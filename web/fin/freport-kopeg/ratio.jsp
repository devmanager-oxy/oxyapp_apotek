 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.report.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%!
	public String strDisplay(double amount, String coaStatus){
		String displayStr = "";
		if(amount<0)
			displayStr = "("+JSPFormater.formatNumber(amount*-1,"#,###")+")";
		else if(amount>0)										
			displayStr = JSPFormater.formatNumber(amount,"#,###");
		else if(amount==0)
			displayStr = "-";
		if(coaStatus.equals("HEADER"))
			displayStr = "<b>"+displayStr+"</b>";
		return displayStr;
	}
	
	public String strDisplayPercent(double amount, String coaStatus){
		String displayStr = "";
		if(amount<0)
			displayStr = "("+JSPFormater.formatNumber(amount*-1,"#,###.##")+")";
		else if(amount>0)										
			displayStr = JSPFormater.formatNumber(amount,"#,###.##");
		else if(amount==0)
			displayStr = "-";
		if(coaStatus.equals("HEADER"))
			displayStr = "<b>"+displayStr+"</b>";
		return displayStr;
	}
%>
<%

	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}
	
	if(session.getValue("KONSTAN")!=null){
		session.removeValue("KONSTAN");
	}

long periodeId = JSPRequestValue.requestLong(request, "src_periode_id");
	
Vector periodes = DbPeriode.list(0,0, "", "start_date desc");

Periode periode = new Periode();

boolean isOpen = false;
if(periodeId==0){
	if(periodes!=null && periodes.size()>0){
		periode =(Periode)periodes.get(0);
		periodeId = periode.getOID();
		if(periode.getStatus().equals("Open")){
			isOpen = true;
		}
	}
}
else{
	try{
		periode = DbPeriode.fetchExc(periodeId);
		if(periode.getStatus().equals("Open")){
			isOpen = true;
		}
	}
	catch(Exception e){
	}
}

Date dt = periode.getStartDate();            
Date dty = (Date)dt.clone();
dty.setYear(dty.getYear()-1);
			
Periode periode2 = DbPeriode.getPeriodByTransDate(dty);

	
//setup rasio ***********************************

long oidCoaPiutang = 504404408245783427l;
long oidCoaCategoryCash = 504404361643495473l;
long oidCoaCategoryCredit = 504404361643672817l;

//current rasio ===================================
	
	//luquid asset
	double amountLiquidAsset = DbCoa.getRatioCurrYR(I_Project.ACC_GROUP_LIQUID_ASSET, periode, "DC");
	double amountLiquidAssetPrev = DbCoa.getRatioPrevYR(I_Project.ACC_GROUP_LIQUID_ASSET, periode, "DC");
	
	//hutang lancar = current liability
	double amountCurrentLiability = DbCoa.getRatioCurrYR(I_Project.ACC_GROUP_CURRENT_LIABILITIES, periode, "CD");
	double amountCurrentLiabilityPrev = DbCoa.getRatioPrevYR(I_Project.ACC_GROUP_CURRENT_LIABILITIES, periode, "CD");
	
//rasio hutang ==================================
	//total hutang = current liability + long term liability
	//longterm
	double amountLongTermLiability = DbCoa.getRatioCurrYR(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES, periode, "CD");
	double amountLongTermLiabilityPrev = DbCoa.getRatioPrevYR(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES, periode, "CD");
	
	double amountTotalHutang = amountCurrentLiability + amountLongTermLiability;
	double amountTotalHutangPrev = amountCurrentLiabilityPrev + amountLongTermLiabilityPrev;
	
	//total harta = liquid asset + fixed asset + other asset
	double amountFixedAsset = DbCoa.getRatioCurrYR(I_Project.ACC_GROUP_FIXED_ASSET, periode, "DC");
	double amountFixedAssetPrev = DbCoa.getRatioPrevYR(I_Project.ACC_GROUP_FIXED_ASSET, periode, "DC");
	
	double amountOtherAsset = DbCoa.getRatioCurrYR(I_Project.ACC_GROUP_OTHER_ASSET, periode, "DC");
	double amountOtherAssetPrev = DbCoa.getRatioPrevYR(I_Project.ACC_GROUP_OTHER_ASSET, periode, "DC");
	
	double amountTotalHarta = amountLiquidAsset + amountFixedAsset + amountOtherAsset;
	double amountTotalHartaPrev = amountLiquidAssetPrev + amountFixedAssetPrev + amountOtherAssetPrev;

