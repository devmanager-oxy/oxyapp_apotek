 
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

<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidRekapPotonganGaji = JSPRequestValue.requestLong(request, "hidden_simpanan_member_id");
long periodId = JSPRequestValue.requestLong(request, "hidden_periode_id");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

PeriodeRekap prekap = new PeriodeRekap();
try{
	prekap = DbPeriodeRekap.fetchExc(periodId);
}
catch(Exception e){
}

CmdRekapPotonganGaji ctrlRekapPotonganGaji = new CmdRekapPotonganGaji(request);
JSPLine ctrLine = new JSPLine();
Vector listRekapPotonganGaji = new Vector(1,1);

/*switch statement */
//iErrCode = ctrlRekapPotonganGaji.action(iJSPCommand , oidRekapPotonganGaji);
/* end switch*/
JspRekapPotonganGaji jspRekapPotonganGaji = ctrlRekapPotonganGaji.getForm();

/*count list All RekapPotonganGaji*/
int vectSize = DbRekapPotonganGaji.getCount(whereClause);

/*switch list RekapPotonganGaji*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlRekapPotonganGaji.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

RekapPotonganGaji rekapPotonganGaji1 = ctrlRekapPotonganGaji.getRekapPotonganGaji();
msgString =  ctrlRekapPotonganGaji.getMessage();

/* get record to display */
listRekapPotonganGaji = DbRekapPotonganGaji.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listRekapPotonganGaji.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listRekapPotonganGaji = DbRekapPotonganGaji.list(start,recordToGet, whereClause , orderClause);
}

Vector periodRekaps = DbPeriodeRekap.list(0,0, "", "start_date");

if(iJSPCommand==JSPCommand.SAVE){
	Vector members = DbMember.list(0,0, "status='1'", "nama");
	if(members!=null && members.size()>0){
		for(int i=0; i<members.size(); i++){
		
			Member member = (Member)members.get(i);
			double simPokok = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_POKOK]+"_"+member.getOID());
			double simWajib = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_WAJIB]+"_"+member.getOID());
			double simSHU = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SUKARELA_SHU]+"_"+member.getOID());
			double simTab = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SUKARELA_TABUNGAN]+"_"+member.getOID());
			double simPinj = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_POTONGAN_PINJAMAN]+"_"+member.getOID());
			double simTotal = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_TOTAL]+"_"+member.getOID());
			double simDisetujui = JSPRequestValue.requestDouble(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_DISETUJUI]+"_"+member.getOID());
			String ket = JSPRequestValue.requestString(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_KETERANGAN]+"_"+member.getOID());
			int simStatus = JSPRequestValue.requestInt(request, JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_STATUS]+"_"+member.getOID());
			
			
			
		}
	}
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

