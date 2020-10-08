<% 
/*******************************************************************
 *  eka
 *******************************************************************/
%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.activity.*" %>

<%@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
/* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
boolean privAdd=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
boolean privUpdate=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
boolean privDelete=true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean closingPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC);
boolean closingPrivView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC, AppMenu.PRIV_VIEW);
boolean closingPrivUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_DATASYNC, AppMenu.M2_MENU_DATASYNC, AppMenu.PRIV_UPDATE);
%>
<!-- Jsp Block -->
<%!

	
	
	
	public Vector addNewDetail(Vector listInvoiceActivity, TransactionActivityDetail activityDetail){
		boolean found = false;
		//diblok sementara
		if(listInvoiceActivity!=null && listInvoiceActivity.size()>0){
			for(int i=0; i<listInvoiceActivity.size(); i++){
				TransactionActivityDetail cr = (TransactionActivityDetail)listInvoiceActivity.get(i);
				if(cr.getType()==activityDetail.getType() && cr.getModuleId()==activityDetail.getModuleId() && cr.getDonorId()==activityDetail.getDonorId()){
					//jika coa sama dan currency sama lakukan penggabungan					
					cr.setAmount(cr.getAmount()+activityDetail.getAmount());
					found = true;
				}
			}
		}
		
		if(!found){
			listInvoiceActivity.add(activityDetail);
		}
		
		return listInvoiceActivity;
	}
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				TransactionActivityDetail crd = (TransactionActivityDetail)listx.get(i);
				result = result + crd.getAmount();
			}
		}
		return result;
	}

%>
<%

//main data

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidInvoice = JSPRequestValue.requestLong(request, "hidden_invoice_id");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");
ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();

//out.println("oidInvoice : "+oidInvoice);

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	if(session.getValue("BBPOACTIVITY_DETAIL")!=null){
		session.removeValue("BBPOACTIVITY_DETAIL");
	}
	//iJSPCommand = JSPCommand.ADD;
	recIdx = -1;
}
//===============================================================

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";
JSPLine ctrLine = new JSPLine();

CmdInvoice ctrlInvoice = new CmdInvoice(request);

Vector listInvoice = new Vector(1,1);

/*switch statement */
int iErrCodeMain = 0;//ctrlInvoice.action(iJSPCommand , oidInvoice);
/* end switch*/
JspInvoice jspInvoice = ctrlInvoice.getForm();

/*count list All Invoice*/
int vectSize = DbInvoice.getCount(whereClause);

Invoice invoice = new Invoice();//ctrlInvoice.getInvoice();

try{
	invoice = DbInvoice.fetchExc(oidInvoice);
}
catch(Exception e){
}

Purchase purchase = new Purchase();
long purchaseId = invoice.getPurchaseId();
	
if(purchaseId!=0){
	try{
		purchase = DbPurchase.fetchExc(purchaseId);
	}
	catch(Exception e){
	}
}

//out.println("invoice : "+invoice.getGrandTotal());

String msgStringMain =  "";//ctrlInvoice.getMessage();

System.out.println("\n -- start detail session ---\n");

%>
<%

//detail 

//bagian  DETAIL
//===================================update============================
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
}
//=====================================================================

//int iJSPCommand = JSPRequestValue.requestJSPCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidTransactionActivityDetail = JSPRequestValue.requestLong(request, "hidden_invoice_activity_id");

/*variable declaration*/
//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdTransactionActivityDetail ctrlTransactionActivityDetail = new CmdTransactionActivityDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listInvoiceActivity = new Vector(1,1);

/*switch statement */
iErrCode = ctrlTransactionActivityDetail.action(iJSPCommand , oidTransactionActivityDetail);
/* end switch*/
JspTransactionActivityDetail jspTransactionActivityDetail = ctrlTransactionActivityDetail.getForm();

//out.println(jspTransactionActivityDetail.getErrors());

TransactionActivityDetail pettycashActivityDetail = ctrlTransactionActivityDetail.getTransactionActivityDetail();
msgString =  ctrlTransactionActivityDetail.getMessage();

if(session.getValue("BBPOACTIVITY_DETAIL")!=null){
	listInvoiceActivity = (Vector)session.getValue("BBPOACTIVITY_DETAIL");
}

