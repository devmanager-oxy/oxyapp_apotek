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

	
	
	
	public Vector addNewDetail(Vector listBanknonpoPaymentDetail, BanknonpoPaymentDetail banknonpoPaymentDetail){
		boolean found = false;
		if(listBanknonpoPaymentDetail!=null && listBanknonpoPaymentDetail.size()>0){
			for(int i=0; i<listBanknonpoPaymentDetail.size(); i++){
				BanknonpoPaymentDetail cr = (BanknonpoPaymentDetail)listBanknonpoPaymentDetail.get(i);
				if(cr.getCoaId()==banknonpoPaymentDetail.getCoaId()){
					//jika coa sama dan currency sama lakukan penggabungan					
					cr.setAmount(cr.getAmount()+banknonpoPaymentDetail.getAmount());
					found = true;
				}
			}
		}
		
		if(!found){
			listBanknonpoPaymentDetail.add(banknonpoPaymentDetail);
		}
		
		return listBanknonpoPaymentDetail;
	}
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail)listx.get(i);
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
long oidBanknonpoPayment = JSPRequestValue.requestLong(request, "hidden_bankarchive");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");

long oidBanknonpoPaymentDetail = 0;
int vectSize = 0;

JspBanknonpoPayment jspBanknonpoPayment = new JspBanknonpoPayment();
JspBanknonpoPaymentDetail jspBanknonpoPaymentDetail = new JspBanknonpoPaymentDetail();

BanknonpoPayment banknonpoPayment = new BanknonpoPayment();
if(oidBanknonpoPayment!=0){
	try{
		banknonpoPayment = DbBanknonpoPayment.fetchExc(oidBanknonpoPayment);
	}
	catch(Exception e){
	}
}

//detail 
Vector listBanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(0,0, "banknonpo_payment_id="+banknonpoPayment.getOID(), "");



%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title>Finance System - PNK</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

//=======================================update===========================================================

<%if(!closingPriv || !closingPrivView || !closingPrivUpdate){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBanknonpoPaymentPDF?oid=<%=appSessUser.getLoginId()%>&nonpo_id=<%=oidBanknonpoPayment%>");//,"budget","scrollbars=no,height=400,width=400,addressbar=no,menubar=no,toolbar=no,location=no,");  				
}

function cmdNewVendor(){
	window.open("vendor.jsp?command=<%=JSPCommand.ADD%>","addvendor","scrollbars=yes,height=500,width=800, menubar=no,toolbar=no,location=no");
}

function cmdEditVendor(){
	var oid = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_VENDOR_ID]%>.value;
	window.open("vendor.jsp?command=<%=JSPCommand.EDIT%>&hidden_vendor_id="+oid,"editvendor","scrollbars=yes,height=500,width=800, menubar=no,toolbar=no,location=no");
}

function cmdVendor(){
	var oid = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_VENDOR_ID]%>.value;
	var found = false;
		
	if(!found){
		document.frmbanknonpopaymentdetail.vnd_address.value="";
	}
}

function cmdClickIt(){
	document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.select();
}

function cmdGetBalance(){
	
	
	
	//checkNumber();
}

function cmdFixing(){	
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.POST%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();	
}

function cmdNewJournal(){	
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.NONE%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();	
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
	var st = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value;		
	var ab = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>.value;		
	
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
			result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			alert("Transaction amount over the account balance,\nSystem will reset the amount into maximum allowed.");
		}
	}
	
	document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber2(){
	var main = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value;		
	main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var currTotal = document.frmbanknonpopaymentdetail.total_detail.value;
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
	var idx = document.frmbanknonpopaymentdetail.select_idx.value;
	
	var maxtransaction = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>.value;
	var pbalanace = maxtransaction;//document.frmbanknonpopaymentdetail.pcash_balance.value;
	var limit = parseFloat(maxtransaction);
	if(limit > parseFloat(pbalanace)){
		limit = parseFloat(pbalanace);
	}		
	
	var st = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("result : "+result);
	
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(currTotal) + parseFloat(result);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+limit+", \nsystem will reset the data");
			//result = parseFloat(main)-parseFloat(currTotal);			
			result = parseFloat(limit)-parseFloat(currTotal);
			amount = limit;			
		}
		
		document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	//edit
	else{
		var editAmount =  document.frmbanknonpopaymentdetail.edit_amount.value;
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+limit+", \nsystem will reset the data");
			//result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));			
			result = parseFloat(limit)-(parseFloat(currTotal)-parseFloat(editAmount));			
			amount = limit;
		}
		
		document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	
	document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
}

function cmdUpdateExchange(){
	var idCurr = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
	
	
	
	var famount = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value;
	
	famount = removeChar(famount);
	famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert(famount);
	
	var fbooked = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value;
	fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert(fbooked);
	
	if(!isNaN(famount)){
		document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
		document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		//alert('!isNaN');		
	}
	
	checkNumber2();
}

