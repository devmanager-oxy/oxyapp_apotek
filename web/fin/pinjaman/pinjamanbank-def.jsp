 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %> 
<%@ page import = "com.project.coorp.member.*" %>
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
long oidPinjaman = JSPRequestValue.requestLong(request, "hidden_pinjaman_id");
long oidPinjamanDetail = JSPRequestValue.requestLong(request, "hidden_pinjaman_detail_id");

if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
}

Vector listBank = DbBank.list(0,0, "", "");

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

//out.println("jspPinjaman.getErrors() : "+jspPinjaman.getErrors());

/*count list All Pinjaman*/
int vectSize = DbPinjaman.getCount(whereClause);

Pinjaman pinjaman = ctrlPinjaman.getPinjaman();

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
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Sipadu - Finance</title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">


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


function cmdUpdateTanggal(oid){
	document.frmpinjaman.hidden_pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.hidden_pinjaman_detail_id.value=oid;
	document.frmpinjaman.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}

function cmdUpdateJT(){
	document.frmpinjaman.hidden_pinjaman_id.value="<%=pinjaman.getOID()%>";
	document.frmpinjaman.command.value="<%=JSPCommand.POST%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}

function cmdChangeType(){
	
	var bunga = document.frmpinjaman.<%=jspPinjaman.colNames[JspPinjaman.JSP_BUNGA] %>.value;
	bunga = removeChar(bunga);	
	bunga = cleanNumberFloat(bunga, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var lama = document.frmpinjaman.<%=jspPinjaman.colNames[JspPinjaman.JSP_LAMA_CICILAN] %>.value;
	lama = removeChar(lama);	
	lama = cleanNumberFloat(lama, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var total = document.frmpinjaman.<%=jspPinjaman.colNames[JspPinjaman.JSP_TOTAL_PINJAMAN] %>.value;
	total = removeChar(total);	
	total = cleanNumberFloat(total, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("bunga : "+bunga+", lama : "+lama+", total : "+total);
	//alert("bungaf : "+parseFloat(bunga)+", lama  f: "+parseFloat(lama)+", total f : "+parseFloat(total));
	
	if(!isNaN(bunga) && parseFloat(bunga)>0 && !isNaN(lama) && parseFloat(lama)>0 && !isNaN(total) && parseFloat(total)>0){
		
		//alert("in");
	
		var cicilan = 0;
		var type = document.frmpinjaman.<%=jspPinjaman.colNames[JspPinjaman.JSP_JENIS_CICILAN] %>.value;		
		
		//alert("type : "+type);
		
		//bunga tetap
		if(parseInt(type)==0){
			cicilan = (parseFloat(total)/parseFloat(lama)) + ((parseFloat(total)/parseFloat(lama)) * (parseFloat(bunga)/100));
		}
		else{
			x = Math.pow(1/(1+(parseFloat(bunga)/100)),(parseFloat(lama)));
        
			y = ((1-x))/(parseFloat(bunga)/100);
			
			cicilan = parseFloat(total)/y;
		}
		
		//alert("cicilan : "+cicilan);
		
		document.frmpinjaman.<%=jspPinjaman.colNames[JspPinjaman.JSP_CICILAN] %>.value = formatFloat(""+cicilan, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
	}
	else{
		document.frmpinjaman.<%=jspPinjaman.colNames[JspPinjaman.JSP_CICILAN] %>.value = "0.00";
	}
	
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
	document.frmpinjaman.hidden_pinjaman_id.value=oidp;
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="bayarpinjaman.jsp";
	document.frmpinjaman.submit();
}

function cmdAdd(){
	document.frmpinjaman.hidden_pinjaman_id.value="0";
	document.frmpinjaman.command.value="<%=JSPCommand.ADD%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}

function cmdAsk(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.ASK%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}

function cmdConfirmDelete(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.DELETE%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}
function cmdSave(){
	document.frmpinjaman.command.value="<%=JSPCommand.SAVE%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
	}

function cmdEdit(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
	}

function cmdCancel(oidPinjaman){
	document.frmpinjaman.hidden_pinjaman_id.value=oidPinjaman;
	document.frmpinjaman.command.value="<%=JSPCommand.EDIT%>";
	document.frmpinjaman.prev_command.value="<%=prevJSPCommand%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}

function cmdBack(){
	document.frmpinjaman.command.value="<%=JSPCommand.BACK%>";
	//document.frmpinjaman.action="<%=approot%>/home.jsp?menu_idx=0";
	document.frmpinjaman.action="arsippinjamanbank.jsp";
	document.frmpinjaman.submit();
	}

function cmdListFirst(){
	document.frmpinjaman.command.value="<%=JSPCommand.FIRST%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}

function cmdListPrev(){
	document.frmpinjaman.command.value="<%=JSPCommand.PREV%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
	}

function cmdListNext(){
	document.frmpinjaman.command.value="<%=JSPCommand.NEXT%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}

function cmdListLast(){
	document.frmpinjaman.command.value="<%=JSPCommand.LAST%>";
	document.frmpinjaman.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpinjaman.action="pinjamanbank.jsp";
	document.frmpinjaman.submit();
}

function getMember(){
	window.open("scrmember.jsp","srcmember","scrollbars=no,height=400,width=800,addressbar=no,menubar=no,toolbar=no,location=no,");
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Keanggotaan</span> 
                        &raquo; <span class="level1">Simpan Pinjam</span> &raquo; 
                        <span class="level2">Pinjaman Bank 
                        <%if(pinjaman.getOID()==0){%>
                        Baru
                        <%}%> - Angsuran Bunga Tetap
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
                          <input type="hidden" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_USER_ID] %>"  value="<%= (pinjaman.getUserId()==0) ? user.getOID() :  pinjaman.getUserId()%>">
                          <input type="hidden" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_APPROVE_BY_ID] %>"  value="<%= (pinjaman.getApproveById()==0) ? user.getOID() :  pinjaman.getApproveById()%>">
                          <input type="hidden" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_TYPE] %>"  value="<%= DbPinjaman.TYPE_PINJAMAN_BANK %>">
						  <input type="hidden" name="<%=jspPinjaman.colNames[jspPinjaman.JSP_JENIS_CICILAN]%>" value="<%=DbPinjaman.JENIS_CICILAN_TETAP%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="21" width="11%">Anggota</td>
                                    <td height="21" width="24%"> 
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
											}
											
											%>
                                            <input type="text" name="anggota" value="<%=str%>" readOnly size="30">
                                            <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_MEMBER_ID) %> </td>
                                          <td width="3%"><img src="../images/spacer.gif" width="8" height="8"></td>
                                          <td width="32%" nowrap><a href="javascript:getMember()"><img src="../images/search2.jpg" width="22" border="0"></a><img src="../images/spacer.gif" width="20" height="8"></td>
                                        </tr>
                                      </table>
                                    <td height="21" width="14%">Nomor Rekening 
                                      Pinjaman 
                                    <td height="21" width="51%"> 
                                      <%
									  if(pinjaman.getOID()==0){
									  		pinjaman.setType(DbPinjaman.TYPE_PINJAMAN_BANK);
									  }
									  int cnt = DbPinjaman.getNextCounter(pinjaman.getType());
									  String prefix = DbPinjaman.getNumberPrefix(pinjaman.getType());
									  String number = DbPinjaman.getNextNumber(cnt, pinjaman.getType());
									  if(pinjaman.getOID()==0){
									  		pinjaman.setNumber(number);	
									  }
									  %>
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_NUMBER] %>"  value="<%= pinjaman.getNumber() %>" class="formElemen">
                                  <tr align="left"> 
                                    <td height="21" width="11%">Bank</td>
                                    <td height="21" width="24%"> 
                                      <select name="<%=jspPinjaman.colNames[jspPinjaman.JSP_BANK_ID]%>">
                                        <%
										if(listBank!=null && listBank.size()>0){
											for(int i=0; i<listBank.size(); i++){
												Bank bank = (Bank)listBank.get(i);
										%>
                                        <option value="<%=bank.getOID()%>" <%if(bank.getOID()==pinjaman.getBankId()){%>selected<%}%>><%=bank.getName()%></option>
                                        <%
											}
										}%>
                                      </select>
                                      * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_TOTAL_PINJAMAN) %> 
                                    <td height="21" width="14%">&nbsp;
                                    <td height="21" width="51%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" width="11%">Tanggal</td>
                                    <td height="21" width="24%"> 
                                      <input name="<%=jspPinjaman.colNames[JspPinjaman.JSP_DATE] %>" value="<%=JSPFormater.formatDate((pinjaman.getDate()==null) ? new Date() : pinjaman.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpinjaman.<%=jspPinjaman.colNames[JspPinjaman.JSP_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                    <td height="21" width="14%">Bunga Pinjaman 
                                      Koperasi 
                                    <td height="21" width="51%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_BUNGA] %>"  value="<%= pinjaman.getBunga() %>" class="formElemen" size="10"  style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()" onChange="javascript:cmdChangeType()">
                                      % /bulan * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_BUNGA) %> 
                                  <tr align="left"> 
                                    <td height="21" width="11%">Total Pinjaman</td>
                                    <td height="21" width="24%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_TOTAL_PINJAMAN] %>"  value="<%= JSPFormater.formatNumber(pinjaman.getTotalPinjaman(),"#,###.##") %>" class="formElemen" style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()" onChange="javascript:cmdChangeType()">
                                      * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_TOTAL_PINJAMAN) %> 
                                    <td height="21" width="14%">Bunga Pinjaman 
                                      Bank 
                                    <td height="21" width="51%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_BUNGA_BANK] %>"  value="<%= pinjaman.getBungaBank() %>" class="formElemen" size="10"  style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                      % /bulan * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_BUNGA_BANK) %> 
                                  <tr align="left"> 
                                    <td height="21" width="11%">Biaya Administrasi</td>
                                    <td height="21" width="24%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_BIAYA_ADMINISTRASI] %>"  value="<%= JSPFormater.formatNumber(pinjaman.getBiayaAdministrasi(),"#,###.##") %>" class="formElemen"  style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                    <td height="21" width="14%">Lama Angsuran 
                                    <td height="21" width="51%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_LAMA_CICILAN] %>"  value="<%= pinjaman.getLamaCicilan() %>" class="formElemen" size="10" onBlur="javascript:checkNumber1(this)" style="text-align:right" onClick="this.select()" onChange="javascript:cmdChangeType()">
                                      bulan * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_LAMA_CICILAN) %> 
                                  <tr align="left"> 
                                    <td height="21" width="11%">Biaya Provisi</td>
                                    <td height="21" width="24%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_PROVISI] %>"  value="<%= JSPFormater.formatNumber(pinjaman.getProvisi(),"#,###.##") %>" class="formElemen"  style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                    <td height="21" width="14%">Besar Angsuran
                                    <td height="21" width="51%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_CICILAN] %>"  value="<%= JSPFormater.formatNumber(pinjaman.getCicilan(),"#,###.##") %>" class="formElemen"  style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                  <tr align="left"> 
                                    <td height="21" width="11%">Biaya Asuransi</td>
                                    <td height="21" width="24%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_BIAYA_ADMINISTRASI] %>3"  value="<%= JSPFormater.formatNumber(pinjaman.getBiayaAdministrasi(),"#,###.##") %>" class="formElemen"  style="text-align:right" onBlur="javascript:checkNumber(this)" onClick="this.select()">
                                    <td height="21" width="14%">&nbsp; 
                                    <td height="21" width="51%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" width="11%">Jenis Pinjaman</td>
                                    <td height="21" width="24%"> 
                                      <select name="<%=jspPinjaman.colNames[JspPinjaman.JSP_JENIS_BARANG] %>">
                                        <%for(int i=0; i<DbPinjaman.strJenisBarang.length; i++){%>
                                        <option value="<%=i%>" <%if(pinjaman.getJenisBarang()==i){%>selected<%}%>><%=DbPinjaman.strJenisBarang[i]%></option>
                                        <%}%>
                                      </select>
                                    <td height="21" width="14%">Jatuh Tempo Setiap 
                                      Tanggal 
                                    <td height="21" width="51%"> 
                                      <input type="text" name="<%=jspPinjaman.colNames[JspPinjaman.JSP_TANGGAL_JATUH_TEMPO] %>"  value="<%= pinjaman.getTanggalJatuhTempo() %>" class="formElemen" size="10"  onBlur="javascript:checkNumber1(this)" style="text-align:right" onClick="this.select()">
                                      * <%= jspPinjaman.getErrorMsg(JspPinjaman.JSP_TANGGAL_JATUH_TEMPO) %> 
                                  <tr align="left"> 
                                    <td height="21" width="11%">Keterangan</td>
                                    <td height="21" colspan="3"> 
                                      <textarea name="<%=jspPinjaman.colNames[JspPinjaman.JSP_DETAIL_JENIS_BARANG] %>" class="formElemen" cols="120" rows="2"><%= pinjaman.getDetailJenisBarang() %></textarea>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="11%">&nbsp;</td>
                                    <td height="8" width="24%" valign="top">&nbsp;</td>
                                    <td height="8" width="14%" valign="top">&nbsp;</td>
                                    <td height="8" width="51%" valign="top">&nbsp;</td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="11%">Status 
                                      Pinjaman </td>
                                    <td height="8" width="24%" valign="top"> 
                                      <%if(pinjaman.getStatus()==DbPinjaman.STATUS_DRAFT){%>
                                      <select name="<%=jspPinjaman.colNames[JspPinjaman.JSP_STATUS] %>">
                                        <%for(int i=0; i<DbPinjaman.strStatus.length; i++){%>
                                        <option value="<%=i%>" <%if(pinjaman.getStatus()==i){%>selected<%}%>><%=DbPinjaman.strStatus[i]%></option>
                                        <%}%>
                                      </select>
                                      <%}else{%>
                                      <table width="40%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td height="25" bgcolor="#FFFF00"> 
                                            <div align="center"><b><font color="#003399"><%=DbPinjaman.strStatus[pinjaman.getStatus()]%></font></b></div>
                                          </td>
                                        </tr>
                                      </table>
                                      <%}%>
                                    </td>
                                    <td height="8" width="14%" valign="top">&nbsp;</td>
                                    <td height="8" width="51%" valign="top">&nbsp;</td>
                                  </tr>
                                  <%if(pinjaman.getOID()!=0){%>
                                  <tr align="left"> 
                                    <td height="21" valign="middle" width="11%">&nbsp;</td>
                                    <td height="21" width="24%" valign="top">&nbsp;</td>
                                    <td height="21" width="14%" valign="top">&nbsp;</td>
                                    <td height="21" width="51%" valign="top">&nbsp;</td>
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
                                            <%if(pinjaman.getStatus()==DbPinjaman.STATUS_APPROVE || pinjaman.getStatus()==DbPinjaman.STATUS_LUNAS){%>
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
                                    <td height="21" valign="middle" width="11%">&nbsp;</td>
                                    <td height="21" width="24%" valign="top">&nbsp;</td>
                                    <td height="21" width="14%" valign="top">&nbsp;</td>
                                    <td height="21" width="51%" valign="top">&nbsp; 
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
                                    <td width="11%">&nbsp;</td>
                                    <td width="24%">&nbsp;</td>
                                    <td width="14%">&nbsp;</td>
                                    <td width="51%">&nbsp;</td>
                                  </tr>
                                  <%if(pds!=null && pds.size()>0){%>
                                  <tr align="left" valign="middle" > 
                                    <td colspan="4" height="23"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
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
                                            <td class="tablehdr">Angsuran </td>
                                            <td class="tablehdr">Pokok Angsuran</td>
                                            <td class="tablehdr">Bunga Koperasi 
                                            </td>
                                            <td class="tablehdr">Angsuran Koperasi</td>
                                            <td class="tablehdr">Bunga Bank</td>
                                            <td class="tablehdr">Angsuran Bank 
                                            </td>
                                            <td class="tablehdr">Jatuh Tempo</td>
                                            <td class="tablehdr">Status</td>
                                            <td class="tablehdr">Tanggal Angsuran</td>
                                            <td class="tablehdr">Angsuran</td>
                                            <td class="tablehdr">Pelunasan</td>
                                          </tr>
                                          <%
										  
										  boolean nextPayment = false;
										  long prevPaidDetail = 0;
										  
										  for(int i=0; i<pds.size(); i++){
										  		PinjamanDetail pd = (PinjamanDetail)pds.get(i);
												
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
												
												if(i%2==0){
										  %>
                                          <tr> 
                                            <td class="tablecell"> 
                                              <div align="center"><%=pd.getCicilanKe()%></div>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getBunga(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount()+pd.getBunga(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getBungaBank(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount() + pd.getBungaBank(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="right"> 
                                                <%if(i==0 && bp.getOID()==0){%>
                                                <a href="javascript:cmdUpdateTanggal('<%=pd.getOID()%>')"><%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd/MM/yy")%></a> 
                                                <%}else{%>
                                                <%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd/MM/yy")%> 
                                                <%}%>
                                              </div>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="center"><%=DbPinjaman.strPaymentStatus[pd.getStatus()]%></div>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="center"><%=(bp.getOID()!=0) ? JSPFormater.formatDate(bp.getTanggal(), "dd MMMM yyyy") : "-"%></div>
                                            </td>
                                            <td class="tablecell"> 
                                              <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                              <a href="javascript:cmdBayar('<%=pd.getOID()%>')">Angsuran</a> 
                                              <%	}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_ANGSURAN){														
													%>
                                              <a href="javascript:cmdBayarDetail('<%=pd.getOID()%>')">Detail</a> 
                                              <%	
														}
													}
												}%>
                                            </td>
                                            <td class="tablecell"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <a href="javascript:cmdPelunasan('<%=pd.getOID()%>')">Pelunasan</a> 
                                                <%
														}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_PELUNASAN){
														%>
                                                <a href="javascript:cmdPelunasanDetail('<%=pd.getOID()%>')">Detail</a> 
                                                <%
														}
													}
												}%>
                                              </div>
                                            </td>
                                          </tr>
                                          <%}else{%>
                                          <tr> 
                                            <td class="tablecell1"> 
                                              <div align="center"><%=pd.getCicilanKe()%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getBunga(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount()+pd.getBunga(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getBungaBank(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="right"><%=JSPFormater.formatNumber(pd.getAmount() + pd.getBungaBank(), "#,###.##")%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="right"> 
                                                <%if(i==0 && bp.getOID()==0){%>
                                                <a href="javascript:cmdUpdateTanggal('<%=pd.getOID()%>')"><%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd/MM/yy")%></a> 
                                                <%}else{%>
                                                <%=JSPFormater.formatDate(pd.getJatuhTempo(), "dd/MM/yy")%> 
                                                <%}%>
                                              </div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="center"><%=DbPinjaman.strPaymentStatus[pd.getStatus()]%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="center"><%=(bp.getOID()!=0) ? JSPFormater.formatDate(bp.getTanggal(), "dd MMMM yyyy") : "-"%></div>
                                            </td>
                                            <td class="tablecell1"> 
                                              <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                              <a href="javascript:cmdBayar('<%=pd.getOID()%>')">Angsuran</a> 
                                              <%	}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_ANGSURAN){														
													%>
                                              <a href="javascript:cmdBayarDetail('<%=pd.getOID()%>')">Detail</a> 
                                              <%	
														}
													}
												}%>
                                            </td>
                                            <td class="tablecell1"> 
                                              <div align="center"> 
                                                <%
												if(pinjaman.getStatus()!=DbPinjaman.STATUS_DRAFT){
													if(bp.getOID()==0){
														if(pinjaman.getStatus()!=DbPinjaman.STATUS_LUNAS && nextPayment){
													%>
                                                <a href="javascript:cmdPelunasan('<%=pd.getOID()%>')">Pelunasan</a> 
                                                <%
														}
													}else{
														if(bp.getType()==DbBayarPinjaman.TYPE_PELUNASAN){
														%>
                                                <a href="javascript:cmdPelunasanDetail('<%=pd.getOID()%>')">Detail</a> 
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
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>Jatuh tempo Angsuran I</td>
                                            <td> 
                                              <input name="jatuh_tempo" value="<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>" size="11" readonly>
                                              <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpinjaman.jatuh_tempo);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            </td>
                                            <td> 
                                              <div align="center"><a href="javascript:cmdUpdateJT()">Update</a></div>
                                            </td>
                                            <td> 
                                              <div align="center"><a href="javascript:cmdCancel('<%=pd.getPinjamanId()%>')">Batalkan</a></div>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                          </tr>
                                          <%}
										  		
												nextPayment = false;
										  
										  }%>
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
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td><b>Total Pinjaman</b></td>
                                            <td colspan="5" class="tablecell1"> 
                                              <div align="right"><b><%= JSPFormater.formatNumber(pinjaman.getTotalPinjaman(),"#,###.##") %></b></div>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td><b>Total Pembayaran</b></td>
                                            <td colspan="5" class="tablecell1"> 
                                              <div align="right"> <b> 
                                                <%
											double totalBayar = DbBayarPinjaman.getTotalPayment(pinjaman.getOID());
											%>
                                                <%= JSPFormater.formatNumber(totalBayar,"#,###.##") %></b></div>
                                            </td>
                                          </tr>
                                          <tr> 
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td><b>Sisa</b></td>
                                            <td colspan="5" class="tablecell1"> 
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
                                          <td><img src="../images/print.gif" width="53" height="22"></td>
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
