 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.asset.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.fms.report.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>

<%

	if(session.getValue("DETAIL")!=null){
		session.removeValue("DETAIL");
	}

//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
long itemMasterId = JSPRequestValue.requestLong(request, "item_master_id");
long assetDataId = JSPRequestValue.requestLong(request, "asset_data_id");
long stockId = JSPRequestValue.requestLong(request, "stock_id");
long periodId = JSPRequestValue.requestLong(request, "period_id");


Vector temp = DbPeriode.list(0,0, "", "start_date desc");
if(periodId==0 && temp!=null && temp.size()>0){
	Periode p = (Periode)temp.get(0);
	periodId = p.getOID();
}

Periode periode = new Periode();
try{
	periode = DbPeriode.fetchExc(periodId);
}
catch(Exception e){
}

Date dt = periode.getStartDate();
Date prevYear = new Date();
prevYear = (Date)dt.clone();
prevYear.setYear(prevYear.getYear()-2);
prevYear.setDate(31);
prevYear.setMonth(11);

Date prevMonth = new Date();
prevMonth = (Date)dt.clone();
prevMonth.setMonth(prevMonth.getMonth()-1);


//out.println("itemMasterId : "+itemMasterId);
//out.println("assetDataId : "+assetDataId);
//out.println("stockId : "+stockId);


/*variable declaration*/
String msgString = "";
int iErrCode = JSPMessage.NONE;
CmdAssetData ctrlAssetData = new CmdAssetData(request);

/*switch statement */
iErrCode = ctrlAssetData.action(iJSPCommand , assetDataId, stockId);
msgString =  ctrlAssetData.getMessage();
JspAssetData jspAssetData = ctrlAssetData.getForm();
AssetData assetDataObj = ctrlAssetData.getAssetData();

//out.println("iErrCode : "+iErrCode);
//out.println("jspAssetData : "+jspAssetData.getErrors());

ItemMaster itemMaster = new ItemMaster();
try{
	itemMaster = DbItemMaster.fetchExc(itemMasterId);
}
catch(Exception e){
}

Vector assetList = DbStock.getAssetList();
Vector coaFixedAsset = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_FIXED_ASSET+"'", "");
Vector coaExpense = DbCoa.list(0,0, "account_group='"+I_Project.ACC_GROUP_EXPENSE+"'", "");

Vector objReport = new Vector();
RptAktivaTetapL detail = new RptAktivaTetapL();

%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<%if(iJSPCommand==JSPCommand.EDIT || iErrCode!=0){%>
	window.location="#go";
<%}%>

function cmdPrintXLS(){	 
	window.open("<%=printroot%>.report.RptAktivaTetapXLS?oid=<%=appSessUser.getLoginId()%>");
}

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

function cmdChange(){
	document.form1.command.value="<%=JSPCommand.LIST%>";
	document.form1.action="assetreport.jsp";
	document.form1.submit();
}

function checkNumber(obj){
	var st = obj.value;
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}
<!--
function cmdSave(oid, oidAsset, stockId){
	document.form1.item_master_id.value=oid;
	document.form1.asset_data_id.value=oidAsset;
	document.form1.stock_id.value=stockId;
	document.form1.command.value="<%=JSPCommand.SAVE%>";
	document.form1.action="assetreport.jsp";
	document.form1.submit();
}

function cmdCancel(){
	document.form1.item_master_id.value="0";
	document.form1.asset_data_id.value="0";
	document.form1.command.value="<%=JSPCommand.BACK%>";
	document.form1.action="assetreport.jsp";
	document.form1.submit();
}


