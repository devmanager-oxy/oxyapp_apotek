 
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
<%@ include file = "../main/checkmm.jsp" %>
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
	if(session.getValue("KONSTAN")!=null){
		session.removeValue("KONSTAN");
	}
	
	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPinjaman = JSPRequestValue.requestLong(request, "hidden_pinjaman_id");
long oidPinjamanDetail = JSPRequestValue.requestLong(request, "hidden_pinjaman_detail_id");

if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
}


/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPinjaman ctrlPinjaman = new CmdPinjaman(request);
JSPLine ctrLine = new JSPLine();
Vector listPinjaman = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPinjaman.action(iJSPCommand , oidPinjaman);

/* end switch*/
JspPinjaman jspPinjaman = ctrlPinjaman.getForm();

/*count list All Pinjaman*/
int vectSize = DbPinjaman.getCount(whereClause);

Pinjaman pinjaman = ctrlPinjaman.getPinjaman();

RptPinjamanAnggota rptKonstan = new RptPinjamanAnggota();
Vector vTemp = new Vector();

if(oidPinjaman==0){
	oidPinjaman = pinjaman.getOID();
}

if(iJSPCommand==JSPCommand.SAVE && pinjaman.getStatus()==DbPinjaman.STATUS_DRAFT){
	DbPinjamanDetail.setupDetailPinjaman(pinjaman);
}

if(iJSPCommand==JSPCommand.POST){
	String strDate = JSPRequestValue.requestString(request, "jatuh_tempo");
	DbPinjamanDetail.updateJatuhTempo(oidPinjaman, strDate);
}


msgString =  ctrlPinjaman.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlPinjaman.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listPinjaman = DbPinjaman.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listPinjaman.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listPinjaman = DbPinjaman.list(start,recordToGet, whereClause , orderClause);
}

Vector pds = DbPinjamanDetail.list(0,0,"pinjaman_id="+pinjaman.getOID(), "cicilan_ke");
//out.println("pds : "+pds);