function cmdAdd(){
	document.frmsimpananmember.hidden_simpanan_member_id.value="0";
	document.frmsimpananmember.command.value="<%=JSPCommand.ADD%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdAsk(oidRekapPotonganGaji){
	document.frmsimpananmember.hidden_simpanan_member_id.value=oidRekapPotonganGaji;
	document.frmsimpananmember.command.value="<%=JSPCommand.ASK%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdConfirmDelete(oidRekapPotonganGaji){
	document.frmsimpananmember.hidden_simpanan_member_id.value=oidRekapPotonganGaji;
	document.frmsimpananmember.command.value="<%=JSPCommand.DELETE%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdSave(){
	document.frmsimpananmember.command.value="<%=JSPCommand.SAVE%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdEdit(oidRekapPotonganGaji){
	document.frmsimpananmember.hidden_simpanan_member_id.value=oidRekapPotonganGaji;
	document.frmsimpananmember.command.value="<%=JSPCommand.EDIT%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdCancel(oidRekapPotonganGaji){
	document.frmsimpananmember.hidden_simpanan_member_id.value=oidRekapPotonganGaji;
	document.frmsimpananmember.command.value="<%=JSPCommand.EDIT%>";
	document.frmsimpananmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdBack(){
	document.frmsimpananmember.command.value="<%=JSPCommand.BACK%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdListFirst(){
	document.frmsimpananmember.command.value="<%=JSPCommand.FIRST%>";
	document.frmsimpananmember.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdListPrev(){
	document.frmsimpananmember.command.value="<%=JSPCommand.PREV%>";
	document.frmsimpananmember.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdListNext(){
	document.frmsimpananmember.command.value="<%=JSPCommand.NEXT%>";
	document.frmsimpananmember.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

function cmdListLast(){
	document.frmsimpananmember.command.value="<%=JSPCommand.LAST%>";
	document.frmsimpananmember.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmsimpananmember.action="rekappotongangaji.jsp";
	document.frmsimpananmember.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidRekapPotonganGaji){
	document.frmimage.hidden_simpanan_member_id.value=oidRekapPotonganGaji;
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
                        Pinjam</span> &raquo; <span class="level2">Rekap Potongan 
                        Gaji <br>
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
                          <input type="hidden" name="hidden_simpanan_member_id" value="<%=oidRekapPotonganGaji%>">
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
                                                <td width="7%">&nbsp;Periode</td>
                                                <td width="43%">
                                                  <select name="hidden_periode_id">
												  	<%if(periodRekaps!=null && periodRekaps.size()>0){
														for(int i=0; i<periodRekaps.size(); i++){
															PeriodeRekap pr = (PeriodeRekap)periodRekaps.get(i);
													%>
                                                    <option value="<%=pr.getOID()%>" <%if(pr.getOID()==periodId){%>selected<%}%>><%=pr.getName()%></option>
													<%}}%>
                                                  </select>
                                                </td>
                                                <td width="25%">&nbsp;</td>
                                                <td width="25%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="7%">&nbsp;No Dokumen</td>
                                                <td width="43%">
												  <%
												  
												  Vector vx = DbRekapPotonganGaji.list(0,0, "periode_id="+periodId, "");												  
												  String code = "";
												  if(vx!=null && vx.size()>0){
												  	 	RekapPotonganGaji rx = (RekapPotonganGaji)vx.get(0);
														code = rx.getNumber();
												  }
												  if(code.length()==0){
												  		int cnt = DbRekapPotonganGaji.getNextCounter();
														code = DbRekapPotonganGaji.getNextNumber(cnt);
												  }
												  %>
												
                                                  <input type="text" name="textfield7" value="<%=code%>" readOnly>
                                                </td>
                                                <td width="25%">&nbsp;</td>
                                                <td width="25%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="7%">&nbsp;</td>
                                                <td width="43%">&nbsp;</td>
                                                <td width="25%">&nbsp;</td>
                                                <td width="25%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td class="tablehdr" rowspan="2" width="14%">Anggota</td>
                                                      <td class="tablehdr" rowspan="2" width="13%">Simpanan 
                                                        Pokok </td>
                                                      <td class="tablehdr" rowspan="2" width="11%">Simpanan 
                                                        Wajib </td>
                                                      <td class="tablehdr" colspan="2">Sukarela</td>
                                                      <td class="tablehdr" rowspan="2" width="12%">Angsuran 
                                                        Pinjaman</td>
                                                      <td class="tablehdr" rowspan="2" width="10%">Jumlah</td>
                                                      <td class="tablehdr" rowspan="2" width="14%">Disetujui</td>
                                                      <td class="tablehdr" rowspan="2" width="14%">Keterangan</td>
                                                      <td class="tablehdr" rowspan="2" width="7%">Status</td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="tablehdr" width="10%">SHU/Alokasi</td>
                                                      <td class="tablehdr" width="9%">Tab.Kop</td>
                                                    </tr>
                                                    <%
													Vector members = DbMember.list(0,0, "status='1'", "nama");
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
														
														double angsuranPinjaman = rpg.getPotonganPinjaman();
														if(rpg.getStatus()==DbRekapPotonganGaji.STATUS_DRAFT){
															angsuranPinjaman = DbPinjaman.getTotalTagihanPinjaman(member.getOID(), prekap.getStartDate());
														}
														
														if(i%2==0){
													%>
                                                    <tr> 
                                                      <td width="14%" class="tablecell" nowrap><%=member.getNoMember()+"/"+member.getNama()%></td>
                                                      <td width="13%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_POKOK]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(simPokok, "#,###")%>" size="15" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="11%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_WAJIB]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(simWajib, "#,###")%>" size="15" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="10%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SUKARELA_SHU]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getSukarelaShu(), "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SUKARELA_TABUNGAN]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getSukarelaTabungan(), "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="12%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_POTONGAN_PINJAMAN]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(angsuranPinjaman, "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="10%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_TOTAL]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getTotal(), "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="14%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_DISETUJUI]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getDisetujui(), "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="14%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_KETERANGAN]+"_"+member.getOID()%>" size="20" value="<%=rpg.getKeterangan()%>">
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <select name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_STATUS]+"_"+member.getOID()%>">
                                                            <%for(int x=0; x<DbRekapPotonganGaji.strStatus.length; x++){%>
                                                            <option value="<%=x%>" <%if(x==rpg.getStatus()){%>selected<%}%>><%=DbRekapPotonganGaji.strStatus[x]%></option>
                                                            <%}%>
                                                          </select>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <%}else{%>
                                                    <tr> 
                                                      <td width="14%" class="tablecell1"><%=member.getNoMember()+"/"+member.getNama()%></td>
                                                      <td width="13%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_POKOK]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(simPokok, "#,###")%>" size="15" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="11%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_WAJIB]+"_"+member.getOID()%>" value="<%=JSPFormater.formatNumber(simWajib, "#,###")%>" size="15" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="10%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SUKARELA_SHU]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getSukarelaShu(), "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_SUKARELA_TABUNGAN]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getSukarelaTabungan(), "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="12%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_POTONGAN_PINJAMAN]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(angsuranPinjaman, "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="10%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_TOTAL]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getTotal(), "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="14%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_DISETUJUI]+"_"+member.getOID()%>" size="15" value="<%=JSPFormater.formatNumber(rpg.getDisetujui(), "#,###")%>" style="text-align:right">
                                                        </div>
                                                      </td>
                                                      <td width="14%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_KETERANGAN]+"_"+member.getOID()%>" size="20" value="<%=rpg.getKeterangan()%>">
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"> 
                                                          <select name="<%=JspRekapPotonganGaji.colNames[JspRekapPotonganGaji.JSP_STATUS]+"_"+member.getOID()%>">
                                                            <%for(int x=0; x<DbRekapPotonganGaji.strStatus.length; x++){%>
                                                            <option value="<%=x%>" <%if(x==rpg.getStatus()){%>selected<%}%>><%=DbRekapPotonganGaji.strStatus[x]%></option>
                                                            <%}%>
                                                          </select>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <%}}}%>
                                                    <tr> 
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="13%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="14%"><b>Document 
                                                        Status </b></td>
                                                      <td width="13%"><b>: <%=DbRekapPotonganGaji.docStatus[docStatus]%></b></td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="13%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="10">
                                                        <table width="30%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr>
                                                            <td width="7%"><a href="javascript:cmdSave()"><img src="../images/success.gif" width="20" height="20" border="0"></a></td>
                                                            <td width="26%"><a href="javascript:cmdSave()">Save</a></td>
                                                            <td width="6%"><a href="javascript:cmdPost()"><img src="../images/yesx.gif" width="17" height="14" border="0"></a></td>
                                                            <td width="61%"><a href="javascript:cmdPost()">Posting 
                                                              Jurnal</a></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="13%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="13%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="13%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="7%">&nbsp;</td>
                                                <td width="43%">&nbsp;</td>
                                                <td width="25%">&nbsp;</td>
                                                <td width="25%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%
							try{
							%>
                                        <% 
						  }catch(Exception exc){ 
						  }%>
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
