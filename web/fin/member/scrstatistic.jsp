<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>

<%@ page import = "com.project.e_member.report.*" %>
<%@ page import = "com.project.e_member.search.*" %>
<%@ page import = "com.project.e_member.session.*" %>
<%@ page import = "com.project.util.ChartGenerator"%>

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
<%!
public String drawList(Vector objectClass) {
    return "";
}
%>
<%

if(session.getValue("LAPORAN")!=null){
		session.removeValue("LAPORAN");
}
int iJSPCommand = JSPRequestValue.requestCommand(request);

SrcCustomerStatistic objSrcCustomer = new SrcCustomerStatistic();

int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCustomer = JSPRequestValue.requestLong(request, "hidden_customer_id");
int srcPilihan = JSPRequestValue.requestInt(request, "src_pilihan");

//object to get value
RptCustomerStatistic grap = new RptCustomerStatistic();
   //set option to selected
       objSrcCustomer.setPilihan(srcPilihan);
       grap.setPilihan(srcPilihan);
	   
/*variable declaration*/
int recordToGet = 2;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

if(iJSPCommand==JSPCommand.NONE){
	srcPilihan = -1;
}

Vector vctTable = new Vector();
switch(srcPilihan){
	case 0 :
			int pria = DbCustomer.getCount("jenis_kelamin = 0 and status = 1");
			Vector vct = new Vector();
			    vct.add("Pria");
				vct.add(""+pria);
			    vctTable.add(vct);
				
			int wanita = DbCustomer.getCount("jenis_kelamin = 1 and status = 1");
				Vector vct2 = new Vector();
				vct2.add("Wanita");
				vct2.add(""+wanita);
				vctTable.add(vct2);
	        break;
	case 1 :
			int sibuhar = DbCustomer.getCount("sibuhar = 1 and status = 1");
				Vector sbh = new Vector();
				sbh.add("Sibuhar");
				sbh.add(""+sibuhar);
				vctTable.add(sbh);
			int simple = DbCustomer.getCount("simple = 1 and status = 1");
				Vector smp = new Vector();
				smp.add("Simple");
				smp.add(""+simple);
				vctTable.add(smp);
			int siraya = DbCustomer.getCount("siraya = 1 and status = 1");
				Vector sr = new Vector();
				sr.add("Siraya");
				sr.add(""+siraya);
				vctTable.add(sr);
			int simapan = DbCustomer.getCount("simapan = 1 and status = 1");
				Vector simp = new Vector();
				simp.add("Simapan");
				simp.add(""+simapan);
				vctTable.add(simp);
			int rencana = DbCustomer.getCount("simp_rencana = 1 and status = 1");
				Vector smpR = new Vector();
				smpR.add("Simp.Rencana");
				smpR.add(""+rencana);
				vctTable.add(smpR);
			int sisuka = DbCustomer.getCount("sisuka = 1 and status = 1");
				Vector ssk = new Vector();
				ssk.add("Sisuka");
				ssk.add(""+sisuka);
				vctTable.add(ssk);	
	        break;
	case 2 :
			int kuku = DbCustomer.getCount("kuk = 1 and status = 1");
				Vector kukunya = new Vector();
				kukunya.add("KUK");
				kukunya.add(""+kuku);
				vctTable.add(kukunya);
			int kmpu = DbCustomer.getCount("kmp = 1 and status = 1");
				Vector kmpuu = new Vector();
				kmpuu.add("KMP");
				kmpuu.add(""+kmpu);
				vctTable.add(kmpuu);
			int kip = DbCustomer.getCount("kip = 1 and status = 1");
				Vector kipp = new Vector();
				kipp.add("KIP");
				kipp.add(""+kip);
				vctTable.add(kipp);
			int ktmm = DbCustomer.getCount("ktm = 1 and status = 1");
				Vector ktmmp = new Vector();
				ktmmp.add("KTM");
				ktmmp.add(""+ktmm);
				vctTable.add(ktmmp);
			int kppr = DbCustomer.getCount("kpp = 1 and status = 1");
				Vector kpprr = new Vector();
				kpprr.add("KPP");
				kpprr.add(""+kppr);
				vctTable.add(kpprr);
			int kpr = DbCustomer.getCount("kiper = 1 and status = 1");
				Vector kprr = new Vector();
				kprr.add("KIPER");
				kprr.add(""+kpr);
				vctTable.add(kprr);
			int kprm = DbCustomer.getCount("kiperum = 1 and status = 1");
				Vector kprmm = new Vector();
				kprmm.add("KIPERUM");
				kprmm.add(""+kprm);
				vctTable.add(kprmm);
			int khss = DbCustomer.getCount("khusus = 1 and status = 1");
				Vector khs = new Vector();
				khs.add("KHUSUS");
				khs.add(""+khss);
				vctTable.add(khs);	
	        break;
	case 3 :
			Vector listKecamatan = DbKecamatan.list(0,0,"","");
				if(listKecamatan != null && listKecamatan.size()>0){
					for(int i=0;i<listKecamatan.size();i++){
						Kecamatan kecamatan = (Kecamatan)listKecamatan.get(i);
						int daerah = DbCustomer.getCount("kecamatan_id = "+ kecamatan.getOID() +" and status = 1");
						Vector dst = new Vector();
							dst.add(kecamatan.getNama());
							dst.add(""+daerah);
							vctTable.add(dst);
					}
				}
	        break;
	case 4 :
			int hindu = DbCustomer.getCount("agama = 'hindu' and status = 1");
				Vector vHindu = new Vector();
				vHindu.add("Hindu");
				vHindu.add(""+hindu);
				vctTable.add(vHindu);
			int islam = DbCustomer.getCount("agama = 'islam' and status = 1");
				Vector vIslam = new Vector();
				vIslam.add("Islam");
				vIslam.add(""+islam);
				vctTable.add(vIslam);
			int bhuda = DbCustomer.getCount("agama = 'bhuda' and status = 1");
				Vector vBhuda = new Vector();
				vBhuda.add("Bhuda");
				vBhuda.add(""+bhuda);
				vctTable.add(vBhuda);
			int kKatolik = DbCustomer.getCount("agama = 'Kristen Katolik' and status = 1");
				Vector vKKatolik = new Vector();
				vKKatolik.add("Kristen Katolik");
				vKKatolik.add(""+kKatolik);
				vctTable.add(vKKatolik);
			int kProtestan = DbCustomer.getCount("agama = 'Kristen Protestan' and status = 1");
				Vector vKProtestan = new Vector();
				vKProtestan.add("Kristen Protestan");
				vKProtestan.add(""+kProtestan);
				vctTable.add(vKProtestan);
	        break;
	case 5 :
			Vector listPekerjaan = DbPekerjaan.list(0,0,"","");
				if(listPekerjaan != null && listPekerjaan.size()>0){
					for(int i=0;i<listPekerjaan.size();i++){
						Pekerjaan pekerjaan = (Pekerjaan)listPekerjaan.get(i);
						int pkr = DbCustomer.getCount("pekerjaan_id = "+ pekerjaan.getOID() +" and status = 1");
						Vector pst = new Vector();
							pst.add(pekerjaan.getNama());
							pst.add(""+pkr);
							vctTable.add(pst);
					}
				}
	        break;
}