//periode tagihan
	
	//penjualan, = iktisar RL CASH + CREDIT
	//cash	
	CoaCategory cashCC = new CoaCategory();
	try{
		cashCC = DbCoaCategory.fetchExc(oidCoaCategoryCash);
	}
	catch(Exception e){
	}
	double totalSales = DbCoaCategory.getCoaBalanceYTD(cashCC, periode);
	double totalSalesPrev = DbCoaCategory.getCoaBalanceYTD(cashCC, periode2);
	
	//credit	
	cashCC = new CoaCategory();
	try{
		cashCC = DbCoaCategory.fetchExc(oidCoaCategoryCredit);
	}
	catch(Exception e){
	}
	totalSales = totalSales + DbCoaCategory.getCoaBalanceYTD(cashCC, periode);
	totalSalesPrev = totalSalesPrev + DbCoaCategory.getCoaBalanceYTD(cashCC, periode2);
	
	
	//piutang = coa header piutang
	Coa piutangCoa = new Coa();
	try{
		piutangCoa = DbCoa.fetchExc(oidCoaPiutang);
	}
	catch(Exception e){
	}
	
	double totalPiutang = DbCoa.getCoaBalanceRecursifNonPL(piutangCoa, periode, "DC");
	double totalPiutangPrev = DbCoa.getCoaBalanceRecursifNonPL(piutangCoa, periode2, "DC");



//profitabilitas ====================
	//laba bersih *****
	double labaBersih = DbCoa.getEarningByPeriod(periode);
	double labaBersihPrev = DbCoa.getEarningByPeriod(periode2);
	
	//penjualan *******
//roi
Vector objReport = new Vector();
RptRasioL detail = new RptRasioL();
RptRasio rptKonstan = new RptRasio();

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
	window.open("<%=printroot%>.report.RptRasioXLS?oid=<%=appSessUser.getLoginId()%>");
}

