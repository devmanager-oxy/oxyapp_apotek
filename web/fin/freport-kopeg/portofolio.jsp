 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.report.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%!

public String getDispayString(Coa coa, double val){
	
	String result = "";
	if(val<0){
		result = "("+JSPFormater.formatNumber(val*-1, "#,###")+")";
	}
	else if(val>0){
		result = JSPFormater.formatNumber(val, "#,###");
	}
	
	if(coa.getLevel()==1 || coa.getLevel()==2){
		result = "<b>"+result+"</b>";
	}
	
	return result;
}

public String getDispayString(double val){
	
	String result = "";
	if(val<0){
		result = "("+JSPFormater.formatNumber(val*-1, "#,###")+")";
	}
	else if(val>0){
		result = JSPFormater.formatNumber(val, "#,###");
	}
	
	return result;
}

%>
<%

	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}
	if(session.getValue("KONSTAN")!=null){
		session.removeValue("KONSTAN");
	}

//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
long periodeId = JSPRequestValue.requestLong(request, "src_periode_id");

Vector periodes = DbPeriode.list(0,0, "", "start_date desc");

Periode p = new Periode();

boolean isOpen = false;
if(periodeId==0){
	if(periodes!=null && periodes.size()>0){
		p =(Periode)periodes.get(0);
		periodeId = p.getOID();
		if(p.getStatus().equals("Open")){
			isOpen = true;
		}
	}
}
else{
	try{
		p = DbPeriode.fetchExc(periodeId);
		if(p.getStatus().equals("Open")){
			isOpen = true;
		}
	}
	catch(Exception e){
	}
}

//out.println("periodeId : "+periodeId);

String whereClause = "periode_id="+periodeId;
String orderClause = "type, coa_code";

//jika periode open, maka lakukan proses update value
if(isOpen && iJSPCommand==JSPCommand.POST){
	DbCoaPortofolioSetup.setPortofolioValue(periodeId);
}

//get list
Vector listCoaPortofolioSetup = DbCoaPortofolioSetup.list(0,0, whereClause , orderClause);

RptPortofolio rptKonstan = new RptPortofolio();

Vector objReport = new Vector();

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--

function cmdPrintXLS(){	 
	window.open("<%=printroot%>.report.RptPortofolioXLS?oid=<%=appSessUser.getLoginId()%>");
}

function cmdRecalculate(){
	document.form_rpt.command.value="<%=JSPCommand.POST%>";
	document.form_rpt.action="portofolio.jsp";
	document.form_rpt.submit();
}

