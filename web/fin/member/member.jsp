<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% //int  appObjCode = ObjInfo.composeObjCode(ObjInfo.G1_MASTERDATA, ObjInfo.G2_MD_COMPANY, ObjInfo.OBJ_DIVISION); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privNone = true;
%>
<!-- Jsp Block -->
<%!

	public String drawList(Vector objectClass ,  long memberId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("No Member","10%");
		ctrlist.addHeader("Nama","30%");
		ctrlist.addHeader("Alamat","30%");
		//ctrlist.addHeader("Tempat Lahir","10%");
		ctrlist.addHeader("Tanggal Lahir","10%");
		//ctrlist.addHeader("Status","10%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			Member member = (Member)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(memberId == member.getOID())
				 index = i;

			rowx.add(member.getNoMember());

			rowx.add(member.getNama());

			rowx.add(member.getAlamat());

			//rowx.add(member.getTglLahir());

			String str_dt_TglLahir = ""; 
			try{
				Date dt_TanggalLahir = member.getTglLahir();
				if(dt_TanggalLahir==null){
					dt_TanggalLahir = new Date();
				}

				str_dt_TglLahir = JSPFormater.formatDate(dt_TanggalLahir, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_TglLahir = ""; }

			rowx.add(str_dt_TglLahir);

			//rowx.add(DbMember.strStatus[member.getStatus()]);

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(member.getOID()));
		}

		return ctrlist.draw(index);
	}

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidMember = JSPRequestValue.requestLong(request, "hidden_member_id");
long oidKecamatan = JSPRequestValue.requestLong(request, "JSP_KECAMATAN_ID");
long oidDesa = JSPRequestValue.requestLong(request, "JSP_DESA_ID");
int stt = JSPRequestValue.requestInt(request, "JSP_STATUS");
/*

*/



/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdMember ctrlMember = new CmdMember(request);
JSPLine ctrLine = new JSPLine();
Vector listMember = new Vector(1,1);

/*switch statement */
iErrCode = ctrlMember.action(iJSPCommand , oidMember);
/* end switch*/
JspMember jspMember = ctrlMember.getForm();

/*count list All Member*/
int vectSize = DbMember.getCount(whereClause);

Member member = ctrlMember.getMember();
msgString =  ctrlMember.getMessage();

if(iJSPCommand==JSPCommand.NONE){
	member.setStatus(1);
}

if(iJSPCommand==JSPCommand.NONE){
	if(oidMember==0){
		iJSPCommand = JSPCommand.ADD;
	}
	else{
		iJSPCommand = JSPCommand.EDIT;
	}
}

//kecamatan dan desa
Kecamatan kct = new Kecamatan();
Vector listKct = DbKecamatan.list(0,0,"","");
if(iJSPCommand==JSPCommand.EDIT){
	oidKecamatan = member.getKecamatanId();
}else{
	if(oidKecamatan==0 && listKct!=null && listKct.size()>0){
		Kecamatan kctt = (Kecamatan)listKct.get(0);
		oidKecamatan = kctt.getOID();
		member.setKecamatanId(oidKecamatan);
	}
}

