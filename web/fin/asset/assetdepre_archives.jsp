 
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
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>

<%
//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
long itemMasterId = JSPRequestValue.requestLong(request, "item_master_id");
long assetDataId = JSPRequestValue.requestLong(request, "asset_data_id");
long stockId = JSPRequestValue.requestLong(request, "stock_id");

long periodId = JSPRequestValue.requestLong(request, "period_id");


//out.println("assetDataId : "+assetDataId);
//out.println("stockId : "+stockId);

Vector temp = DbPeriode.list(0,0, "", "start_date desc");
if(periodId==0 && temp!=null && temp.size()>0){
	Periode p = (Periode)temp.get(0);
	periodId = p.getOID();
}

//out.println("periodId : "+periodId);

/*variable declaration*/
String msgString = "";
int iErrCode = JSPMessage.NONE;
CmdAssetData ctrlAssetData = new CmdAssetData(request);

/*switch statement */
//iErrCode = ctrlAssetData.action(iJSPCommand , assetDataId, stockId);
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

Vector assetList = DbStock.getAssetListDepreciation(periodId);

int count = DbAssetDataDepresiasi.getCount("periode_id="+periodId);

Vector vx = DbAssetDataDepresiasi.list(0,0, "periode_id="+periodId, "");
AssetDataDepresiasi ax = new AssetDataDepresiasi();
if(vx!=null && vx.size()>0){
	count = 10;
	ax = (AssetDataDepresiasi)vx.get(0);
}

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
	document.form1.action="assetdepre_archives.jsp";
	document.form1.submit();
}

