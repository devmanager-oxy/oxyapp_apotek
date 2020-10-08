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
boolean cashPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT);
%>

<%!
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
long oidPettycashPayment = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_id");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");
ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();



/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";
JSPLine ctrLine = new JSPLine();

JspTransactionActivityDetail jspTransactionActivityDetail = new JspTransactionActivityDetail();
JspPettycashPayment jspPettycashPayment = new JspPettycashPayment();

PettycashPayment pettycashPayment = new PettycashPayment();//ctrlPettycashPayment.getPettycashPayment();

try{
	pettycashPayment = DbPettycashPayment.fetchExc(oidPettycashPayment);
}
catch(Exception e){
}

//out.println("oidPettycashPayment : "+oidPettycashPayment);

Vector listPettycashPaymentActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+pettycashPayment.getOID(), "");


Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_PETTY_CASH+"' and location_id="+sysCompany.getSystemLocation(), "");
									  
ExchangeRate eRate = DbExchangeRate.getStandardRate();

Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

//out.println("accountBalance : "+accountBalance);

double balance = 0;
double totalDetail = getTotalDetail(listPettycashPaymentActivity);

balance = pettycashPayment.getAmount() - totalDetail; 



Vector modules = DbModule.list(0,0, "activity_period_id="+openAp.getOID(), "code");

Vector donors = DbDonor.list(0,0, "", "");

//count dari input ke database
int cntActivity = DbTransactionActivityDetail.getCount("transaction_id="+oidPettycashPayment); 
if(cntActivity>0){
	listPettycashPaymentActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+pettycashPayment.getOID(), "");
}

//out.println(listPettycashPaymentActivity);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!cashPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<!--
//=======================================update===========================================================
function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptPCPaymentActPDF?oid=<%=appSessUser.getLoginId()%>&pcPayment_id=<%=pettycashPayment.getOID()%>");
}

function cmdClickIt(){
	document.frmpettycashpaymentdetail.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.select();
}

function cmdGetBalance(){
	
	var x = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_COA_ID]%>.value;
	//alert(x);
	<%if(accountBalance!=null && accountBalance.size()>0){
		for(int i=0; i<accountBalance.size(); i++){
			Coa c = (Coa)accountBalance.get(i);
	%>
		if(x=='<%=c.getOID()%>'){
			document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
			document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);//"<%=c.getOpeningBalance()%>";
			document.frmpettycashpaymentdetail.pcash_balance.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
			<%if(c.getOpeningBalance()<1){%>
				//alert('No account balance to do transaction.');
				document.all.command_line.style.display="none";
				document.all.emptymessage.style.display="";
			<%}else{%>
				document.all.command_line.style.display="";
				document.all.emptymessage.style.display="none";
			<%}%>
		}
	<%}}%>
	
	//checkNumber();
}

function cmdFixing(){	
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.POST%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();	
}

function cmdNewJournal(){	
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();	
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
	var st = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value;		
	var ab = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>.value;		
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	if(parseFloat(result) > parseFloat(ab)){
		if(parseFloat(ab)<1){
			result = "0";
			//result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			alert("No account balance available,\nCan not continue the transaction.");
		}
		else{
			result = ab;
			//result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			alert("Transaction amount over the account balance");
		}
	}
	
	document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber2(){
	var main = document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value;		
	main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var currTotal = document.frmpettycashpaymentdetail.total_detail.value;
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
	var idx = document.frmpettycashpaymentdetail.select_idx.value;
	
	var maxtransaction = document.frmpettycashpaymentdetail.max_pcash_transaction.value;
	var pbalanace = document.frmpettycashpaymentdetail.pcash_balance.value;
	var limit = parseFloat(maxtransaction);
	if(limit > parseFloat(pbalanace)){
		limit = parseFloat(pbalanace);
	}		
	
	var st = document.frmpettycashpaymentdetail.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("result : "+result);
	
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(currTotal) + parseFloat(result);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+limit+", \nsystem will reset the data");
			//result = parseFloat(main)-parseFloat(currTotal);			
			result = "0";//parseFloat(limit)-parseFloat(currTotal);
			//amount = 0;//limit;			
		}
		
		var amount = parseFloat(currTotal) + parseFloat(result);
		
		document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	//edit
	else{
		var editAmount =  document.frmpettycashpaymentdetail.edit_amount.value;
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+limit+", \nsystem will reset the data");
			//result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));			
			result = parseFloat(editAmount);			
			amount = limit;
		}
		
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		
		document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	
	document.frmpettycashpaymentdetail.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
}

