 
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.coorp.pinjaman.*" %>
<%@ page import = "com.project.coorp.member.*" %>
<%@ page import = "com.project.coorp.report.*" %>
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

int iJSPCommand = JSPRequestValue.requestCommand(request);

Vector saldos = DbSimpananMember.getSaldoSimpanan();

%>
<html >
<!-- #BeginTemplate "/Templates/indexsp.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../css/csssp.css" rel="stylesheet" type="text/css" />
<title><%=spTitle%></title>
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

function checkNumber(obj){
	var st = obj.value;
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function cmdPrintDetailXLS(){	 
	window.open("<%=printrootsp%>.report.RptSaldoAnggotaXLS?idx=<%=System.currentTimeMillis()%>");
}


//-------------- script form image -------------------

function cmdDelPict(oidSimpananMember){
	document.frmimage.hidden_simpanan_member_id.value=oidSimpananMember;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="simpananmember.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/imagessp/home2.gif','<%=approot%>/imagessp/logout2.gif','<%=approot%>/images/ctr_line/BtnNewOn.jpg')">
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
                                                <td width="7%"><b><font size="2">DAFTAR 
                                                  SALDO SIMPANAN ANGGOTA &nbsp;</font></b></td>
                                              </tr>
                                              <tr> 
                                                <td width="7%"><b><font size="2">POSISI 
                                                  <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy").toUpperCase()%></font></b></td>
                                              </tr>
                                              <tr> 
                                                <td width="7%">&nbsp;</td>
                                              </tr>
                                              <tr>
                                                <td width="7%">
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td class="tablehdr" rowspan="2">NO</td>
                                                      <td class="tablehdr" rowspan="2">NIK</td>
                                                      <td class="tablehdr" rowspan="2">NAMA</td>
                                                      <td class="tablehdr" rowspan="2">DINAS</td>
                                                      <td class="tablehdr" rowspan="2">STATUS</td>
                                                      <td class="tablehdr" colspan="4">SALDO 
                                                        SIMPANAN </td>
                                                      <td class="tablehdr" rowspan="2">JUMLAH</td>
                                                    </tr>
                                                    <tr> 
                                                      <td class="tablehdr" width="9%">POKOK</td>
                                                      <td class="tablehdr" width="10%">WAJIB</td>
                                                      <td class="tablehdr" width="10%">SHU/ALOKASI 
                                                        '08 </td>
                                                      <td class="tablehdr" width="10%">SUKARELA</td>
                                                    </tr>
                                                    <%
													
													Vector tempReport = new Vector();
													
													double totalPokok = 0;
													double totalWajib = 0;
													double totalSukarelaSku = 0;
													double totalSukarela = 0;
													
													if(saldos!=null && saldos.size()>0){
														
														long prevDinas = 0;
														int idx = 0;
													
														for(int i=0; i<saldos.size(); i++){
															
															Vector temp = (Vector)saldos.get(i);
															SimpananMember sm = (SimpananMember)temp.get(0);
															Member member = (Member)temp.get(1);
															Dinas dinas = (Dinas)temp.get(2);
															
															totalPokok = totalPokok + sm.getPokok();
															totalWajib = totalWajib + sm.getWajib();
															totalSukarelaSku = totalSukarelaSku + sm.getSukarelaShu();
															totalSukarela = totalSukarela + sm.getSukarelaTabungan();
															
															if(prevDinas!=dinas.getOID()){
															
																prevDinas = dinas.getOID();
																idx = 0;
																
																//=========report==================
																ObjSaldoAnggota osa = new ObjSaldoAnggota();
																osa.setNama(dinas.getNama().toUpperCase());
																osa.setType(0);
																tempReport.add(osa);
																//=================================
															
															%>
                                                    <tr> 
                                                      <td colspan="3"> 
                                                        <div align="left"><b><%=dinas.getNama().toUpperCase()%></b></div>
                                                      </td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                    </tr>
                                                    <%}
															
															
															if(i%2==0){
																
																idx = idx + 1;
																
																//=========report==================
																ObjSaldoAnggota osa = new ObjSaldoAnggota();
																osa.setDatel(dinas.getNama());
																osa.setType(1);
																osa.setNama(member.getNama().toUpperCase());
																osa.setNik(member.getNoMember());
																osa.setNo(idx);
																osa.setPokok(sm.getPokok());
																osa.setWajib(sm.getWajib());
																osa.setShu(sm.getSukarelaShu());
																osa.setSukarela(sm.getSukarelaTabungan());
																osa.setStatus(member.getStatus());
																
																tempReport.add(osa);
																//=================================
														
													%>
                                                    <tr> 
                                                      <td width="2%" class="tablecell1"> 
                                                        <div align="right"><%=idx%></div>
                                                      </td>
                                                      <td width="7%" class="tablecell1"> 
                                                        <div align="center"><%=member.getNoMember()%></div>
                                                      </td>
                                                      <td width="19%" class="tablecell1"><%=member.getNama().toUpperCase()%></td>
                                                      <td width="11%" class="tablecell1"><%=dinas.getNama()%></td>
                                                      <td width="10%" class="tablecell1"> 
                                                        <div align="center"><%=DbMember.status[member.getStatus()]%></div>
                                                      </td>
                                                      <td width="9%" class="tablecell1"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getPokok(), "#,###")%></div>
                                                      </td>
                                                      <td width="10%" class="tablecell1"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getWajib(), "#,###")%></div>
                                                      </td>
                                                      <td width="10%" class="tablecell1"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getSukarelaShu(), "#,###")%></div>
                                                      </td>
                                                      <td width="10%" class="tablecell1"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getSukarelaTabungan(), "#,###")%></div>
                                                      </td>
                                                      <td width="12%" class="tablecell1"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getPokok()+sm.getWajib()+sm.getSukarelaShu()+sm.getSukarelaTabungan(), "#,###")%></div>
                                                      </td>
                                                    </tr>
                                                    <%}else{
															idx = idx + 1;
															
															//=========report==================
															ObjSaldoAnggota osa = new ObjSaldoAnggota();
															osa.setDatel(dinas.getNama());
															osa.setType(1);
															osa.setNama(member.getNama().toUpperCase());
															osa.setNik(member.getNoMember());
															osa.setNo(idx);
															osa.setPokok(sm.getPokok());
															osa.setWajib(sm.getWajib());
															osa.setShu(sm.getSukarelaShu());
															osa.setSukarela(sm.getSukarelaTabungan());
															osa.setStatus(member.getStatus());
															
															tempReport.add(osa);
															//=================================
														
													%>
                                                    <tr> 
                                                      <td width="2%" class="tablecell"> 
                                                        <div align="right"><%=idx%></div>
                                                      </td>
                                                      <td width="7%" class="tablecell"> 
                                                        <div align="center"><%=member.getNoMember()%></div>
                                                      </td>
                                                      <td width="19%" class="tablecell"><%=member.getNama().toUpperCase()%></td>
                                                      <td width="11%" class="tablecell"><%=dinas.getNama()%></td>
                                                      <td width="10%" class="tablecell"> 
                                                        <div align="center"><%=DbMember.status[member.getStatus()]%></div>
                                                      </td>
                                                      <td width="9%" class="tablecell"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getPokok(), "#,###")%></div>
                                                      </td>
                                                      <td width="10%" class="tablecell"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getWajib(), "#,###")%></div>
                                                      </td>
                                                      <td width="10%" class="tablecell"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getSukarelaShu(), "#,###")%></div>
                                                      </td>
                                                      <td width="10%" class="tablecell"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getSukarelaTabungan(), "#,###")%></div>
                                                      </td>
                                                      <td width="12%" class="tablecell"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(sm.getPokok()+sm.getWajib()+sm.getSukarelaShu()+sm.getSukarelaTabungan(), "#,###")%></div>
                                                      </td>
                                                    </tr>
                                                    <%}}}%>
                                                    <tr> 
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                      <td width="19%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                      <td width="19%"> 
                                                        <div align="center"><b>T 
                                                          O T A L :</b></div>
                                                      </td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%"> 
                                                        <div align="right"><b><%=JSPFormater.formatNumber(totalPokok, "#,###")%></b></div>
                                                      </td>
                                                      <td width="10%"> 
                                                        <div align="right"><b><%=JSPFormater.formatNumber(totalWajib, "#,###")%></b></div>
                                                      </td>
                                                      <td width="10%"> 
                                                        <div align="right"><b><%=JSPFormater.formatNumber(totalSukarelaSku, "#,###")%></b></div>
                                                      </td>
                                                      <td width="10%"> 
                                                        <div align="right"><b><%=JSPFormater.formatNumber(totalSukarela, "#,###")%></b></div>
                                                      </td>
                                                      <td width="12%"> 
                                                        <div align="right"><b><%=JSPFormater.formatNumber(totalPokok + totalWajib + totalSukarelaSku + totalSukarela, "#,###")%></b></div>
                                                      </td>
                                                    </tr>
													<%
													
													//=========report==================
													ObjSaldoAnggota osa = new ObjSaldoAnggota();
													//osa.setDatel(dinas.getNama());
													osa.setType(2);
													//osa.setNama(member.getNama());
													//osa.setNik(member.getNoMember());
													//osa.setNo(idx);
													osa.setPokok(totalPokok);
													osa.setWajib(totalWajib);
													osa.setShu(totalSukarelaSku);
													osa.setSukarela(totalSukarela);
													//osa.setStatus(member.getStatus());
													
													tempReport.add(osa);
													//=================================
													
													session.putValue("SALDO_ANGGOTA", tempReport);
													
													%>
                                                    <tr> 
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="7%">&nbsp;</td>
                                                      <td width="19%">&nbsp;</td>
                                                      <td width="11%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="10%">&nbsp;</td>
                                                      <td width="12%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="7%"><a href="javascript:cmdPrintDetailXLS()"><img src="../images/printxls.gif" width="120" height="22" border="0"></a></td>
                                              </tr>
                                              <tr> 
                                                <td>&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td width="7%">&nbsp;</td>
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