//Vector result = new Vector(1,1);
   String chartImage = "";
   String chartName = "Laporan Statistic";
   JspWriter jspWriter = out;
   if(iJSPCommand == JSPCommand.LIST) {
       //result = SessCustomer.laporanStatistic(objSrcCustomer);
       chartImage = ChartGenerator.createChart(vctTable, chartroot, session, jspWriter, chartName);
       grap.setGambar(chartImage);
   }

%>
<html><!-- #BeginTemplate "/Templates/main.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>E-Member - Laporan Statistic</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/main.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!laporanStatistic){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdShowStatistic() {
	document.frmcustomer.command.value="<%=JSPCommand.VIEW%>";
	document.frmcustomer.action="scrstatistic.jsp";
	document.frmcustomer.submit();
}
    
function cmdPrintLaporan() {
	document.frmcustomer.command.value="<%=JSPCommand.PRINT%>";
	document.frmcustomer.action="laporan.jsp";
	document.frmcustomer.submit();
}

function cmdAdd(){
	document.frmcustomer.hidden_customer_id.value="0";
	document.frmcustomer.command.value="<%=JSPCommand.ADD%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}

function cmdSearch(){
	document.frmcustomer.command.value="<%=JSPCommand.LIST%>";
	document.frmcustomer.action="scrstatistic.jsp";
	document.frmcustomer.submit();
}

function cmdAsk(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.ASK%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}

function cmdConfirmDelete(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.DELETE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}
function cmdSave(){
	document.frmcustomer.command.value="<%=JSPCommand.SAVE%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
	}

function cmdEdit(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
	}

function cmdCancel(oidCustomer){
	document.frmcustomer.hidden_customer_id.value=oidCustomer;
	document.frmcustomer.command.value="<%=JSPCommand.EDIT%>";
	document.frmcustomer.prev_command.value="<%=prevJSPCommand%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
}

function cmdBack(){
	document.frmcustomer.command.value="<%=JSPCommand.BACK%>";
	document.frmcustomer.action="customer.jsp";
	document.frmcustomer.submit();
	}

function cmdListFirst(){
	document.frmcustomer.command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcustomer.action="srccustomer.jsp";
	document.frmcustomer.submit();
}

function cmdListPrev(){
	document.frmcustomer.command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcustomer.action="srccustomer.jsp";
	document.frmcustomer.submit();
	}

function cmdListNext(){
	document.frmcustomer.command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcustomer.action="srccustomer.jsp";
	document.frmcustomer.submit();
}

function cmdListLast(){
	document.frmcustomer.command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcustomer.action="srccustomer.jsp";
	document.frmcustomer.submit();
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

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" bottomargin="0" rightmargin="0" leftmargin="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr> 
    <td width="89%" height="73"> <!-- #BeginEditable "header" --> 
      <%@ include file="../main/header.jsp" %>
      <!-- #EndEditable -->
     
    </td>
  </tr>
  <tr> 
    <td width="89%" valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td width="13%" valign="top"> <!-- #BeginEditable "menu" --> 
            <%@ include file="../main/menu.jsp" %>
			<%@ include file="../calendar/calendarframe.jsp"%>
            <!-- #EndEditable --></td>
          <td width="87%" valign="top" background="../Templates/white"><!-- #BeginEditable "content" --> 
            <form name="frmcustomer" method ="post" action="">
              <input type="hidden" name="command" value="<%=iJSPCommand%>">
              <input type="hidden" name="hidden_customer_id" value="<%=oidCustomer%>">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="349">
                <tr align="left" valign="top"> 
                  <td height="371"  colspan="3"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr align="left" valign="top"> 
                        <td height="8" valign="middle" colspan="3">&nbsp; </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="14" valign="top" colspan="3"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="0">
                            <tr> 
                              <td colspan="12" height="22"><b>E-Member &gt; Laporan 
                                Statistic</b></td>
                            </tr>
                            <tr> 
                              <td width="2%" height="36"> 
                                <input type="radio" name="src_pilihan" value="0" <%if(srcPilihan==0){%>checked<%}%>>
                              </td>
                              <td width="12%" height="36"> Jenis Kelamin </td>
                              <td width="2%" height="36"> 
                                <input type="radio" name="src_pilihan" value="1" <%if(srcPilihan==1){%>checked<%}%>>
                              </td>
                              <td width="12%" height="36">Jenis Simpanan </td>
                              <td width="2%" height="36"> 
                                <input type="radio" name="src_pilihan" value="2" <%if(srcPilihan==2){%>checked<%}%>>
                              </td>
                              <td width="12%" height="36">Jenis Pinjaman </td>
                              <td width="2%" height="36"> 
                                <input type="radio" name="src_pilihan" value="3" <%if(srcPilihan==3){%>checked<%}%>>
                              </td>
                              <td width="12%" height="36">Daerah</td>
                              <td width="2%" height="36"> 
                                <input type="radio" name="src_pilihan" value="4" <%if(srcPilihan==4){%>checked<%}%>>
                              </td>
                              <td width="11%" height="36">Agama</td>
                              <td width="2%" height="36"> 
                                <input type="radio" name="src_pilihan" value="5" <%if(srcPilihan==5){%>checked<%}%>>
                              </td>
                              <td width="29%" height="36">Pekerjaan</td>
                            </tr>
                            <tr> 
                              <td colspan="12" height="5"></td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr align="left" valign="top"> 
                        <td height="22" valign="middle" colspan="3"> 
                          <table width="100%" border="0" cellspacing="2" cellpadding="3" height="21">
                            <tr> 
                              <td width="4%" height="19"><a href="javascript:cmdSearch()"><img src="../images/search.jpg" alt="Cari" width="25" border="0"></a></td>
                              <td width="13%" height="19"><a href="javascript:cmdSearch()">Tampilkan 
                                Statistic</a></td>
								<%if(srcPilihan!=-1){%>
                              <td width="4%" height="19"><a href="javascript:cmdPrintLaporan()"><img src="../images/ctr_line/print.jpg" alt="Cetak" width="30" border="0"></a></td>
                              <td width="20%" height="19"><a href="javascript:cmdPrintLaporan()">Cetak 
                                / Print</a></td>
								<%}%>
                              <td width="59%" height="19">&nbsp;</td>
                            </tr>
                          </table>
                        </td>
                      </tr>
                      <tr align="left" valign="top">
                        <td height="15" valign="middle" colspan="3">&nbsp;</td>
                      </tr>
                      <%
							try{
								if (vctTable!= null && vctTable.size()>0){
							%>
                      <tr align="left" valign="top"> 
                        <td valign="top" colspan="3">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td width="36%" height="43" valign="top"> 
                                <table width="319" border="0" cellspacing="2" cellpadding="0" class="listgen">
                                  <tr> 
                                    <td colspan="1"></td>
                                  </tr>
                                  <tr> 
                                    <td class="tableheader" width="206"> 
                                      <div align="center"> 
                                        <%if(srcPilihan==0){%>
                                        Jenis Kelamin 
                                        <%}%>
                                        <%if(srcPilihan==1){%>
                                        Jenis Simpanan 
                                        <%}%>
                                        <%if(srcPilihan==2){%>
                                        Jenis Pinjaman 
                                        <%}%>
                                        <%if(srcPilihan==3){%>
                                        Daerah 
                                        <%}%>
                                        <%if(srcPilihan==4){%>
                                        Agama 
                                        <%}%>
                                        <%if(srcPilihan==5){%>
                                        Pekerjaan 
                                        <%}%>
                                      </div>
                                    </td>
                                    <td class="tableheader" width="110"> 
                                      <div align="center">Jumlah</div>
                                    </td>
                                  </tr>
                                  <%
								   int total = 0;
								   if(vctTable != null && vctTable.size()>0){
								   	  for(int i=0;i<vctTable.size();i++){
									  	Vector x = (Vector)vctTable.get(i);
										
										String nl = (String)x.get(1);
										int nilai = Integer.parseInt(nl);
										
										total = total + nilai;
								  %>
                                  <tr class="cellStyle"> 
                                    <td width="206"><%=x.get(0)%></td>
                                    <td width="110"> 
                                      <div align="center"><%=(nilai==0)? "-" : nilai%></div>
                                    </td>
                                  </tr>
                                  <%
								      }
								   }
								  %>
                                  <tr bgcolor="#000000"> 
                                    <td colspan="2"></td>
                                  </tr>
                                  <tr> 
                                    <td width="206"> 
                                      <div align="right"><b>Total</b>&nbsp;</div>
                                    </td>
                                    <td width="110"> 
                                      <div align="center"><%=total%></div>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                              <td width="64%" height="43"> 
                                <div align="top"> 
                                  <% if(iJSPCommand == JSPCommand.LIST) { %>
                                  <table width="80%" cellspacing="1" cellpadding="0" border="0">
                                    <tr> 
                                      <td align="center" height="1"></td>
                                    </tr>
                                    <tr> 
                                      <td align="center">&nbsp;<img src="<%=chartImage%>" border=0></td>
                                    </tr>
                                    <tr> 
                                      <td align="center">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td align="center">&nbsp;</td>
                                    </tr>
                                  </table>
                                  <% } %>
                                  <%
									session.putValue("LAPORAN",grap);
								  %>
                                </div>
                              </td>
                            </tr>
                          </table>
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
                          <span class="command"> </span> </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr align="left" valign="top"> 
                  <td height="8" valign="middle" colspan="3">&nbsp; </td>
                </tr>
              </table>
            </form>
            <!-- #EndEditable --></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td width="89%" height="20"><!-- #BeginEditable "footer" --> 
      <%@ include file="../main/footer.jsp" %>
      <!-- #EndEditable --></td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