//posting jurnal pengakuan pihutang
if(iJSPCommand==JSPCommand.SAVE && pinjaman.getStatus()==DbPinjaman.STATUS_APPROVE){
	try{
		DbPinjaman.postJournal(pinjaman);
	}
	catch(Exception e){
		System.out.println(e.toString());
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

function cmdUpdateTanggal(oid){
	document.frmpinjaman.hidden_pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oid;
	document.frmpinjaman.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdUpdateJT(){
	document.frmpinjaman.hidden_pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.command.value="<%=JSPCommand.POST%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}



function cmdBayar(oidpd){
	document.frmpinjaman.hidden_bayar_type.value="0";
	document.frmpinjaman.hidden_pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oidpd;
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="bayarpinjaman.jsp";
	document.frmpinjaman.submit();
}


function cmdBayarDetail(oidpd){
	document.frmpinjaman.hidden_bayar_type.value="0";
	document.frmpinjaman.hidden_pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oidpd;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="bayarpinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdPelunasanDetail(oidpd){
	document.frmpinjaman.hidden_bayar_type.value="0";
	document.frmpinjaman.hidden_pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oidpd;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pelunasan.jsp";
	document.frmpinjaman.submit();
}

function cmdPelunasan(oidp){
	document.frmpinjaman.hidden_bayar_type.value="1";
	document.frmpinjaman.hidden_pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oidp;
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pelunasan.jsp";
	document.frmpinjaman.submit();
}

function cmdAdd(){
	document.frmpinjaman.hidden_pinjaman_id.value="0";
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdAsk(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.ASK%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdConfirmDelete(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
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
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjaman.jsp";
	document.frmpinjaman.submit();
	}

function cmdCancel(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
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
            <%@ include file="../main/hmenumm.jsp"%>
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
                  <%@ include file="../main/menumm.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Simpan 
                        Pinjam</span> &raquo; <span class="level2">Pinjaman Koperasi 
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
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_pinjaman_id" value="<%=oidPinjaman%>">
                          <input type="hidden" name="hidden_pinjaman_detail_id" value="">
                          <input type="hidden" name="hidden_bayar_type" value="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_USER_ID] %>"  value="<%//= (pinjaman.getUserId()==0) ? user.getOID() :  pinjaman.getUserId()%>">
                          <input type="hidden" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_APPROVE_BY_ID] %>"  value="<%//= (pinjaman.getApproveById()==0) ? user.getOID() :  pinjaman.getApproveById()%>">
                          <input type="hidden" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_TYPE] %>"  value="<%= DbPinjaman.TYPE_PINJAMAN_KOPERASI %>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="21" width="13%"><b>Anggota</b></td>
                                    <td height="21" width="27%"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="65%"> 
                                            <input type="hidden" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_MEMBER_ID] %>"  value="<%= pinjaman.getMemberId() %>" class="formElemen" size="30">
                                            <%
											Member m = new Member();
											String str = "";
											if(pinjaman.getMemberId()!=0){
												try{
													m = DbMember.fetchExc(pinjaman.getMemberId());
												}
												catch(Exception e){
												}
												str = m.getNoMember()+"/"+m.getNama();
												
												rptKonstan.setNik( m.getNoMember());
												rptKonstan.setPeminjam(m.getNama());
											}
											
											%>
                                            <%=str%> <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_MEMBER_ID) %> </td>
                                          <td width="3%"><img src="../images/spacer.gif" width="8" height="8"></td>
                                          <td width="32%" nowrap><img src="../images/spacer.gif" width="20" height="8"></td>
                                        </tr>
                                      </table>
                                    <td height="21" width="18%"><b>Nomor Rekening 
                                      Pinjaman </b> 
                                    <td height="21" width="42%"> 
                                      <%
									  int cnt = DbPinjaman.getNextCounter(pinjaman.getType());
									  String prefix = DbPinjaman.getNumberPrefix(pinjaman.getType());
									  String number = DbPinjaman.getNextNumber(cnt, pinjaman.getType());
									  if(pinjaman.getOID()==0){
									  		pinjaman.setNumber(number);	
									  }
									  %>
                                      <%= pinjaman.getNumber() %> 
                                      <%rptKonstan.setNoRekening(pinjaman.getNumber());%>
                                  <tr align="left"> 
                                    <td height="21" width="13%"><b>Tanggal</b></td>
                                    <td height="21" width="27%"> <%=JSPFormater.formatDate((pinjaman.getDate()==null) ? new Date() : pinjaman.getDate(), "dd/MM/yyyy")%> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpinjaman.<%=jspPinjaman.colNames[JspPinjaman.JSP_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                      <%rptKonstan.setTanggal(pinjaman.getDate());%>
                                    <td height="21" width="18%"><b>Bunga Pinjaman 
                                      </b> 
                                    <td height="21" width="42%"> <%= pinjaman.getBunga() %> % /bulan * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_BUNGA) %> 
                                      <%rptKonstan.setBungaPinjaman(pinjaman.getBunga());%>
                                  <tr align="left"> 
                                    <td height="21" width="13%"><b>Total Pinjaman</b></td>
                                    <td height="21" width="27%"> <%= JSPFormater.formatNumber(pinjaman.getTotalPinjaman(),"#,###.##") %> * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_TOTAL_PINJAMAN) %> 
                                      <%rptKonstan.setTotalPinjaman(pinjaman.getTotalPinjaman());%>
                                    <td height="21" width="18%"><b>Lama Angsuran 
                                      </b> 
                                    <td height="21" width="42%"> <%= pinjaman.getLamaCicilan() %> bulan * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_LAMA_CICILAN) %> 
                                      <%rptKonstan.setLamaAngsuran(pinjaman.getLamaCicilan());%>
                                  <tr align="left"> 
                                    <td height="21" width="13%"><b>Biaya Administrasi</b></td>
                                    <td height="21" width="27%"> <%= JSPFormater.formatNumber(pinjaman.getBiayaAdministrasi(),"#,###.##") %> 
                                    <td height="21" width="18%" nowrap><b>Jatuh 
                                      Tempo Setiap Tanggal </b> 
                                    <td height="21" width="42%"> <%= pinjaman.getTanggalJatuhTempo() %> * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_TANGGAL_JATUH_TEMPO) %> 
                                      <%if(pinjaman.getOID()!=0){%>
                                      <%}%>
                                      <%if(pds!=null && pds.size()>0){%>
                                      <%}%>
                                  <tr align="left"> 
                                    <td height="21" width="13%"><b>Jenis Pinjaman</b></td>
                                    <td height="21" width="27%"><%=DbPinjaman.strJenisBarang[pinjaman.getJenisBarang()]%> 
                                    <td height="21" width="18%">&nbsp; 
                                    <td height="21" width="42%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" width="13%"><b>Keterangan</b></td>
                                    <td height="21" colspan="3"> <%=(pinjaman.getDetailJenisBarang().length()>0) ? pinjaman.getDetailJenisBarang() : "-"%> 
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="13%">&nbsp;</td>
                                    <td height="21" width="27%" valign="top">&nbsp;</td>
                                    <td height="21" width="18%" valign="top">&nbsp;</td>
                                    <td height="21" width="42%" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" width="13%"><b>Status Pinjaman 
                                      </b> </td>
                                    <td height="21" width="27%"> 
                                      <table width="40%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td height="25" bgcolor="#FFFF00"> 
                                            <div align="center"><b><font color="#003399"><%=DbPinjaman.strStatus[pinjaman.getStatus()]%></font></b></div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td height="21" width="18%">&nbsp;</td>
                                    <td height="21" width="42%">&nbsp;</td>
                                  </tr>
                                  <%if(pinjaman.getOID()!=0){%>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="13%">&nbsp;</td>
                                    <td height="21" width="27%" valign="top">&nbsp;</td>
                                    <td height="21" width="18%" valign="top">&nbsp;</td>
                                    <td height="21" width="42%" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" colspan="4"> 
                                      <table width="32%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="33%" class="tablecell1"><b><u>Document 
                                            History</u></b></td>
                                          <td width="34%" class="tablecell1"> 
                                            <div align="center"><b><u>User</u></b></div>
                                          </td>
                                          <td width="33%" class="tablecell1"> 
                                            <div align="center"><b><u>Tanggal</u></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="33%" class="tablecell1"><i>Dibuat 
                                            oleh</i></td>
                                          <td width="34%" class="tablecell1"> 
                                            <div align="center"> <i> 
                                              <%
												User u = new User();
												try{
													u = DbUser.fetch(pinjaman.getUserId());
												}
												catch(Exception e){
												}
												%>
                                              <%=u.getLoginId()%></i></div>
                                          </td>
                                          <td width="33%" class="tablecell1"> 
                                            <div align="center"><i><%=JSPFormater.formatDate(pinjaman.getDate(), "dd MMMM yy")%></i></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="33%" class="tablecell1"><i> 
                                            <%
										  if(
										  pinjaman.getStatus()==DbPinjaman.STATUS_APPROVE || 
										  pinjaman.getStatus()==DbPinjaman.STATUS_LUNAS ||
										  pinjaman.getStatus()==DbPinjaman.STATUS_DRAFT
										  ){%>
                                            Disetujui 
                                            <%}else if(pinjaman.getStatus()==DbPinjaman.STATUS_DITOLAK){%>
                                            Ditolak 
                                            <%}%>
                                            oleh</i></td>
                                          <td width="34%" class="tablecell1"> 
                                            <div align="center"> <i> 
                                              <%
												 u = new User();
												try{
													u = DbUser.fetch(pinjaman.getApproveById());
												}
												catch(Exception e){
												}
												%>
                                              <%=u.getLoginId()%></i></div>
                                          </td>
                                          <td width="33%" class="tablecell1"> 
                                            <div align="center"> <i> 
                                              <%if(pinjaman.getApproveById()!=0){%>
                                              <%=JSPFormater.formatDate(pinjaman.getApproveDate(), "dd MMMM yy")%> 
                                              <%}%>
                                              </i></div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="13%">&nbsp;</td>
                                    <td height="21" width="27%" valign="top">&nbsp;</td>
                                    <td height="21" width="18%" valign="top">&nbsp;</td>
                                    <td height="21" width="42%" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" class="command" valign="top"> 
                                      <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("60%");
									String scomDel = "javascript:cmdAsk('"+oidPinjaman+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidPinjaman+"')";
									String scancel = "javascript:cmdEdit('"+oidPinjaman+"')";
									ctrLine.setBackCaption("Ke List Pinjaman");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Hapus");
										ctrLine.setSaveCaption("Simpan");
										ctrLine.setConfirmDelCaption("Ya Hapus");
										ctrLine.setAddCaption("");

									if (privDelete){
										ctrLine.setConfirmDelJSPCommand(sconDelCom);
										ctrLine.setDeleteJSPCommand(scomDel);
										ctrLine.setEditJSPCommand(scancel);
									}else{ 
										ctrLine.setConfirmDelCaption("");
										ctrLine.setDeleteCaption("");
										ctrLine.setEditCaption("");
									}

									if(privAdd == false  && privUpdate == false){
										ctrLine.setSaveCaption("");
									}

									if (privAdd == false){
										ctrLine.setAddCaption("");
									}
									
									if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
										ctrLine.setDeleteCaption("");
										ctrLine.setSaveCaption("");
									}
									
									if(iJSPCommand==JSPCommand.POST){
										iJSPCommand = JSPCommand.EDIT;
									}
									
									%>
                                      <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                  </tr>
                                  <tr> 
                                    <td width="13%">&nbsp;</td>
                                    <td width="27%">&nbsp;</td>
                                    <td width="18%">&nbsp;</td>
                                    <td width="42%">&nbsp;</td>
                                  </tr>
                                  <%if(pds!=null && pds.size()>0){%>
                                  <tr align="left" > 
                                    <td colspan="4" height="23" valign="middle"> 
                                      <table width="90%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablecell1" height="20" >&nbsp;<b>Ilustrasi 
                                            Angsuran</b> </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" valign="top"> 
                                      <div align="left"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                          <tr> 
                                            <td class="tablehdr" width="6%" nowrap>Angsuran 
                                            </td>
                                            <td class="tablehdr" width="8%" nowrap>Pokok 
                                              Angsuran</td>
                                            <td class="tablehdr" width="9%" nowrap>Bunga</td>
                                            <td class="tablehdr" width="11%" nowrap>Saldo</td>
                                            <td class="tablehdr" width="11%" nowrap>Total 
                                              Angsuran</td>
                                            <td class="tablehdr" width="11%" nowrap>Jatuh 
                                              Tempo</td>
                                            <td class="tablehdr" width="11%" nowrap>Tanggal 
                                              Angsuran </td>
                                            <td class="tablehdr" width="9%">Pokok 
                                              Angsuran </td>
                                            <td class="tablehdr" width="8%">Bunga 
                                              Angsuran </td>
                                            <td class="tablehdr" width="6%">Angsuran</td>
                                            <td  class="tablehdr" width="10%">Pelunasan</td>
                                          </tr>
                                          <tr> 
                                            <td class="tablecell" width="6%">&nbsp;</td>
                                            <td class="tablecell" width="8%">&nbsp;</td>
                                            <td class="tablecell" width="9%">&nbsp;</td>
                                            <td class="tablecell" width="11%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pinjaman.getTotalPinjaman(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell" width="11%">&nbsp;</td>
                                            <td class="tablecell" width="11%">&nbsp;</td>
                                            <td class="tablecell" width="11%">&nbsp;</td>
                                            <td width="9%" class="tablecell">&nbsp;</td>
                                            <td width="8%" class="tablecell">&nbsp;</td>
                                            <td width="6%" class="tablecell">&nbsp;</td>
                                            <td width="10%" class="tablecell">&nbsp;</td>
                                          </tr>
                                          <%
										  
										  boolean nextPayment = false;
										  long prevPaidDetail = 0;
										  
										  for(int i=0; i<pds.size(); i++){
										  		PinjamanDetail pd = (PinjamanDetail)pds.get(i);
												
												RptPinjamanAnggotaL detail = new RptPinjamanAnggotaL();
												
												Vector bayars = DbBayarPinjaman.list(0,0, "pinjaman_detail_id="+pd.getOID(), "");
												BayarPinjaman bp = new BayarPinjaman();
												if(bayars!=null && bayars.size()>0){
													bp = (BayarPinjaman)bayars.get(0);
												}
												
												//pertama
												if(i==0 && bp.getOID()==0){
													nextPayment = true;
												}
												//kedua dst
												else{
													if(prevPaidDetail!=0 && bp.getOID()==0){
														nextPayment = true;
													}
												}
												
												prevPaidDetail = bp.getOID();
												
												detail.setAngsuran(pd.getCicilanKe());
												detail.setAngPokok(pd.getAmount());
												detail.setBunga(pd.getBunga());
												detail.setTotalAngsuran(pd.getAmount()+pd.getBunga());
												detail.setSaldo(pd.getSaldoKoperasi());
												detail.setTglJatuhTempo(pd.getJatuhTempo());
												if(bp.getOID()!=0){
													detail.setTglBayar(JSPFormater.formatDate(bp.getTanggal(), "dd/MM/yyyy"));
													detail.setBayarPinjaman(bp.getAmount()+bp.getBunga()+bp.getDenda());
												}
												
												vTemp.add(detail);
												
												if(i%2==0){
										  %>
                                          <tr> 
                                            <td class="tablecell" width="6%"> 
                                              <div align="center"><%=pd.getCicilanKe()%></div>
                                            </td>
                                            <td class="tablecell" width="8%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell" width="9%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getBunga(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell" width="11%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getSaldoKoperasi(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell" width="11%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount()+pd.getBunga(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell" width="11%"> 
                                              <div align="right"> 
                                                <%if(i==0 && bp.getOID()==0){%>
                                                <a href="javascript:cmdUpdateTanggal('<%=pd.getOID()%>')"><%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd MMMM yyyy")%></a> 
                                                <%}else{%>
                                                <%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd MMMM yyyy")%> 
                                                <%}%>
                                              </div>
                                            </td>
                                            <td class="tablecell" width="11%"> 
                                              <div align="right"><%=(bp.getOID()!=0) ? JSPFormater.formatDate(bp.getTanggal(), "dd MMMM yyyy") : "-"%> </div>
                                            </td>
                                            <td width="9%" class="tablecell"> 
                                              <div align="right"><%=(bp.getAmount()!=0) ? JSPFormater.formatNumber(bp.getAmount(), "#,###.##") : ""%></div>
                                            </td>
                                            <td width="8%" class="tablecell"> 
                                              <div align="right"><%=(bp.getBunga()!=0) ? JSPFormater.formatNumber(bp.getBunga(), "#,###.##") : ""%></div>
                                            </td>
                                            <td width="6%" class="tablecell"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <%	}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_ANGSURAN){														
													%>
                                                <img src="../images/yesx.gif" width="17" height="14"> 
                                                <%	
														}
													}
												}%>
                                              </div>
                                            </td>
                                            <td width="10%" class="tablecell"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <%
														}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_PELUNASAN){
														%>
                                                <img src="../images/yesx.gif" width="17" height="14"> 
                                                <%
														}
													}
												}%>
                                              </div>
                                            </td>
                                          </tr>
                                          <%}else{%>
                                          <tr> 
                                            <td class="tablecell1" width="6%"> 
                                              <div align="center"><%=pd.getCicilanKe()%></div>
                                            </td>
                                            <td class="tablecell1" width="8%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1" width="9%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getBunga(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1" width="11%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getSaldoKoperasi(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1" width="11%"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount()+pd.getBunga(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1" width="11%"> 
                                              <div align="right"> 
                                                <%if(i==0 && bp.getOID()==0){%>
                                                <a href="javascript:cmdUpdateTanggal('<%=pd.getOID()%>')"><%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd MMMM yyyy")%></a> 
                                                <%}else{%>
                                                <%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd MMMM yyyy")%> 
                                                <%}%>
                                              </div>
                                            </td>
                                            <td class="tablecell1" width="11%"> 
                                              <div align="right"><%=(bp.getOID()!=0) ? JSPFormater.formatDate(bp.getTanggal(), "dd MMMM yyyy") : "-"%> </div>
                                            </td>
                                            <td width="9%" class="tablecell1"> 
                                              <div align="right"><%=(bp.getAmount()!=0) ? JSPFormater.formatNumber(bp.getAmount(), "#,###.##") : ""%></div>
                                            </td>
                                            <td width="8%" class="tablecell1"> 
                                              <div align="right"><%=(bp.getBunga()!=0) ? JSPFormater.formatNumber(bp.getBunga(), "#,###.##") : ""%></div>
                                            </td>
                                            <td width="6%" class="tablecell1"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <%	}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_ANGSURAN){														
													%>
                                                <img src="../images/yesx.gif" width="17" height="14"> 
                                                <%	
														}
													}
												}%>
                                              </div>
                                            </td>
                                            <td width="10%" class="tablecell1"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <%
														}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_PELUNASAN){
														%>
                                                <img src="../images/yesx.gif" width="17" height="14"> 
                                                <%
														}
													}
												}%>
                                              </div>
                                            </td>
                                          </tr>
                                          <%}%>
                                          <%if(iJSPCommand==JSPCommand.SUBMIT && pd.getOID()==oidPinjamanDetail){%>
                                          <tr> 
                                            <td class="tablecell" width="6%">&nbsp;</td>
                                            <td class="tablecell" width="8%">&nbsp;</td>
                                            <td class="tablecell" width="9%">&nbsp;</td>
                                            <td class="tablecell" width="11%">&nbsp;</td>
                                            <td class="tablecell" width="11%">Jatuh 
                                              tempo Angsuran I</td>
                                            <td class="tablecell" width="11%" nowrap> 
                                              <div align="center"> 
                                                <input name="jatuh_tempo" value="<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>" size="11" readonly>
                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpinjaman.jatuh_tempo);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                              </div>
                                            </td>
                                            <td class="tablecell" width="11%"> 
                                              <div align="center"></div>
                                            </td>
                                            <td width="9%" class="tablecell">&nbsp;</td>
                                            <td width="8%" class="tablecell">&nbsp;</td>
                                            <td width="6%" class="tablecell">&nbsp;</td>
                                            <td width="10%" class="tablecell">&nbsp;</td>
                                          </tr>
                                          <%}
										  
										  	nextPayment = false;
										  
										  }%>
                                          <tr> 
                                            <td width="6%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="6%">&nbsp;</td>
                                            <td width="10%">&nbsp;</td>
                                          </tr>
                                          <tr> 
                                            <td width="6%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%"><b>Total Pinjaman</b></td>
                                            <td colspan="4" class="tablecell1"> 
                                              <div align="right"><b><%= JSPFormater.formatNumber(pinjaman.getTotalPinjaman(),"#,###.##") %></b></div>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td width="6%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%"><b>Total Pembayaran</b></td>
                                            <td colspan="4" class="tablecell1"> 
                                              <div align="right"> <b> 
                                                <%
											double totalBayar = DbBayarPinjaman.getTotalPayment(pinjaman.getOID());
											%>
                                                <%= JSPFormater.formatNumber(totalBayar,"#,###.##") %></b></div>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td width="6%">&nbsp;</td>
                                            <td width="8%">&nbsp;</td>
                                            <td width="9%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%">&nbsp;</td>
                                            <td width="11%"><b>Sisa</b></td>
                                            <td colspan="4" class="tablecell1"> 
                                              <div align="right"><b><%= JSPFormater.formatNumber(pinjaman.getTotalPinjaman()-totalBayar,"#,###.##") %></b></div>
                                            </td>
                                          </tr>
                                        </table>
                                      </div>
                                    </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" valign="top"> 
                                      <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td><a href="javascript:cmdPrintXLS()"><img src="../images/print.gif" width="53" height="22" border="0"></a></td>
                                          <td>&nbsp;</td>
                                        </tr>
                                      </table>
                                      &nbsp;</td>
                                  </tr>
                                  <%}%>
                                  <tr align="left" > 
                                    <td colspan="4" valign="top" height="12">&nbsp;</td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" valign="top">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>
                        </form>
						<%
							session.putValue("KONSTAN", rptKonstan);
							session.putValue("DETAIL", vTemp);
						%>
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
            <%@ include file="../main/footermm.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
