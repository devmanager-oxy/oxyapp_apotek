

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>

<!--package test -->
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.general.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>

<%
	/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!

	/*public String drawList(Vector objectClass ,  long companyId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		::..error, can't generate list header, header is null..::

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;::...error, can't generate record display, header es empty...::

		return ctrlist.drawList(index);
	}
	*/

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidCompany = JSPRequestValue.requestLong(request, "hidden_company_id");

Company companySess = new Company();
if(session.getValue("SESS_COMPANY")!=null){
	companySess = (Company)session.getValue("SESS_COMPANY");
}

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdCompany_1 ctrlCompany = new CmdCompany_1(request);
JSPLine ctrLine = new JSPLine();
Vector listCompany = new Vector(1,1);

/*switch statement */
iErrCode = ctrlCompany.action(iJSPCommand , oidCompany);
/* end switch*/
JspCompany_1 jspCompany = ctrlCompany.getForm();

/*count list All Company*/
int vectSize = DbCompany.getCount(whereClause);

Company company = ctrlCompany.getCompany();
msgString =  ctrlCompany.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlCompany.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listCompany = DbCompany.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCompany.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCompany = DbCompany.list(start,recordToGet, whereClause , orderClause);
}

if(iJSPCommand==JSPCommand.BACK){
	companySess = company;
}

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0){
	//company.setName(getString(JSP_NAME));
	//company.setSerialNumber(getString(JSP_SERIAL_NUMBER));
	//company.setAddress(getString(JSP_ADDRESS));
	companySess.setFiscalYear(company.getFiscalYear());
	companySess.setEndFiscalMonth(company.getEndFiscalMonth());
	companySess.setEntryStartMonth(company.getEntryStartMonth());
	companySess.setNumberOfPeriod(company.getNumberOfPeriod());
	//companySess.setCashReceiveCode(company.getCashReceiveCode());
	//companySess.setPettycashPaymentCode(company.getPettycashPaymentCode());
	//companySess.setPettycashReplaceCode(company.getPettycashReplaceCode());
	//companySess.setBankDepositCode(company.getBankDepositCode());
	//companySess.setBankPaymentPoCode(company.getBankPaymentPoCode());
	//companySess.setBankPaymentNonpoCode(company.getBankPaymentNonpoCode());
	//companySess.setPurchaseOrderCode(company.getPurchaseOrderCode());
	//company.setGeneralLedgerCode(company.sgetGeneralLedgerCode());
	companySess.setMaxPettycashReplenis(company.getMaxPettycashReplenis());
	companySess.setMaxPettycashTransaction(company.getMaxPettycashTransaction());
	companySess.setBookingCurrencyCode(company.getBookingCurrencyCode());
	companySess.setBookingCurrencyId(company.getBookingCurrencyId());
	companySess.setSystemLocation(company.getSystemLocation());
	companySess.setActivationCode(company.getActivationCode());
	companySess.setSystemLocationCode(company.getSystemLocationCode());
	companySess.setGovernmentVat(company.getGovernmentVat());
	companySess.setDepartmentLevel(company.getDepartmentLevel());
	//company.setContact(getString(JSP_CONTACT));
	//company.setAddress2(getString(JSP_ADDRESS2));
	session.putValue("SESS_COMPANY", companySess);
}



//out.println("iJSPCommand : "+iJSPCommand);
//out.println("iErrCode : "+iErrCode);
//
%>
<html ><!-- #BeginTemplate "/Templates/indexwomenu.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">