function cmdEdit(oid, oidStock){
	document.form1.item_master_id.value=oid;
	document.form1.stock_id.value=oidStock;
	document.form1.command.value="<%=JSPCommand.EDIT%>";
	document.form1.action="assetreport.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/save2.gif','../images/back2.gif','../images/printxls2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable --> </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --> 
                        <%
					  String navigator = "<font class=\"lvl1\">Asset Management</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Asset Report</span></font>";
					  %>
                        <%@ include file="../main/navigator.jsp"%>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
                          <input type="hidden" name="item_master_id" value="<%=itemMasterId%>">
                          <input type="hidden" name="asset_data_id" value="<%=assetDataId%>">
                          <input type="hidden" name="stock_id" value="<%=stockId%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=JspAssetData.colNames[JspAssetData.JSP_ITEM_MASTER_ID]%>" value="<%=itemMaster.getOID()%>">
                          <input type="hidden" name="<%=JspAssetData.colNames[JspAssetData.JSP_USER_ID]%>" value="<%=user.getOID()%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="14%">&nbsp;</td>
                                    <td colspan="2" width="78%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="8%"><b>Account Period</b></td>
                                    <td width="14%"><b>: &nbsp; 
                                      <select name="period_id" onChange="javascript:cmdChange()">
                                        <%if(temp!=null && temp.size()>0){
									   	for(int i=0; i<temp.size(); i++){
											Periode px = (Periode)temp.get(i);
									   %>
                                        <option value="<%=px.getOID()%>" <%if(px.getOID()==periodId){%>selected<%}%>><b><%=px.getName()%></b></option>
                                        <%}}%>
                                      </select>
                                      </b></td>
                                    <td colspan="2" width="78%">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="8%">&nbsp;</td>
                                    <td width="14%">&nbsp;</td>
                                    <td colspan="2" width="78%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td class="tablehdr" rowspan="2"><font size="1">NOMOR 
                                      INVENTARIS</font></td>
                                    <td class="tablehdr" rowspan="2"><font size="1">AKTIVA</font></td>
                                    <td class="tablehdr" rowspan="2" width="20"> 
                                      <p><font size="1">DLM<br>
                                        PRO<br>
                                        SEN<br>
                                        TASE</font></p>
                                    </td>
                                    <td class="tablehdr" rowspan="2" width="20"> 
                                      <p><font size="1">JML/<br>
                                        UNIT/<br>
                                        BH/<br>
                                        SET</font></p>
                                    </td>
                                    <td class="tablehdr" rowspan="2" width="20"><font size="1">TAHUN 
                                      <br>
                                      PERO<br>
                                      LEHAN</font></td>
                                    <td class="tablehdr" colspan="3"><font size="1">NILAI 
                                      PEROLEHAN</font></td>
                                    <td class="tablehdr" colspan="7"><font size="1">AKUMULASI 
                                      PENYUSUTAN</font></td>
                                    <td class="tablehdr" rowspan="2" width="50"><font size="1">NILAI 
                                      BUKU</font></td>
                                    <td class="tablehdr" rowspan="2" width="100"><font size="1">KETERANGAN</font></td>
                                  </tr>
                                  <tr> 
                                    <td class="tablehdr" width="50"><font size="1">S/D<br>
                                      <%=JSPFormater.formatDate(prevYear, "dd/MM/yyyy")%></font></td>
                                    <td class="tablehdr" width="50"><font size="1">PENAMBAH</font></td>
                                    <td class="tablehdr" width="50" nowrap><font size="1">SALDO 
                                      S/DSAAT INI</font></td>
                                    <td class="tablehdr" width="50"><font size="1">PER<br>
                                      <%=JSPFormater.formatDate(prevYear, "dd/MM/yyyy")%></font></td>
                                    <td class="tablehdr" width="50"><font size="1">SALDO 
                                      <%=JSPFormater.formatDate(prevMonth, "MMMM yy").toUpperCase()%></font></td>
                                    <td class="tablehdr" width="50"><font size="1">SO.S/D 
                                      <%=JSPFormater.formatDate(prevMonth, "MMMM yy").toUpperCase()%><br>
                                      </font></td>
                                    <td class="tablehdr" width="50"><font size="1">PENAMBAH<br>
                                      </font></td>
                                    <td class="tablehdr" width="50"><font size="1">PENGURANG<br>
                                      </font></td>
                                    <td class="tablehdr" width="50"><font size="1">SALDO 
                                      <%=JSPFormater.formatDate(periode.getStartDate(), "MMMM yy").toUpperCase()%></font></td>
                                    <td class="tablehdr" width="50"><font size="1">SALDO 
                                      S/D <%=JSPFormater.formatDate(periode.getStartDate(), "MMMM yy").toUpperCase()%></font></td>
                                  </tr>
                                  <%
								  
								  long groupId = 0;
								  long locationId = 0;
								  
								  double totalNilaiPerolehanSD = 0;
								  double totalNilaiPerolehanPenambah = 0;
								  double totalAkumSD = 0;
								  double totalAkumSaldoPrev = 0;
								  double totalAkumPenambah = 0;
								  double totalAkumPengurang = 0;
								  
								  double grandTotalNilaiPerolehanSD = 0;
								  double grandTotalNilaiPerolehanPenambah = 0;
								  double grandTotalAkumSD = 0;
								  double grandTotalAkumSaldoPrev = 0;
								  double grandTotalAkumPenambah = 0;
								  double grandTotalAkumPengurang = 0;
								  
								  double superTotalNilaiPerolehanSD = 0;
								  double superTotalNilaiPerolehanPenambah = 0;
								  double superTotalAkumSD = 0;
								  double superTotalAkumSaldoPrev = 0;
								  double superTotalAkumPenambah = 0;
								  double superTotalAkumPengurang = 0;
								  
								  if(assetList!=null && assetList.size()>0){
								 
									for(int i=0; i<assetList.size(); i++){
										Vector v = (Vector)assetList.get(i);
										
										
										ItemGroup ig = (ItemGroup)v.get(0);
										ItemMaster im = (ItemMaster)v.get(1);
										Location loc = (Location)v.get(2);
										Stock s = (Stock)v.get(3);
										
										AssetData assetData = new AssetData();
										Vector ads = DbAssetData.list(0,0, "item_master_id="+im.getOID(), "");
										boolean isEditable = true;
										if(ads!=null && ads.size()>0){
											assetData = (AssetData)ads.get(0);
											int cnt = DbAssetDataDepresiasi.getCount("asset_data_id="+assetData.getOID());
											if(cnt>0){
												isEditable = false;
											}
										}
										
										Coa akumDep = new Coa();
										Coa expDep = new Coa();
										try{
											akumDep = DbCoa.fetchExc(assetData.getCoaAkumDepId());
										}
										catch(Exception e){
										}
										try{
											expDep = DbCoa.fetchExc(assetData.getCoaExpenseDepId());
										}
										catch(Exception e){
										}
										
										
										if(s.getQty()>0 && assetData.getOID()!=0){
										
											//set value2
											//================================================================
											double nilaiPerolehanSD = 0;
											double nilaiPerolehanPenambah = 0;
											double akumSD = 0;
											double akumSaldoPrev = 0;
											double akumPenambah = 0;
											double akumPengurang = 0;
											
											
											if(assetData.getTglPerolehan().before(periode.getStartDate())||assetData.getTglPerolehan().equals(periode.getStartDate())){
											
												//jika pada prolehan sd											
												if(assetData.getTglPerolehan().before(prevYear)){
													nilaiPerolehanSD = assetData.getAmountPerolehan();												
												}
												else{
													nilaiPerolehanPenambah = assetData.getAmountPerolehan();
												}
											
												
												//akumulasi
												
												akumSD = assetData.getTotalDepreSebelum();
												//1. ambil total depre sebelum bulan lalu ( < prevMonth)
												prevMonth.setDate(1);
												akumSD = akumSD + DbAssetDataDepresiasi.getTotalDepreBeforeDate(prevMonth, assetData.getOID());
												//2. ambil depre bulan lalu (prevMonth)
												AssetDataDepresiasi akumPrevMonth = DbAssetDataDepresiasi.getObjDepreInDate(prevMonth, assetData.getOID());
												akumSaldoPrev = akumPrevMonth.getAmount()-akumPrevMonth.getPengurang();
												//3. ambil depre bulan ini (periode)
												AssetDataDepresiasi akumCurrMonth = DbAssetDataDepresiasi.getDepresiasiByPeriod(periode.getOID(), assetData.getOID());
												akumPenambah = akumCurrMonth.getAmount();
												akumPengurang = akumCurrMonth.getPengurang();
												
											}
																					
											//================================================================
										
											if(groupId!=ig.getOID()){
												
												groupId = ig.getOID();
												locationId = loc.getOID();
												
												//jika index pertama jangan munculkan total
												if(i!=0){
												
												//================ value total ====================\\
												double sldini = totalNilaiPerolehanSD+totalNilaiPerolehanPenambah;
												double so = totalAkumSD+totalAkumSaldoPrev;
												double saldo2 = totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang;
												double saldo3 = totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang;
												double nilaibk = totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang);
												
												//================ value grand total ================\\
												double tsldini = grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah;
												double tso = grandTotalAkumSD+grandTotalAkumSaldoPrev;
												double tsaldo2 = grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang;
												double tsaldo3 = grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang;
												double tnilaibk = grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah-(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang);
												//==========================================================\\
												
												
												//======================= Total ========================\\
												detail = new RptAktivaTetapL();
												
												detail.setLevel(7);// leve for total
												detail.setTotalPerolehanSd(totalNilaiPerolehanSD);
												detail.setTotalPerolehanPenambah(totalNilaiPerolehanPenambah);
												detail.setTotalPerolehanSaldoSaatIni(sldini);
												
												detail.setTotalPenyusutanPer(totalAkumSD);
												detail.setTotalPenyusutanSaldo1(totalAkumSaldoPrev);
												detail.setTotalPenyusutanSo(so);
												
												detail.setTotalPenyusutanPenambah(totalAkumPenambah);
												detail.setTotalPenyusutanPengurang(totalAkumPengurang);
												detail.setTotalPenyusutanSaldo2(saldo2);
												
												detail.setTotalPenyusutanSaldo3(saldo3);
												detail.setTotalNilaiBuku(nilaibk);
												objReport.add(detail);
												
												
												//========================== grand total ========================\\
												detail = new RptAktivaTetapL();
												
												detail.setLevel(8);// level for grand total
												detail.setTotalPerolehanSd2(grandTotalNilaiPerolehanSD);
												detail.setTotalPerolehanPenambah2(grandTotalNilaiPerolehanPenambah);
												detail.setTotalPerolehanSaldoSaatIni2(tsldini);
												
												detail.setTotalPenyusutanPer(grandTotalAkumSD);
												detail.setTotalPenyusutanSaldo11(grandTotalAkumSaldoPrev);
												detail.setTotalPenyusutanSo2(tso);
												
												detail.setTotalPenyusutanPenambah2(grandTotalAkumPenambah);
												detail.setTotalPenyusutanPengurang2(grandTotalAkumPengurang);
												detail.setTotalPenyusutanSaldo21(tsaldo2);
												
												detail.setTotalPenyusutanSaldo31(tsaldo3);
												detail.setTotalNilaiBuku2(tnilaibk);
												objReport.add(detail);		
								  %>
                                  <tr> 
                                    <td class="tablecell">&nbsp;</td>
                                    <td class="tablecell"> 
                                      <div align="center"><font size="1" color="#FF6600"><b>T 
                                        O T A L</b></font></div>
                                    </td>
                                    <td class="tablecell"><font color="#FF6600"></font></td>
                                    <td class="tablecell"><font color="#FF6600"></font></td>
                                    <td class="tablecell"><font size="1" color="#FF6600"></font></td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD==0) ? "" : JSPFormater.formatNumber(totalAkumSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(totalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD+totalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(totalAkumSD+totalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumPenambah==0) ? "" : JSPFormater.formatNumber(totalAkumPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang)==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td class="tablecell"><font size="1"></font></td>
                                  </tr>
                                  <tr> 
                                    <td class="tablecell">&nbsp;</td>
                                    <td class="tablecell"> 
                                      <div align="center"><font size="1" color="#990000"><b>G 
                                        R A N D T O T A L</b></font></div>
                                    </td>
                                    <td class="tablecell"><font color="#990000"></font></td>
                                    <td class="tablecell"><font color="#990000"></font></td>
                                    <td class="tablecell"><font size="1" color="#990000"></font></td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalNilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(grandTotalNilaiPerolehanSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(grandTotalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSD==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSD+grandTotalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSD+grandTotalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumPenambah==0) ? "" : JSPFormater.formatNumber(grandTotalAkumPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(grandTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah-(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang)==0) ? "" : JSPFormater.formatNumber(grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah-(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td class="tablecell"><font size="1"></font></td>
                                  </tr>
                                  <%}
								  
								  //reset total & grand total
								  totalNilaiPerolehanSD = nilaiPerolehanSD;
								  totalNilaiPerolehanPenambah = nilaiPerolehanPenambah;
								  totalAkumSD = akumSD;
								  totalAkumSaldoPrev = akumSaldoPrev;
								  totalAkumPenambah = akumPenambah;
								  totalAkumPengurang = akumPengurang;
								  
								  grandTotalNilaiPerolehanSD = nilaiPerolehanSD;
								  grandTotalNilaiPerolehanPenambah = nilaiPerolehanPenambah;
								  grandTotalAkumSD = akumSD;
								  grandTotalAkumSaldoPrev = akumSaldoPrev;
								  grandTotalAkumPenambah = akumPenambah;
								  grandTotalAkumPengurang = akumPengurang;
								  
								  superTotalNilaiPerolehanSD = superTotalNilaiPerolehanSD + nilaiPerolehanSD ;
								  superTotalNilaiPerolehanPenambah = superTotalNilaiPerolehanPenambah + nilaiPerolehanPenambah;
								  superTotalAkumSD = superTotalAkumSD + akumSD;
								  superTotalAkumSaldoPrev = superTotalAkumSaldoPrev + akumSaldoPrev;
								  superTotalAkumPenambah = superTotalAkumPenambah + akumPenambah;
								  superTotalAkumPengurang = superTotalAkumPengurang + akumPengurang;
								  
								    
									//====== for value report =======================
									detail = new RptAktivaTetapL();
									
									detail.setLevel(1);
									detail.setHeader1(ig.getName());
									detail.setHeader2(loc.getName());
									
									detail.setNomor(im.getCode());
									detail.setAktiva(im.getName());
									
									detail.setPersentase(assetData.getDepresiasiPercent());
									detail.setJumlahUnit(s.getQty());
									
									if(assetData.getTglPerolehan()!=null){// for date
									   detail.setTahunPerolehan(assetData.getTglPerolehan());
									}else{
									   detail.setTahunPerolehan(s.getDate());
									}
									
									detail.setPerolehanSd(nilaiPerolehanSD);
									detail.setPerolehanPenambahan(nilaiPerolehanPenambah);
									
									detail.setPenyusutanPer(akumSD);
									detail.setPenyusutanSaldo(akumSaldoPrev);
									
									detail.setPenyusutanPenambah(akumPenambah);
									detail.setPenyusutanPengurang(akumPengurang);
									detail.setKeterangan("");
									
									objReport.add(detail);
								  
								  %>
                                  <tr> 
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td><img src="../images/spacer.gif" width="25" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="25" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="25" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="50" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="50" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="60" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="50" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="50" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="50" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="50" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="50" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="60" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="60" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="60" height="8"></td>
                                    <td><img src="../images/spacer.gif" width="100" height="8"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="17"><b><%=ig.getName().toUpperCase()%></b></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="17" class="tablecell"><b class="level2"><%=loc.getName().toUpperCase()%></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="7%" class="tablecell1"> <font size="1"><%=im.getCode()%></font> </td>
                                    <td width="15%" class="tablecell1" nowrap><font size="1"><%=im.getName()%></font></td>
                                    <td width="20" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent()==0) ? "" : ""+assetData.getDepresiasiPercent()%>%</font></div>
                                    </td>
                                    <td width="20" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=s.getQty()%></font></div>
                                    </td>
                                    <td width="20" class="tablecell1" nowrap> 
                                      <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan()!=null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(nilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(nilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(nilaiPerolehanSD+nilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD+nilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumSD==0) ? "" : JSPFormater.formatNumber(akumSD, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumSaldoPrev==0) ? "" : JSPFormater.formatNumber(akumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumSD+akumSaldoPrev==0) ? "" : JSPFormater.formatNumber(akumSD+akumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumPenambah==0) ? "" : JSPFormater.formatNumber(akumPenambah, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumPengurang==0) ? "" : JSPFormater.formatNumber(akumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumSaldoPrev+akumPenambah-akumPengurang==0) ? "" : JSPFormater.formatNumber(akumSaldoPrev+akumPenambah-akumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(akumSD+akumSaldoPrev+akumPenambah-akumPengurang==0) ? "" : JSPFormater.formatNumber(akumSD+akumSaldoPrev+akumPenambah-akumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(nilaiPerolehanSD+nilaiPerolehanPenambah-(akumSD+akumSaldoPrev+akumPenambah-akumPengurang)==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD+nilaiPerolehanPenambah-(akumSD+akumSaldoPrev+akumPenambah-akumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td width="100" class="tablecell1">&nbsp;</td>
                                  </tr>
                                  <%
								  
								  }//end if group beda
								  else{
								  	//jika lokasi beda
								  	if(locationId!=loc.getOID()){
										locationId = loc.getOID();
										
										    //================ value total ====================\\
											double sldini = totalNilaiPerolehanSD+totalNilaiPerolehanPenambah;
											double so = totalAkumSD+totalAkumSaldoPrev;
											double saldo2 = totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang;
											double saldo3 = totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang;
											double nilaibk = totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang);
											
											
											//======================= Total ========================\\
											detail = new RptAktivaTetapL();
											
											detail.setLevel(7);// leve for total
											detail.setTotalPerolehanSd(totalNilaiPerolehanSD);
											detail.setTotalPerolehanPenambah(totalNilaiPerolehanPenambah);
											detail.setTotalPerolehanSaldoSaatIni(sldini);
											
											detail.setTotalPenyusutanPer(totalAkumSD);
											detail.setTotalPenyusutanSaldo1(totalAkumSaldoPrev);
											detail.setTotalPenyusutanSo(so);
											
											detail.setTotalPenyusutanPenambah(totalAkumPenambah);
											detail.setTotalPenyusutanPengurang(totalAkumPengurang);
											detail.setTotalPenyusutanSaldo2(saldo2);
											
											detail.setTotalPenyusutanSaldo3(saldo3);
											detail.setTotalNilaiBuku(nilaibk);
											objReport.add(detail);
										
									%>
                                  <tr> 
                                    <td class="tablecell">&nbsp;</td>
                                    <td class="tablecell"> 
                                      <div align="center"><font color="#FF6600"><b><font size="1">T 
                                        O T A L</font></b></font></div>
                                    </td>
                                    <td class="tablecell"><font color="#FF6600"></font></td>
                                    <td class="tablecell"><font color="#FF6600"></font></td>
                                    <td class="tablecell"><font color="#FF6600"></font></td>
                                    <td class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD==0) ? "" : JSPFormater.formatNumber(totalAkumSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(totalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD+totalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(totalAkumSD+totalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumPenambah==0) ? "" : JSPFormater.formatNumber(totalAkumPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang)==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td class="tablecell">&nbsp;</td>
                                  </tr>
                                  <%
								  
								  //reset total & grand total
								  totalNilaiPerolehanSD = nilaiPerolehanSD;
								  totalNilaiPerolehanPenambah = nilaiPerolehanPenambah;
								  totalAkumSD = akumSD;
								  totalAkumSaldoPrev = akumSaldoPrev;
								  totalAkumPenambah = akumPenambah;
								  totalAkumPengurang = akumPengurang;
								  
								  grandTotalNilaiPerolehanSD = grandTotalNilaiPerolehanSD + nilaiPerolehanSD;
								  grandTotalNilaiPerolehanPenambah = grandTotalNilaiPerolehanPenambah + nilaiPerolehanPenambah;
								  grandTotalAkumSD = grandTotalAkumSD + akumSD;
								  grandTotalAkumSaldoPrev = grandTotalAkumSaldoPrev + akumSaldoPrev;
								  grandTotalAkumPenambah = grandTotalAkumPenambah + akumPenambah;
								  grandTotalAkumPengurang = grandTotalAkumPengurang + akumPengurang;
								  
								  superTotalNilaiPerolehanSD = superTotalNilaiPerolehanSD + nilaiPerolehanSD ;
								  superTotalNilaiPerolehanPenambah = superTotalNilaiPerolehanPenambah + nilaiPerolehanPenambah;
								  superTotalAkumSD = superTotalAkumSD + akumSD;
								  superTotalAkumSaldoPrev = superTotalAkumSaldoPrev + akumSaldoPrev;
								  superTotalAkumPenambah = superTotalAkumPenambah + akumPenambah;
								  superTotalAkumPengurang = superTotalAkumPengurang + akumPengurang;
								  
								  		//=================== for set value report ================== \\		
										detail = new RptAktivaTetapL();
									
										detail.setLevel(2);
										//detail.setHeader1('');
										detail.setHeader2(loc.getName());
										
										detail.setNomor(im.getCode());
										detail.setAktiva(im.getName());
										
										detail.setPersentase(assetData.getDepresiasiPercent());
										detail.setJumlahUnit(s.getQty());
										
										if(assetData.getTglPerolehan()!=null){// for date
										   detail.setTahunPerolehan(assetData.getTglPerolehan());
										}else{
										   detail.setTahunPerolehan(s.getDate());
										}
										
										detail.setPerolehanSd(nilaiPerolehanSD);
										detail.setPerolehanPenambahan(nilaiPerolehanPenambah);
										
										detail.setPenyusutanPer(akumSD);
										detail.setPenyusutanSaldo(akumSaldoPrev);
										
										detail.setPenyusutanPenambah(akumPenambah);
										detail.setPenyusutanPengurang(akumPengurang);
										detail.setKeterangan("");
										
										objReport.add(detail);
								  
								  %>
                                  <tr> 
                                    <td colspan="17" class="tablecell"><b class="level2"><%=loc.getName().toUpperCase()%></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="7%" class="tablecell1"> <font size="1"><%=im.getCode()%></font> </td>
                                    <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                    <td width="20" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent()==0) ? "" : ""+assetData.getDepresiasiPercent()%>%</font></div>
                                    </td>
                                    <td width="20" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=s.getQty()%></font></div>
                                    </td>
                                    <td width="20" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan()!=null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(nilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(nilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(nilaiPerolehanSD+nilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD+nilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumSD==0) ? "" : JSPFormater.formatNumber(akumSD, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumSaldoPrev==0) ? "" : JSPFormater.formatNumber(akumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumSD+akumSaldoPrev==0) ? "" : JSPFormater.formatNumber(akumSD+akumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumPenambah==0) ? "" : JSPFormater.formatNumber(akumPenambah, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumPengurang==0) ? "" : JSPFormater.formatNumber(akumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><%=(akumSaldoPrev+akumPenambah-akumPengurang==0) ? "" : JSPFormater.formatNumber(akumSaldoPrev+akumPenambah-akumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(akumSD+akumSaldoPrev+akumPenambah-akumPengurang==0) ? "" : JSPFormater.formatNumber(akumSD+akumSaldoPrev+akumPenambah-akumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(nilaiPerolehanSD+nilaiPerolehanPenambah-(akumSD+akumSaldoPrev+akumPenambah-akumPengurang)==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD+nilaiPerolehanPenambah-(akumSD+akumSaldoPrev+akumPenambah-akumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td width="100" class="tablecell1">&nbsp;</td>
                                  </tr>
                                  <%//end editor
								}//end if loc beda
								else{
									
									
								  
								  //reset total & grand total
								  totalNilaiPerolehanSD = totalNilaiPerolehanSD + nilaiPerolehanSD;
								  totalNilaiPerolehanPenambah = totalNilaiPerolehanPenambah + nilaiPerolehanPenambah;
								  totalAkumSD = totalAkumSD + akumSD;
								  totalAkumSaldoPrev = totalAkumSaldoPrev + akumSaldoPrev;
								  totalAkumPenambah = totalAkumPenambah + akumPenambah;
								  totalAkumPengurang = totalAkumPengurang + akumPengurang;
								  
								  grandTotalNilaiPerolehanSD = grandTotalNilaiPerolehanSD + nilaiPerolehanSD;
								  grandTotalNilaiPerolehanPenambah = grandTotalNilaiPerolehanPenambah + nilaiPerolehanPenambah;
								  grandTotalAkumSD = grandTotalAkumSD + akumSD;
								  grandTotalAkumSaldoPrev = grandTotalAkumSaldoPrev + akumSaldoPrev;
								  grandTotalAkumPenambah = grandTotalAkumPenambah + akumPenambah;
								  grandTotalAkumPengurang = grandTotalAkumPengurang + akumPengurang;
								  
								  superTotalNilaiPerolehanSD = superTotalNilaiPerolehanSD + nilaiPerolehanSD ;
								  superTotalNilaiPerolehanPenambah = superTotalNilaiPerolehanPenambah + nilaiPerolehanPenambah;
								  superTotalAkumSD = superTotalAkumSD + akumSD;
								  superTotalAkumSaldoPrev = superTotalAkumSaldoPrev + akumSaldoPrev;
								  superTotalAkumPenambah = superTotalAkumPenambah + akumPenambah;
								  superTotalAkumPengurang = superTotalAkumPengurang + akumPengurang;
								  
								        //=================== for set value report ================== \\		
										detail = new RptAktivaTetapL();
									
										detail.setLevel(3);
										//detail.setHeader1('');
										//detail.setHeader2('');
										
										detail.setNomor(im.getCode());
										detail.setAktiva(im.getName());
										
										detail.setPersentase(assetData.getDepresiasiPercent());
										detail.setJumlahUnit(s.getQty());
										
										if(assetData.getTglPerolehan()!=null){// for date
										   detail.setTahunPerolehan(assetData.getTglPerolehan());
										}else{
										   detail.setTahunPerolehan(s.getDate());
										}
										
										detail.setPerolehanSd(nilaiPerolehanSD);
										detail.setPerolehanPenambahan(nilaiPerolehanPenambah);
										
										detail.setPenyusutanPer(akumSD);
										detail.setPenyusutanSaldo(akumSaldoPrev);
										
										detail.setPenyusutanPenambah(akumPenambah);
										detail.setPenyusutanPengurang(akumPengurang);
										detail.setKeterangan("");
										
										objReport.add(detail);		
								
								%>
                                  <tr> 
                                    <td width="7%" class="tablecell1"> <font size="1"><%=im.getCode()%></font> </td>
                                    <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                    <td width="20" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent()==0) ? "" : ""+assetData.getDepresiasiPercent()%>%</font></div>
                                    </td>
                                    <td width="20" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=s.getQty()%></font></div>
                                    </td>
                                    <td width="20" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan()!=null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><font size="1"><%=(nilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD, "#,###")%></font></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><font size="1"><%=(nilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanPenambah, "#,###")%></font></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(nilaiPerolehanSD+nilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD+nilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><font size="1"><%=(akumSD==0) ? "" : JSPFormater.formatNumber(akumSD, "#,###")%></font></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><font size="1"><%=(akumSaldoPrev==0) ? "" : JSPFormater.formatNumber(akumSaldoPrev, "#,###")%></font></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><font size="1"><%=(akumSD+akumSaldoPrev==0) ? "" : JSPFormater.formatNumber(akumSD+akumSaldoPrev, "#,###")%></font></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><font size="1"><%=(akumPenambah==0) ? "" : JSPFormater.formatNumber(akumPenambah, "#,###")%></font></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><font size="1"><%=(akumPengurang==0) ? "" : JSPFormater.formatNumber(akumPengurang, "#,###")%></font></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1"><font size="1"><%=(akumSaldoPrev+akumPenambah-akumPengurang==0) ? "" : JSPFormater.formatNumber(akumSaldoPrev+akumPenambah-akumPengurang, "#,###")%></font></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(akumSD+akumSaldoPrev+akumPenambah-akumPengurang==0) ? "" : JSPFormater.formatNumber(akumSD+akumSaldoPrev+akumPenambah-akumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td width="50" class="tablecell1" nowrap> 
                                      <div align="right"><font size="1" color="#0033CC"><%=(nilaiPerolehanSD+nilaiPerolehanPenambah-(akumSD+akumSaldoPrev+akumPenambah-akumPengurang)==0) ? "" : JSPFormater.formatNumber(nilaiPerolehanSD+nilaiPerolehanPenambah-(akumSD+akumSaldoPrev+akumPenambah-akumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td width="100" class="tablecell1">&nbsp;</td>
                                  </tr>
                                  <%//end editor
								  }	
								 }%>
                                  <%								  
								  }// if > 0
								  }
								  
								  // for
								  
								  	            //================ value total ====================\\
												double sldini = totalNilaiPerolehanSD+totalNilaiPerolehanPenambah;
												double so = totalAkumSD+totalAkumSaldoPrev;
												double saldo2 = totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang;
												double saldo3 = totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang;
												double nilaibk = totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang);
												
												//================ value grand total ================\\
												double tsldini = grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah;
												double tso = grandTotalAkumSD+grandTotalAkumSaldoPrev;
												double tsaldo2 = grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang;
												double tsaldo3 = grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang;
												double tnilaibk = grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah-(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang);
												
												//================ total akhir ================\\
												double tasldini = superTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah;
												double taso = superTotalAkumSD+superTotalAkumSaldoPrev;
												double tasaldo2 = superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang;
												double tasaldo3 = superTotalAkumSD+superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang;
												double tanilaibk = superTotalNilaiPerolehanSD+superTotalNilaiPerolehanPenambah-(superTotalAkumSD+superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang);
												//==========================================================\\
												
												
												//======================= Total ========================\\
												detail = new RptAktivaTetapL();
												
												detail.setLevel(7);// leve for total
												detail.setTotalPerolehanSd(totalNilaiPerolehanSD);
												detail.setTotalPerolehanPenambah(totalNilaiPerolehanPenambah);
												detail.setTotalPerolehanSaldoSaatIni(sldini);
												
												detail.setTotalPenyusutanPer(totalAkumSD);
												detail.setTotalPenyusutanSaldo1(totalAkumSaldoPrev);
												detail.setTotalPenyusutanSo(so);
												
												detail.setTotalPenyusutanPenambah(totalAkumPenambah);
												detail.setTotalPenyusutanPengurang(totalAkumPengurang);
												detail.setTotalPenyusutanSaldo2(saldo2);
												
												detail.setTotalPenyusutanSaldo3(saldo3);
												detail.setTotalNilaiBuku(nilaibk);
												objReport.add(detail);
												
												
												//========================== grand total ========================\\
												detail = new RptAktivaTetapL();
												
												detail.setLevel(8);// level for grand total
												detail.setTotalPerolehanSd2(grandTotalNilaiPerolehanSD);
												detail.setTotalPerolehanPenambah2(grandTotalNilaiPerolehanPenambah);
												detail.setTotalPerolehanSaldoSaatIni2(tsldini);
												
												detail.setTotalPenyusutanPer(grandTotalAkumSD);
												detail.setTotalPenyusutanSaldo11(grandTotalAkumSaldoPrev);
												detail.setTotalPenyusutanSo2(tso);
												
												detail.setTotalPenyusutanPenambah2(grandTotalAkumPenambah);
												detail.setTotalPenyusutanPengurang2(grandTotalAkumPengurang);
												detail.setTotalPenyusutanSaldo21(tsaldo2);
												
												detail.setTotalPenyusutanSaldo31(tsaldo3);
												detail.setTotalNilaiBuku2(tnilaibk);
												objReport.add(detail);
												
												
												//========================== total akhir ========================\\
												detail = new RptAktivaTetapL();
												
												detail.setLevel(9);// level for grand total
												detail.setTaPerolehanSd(superTotalNilaiPerolehanSD);
												detail.setTaPerolehanPenambahan(superTotalNilaiPerolehanPenambah);
												detail.setTaPerolehanSaldoSaatIni(tasldini);
												
												detail.setTaPenyusutanPer(superTotalAkumSD);
												detail.setTaPenyusutanSaldo1(superTotalAkumSaldoPrev);
												detail.setTaPenyusutanSo(taso);
												
												detail.setTaPenyusutanPenambahan(superTotalAkumPenambah);
												detail.setTaPenyusutanPengurangan(superTotalAkumPengurang);
												detail.setTaPenyusutanSaldo2(tasaldo2);
												
												detail.setTaPenyusutanSaldo3(tasaldo3);
												detail.setTaNilaiBuku(tanilaibk);
												objReport.add(detail);
								  
								  %>
                                  <tr> 
                                    <td class="tablecell">&nbsp;</td>
                                    <td class="tablecell"> 
                                      <div align="center"><font size="1" color="#FF6600"><b>T 
                                        O T A L</b></font></div>
                                    </td>
                                    <td class="tablecell"><font color="#FF6600"></font></td>
                                    <td class="tablecell"><font color="#FF6600"></font></td>
                                    <td class="tablecell"><font color="#FF6600"></font></td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD==0) ? "" : JSPFormater.formatNumber(totalAkumSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(totalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD+totalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(totalAkumSD+totalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumPenambah==0) ? "" : JSPFormater.formatNumber(totalAkumPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang==0) ? "" : JSPFormater.formatNumber(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#FF6600"><%=(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang)==0) ? "" : JSPFormater.formatNumber(totalNilaiPerolehanSD+totalNilaiPerolehanPenambah-(totalAkumSD+totalAkumSaldoPrev+totalAkumPenambah-totalAkumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td class="tablecell">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td class="tablecell">&nbsp;</td>
                                    <td class="tablecell"> 
                                      <div align="center"><font size="1" color="#990000"><b>G 
                                        R A N D T O T A L</b></font></div>
                                    </td>
                                    <td class="tablecell"><font color="#990000"></font></td>
                                    <td class="tablecell"><font color="#990000"></font></td>
                                    <td class="tablecell"><font color="#990000"></font></td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalNilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(grandTotalNilaiPerolehanSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(grandTotalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSD==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSD+grandTotalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSD+grandTotalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumPenambah==0) ? "" : JSPFormater.formatNumber(grandTotalAkumPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(grandTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#990000"><%=(grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah-(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang)==0) ? "" : JSPFormater.formatNumber(grandTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah-(grandTotalAkumSD+grandTotalAkumSaldoPrev+grandTotalAkumPenambah-grandTotalAkumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td class="tablecell">&nbsp;</td>
                                  </tr>
                                  <%}// if ada%>
                                  <tr> 
                                    <td width="7%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="100">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="7%" class="tablecell">&nbsp;</td>
                                    <td width="15%" class="tablecell"> 
                                      <div align="center"><font color="#000066"><b>TOTAL 
                                        AKHIR INVENTARIS</b></font></div>
                                    </td>
                                    <td width="20" class="tablecell"><font color="#000066"></font></td>
                                    <td width="20" class="tablecell"><font color="#000066"></font></td>
                                    <td width="20" class="tablecell"><font color="#000066"></font></td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalNilaiPerolehanSD==0) ? "" : JSPFormater.formatNumber(superTotalNilaiPerolehanSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(superTotalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah==0) ? "" : JSPFormater.formatNumber(superTotalNilaiPerolehanSD+grandTotalNilaiPerolehanPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalAkumSD==0) ? "" : JSPFormater.formatNumber(superTotalAkumSD, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(superTotalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalAkumSD+grandTotalAkumSaldoPrev==0) ? "" : JSPFormater.formatNumber(superTotalAkumSD+superTotalAkumSaldoPrev, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalAkumPenambah==0) ? "" : JSPFormater.formatNumber(superTotalAkumPenambah, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(superTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalAkumSD+superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang==0) ? "" : JSPFormater.formatNumber(superTotalAkumSD+superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang, "#,###")%></font></div>
                                    </td>
                                    <td nowrap width="50" class="tablecell"> 
                                      <div align="right"><font size="1" color="#000066"><%=(superTotalNilaiPerolehanSD+superTotalNilaiPerolehanPenambah-(superTotalAkumSD+superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang)==0) ? "" : JSPFormater.formatNumber(superTotalNilaiPerolehanSD+superTotalNilaiPerolehanPenambah-(superTotalAkumSD+superTotalAkumSaldoPrev+superTotalAkumPenambah-superTotalAkumPengurang), "#,###")%></font></div>
                                    </td>
                                    <td width="100" class="tablecell">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="7%" class="tablecell1">&nbsp;</td>
                                    <td width="15%" class="tablecell1">&nbsp;</td>
                                    <td width="20" class="tablecell1">&nbsp;</td>
                                    <td width="20" class="tablecell1">&nbsp;</td>
                                    <td width="20" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="50" class="tablecell1">&nbsp;</td>
                                    <td width="100" class="tablecell1">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="7%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="100">&nbsp;</td>
                                  </tr>
                                  <tr>
								    <%if(assetList!=null && assetList.size()>0){ %>
                                    <td colspan="2"><a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                    <%}%>
									<td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="100">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="7%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="100">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="7%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="100">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="7%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="20">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="50">&nbsp;</td>
                                    <td width="100">&nbsp;</td>
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
