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

	public Vector drawList(Vector objectClass ,  long memberId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setCellStyle1("tablecell1");
		ctrlist.setHeaderStyle("tablehdr");
		
		ctrlist.addHeader("N.B.A","7%");
		ctrlist.addHeader("Nama","15%");
		ctrlist.addHeader("Alamat","15%");
		ctrlist.addHeader("J.Kelamin","7%");
		ctrlist.addHeader("Agama","10%");
		ctrlist.addHeader("Kecamatan","10%");
		ctrlist.addHeader("Desa","10%");
		//ctrlist.addHeader("Jenis Simpanan","15%");
		//ctrlist.addHeader("Jenis Pinjaman","15%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;
		
		Vector temp = new Vector();

		for (int i = 0; i < objectClass.size(); i++) {
			Member member = (Member)objectClass.get(i);
			//for set value to print report
			DataMember dtC = new DataMember();
			 
			 Vector rowx = new Vector();
			 
			 if(memberId == member.getOID())
				 index = i;

			rowx.add(member.getNoMember());
			dtC.setNoMember(member.getNoMember());

			rowx.add(member.getNama());
			dtC.setNama(member.getNama());

			rowx.add(member.getAlamat());
			dtC.setAlamat(member.getAlamat());
			
			String sex = "";
			if(member.getJenisKelamin()==0){
				sex = "Pria";
			}else{
				sex = "Wanita";
			}
			
			rowx.add(sex);
			dtC.setJenisKelamin(sex);
			
			rowx.add(member.getAgama());
			dtC.setAgama(member.getAgama());
			
			Kecamatan keca = new Kecamatan();
			try{
				keca = DbKecamatan.fetchExc(member.getKecamatanId());
			}catch(Exception e){
			}
			
			rowx.add(keca.getNama());
			dtC.setKecamatan(keca.getNama());
			
			
			Desa ds = new Desa();
			try{
				ds = DbDesa.fetchExc(member.getDesaId());
			}catch(Exception e){
			}
			
			rowx.add(ds.getNama());
			dtC.setDesa(ds.getNama());
			
			//simpanan
			String simpanan = "";
			if(member.getSibuhar()==1){
				simpanan = "Sibuhar";
			}
			
			if(member.getSimple()==1){
				simpanan = simpanan +" , "+"Simple";
			}else{
				simpanan = "Simple";
			}
			if(member.getSiraya()==1){
				simpanan = simpanan +" , "+"Siraya";
			}
			if(member.getSimapan()==1){
				simpanan = simpanan +" , "+"Simapan";
			}
			if(member.getSimpRencana()==1){
				simpanan = simpanan +" , "+"Simp.Rencana";
			}
			if(member.getSisuka()==1){
				simpanan = simpanan +" , "+"Sisuka";
			}
			
			//rowx.add(simpanan);
			dtC.setJenisSimpanan(simpanan);
			
			//pinjaman
			String pinjaman = "";
			if(member.getKuk()==1){
				pinjaman = "KUK";
			}
			if(member.getKmp()==1){
				pinjaman = pinjaman +" , "+"KMP";
			}
			if(member.getKip()==1){
				pinjaman = pinjaman +" , "+"KIP";
			}
			if(member.getKtm()==1){
				pinjaman = pinjaman +" , "+"KTM";
			}
			if(member.getKpp()==1){
				pinjaman = pinjaman +" , "+"KPP";
			}
			if(member.getKiper()==1){
				pinjaman = pinjaman +" , "+"KIPER";
			}
			if(member.getKiperum()==1){
				pinjaman = pinjaman +" , "+"KIPERUM";
			}
			if(member.getKhusus()==1){
				pinjaman = pinjaman +" , "+"KHUSUS";
			}
			
			//rowx.add(pinjaman);
			dtC.setJenisPinjaman(pinjaman);

			
			lstData.add(rowx);
			lstLinkData.add(String.valueOf(member.getOID()));
			
			temp.add(dtC);
		}
		
		Vector vc = new Vector();
		vc.add(ctrlist.draw(index));
		vc.add(temp);
		return vc;
		//return ctrlist.draw(index);
	}

%>
<%

    if(session.getValue("CUSTOMER_REPORT")!=null){
			session.removeValue("CUSTOMER_REPORT");
	}