function cmdSubmitCommand(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SAVE%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdPettycashPayment(oid){
	document.frmpettycashpaymentdetail.hidden_casharchive.value=oid;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetailprint.jsp";
	document.frmpettycashpaymentdetail.submit();
}

//===============================================================================================

function cmdAdd(){
	document.frmpettycashpaymentdetail.select_idx.value="-1";
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value="0";
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdAsk(idx){
	document.frmpettycashpaymentdetail.select_idx.value=idx;
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value=0;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ASK%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdConfirmDelete(oidTransactionActivityDetail){
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.DELETE%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdSave(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdEdit(idxx){
	document.frmpettycashpaymentdetail.select_idx.value=idxx;
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value=0;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdCancel(oidTransactionActivityDetail){
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdBack(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.BACK%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListFirst(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListPrev(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListNext(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListLast(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
	document.frmpettycashpaymentdetail.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidTransactionActivityDetail){
	document.frmimage.hidden_pettycash_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="pettycashpaymentactivity.jsp";
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
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Petty Cash</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Payment Activity</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpettycashpaymentdetail" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          
                          <input type="hidden" name="hidden_pettycash_payment_id" value="<%=oidPettycashPayment%>">
						  <input type="hidden" name="hidden_casharchive" value="<%=oidPettycashPayment%>">
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
                                                  <div align="right">Date : <%=JSPFormater.formatDate(pettycashPayment.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : 
                                                    <%
													User u = new User();
													try{
														u = DbUser.fetch(pettycashPayment.getOperatorId());
													}
													catch(Exception e){
													}
													%>
                                                    <%=u.getLoginId()%>&nbsp;&nbsp;</div>
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
                                                <td width="22%">&nbsp;</td>
                                                <td width="12%" nowrap>&nbsp;</td>
                                                <td width="54%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" nowrap>Payment 
                                                  from Account</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="22%"> 
                                                  <%
										Coa coay = new Coa();
										//if(accLinks!=null && accLinks.size()>0){
											//AccLink accLink = (AccLink)accLinks.get(0);																						
											try{
												coay = DbCoa.fetchExc(pettycashPayment.getCoaId());
											}
											catch(Exception e){
											}
										//}%>
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_COA_ID]%>" value="<%=coay.getOID()%>">
                                                  <%=coay.getCode()+ " - "+coay.getName()%></td>
                                                <td width="12%" nowrap>Amount 
                                                  <%=baseCurrency.getCurrencyCode()%></td>
                                                <td width="54%"> <%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Journal Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="22%"><%=pettycashPayment.getJournalNumber()%> </td>
                                                <td width="12%">Transaction Date</td>
                                                <td width="54%"><%=JSPFormater.formatDate((pettycashPayment.getTransDate()==null) ? new Date() : pettycashPayment.getTransDate(), "dd/MM/yyyy")%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="16">Memo</td>
                                                <td width="2%" height="16">&nbsp;</td>
                                                <td colspan="3" valign="top"> 
                                                  <%=pettycashPayment.getMemo()%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="22%" valign="top">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="54%">&nbsp;</td>
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
                                                            <td class="tabin"><a href="javascript:cmdPettycashPayment('<%=oidPettycashPayment%>')" class="tablink">Disbursement</a></td>
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
                                                                  <td  class="tablehdr" width="5%" height="20">&nbsp;Direct&nbsp;</td>
                                                                  <td  class="tablehdr" width="10%" height="20">Type</td>
                                                                  <td class="tablehdr" width="28%" height="20">Account</td>
                                                                  <td class="tablehdr" width="40%" height="20">Activity</td>
                                                                  <td class="tablehdr" width="17%" height="20">Amount 
                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                </tr>
                                                                <%if(listPettycashPaymentActivity!=null && listPettycashPaymentActivity.size()>0){
													for(int i=0; i<listPettycashPaymentActivity.size(); i++){
																												
														TransactionActivityDetail crd = new TransactionActivityDetail();
														try{
															crd = (TransactionActivityDetail)listPettycashPaymentActivity.get(i);
														}
														catch(Exception e){
														}
														
														Coa c = new Coa();
														try{
															c = DbCoa.fetchExc(crd.getCoaId());
														}
														catch(Exception e){
														}
														
														String cssString = "tablecell";
														if(i%2!=0){
															cssString = "tablecell1";
														}
														
												%>
                                                                <tr> 
                                                                  <td class="<%=cssString%>" width="5%" height="17"> 
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
                                                                  <td width="28%" class="<%=cssString%>" nowrap height="17"> 
                                                                    <%
																  Coa xcoa = new Coa();
																  try{
																  		xcoa = DbCoa.fetchExc(crd.getCoaId());		
																  }
																  catch(Exception e){
																  }
																  %>
																  <%=xcoa.getCode()+" - "+xcoa.getName()%>
																  </td>
                                                                  <td width="40%" class="<%=cssString%>" nowrap height="17"> 
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
                                                                  <td width="17%" class="<%=cssString%>" height="17"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                  </td>
                                                                </tr>
                                                                <%}}%>
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
                                                      <td width="76%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a> 
                                                      </td>
                                                      <td class="boxed1" width="24%"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="49%"> 
                                                              <div align="right"><b>Total 
                                                                <%=baseCurrency.getCurrencyCode()%> :</b></div>
                                                            </td>
                                                            <td width="51%"> 
                                                              <div align="right"><b> 
                                                                <%
																//out.println("<br>totalDetail : "+totalDetail);
																//out.println("<br>pettycashPayment.getAmount() : "+pettycashPayment.getAmount());
																
																balance = pettycashPayment.getAmount() - totalDetail;
																%>
                                                                <input type="hidden" name="total_detail" value="<%=totalDetail%>">
                                                                <%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b></div>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
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
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="4%">&nbsp;</td>
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="49%">&nbsp;</td>
                                                      <td width="36%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
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
