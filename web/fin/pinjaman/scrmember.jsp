<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% //int  appObjCode = ObjInfo.composeObjCode(ObjInfo.G1_MASTERDATA, ObjInfo.G2_MD_COMPANY, ObjInfo.OBJ_DIVISION); %>
<%@ include file = "../main/checksp.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
boolean privNone = true;
%>
<!-- Jsp Block -->
<%!

	public Vector drawList(Vector objectClass)

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
			lstLinkData.add(String.valueOf(member.getOID())+"','"+member.getNoMember()+"','"+member.getNama());
			
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

//Request value
String srcNoMember = JSPRequestValue.requestString(request, "src_no_member");
String srcNama = JSPRequestValue.requestString(request, "src_nama");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
if(srcNoMember!=null && srcNoMember.length()>0){
	whereClause = "no_member like '%"+srcNoMember+"%'";
}

if(srcNama!=null && srcNama.length()>0){
	if(whereClause.length()>0){
		whereClause = whereClause + " and nama like '%"+srcNama+"%'";
	}
	else{
		whereClause = "nama like '%"+srcNama+"%'";
	}	
}
String orderClause = "";

CmdMember ctrlMember = new CmdMember(request);
JSPLine ctrLine = new JSPLine();
Vector listMember = new Vector(1,1);

/*switch statement */


/* end switch*/

/*count list All Member*/

//kecamatan dan desa
int vectSize = DbMember.getCount(whereClause);

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlMember.actionList(iJSPCommand, start, vectSize, recordToGet);
} 

listMember = DbMember.list(start,recordToGet, whereClause, "nama");





%>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=spTitle%></title>
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">

function cmdSearch(){
	document.frmmember.start.value="0";
	document.frmmember.command.value="<%=JSPCommand.LIST%>";
	document.frmmember.action="scrmember.jsp";
	document.frmmember.submit();
}

function cmdEdit(oid, nip, nama){
	self.opener.frmpinjaman.<%=JspPinjaman.colNames[JspPinjaman.JSP_MEMBER_ID] %>.value=oid;
	self.opener.frmpinjaman.anggota.value=nip+"/"+nama;
	self.close();
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

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.imagessp){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td> 
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                          <tr> 
                            <td valign="top"> 
                              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                <tr> 
                                  <td valign="top"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                      <!--DWLayoutTable-->
                                      <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                          <%@ include file="../calendar/calendarframe.jsp"%>
                                        </td>
                                        <td width="100%" valign="top"> 
                                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr> 
                                              <td>&nbsp;</td>
                                            </tr>
                                            <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                                            <tr> 
                                              <td> 
                                                <form name="frmmember" method ="post" action="">
                                                  <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                  <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                  <input type="hidden" name="start" value="<%=start%>">
                                                  <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr align="left" valign="top"> 
                                                      <td height="8"  colspan="3" class="container"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr align="left" valign="top"> 
                                                            <td height="14" valign="middle" colspan="3"><span class="level1"><b>Keanggotaan</b></span> 
                                                              <b>&raquo; <span class="level2">Pencarian 
                                                              Anggota</span></b> 
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="14" valign="middle" colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                                                <tr> 
                                                                  <td colspan="5" height="5"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="6%" nowrap>No 
                                                                    Anggota</td>
                                                                  <td width="14%"> 
                                                                    <input type="text" name="src_no_member" value="<%=srcNoMember%>">
                                                                  </td>
                                                                  <td width="3%" nowrap><img src="../images/spacer.gif" width="10" height="1"></td>
                                                                  <td width="6%" nowrap>Nama 
                                                                    Member</td>
                                                                  <td width="71%"> 
                                                                    <input type="text" name="src_nama" value="<%=srcNama%>" size="45">
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="5" height="5"></td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="3"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td width="3%"><a href="javascript:cmdSearch()"><img src="../images/search.jpg" alt="Cari" width="22" border="0"></a></td>
                                                                  <td width="35%"><a href="javascript:cmdSearch()">Cari 
                                                                    Data </a></td>
                                                                  <td width="14%">&nbsp;</td>
                                                                  <td width="24%">&nbsp;</td>
                                                                  <td width="24%">&nbsp;</td>
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
							  Vector x = drawList(listMember);
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
                                                            <td height="22" valign="middle" colspan="3">&nbsp;<font color="#FF0000">data 
                                                              tidak ditemukan</font></td>
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
                                                              <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								 %>
                                                              <%=ctrLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> 
                                                            </td>
                                                          </tr>
                                                          <%if (false){//listMember.size()>0){%>
                                                          <tr align="left" valign="top"> 
                                                            <td height="22" valign="middle" colspan="3">&nbsp; 
                                                            </td>
                                                          </tr>
                                                          <%}%>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                      <td height="8" valign="middle" colspan="3">&nbsp; 
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <script language="JavaScript">
window.focus();
</script>
                                                </form>
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
                                  <td height="25">&nbsp; </td>
                                </tr>
                              </table>
                            </td>
                          </tr>
                        </table>
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
          <td height="25">&nbsp; </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
