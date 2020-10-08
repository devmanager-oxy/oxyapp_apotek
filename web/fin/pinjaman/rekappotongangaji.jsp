 
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
public Coa getCoa(long oid){
	Coa cx = new Coa();
	try{
		return cx = DbCoa.fetchExc(oid);
	}
	catch(Exception e){
	}
	return new Coa();
}

%>

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
long dinasId = 0;
long unitId = JSPRequestValue.requestLong(request, "hidden_unit_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdRekapMain ctrlRekapMain = new CmdRekapMain(request);
JSPLine ctrLine = new JSPLine();
Vector listRekapMain = new Vector(1,1);

Vector temp = DbDinasUnit.list(0,0,"", "dinas_id, nama");
if(unitId==0 && temp!=null && temp.size()>0){
	DinasUnit du = (DinasUnit)temp.get(0);
	unitId =  du.getOID();
}

try{
	DinasUnit du = DbDinasUnit.fetchExc(unitId);
	dinasId = du.getDinasId();
}
catch(Exception e){
}

PeriodeRekap prekap = new PeriodeRekap();
Vector periodRekaps = DbPeriodeRekap.list(0,0, "", "start_date desc");
if(periodId==0){
	if(periodRekaps!=null && periodRekaps.size()>0){
		for(int i=0; i<periodRekaps.size(); i++){
			prekap = (PeriodeRekap)periodRekaps.get(i);
			Date dt = new Date();
			if(dt.after(prekap.getStartDate())){
				periodId = prekap.getOID();
				break;
			}
		}
	}
}else{
	try{
		prekap = DbPeriodeRekap.fetchExc(periodId);
	}
	catch(Exception e){
	}
}



//rekap main ----------

RekapMain rekapMain = new RekapMain();
Vector vrm = DbRekapMain.list(0,0, "periode_rekap_id="+periodId+" and dinas_id="+dinasId+" and dinas_unit_id="+unitId, "");
if(vrm!=null && vrm.size()>0){
	rekapMain= (RekapMain)vrm.get(0);
	oidRekapMain = rekapMain.getOID();
}
else{
	oidRekapMain = 0;	
}

//---------------------

Vector members = DbMember.list(0,0, "status='1' and dinas_id="+dinasId+" and dinas_unit_id="+unitId+" and status_pegawai="+DbMember.STATUS_PEGAWAI_AKTIF, "no_member");

if((iJSPCommand==JSPCommand.SAVE || iJSPCommand==JSPCommand.POST) && periodId!=0){

	//proses rekap main---------------
	
	JspRekapMain jrm = new JspRekapMain(request, rekapMain);
	if(oidRekapMain!=0){
		try{
			rekapMain = DbRekapMain.fetchExc(oidRekapMain);
		}
		catch(Exception e){
		}
	}
	
	jrm.requestEntityObject(rekapMain);
	
	rekapMain.setPeriodeRekapId(periodId);
	rekapMain.setDinasId(dinasId);
	rekapMain.setDinasUnitId(unitId);
	
	try{
		if(oidRekapMain==0){
			rekapMain.setDate(new Date());
			rekapMain.setCounter(DbRekapMain.getNextCounter());
			rekapMain.setPrefixNumber(DbRekapMain.getNumberPrefix());
			rekapMain.setNumber(DbRekapMain.getNextNumber(rekapMain.getCounter()));
			
			oidRekapMain = DbRekapMain.insertExc(rekapMain);
		}
		else{
			oidRekapMain = DbRekapMain.updateExc(rekapMain);
		}
	}
	catch(Exception e){
	}
	
	//------------- end main --------
	
	if(members!=null && members.size()>0){
		for(int i=0; i<members.size(); i++){
		
			Member member = (Member)members.get(i);
						
			double simPokok = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_POKOK]+"_"+member.getOID());
			double simWajib = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_WAJIB]+"_"+member.getOID());
			double simSukarela = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_SUKARELA]+"_"+member.getOID());
			double pjmPokok = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_PINJAMAN_POKOK]+"_"+member.getOID());
			double pjmBunga = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_PINJAMAN_BUNGA]+"_"+member.getOID());
			double minimarket = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MINIMARKET]+"_"+member.getOID());
			double elekPokok = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_ELEKTRONIK_POKOK]+"_"+member.getOID());
			double elekBunga = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_ELEKTRONIK_BUNGA]+"_"+member.getOID());
			double mandiri = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MANDIRI]+"_"+member.getOID());
			double mandiriBunga = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MANDIRI_BUNGA]+"_"+member.getOID());
			double fasjabtel = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_FASJABTEL]+"_"+member.getOID());
			double lainlain = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_LAINLAIN]+"_"+member.getOID());
			double disetujui = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_DISETUJUI]+"_"+member.getOID());
			String ket = JSPRequestValue.requestString(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_NOTE]+"_"+member.getOID());
			int simStatus = JSPRequestValue.requestInt(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_STATUS]+"_"+member.getOID());
			
			RekapPotonganGaji rpg = new RekapPotonganGaji();
			rpg.setRekapMainId(oidRekapMain);//------baru
			rpg.setMemberId(member.getOID());
			rpg.setPeriodeRekapId(periodId);
			rpg.setSimpananPokok(simPokok);
			rpg.setSimpananWajib(simWajib);
			rpg.setSimpananSukarela(simSukarela);
			rpg.setPinjamanPokok(pjmPokok);
			rpg.setPinjamanBunga(pjmBunga);
			rpg.setMinimarket(minimarket);
			rpg.setElektronikPokok(elekPokok);
			rpg.setElektronikBunga(elekBunga);
			rpg.setMandiri(mandiri);
			rpg.setMandiriBunga(mandiriBunga);
			rpg.setFasjabtel(fasjabtel);
			rpg.setLainlain(lainlain);
			rpg.setDisetujui(disetujui);
			rpg.setNote(ket);
			rpg.setStatus(simStatus);

			try{			
				Vector x = DbRekapPotonganGaji.list(0,0, "rekap_main_id="+oidRekapMain+" and member_id="+rpg.getMemberId()+" and periode_rekap_id="+rpg.getPeriodeRekapId(), "");
				if(x!=null && x.size()>0){
					RekapPotonganGaji rpgx = (RekapPotonganGaji)x.get(0);
					rpg.setOID(rpgx.getOID());
					DbRekapPotonganGaji.updateExc(rpg);
				}
				else{
					DbRekapPotonganGaji.insertExc(rpg);
				}
			}
			catch(Exception e){
			}
			
		}
	}
	
	//posting payment dan jurnal
	if(iJSPCommand==JSPCommand.POST){
		try{
			DbRekapMain.postJournal(rekapMain);
			rekapMain.setStatus(DbRekapMain.DOCUMENT_STATUS_POSTED);
			DbRekapMain.updateExc(rekapMain);
		}
		catch(Exception e){
		}
		
	}
	
}

