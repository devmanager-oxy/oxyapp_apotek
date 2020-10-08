
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.*" %>

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
boolean bankPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO);
%>
<!-- Jsp Block -->
<%!
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
	
	public BankpoPaymentDetail getBankpoPaymentDetail(Invoice ii, Vector bankpoPaymentDetail){	
		BankpoPaymentDetail bpd = new BankpoPaymentDetail();		
		try{
			if(bankpoPaymentDetail!=null && bankpoPaymentDetail.size()>0){
				for(int i=0; i<bankpoPaymentDetail.size(); i++){
					BankpoPaymentDetail x = (BankpoPaymentDetail)bankpoPaymentDetail.get(i);
					if(x.getInvoiceId()==ii.getOID()){
						return x;
					}
				}
			}
		}
		catch(Exception e){
			System.out.println("\nerror : "+e.toString()+"\n");
		}		
		return bpd;		
	}
	
%>
<%

//main data

int iJSPCommand = JSPRequestValue.requestCommand(request);
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

//out.print("--------"+iJSPCommand);
long oidBankpoPayment = JSPRequestValue.requestLong(request, "hidden_bankarchive");
long oidBankpoPaymentx = JSPRequestValue.requestLong(request, "hidden_bankpo_payment_id");

//out.println("--------"+oidBankpoPayment);
//out.println("--------"+oidBankpoPaymentx+"--------");
int iErrCode = JSPMessage.NONE;
CmdBankpoPayment ctrlBankpoPayment = new CmdBankpoPayment(request);

if (oidBankpoPaymentx>0)
{
	iErrCode = ctrlBankpoPayment.action(iJSPCommand , oidBankpoPayment);
	Vector vBPDx = DbBankpoPaymentDetail.list(0,0, "bankpo_payment_id="+oidBankpoPayment, "");
	DbInvoice.checkForClosed(oidBankpoPayment, vBPDx);

}
//out.println("--------"+iErrCode+"--------");
long oidBankpoPaymentDetail = 0;
int vectSize = 0;

JspBankpoPayment jspBankpoPayment = new JspBankpoPayment();
JspBankpoPaymentDetail jspBankpoPaymentDetail = new JspBankpoPaymentDetail();

BankpoPayment bankpoPayment = new BankpoPayment();
if(oidBankpoPayment!=0){
	try{
		bankpoPayment = DbBankpoPayment.fetchExc(oidBankpoPayment);
	}
	catch(Exception e){
	}
}

//detail 
Vector listBankpoPaymentDetail = DbBankpoPaymentDetail.list(0,0, "bankpo_payment_id="+bankpoPayment.getOID(), "");

if(bankpoPayment.getOID()!=0 && iJSPCommand==JSPCommand.SUBMIT){
	DbReceive.checkForClosed(bankpoPayment.getOID(), listBankpoPaymentDetail);
}

%>


<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />

<script language="JavaScript">

<%if(!bankPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>	
						
var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBankpoPaymentPDF?oid=<%=appSessUser.getLoginId()%>&po_id=<%=oidBankpoPayment%>");
}

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

function cmdSubmitCommand(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
}

function cmdAdd(){
	document.frmbankpopayment.hidden_bankpo_payment_id.value="0";
	document.frmbankpopayment.command.value="<%=JSPCommand.ADD%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
}

function cmdAsk(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.ASK%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
}

function cmdConfirmDelete(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.DELETE%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
}
function cmdSave(){
	document.frmbankpopayment.command.value="<%=JSPCommand.SAVE%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
	}

function cmdEdit(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.EDIT%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
	}

function cmdCancel(oidBankpoPayment){
	document.frmbankpopayment.hidden_bankpo_payment_id.value=oidBankpoPayment;
	document.frmbankpopayment.command.value="<%=JSPCommand.EDIT%>";
	document.frmbankpopayment.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
}

function cmdBack(){
	window.history.back();
	}

function cmdListFirst(){
	document.frmbankpopayment.command.value="<%=JSPCommand.FIRST%>";
	document.frmbankpopayment.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
}

