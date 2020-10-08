 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.coorp.member.*" %>
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

<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidSimpananMember = JSPRequestValue.requestLong(request, "hidden_simpanan_member_id");
long periodId = JSPRequestValue.requestLong(request, "hidden_periode_id");

if(start<0){
	start = 0;
}

//out.println("start : "+start);

long memberId = JSPRequestValue.requestLong(request, "hidden_member_id");

/*variable declaration*/
int recordToGet = 15;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "member_id="+memberId;
String orderClause = "tanggal";

Member member = new Member();
try{
	member = DbMember.fetchExc(memberId);
}
catch(Exception e){
}

Dinas dinas = new Dinas();
try{
	dinas = DbDinas.fetchExc(member.getDinasId());
}
catch(Exception e){
}

DinasUnit dinasUnit = new DinasUnit();
try{
	dinasUnit = DbDinasUnit.fetchExc(member.getDinasUnitId());
}
catch(Exception e){
}

CmdSimpananMember ctrlSimpananMember = new CmdSimpananMember(request);
JSPLine ctrLine = new JSPLine();
Vector listSimpananMember = new Vector(1,1);

/*switch statement */
iErrCode = ctrlSimpananMember.action(iJSPCommand , oidSimpananMember);
/* end switch*/
JspSimpananMember jspSimpananMember = ctrlSimpananMember.getForm();

//out.println(jspSimpananMember.getErrors());

/*count list All SimpananMember*/
int vectSize = DbSimpananMember.getCount(whereClause);

if(iJSPCommand==JSPCommand.EDIT){
	iJSPCommand=JSPCommand.LAST;
}

/*switch list SimpananMember*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlSimpananMember.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

SimpananMember simpananMember = ctrlSimpananMember.getSimpananMember();
msgString =  ctrlSimpananMember.getMessage();

/* get record to display */
listSimpananMember = DbSimpananMember.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listSimpananMember.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listSimpananMember = DbSimpananMember.list(start,recordToGet, whereClause , orderClause);
}




%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<title>sipadu--</title>
<script language="JavaScript">
<!--



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