if(iJSPCommand==JSPCommand.SUBMIT){
	if(iErrCode==0){
		if(recIdx==-1){		
			listInvoiceActivity = addNewDetail(listInvoiceActivity, pettycashActivityDetail);
			//listInvoiceActivity.add(pettycashActivityDetail);
		}
		else{
			//listInvoiceActivity.set(recIdx, pettycashActivityDetail);
			listInvoiceActivity.remove(recIdx);
			listInvoiceActivity = addNewDetail(listInvoiceActivity, pettycashActivityDetail);
		}
	}
}
if(iJSPCommand==JSPCommand.DELETE){
	listInvoiceActivity.remove(recIdx);
}

//out.println("<br>sebelum save : "+listInvoiceActivity);

if(iJSPCommand==JSPCommand.SAVE){
	if(invoice.getOID()!=0){
		long oidFlag = DbTransactionActivityDetail.saveAllDetail(oidInvoice, listInvoiceActivity);
		DbInvoice.postActivityStatus(oidFlag, oidInvoice);
		//listInvoiceActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+invoice.getOID(), "");
	}
}

//out.println("jspTransactionActivityDetail : "+jspTransactionActivityDetail.getErrors());
//out.println("<br>"+listInvoiceActivity);

session.putValue("BBPOACTIVITY_DETAIL", listInvoiceActivity);

String wherex = "(account_group='"+I_Project.ACC_GROUP_EXPENSE+"' or account_group='"+I_Project.ACC_GROUP_OTHER_EXPENSE+"') "+
				" and (location_id="+sysLocation.getOID()+" or location_id=0)";

//Vector incomeCoas = DbCoa.list(0,0, wherex, "code");

//Vector currencies = DbCurrency.list(0,0,"", "");

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_PETTY_CASH+"' and location_id="+sysCompany.getSystemLocation(), "");
									  
ExchangeRate eRate = DbExchangeRate.getStandardRate();

Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

//out.println("accountBalance : "+accountBalance);

double balance = 0;
double totalDetail = getTotalDetail(listInvoiceActivity);

balance = invoice.getGrandTotal() - totalDetail; 

//invoice.setAmount(totalDetail);

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && iErrCodeMain==0 && recIdx==-1){
	iJSPCommand = JSPCommand.ADD;
	pettycashActivityDetail = new TransactionActivityDetail();
}

Vector modules = DbModule.list(0,0, "activity_period_id="+openAp.getOID(), "code");

Vector donors = DbDonor.list(0,0, "", "");

//count dari input ke database
int cntActivity = DbTransactionActivityDetail.getCount("transaction_id="+oidInvoice); 
if(cntActivity>0){
	listInvoiceActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+invoice.getOID(), "");
}

//out.println("<br>cntActivity :"+cntActivity);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!closingPriv || !closingPrivView || !closingPrivUpdate){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<!--
//=======================================update===========================================================
function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptAccPaymentActPDF?oid=<%=appSessUser.getLoginId()%>&inv_id=<%=oidInvoice%>");
}

function cmdClickIt(){
	document.frminvoiceactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.select();
}

function cmdGetBalance(){
	
	
	//checkNumber();
}

function cmdFixing(){	
	document.frminvoiceactivity.command.value="<%=JSPCommand.POST%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();	
}