int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidMember = JSPRequestValue.requestLong(request, "hidden_member_id");
long oidKecamatan = JSPRequestValue.requestLong(request, "src_kecamatan");
long oidDesa = JSPRequestValue.requestLong(request, "src_desa");
long oidPekerjaan = JSPRequestValue.requestLong(request, "src_pekerjaan");
//Request value
String srcNoMember = JSPRequestValue.requestString(request, "src_no_member");
String srcNama = JSPRequestValue.requestString(request, "src_nama");
String srcAlamat = JSPRequestValue.requestString(request, "src_alamat");
int srcJenisKelamin = JSPRequestValue.requestInt(request, "src_jenis_kelamin");
String srcAgama = JSPRequestValue.requestString(request, "src_agama");
//jenis simpanan
int srcSibuhar = JSPRequestValue.requestInt(request, "src_sibuhar");
int srcSimple = JSPRequestValue.requestInt(request, "src_simple");
int srcSiraya = JSPRequestValue.requestInt(request, "src_siraya");
int srcSimapan = JSPRequestValue.requestInt(request, "src_simapan");
int srcSimpRencana = JSPRequestValue.requestInt(request, "src_simp_rencana");
int srcSisuka = JSPRequestValue.requestInt(request, "src_sisuka");
//jenis pinjaman
int srcKuk = JSPRequestValue.requestInt(request, "src_kuk");
int srcKmp = JSPRequestValue.requestInt(request, "src_kmp");
int srcKip = JSPRequestValue.requestInt(request, "src_kip");
int srcKtm = JSPRequestValue.requestInt(request, "src_ktm");
int srcKpp = JSPRequestValue.requestInt(request, "src_kpp");
int srcKiper = JSPRequestValue.requestInt(request, "src_kiper");
int srcKiperum = JSPRequestValue.requestInt(request, "src_kiperum");
int srcKhusus = JSPRequestValue.requestInt(request, "src_khusus");
//tanggal
String srcTglStart = JSPRequestValue.requestString(request, "src_tgl_lahir_1");
String srcTglEnd = JSPRequestValue.requestString(request, "src_tgl_lahir_2");

Date srcTglLahir1 = JSPFormater.formatDate(srcTglStart, "dd/MM/yyyy");
Date srcTglLahir2 = JSPFormater.formatDate(srcTglEnd,"dd/MM/yyyy");
//batas
int srcBatas = JSPRequestValue.requestInt(request, "src_batas");

int srcStatus = JSPRequestValue.requestInt(request, "src_status");

if(iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.BACK){
	srcBatas = 1;//biar tercheck
	srcJenisKelamin = -1;
	srcStatus = 1;
}

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

//kecamatan dan desa
/*
Kecamatan kct = new Kecamatan();
Vector listKct = DbKecamatan.list(0,0,"","");
if(oidKecamatan==0 && listKct!=null && listKct.size()>0){
	Kecamatan kctt = (Kecamatan)listKct.get(0);
	oidKecamatan = kctt.getOID();
}
*/

/*
Desa ds = new Desa();
Vector listDs = DbDesa.list(0,0,"kecamatan_id ="+oidKecamatan,"");
if(oidDesa==0 && listDs!=null && listDs.size()>0){
	    Desa dss = (Desa)listDs.get(0);
		oidDesa = dss.getOID();
}
*/

//int vectSize = DbMember.getCount(whereClause);
int vectSize = SessMember.getCountMember(srcNoMember, srcNama, srcAlamat, srcJenisKelamin, oidKecamatan, oidDesa, srcAgama,
                                    srcTglLahir1, srcTglLahir2, srcSibuhar, srcSimple, srcSiraya, srcSimapan, srcSimpRencana, srcSisuka, 
                                    srcKuk, srcKmp, srcKip, srcKtm, srcKpp, srcKiper, srcKiperum, srcKhusus, srcBatas, oidPekerjaan, srcStatus);
									