function cmdChangePeriod(){
	document.form1.action="ratio.jsp";
	document.form1.submit();
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Rasio</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
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
                                          <td width="24%" nowrap><b>PERIODE : 
                                            <select name="src_periode_id" onChange="javascript:cmdChangePeriod()">
                                              <%if(periodes!=null && periodes.size()>0){
											  for(int i=0; i<periodes.size(); i++){
											  		Periode px = (Periode)periodes.get(i);
											  %>
                                              <option value="<%=px.getOID()%>" <%if(px.getOID()==periodeId){%>selected<%}%>><%=px.getName()%></option>
                                              <%}}%>
                                            </select>
                                            </b></td>
                                          <td width="76%">&nbsp; </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <div align="center"><span class="level1"><font size="+1"><b>PERFORMASI 
                                        KEUANGAN </b></font></span></div>
                                    </td>
                                  </tr>
                                  <%
									String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "MMMM yyyy");//+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");        
									
									Date dtx = periode.getStartDate();
									int yearx = dtx.getYear()+1900;
							%>
                                  <tr> 
                                    <td> 
                                      <div align="center"><span class="level1"><b><font size="3"><%=openPeriod.toUpperCase()%></font></b></span></div>
                                      <%
									  	rptKonstan.setPeriode(openPeriod);
									  %>
									</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td class="tablehdr" width="3%">NO</td>
                                          <td class="tablehdr" colspan="2">RASIO</td>
                                          <td class="tablehdr" colspan="2">TAHUN</td>
                                          <td class="tablehdr" width="9%">TREND</td>
                                          <td class="tablehdr" width="23%">INTERPRETASI</td>
                                          <td width="15%"> 
                                            <div align="center"><b><%=yearx-1%></b></div>
                                          </td>
                                          <td width="15%"> 
                                            <div align="center"><b><%=yearx%></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td class="tablehdr" width="3%">&nbsp;</td>
                                          <td class="tablehdr" width="3%">&nbsp;</td>
                                          <td class="tablehdr" width="18%">&nbsp;</td>
                                          <td class="tablehdr" width="7%"><%=yearx-1%></td>
                                          <td class="tablehdr" width="7%"><%=yearx%></td>
										  <%
										  	rptKonstan.setTahun1(yearx-1);
											rptKonstan.setTahun2(yearx);
										  %>
                                          <td class="tablehdr" width="9%">&nbsp;</td>
                                          <td class="tablehdr" width="23%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="18%" class="tablecell1">&nbsp;</td>
                                          <td width="7%" class="tablecell1">&nbsp;</td>
                                          <td width="7%" class="tablecell1">&nbsp;</td>
                                          <td width="9%" class="tablecell1">&nbsp;</td>
                                          <td width="23%" class="tablecell1">&nbsp;</td>
                                          <td width="15%" bgcolor="#F0F0F0"><b></b></td>
                                          <td width="15%" bgcolor="#F0F0F0"><b></b></td>
                                        </tr>
										<%
											double thn1 = 0;
											double thn2 = 0;
											double thn33 = 0;
											double thn43 = 0;
											
											detail = new RptRasioL();
											detail.setType(1);
											detail.setRasio1("CURRENT RATIO");
											detail.setRasio2("HARTA LANCAR");
											detail.setRasio3("HUTANG LANCAR");
											detail.setInter("Kemampuan untuk membayar hutang jangka pendek");
											
											if(amountCurrentLiabilityPrev==0){
												thn1 = 0;
											}else{
												thn1 = (amountLiquidAssetPrev/amountCurrentLiabilityPrev)*100;
											}
											
											if(amountCurrentLiability==0){
												thn2 = 0;
											}else{
												thn2 = (amountLiquidAsset/amountCurrentLiability)*100;
											}
											
											//=============================================
											if(amountCurrentLiabilityPrev==0){
												thn33 = 0;
											}else{
												thn33 = (amountLiquidAssetPrev/amountCurrentLiabilityPrev)*100;
											}
											
											if(amountCurrentLiability==0){
												thn43 = 0;
											}else{
												thn43 = (amountLiquidAsset/amountCurrentLiability)*100;
											}
											
											detail.setTahun1(thn1);
											detail.setTahun2(thn2);
											
											detail.setTahun31(amountLiquidAssetPrev);
											detail.setTahun32(amountCurrentLiabilityPrev);
											detail.setTahun33(thn33);
											
											detail.setTahun41(amountLiquidAsset);
											detail.setTahun42(amountCurrentLiability);
											detail.setTahun43(thn43);
											
											objReport.add(detail);
											
										%>
                                        <tr> 
                                          <td width="3%" class="tablecell" height="20"> 
                                            <div align="center"><b>1</b></div>
                                          </td>
                                          <td colspan="2" class="tablecell" height="20"><b class="level2">CURRENT 
                                            RATIO</b></td>
                                          <td width="7%" class="tablecell" height="20"><b></b></td>
                                          <td width="7%" class="tablecell" height="20"><b></b></td>
                                          <td width="9%" class="tablecell" height="20"><b></b></td>
                                          <td width="23%" class="tablecell" height="20"><b></b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b></b></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b></b></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell" height="20"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" class="tablecell" height="20"><b></b></td>
                                          <td width="18%" class="tablecell" height="20"><b>HARTA 
                                            LANCAR</b></td>
                                          <td rowspan="2" class="tablecell" height="41"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((amountLiquidAssetPrev/amountCurrentLiabilityPrev)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" class="tablecell" height="41"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((amountLiquidAsset/amountCurrentLiability)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" class="tablecell" height="41"> 
                                            <div align="center"><b></b><b></b></div>
                                          </td>
                                          <td rowspan="2" class="tablecell" height="41" valign="top"><b>Kemampuan 
                                            untuk membayar hutang jangka pendek</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountLiquidAssetPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountLiquidAsset, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell" height="20"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" class="tablecell" height="20"><b></b></td>
                                          <td width="18%" class="tablecell" height="20"><b>HUTANG 
                                            LANCAR</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountCurrentLiabilityPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountCurrentLiability, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="18%" class="tablecell1">&nbsp;</td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="2"></font></div>
                                          </td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="2"></font></div>
                                          </td>
                                          <td width="9%" class="tablecell1"> 
                                            <div align="center"></div>
                                          </td>
                                          <td width="23%" class="tablecell1" valign="top">&nbsp;</td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((amountLiquidAssetPrev/amountCurrentLiabilityPrev)*100, "")%></div>
                                          </td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((amountLiquidAsset/amountCurrentLiability)*100, "")%></div>
                                          </td>
                                        </tr>
										<%
											detail = new RptRasioL();
											detail.setType(2);
											detail.setRasio1("RATIO HUTANG");
											detail.setRasio2("TOTAL HUTANG");
											detail.setRasio3("TOTAL HARTA");
											detail.setInter("Kemampuan hutang untuk membiayai aktiva");
											
											if(amountTotalHartaPrev==0){
												thn1 = 0;
											}else{
												thn1 = (amountTotalHutangPrev/amountTotalHartaPrev)*100;
											}
											
											if(amountTotalHarta==0){
												thn2 = 0;
											}else{
												thn2 = (amountTotalHutang/amountTotalHarta)*100;
											}
											
											//=============================================
											if(amountTotalHartaPrev==0){
												thn33 = 0;
											}else{
												thn33 = (amountTotalHutangPrev/amountTotalHartaPrev)*100;
											}
											
											if(amountTotalHarta==0){
												thn43 = 0;
											}else{
												thn43 = (amountTotalHutang/amountTotalHarta)*100;
											}
											
											
											detail.setTahun1(thn1);
											detail.setTahun2(thn2);
											
											detail.setTahun31(amountTotalHutangPrev);
											detail.setTahun32(amountTotalHartaPrev);
											detail.setTahun33(thn33);
											
											detail.setTahun41(amountTotalHutang);
											detail.setTahun42(amountTotalHarta);
											detail.setTahun43(thn43);
											
											objReport.add(detail);
										%>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b>2</b></div>
                                          </td>
                                          <td colspan="2" height="20" class="tablecell"><b class="level2">RATIO 
                                            HUTANG</b></td>
                                          <td width="7%" height="20" class="tablecell"> 
                                            <div align="right"><b><font size="2"></font></b></div>
                                          </td>
                                          <td width="7%" height="20" class="tablecell"> 
                                            <div align="right"><b><font size="2"></font></b></div>
                                          </td>
                                          <td width="9%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="23%" height="20" class="tablecell" valign="top"><b></b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b><b></b></b></b></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b><b></b></b></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" height="20" class="tablecell"><b></b></td>
                                          <td width="18%" height="20" class="tablecell"><b>TOTAL 
                                            HUTANG</b></td>
                                          <td rowspan="2" class="tablecell" height="41"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((amountTotalHutangPrev/amountTotalHartaPrev)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" class="tablecell" height="41"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((amountTotalHutang/amountTotalHarta)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="center"><b></b><b></b></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell" valign="top"><b>Kemampuan 
                                            hutang untuk membiayai aktiva</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountTotalHutangPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountTotalHutang, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" height="20" class="tablecell"><b></b></td>
                                          <td width="18%" height="20" class="tablecell"><b>TOTAL 
                                            HARTA</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountTotalHartaPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountTotalHarta, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="18%" class="tablecell1">&nbsp;</td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="2"></font></div>
                                          </td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="2"></font></div>
                                          </td>
                                          <td width="9%" class="tablecell1"> 
                                            <div align="center"></div>
                                          </td>
                                          <td width="23%" class="tablecell1" valign="top">&nbsp;</td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((amountTotalHutangPrev/amountTotalHartaPrev)*100, "")%></div>
                                          </td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((amountTotalHutang/amountTotalHarta)*100, "")%></div>
                                          </td>
                                        </tr>
										<%
											detail = new RptRasioL();
											detail.setType(3);
											detail.setRasio1("PERIODE TAGIHAN");
											detail.setRasio2("PENJUALAN");
											detail.setRasio3("PIUTANG");
											detail.setInter("Ratio perputaran piutang lancar");
											
											if(totalPiutangPrev==0){
												thn1 = 0;
											}else{
												thn1 = (totalSalesPrev/totalPiutangPrev)*100;
											}
											
											if(totalPiutang==0){
												thn2 = 0;
											}else{
												thn2 = (totalSales/totalPiutang)*100;
											}
											
											//=============================================
											if(totalPiutangPrev==0){
												thn33 = 0;
											}else{
												thn33 = (totalSalesPrev/totalPiutangPrev)*100;
											}
											
											if(totalPiutang==0){
												thn43 = 0;
											}else{
												thn43 = (totalSales/totalPiutang)*100;
											}
											
											
											detail.setTahun1(thn1);
											detail.setTahun2(thn2);
											
											detail.setTahun31(totalSalesPrev);
											detail.setTahun32(totalPiutangPrev);
											detail.setTahun33(thn33);
											
											detail.setTahun41(totalSales);
											detail.setTahun42(totalPiutang);
											detail.setTahun43(thn43);
											
											objReport.add(detail);
										%>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b>3</b></div>
                                          </td>
                                          <td colspan="2" height="20" class="tablecell"><b class="level2">PERIODE 
                                            TAGIHAN</b></td>
                                          <td width="7%" height="20" class="tablecell"> 
                                            <div align="right"><b><font size="2"></font></b></div>
                                          </td>
                                          <td width="7%" height="20" class="tablecell"> 
                                            <div align="right"><b><font size="2"></font></b></div>
                                          </td>
                                          <td width="9%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="23%" height="20" class="tablecell" valign="top"><b></b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b></b></b></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b></b></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" height="20" class="tablecell"><b></b></td>
                                          <td width="18%" height="20" class="tablecell"><b>PENJUALAN</b></td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((totalSalesPrev/totalPiutangPrev)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((totalSales/totalPiutang)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="center"><b></b><b></b></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell" valign="top"><b>Ratio 
                                            perputaran piutang lancar</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(totalSalesPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(totalSales, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" height="20" class="tablecell"><b></b></td>
                                          <td width="18%" height="20" class="tablecell"><b>PIUTANG</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(totalPiutangPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(totalPiutang, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="18%" class="tablecell1">&nbsp;</td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="2"></font></div>
                                          </td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="2"></font></div>
                                          </td>
                                          <td width="9%" class="tablecell1"> 
                                            <div align="center"></div>
                                          </td>
                                          <td width="23%" class="tablecell1" valign="top">&nbsp;</td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((totalSalesPrev/totalPiutangPrev)*100, "")%></div>
                                          </td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((totalSales/totalPiutang)*100, "")%></div>
                                          </td>
                                        </tr>
										<%
											detail = new RptRasioL();
											detail.setType(4);
											detail.setRasio1("PROFITABILITAS");
											detail.setRasio2("LABA BERSIH");
											detail.setRasio3("PENJUALAN");
											detail.setInter("Margin laba yang diperoleh dari penjualan");
											
											if(totalSalesPrev==0){
												thn1 = 0;
											}else{
												thn1 = (labaBersihPrev/totalSalesPrev)*100;
											}
											
											if(totalSales==0){
												thn2 = 0;
											}else{
												thn2 = (labaBersih/totalSales)*100;
											}
											
											//=============================================
											if(totalSalesPrev==0){
												thn33 = 0;
											}else{
												thn33 = (labaBersihPrev/totalSalesPrev)*100;
											}
											
											if(totalSales==0){
												thn43 = 0;
											}else{
												thn43 = (labaBersih/totalSales)*100;
											}
											
											
											detail.setTahun1(thn1);
											detail.setTahun2(thn2);
											
											detail.setTahun31(labaBersihPrev);
											detail.setTahun32(totalSalesPrev);
											detail.setTahun33(thn33);
											
											detail.setTahun41(labaBersih);
											detail.setTahun42(totalSales);
											detail.setTahun43(thn43);
											
											objReport.add(detail);
										%>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b>4</b></div>
                                          </td>
                                          <td colspan="2" height="20" class="tablecell"><b class="level2">PROFITABILITAS</b></td>
                                          <td width="7%" height="20" class="tablecell"> 
                                            <div align="right"><b><font size="2"></font></b></div>
                                          </td>
                                          <td width="7%" height="20" class="tablecell"> 
                                            <div align="right"><b><font size="2"></font></b></div>
                                          </td>
                                          <td width="9%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="23%" height="20" class="tablecell" valign="top"><b></b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b></b></b></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b></b></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" height="20" class="tablecell"><b></b></td>
                                          <td width="18%" height="20" class="tablecell"><b>LABA 
                                            BERSIH</b></td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((labaBersihPrev/totalSalesPrev)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((labaBersih/totalSales)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="center"><b></b><b></b></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell" valign="top"><b>Margin 
                                            laba yang diperoleh dari penjualan</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(labaBersihPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(labaBersih, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" height="20" class="tablecell"><b></b></td>
                                          <td width="18%" height="20" class="tablecell"><b>PENJUALAN</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(totalSalesPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(totalSales, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="18%" class="tablecell1">&nbsp;</td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="2"></font></div>
                                          </td>
                                          <td width="7%" class="tablecell1"> 
                                            <div align="right"><font size="2"></font></div>
                                          </td>
                                          <td width="9%" class="tablecell1"> 
                                            <div align="center"></div>
                                          </td>
                                          <td width="23%" class="tablecell1" valign="top">&nbsp;</td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((labaBersihPrev/totalSalesPrev)*100, "")%></div>
                                          </td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((labaBersih/totalSales)*100, "")%></div>
                                          </td>
                                        </tr>
										<%
											detail = new RptRasioL();
											detail.setType(5);
											detail.setRasio1("ROI");
											detail.setRasio2("LABA BERSIH");
											detail.setRasio3("TOTAL HARTA");
											detail.setInter("Pengembalian atas investasi yang tertanam");
											
											if(amountTotalHartaPrev==0){
												thn1 = 0;
											}else{
												thn1 = (labaBersihPrev/amountTotalHartaPrev)*100;
											}
											
											if(amountTotalHarta==0){
												thn2 = 0;
											}else{
												thn2 = (labaBersih/amountTotalHarta)*100;
											}
											
											//=============================================
											if(amountTotalHartaPrev==0){
												thn33 = 0;
											}else{
												thn33 = (labaBersihPrev/amountTotalHartaPrev)*100;
											}
											
											if(amountTotalHarta==0){
												thn43 = 0;
											}else{
												thn43 = (labaBersih/amountTotalHarta)*100;
											}
											
											
											detail.setTahun1(thn1);
											detail.setTahun2(thn2);
											
											detail.setTahun31(labaBersihPrev);
											detail.setTahun32(amountTotalHartaPrev);
											detail.setTahun33(thn33);
											
											detail.setTahun41(labaBersih);
											detail.setTahun42(amountTotalHarta);
											detail.setTahun43(thn43);
											
											objReport.add(detail);
										%>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b>5</b></div>
                                          </td>
                                          <td colspan="2" height="20" class="tablecell"><b class="level2">ROI</b></td>
                                          <td width="7%" height="20" class="tablecell"> 
                                            <div align="right"><b><font size="2"></font></b></div>
                                          </td>
                                          <td width="7%" height="20" class="tablecell"> 
                                            <div align="right"><b><font size="2"></font></b></div>
                                          </td>
                                          <td width="9%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="23%" height="20" class="tablecell" valign="top"><b></b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b></b></b></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><b><b></b></b></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" height="20" class="tablecell"><b></b></td>
                                          <td width="18%" height="20" class="tablecell"><b>LABA 
                                            BERSIH</b></td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((labaBersihPrev/amountTotalHartaPrev)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="right"><font size="2"><b><%=strDisplayPercent((labaBersih/amountTotalHarta)*100, "")%>%</b></font></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell"> 
                                            <div align="center"><b></b><b></b></div>
                                          </td>
                                          <td rowspan="2" height="41" class="tablecell" valign="top"><b>Pengembalian 
                                            atas investasi yang tertanam</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(labaBersihPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(labaBersih, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" height="20" class="tablecell"> 
                                            <div align="center"><b></b></div>
                                          </td>
                                          <td width="3%" height="20" class="tablecell"><b></b></td>
                                          <td width="18%" height="20" class="tablecell"><b>TOTAL 
                                            HARTA</b></td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountTotalHartaPrev, "")%></div>
                                          </td>
                                          <td width="15%" height="20" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplay(amountTotalHarta, "")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="3%" class="tablecell1">&nbsp;</td>
                                          <td width="18%" class="tablecell1">&nbsp;</td>
                                          <td width="7%" class="tablecell1">&nbsp;</td>
                                          <td width="7%" class="tablecell1">&nbsp;</td>
                                          <td width="9%" class="tablecell1">&nbsp;</td>
                                          <td width="23%" class="tablecell1">&nbsp;</td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((labaBersihPrev/amountTotalHartaPrev)*100, "")%></div>
                                          </td>
                                          <td width="15%" bgcolor="#F0F0F0"> 
                                            <div align="right"><%=strDisplayPercent((labaBersih/amountTotalHarta)*100, "")%></div>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td><a href="javascript:cmdPrintXLS()"><img src="../images/print.gif" width="53" height="22" border="0"></a></td>
                                  </tr>
                                </table>
                              </td>
  </tr>
</table>
						  
						  
                          
                        </form>
						<%
							session.putValue("KONSTAN", rptKonstan);
							session.putValue("DETAIL", objReport);
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