function checkNumber(obj){
	var st = obj.value;	
	result = removeChar(st);
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	obj.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function cmdCancel(){
	document.form1.item_master_id.value="0";
	document.form1.asset_data_id.value="0";
	document.form1.command.value="<%=JSPCommand.BACK%>";
	document.form1.action="assetdepre_archives.jsp";
	document.form1.submit();
}


function cmdEdit(oid, oidStock){
	document.form1.item_master_id.value=oid;
	document.form1.stock_id.value=oidStock;
	document.form1.command.value="<%=JSPCommand.EDIT%>";
	document.form1.action="assetdepre_archives.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/save2.gif','../images/back2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Asset Management</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Depreciation Archives</span></font>";
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
						  <input type="hidden" name="item_master_id" value="<%=itemMasterId%>">
						  <input type="hidden" name="asset_data_id" value="<%=assetDataId%>">
						  <input type="hidden" name="stock_id" value="<%=stockId%>">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  
						  <input type="hidden" name="<%=JspAssetData.colNames[JspAssetData.JSP_ITEM_MASTER_ID]%>" value="<%=itemMaster.getOID()%>">
						  <input type="hidden" name="<%=JspAssetData.colNames[JspAssetData.JSP_USER_ID]%>" value="<%=user.getOID()%>">
						  
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="container">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="7%" height="27">Date</td>
                                    <td width="15%" height="27"><b>: &nbsp;<%=(ax.getDate()==null) ? "-" : JSPFormater.formatDate(ax.getDate(), "dd MMMM yyyy")%></b></td>
                                    <td width="9%" height="27">Doc. Number</td>
                                    <td width="69%" height="27"><b>:&nbsp; <%=ax.getNumber()%></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="7%">Period</td>
                                    <td width="15%"><b>: &nbsp;
                                      <select name="period_id" onChange="javascript:cmdChange()">
									   <%if(temp!=null && temp.size()>0){
									   	for(int i=0; i<temp.size(); i++){
											Periode px = (Periode)temp.get(i);
									   %>
                                        <option value="<%=px.getOID()%>" <%if(px.getOID()==periodId){%>selected<%}%>><%=px.getName()%></option>
										<%}}%>
                                      </select>
                                      </b></td>
                                    <td colspan="2">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td class="tablehdr" width="7%"><font size="1">NOMOR 
                                      INVENTARIS</font></td>
                                    <td class="tablehdr" width="15%"><font size="1">AKTIVA</font></td>
                                    <td class="tablehdr" width="4%"> 
                                      <p><font size="1">DLM<br>
                                        PRO<br>
                                        SEN<br>
                                        TASE</font></p>
                                    </td>
                                    <td class="tablehdr" width="4%"> 
                                      <p><font size="1">JML/<br>
                                        UNIT/<br>
                                        BH/<br>
                                        SET</font></p>
                                    </td>
                                    <td class="tablehdr" width="5%"><font size="1">TAHUN 
                                      <br>
                                      PERO<br>
                                      LEHAN</font></td>
                                    <td class="tablehdr" width="7%"><font size="1">COA 
                                      AKUM DEPRESIASI</font></td>
                                    <td class="tablehdr" width="7%"><font size="1">COA 
                                      EXPENSE DEPRESIASI</font></td>
                                    <td class="tablehdr" width="7%"><font size="1">NILAI 
                                      PEROLEHAN</font></td>
                                    <td class="tablehdr" width="6%"><font size="1">RESIDU</font></td>
                                    <td class="tablehdr" width="7%"><font size="1">TOTAL<br>
                                      DEPRESIASI<br>
                                      SEBELUMNYA</font></td>
                                    <td class="tablehdr" width="7%"><font size="1">JML 
                                      DEPRESIASI<br>
                                      PERIODE INI</font></td>
                                    <td class="tablehdr" width="5%">PENGURANG</td>
                                    <td class="tablehdr" width="5%"><font size="1">STATUS 
                                      DEPRESIASI PERIODE INI</font></td>
                                  </tr>
                                  <%
								  
								  long groupId = 0;
								  long locationId = 0;
								  
								  if(assetList!=null && assetList.size()>0){
								 
									for(int i=0; i<assetList.size(); i++){
										Vector v = (Vector)assetList.get(i);
										
										ItemGroup ig = (ItemGroup)v.get(0);
										ItemMaster im = (ItemMaster)v.get(1);
										Location loc = (Location)v.get(2);
										Stock s = (Stock)v.get(3);
										
										AssetData assetData = new AssetData();
										Vector ads = DbAssetData.list(0,0, "item_master_id="+im.getOID(), "");
										boolean isPosted = false;
										double totalDepre = 0;
										if(ads!=null && ads.size()>0){
											assetData = (AssetData)ads.get(0);
											totalDepre = DbAssetDataDepresiasi.getTotalDepresiasi(assetData.getOID());
											int cnt = DbAssetDataDepresiasi.getCount("asset_data_id="+assetData.getOID()+" and periode_id="+periodId);
											if(cnt>0){
												isPosted = true;
											}
										}
										
										AssetDataDepresiasi assetDataDepresiasi = new AssetDataDepresiasi();
										Vector adsDeps = DbAssetDataDepresiasi.list(0,0, "asset_data_id="+assetData.getOID()+" and periode_id="+periodId, "");
										if(adsDeps!=null && adsDeps.size()>0){
											assetDataDepresiasi = (AssetDataDepresiasi)adsDeps.get(0);
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
										
										boolean isDepreciated = false;
										//jika masih ada sisa 										
										if((assetData.getAmountPerolehan()-assetData.getResidu())>totalDepre){
											isDepreciated = true;
										}										
										
										if(s.getQty()>0 && isDepreciated){
										
											if(groupId!=ig.getOID()){
												groupId = ig.getOID();
												locationId = loc.getOID();
								  %>
                                  <tr> 
                                    <td colspan="13">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td colspan="13"><b><%=ig.getName().toUpperCase()%></b></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="13" class="tablecell"><b class="level2"><%=loc.getName().toUpperCase()%></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="7%" class="tablecell1"><font size="1"><%=im.getCode()%></font></td>
                                    <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                    <td width="4%" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent()==0) ? "" : ""+assetData.getDepresiasiPercent()%>%</font></div>
                                    </td>
                                    <td width="4%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                    </td>
                                    <td width="5%" class="tablecell1" nowrap> 
                                      <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan()!=null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"><%=akumDep.getCode()+"/"+akumDep.getName()%></td>
                                    <td width="7%" class="tablecell1"><%=expDep.getCode()+"/"+expDep.getName()%></td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=JSPFormater.formatNumber(s.getQty()*im.getCogs(), "#,###")%></font></div>
                                    </td>
                                    <td width="6%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(assetData.getResidu()==0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(totalDepre==0) ? "" : JSPFormater.formatNumber(totalDepre, "#,###")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(assetData.getMthDepresiasi()==0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%></font></div>
                                    </td>
                                    <td width="5%" class="tablecell1">
										<%if(isPosted){%>
										<div align="right"> 
                                        <%=JSPFormater.formatNumber(assetDataDepresiasi.getPengurang(), "#,###")%> 
										</div>
                                        <%}else{%>                                        
                                      <div align="center"> 
                                        <input type="text" name="<%=im.getOID()%>_pengurang" size="15" value="<%=JSPFormater.formatNumber(assetDataDepresiasi.getPengurang(), "#,###")%>" style="text-align:right">
                                      </div>									  
                                        <%}%> 
                                    </td>
                                    <td width="5%" class="tablecell1"> 
                                      <div align="center"> 
                                        <%if(isPosted){%>
                                        <b>Posted</b> 
                                        <%}else{%>
                                        - 
                                        <%}%>
                                      </div>
                                    </td>
                                  </tr>
                                  <%
								  	
								  }//end if group beda
								  else{
								  	//jika lokasi beda
								  	if(locationId!=loc.getOID()){
										locationId = loc.getOID();
									%>
                                  <tr> 
                                    <td colspan="13" class="tablecell"><b class="level2"><%=loc.getName().toUpperCase()%></b></td>
                                  </tr>
                                  <tr> 
                                    <td width="7%" class="tablecell1"><font size="1"><%=im.getCode()%></font></td>
                                    <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                    <td width="4%" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent()==0) ? "" : ""+assetData.getDepresiasiPercent()%>%</font></div>
                                    </td>
                                    <td width="4%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                    </td>
                                    <td width="5%" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan()!=null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"><%=akumDep.getCode()+"/"+akumDep.getName()%></td>
                                    <td width="7%" class="tablecell1"><%=expDep.getCode()+"/"+expDep.getName()%></td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=JSPFormater.formatNumber(s.getQty()*im.getCogs(), "#,###")%></font></div>
                                    </td>
                                    <td width="6%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(assetData.getResidu()==0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(totalDepre==0) ? "" : JSPFormater.formatNumber(totalDepre, "#,###")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(assetData.getMthDepresiasi()==0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%></font></div>
                                    </td>
                                    <td width="5%" class="tablecell1"> 
                                     <%if(isPosted){%>
										<div align="right"> 
                                        <%=JSPFormater.formatNumber(assetDataDepresiasi.getPengurang(), "#,###")%> 
										</div>
                                        <%}else{%>                                        
                                      <div align="center"> 
                                        <input type="text" name="<%=im.getOID()%>_pengurang" size="15" value="<%=JSPFormater.formatNumber(assetDataDepresiasi.getPengurang(), "#,###")%>" style="text-align:right">
                                      </div>									  
                                        <%}%> 
                                    </td>
                                    <td width="5%" class="tablecell1"> 
                                      <div align="center"> 
                                        <%if(isPosted){%>
                                        <b>Posted</b> 
                                        <%}else{%>
                                        - 
                                        <%}%>
                                      </div>
                                    </td>
                                  </tr>
                                  <%
								}//end if loc beda
								else{
								%>
                                  <tr> 
                                    <td width="7%" class="tablecell1"><font size="1"><%=im.getCode()%></font></td>
                                    <td width="15%" class="tablecell1"><font size="1"><%=im.getName()%></font></td>
                                    <td width="4%" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=(assetData.getDepresiasiPercent()==0) ? "" : ""+assetData.getDepresiasiPercent()%>%</font></div>
                                    </td>
                                    <td width="4%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=s.getQty()%></font></div>
                                    </td>
                                    <td width="5%" class="tablecell1"> 
                                      <div align="center"><font size="1"><%=JSPFormater.formatDate((assetData.getTglPerolehan()!=null) ? assetData.getTglPerolehan() : s.getDate(), "dd/MM/yyyy")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"><%=akumDep.getCode()+"/"+akumDep.getName()%></td>
                                    <td width="7%" class="tablecell1"><%=expDep.getCode()+"/"+expDep.getName()%></td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=JSPFormater.formatNumber(s.getQty()*im.getCogs(), "#,###")%></font></div>
                                    </td>
                                    <td width="6%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(assetData.getResidu()==0) ? "" : JSPFormater.formatNumber(assetData.getResidu(), "#,###")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(totalDepre==0) ? "" : JSPFormater.formatNumber(totalDepre, "#,###")%></font></div>
                                    </td>
                                    <td width="7%" class="tablecell1"> 
                                      <div align="right"><font size="1"><%=(assetData.getMthDepresiasi()==0) ? "" : JSPFormater.formatNumber(assetData.getMthDepresiasi(), "#,###")%></font></div>
                                    </td>
                                    <td width="5%" class="tablecell1"> 
                                      <%if(isPosted){%>
										<div align="right"> 
                                        <%=JSPFormater.formatNumber(assetDataDepresiasi.getPengurang(), "#,###")%> 
										</div>
                                        <%}else{%>                                        
                                      <div align="center"> 
                                        <input type="text" name="<%=im.getOID()%>_pengurang" size="15" value="<%=JSPFormater.formatNumber(assetDataDepresiasi.getPengurang(), "#,###")%>" style="text-align:right">
                                      </div>									  
                                        <%}%> 
                                    </td>
                                    <td width="5%" class="tablecell1"> 
                                      <div align="center"> 
                                        <%if(isPosted){%>
                                        <b>Posted</b> 
                                        <%}else{%>
                                        - 
                                        <%}%>
                                      </div>
                                    </td>
                                  </tr>
                                  <%
								  }	
								 }%>
                                  <%								  
								  }// if > 0
								  }// for
								  }// if ada%>
                                  <tr> 
                                    <td width="7%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="4%">&nbsp;</td>
                                    <td width="4%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="6%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="7%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                    <td width="5%">&nbsp;</td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
							
                            <tr> 
                              <td>&nbsp;</td>
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