function cmdAdd(){
	document.frmsimpananmember.hidden_simpanan_member_id.value="0";
	document.frmsimpananmember.command.value="<%=JSPCommand.ADD%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdAsk(oidSimpananMember){
	document.frmsimpananmember.hidden_simpanan_member_id.value=oidSimpananMember;
	document.frmsimpananmember.command.value="<%=JSPCommand.ASK%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdConfirmDelete(oidSimpananMember){
	document.frmsimpananmember.hidden_simpanan_member_id.value=oidSimpananMember;
	document.frmsimpananmember.command.value="<%=JSPCommand.DELETE%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdSave(){
	document.frmsimpananmember.command.value="<%=JSPCommand.SAVE%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdEdit(oidSimpananMember){
	document.frmsimpananmember.hidden_simpanan_member_id.value=oidSimpananMember;
	document.frmsimpananmember.command.value="<%=JSPCommand.EDIT%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdCancel(oidSimpananMember){
	document.frmsimpananmember.hidden_simpanan_member_id.value=oidSimpananMember;
	document.frmsimpananmember.command.value="<%=JSPCommand.EDIT%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdBack(){
	document.frmsimpananmember.command.value="<%=JSPCommand.BACK%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdListFirst(){
	document.frmsimpananmember.command.value="<%=JSPCommand.FIRST%>";
	document.frmsimpananmember.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdListPrev(){
	document.frmsimpananmember.command.value="<%=JSPCommand.PREV%>";
	document.frmsimpananmember.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdListNext(){
	document.frmsimpananmember.command.value="<%=JSPCommand.NEXT%>";
	document.frmsimpananmember.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

function cmdListLast(){
	document.frmsimpananmember.command.value="<%=JSPCommand.LAST%>";
	document.frmsimpananmember.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsimpananmember.action="simpananmember.jsp";
	document.frmsimpananmember.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidSimpananMember){
	document.frmimage.hidden_simpanan_member_id.value=oidSimpananMember;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="simpananmember.jsp";
	document.frmimage.submit();
}

//-------------- script control line -------------------
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
                        Pinjam</span> &raquo; <span class="level2">Simpanan Anggota<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/imagessp/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmsimpananmember" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_simpanan_member_id" value="<%=oidSimpananMember%>">
                          <input type="hidden" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_MEMBER_ID]%>" value="<%=memberId%>">
                          <input type="hidden" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_USER_ID]%>" value="<%//=user.getOID()%>">
                          <input type="hidden" name="hidden_member_id" value="<%=memberId%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="1" cellpadding="1">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="middle" colspan="3">&nbsp; 
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="14" valign="middle" colspan="3"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="7%"><b>&nbsp;NIK</b></td>
                                                <td width="24%"><b>: &nbsp;<%=member.getNoMember()%></b></td>
                                                <td width="6%"><b>Dinas</b></td>
                                                <td width="63%"><b>: &nbsp;<%=dinas.getNama()%></b></td>
                                              </tr>
                                              <tr> 
                                                <td width="7%"><b>&nbsp;Nama</b></td>
                                                <td width="24%"><b>: &nbsp;<%=member.getNama()%></b></td>
                                                <td width="6%"><b>Unit </b></td>
                                                <td width="63%"><b>: &nbsp;<%=dinasUnit.getNama()%></b></td>
                                              </tr>
                                              <tr> 
                                                <td width="7%">&nbsp;</td>
                                                <td width="24%">&nbsp;</td>
                                                <td width="6%">&nbsp;</td>
                                                <td width="63%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td class="tablehdr" rowspan="2" width="4%">No</td>
                                                      <td class="tablehdr" rowspan="2" width="10%">Tanggal</td>
                                                      <td class="tablehdr" rowspan="2" width="11%">Simpanan 
                                                        Pokok </td>
                                                      <td class="tablehdr" rowspan="2" width="9%">Simpanan 
                                                        Wajib </td>
                                                      <td class="tablehdr" colspan="2">Simpanan 
                                                        Sukarela</td>
                                                      <td class="tablehdr" rowspan="2" width="9%">Saldo</td>
                                                      <td class="tablehdr" rowspan="2" width="32%">Keterangan</td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="tablehdr" width="11%">SHU/Alokasi</td>
                                                      <td class="tablehdr" width="14%">Tab.Kop</td>
                                                    </tr>
                                                    <%
													//Vector tabungans = DbSimpananMember.list(start, recordToGet, "member_id="+memberId, "tanggal");
													int docStatus = 0;
													
													double saldo = 0;//DbSimpananMember.getSaldoSebelumnya(memberId, sm1);
													
													if(listSimpananMember!=null && listSimpananMember.size()>0){
													
														SimpananMember sm1 = (SimpananMember)listSimpananMember.get(0);
													
														saldo = DbSimpananMember.getSaldoSebelumnya(memberId, sm1);
														
														for(int i=0; i<listSimpananMember.size(); i++){
														
															SimpananMember simpmember = (SimpananMember)listSimpananMember.get(i);
															saldo = saldo + simpmember.getPokok() + simpmember.getWajib() + simpmember.getSukarelaShu() + simpmember.getSukarelaTabungan();
																													
															if(i%2==0){
													%>
                                                    <tr> 
                                                      <td width="4%" class="tablecell"> 
                                                        <div align="center"><%=start+(i+1)%></div>
                                                      </td>
                                                      <td width="10%" class="tablecell"> 
                                                        <div align="center"><%=JSPFormater.formatDate(simpmember.getTanggal(), "dd/MM/yyyy")%></div>
                                                      </td>
                                                      <td width="11%" class="tablecell"> 
                                                        <div align="right"><%=(simpmember.getPokok()==0) ? "" : ((simpmember.getPokok()>0) ? JSPFormater.formatNumber(simpmember.getPokok(), "#,###") : "("+JSPFormater.formatNumber(simpmember.getPokok()*-1, "#,###")+")")%> </div>
                                                      </td>
                                                      <td width="9%" class="tablecell"> 
                                                        <div align="right"><%=(simpmember.getWajib()==0) ? "" : ((simpmember.getWajib()>0) ? JSPFormater.formatNumber(simpmember.getWajib(), "#,###") : "("+JSPFormater.formatNumber(simpmember.getWajib()*-1, "#,###")+")")%> </div>
                                                      </td>
                                                      <td width="11%" class="tablecell"> 
                                                        <div align="right"><%=(simpmember.getSukarelaShu()==0) ? "" : ((simpmember.getSukarelaShu()>0) ? JSPFormater.formatNumber(simpmember.getSukarelaShu(), "#,###") : "("+JSPFormater.formatNumber(simpmember.getSukarelaShu()*-1, "#,###")+")")%></div>
                                                      </td>
                                                      <td width="14%" class="tablecell"> 
                                                        <div align="right"><%=(simpmember.getSukarelaTabungan()==0) ? "" : ((simpmember.getSukarelaTabungan()>0) ? JSPFormater.formatNumber(simpmember.getSukarelaTabungan(), "#,###") : "("+JSPFormater.formatNumber(simpmember.getSukarelaTabungan()*-1, "#,###")+")")%></div>
                                                      </td>
                                                      <td width="9%" class="tablecell"> 
                                                        <div align="right"><%=(saldo==0) ? "" : JSPFormater.formatNumber(saldo, "#,###")%></div>
                                                      </td>
                                                      <td width="32%" class="tablecell"> 
                                                        <div align="left"><%=simpmember.getKeterangan()%></div>
                                                      </td>
                                                    </tr>
                                                    <%}else{%>
                                                    <tr> 
                                                      <td width="4%" class="tablecell1"> 
                                                        <div align="center"><%=start+(i+1)%></div>
                                                      </td>
                                                      <td width="10%" class="tablecell1"> 
                                                        <div align="center"><%=JSPFormater.formatDate(simpmember.getTanggal(), "dd/MM/yyyy")%></div>
                                                      </td>
                                                      <td width="11%" class="tablecell1"> 
                                                        <div align="right"><%=(simpmember.getPokok()==0) ? "" : ((simpmember.getPokok()>0) ? JSPFormater.formatNumber(simpmember.getPokok(), "#,###") : "("+JSPFormater.formatNumber(simpmember.getPokok()*-1, "#,###")+")")%></div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="right"><%=(simpmember.getWajib()==0) ? "" : ((simpmember.getWajib()>0) ? JSPFormater.formatNumber(simpmember.getWajib(), "#,###") : "("+JSPFormater.formatNumber(simpmember.getWajib()*-1, "#,###")+")")%></div>
                                                      </td>
                                                      <td width="11%" class="tablecell1"> 
                                                        <div align="right"><%=(simpmember.getSukarelaShu()==0) ? "" : ((simpmember.getSukarelaShu()>0) ? JSPFormater.formatNumber(simpmember.getSukarelaShu(), "#,###") : "("+JSPFormater.formatNumber(simpmember.getSukarelaShu()*-1, "#,###")+")")%></div>
                                                      </td>
                                                      <td width="14%" class="tablecell1"> 
                                                        <div align="right"><%=(simpmember.getSukarelaTabungan()==0) ? "" : ((simpmember.getSukarelaTabungan()>0) ? JSPFormater.formatNumber(simpmember.getSukarelaTabungan(), "#,###") : "("+JSPFormater.formatNumber(simpmember.getSukarelaTabungan()*-1, "#,###")+")")%></div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="right"><%=(saldo==0) ? "" : JSPFormater.formatNumber(saldo, "#,###")%></div>
                                                      </td>
                                                      <td width="32%" class="tablecell1"> 
                                                        <div align="left"><%=simpmember.getKeterangan()%></div>
                                                      </td>
                                                    </tr>
                                                    <%}}}%>
                                                    <%if(iJSPCommand==JSPCommand.ADD || iErrCode!=0){%>
                                                    <tr> 
                                                      <td width="4%" class="tablecell"> 
                                                        <div align="center"></div>
                                                      </td>
                                                      <td width="10%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="textfield" size="20" value="<%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>">
                                                        </div>
                                                      </td>
                                                      <td width="11%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_POKOK]%>" size="20" value="<%=(simpananMember.getPokok()==0) ? "0" : JSPFormater.formatNumber(simpananMember.getPokok(), "#,###")%>" style="text-align:right" onBlur="/*javascript:checkNumber(this)*/" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_WAJIB]%>" size="20" value="<%=(simpananMember.getWajib()==0) ? "0" : JSPFormater.formatNumber(simpananMember.getWajib(), "#,###")%>" style="text-align:right" onBlur="/*javascript:checkNumber(this)*/" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="11%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SUKARELA_SHU]%>" size="20" value="<%=(simpananMember.getSukarelaShu()==0) ? "0" : JSPFormater.formatNumber(simpananMember.getSukarelaShu(), "#,###")%>" style="text-align:right" onBlur="/*javascript:checkNumber(this)*/" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="14%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SUKARELA_TABUNGAN]%>" size="20" value="<%=(simpananMember.getSukarelaTabungan()==0) ? "0" : JSPFormater.formatNumber(simpananMember.getSukarelaTabungan(), "#,###")%>" style="text-align:right" onBlur="/*javascript:checkNumber(this)*/" onClick="this.select()">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell"> 
                                                        <div align="center"></div>
                                                      </td>
                                                      <td width="32%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_KETERANGAN]%>" size="50" value="<%=simpananMember.getKeterangan()%>">
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="7">&nbsp; </td>
                                                      <td width="32%"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="25%" bgcolor="#EEEEEE" nowrap>Detail 
                                                              Jurnal</td>
                                                            <td width="75%">&nbsp;</td>
                                                          </tr>
                                                          <tr bgcolor="#E9E9E9"> 
                                                            <td width="25%">Debet</td>
                                                            <td width="75%"> 
                                                              <%
															Vector temp = new Vector();
															if(true){//simpananMember.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){
																
																temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_DEBET+"'", "");											
																if(temp!=null && temp.size()>0){
																	if(temp.size()>0){
																	%>
                                                              <select name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_DEBET_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																				AccLink al = (AccLink)temp.get(i);
																				Coa cx = new Coa();
																				try{
																					cx = DbCoa.fetchExc(al.getCoaId());
																				}
																				catch(Exception e){
																				}
																		  %>
                                                                <option value="<%=cx.getOID()%>" <%if(simpananMember.getSimpananCoaDebetId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
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
                                                              <input type="hidden" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_DEBET_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
															}else{
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(simpananMember.getSimpananCoaDebetId());
																}
																catch(Exception e){
																}
																out.println(cx.getCode()+" - "+cx.getName());
															}
															%>
                                                            </td>
                                                          </tr>
                                                          <tr bgcolor="#E9E9E9"> 
                                                            <td width="25%">Simpanan 
                                                              Wajib </td>
                                                            <td width="75%"> 
                                                              <%
											if(simpananMember.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_CREDIT_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(simpananMember.getSimpananCoaCreditId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
                                                                <%}%>
                                                              </select>
                                                              <%}else{
														AccLink al = new AccLink();													
														al = (AccLink)temp.get(0);
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(simpananMember.getSimpananCoaCreditId());
														}
														catch(Exception e){
														}
													%>
                                                              <input type="hidden" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_CREDIT_ID] %>" value="<%=simpananMember.getSimpananCoaCreditId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(simpananMember.getSimpananCoaCreditId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr bgcolor="#E9E9E9"> 
                                                            <td width="25%">Simpanan 
                                                              Pokok </td>
                                                            <td width="75%"> 
                                                              <%
											if(simpananMember.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_POKOK_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_POKOK_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(simpananMember.getSimpananCoaPokokId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
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
                                                              <input type="hidden" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_POKOK_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(simpananMember.getSimpananCoaPokokId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr bgcolor="#E9E9E9"> 
                                                            <td width="25%" nowrap>Simpanan 
                                                              Sukarela </td>
                                                            <td width="75%"> 
                                                              <%
											if(simpananMember.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_SUKARELA_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_SUKARELA_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(simpananMember.getSimpananCoaSukarelaId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
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
                                                              <input type="hidden" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_SUKARELA_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(simpananMember.getSimpananCoaSukarelaId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                          <tr bgcolor="#E9E9E9"> 
                                                            <td width="25%" nowrap>SHU/Alokasi</td>
                                                            <td width="75%"> 
                                                              <%
											if(simpananMember.getStatus()==DbRekapMain.DOCUMENT_STATUS_DRAFT){	
											
												temp = DbAccLink.list(0,0, DbAccLink.colNames[DbAccLink.COL_TYPE]+"='"+I_Project.ACC_LINK_PINJAMAN_SIMPANAN_SHU_CREDIT+"'", "");											
												if(temp!=null && temp.size()>0){
													if(temp.size()>0){
													%>
                                                              <select name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_SHU_ID] %>">
                                                                <%for(int i=0; i<temp.size(); i++){
																AccLink al = (AccLink)temp.get(i);
																Coa cx = new Coa();
																try{
																	cx = DbCoa.fetchExc(al.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                                <option value="<%=cx.getOID()%>" <%if(simpananMember.getSimpananCoaShuId()==cx.getOID()){%>selected<%}%>><%=cx.getCode()+" - "+cx.getName()%></option>
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
                                                              <input type="hidden" name="<%=JspSimpananMember.colNames[JspSimpananMember.JSP_SIMPANAN_COA_SHU_ID] %>" value="<%=al.getCoaId()%>">
                                                              <%=cx.getCode()+" - "+cx.getName()%> 
                                                              <%}}
											}else{
												Coa cx = new Coa();
												try{
													cx = DbCoa.fetchExc(simpananMember.getSimpananCoaShuId());
												}
												catch(Exception e){
												}
												out.println(cx.getCode()+" - "+cx.getName());
											}	
											%>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <%}%>
                                                    <tr> 
                                                      <td width="4%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="32%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="4%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="14%"> 
                                                        <div align="right"><b>Saldo 
                                                          Akhir :</b> &nbsp;</div>
                                                      </td>
                                                      <td width="9%"> 
                                                        <%
														 double total = DbSimpananMember.getTotalSimpanan(memberId);
														%>
                                                        <div align="right"><b><%=(total==0) ? "" : JSPFormater.formatNumber(total, "#,###")%></b></div>
                                                      </td>
                                                      <td width="32%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="8"><span class="command"> 
                                                        <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
								   } 
							    %>
                                                        <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								 %>
                                                        <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span></td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="8">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="8">&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="8">&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="4%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="32%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="4%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="32%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="4%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="32%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="7%">&nbsp;</td>
                                                <td width="24%">&nbsp;</td>
                                                <td width="6%">&nbsp;</td>
                                                <td width="63%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
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