function cmdNewJournal(){	
	document.frminvoiceactivity.command.value="<%=JSPCommand.NONE%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();	
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

function checkNumber(){
	}

function checkNumber2(){
	var idx = document.frminvoiceactivity.select_idx.value;
	
	alert("idx : "+idx);
	
	var max = document.frminvoiceactivity.grand_total.value;
	//alert(max);
	
	var totalDetail = document.frminvoiceactivity.total_detail.value;
	totalDetail = cleanNumberFloat(totalDetail, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var detail = document.frminvoiceactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value;
	detail = removeChar(detail);	
	document.frminvoiceactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(detail, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);		
	
	detail = cleanNumberFloat(detail, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	if(parseInt(idx)<0){
		if(parseFloat(max)<(parseFloat(totalDetail)+parseFloat(detail))){
			//alert('maximum expense is '+max);
			detail = parseFloat(max)-parseFloat(totalDetail);	
			document.frminvoiceactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(detail, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		}
	}
	else{
		var editAmount = document.frminvoiceactivity.edit_amount.value;
		//editAmount = removeChar(editAmount);
		if(parseFloat(max)<(parseFloat(totalDetail)-parseFloat(editAmount)+parseFloat(detail))){
			alert("max : "+max+", total detail : "+totalDetail+", edit amoun : "+editAmount+", detail : "+detail);
			detail = parseFloat(max)-((parseFloat(totalDetail)-parseFloat(editAmount)));	
			document.frminvoiceactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(detail, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		}
	}
}

function cmdSubmitCommand(){
	document.frminvoiceactivity.command.value="<%=JSPCommand.SAVE%>";
	document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdInvoice(oid){
		//document.frminvoiceactivity.hidden_invoicearchive.value=oid;
		document.frminvoiceactivity.hidden_invoice_id.value=oid;
		document.frminvoiceactivity.command.value="<%=JSPCommand.EDIT%>";
		document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
		document.frminvoiceactivity.action="invoiceclosing.jsp";
		document.frminvoiceactivity.submit();
}

function cmdInvoiceX(oid){
	<%if(cntActivity>0){%>
		document.frminvoiceactivity.hidden_invoicearchive.value=oid;
		document.frminvoiceactivity.hidden_invoice_id.value=oid;
		document.frminvoiceactivity.command.value="<%=JSPCommand.EDIT%>";
		document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
		document.frminvoiceactivity.action="invoiceclosing.jsp";
		document.frminvoiceactivity.submit();
	<%}else{%>
		alert('Please finish and post activity transaction before go to payment archive');
	<%}%>
	
}

//===============================================================================================

function cmdAdd(){
	document.frminvoiceactivity.select_idx.value="-1";
	document.frminvoiceactivity.hidden_invoice_id.value="0";
	document.frminvoiceactivity.hidden_invoice_activity_id.value="0";
	document.frminvoiceactivity.command.value="<%=JSPCommand.ADD%>";
	document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdAsk(idx){
	document.frminvoiceactivity.select_idx.value=idx;
	document.frminvoiceactivity.hidden_invoice_activity_id.value=0;
	document.frminvoiceactivity.command.value="<%=JSPCommand.ASK%>";
	document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdConfirmDelete(oidTransactionActivityDetail){
	document.frminvoiceactivity.hidden_invoice_activity_id.value=oidTransactionActivityDetail;
	document.frminvoiceactivity.command.value="<%=JSPCommand.DELETE%>";
	document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdSave(){
	document.frminvoiceactivity.command.value="<%=JSPCommand.SUBMIT%>";
	document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdEdit(idxx){
	document.frminvoiceactivity.select_idx.value=idxx;
	document.frminvoiceactivity.hidden_invoice_activity_id.value=0;
	document.frminvoiceactivity.command.value="<%=JSPCommand.EDIT%>";
	document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdCancel(oidTransactionActivityDetail){
	document.frminvoiceactivity.hidden_invoice_activity_id.value=oidTransactionActivityDetail;
	document.frminvoiceactivity.command.value="<%=JSPCommand.EDIT%>";
	document.frminvoiceactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdBack(){
	document.frminvoiceactivity.command.value="<%=JSPCommand.BACK%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdListFirst(){
	document.frminvoiceactivity.command.value="<%=JSPCommand.FIRST%>";
	document.frminvoiceactivity.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdListPrev(){
	document.frminvoiceactivity.command.value="<%=JSPCommand.PREV%>";
	document.frminvoiceactivity.prev_command.value="<%=JSPCommand.PREV%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdListNext(){
	document.frminvoiceactivity.command.value="<%=JSPCommand.NEXT%>";
	document.frminvoiceactivity.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

function cmdListLast(){
	document.frminvoiceactivity.command.value="<%=JSPCommand.LAST%>";
	document.frminvoiceactivity.prev_command.value="<%=JSPCommand.LAST%>";
	document.frminvoiceactivity.action="invoiceactivityclosing.jsp";
	document.frminvoiceactivity.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidTransactionActivityDetail){
	document.frmimage.hidden_invoice_activity_id.value=oidTransactionActivityDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="invoiceactivityclosing.jsp";
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
//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif')">
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
                <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                  <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" --><span class="level1">Data Synchronization
                        </span> &raquo; <span class="level2">Invoice Activity<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frminvoiceactivity" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_invoice_activity_id" value="<%=oidTransactionActivityDetail%>">
                          <input type="hidden" name="hidden_invoice_id" value="<%=oidInvoice%>">
						  <input type="hidden" name="hidden_invoicearchive" value="<%=oidInvoice%>">
						  
                          <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="max_pcash_transaction" value="<%=sysCompany.getMaxPettycashTransaction()%>">
                          <input type="hidden" name="pcash_balance" value="">
                          <%try{%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="4" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="31%">&nbsp;</td>
                                                <td width="32%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspInvoice.getErrorMsg(jspInvoice.JSP_OPERATOR_ID) %>&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                              <tr> 
                                                <td width="10%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%">&nbsp;</td>
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>Vendor</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%" valign="top"> 
                                                  <%
									Vendor v = new Vendor();
									try{
										v = DbVendor.fetchExc(invoice.getVendorId());
									}
									catch(Exception e){
									}
									%>
                                                  <%=v.getCode()+" - "+v.getName()%> 
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_VENDOR_ID]%>" value="<%=invoice.getVendorId()%>">
                                                  <%=jspInvoice.getErrorMsg(JspInvoice.JSP_VENDOR_ID)%> </td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%" valign="top"> 
                                                  <%=v.getAddress() + ((v.getCity().length()>0) ? ", "+v.getCity() : "") + ((v.getState().length()>0) ? "<br>"+v.getState() : "") + ((v.getCountryName().length()>0) ? ", "+v.getCountryName() : "") %></td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%" valign="top">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>Purchase 
                                                  Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="34%"> <b> <%=purchase.getJournalNumber()%> 
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_PURCHASE_ID]%>" value="<%=invoice.getPurchaseId()%>" class="formElemen">
                                                  <%=jspInvoice.getErrorMsg(JspInvoice.JSP_PURCHASE_ID)%> </b></td>
                                                <td  width="10%" align="left">Journal 
                                                  Number</td>
                                                <td  width="10%" align="left"> 
                                                  <%=invoice.getJournalNumber()%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Purchase Currency 
                                                </td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="34%"> 
                                                  <% 
									  Currency c = new Currency();
									  try{
									  	c = DbCurrency.fetchExc(invoice.getCurrencyId());
									  }
									  catch(Exception e){
									  }
									  %>
                                                  <%=c.getCurrencyCode()%> 
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_CURRENCY_ID]%>" value="<%=invoice.getCurrencyId()%>">
                                                  <%=jspInvoice.getErrorMsg(JspInvoice.JSP_CURRENCY_ID)%></td>
                                                <td  width="10%" align="left">Trans 
                                                  Date</td>
                                                <td  width="10%" align="left"> 
                                                  <%=JSPFormater.formatDate(invoice.getTransDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Apply VAT</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="34%"> 
                                                  <%if(invoice.getApplyVat()==1){%>
                                                  YES 
                                                  <%}else{%>
                                                  NO 
                                                  <%}%>
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_APPLY_VAT]%>" value="<%=invoice.getApplyVat()%>">
                                                </td>
                                                <td  width="10%" align="left">Due 
                                                  Date</td>
                                                <td  width="10%" align="left"> 
                                                  <%=JSPFormater.formatDate(invoice.getDueDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" height="16">Vendor 
                                                  Invoice Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td height="8" width="34%"> <%=invoice.getVendorInvoiceNumber()%></td>
                                                <td  width="10%" align="left">Amount</td>
                                                <td  width="10%" align="left"><%=JSPFormater.formatNumber(invoice.getGrandTotal(), "#,###.##")%> 
                                                  <input type="hidden" name="grand_total" value="<%=invoice.getGrandTotal()%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Memo</td>
                                                <td width="2%">&nbsp;</td>
                                                <td colspan="3" valign="top"> 
                                                  <%=invoice.getMemo()%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%" valign="top">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                          <tr > 
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                            <td class="tabin"><a href="javascript:cmdInvoice('<%=oidInvoice%>')" class="tablink">Disbursement</a></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tab">Activity</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="13" height="10"> 
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="100%" class="page"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <tr> 
                                                                  <td  class="tablehdr" width="3%" height="20">&nbsp;Direct&nbsp;</td>
                                                                  <td  class="tablehdr" width="10%" height="20">Type</td>
                                                                  <td class="tablehdr" width="20%" height="20">Account</td>
                                                                  <td class="tablehdr" width="33%" height="20">Activity</td>
                                                                  <td class="tablehdr" width="13%" height="20">Amount 
                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                </tr>
                                                                <%if(listInvoiceActivity!=null && listInvoiceActivity.size()>0){
													for(int i=0; i<listInvoiceActivity.size(); i++){
																												
														TransactionActivityDetail crd = new TransactionActivityDetail();
														try{
															crd = (TransactionActivityDetail)listInvoiceActivity.get(i);
														}
														catch(Exception e){
														}
														
														
														
														String cssString = "tablecell";
														if(i%2!=0){
															cssString = "tablecell1";
														}
														
												%>
                                                                <%
									
												if(((iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK) || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && i==recIdx){%>
                                                                <%}else{%>
                                                                <tr> 
                                                                  <td class="<%=cssString%>" width="3%" height="17"> 
                                                                    <div align="center">
                                                                      <%if(crd.getIsDirect()==1){%>
                                                                      <img src="../images/yesx.gif" width="17" height="14"> 
                                                                      <%}%>
                                                                    </div>
                                                                  </td>
                                                                  <td class="<%=cssString%>" width="10%" height="17"> 
                                                                    <%if(cntActivity==0){%>
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=DbTransactionActivityDetail.activities[crd.getType()]%></a> 
                                                                    <%}else{%>
                                                                    <%=DbTransactionActivityDetail.activities[crd.getType()]%> 
                                                                    <%}%>
                                                                  </td>
                                                                  <td width="20%" class="<%=cssString%>" nowrap height="17"> 
                                                                    <%
																  Coa cecxx = new Coa();
																  try{
																  	cecxx = DbCoa.fetchExc(crd.getCoaId());
																  }
																  catch(Exception e){
																  
																  }
																  %>
                                                                    <%=cecxx.getCode()+" - "+cecxx.getName()%> 
                                                                  </td>
                                                                  <td width="33%" class="<%=cssString%>" nowrap height="17"> 
                                                                    <%if(crd.getModuleId()!=0){
																  		Module mdl = new Module();
																  		try{
																			mdl = DbModule.fetchExc(crd.getModuleId());
																		}
																		catch(Exception e){
																		}
																		
																		if(mdl.getDescription().length()>40){
																  	%>
                                                                    <a href="#" title="<%=mdl.getDescription()%>"><%=mdl.getCode()+" - "+((mdl.getDescription().length()>40) ? (mdl.getDescription().substring(0, 40)+"...") : mdl.getDescription())%></a> 
                                                                    <%}else{%>
                                                                    <%=mdl.getCode()+" - "+mdl.getDescription()%> 
                                                                    <%}}else{%>
                                                                    - 
                                                                    <%}%>
                                                                  </td>
                                                                  <td width="13%" class="<%=cssString%>" height="17"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                                <%}}%>
                                                                <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && recIdx==-1 ){%>
                                                                <%}%>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr id="command_line"> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td colspan="2" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="76%">&nbsp;</td>
                                                      <td width="24%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="76%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/print2.gif',1)"><img src="../images/print.gif" name="print1" width="53" height="22" border="0"></a> 
                                                      </td>
                                                      <td class="boxed1" width="24%"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="49%"> 
                                                              <div align="left"><b>Total 
                                                                <%=baseCurrency.getCurrencyCode()%> :</b></div>
                                                            </td>
                                                            <td width="51%"> 
                                                              <div align="right"><b> 
                                                                <%
																//out.println("<br>totalDetail : "+totalDetail);
																//out.println("<br>invoice.getGrandTotal() : "+invoice.getGrandTotal());
																
																//balance = invoice.getGrandTotal() - totalDetail;
																%>
                                                                <input type="hidden" name="total_detail" value="<%=totalDetail%>">
                                                                <%=JSPFormater.formatNumber(getTotalDetail(listInvoiceActivity), "#,###.##")%></b></div>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%if(invoice.getGrandTotal()!=0 && iErrCode==0 && iErrCodeMain==0 && balance==0 && cntActivity==0){%>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td height="2">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5">&nbsp; </td>
                                              </tr>
                                              <%}%>
                                              <%if(cntActivity!=0){%>
                                              <tr> 
                                                <td colspan="5">&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5">&nbsp; </td>
                                              </tr>
                                              <%}%>
                                              <tr id="emptymessage"> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="18%">&nbsp;</td>
                                          <td width="28%">&nbsp;</td>
                                          <td width="30%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="4" class="command">&nbsp; </td>
                            </tr>
                          </table>
                          <%}
				catch(Exception e){
					out.println(e.toString());
				}%>
                          <script language="JavaScript">
				//cmdGetBalance();
				//document.frminvoiceactivity.grand_total.value= formatFloat('<%=totalDetail%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
				<%if(iErrCode!=0 || iErrCodeMain!=0 || iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT){%>
				//checkNumber2();
				<%}%>
				</script>
                        </form>
                        <!-- #EndEditable -->
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