function cmdSubmitCommand(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.SAVE%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdActivity(oid){
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_id.value=oid;
	<%
		if(banknonpoPayment.getActivityStatus().equals("Posted"))
		{
	%>	
		document.frmbanknonpopaymentdetail.action="banknonpoactivityprint.jsp?menu_idx=7";
	<%
		}else{
	%>
		document.frmbanknonpopaymentdetail.action="banknonpoactivityclosing.jsp?menu_idx=7";
	<%
		}
	%>
	document.frmbanknonpopaymentdetail.submit();
}

//===============================================================================================

function cmdAdd(){
	document.frmbanknonpopaymentdetail.select_idx.value="-1";
	document.frmbanknonpopaymentdetail.hidden_pettycash_payment_id.value="0";
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value="0";
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdAsk(idx){
	document.frmbanknonpopaymentdetail.select_idx.value=idx;
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=0;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.ASK%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdConfirmDelete(oidBanknonpoPaymentDetail){
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.DELETE%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdSave(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdEdit(idxx){
	document.frmbanknonpopaymentdetail.select_idx.value=idxx;
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=0;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdCancel(oidBanknonpoPaymentDetail){
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdBack(){
	document.frmbanknonpopaymentdetail.action = "../incomplete/closinglist.jsp?menu_idx=7";
	document.frmbanknonpopaymentdetail.submit();

}

function cmdListFirst(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.FIRST%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdListPrev(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.PREV%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdListNext(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.NEXT%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdListLast(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.LAST%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentclosing.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidBanknonpoPaymentDetail){
	document.frmimage.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="banknonpopaymentclosing.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/back2.gif')">
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
                        </span> &raquo; <span class="level2">Bank Non PO Payment<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbanknonpopaymentdetail" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_banknonpo_payment_detail_id" value="<%=oidBanknonpoPaymentDetail%>">
                          <input type="hidden" name="hidden_pettycash_payment_id" value="<%=oidBanknonpoPayment%>">
						  <input type="hidden" name="hidden_banknonpo_payment_id" value="<%=oidBanknonpoPayment%>">						  
                          <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="max_pcash_transaction" value="<%=sysCompany.getMaxPettycashTransaction()%>">
                          <input type="hidden" name="pcash_balance" value="">
						  <input type="hidden" name="hidden_bankarchive" value="<%=oidBanknonpoPayment%>">
						  
						  
                          <%try{%>
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
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
                                                  <div align="right">Date : <%=JSPFormater.formatDate(banknonpoPayment.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : 
                                                    <%
													User u = new User();
													try{
														u = DbUser.fetch(banknonpoPayment.getOperatorId());
													}
													catch(Exception e){
													}
													%>
                                                    <%=u.getLoginId()%>&nbsp;&nbsp</div>
                                                </td>
                                              </tr>
											  <tr> 
												<td height="22" valign="middle" colspan="3" class="comment"><font color="#FF0000">
												<%
													String msg = "";
													if(banknonpoPayment.getActivityStatus().equals("Posted"))
													{
														msg = "Process Complete";
													}else{
														msg = "Incomplete activity";
													}
												%><%=msg%>
												</font></td>
										      </tr>											  
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="14%" nowrap>&nbsp;</td>
                                                <td width="32%">&nbsp;</td>
                                                <td width="12%" nowrap>&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                              </tr>
											  <%
												  if(banknonpoPayment.getType()==0)
												  {
											  %>
                                              <tr> 
                                                <td width="14%" nowrap>Vendor</td>
                                                <td width="32%"> 
                                                  <%
													  //out.println(banknonpoPayment.getVendorId());
													  
													  	Vendor vx = new Vendor();
														try{
															vx = DbVendor.fetchExc(banknonpoPayment.getVendorId());
														}
														catch(Exception e){
														}
													  %>
                                                  <%=vx.getCode()%> - <%=vx.getName()%></td>
                                                <td width="12%" nowrap>&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="14%" nowrap>&nbsp;</td>
                                                <td colspan="3"><%=vx.getAddress()%></td>
                                              </tr>
                                              <tr> 
                                                <td width="14%" nowrap>&nbsp;</td>
                                                <td width="32%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                              </tr>
											  <%}%>
                                              <tr> 
                                                <td width="14%" nowrap>Payment 
                                                  from Account</td>
                                                <td width="32%"> 
                                                  <%
												Coa coa = new Coa();
												try{
													coa = DbCoa.fetchExc(banknonpoPayment.getCoaId());
												}
												catch(Exception e){
												}
												%>
                                                  <%=coa.getCode()+ " - "+coa.getName()%> </td>
                                                <td width="12%">Journal Number</td>
                                                <td width="42%"> 
                                                  <%
									  int counter = DbBanknonpoPayment.getNextCounter();
									  String strNumber = DbBanknonpoPayment.getNextNumber(counter);
									  
									  if(banknonpoPayment.getOID()!=0){
											strNumber = banknonpoPayment.getJournalNumber();
									  }
									  
									  %>
                                                  <%=strNumber%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">Payment Method</td>
                                                <td width="32%"> 
                                                  <%
										Vector vpm = DbPaymentMethod.list(0,0, "", "");
										%>
												  <%PaymentMethod pm = DbPaymentMethod.fetchExc(banknonpoPayment.getPaymentMethodId());%> 
												  <%=pm.getDescription()%></td>
                                                <td width="12%">Transaction Date</td>
                                                <td width="42%"> <%=JSPFormater.formatDate(banknonpoPayment.getTransDate(), "dd/MM/yyyy")%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">Bank Reference 
                                                  Number</td>
                                                <td width="32%"> <%=banknonpoPayment.getRefNumber()%> </td>
                                                <td width="12%" height="16">Invoice 
                                                  Number </td>
                                                <td width="42%" height="16"> <%=(banknonpoPayment.getInvoiceNumber()==null) ? "-" : banknonpoPayment.getInvoiceNumber()%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="14%" height="16">&nbsp;</td>
                                                <td height="8" width="32%">&nbsp; </td>
                                                <td width="12%" height="16">&nbsp;</td>
                                                <td width="42%" height="16">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="14%">Memo</td>
                                                <td height="8" colspan="3"> <%=banknonpoPayment.getMemo()%></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td>&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                          <tr > 
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                            <td class="tab">Disbursement</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabin"><a href="javascript:cmdActivity('<%=oidBanknonpoPayment%>')" class="tablink">Activity</a></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="100%" class="page"> 
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td  class="tablehdr" rowspan="2" width="19%">Account 
                                                                    - Description</td>
                                                                  <td class="tablehdr" rowspan="2">Department</td>
                                                                  <td class="tablehdr" colspan="2">Currency</td>
                                                                  <td class="tablehdr" rowspan="2" width="9%">Booked 
                                                                    Rate </td>
                                                                  <td class="tablehdr" rowspan="2" width="15%">Amount 
                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                  <td class="tablehdr" rowspan="2" width="40%">Description</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td class="tablehdr" width="4%">Code</td>
                                                                  <td class="tablehdr" width="13%">Amount</td>
                                                                </tr>
                                                                <%if(listBanknonpoPaymentDetail!=null && listBanknonpoPaymentDetail.size()>0){
													for(int i=0; i<listBanknonpoPaymentDetail.size(); i++){
														BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail)listBanknonpoPaymentDetail.get(i);
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
                                                                  <td class="<%=cssString%>" width="19%" nowrap height="17"> 
                                                                    <%if(banknonpoPayment.getOID()==0){%>
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%></a> 
                                                                    <%}else{%>
                                                                    <%=c.getCode()%> 
                                                                    <%}%>
                                                                    &nbsp;-&nbsp; 
                                                                    <%=c.getName()%></td>
                                                                  <td width="4%" class="<%=cssString%>" nowrap height="17"> 
                                                                    <%
																  Department d = new Department();
																  try{
																  	d = DbDepartment.fetchExc(crd.getDepartmentId());
																  }
																  catch(Exception e){
																  }
																  %>
																  <%=d.getCode()+" - "+d.getName()%></td>
                                                                  <td width="4%" class="<%=cssString%>" height="17"> 
                                                                    <div align="center"> 
                                                                      <%
									  Currency xc = new Currency();
									  try{
									  		xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
									  }
									  catch(Exception e){
									  }									  
									  %>
                                                                      <%=xc.getCurrencyCode()%> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="13%" class="<%=cssString%>" height="17"> 
                                                                    <div align="right"> 
                                                                      <%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="9%" class="<%=cssString%>" height="17"> 
                                                                    <div align="right"> 
                                                                      <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="15%" class="<%=cssString%>" height="17"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                  </td>
                                                                  <td width="40%" class="<%=cssString%>" height="17"><%=crd.getMemo()%></td>
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
                                                <td colspan="4"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td colspan="2" height="5"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="78%">&nbsp;</td>
                                                      <td width="22%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="78%"> 
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td width="9%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new13','','../images/back2.gif',1)"><img src="../images/back.gif" name="new13"  border="0"></a></td>
                                                            <td width="91%">&nbsp;</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                      <td class="boxed1" width="22%"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                          <tr> 
                                                            <td width="36%"> 
                                                              <div align="left"><b>Total 
                                                                <%=baseCurrency.getCurrencyCode()%> : 
                                                                </b></div>
                                                            </td>
                                                            <td width="64%"> 
                                                              <div align="right"><b><%=JSPFormater.formatNumber(banknonpoPayment.getAmount(), "#,###.##")%></b></div>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4">&nbsp; </td>
                                              </tr>
                                              <%if(banknonpoPayment.getOID()!=0){%>
                                              <tr> 
                                                <td colspan="4">&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4">&nbsp; </td>
                                              </tr>
                                              <%}%>
                                              <tr id="emptymessage"> 
                                                <td colspan="4"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td>&nbsp; </td>
                                                    </tr>
                                                    <tr> 
                                                      <td> 
                                                        <div align="right" class="msgnextaction"> 
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td width="22%">&nbsp;</td>
                                          <td width="28%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="26%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="22%">&nbsp;</td>
                                          <td width="28%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="26%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="22%">&nbsp;</td>
                                          <td width="28%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="26%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="22%">&nbsp;</td>
                                          <td width="28%">&nbsp;</td>
                                          <td width="24%">&nbsp;</td>
                                          <td width="26%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                </table>
                              </td>
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