function cmdChangePeriod(){
	document.form_rpt.command.value="<%=JSPCommand.LIST%>";
	document.form_rpt.action="portofolio.jsp";
	document.form_rpt.submit();
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
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
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Portofolio</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form_rpt" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="40%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td width="25%" nowrap><b>PERIODE : 
                                            <select name="src_periode_id" onChange="javascript:cmdChangePeriod()">
                                              <%if(periodes!=null && periodes.size()>0){
											  for(int i=0; i<periodes.size(); i++){
											  		Periode px = (Periode)periodes.get(i);
											  %>
                                              <option value="<%=px.getOID()%>" <%if(px.getOID()==periodeId){%>selected<%}%>><%=px.getName()%></option>
                                              <%}}%>
                                            </select>
                                            </b></td>
                                          <td width="75%"> 
                                            <%if(isOpen){%>
                                            <input type="button" name="Button" value="Recalculate" onClick="javascript:cmdRecalculate()">
											<%}%>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="17">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <div align="left"><font size="4"><b>PORTOFOLIO 
                                        USAHA BULAN <%=(JSPFormater.formatDate(p.getStartDate(), "MMMM yyyy")).toUpperCase()%></b></font>
									    <%
											rptKonstan.setPeriode(p.getStartDate());
										%>
									  </div>	
									</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="1800" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td rowspan="2" width="350" class="tablehdr">NAMA 
                                            PERKIRAAN</td>
                                          <td rowspan="2" width="100" class="tablehdr">TARGET 
                                            LABA<br>
                                            THN <%=(JSPFormater.formatDate(p.getStartDate(), "yyyy")).toUpperCase()%></td>
                                          <td rowspan="2" width="100" class="tablehdr">TARGET 
                                            LABA SD BLN INI</td>
                                          <td rowspan="2" width="100" class="tablehdr">TARGET 
                                            LABA BLN INI</td>
                                          <td colspan="3" class="tablehdr">REALISASI 
                                            SD BLN INI</td>
                                          <td rowspan="2" width="100" class="tablehdr">PENCAPAIAN 
                                            PROSENTASE LABA S/D</td>
                                          <td rowspan="2" width="100" class="tablehdr">TARGET 
                                            LABA BLN INI</td>
                                          <td colspan="3" class="tablehdr">REALISASI 
                                            BLN INI</td>
                                          <td rowspan="2" class="tablehdr">PENCAPAIAN 
                                            PROSENTASE LABA BLN INI</td>
                                          <td rowspan="2" width="250" class="tablehdr">KETERANGAN</td>
                                        </tr>
                                        <tr> 
                                          <td width="100" class="tablehdr">PDPT</td>
                                          <td width="100" class="tablehdr">BIAYA</td>
                                          <td width="100" class="tablehdr">LABA</td>
                                          <td width="100" class="tablehdr">PDPT</td>
                                          <td width="100" class="tablehdr">BIAYA</td>
                                          <td width="100" class="tablehdr">LABA</td>
                                        </tr>
                                        <tr> 
                                          <td width="350" height="19" nowrap> 
                                            <div align="center">1</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">2</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">3</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">3</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">4</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">5</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">6</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">7</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">8</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">9</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">10</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">11</div>
                                          </td>
                                          <td width="100" height="19" nowrap> 
                                            <div align="center">12</div>
                                          </td>
                                          <td width="250" height="19"> 
                                            <div align="center">13</div>
                                          </td>
                                        </tr>
                                        <%
										
										double grandTotalTargetLaba = 0;
										double grandTotalTargetLabaSD = 0;
										double grandTotalTargetLabaMth = 0;
										
										double grandTotalPdptSD = 0;
										double grandTotalBiayaSD = 0;
										double grandTotalLabaSD = 0;
										
										double grandTotalPdptMth = 0;
										double grandTotalBiayaMth = 0;
										double grandTotalLabaMth = 0;
										
										//-----------------
										
										double totalTargetLaba = 0;
										double totalTargetLabaSD = 0;
										double totalTargetLabaMth = 0;
										
										double totalPdptSD = 0;
										double totalBiayaSD = 0;
										double totalLabaSD = 0;
										
										double totalPdptMth = 0;
										double totalBiayaMth = 0;
										double totalLabaMth = 0;
										
										if(listCoaPortofolioSetup!=null && listCoaPortofolioSetup.size()>0){
										
										int pfType = 0;
										
										for(int i=0; i<listCoaPortofolioSetup.size(); i++){
											
											CoaPortofolioSetup pf = (CoaPortofolioSetup)listCoaPortofolioSetup.get(i);
											
											RptPortofolioL detail = new RptPortofolioL();
											
											Coa coa = new Coa();
											
											if(pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_INCOME 
            								|| pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_OTHER_INCOME){  
												try{
													coa = DbCoa.fetchExc(pf.getCoaRevenueId());	
												}
												catch(Exception e){
												}
											}
											else if(pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_OTHER_EXPENSE 
											|| pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_GENERAL_EXPENSE
											|| pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_INTEREST_EXPENSE
											|| pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_TAX_EXPENSE
											){ 
												try{
													coa = DbCoa.fetchExc(pf.getCoaExpenseId());	
												}
												catch(Exception e){
												}
											}
											
											
											String str = "";
											switch(coa.getLevel()){
												case 1 : 											
													break;
												case 2 : 
													str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													break;
												case 3 :
													str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													break;
												case 4 :
													str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													break;
												case 5 :
													str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													break;				
											}
											
											
											double targetLabaThnIni = pf.getTargetLaba();
											double targetLabaBlnIni = targetLabaThnIni/12;
											double targetLabaSdBlnIni = targetLabaBlnIni * (1 + ((Date)p.getStartDate()).getMonth());
											
											//for report
											String strTargetLabaThnIni = getDispayString(coa, targetLabaThnIni);//(targetLabaThnIni==0) ? "" : JSPFormater.formatNumber(targetLabaThnIni, "#,###");
											String strTargetLabaBlnIni = getDispayString(coa, targetLabaBlnIni);//(targetLabaBlnIni==0) ? "" : JSPFormater.formatNumber(targetLabaBlnIni, "#,###");
											String strTargetLabaSdBlnIni = getDispayString(coa, targetLabaSdBlnIni);//(targetLabaSdBlnIni==0) ? "" : JSPFormater.formatNumber(targetLabaSdBlnIni, "#,###");
											
											double realSdPdpt = pf.getRealSdPdpt();
											double realSdBiaya = pf.getRealSdBiaya();
											double realSdLaba = 0;
											
											if(pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_INCOME 
											|| pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_OTHER_INCOME){ 
											 
												realSdLaba = realSdPdpt - realSdBiaya;
											}
											else{
												realSdLaba = realSdBiaya;
											}
											
											double realSdPercent = (realSdLaba/targetLabaSdBlnIni) * 100;
											
											
											
											//for report
											String strRealSdPdpt = getDispayString(coa, realSdPdpt);//(realSdPdpt==0) ? "" : JSPFormater.formatNumber(realSdPdpt, "#,###");
											String strRealSdBiaya = getDispayString(coa, realSdBiaya);//(realSdBiaya==0) ? "" : JSPFormater.formatNumber(realSdBiaya, "#,###");
											String strRealSdLaba = getDispayString(coa, realSdLaba);//(realSdLaba==0) ? "" : JSPFormater.formatNumber(realSdLaba, "#,###");
											String strRealSdPercent = getDispayString(coa, realSdPercent);//(realSdPercent==0) ? "" : JSPFormater.formatNumber(realSdPercent, "#,###");
											
											double realPdpt = pf.getRealPdpt();
											double realBiaya = pf.getRealBiaya();
											double realLaba = realPdpt - realBiaya;
											
											if(pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_INCOME 
											|| pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_OTHER_INCOME){ 
											 
												realLaba = realPdpt - realBiaya;
											}
											else{
												realLaba = realBiaya;
											}
											
											double realPercent = (realLaba/targetLabaBlnIni) * 100;
											
											
																						
											//for report
											String strRealPdpt = getDispayString(coa, realPdpt);//(realSdPdpt==0) ? "" : JSPFormater.formatNumber(realSdPdpt, "#,###");
											String strRealBiaya = getDispayString(coa, realBiaya);//(realSdBiaya==0) ? "" : JSPFormater.formatNumber(realSdBiaya, "#,###");
											String strRealLaba = getDispayString(coa, realLaba);//(realSdLaba==0) ? "" : JSPFormater.formatNumber(realSdLaba, "#,###");
											String strRealPercent = getDispayString(coa, realPercent);//(realSdPercent==0) ? "" : JSPFormater.formatNumber(realSdPercent, "#,###");
											
											if(pfType==pf.getType()){
												
												if(coa.getLevel()==1){
													totalTargetLaba = totalTargetLaba + targetLabaThnIni;
													totalTargetLabaSD = totalTargetLabaSD + targetLabaSdBlnIni;
													totalTargetLabaMth = totalTargetLabaMth + targetLabaBlnIni;
													
													totalPdptSD = totalPdptSD + realSdPdpt;
													totalBiayaSD = totalBiayaSD + realSdBiaya;
													totalLabaSD = totalLabaSD + realSdLaba;
													
													totalPdptMth = totalPdptMth + realPdpt;
													totalBiayaMth = totalBiayaMth + realBiaya;
													totalLabaMth = totalLabaMth + realLaba;
														
												}
												
											}else{
											
											//jika type tidak sama buatkan totalnya
												
												//out.println("total laba ="+totalTargetLaba);
												
												//============ for report ====================
												//================== for value ==================
												
												detail = new RptPortofolioL();
												
												detail.setTypes(9);
												detail.setTtTargetLaba(totalTargetLaba);
												
												//out.println("total get ="+detail.getTtTargetLaba());
												
												detail.setTtTargetLabaSd(totalTargetLabaSD);
												detail.setTtTargetLabaBulanIni(totalTargetLabaMth);
												
												detail.setTtPdptSd(totalPdptSD);
												detail.setTtBiayaSd(totalBiayaSD);
												detail.setTtLabaSd(totalLabaSD);
												
												detail.setTtTargetLabaBulanIni2(totalTargetLabaMth);
												detail.setTtPdpt(totalPdptMth);
												detail.setTtBiaya(totalBiayaMth);
												detail.setTtLaba(totalLabaMth);
												//================= end value ===================
												
														/*								
												detail.setType(coa.getLevel());
												detail.setCode(coa.getCode());
												detail.setName(coa.getName());
												
												detail.setTargetLaba(targetLabaThnIni);
												detail.setTargetLabaSd(targetLabaSdBlnIni);
												detail.setTargetLabaBulanIni(targetLabaBlnIni);
												detail.setPdptSd(realSdPdpt);
												detail.setBiayaSd(realSdBiaya);
												detail.setLabaSd(realSdLaba);
												
												if(targetLabaSdBlnIni==0){
												   detail.setPersenLabaSd(0);
												}else{
												   detail.setPersenLabaSd(realSdPercent);
												}
												
												detail.setTargetLabaBulanIni2(targetLabaBlnIni);
												detail.setPdpt(realPdpt);
												detail.setBiaya(realBiaya);
												detail.setLaba(realLaba);
												
												if(targetLabaBlnIni==0){
												   detail.setPersenLaba(0);
												}else{
												   detail.setPersenLaba(realPercent);
												}
												
												detail.setKeterangan(pf.getNote());
												*/
												
												objReport.add(detail);
												
												//=== end report ============
												
												String strTotalTargetLaba = getDispayString(totalTargetLaba);
												String strTotalTargetLabaSD = getDispayString(totalTargetLabaSD);
												String strTotalTargetLabaMth = getDispayString(totalTargetLabaMth);
												
												//----------grand total---------
												if(pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_INCOME 
												|| pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_OTHER_INCOME){  
													grandTotalTargetLaba = grandTotalTargetLaba + totalTargetLaba;
													grandTotalTargetLabaSD = grandTotalTargetLabaSD + totalTargetLabaSD;
													grandTotalTargetLabaMth = grandTotalTargetLabaMth + totalTargetLabaMth;
												}
												else{
													grandTotalTargetLaba = grandTotalTargetLaba - totalTargetLaba;
													grandTotalTargetLabaSD = grandTotalTargetLabaSD - totalTargetLabaSD;
													grandTotalTargetLabaMth = grandTotalTargetLabaMth - totalTargetLabaMth;
												}
												//----------------------
													
												
												String strTotalPdptSD = getDispayString(totalPdptSD);
												String strTotalBiayaSD = getDispayString(totalBiayaSD);
												String strTotalLabaSD = getDispayString(totalLabaSD);
												
												strRealSdPercent = getDispayString((totalLabaSD/totalTargetLabaSD) * 100);
																								
												grandTotalPdptSD = grandTotalPdptSD + totalPdptSD;
												grandTotalBiayaSD = grandTotalBiayaSD +totalBiayaSD;
												//grandTotalLabaSD = grandTotalLabaSD + totalLabaSD;
												
												String strTotalPdptMth = getDispayString(totalPdptMth);
												String strTotalBiayaMth = getDispayString(totalBiayaMth);
												String strTotalLabaMth = getDispayString(totalLabaMth);
												
												strRealPercent = getDispayString((totalLabaMth/totalTargetLabaMth) * 100);
												
												grandTotalPdptMth = grandTotalPdptMth +totalPdptMth ;
												grandTotalBiayaMth = grandTotalBiayaMth + totalBiayaMth;
												//grandTotalLabaMth = grandTotalLabaMth + totalLabaMth;
												
												//out.println("1 totalLabaSD : "+JSPFormater.formatNumber(totalLabaSD, "#,###")+", grandTotalLabaSD : "+JSPFormater.formatNumber(grandTotalLabaSD, "#,###"));
												
												if(coa.getLevel()==1){
													totalTargetLaba = targetLabaThnIni;
													totalTargetLabaSD = targetLabaSdBlnIni;
													totalTargetLabaMth = targetLabaBlnIni;
													
													totalPdptSD = realSdPdpt;
													totalBiayaSD = realSdBiaya;
													totalLabaSD = realSdLaba;
													
													totalPdptMth = realPdpt;
													totalBiayaMth = realBiaya;
													totalLabaMth = realLaba;
												}
												
												pfType = pf.getType();
										%>
                                        <tr> 
                                          <td width="350" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="center"><b>T O T A L :</b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalTargetLaba%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalTargetLabaSD%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalTargetLabaMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalPdptSD%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalBiayaSD%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalLabaSD%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"> <b> <%=strRealSdPercent%> %</b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalTargetLabaMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalPdptMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalBiayaMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalLabaMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"> <b> <%=strRealPercent%> %</b></div>
                                          </td>
                                          <td width="250" height="19" bgcolor="#CCCCCC"><b></b></td>
                                        </tr>
                                        <tr> 
                                          <td width="350" height="17" nowrap>&nbsp; 
                                          </td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="250" height="17"></td>
                                        </tr>
                                        <%}
										
										        
										
										if(i%2==0){
										
											    //================== for value ==================
												detail = new RptPortofolioL();
												
												detail.setTypes(coa.getLevel());
												detail.setTtTargetLaba(totalTargetLaba);
												detail.setTtTargetLabaSd(totalTargetLabaSD);
												detail.setTtTargetLabaBulanIni(totalTargetLabaMth);
												
												detail.setTtPdptSd(totalPdptSD);
												detail.setTtBiayaSd(totalBiayaSD);
												detail.setTtLabaSd(totalLabaSD);
												
												detail.setTtTargetLabaBulanIni2(totalTargetLabaMth);
												detail.setTtPdpt(totalPdptMth);
												detail.setTtBiaya(totalBiayaMth);
												detail.setTtLaba(totalLabaMth);
												//================= end value ===================
												
																						
												detail.setType(coa.getLevel());
												detail.setCode(coa.getCode());
												detail.setName(coa.getName());
												
												detail.setTargetLaba(targetLabaThnIni);
												detail.setTargetLabaSd(targetLabaSdBlnIni);
												detail.setTargetLabaBulanIni(targetLabaBlnIni);
												detail.setPdptSd(realSdPdpt);
												detail.setBiayaSd(realSdBiaya);
												detail.setLabaSd(realSdLaba);
												
												if(targetLabaSdBlnIni==0){
												   detail.setPersenLabaSd(0);
												}else{
												   detail.setPersenLabaSd(realSdPercent);
												}
												
												detail.setTargetLabaBulanIni2(targetLabaBlnIni);
												detail.setPdpt(realPdpt);
												detail.setBiaya(realBiaya);
												detail.setLaba(realLaba);
												
												if(targetLabaBlnIni==0){
												   detail.setPersenLaba(0);
												}else{
												   detail.setPersenLaba(realPercent);
												}
												
												detail.setKeterangan(pf.getNote());
												
												objReport.add(detail);
												
												//=== end report ============
											
										%>
                                        <tr> 
                                          <td width="350" class="tablecell" height="17" nowrap> 
                                            <%if(coa.getLevel()==1 || coa.getLevel()==2){%>
                                            <b> 
                                            <%}%>
                                            <%=str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getLevel()==1 || coa.getLevel()==2){%>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strTargetLabaThnIni%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strTargetLabaSdBlnIni%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strTargetLabaBlnIni%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strRealSdPdpt%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strRealSdBiaya%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strRealSdLaba%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strRealSdPercent%> %</div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strTargetLabaBlnIni%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strRealPdpt%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strRealBiaya%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strRealLaba%></div>
                                          </td>
                                          <td width="100" class="tablecell" height="17" nowrap> 
                                            <div align="right"><%=strRealPercent%>%</div>
                                          </td>
                                          <td width="250" class="tablecell" height="17"><%=pf.getNote()%></td>
                                        </tr>
                                        <%}else{
										
												//================== for value ==================
												detail = new RptPortofolioL();
												
												detail.setTypes(coa.getLevel());
												detail.setTtTargetLaba(totalTargetLaba);
												detail.setTtTargetLabaSd(totalTargetLabaSD);
												detail.setTtTargetLabaBulanIni(totalTargetLabaMth);
												
												detail.setTtPdptSd(totalPdptSD);
												detail.setTtBiayaSd(totalBiayaSD);
												detail.setTtLabaSd(totalLabaSD);
												
												detail.setTtTargetLabaBulanIni2(totalTargetLabaMth);
												detail.setTtPdpt(totalPdptMth);
												detail.setTtBiaya(totalBiayaMth);
												detail.setTtLaba(totalLabaMth);
												//================= end value ===================
												
																						
												detail.setType(coa.getLevel());
												detail.setCode(coa.getCode());
												detail.setName(coa.getName());
												
												detail.setTargetLaba(targetLabaThnIni);
												detail.setTargetLabaSd(targetLabaSdBlnIni);
												detail.setTargetLabaBulanIni(targetLabaBlnIni);
												detail.setPdptSd(realSdPdpt);
												detail.setBiayaSd(realSdBiaya);
												detail.setLabaSd(realSdLaba);
												
												if(targetLabaSdBlnIni==0){
												   detail.setPersenLabaSd(0);
												}else{
												   detail.setPersenLabaSd(realSdPercent);
												}
												
												detail.setTargetLabaBulanIni2(targetLabaBlnIni);
												detail.setPdpt(realPdpt);
												detail.setBiaya(realBiaya);
												detail.setLaba(realLaba);
												
												if(targetLabaBlnIni==0){
												   detail.setPersenLaba(0);
												}else{
												   detail.setPersenLaba(realPercent);
												}
												
												detail.setKeterangan(pf.getNote());
												
												objReport.add(detail);
												
												//=== end report ============
										
										%>
                                        <tr> 
                                          <td width="350" class="tablecell1" height="17" nowrap> 
                                            <%if(coa.getLevel()==1 || coa.getLevel()==2){%>
                                            <b> 
                                            <%}%>
                                            <%=str+coa.getCode()+" - "+coa.getName()%> 
                                            <%if(coa.getLevel()==1 || coa.getLevel()==2){%>
                                            </b> 
                                            <%}%>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strTargetLabaThnIni%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strTargetLabaSdBlnIni%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strTargetLabaBlnIni%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strRealSdPdpt%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strRealSdBiaya%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strRealSdLaba%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strRealSdPercent%> %</div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strTargetLabaBlnIni%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strRealPdpt%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strRealBiaya%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strRealLaba%></div>
                                          </td>
                                          <td width="100" class="tablecell1" height="17" nowrap> 
                                            <div align="right"><%=strRealPercent%>%</div>
                                          </td>
                                          <td width="250" class="tablecell1" height="17"><%=pf.getNote()%></td>
                                        </tr>
                                        <%}//terakhir
										if(i==listCoaPortofolioSetup.size()-1){
										
												String strTotalTargetLaba = getDispayString(totalTargetLaba);
												String strTotalTargetLabaSD = getDispayString(totalTargetLabaSD);
												String strTotalTargetLabaMth = getDispayString(totalTargetLabaMth);
												
												//----------grand total---------
												if(pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_INCOME 
												|| pf.getType()==DbCoaPortofolioSetup.TYPE_PORTO_OTHER_INCOME){  
													grandTotalTargetLaba = grandTotalTargetLaba + totalTargetLaba;
													grandTotalTargetLabaSD = grandTotalTargetLabaSD + totalTargetLabaSD;
													grandTotalTargetLabaMth = grandTotalTargetLabaMth + totalTargetLabaMth;
												}
												else{
													grandTotalTargetLaba = grandTotalTargetLaba - totalTargetLaba;
													grandTotalTargetLabaSD = grandTotalTargetLabaSD - totalTargetLabaSD;
													grandTotalTargetLabaMth = grandTotalTargetLabaMth - totalTargetLabaMth;
												}
												//----------------------
												
												String strTotalPdptSD = getDispayString(totalPdptSD);
												String strTotalBiayaSD = getDispayString(totalBiayaSD);
												String strTotalLabaSD = getDispayString(totalLabaSD);
												
												strRealSdPercent = getDispayString((totalLabaSD/totalTargetLabaSD) * 100);
												
												grandTotalLabaSD = grandTotalLabaSD + totalLabaSD;
												grandTotalBiayaSD = grandTotalBiayaSD +totalBiayaSD;
												//grandTotalLabaSD = grandTotalLabaSD + totalLabaSD;
												
												String strTotalPdptMth = getDispayString(totalPdptMth);
												String strTotalBiayaMth = getDispayString(totalBiayaMth);
												String strTotalLabaMth = getDispayString(totalLabaMth);
												
												strRealPercent = getDispayString((totalLabaMth/totalTargetLabaMth) * 100);
												
												grandTotalPdptMth = grandTotalPdptMth +totalPdptMth ;
												grandTotalBiayaMth = grandTotalBiayaMth + totalBiayaMth;
												//grandTotalLabaMth = grandTotalLabaMth + totalLabaMth;
												
												//out.println("totalLabaSD : "+JSPFormater.formatNumber(totalLabaSD, "#,###")+", grandTotalLabaSD : "+JSPFormater.formatNumber(grandTotalLabaSD, "#,###"));
												
												
												
												//================== for report ==================
												detail = new RptPortofolioL();
												
												detail.setTypes(9);
												detail.setTtTargetLaba(totalTargetLaba);
												detail.setTtTargetLabaSd(totalTargetLabaSD);
												detail.setTtTargetLabaBulanIni(totalTargetLabaMth);
												
												detail.setTtPdptSd(totalPdptSD);
												detail.setTtBiayaSd(totalBiayaSD);
												detail.setTtLabaSd(totalLabaSD);
												
												detail.setTtTargetLabaBulanIni2(totalTargetLabaMth);
												detail.setTtPdpt(totalPdptMth);
												detail.setTtBiaya(totalBiayaMth);
												detail.setTtLaba(totalLabaMth);
												//================= end value ===================
												
																						
												detail.setType(coa.getLevel());
												detail.setCode(coa.getCode());
												detail.setName(coa.getName());
												
												detail.setTargetLaba(targetLabaThnIni);
												detail.setTargetLabaSd(targetLabaSdBlnIni);
												detail.setTargetLabaBulanIni(targetLabaBlnIni);
												detail.setPdptSd(realSdPdpt);
												detail.setBiayaSd(realSdBiaya);
												detail.setLabaSd(realSdLaba);
												
												if(targetLabaSdBlnIni==0){
												   detail.setPersenLabaSd(0);
												}else{
												   detail.setPersenLabaSd(realSdPercent);
												}
												
												detail.setTargetLabaBulanIni2(targetLabaBlnIni);
												detail.setPdpt(realPdpt);
												detail.setBiaya(realBiaya);
												detail.setLaba(realLaba);
												
												if(targetLabaBlnIni==0){
												   detail.setPersenLaba(0);
												}else{
												   detail.setPersenLaba(realPercent);
												}
												
												detail.setKeterangan(pf.getNote());
												
												objReport.add(detail);
												
												//=== end report ============
										
										%>
                                        <tr> 
                                          <td width="350" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="center"><b>T O T A L :</b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalTargetLaba%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalTargetLabaSD%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalTargetLabaMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalPdptSD%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalBiayaSD%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalLabaSD%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"> <b> <%=strRealSdPercent%> %</b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalTargetLabaMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalPdptMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalBiayaMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"><b><%=strTotalLabaMth%></b></div>
                                          </td>
                                          <td width="100" height="19" nowrap bgcolor="#CCCCCC"> 
                                            <div align="right"> <b> <%=strRealPercent%> %</b></div>
                                          </td>
                                          <td width="250" height="19" bgcolor="#CCCCCC"><b></b></td>
                                        </tr>
                                        <tr> 
                                          <td width="350" height="17" nowrap>&nbsp; 
                                          </td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="100" height="17" nowrap>&nbsp;</td>
                                          <td width="250" height="17"></td>
                                        </tr>
                                        <%}}}%>
                                        <%
										//String total
										double lbsd = grandTotalPdptSD-grandTotalBiayaSD;
										double persenSd = ((grandTotalPdptSD-grandTotalBiayaSD)/grandTotalTargetLabaSD)*100;
										double laba = grandTotalPdptMth-grandTotalBiayaMth;
										double psn = ((grandTotalPdptMth-grandTotalBiayaMth)/grandTotalTargetLabaMth)*100;
										
										rptKonstan.setTotalTargetLaba(grandTotalTargetLaba);
										rptKonstan.setTotalTargetLabaSd(grandTotalTargetLabaSD);
										rptKonstan.setTotalTargetLabaBulanIni(grandTotalTargetLabaMth);
										
										rptKonstan.setTotalPdptSd(grandTotalPdptSD);
										rptKonstan.setTotalBiayaSd(grandTotalBiayaSD);
										rptKonstan.setTotalLabaSd(lbsd);
										
										rptKonstan.setTotalPersenLabaSd(persenSd);
										rptKonstan.setTotalTargetLabaBulanIni2(grandTotalTargetLabaMth);
										rptKonstan.setTotalPdpt(grandTotalPdptMth);
										
										rptKonstan.setTotalBiaya(grandTotalBiayaMth);
										rptKonstan.setTotalLaba(laba);
										rptKonstan.setTotalPersenLaba(psn);
										
										
										String strGrandTotalTargetLaba = JSPFormater.formatNumber(grandTotalTargetLaba, "#,###");// + targetLabaThnIni;
										String strGrandTotalTargetLabaSD = JSPFormater.formatNumber(grandTotalTargetLabaSD, "#,###");// + targetLabaSdBlnIni;
										String strGrandTotalTargetLabaMth = JSPFormater.formatNumber(grandTotalTargetLabaMth, "#,###");// + targetLabaBlnIni;
										
										String strGrandTotalPdptSD = getDispayString(grandTotalPdptSD);//JSPFormater.formatNumber(grandTotalPdptSD, "#,###");// + realSdPdpt;
										String strGrandTotalBiayaSD = getDispayString(grandTotalBiayaSD);//JSPFormater.formatNumber(grandTotalBiayaSD, "#,###");// + realSdBiaya;
										String strGrandTotalLabaSD = getDispayString(grandTotalPdptSD-grandTotalBiayaSD);//JSPFormater.formatNumber(grandTotalLabaSD, "#,###");// + realSdLaba;
										
										String strSDPercent = getDispayString(((grandTotalPdptSD-grandTotalBiayaSD)/grandTotalTargetLabaSD)*100);
										//out.println("totalLabaSD : "+JSPFormater.formatNumber(totalLabaSD, "#,###")+", xxx grandTotalLabaSD : "+JSPFormater.formatNumber(grandTotalLabaSD, "#,###"));
										
										String strGrandTotalPdptMth = getDispayString(grandTotalPdptMth);//JSPFormater.formatNumber(grandTotalPdptMth, "#,###");// + realPdpt;
										String strGrandTotalBiayaMth = getDispayString(grandTotalBiayaMth);//JSPFormater.formatNumber(grandTotalBiayaMth, "#,###");// + realBiaya;
										String strGrandTotalLabaMth = getDispayString(grandTotalPdptMth-grandTotalBiayaMth);//JSPFormater.formatNumber(grandTotalLabaMth, "#,###");// + realLaba;
										
										String strPercent = getDispayString(((grandTotalPdptMth-grandTotalBiayaMth)/grandTotalTargetLabaMth)*100);
										
										%>
                                        <tr> 
                                          <td width="350" height="23" bgcolor="#666666"> 
                                            <div align="center"><b><font color="#FFFFFF">LABA 
                                              SETELAH BUNGA DAN PAJAK </font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalTargetLaba%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalTargetLabaSD%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalTargetLabaMth%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalPdptSD%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalBiayaSD%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalLabaSD%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#FFFFFF"><%=strSDPercent%>%</font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalTargetLabaMth%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalPdptMth%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalBiayaMth%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strGrandTotalLabaMth%></font></font></b></div>
                                          </td>
                                          <td width="100" height="23" bgcolor="#666666"> 
                                            <div align="right"><b><font color="#000000"><font color="#FFFFFF"><%=strPercent%>%</font></font></b></div>
                                          </td>
                                          <td width="250" height="23" bgcolor="#666666">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="350">&nbsp;</td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="250">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="350"><a href="javascript:cmdPrintXLS()"><img src="../images/print.gif" width="53" height="22" border="0"></a></td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="250">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="350">&nbsp;</td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="250">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="350">&nbsp;</td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="250">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="350">&nbsp;</td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="100"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="250">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td height="15">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
                        </form>
						<%
							
							session.putValue("DETAIL", objReport);
							session.putValue("KONSTAN", rptKonstan);
						%>
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
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable --> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate -->
</html>