<%

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0){%>
	window.location="company_3.jsp?command=<%=JSPCommand.NEXT%>";
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


function checkNumber(){
	var st = document.frmcompany.<%=jspCompany.colNames[jspCompany.JSP_MAX_PETTYCASH_REPLENIS]%>.value;		
	
	var result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmcompany.<%=jspCompany.colNames[jspCompany.JSP_MAX_PETTYCASH_REPLENIS]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber2(){
	var st1 = document.frmcompany.<%=jspCompany.colNames[jspCompany.JSP_MAX_PETTYCASH_REPLENIS]%>.value;		
	var result1 = removeChar(st1);
	result1 = cleanNumberFloat(result1, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var st = document.frmcompany.<%=jspCompany.colNames[jspCompany.JSP_MAX_PETTYCASH_TRANSACTION]%>.value;		
	
	var result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	if(parseFloat(result)>parseFloat(result1)){
		alert('Transaction amount over the replenishment amount');
		document.frmcompany.<%=jspCompany.colNames[jspCompany.JSP_MAX_PETTYCASH_TRANSACTION]%>.value = formatFloat(result1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
		document.frmcompany.<%=jspCompany.colNames[jspCompany.JSP_MAX_PETTYCASH_TRANSACTION]%>.select();
	}
	else{	
		document.frmcompany.<%=jspCompany.colNames[jspCompany.JSP_MAX_PETTYCASH_TRANSACTION]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
	}
}

function cmdAdd(){
	document.frmcompany.hidden_company_id.value="0";
	document.frmcompany.command.value="<%=JSPCommand.ADD%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdAsk(oidCompany){
	document.frmcompany.hidden_company_id.value=oidCompany;
	document.frmcompany.command.value="<%=JSPCommand.ASK%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdConfirmDelete(oidCompany){
	document.frmcompany.hidden_company_id.value=oidCompany;
	document.frmcompany.command.value="<%=JSPCommand.DELETE%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}
function cmdSave(){
	document.frmcompany.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company_2.jsp";
	document.frmcompany.submit();
	}

function cmdEdit(oidCompany){
	document.frmcompany.hidden_company_id.value=oidCompany;
	document.frmcompany.command.value="<%=JSPCommand.EDIT%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
	}

function cmdCancel(oidCompany){
	document.frmcompany.hidden_company_id.value=oidCompany;
	document.frmcompany.command.value="<%=JSPCommand.EDIT%>";
	document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdBack(){
	document.frmcompany.command.value="<%=JSPCommand.BACK%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
	}

function cmdListFirst(){
	document.frmcompany.command.value="<%=JSPCommand.FIRST%>";
	document.frmcompany.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdListPrev(){
	document.frmcompany.command.value="<%=JSPCommand.PREV%>";
	document.frmcompany.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
	}

function cmdListNext(){
	document.frmcompany.command.value="<%=JSPCommand.NEXT%>";
	document.frmcompany.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
}

function cmdListLast(){
	document.frmcompany.command.value="<%=JSPCommand.LAST%>";
	document.frmcompany.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcompany.action="company.jsp";
	document.frmcompany.submit();
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
<script language="JavaScript">
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr> 
          <td height="96"> 
            <!-- #BeginEditable "header" --> 
        <%@ include file="../main/hmenu.jsp"%>
        <!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td valign="top"> 
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr> 
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Company Profile</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Step 4 of 5</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <tr> 
                      <td><span class="level2"><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></span></td>
                    </tr>
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
              <form name="frmcompany" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="vectSize" value="<%=vectSize%>">
                <input type="hidden" name="start" value="<%=start%>">
                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
				<input type="hidden" name="hidden_company_id" value="<%=oidCompany%>">
				<input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr align="left" valign="top"> 
                    <td height="8"  colspan="3">&nbsp;</td>
                  </tr>
                  <tr align="left" valign="top"> 
                    <td height="8" valign="top" colspan="3"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" colspan="3">&nbsp;</td>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" colspan="3">&nbsp;Please setup 
                                      your default financial data. </td>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" valign="top" width="15%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;Current 
                                      Fiscal Year</td>
                                    <td height="21" colspan="2" width="83%" valign="top"> 
                                      <%
							Date d = new Date();
							int x = d.getYear();
							%>
                                      <select name="<%=jspCompany.colNames[JspCompany_1.JSP_FISCAL_YEAR] %>">
                                        <option value="<%=1900+(x-1)%>" <%if(company.getFiscalYear()==(1900+x-1)){%>selected<%}%>><%=1900+x-1%></option>
                                        <option value="<%=1900+x%>" <%if(company.getFiscalYear()==(1900+x)){%>selected<%}%>><%=1900+x%></option>
                                      </select>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;End Fiscal 
                                      Month</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <select name="<%=jspCompany.colNames[JspCompany_1.JSP_END_FISCAL_MONTH] %>">
                                        <%for(int i=0; i<I_Project.longMonths.length; i++){%>
                                        <option value="<%=i%>" <%if(company.getEndFiscalMonth()==i){%>selected<%}%>><%=I_Project.longMonths[i]%></option>
                                        <%}%>
                                      </select>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;Current 
                                      Open Period</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <select name="<%=jspCompany.colNames[JspCompany_1.JSP_ENTRY_START_MONTH] %>">
                                        <%for(int i=0; i<I_Project.longMonths.length; i++){%>
                                        <option value="<%=i%>" <%if(company.getEntryStartMonth()==i){%>selected<%}%>><%=I_Project.longMonths[i]%></option>
                                        <%}%>
                                      </select>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;Number Of 
                                      Period in a Year</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <select name="<%=jspCompany.colNames[JspCompany_1.JSP_NUMBER_OF_PERIOD] %>">
                                        <option value="1" <%if(company.getNumberOfPeriod()==1){%>selected<%}%>>1</option>
                                        <option value="2" <%if(company.getNumberOfPeriod()==2){%>selected<%}%>>2</option>
                                        <option value="6" <%if(company.getNumberOfPeriod()==6){%>selected<%}%>>6</option>
                                        <option value="12"  <%if(company.getNumberOfPeriod()==12){%>selected<%}%>>12</option>
                                      </select>
                                      Months 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;Booking 
                                      Currency</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <%
						  Vector v = DbCurrency.list(0,0, "", "");
						  %>
                                      <select name="<%=jspCompany.colNames[JspCompany_1.JSP_BOOKING_CURRENCY_ID] %>">
                                        <%if(v!=null && v.size()>0){
							  		for(int i=0; i<v.size(); i++){
										Currency c = (Currency)v.get(i);
							  %>
                                        <option value="<%=c.getOID()%>" <%if(c.getOID()==company.getBookingCurrencyId()){%>selected<%}%>><%=c.getCurrencyCode()%></option>
                                        <%}}%>
                                      </select>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;System Location</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <%
						   v = DbLocation.list(0,0, "", "");
						  %>
                                      <select name="<%=jspCompany.colNames[JspCompany_1.JSP_SYSTEM_LOCATION] %>">
                                        <%if(v!=null && v.size()>0){
							  		for(int i=0; i<v.size(); i++){
										Location c = (Location)v.get(i);
							  %>
                                        <option value="<%=c.getOID()%>" <%if(c.getOID()==company.getSystemLocation()){%>selected<%}%>><%=c.getCode()+" - "+c.getName()%></option>
                                        <%}}%>
                                      </select>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%">&nbsp;
                                  <tr align="left">
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">Default Government 
                                      Tax </td>
                                    <td height="21" colspan="2" width="83%">
                                      <input type="text" name="<%=jspCompany.colNames[JspCompany_1.JSP_GOVERNMENT_VAT] %>" value="<%=JSPFormater.formatNumber(company.getGovernmentVat(), "#,###.#")%>" size="5">
                                      % 
                                  
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">Department Level</td>
                                    <td height="21" colspan="2" width="83%">                                       
                                      <select name="<%=jspCompany.colNames[JspCompany_1.JSP_DEPARTMENT_LEVEL] %>">
									  	<option value="-1">TOTAL CORPORATE</option>
                                        <%for(int i=0; i<DbDepartment.strLevel.length; i++){%>
                                        <option value="<%=i%>" <%if(company.getDepartmentLevel()==i){%>selected<%}%>><%=DbDepartment.strLevel[i]%></option>
                                        <%}%>
                                      </select>
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;Max. Petty 
                                      Cash Replenisment</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspCompany.colNames[JspCompany_1.JSP_MAX_PETTYCASH_REPLENIS] %>"  value="<%= JSPFormater.formatNumber(company.getMaxPettycashReplenis(), "#,###.##") %>" class="formElemen" style="text-align:right" onClick="this.select()" onBlur="javascript:checkNumber()">
                                      <%= jspCompany.getErrorMsg(jspCompany.JSP_MAX_PETTYCASH_REPLENIS) %> 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" width="15%">&nbsp;Max. Petty 
                                      Cash Transaction</td>
                                    <td height="21" colspan="2" width="83%"> 
                                      <input type="text" name="<%=jspCompany.colNames[JspCompany_1.JSP_MAX_PETTYCASH_TRANSACTION] %>"  value="<%= JSPFormater.formatNumber(company.getMaxPettycashTransaction(), "#,###.##") %>" class="formElemen"  style="text-align:right" onClick="this.select()"  onBlur="javascript:checkNumber2()">
                                      <%= jspCompany.getErrorMsg(jspCompany.JSP_MAX_PETTYCASH_TRANSACTION) %> 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" valign="top" width="15%">&nbsp;</td>
                                    <td height="21" colspan="2" width="83%" valign="top">&nbsp; 
                                  <tr align="left"> 
                                    <td height="21" valign="top" width="2%">&nbsp;</td>
                                    <td height="21" colspan="3"> 
                                      <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="6%"><a href="company_loc.jsp?command=<%=JSPCommand.BACK%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" width="51" height="22" border="0"></a></td>
                                          <td width="14%"><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('next','','../images/next2.gif',1)"><img src="../images/next.gif" name="next" width="55" height="22" border="0"></a></td>
                                          <td width="80%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  <tr align="left"> 
                                    <td height="8" valign="middle" width="2%">&nbsp;</td>
                                    <td height="8" valign="middle" width="15%">&nbsp;</td>
                                    <td height="8" colspan="2" width="83%" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" class="command" valign="top">&nbsp; 
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="2%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="83%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" > 
                                    <td colspan="4" valign="top"> 
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
          <td height="25"> 
            <!-- #BeginEditable "footer" --> 
        <%@ include file="../main/footer.jsp"%>
        <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