function cmdListPrev(){
	document.frmbankpopayment.command.value="<%=JSPCommand.PREV%>";
	document.frmbankpopayment.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
	}

function cmdListNext(){
	document.frmbankpopayment.command.value="<%=JSPCommand.NEXT%>";
	document.frmbankpopayment.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
}

function cmdListLast(){
	document.frmbankpopayment.command.value="<%=JSPCommand.LAST%>";
	document.frmbankpopayment.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmbankpopayment.action="bankpopaymentprint.jsp";
	document.frmbankpopayment.submit();
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
<script type="text/javascript">
<!--
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/post_journal2.gif','../images/print2.gif','../images/back2.gif','../images/close2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Bank</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">PO Payment Archive</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbankpopayment" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
						  <input type="hidden" name="hidden_bankarchive" value="<%=oidBankpoPayment%>">
                          <input type="hidden" name="hidden_bankpo_payment_id" value="<%=oidBankpoPayment%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8" valign="top" colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" width="14%">&nbsp;</td>
                                    <td height="21" valign="middle" width="26%">&nbsp;</td>
                                    <td height="21" valign="middle" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" class="comment"> 
										<div align="right">Date : <%=JSPFormater.formatDate(bankpoPayment.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
										: 
										<%
										User u = new User();
										try{
											u = DbUser.fetch(bankpoPayment.getOperatorId());
										}
										catch(Exception e){
										}
										%>
										<%=u.getLoginId()%>&nbsp;&nbsp;</div>                                    
										</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" colspan="3" bgcolor="#FFFFCC"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="50%"><b>VENDOR</b></td>
                                          <td width="50%">&nbsp;</td>
                                        </tr>
                                        <tr> 
										  <%
											Vendor vendor = new Vendor();
											try{
												vendor = DbVendor.fetchExc(bankpoPayment.getVendorId());
											}
											catch(Exception e){
											}
										  %>

                                          <td width="50%"><b><%=vendor.getCode()+" - "+vendor.getName()%></b></td>
                                          <td width="50%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="50%"> <%=vendor.getAddress()+((vendor.getCity().length()>0) ? ", "+vendor.getCity(): "")+((vendor.getState().length()>0) ? "<br>"+vendor.getState(): "")%> <%=((vendor.getPhone().length()>0) ? vendor.getPhone(): "")+((vendor.getFax().length()>0) ? vendor.getFax(): "")%></td>
                                          <td width="50%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td height="21" colspan="2" width="47%" class="comment">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" width="14%">&nbsp;</td>
                                    <td height="21" valign="middle" width="26%">&nbsp;</td>
                                    <td height="21" valign="middle" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" class="comment">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" width="14%">Payment 
                                      from Account</td>
                                    <td height="21" valign="middle" width="26%"> 
                                      			<%
												Coa coa = new Coa();
												try{
													coa = DbCoa.fetchExc(bankpoPayment.getCoaId());
												}
												catch(Exception e){
												}
												%>
                                                  <%=coa.getCode()+ " - "+coa.getName()%> 
                                      </td>
                                    <td height="21" valign="middle" width="13%">Journal 
                                      Number</td>
                                    <td height="21" colspan="2" width="47%" class="comment"> 
                                      <%
									  int counter = DbBankpoPayment.getNextCounter(sysCompany.getOID());
									  String strNumber = DbBankpoPayment.getNextNumber(counter, sysCompany.getOID());
									  
									  if(bankpoPayment.getOID()!=0){
											strNumber = bankpoPayment.getJournalNumber();
									  }
									  
									  %>
                                      <%=strNumber%> 
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" width="14%">Payment 
                                      Method</td>
                                    <td height="21" valign="middle" width="26%"> 
                                      <%PaymentMethod pm = DbPaymentMethod.fetchExc(bankpoPayment.getPaymentMethodId());%> 
									  <%=pm.getDescription()%>
                                    </td>
                                    <td height="21" valign="middle" width="13%">Trans 
                                      Date</td>
                                    <td height="21" colspan="2" width="47%" class="comment"> 
                                      <%=JSPFormater.formatDate(bankpoPayment.getTransDate(), "dd/MM/yyyy")%></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="middle" width="14%">Cheque/Transfer 
                                      Number</td>
                                    <td height="21" valign="middle" width="26%"> 
                                     <%=bankpoPayment.getRefNumber()%>
                                    </td>
                                    <td height="21" valign="middle" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%" class="comment">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="14%">Memo</td>
                                    <td height="21" valign="top" colspan="4"> <%=bankpoPayment.getMemo()%></td>
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="14%">&nbsp;</td>
                                    <td height="21" valign="top" width="26%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%">&nbsp; 
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" colspan="5"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td> 
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                              <tr > 
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                <td class="tab">Disbursement</td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"></td>
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
                                                      <td  class="tablehdr" width="12%">Invoice 
                                                        Number </td>
                                                      <td class="tablehdr" width="6%">Currency</td>
                                                      <td class="tablehdr" width="11%">Balance</td>
                                                      <td class="tablehdr" width="8%">Booked 
                                                        Rate </td>
                                                      <td class="tablehdr" width="11%">Balance 
                                                        <%=baseCurrency.getCurrencyCode()%></td>
                                                      <td class="tablehdr" width="13%">Payment 
                                                        <%=baseCurrency.getCurrencyCode()%></td>
                                                      <td class="tablehdr" width="11%">Payment 
                                                        By Invoice<br>
                                                        Currency</td>
                                                      <td class="tablehdr" width="28%">Description</td>
                                                    </tr>
                                                    <%if(listBankpoPaymentDetail!=null && listBankpoPaymentDetail.size()>0){
													for(int i=0; i<listBankpoPaymentDetail.size(); i++){
														BankpoPaymentDetail bpd = (BankpoPaymentDetail)listBankpoPaymentDetail.get(i);
														Receive receive = DbReceive.fetchExc(bpd.getInvoiceId());
												%>
                                                    <tr>  
                                                      <td class="tablecell" width="12%"> 
                                                        <div align="left"><%=receive.getInvoiceNumber()+"/"+receive.getDoNumber()%></div>
                                                      </td>
                                                      <td width="6%" class="tablecell"> 
                                                        <div align="center">
														<%
														Currency c = new Currency();
														try{
															c = DbCurrency.fetchExc(receive.getCurrencyId());
														}
														catch(Exception e){
														}														
														
														%>
														<%=c.getCurrencyCode()%>
														</div>
                                                      </td>
                                                      <td width="11%" class="tablecell" align="right"> 
                                                        <%=JSPFormater.formatNumber(DbReceive.getInvoiceBalance(receive.getOID()), "#,###.##")%>
                                                      </td>
                                                      <td width="8%" class="tablecell" align="right"> 
														  <%
														  ExchangeRate eRate = DbExchangeRate.getStandardRate();	

														  double exRateValue = 1;
														  if(c.getCurrencyCode().equals(IDRCODE)){
														  		exRateValue = eRate.getValueIdr();		 
														  }
														  else if(c.getCurrencyCode().equals(USDCODE)){
														  		exRateValue = eRate.getValueUsd();		 		
														  }
														  else{
														  		exRateValue = eRate.getValueEuro();		 		
														  }
														  %>
                                                          <%=JSPFormater.formatNumber(exRateValue, "#,###.##")%>
                                                        
                                                      </td>
                                                      <td width="11%" class="tablecell" align="right"> 
                                                        <%=JSPFormater.formatNumber(exRateValue*DbReceive.getInvoiceBalance(receive.getOID()), "#,###.##")%>
                                                      </td>
                                                      <td width="13%" class="tablecell" align="right"> 
														<%=JSPFormater.formatNumber(bpd.getPaymentAmount(), "#,###.##")%> </td>
                                                      <td width="11%" class="tablecell" align="right"> 
                                                        <%=JSPFormater.formatNumber(bpd.getPaymentByInvCurrencyAmount(), "#,###.##")%>
                                                      </td>
                                                      <td width="28%" class="tablecell"> 
                                                        <%=bpd.getMemo()%>
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
										  <td width="78%">&nbsp;</td>										
										  <td class="boxed1" width="22%"> 
											<table width="100%" border="0" cellspacing="1" cellpadding="1">
											  <tr> 
												<td width="36%"> 
												  <div align="left"><b>Total 
													<%=baseCurrency.getCurrencyCode()%> : 
													</b></div>
												</td>
												<td width="64%"> 
												  <div align="right"> 
                                                    <input type="text" name="tot" value="<%=JSPFormater.formatNumber(bankpoPayment.getAmount(), "#,###.##")%>" style="text-align:right" size="20" class="readonly" readOnly>
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
									<td colspan="4">&nbsp; </td>
								  </tr>
								  <%
										if(bankpoPayment.getOID()!=0 && bankpoPayment.getAmount()>0 && bankpoPayment.getStatus().equals(I_Project.STATUS_NOT_POSTED)){
								  %>								  
								  <tr> 
									<td colspan="4"> 
									  <table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr> 
										  <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
										</tr>
									  </table>
									</td>
								  </tr>
								  <tr> 
									<td colspan="4"> 
									  <table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr> 
										  <td width="8%"><a href="javascript:cmdSubmitCommand(<%=oidBankpoPayment%>)" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
										  <td width="64%">&nbsp;</td>
										  <td width="28%"> 
											<table border="0" cellpadding="5" cellspacing="0" class="info" width="215" align="right">
                                              <tr> 
												<td width="15"><img src="../images/inform.gif" width="20" height="20"></td>
												<td width="180" nowrap>Journal 
                                                  is ready to be posted</td>
											  </tr>
											</table>
										  </td>
										</tr>
									  </table>
									</td>
								  </tr>
								  <%}%>
								  <%if(bankpoPayment.getOID()!=0 && bankpoPayment.getStatus().equals(I_Project.STATUS_POSTED)){%>
								  <tr> 
									<td colspan="4"> 
									  <table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr> 
										  <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
										</tr>
									  </table>
									</td>
								  </tr>
								  <tr> 
									<td colspan="4"> 
									  <table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr> 
										  <td width="3%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
										  <td width="3%">&nbsp;</td>
										  <td width="9%"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print11','','../images/back2.gif',1)"><img src="../images/back.gif" name="print11"  border="0"></a></td>
										  <td width="47%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
										  <td width="38%">
										  <%
										  	if (oidBankpoPaymentx>0)
											{
										  %>
											<table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
											  <tr> 
												<td width="20"><img src="../images/success.gif" width="20" height="20"></td>
												<td width="220">Journal 
												  has been posted 
												  successfully</td>
											  </tr>
											</table>
										  <%}%>
										  </td>
										</tr>
									  </table>
									</td>
								  </tr>
								  <%}%>								  
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="14%">&nbsp;</td>
                                    <td height="21" valign="top" width="26%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%">&nbsp;</td>
								  </tr> 
                                  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="14%">&nbsp;</td>
                                    <td height="21" valign="top" width="26%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%">&nbsp;</td>
								  </tr> 
								  <tr align="left" valign="top"> 
                                    <td height="21" valign="top" width="14%">&nbsp;</td>
                                    <td height="21" valign="top" width="26%">&nbsp;</td>
                                    <td height="21" valign="top" width="13%">&nbsp;</td>
                                    <td height="21" colspan="2" width="47%">&nbsp;</td>
								  </tr> 
                                  <tr> 
                                    <td width="14%">&nbsp;</td>
                                    <td width="26%">&nbsp;</td>
                                    <td width="13%">&nbsp;</td>
                                    <td width="47%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top" > 
                                    <td colspan="5"> 
                                      <div align="left"></div>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                          </table>						  
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