/*
Desa ds = new Desa();
*/
Vector listDs = DbDesa.list(0,0,"kecamatan_id ="+oidKecamatan,"");
/*
if(oidDesa==0 && listDs!=null && listDs.size()>0){
	    Desa dss = (Desa)listDs.get(0);
		oidDesa = dss.getOID();
}
*/


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlMember.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listMember = DbMember.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listMember.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listMember = DbMember.list(start,recordToGet, whereClause , orderClause);
}
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!anggotaKop){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdPrint(){
	//window.open();
	window.open("<%=printroot%>.print.MemberPdf?oid_member=<%=member.getOID()%>&mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
}


function cmdAdd(){
	document.frmmember.hidden_member_id.value="0";
	document.frmmember.command.value="<%=JSPCommand.ADD%>";
	document.frmmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
}

function cmdAsk(oidMember){
	document.frmmember.hidden_member_id.value=oidMember;
	document.frmmember.command.value="<%=JSPCommand.ASK%>";
	document.frmmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
}

function cmdConfirmDelete(oidMember){
	document.frmmember.hidden_member_id.value=oidMember;
	document.frmmember.command.value="<%=JSPCommand.DELETE%>";
	document.frmmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
}
function cmdSave(){
	document.frmmember.command.value="<%=JSPCommand.SAVE%>";
	document.frmmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
	}

function cmdEdit(oidMember){
	document.frmmember.hidden_member_id.value=oidMember;
	document.frmmember.command.value="<%=JSPCommand.EDIT%>";
	document.frmmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
	}

function cmdCancel(oidMember){
	document.frmmember.hidden_member_id.value=oidMember;
	document.frmmember.command.value="<%=JSPCommand.EDIT%>";
	document.frmmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
}

function cmdBack(){
	//document.frmmember.command.value="<%=JSPCommand.LIST%>";
	document.frmmember.command.value="<%=JSPCommand.BACK%>";
	document.frmmember.action="scrmember.jsp";
	document.frmmember.submit();
}

function cmdListFirst(){
	document.frmmember.command.value="<%=JSPCommand.FIRST%>";
	document.frmmember.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
}

function cmdListPrev(){
	document.frmmember.command.value="<%=JSPCommand.PREV%>";
	document.frmmember.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
	}

function cmdListNext(){
	document.frmmember.command.value="<%=JSPCommand.NEXT%>";
	document.frmmember.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
}

function cmdListLast(){
	document.frmmember.command.value="<%=JSPCommand.LAST%>";
	document.frmmember.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
}

function cmdRefres(oidMember){
	document.frmmember.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmmember.hidden_member_id.value=oidMember;
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp" %>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp" %>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Keanggotaan</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Data Anggota</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmmember" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_member_id" value="<%=oidMember%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3">&nbsp;</td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="5" valign="middle" colspan="5"></td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="17" width="15%"><font color="#ff0000">* 
                                      ) data harap di isi</font></td>
                                    <td height="17" width="35%">&nbsp;</td>
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" colspan="2" width="35%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" width="15%"><b>Data Personal</b></td>
                                    <td height="17" width="35%">&nbsp;</td>
                                    <td height="17" width="15%"><b>Alamat Personal</b></td>
                                    <td height="17" colspan="2" width="35%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" width="15%">NIK</td>
                                    <td height="17" width="35%"> 
                                      <!--%
						  String num = member.getNoMember();
						  if(member.getOID()==0){
						  	 int cnt = DbMember.getNextCounter();
							 num = DbMember.getNextNumber(cnt);
						  }
						  %-->
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_NO_MEMBER] %>"  value="<%=(member.getNoMember()==null)?"":member.getNoMember()%>" class="formElemen">
                                      * <%= jspMember.getErrorMsg(JspMember.JSP_NO_MEMBER) %> </td>
                                    <td height="17" width="15%">Alamat</td>
                                    <td height="17" colspan="2" width="35%"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_ALAMAT] %>"  value="<%=(member.getAlamat()==null)?"":member.getAlamat() %>" class="formElemen" size="50">
                                      * <%= jspMember.getErrorMsg(JspMember.JSP_ALAMAT) %> 
                                  <tr align="left"> 
                                    <td height="17" width="15%">Nama</td>
                                    <td height="17" width="35%"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_NAMA] %>"  value="<%=(member.getNama()==null)?"":member.getNama() %>" class="formElemen" size="50">
                                      * <%= jspMember.getErrorMsg(JspMember.JSP_NAMA) %></td>
                                    <td height="17" width="15%">Kecamatan</td>
                                    <td height="17" colspan="2" width="35%"> 
                                      <select name="<%=jspMember.fieldNames[JspMember.JSP_KECAMATAN_ID]%>" onChange="javascript:cmdRefres('<%=oidMember%>')">
                                        <%
												Vector listKecamatan = DbKecamatan.list(0,0, "","nama");
												boolean found = false;
													
												if(listKecamatan!=null && listKecamatan.size()>0){
													for(int i=0;i<listKecamatan.size();i++){
														Kecamatan kecamatan = (Kecamatan)listKecamatan.get(i);
														if(member.getKecamatanId()==kecamatan.getOID()){
															found = true;
														}
														%>
                                        <option value="<%=kecamatan.getOID()%>" <%if(member.getKecamatanId()==kecamatan.getOID()){%>selected<%}%>><%=kecamatan.getNama()%></option>
                                        <%
											 		}
												}
												
												if(member.getKecamatanId()==0 || found==false){
													if(listKecamatan!=null && listKecamatan.size()>0){													
														Kecamatan kecamatan = (Kecamatan)listKecamatan.get(0);
														member.setKecamatanId(kecamatan.getOID());
														//out.println("kecamatan "+kecamatan.getOID());
													}
												}	
											 %>
                                      </select>
                                  <tr align="left"> 
                                    <td height="17" width="15%">Tanggal Lahir</td>
                                    <td height="17" width="35%"> 
                                      <input name="<%=jspMember.fieldNames[JspMember.JSP_TGL_LAHIR] %>" value="<%=JSPFormater.formatDate((member.getTglLahir()==null) ? new Date() : member.getTglLahir(), "dd/MM/yyyy")%>" size="11" readonly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmember.<%=jspMember.fieldNames[JspMember.JSP_TGL_LAHIR] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                    </td>
                                    <td height="17" width="15%">Desa</td>
                                    <td height="17" colspan="2" width="35%"> 
                                      <select name="<%=jspMember.fieldNames[JspMember.JSP_DESA_ID]%>">
                                        <%
											//Vector listDesa = DbDesa.list(0,0, "kecamatan_id ="+member.getKecamatanId(),"nama");
											
											if(member.getDesaId()==0 && listDs!=null && listDs.size()>0){
												Desa desa = (Desa)listDs.get(0);
												member.setDesaId(desa.getOID());
											}
											
											
											found = false;
											
											if(listDs!=null && listDs.size()>0){
												for(int i=0;i<listDs.size();i++){
													Desa desa = (Desa)listDs.get(i);
													if(member.getDesaId()==desa.getOID()){
														found = true;
													}
													
													%>
                                        <option value="<%=desa.getOID()%>" <%if(member.getDesaId()==desa.getOID()){%>selected<%}%>><%=desa.getNama()%></option>
                                        <%
												}
											}
											
											if((member.getDesaId()==0 || !found) && listDs!=null && listDs.size()>0){
												Desa desa = (Desa)listDs.get(0);
												member.setDesaId(desa.getOID());
											}
												
											 %>
                                      </select>
                                  <tr align="left"> 
                                    <td height="17" width="15%">Jenis Kelamin</td>
                                    <td height="17" width="35%"> 
                                      <% for(int i=0;i<DbMember.sexValue.length;i++){
										String str = "";
									   if(member.getJenisKelamin()==DbMember.sexValue[i]){str = "checked";}
							%>
                                      <input type="radio" name="<%=jspMember.fieldNames[jspMember.JSP_JENIS_KELAMIN]%>" value="<%=DbMember.sexValue[i]%>" <%=str%> style="border:'none'">
                                      <%=DbMember.sexKey[i]%> 
                                      <% }%>
                                    </td>
                                    <td height="17" width="15%">Telephone Rumah</td>
                                    <td height="17" colspan="2" width="35%"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_PHONE] %>"  value="<%=(member.getPhone()==null)?"":member.getPhone()%>" class="formElemen" >
                                      <%= jspMember.getErrorMsg(JspMember.JSP_PHONE) %> 
                                  <tr align="left"> 
                                    <td height="17" width="15%">Agama</td>
                                    <td height="17" width="35%"> 
                                      <select name="<%=jspMember.fieldNames[JspMember.JSP_AGAMA]%>">
                                        <%
								String strAgama = "";
								for(int i=0;i<DbMember.agamaKey.length;i++){
									strAgama = DbMember.agamaKey[i];
									if(member.getAgama()==DbMember.agamaKey[i]){strAgama = "selected";}
							%>
                                        <option value="<%=strAgama%>" <%if(((member.getAgama()==null) ? "" : member.getAgama()).equals(strAgama)){%>selected<%}%>><%=strAgama%></option>
                                        <%
								}
							%>
                                      </select>
                                    </td>
                                    <td height="17" width="15%">Hand phone</td>
                                    <td height="17" colspan="2" width="35%" valign="top"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_HP] %>"  value="<%=(member.getHp()==null)?"":member.getHp()%>" class="formElemen" >
                                      <%= jspMember.getErrorMsg(JspMember.JSP_HP) %> 
                                  <tr align="left"> 
                                    <td height="17" width="15%">Pendidikan Terakhir</td>
                                    <td height="17" width="35%"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_PENDIDIKAN] %>"  value="<%=(member.getPendidikan()==null)? "" : member.getPendidikan()%>" class="formElemen"  size="35">
                                    </td>
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" width="15%">Tanggal Pendidikan 
                                      Dasar</td>
                                    <td height="17" width="35%"> 
                                      <input name="<%=jspMember.fieldNames[JspMember.JSP_TGL_PENDIDIKAN] %>" value="<%=JSPFormater.formatDate((member.getTglPendidikan()==null) ? new Date() : member.getTglPendidikan(), "dd/MM/yyyy")%>" size="11" readonly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmember.<%=jspMember.fieldNames[JspMember.JSP_TGL_PENDIDIKAN] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                    </td>
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" width="15%">Tanggal Masuk</td>
                                    <td height="17" width="35%"> 
                                      <input name="<%=jspMember.fieldNames[JspMember.JSP_TGL_MASUK] %>" value="<%=JSPFormater.formatDate((member.getTglMasuk()==null) ? new Date() : member.getTglMasuk(), "dd/MM/yyyy")%>" size="11" readonly>
                                      <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmember.<%=jspMember.fieldNames[JspMember.JSP_TGL_MASUK] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                    </td>
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp;</td>
                                  <tr align="left"> 
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" width="35%">&nbsp;</td>
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" width="15%">Dinas / Unit</td>
                                    <td height="17" width="35%"> 
                                      <select name="<%=jspMember.fieldNames[JspMember.JSP_DINAS_UNIT_ID]%>">
                                        <%
										Vector temp = DbDinasUnit.list(0,0,"", "dinas_id, nama");
										if(temp!=null && temp.size()>0){
											for(int i=0;i<temp.size();i++){
												DinasUnit du = (DinasUnit)temp.get(i);
												Dinas din = new Dinas();
												try{
													din = DbDinas.fetchExc(du.getDinasId());
												}
												catch(Exception e){
												}
											%>
											<option value="<%=du.getOID()%>" <%if(member.getDinasUnitId()==du.getOID()){%>selected<%}%>><%=din.getNama()+" / "+du.getNama()%></option>
											<%
											}
										}
										%>
										
                                      </select>
                                    </td>
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" width="15%">Status Kepegawaian</td>
                                    <td height="17" width="35%"> 
                                      <select name="<%=jspMember.fieldNames[JspMember.JSP_STATUS_PEGAWAI]%>">
                                        <%
								
										for(int i=0;i<DbMember.statusPegawai.length;i++){
										%>
                                        <option value="<%=i%>" <%if(member.getStatusPegawai()==i){%>selected<%}%>><%=DbMember.statusPegawai[i]%></option>
                                        <%
										}
										%>
                                      </select>
                                    </td>
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" width="35%">&nbsp;</td>
                                    <td height="17" width="15%"><b>Alamat Perusahaan 
                                      / Kantor</b></td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" width="15%"><b>Tanggungan</b></td>
                                    <td height="17" width="35%">&nbsp; </td>
                                    <td height="16" width="15%">Pekerjaan</td>
                                    <td height="17" colspan="2" width="35%" valign="top"> 
                                      <% Vector pekerjaanKey = new Vector(1,1);
							 Vector pekerjaanValue = new Vector(1,1);
								 Vector listPekerjaan = DbPekerjaan.list(0, 0, "", "");
							 for(int i=0; i<listPekerjaan.size();i++){
								        Pekerjaan pekerjaan = (Pekerjaan)listPekerjaan.get(i);
										pekerjaanKey.add(pekerjaan.getKode()+ " - "+pekerjaan.getNama());
										pekerjaanValue.add(""+pekerjaan.getOID());
								 }
								 out.println(JSPCombo.draw(jspMember.fieldNames[JspMember.JSP_PEKERJAAN_ID],"formElemen",null,""+member.getPekerjaanId(),pekerjaanValue,pekerjaanKey));
						  %>
                                    </td>
                                  <tr align="left"> 
                                    <td height="16" width="15%">Nama Ahli Waris</td>
                                    <td height="16" width="35%"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_NAMA_AHLI_WARIS] %>"  value="<%=(member.getNamaAhliWaris()==null)? "" : member.getNamaAhliWaris()%>" class="formElemen"  size="50">
                                      <%= jspMember.getErrorMsg(JspMember.JSP_NAMA_AHLI_WARIS) %> </td>
                                    <td height="17" width="15%">Alamat Perusahaan 
                                      / Kantor</td>
                                    <td height="16" colspan="2" width="35%" valign="top"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_ALAMAT_PERUSAHAAN] %>"  value="<%=(member.getAlamatPerusahaan()==null)?"":member.getAlamatPerusahaan()%>" class="formElemen"  size="50">
                                  <tr align="left"> 
                                    <td height="17" width="15%">Nama Penanggung</td>
                                    <td height="17" width="35%"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_NAMA_PENANGGUNG] %>"  value="<%=(member.getNamaPenanggung()==null)? "" : member.getNamaPenanggung()%>" class="formElemen"  size="50">
                                      <%= jspMember.getErrorMsg(JspMember.JSP_NAMA_PENANGGUNG) %> </td>
                                    <td height="17" width="15%">Telephone Perusahaan 
                                      / Kantor</td>
                                    <td height="17" colspan="2" width="35%" valign="top"> 
                                      <input type="text" name="<%=jspMember.fieldNames[JspMember.JSP_PHONE_PERUSAHAAN] %>"  value="<%=(member.getPhonePerusahaan()==null)?"":member.getPhonePerusahaan()%>" class="formElemen" >
                                  <tr align="left"> 
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" width="35%">&nbsp;</td>
                                    <td height="17" width="15%">&nbsp;</td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp; 
                                      <!--tr align="left"> 
                                    <td height="17" width="15%"><b>Jenis Simpanan</b></td>
                                    <td height="17" width="35%"> 
                                      
                                    </td>
                                    <td height="17" width="15%"><b>Jenis Pinjaman</b></td>
                                    <td height="17" colspan="2" width="35%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="17" valign="top" colspan="2"> 
                                      <table width="75%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                          <td width="28%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_SIBUHAR] %>"  value="1" <%if(member.getSibuhar()==1){%>checked<%}%> class="formElemen">
                                            Sibuhar </td>
                                          <td width="30%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_SIMPLE] %>"  value="1" <%if(member.getSimple()==1){%>checked<%}%> class="formElemen">
                                            Simple </td>
                                          <td width="42%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_SIRAYA] %>"  value="1" <%if(member.getSiraya()==1){%>checked<%}%> class="formElemen">
                                            Siraya </td>
                                        </tr>
                                        <tr> 
                                          <td width="28%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_SIMAPAN] %>"  value="1" <%if(member.getSimapan()==1){%>checked<%}%> class="formElemen">
                                            Simapan </td>
                                          <td width="30%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_SIMP_RENCANA] %>"  value="1" <%if(member.getSimpRencana()==1){%>checked<%}%> class="formElemen">
                                            Simp.Rencana </td>
                                          <td width="42%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_SISUKA] %>"  value="1" <%if(member.getSisuka()==1){%>checked<%}%> class="formElemen">
                                            Sisuka </td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td height="17" valign="top" colspan="3"> 
                                      <table width="92%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                          <td width="22%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_KUK] %>"  value="1" <%if(member.getKuk()==1){%>checked<%}%> class="formElemen">
                                            KUK </td>
                                          <td width="24%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_KMP] %>"  value="1" <%if(member.getKmp()==1){%>checked<%}%> class="formElemen">
                                            KMP </td>
                                          <td width="23%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_KIP] %>"  value="1" <%if(member.getKip()==1){%>checked<%}%> class="formElemen">
                                            KIP </td>
                                          <td width="31%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_KTM] %>"  value="1" <%if(member.getKtm()==1){%>checked<%}%> class="formElemen">
                                            KTM </td>
                                        </tr>
                                        <tr> 
                                          <td width="22%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_KPP] %>"  value="1" <%if(member.getKpp()==1){%>checked<%}%> class="formElemen">
                                            KPP </td>
                                          <td width="24%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_KIPER] %>"  value="1" <%if(member.getKiper()==1){%>checked<%}%> class="formElemen">
                                            KIPER </td>
                                          <td width="23%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_KIPERUM] %>"  value="1" <%if(member.getKiperum()==1){%>checked<%}%> class="formElemen">
                                            KIPERUM </td>
                                          <td width="31%"> 
                                            <input type="checkbox" name="<%=jspMember.fieldNames[JspMember.JSP_KHUSUS] %>"  value="1" <%if(member.getKhusus()==1){%>checked<%}%> class="formElemen">
                                            KHUSUS </td>
                                        </tr>
                                      </table>
                                    </td>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="15%">&nbsp;</td>
                                    <td height="8" valign="middle" width="35%">&nbsp;</td>
                                    <td height="8" valign="middle" width="15%">&nbsp;</td>
                                    <td height="8" colspan="2" width="35%" valign="top">&nbsp;</td>
                                  </tr-->
                                  <tr align="left"> 
                                    <td height="8" valign="middle" colspan="2"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                          <td width="30%">&nbsp;</td>
                                          <td width="70%">&nbsp; </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2"> 
                                            <%
									ctrLine.setLocationImg(approot+"/images/ctr_line");
									ctrLine.initDefault();
									ctrLine.setTableWidth("80%");
									String scomDel = "javascript:cmdAsk('"+oidMember+"')";
									String sconDelCom = "javascript:cmdConfirmDelete('"+oidMember+"')";
									String scancel = "javascript:cmdEdit('"+oidMember+"')";
									ctrLine.setBackCaption("Lihat Daftar");
									ctrLine.setJSPCommandStyle("buttonlink");
										ctrLine.setDeleteCaption("Hapus !");
										ctrLine.setSaveCaption("Simpan");
										ctrLine.setAddCaption("Entry Member Baru");
										ctrLine.setCancelCaption("Batalkan");
										ctrLine.setConfirmDelCaption("Ya Hapus !");

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
									if(iJSPCommand==JSPCommand.SUBMIT){
										if(member.getOID()==0){
											iJSPCommand=JSPCommand.ADD;
										}else{
											iJSPCommand=JSPCommand.EDIT;
										}
									}
									
									%>
                                            <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td height="8" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                        <tr> 
                                          <td width="30%">Status</td>
                                          <td width="70%"> 
                                            <select name="<%=jspMember.fieldNames[JspMember.JSP_STATUS]%>">
                                              <%
								for(int i=0;i<DbMember.status.length;i++){
							%>
                                              <option value="<%=i%>" <%if(member.getStatus()==i){%>selected<%}%>><%=DbMember.status[i]%></option>
                                              <%
								}
							%>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="30%">Tanggal Keluar</td>
                                          <td width="70%"> 
                                            <input name="<%=jspMember.fieldNames[JspMember.JSP_TGL_KELUAR] %>" value="<%=(member.getTglKeluar()==null) ? "" : JSPFormater.formatDate(member.getTglKeluar(), "dd/MM/yyyy")%>" size="11">
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmember.<%=jspMember.fieldNames[JspMember.JSP_TGL_KELUAR] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="15%">&nbsp;</td>
                                    <td height="8" valign="middle" width="35%">&nbsp;</td>
                                    <td height="8" valign="middle" width="15%">&nbsp;</td>
                                    <td height="8" colspan="2" width="35%" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="5" class="command" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <%if(member.getOID()!=0){%>
                                  <tr> 
                                    <td colspan="4">&nbsp; </td>
                                  </tr>
                                  <%}%>
                                  <tr align="left" > 
                                    <td colspan="5" valign="top"> 
                                      <div align="left"></div>
                                    </td>
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
            <%@ include file="../main/footer.jsp" %>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