iJSPCommand = JSPCommand.NONE;
//out.println("oidRekapMain :"+oidRekapMain);
RptPotonganGaji rptKonstan = new RptPotonganGaji();
Vector vTemp = new Vector();

%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sipadu - Finance</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />


<script language="JavaScript">

function cmdPrintXLS(){	 
	window.open("<%=printroot%>.report.RptPotonganGaji2XLS?idx=<%=System.currentTimeMillis()%>");
}


<%if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_POSTED){%>
	window.location="rekappotongangaji_view.jsp?hidden_periode_id=<%=rekapMain.getPeriodeRekapId()%>&hidden_dinas_id=<%=rekapMain.getDinasId()%>&hidden_unit_id=<%=rekapMain.getDinasUnitId()%>&menu_idx=<%=menuIdx%>";
<%}%>

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
	
	<%
	if(members!=null && members.size()>0){
		for(int i=0; i<members.size(); i++){
			Member mx = (Member)members.get(i);
			%>
			if(oid=='<%=mx.getOID()%>'){
				var total = document.frmrekappotongangaji.total_<%=mx.getOID()%>.value;
				total = removeChar(total);
				total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				//alert(total);
				
				var newVal = obj.value;
				newVal = removeChar(newVal);
				newVal = cleanNumberFloat(newVal, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				document.frmrekappotongangaji.total_<%=mx.getOID()%>.value = formatFloat(""+(parseFloat(total)-parseFloat(x)+parseFloat(newVal)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace0); 
				obj.value = formatFloat(""+parseFloat(newVal), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace0); 
				
			}
			<%
		}
	}
	%>
	
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
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdPost(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.POST%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdAdd(){
	document.frmrekappotongangaji.hidden_rekap_main_id.value="0";
	document.frmrekappotongangaji.command.value="<%=JSPCommand.ADD%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdAsk(oidRekapMain){
	document.frmrekappotongangaji.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekappotongangaji.command.value="<%=JSPCommand.ASK%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdConfirmDelete(oidRekapMain){
	document.frmrekappotongangaji.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekappotongangaji.command.value="<%=JSPCommand.DELETE%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdSave(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.SAVE%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdEdit(oidRekapMain){
	document.frmrekappotongangaji.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekappotongangaji.command.value="<%=JSPCommand.EDIT%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdCancel(oidRekapMain){
	document.frmrekappotongangaji.hidden_rekap_main_id.value=oidRekapMain;
	document.frmrekappotongangaji.command.value="<%=JSPCommand.EDIT%>";
	document.frmrekappotongangaji.prev_command.value="<%=prevJSPCommand%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdBack(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.BACK%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdListFirst(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.FIRST%>";
	document.frmrekappotongangaji.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdListPrev(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.PREV%>";
	document.frmrekappotongangaji.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdListNext(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.NEXT%>";
	document.frmrekappotongangaji.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

function cmdListLast(){
	document.frmrekappotongangaji.command.value="<%=JSPCommand.LAST%>";
	document.frmrekappotongangaji.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmrekappotongangaji.action="rekappotongangaji.jsp";
	document.frmrekappotongangaji.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidRekapMain){
	document.frmimage.hidden_rekap_main_id.value=oidRekapMain;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="rekappotongangaji.jsp";
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
						  <input type="hidden" name="<%=JspRekapMain.colNames[JspRekapMain.JSP_USER_ID]%>" value="<%=(rekapMain.getUserId()==0) ? user.getOID() : rekapMain.getUserId()%>">
						  <input type="hidden" name="val_temp" value="">
                          <table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                <td width="8%">Tanggal Rekap</td>
                                                <td width="58%"> 
                                                  <input type="text" name="textfield2" value="<%=(rekapMain.getDate()!=null) ? JSPFormater.formatDate(rekapMain.getDate(), "dd MMMM yyyy") : JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>" readonly>
                                                  <%rptKonstan.setTanggal((rekapMain.getDate()!=null) ? rekapMain.getDate() : new Date());%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="5%">Periode</td>
                                                <td width="29%"> 
                                                  <%
												  
												  Date curDatex = new Date();
												  
												  
												  %>
                                                  <select name="hidden_periode_id" onChange="javascript:cmdChange()">
                                                    <%if(periodRekaps!=null && periodRekaps.size()>0){
														for(int i=0; i<periodRekaps.size(); i++){
															PeriodeRekap pr = (PeriodeRekap)periodRekaps.get(i);
															if(pr.getOID()==periodId){
																rptKonstan.setPeriode(pr.getName());
															}
															if(curDatex.after(pr.getStartDate())){
													%>
                                                    <option value="<%=pr.getOID()%>" <%if(pr.getOID()==periodId){%>selected<%}%>><%=pr.getName()%></option>
                                                    <%}}}%>
                                                  </select>
                                                </td>
                                                <td width="8%">Nomor</td>
                                                <td width="58%"> 
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
													
													if(members!=null && members.size()>0){
													
														for(int i=0; i<members.size(); i++){
														
														Member member = (Member)members.get(i);
														double simPokok = 0;
														if(member.getSimpananPokok()==0){
															simPokok = Double.parseDouble(DbSystemProperty.getValueByName("SIMPANAN_POKOK"));
														}
														double simWajib = Double.parseDouble(DbSystemProperty.getValueByName("SIMPANAN_WAJIB"));
														
														RekapPotonganGaji rpg = DbRekapPotonganGaji.getRekap(periodId, member.getOID());
														docStatus = rpg.getStatusDocument();
														
														//---------report ---------
														RptPotonganGajiL detail = new RptPotonganGajiL();
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
															//detail.setJmlhPotongan(total);
															detail.setKeterangan(rpg.getNote());
															
															vTemp.add(detail);
														//-------------------------
														
																												
														if(rpg.getStatus()==DbRekapPotonganGaji.STATUS_DRAFT){
															PinjamanDetail pd = DbPinjaman.getTotalTagihanPinjaman(member.getOID(), prekap.getStartDate(), DbPinjaman.JENIS_BARANG_CASH);
															rpg.setPinjamanPokok(pd.getAmount());
															rpg.setPinjamanBunga(pd.getBunga());
															
															PinjamanDetail pdx = DbPinjaman.getTotalTagihanPinjaman(member.getOID(), prekap.getStartDate(), DbPinjaman.JENIS_BARANG_ELEKTRONIK);
															rpg.setElektronikPokok(pdx.getAmount());
															rpg.setElektronikBunga(pdx.getBunga());
															
															PinjamanDetail pdy = DbPinjaman.getTotalTagihanBank(member.getOID(), prekap.getStartDate());
															rpg.setMandiri(pdy.getAmount());
															rpg.setMandiriBunga(pdy.getBunga());
															
														}
														
														double total = simPokok + simWajib + rpg.getSimpananSukarela() + rpg.getPinjamanPokok() + rpg.getPinjamanBunga()+
															rpg.getMinimarket() + rpg.getElektronikPokok() + rpg.getElektronikBunga() + rpg.getMandiri() + rpg.getMandiriBunga() +
															rpg.getLainlain() + rpg.getFasjabtel();
														
														if(i%2==0){
													%>
                                              <tr> 
                                                <td width="14%" class="tablecell" nowrap><%=i+1%></td>
                                                <td width="14%" class="tablecell" nowrap><%=member.getNama()%></td>
                                                <td width="13%" class="tablecell"><%=member.getNoMember()%></td>
                                                <td width="13%" class="tablecell"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_POKOK]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(simPokok, "#,###")%>" size="10" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="13%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_WAJIB]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(simWajib, "#,###")%>" size="10" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="11%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_SUKARELA]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(rpg.getSimpananSukarela(), "#,###")%>" size="10" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_PINJAMAN_POKOK]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getPinjamanPokok(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="9%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_PINJAMAN_BUNGA]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getPinjamanBunga(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="12%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MINIMARKET]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getMinimarket(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_ELEKTRONIK_POKOK]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getElektronikPokok(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_ELEKTRONIK_BUNGA]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getElektronikBunga(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MANDIRI]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getMandiri(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MANDIRI_BUNGA]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getMandiriBunga(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_FASJABTEL]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getFasjabtel(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_LAINLAIN]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getLainlain(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <input type="text" name="total_<%=member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(total, "#,###")%>" readonly style="text-align:right">
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_DISETUJUI]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getDisetujui(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)">
                                                </td>
                                                <td width="14%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_NOTE]+"_"+member.getOID()%>" size="20" value="<%=(rpg.getNote()==null) ? "" : rpg.getNote()%>">
                                                  </div>
                                                </td>
                                                <td width="7%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <select name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_STATUS]+"_"+member.getOID()%>">
                                                      <%for(int x=0; x<DbRekapPotonganGaji.strStatus.length; x++){
													  
													  if(rekapMain.getOID()==0){
													  %>
                                                      <option value="<%=x%>" <%if(x==rpg.getStatus()){%>selected<%}%>><%=DbRekapPotonganGaji.strStatus[x]%></option>
                                                      <%}else{
													  	if(x!=0){%>
                                                      <option value="<%=x%>" <%if(x==rpg.getStatus()){%>selected<%}%>><%=DbRekapPotonganGaji.strStatus[x]%></option>
                                                      <%}
													  }}%>
                                                    </select>
                                                  </div>
                                                </td>
                                              </tr>
                                              <%}else{%>
                                              <tr> 
                                                <td width="14%" class="tablecell1" nowrap><%=i+1%></td>
                                                <td width="14%" class="tablecell1" nowrap><%=member.getNama()%></td>
                                                <td width="13%" class="tablecell1"><%=member.getNoMember()%></td>
                                                <td width="13%" class="tablecell1"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_POKOK]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(simPokok, "#,###")%>" size="10" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="13%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_WAJIB]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(simWajib, "#,###")%>" size="10" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="11%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SIMPANAN_SUKARELA]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(rpg.getSimpananSukarela(), "#,###")%>" size="10" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_PINJAMAN_POKOK]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getPinjamanPokok(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="9%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_PINJAMAN_BUNGA]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getPinjamanBunga(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="12%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MINIMARKET]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getMinimarket(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_ELEKTRONIK_POKOK]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getElektronikPokok(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                  </div>
                                                </td>
                                                <td width="10%" class="tablecell1"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_ELEKTRONIK_BUNGA]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getElektronikBunga(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MANDIRI]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getMandiri(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_MANDIRI_BUNGA]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getMandiriBunga(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_FASJABTEL]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getFasjabtel(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_LAINLAIN]+"_"+member.getOID()%>" size="10" value="<%=JSPFormater.formatNumber(rpg.getLainlain(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)" onBlur="javascript:cmdBlurMe(this, '<%=member.getOID()%>')">
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <input type="text" name="total_<%=member.getOID()%>" size="15"  value="<%=JSPFormater.formatNumber(total, "#,###")%>" readonly style="text-align:right">
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_DISETUJUI]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getDisetujui(), "#,###")%>" style="text-align:right" onClick="javascript:cmdClickMe(this)">
                                                </td>
                                                <td width="14%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_NOTE]+"_"+member.getOID()%>" size="20" value="<%=(rpg.getNote()==null) ? "" : rpg.getNote()%>">
                                                  </div>
                                                </td>
                                                <td width="7%" class="tablecell1"> 
                                                  <div align="center"> 
                                                    <select name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_STATUS]+"_"+member.getOID()%>">
                                                      <%for(int x=0; x<DbRekapPotonganGaji.strStatus.length; x++){
													  
													  if(rekapMain.getOID()==0){
													  %>
                                                      <option value="<%=x%>" <%if(x==rpg.getStatus()){%>selected<%}%>><%=DbRekapPotonganGaji.strStatus[x]%></option>
                                                      <%}else{
													  	if(x!=0){%>
                                                      <option value="<%=x%>" <%if(x==rpg.getStatus()){%>selected<%}%>><%=DbRekapPotonganGaji.strStatus[x]%></option>
                                                      <%}
													  }}%>
                                                    </select>
                                                  </div>
                                                </td>
                                              </tr>
                                              <%}}}%>
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
                                                <td colspan="3"><b>Document Status 
                                                  </b></td>
                                                <td width="13%"><b>: <%=DbRekapMain.docStatus[docStatus]%></b></td>
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
                                                            <td width="5%"> 
                                                              <%if(rekapMain.getStatus()!=DbRekapMain.DOCUMENT_STATUS_POSTED){%>
                                                              <a href="javascript:cmdSave()"><img src="../images/success.gif" width="20" height="20" border="0"></a> 
                                                              <%}else{%>
                                                              &nbsp; 
                                                              <%}%>
                                                            </td>
                                                            <td width="19%"> 
                                                              <%if(rekapMain.getStatus()!=DbRekapMain.DOCUMENT_STATUS_POSTED){%>
                                                              <a href="javascript:cmdSave()">Save</a> 
                                                              <%}else{%>
                                                              &nbsp; 
                                                              <%}%>
                                                            </td>
                                                            <td width="6%"> 
                                                              <%if(rekapMain.getOID()!=0 && rekapMain.getStatus()!=DbRekapMain.DOCUMENT_STATUS_POSTED){%>
                                                              <a href="javascript:cmdPost()"><img src="../images/yesx.gif" width="17" height="14" border="0"></a> 
                                                              <%}else{%>
                                                              &nbsp; 
                                                              <%}%>
                                                            </td>
                                                            <td width="25%"> 
                                                              <%if(rekapMain.getOID()!=0 && rekapMain.getStatus()!=DbRekapMain.DOCUMENT_STATUS_POSTED){%>
                                                              <a href="javascript:cmdPost()">Posting 
                                                              Jurnal</a> 
                                                              <%}else{%>
                                                              &nbsp; 
                                                              <%}%>
                                                            </td>
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
                                                            <td width="26%" height="21" bgcolor="#EEEEEE"> 
                                                              <div align="center"><b>Jurnal 
                                                                Detail</b></div>
                                                            </td>
                                                            <td width="74%" height="21">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" height="21" bgcolor="#E1E1E1"><b>Keterangan</b></td>
                                                            <td width="74%" height="21" bgcolor="#E1E1E1"><b>Debet</b></td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Simpanan 
                                                              Diterima Pada</td>
                                                            <td width="74%" nowrap bgcolor="#E1E1E1"> 
                                                              <%
															//Vector temp = new Vector();
															if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){																
																temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_DEBET+"'", "");											
																if(temp!=null && temp.size()>0){																	
																	%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																				AccLink al = (AccLink)temp.get(i);
																				Coa cx = getCoa(al.getCoaId());
																		  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getSimpananCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}
															}else{
																Coa cx = getCoa(rekapMain.getSimpananCoaDebetId());																
																out.println(cx.getCode()+" - "+cx.getName());
															}
															%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Angsuran 
                                                              Pokok Diterima Pada 
                                                            </td>
                                                            <td width="74%" nowrap bgcolor="#E1E1E1"> 
                                                              <%
											//Vector temp = new Vector();
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
												
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_ANGSURAN_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getAngsuranCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getAngsuranCoaDebetId());
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" nowrap bgcolor="#E1E1E1">Pendapatan 
                                                              Bunga Diterima Pada 
                                                            </td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_BUNGA_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getBungaCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getBungaCoaDebetId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}
												%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Minimarket 
                                                              Diterima Pada</td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%	
										  if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
										  
											temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_MINIMARKET_DEBET+"'", "");											
											if(temp!=null && temp.size()>0){
												
												%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_MINIMARKET_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
													  		AccLink al = (AccLink)temp.get(i);
															Coa cx = getCoa(al.getCoaId());															
													  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getMinimarketCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              
                                                              <%}
											
										}else{
												Coa cx = getCoa(rekapMain.getMinimarketCoaDebetId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Fasjabtel 
                                                              Diterima Pada</td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											//Vector temp = new Vector();
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
												
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_FASJABTEL_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){
													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_FASJABTEL_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());															
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getFasjabtelCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getFasjabtelCoaDebetId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Titipan 
                                                              Diterima Pada</td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											//Vector temp = new Vector();
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
												
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_TITIPAN_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_TITIPAN_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getTitipanCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getTitipanCoaDebetId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">&nbsp;</td>
                                                            <td width="74%" bgcolor="#E1E1E1"><b>Kredit</b></td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Simpanan 
                                                              Wajib </td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getSimpananCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getSimpananCoaCreditId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Simpanan 
                                                              Pokok </td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_POKOK_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_POKOK_COA_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());
																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getSimpananPokokCoaId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getSimpananPokokCoaId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Simpanan 
                                                              Sukarela </td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_SUKARELA_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_SIMPANAN_SUKARELA_COA_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getSimpananSukarelaCoaId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getSimpananSukarelaCoaId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Pengurangan 
                                                              Pihutang (AR)</td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_DEBET+"'", "");											
												if(temp!=null && temp.size()>0){													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_ANGSURAN_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getAngsuranCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getAngsuranCoaCreditId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Pendapatan 
                                                              Bunga </td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_BUNGA_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_BUNGA_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getBungaCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getBungaCoaCreditId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Pendapatan 
                                                              Mnimarket</td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_MINIMARKET_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_MINIMARKET_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getMinimarketCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>                                                              
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getMinimarketCoaCreditId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Fasjabtel</td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_FASJABTEL_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_FASJABTEL_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getFasjabtelCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>                                                              
                                                              <%}
											}else{
												Coa cx =getCoa(rekapMain.getFasjabtelCoaCreditId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%" bgcolor="#E1E1E1">Titipan 
                                                              (AP)</td>
                                                            <td width="74%" bgcolor="#E1E1E1"> 
                                                              <%
											if(rekapMain.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_TITIPAN_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){													
													%>
                                                              <select name="<%=JspRekapMain.colNames[JspRekapMain.JSP_TITIPAN_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = getCoa(al.getCoaId());																
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(rekapMain.getTitipanCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>                                                             
                                                              <%}
											}else{
												Coa cx = getCoa(rekapMain.getTitipanCoaCreditId());												
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%">&nbsp;</td>
                                                            <td width="74%">&nbsp;</td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="26%">&nbsp;</td>
                                                            <td width="74%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
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
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
  </tr>
</table>
						<%
							session.putValue("KONSTAN", rptKonstan);
							session.putValue("DETAIL", vTemp);
						%>
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