Member member = ctrlMember.getMember();
msgString =  ctrlMember.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlMember.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
//listMember = DbMember.list(start,recordToGet, whereClause , orderClause);
listMember = SessMember.getMember(start, recordToGet, srcNoMember, srcNama, srcAlamat, srcJenisKelamin, oidKecamatan, oidDesa,
                                    srcAgama, srcTglLahir1, srcTglLahir2, srcSibuhar, srcSimple, srcSiraya, srcSimapan, srcSimpRencana, srcSisuka, 
                                    srcKuk, srcKmp, srcKip, srcKtm, srcKpp, srcKiper, srcKiperum, srcKhusus, srcBatas, oidPekerjaan, srcStatus);
									

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
	  //listMember = DbMember.list(start,recordToGet, whereClause , orderClause);
	 listMember = SessMember.getMember(start, recordToGet, srcNoMember, srcNama, srcAlamat, srcJenisKelamin, oidKecamatan, oidDesa,
                                    srcAgama, srcTglLahir1, srcTglLahir2, srcSibuhar, srcSimple, srcSiraya, srcSimapan, srcSimpRencana, srcSisuka, 
                                    srcKuk, srcKmp, srcKip, srcKtm, srcKpp, srcKiper, srcKiperum, srcKhusus, srcBatas, oidPekerjaan, srcStatus);
									
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

function cmdPrintAll(oidMember){	 
	window.open("<%=printroot%>.report.MemberListPdf?oid=<%=oidMember%>&idx=<%=System.currentTimeMillis()%>");
}

function cmdAdd(){
	document.frmmember.hidden_member_id.value="0";
	document.frmmember.command.value="<%=JSPCommand.ADD%>";
	document.frmmember.prev_command.value="<%=prevJSPCommand%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
}

function cmdSearch(){
	document.frmmember.command.value="<%=JSPCommand.LIST%>";
	document.frmmember.action="scrmember.jsp";
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
	document.frmmember.command.value="<%=JSPCommand.BACK%>";
	document.frmmember.action="member.jsp";
	document.frmmember.submit();
	}

function cmdListFirst(){
	document.frmmember.command.value="<%=JSPCommand.FIRST%>";
	document.frmmember.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmmember.action="scrmember.jsp";
	document.frmmember.submit();
}

function cmdListPrev(){
	document.frmmember.command.value="<%=JSPCommand.PREV%>";
	document.frmmember.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmmember.action="scrmember.jsp";
	document.frmmember.submit();
	}

function cmdListNext(){
	document.frmmember.command.value="<%=JSPCommand.NEXT%>";
	document.frmmember.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmmember.action="scrmember.jsp";
	document.frmmember.submit();
}

function cmdListLast(){
	document.frmmember.command.value="<%=JSPCommand.LAST%>";
	document.frmmember.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmmember.action="scrmember.jsp";
	document.frmmember.submit();
}

function cmdRefres(oidMember){
	document.frmmember.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmmember.hidden_member_id.value=oidMember;
	document.frmmember.action="scrmember.jsp";
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
					  String navigator = "<font class=\"lvl1\">Keanggotaan</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Pencarian Anggota</span></font>";
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
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                        <tr> 
                                          <td colspan="4" height="5"></td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">NIK</td>
                                          <td width="42%"> 
                                            <input type="text" name="src_no_member" value="<%=srcNoMember%>">
                                          </td>
                                          <td width="10%">Jenis Kelamin</td>
                                          <td width="38%"> 
                                            <select name="src_jenis_kelamin">
                                              <option value="-1" <%if(srcJenisKelamin==-1){%>selected<%}%>>Select 
                                              ...</option>
                                              <option value="0" <%if(srcJenisKelamin==0){%>selected<%}%>>Pria</option>
                                              <option value="1" <%if(srcJenisKelamin==1){%>selected<%}%>>Wanita</option>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Nama Member</td>
                                          <td width="42%"> 
                                            <input type="text" name="src_nama" value="<%=srcNama%>" size="45">
                                          </td>
                                          <td width="10%">Pekerjaan </td>
                                          <td width="38%"> 
                                            <select name="src_pekerjaan">
                                              <option value="0">Select ... </option>
                                              <%
									Vector listPekerjaan = DbPekerjaan.list(0,0, "","nama");
									if(listPekerjaan!=null && listPekerjaan.size()>0){
										for(int i=0;i<listPekerjaan.size();i++){
											Pekerjaan pekerjaan = (Pekerjaan)listPekerjaan.get(i);
								   %>
                                              <option value="<%=pekerjaan.getOID()%>" <%if(oidPekerjaan==pekerjaan.getOID()){%>selected<%}%>><%=pekerjaan.getNama()%></option>
                                              <% 
								       } 
								   } 
								 %>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%">Tanggal Lahir</td>
                                          <td width="42%" nowrap> 
                                            <input name="src_tgl_lahir_1"   value="<%=JSPFormater.formatDate((srcTglLahir1==null) ? new Date() : srcTglLahir1, "dd/MM/yyyy")%>" size="11" >
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmember.src_tgl_lahir_1);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            &nbsp;sampai tanggal 
                                            <input name="src_tgl_lahir_2"   value="<%=JSPFormater.formatDate((srcTglLahir2==null) ? new Date() : srcTglLahir2, "dd/MM/yyyy")%>" size="11" >
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmember.src_tgl_lahir_2);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                            <input type="checkbox" name="src_batas" value="1" <%if(srcBatas==1){%>checked<%}%>>
                                            &nbsp;abaikan</td>
                                          <td width="10%">agama</td>
                                          <td width="38%"> 
                                            <select name="src_agama">
                                              <option value="">Select ...</option>
                                              <%
								String strAgama = "";
								for(int i=0;i<DbMember.agamaKey.length;i++){
									strAgama = DbMember.agamaKey[i];
							%>
                                              <option value="<%=strAgama%>" <%if(((srcAgama==null) ? "" : strAgama).equals(srcAgama)){%>selected<%}%>><%=strAgama%></option>
                                              <%
								}
							%>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="10%" height="20">&nbsp;</td>
                                          <td width="42%" height="20">&nbsp; </td>
                                          <td width="10%" height="20">Status Keanggotaan</td>
                                          <td width="38%" height="20"> 
                                            <select name="src_status">
                                              <%
								for(int i=0;i<DbMember.status.length;i++){
							     %>
                                              <option value="<%=i%>" <%if(srcStatus==i){%>selected<%}%>><%=DbMember.status[i]%></option>
                                              <%
								}
							%>
                                            </select>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" height="5"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="2" cellpadding="3">
                                        <tr> 
                                          <td width="3%"><a href="javascript:cmdSearch()"><img src="../images/search.jpg" alt="Cari" width="25" border="0"></a></td>
                                          <td width="10%"><a href="javascript:cmdSearch()">Cari</a></td>
                                          <td width="2%">&nbsp;</td>
                                          <td width="3%"><a href="javascript:cmdAdd()"><img src="../images/ctr_line/BtnNew.jpg" alt="Cari" width="24" height="24" border="0"></a></td>
                                          <td width="58%" nowrap><a href="javascript:cmdAdd()">Entry 
                                            Member Baru </a></td>
                                          <td width="12%">&nbsp;</td>
                                          <td width="12%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="15" valign="middle" colspan="3">&nbsp; 
                                    </td>
                                  </tr>
                                  <%
							try{
								if (listMember.size()>0){
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <%
							  Vector x = drawList(listMember,oidMember);
							  String listStr = (String)x.get(0);
							  Vector objRpt = (Vector)x.get(1);
						  %>
                                      <%= listStr %> 
                                      <%
							session.putValue("CUSTOMER_REPORT",objRpt);
						  %>
                                    </td>
                                  </tr>
                                  <%  } 
					  else{%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3">&nbsp;&nbsp;<font color="#FF0000">data 
                                      kosong ...</font></td>
                                  </tr>
                                  <%}
						  }catch(Exception exc){ 
						  }%>
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" colspan="3" class="command"> 
                                      <span class="command"> 
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
                                      <% ctrLine.setLocationImg(approot+"/images");
							   	ctrLine.initDefault();
								 %>
                                      <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
                                  </tr>
                                  <%if (false){//listMember.size()>0){%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                        <tr> 
                                          <td colspan="5" height="5"></td>
                                        </tr>
                                        <tr> 
                                          <td width="4%"><a href="javascript:cmdPrintAll()"><img src="../images/ctr_line/print.jpg" alt="Cetak" width="30" border="0"></a></td>
                                          <td width="54%"><a href="javascript:cmdPrintAll()">Cetak 
                                            / Print</a></td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="13%">&nbsp;</td>
                                          <td width="16%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3">&nbsp; </td>
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
