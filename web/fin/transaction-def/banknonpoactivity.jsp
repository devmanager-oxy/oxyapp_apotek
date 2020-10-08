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
boolean bankPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO);
%>
<!-- Jsp Block -->
<%!

	
	
	
	public Vector addNewDetail(Vector listBanknonpoPaymentActivity, TransactionActivityDetail activityDetail){
		boolean found = false;
		//diblok sementara
		if(listBanknonpoPaymentActivity!=null && listBanknonpoPaymentActivity.size()>0){
			for(int i=0; i<listBanknonpoPaymentActivity.size(); i++){
				TransactionActivityDetail cr = (TransactionActivityDetail)listBanknonpoPaymentActivity.get(i);
				if(cr.getType()==activityDetail.getType() && cr.getModuleId()==activityDetail.getModuleId() && cr.getDonorId()==activityDetail.getDonorId()){
					//jika coa sama dan currency sama lakukan penggabungan					
					cr.setAmount(cr.getAmount()+activityDetail.getAmount());
					found = true;
				}
			}
		}
		
		if(!found){
			listBanknonpoPaymentActivity.add(activityDetail);
		}
		
		return listBanknonpoPaymentActivity;
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
long oidBanknonpoPayment = JSPRequestValue.requestLong(request, "hidden_banknonpo_payment_id");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");
ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();

//out.println("oidBanknonpoPayment : "+oidBanknonpoPayment);

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	if(session.getValue("BNPOACTIVITY_DETAILX")!=null){
		session.removeValue("BNPOACTIVITY_DETAILX");
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

CmdBanknonpoPayment ctrlBanknonpoPayment = new CmdBanknonpoPayment(request);

Vector listBanknonpoPayment = new Vector(1,1);

/*switch statement */
int iErrCodeMain = 0;//ctrlBanknonpoPayment.action(iJSPCommand , oidBanknonpoPayment);
/* end switch*/
JspBanknonpoPayment jspBanknonpoPayment = ctrlBanknonpoPayment.getForm();

/*count list All BanknonpoPayment*/
int vectSize = DbBanknonpoPayment.getCount(whereClause);

BanknonpoPayment banknonpoPayment = new BanknonpoPayment();//ctrlBanknonpoPayment.getBanknonpoPayment();

try{
	banknonpoPayment = DbBanknonpoPayment.fetchExc(oidBanknonpoPayment);
}
catch(Exception e){
}

//out.println("banknonpoPayment : "+banknonpoPayment.getAmount());

String msgStringMain =  "";//ctrlBanknonpoPayment.getMessage();

System.out.println("\n -- start detail session ---\n");

%>
<%

Vector listBanknonpoPaymentActivity = new Vector(1,1);
//detail 
if(session.getValue("BNPOACTIVITY_DETAILX")!=null){
	listBanknonpoPaymentActivity = (Vector)session.getValue("BNPOACTIVITY_DETAILX");
	
	if(iJSPCommand==JSPCommand.RESET && listBanknonpoPaymentActivity!=null && listBanknonpoPaymentActivity.size()>0){
		for(int i=0; i<listBanknonpoPaymentActivity.size(); i++){
			TransactionActivityDetail xx = (TransactionActivityDetail)listBanknonpoPaymentActivity.get(i);
			//if(xx.getIsDirect()==0){
			if(xx.getIsDirect()==0 && xx.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_MODULE){			
				listBanknonpoPaymentActivity.remove(i);
				i=i-1;
			}			
		}
	}
}

//bagian  DETAIL
//===================================update============================
if(iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.RESET){
	iJSPCommand = JSPCommand.ADD;
}
//=====================================================================

//int iJSPCommand = JSPRequestValue.requestJSPCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidTransactionActivityDetail = JSPRequestValue.requestLong(request, "hidden_banknonpo_payment_activity_id");

/*variable declaration*/
//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdTransactionActivityDetail ctrlTransactionActivityDetail = new CmdTransactionActivityDetail(request);
//JSPLine ctrLine = new JSPLine();

/*switch statement */
iErrCode = ctrlTransactionActivityDetail.action(iJSPCommand , oidTransactionActivityDetail);
/* end switch*/
JspTransactionActivityDetail jspTransactionActivityDetail = ctrlTransactionActivityDetail.getForm();

//out.println(jspTransactionActivityDetail.getErrors());

TransactionActivityDetail banknonpoActivityDetail = ctrlTransactionActivityDetail.getTransactionActivityDetail();
msgString =  ctrlTransactionActivityDetail.getMessage();

if(iJSPCommand==JSPCommand.SUBMIT){
	if(iErrCode==0){
		if(recIdx==-1){		
			listBanknonpoPaymentActivity = addNewDetail(listBanknonpoPaymentActivity, banknonpoActivityDetail);
			//listBanknonpoPaymentActivity.add(banknonpoActivityDetail);
		}
		else{
			//listBanknonpoPaymentActivity.set(recIdx, banknonpoActivityDetail);
			listBanknonpoPaymentActivity.remove(recIdx);
			listBanknonpoPaymentActivity = addNewDetail(listBanknonpoPaymentActivity, banknonpoActivityDetail);
		}
	}
}
if(iJSPCommand==JSPCommand.DELETE){
	listBanknonpoPaymentActivity.remove(recIdx);
}

//out.println("<br>sebelum save : "+listBanknonpoPaymentActivity);

if(iJSPCommand==JSPCommand.SAVE){
	if(banknonpoPayment.getOID()!=0){
		long oidFlag = DbTransactionActivityDetail.saveAllDetail(oidBanknonpoPayment, listBanknonpoPaymentActivity);
		DbBanknonpoPayment.postActivityStatus(oidFlag, oidBanknonpoPayment);
		//listBanknonpoPaymentActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+banknonpoPayment.getOID(), "");
	}
}

//out.println("jspTransactionActivityDetail : "+jspTransactionActivityDetail.getErrors());
//out.println("<br>"+listBanknonpoPaymentActivity);

session.putValue("BNPOACTIVITY_DETAILX", listBanknonpoPaymentActivity);

String wherex = "(account_group='"+I_Project.ACC_GROUP_EXPENSE+"' or account_group='"+I_Project.ACC_GROUP_OTHER_EXPENSE+"') "+
				" and (location_id="+sysLocation.getOID()+" or location_id=0)";

//Vector incomeCoas = DbCoa.list(0,0, wherex, "code");

//Vector currencies = DbCurrency.list(0,0,"", "");

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_PETTY_CASH+"' and location_id="+sysCompany.getSystemLocation(), "");
									  
ExchangeRate eRate = DbExchangeRate.getStandardRate();

Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

//out.println("accountBalance : "+accountBalance);

double balance = 0;
double totalDetail = getTotalDetail(listBanknonpoPaymentActivity);

balance = banknonpoPayment.getAmount() - totalDetail; 

//banknonpoPayment.setAmount(totalDetail);

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && iErrCodeMain==0 && recIdx==-1){
	iJSPCommand = JSPCommand.ADD;
	banknonpoActivityDetail = new TransactionActivityDetail();
}

Vector modules = DbModule.list(0,0, "activity_period_id="+openAp.getOID(), "code");

Vector donors = DbDonor.list(0,0, "", "");

//count dari input ke database
int cntActivity = DbTransactionActivityDetail.getCount("transaction_id="+oidBanknonpoPayment); 
if(cntActivity>0){
	listBanknonpoPaymentActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+banknonpoPayment.getOID(), "");
}

Vector expenseCategories = DbCoaCategory.list(0,0, "", "");
Vector natureExpenseCategories = DbCoaGroupAlias.list(0,0, "", "");

Vector bnpDetails = DbBanknonpoPaymentDetail.list(0,0, "banknonpo_payment_id="+oidBanknonpoPayment, "coa_id");
Vector bnpDetailsX = DbBanknonpoPaymentDetail.list(0,0, "banknonpo_payment_id="+oidBanknonpoPayment, "coa_id");
//System.out.println(invDetailsX.size());
long prevId = 0;
for(int i123 = 0; i123<bnpDetailsX.size(); i123++){ 
	BanknonpoPaymentDetail ppd = (BanknonpoPaymentDetail)bnpDetailsX.get(i123);
	try{
		if(ppd.getCoaId()==prevId){
			bnpDetailsX.remove(i123);
		}
	}
	catch(Exception e){
	}
	prevId = ppd.getCoaId();
}
//System.out.println(invDetailsX.size());

//out.println("<br>bnpDetails :"+bnpDetails);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!bankPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<!--
//=======================================update===========================================================
function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBanknonpoPaymentActPDF?oid=<%=appSessUser.getLoginId()%>&nonpo_id=<%=oidBanknonpoPayment%>");
}

function cmdClickIt(){
	document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.select();
}

function cmdGetBalance(){
	
	var x = document.frmbanknonpoactivity.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_COA_ID]%>.value;
	//alert(x);
	<%if(accountBalance!=null && accountBalance.size()>0){
		for(int i=0; i<accountBalance.size(); i++){
			Coa c = (Coa)accountBalance.get(i);
	%>
		if(x=='<%=c.getOID()%>'){
			document.frmbanknonpoactivity.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
			document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);//"<%=c.getOpeningBalance()%>";
			document.frmbanknonpoactivity.pcash_balance.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
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

function cmdPredefined(oid){
		document.frmbanknonpoactivity.hidden_bankarchive.value=oid;
		document.frmbanknonpoactivity.command.value="<%=JSPCommand.EDIT%>";
		document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
		document.frmbanknonpoactivity.action="banknonpoactivitypredefined.jsp";
		document.frmbanknonpoactivity.submit();	
}

function cmdResetIsDirect(){
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.RESET%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdFixing(){	
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.POST%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();	
}

function cmdNewJournal(){	
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.NONE%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();	
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
	var st = document.frmbanknonpoactivity.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value;		
	var ab = document.frmbanknonpoactivity.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>.value;		
	
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
	
	document.frmbanknonpoactivity.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkHeader(){
	var x = document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_MODULE_ID]%>.value;
	<%
		Vector vModule = new Vector();
		vModule = DbModule.list(0,0,"","");
		if(vModule!=null && vModule.size()>0){
			for(int i=0;i<vModule.size();i++){
				Module m = (Module)vModule.get(i);
	%>
				var levelx = "<%=m.getPositionLevel()%>";
				var postable = "<%=I_Project.ACCOUNT_LEVEL_POSTABLE%>";
				if(x==<%=m.getOID()%> && levelx!=postable){
					//alert("<%=m.getPositionLevel()%>");
					alert("Select Postable Activity \nsystem will reset the data");
					document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_MODULE_ID]%>.value = 0;
				}				
	<%
			}
		}
	%>
}

function checkNumber2(){
	var accId = 0;
	var maxAmount = 0;
	var totalAmount = 0;
	var type = 0;
	var coaName = "";
	//combobox type
	type = document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_TYPE]%>.value;		 	
	//alert("type = "+type);
	//combobox account
	accId = document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>.value;		 	
	//alert("accId = "+accId);
	//load invoice detail from database
	if(accId!=0 && type==2){
	<%
		for(int i123 = 0; i123<bnpDetails.size(); i123++){ 
			BanknonpoPaymentDetail ppd = (BanknonpoPaymentDetail)bnpDetails.get(i123);
			Coa co = new Coa();
			try{
				co = DbCoa.fetchExc(ppd.getCoaId());
				String strCoa = co.getCode() +" - "+ co.getName();
				System.out.println(co.getName());
				double tot = 0;
				for(int i2 = 0; i2<bnpDetails.size(); i2++){ 
					BanknonpoPaymentDetail ppd2 = (BanknonpoPaymentDetail)bnpDetails.get(i2);					
					if(ppd2.getCoaId()==ppd.getCoaId())
						tot = tot + ppd2.getAmount();
				}
	%>
				if(accId=='<%=ppd.getCoaId()%>'){
					//maxAmount = <%=ppd.getAmount()%>;	
					maxAmount = <%=tot%>;	
					coaName = '<%=strCoa%>';
				}
	<%	
			}catch(Exception e){
			}
		}

		if(listBanknonpoPaymentActivity!=null && listBanknonpoPaymentActivity.size()>0){
			for(int i=0; i<listBanknonpoPaymentActivity.size(); i++){
				TransactionActivityDetail crd = (TransactionActivityDetail)listBanknonpoPaymentActivity.get(i);
	%>
				if(accId=='<%=crd.getCoaId()%>')
					totalAmount = totalAmount + <%=crd.getAmount()%>;
	<%
			}
		}																
	%>
	}
	maxAmount = maxAmount - totalAmount;
	//alert(maxAmount);
	
	//total
	var currTotal = document.frmbanknonpoactivity.total_detail.value;
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
	//alert("currTotal = "+currTotal);
	var idx = document.frmbanknonpoactivity.select_idx.value;
	
	//maximum NONPO on company
	var maxtransaction = document.frmbanknonpoactivity.max_pcash_transaction.value;
	//alert("maxtransaction = "+maxtransaction);
	//NONPO Opening Balance
	var pbalanace = <%=balance%>;//document.frmbanknonpoactivity.pcash_balance.value;
	//alert("pbalance = "+pbalanace);
	var limit = parseFloat(maxtransaction);
	//alert("limit = "+limit);	
	if(limit > parseFloat(pbalanace)){
		limit = parseFloat(pbalanace);
	}			
	//tambahan
	limit = parseFloat(pbalanace);
	if(type==2){
		if(limit > parseFloat(maxAmount) && parseFloat(maxAmount)>=0){
			limit = parseFloat(maxAmount);
		}			
	}
	//alert("limit = "+limit);	

	//textbox amount
	var st = document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	//alert("result = "+result);
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(result);

		if(parseFloat(amount)>parseFloat(limit)){//parseFloat(main)){		
			if(type==2){
				if(accId==0){
					alert("No account selected");
					document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>.focus();
				}else{				
					alert("Maximum transaction limit for \""+coaName+"\" is "+formatFloat(""+limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
				}
			}else{
				alert("Maximum transaction limit is "+formatFloat(""+limit,'', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
			}
			result = limit;//"0";//parseFloat(limit)-parseFloat(currTotal);

		}
		
		var amount = parseFloat(result);
	
		document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
	}
	//edit
	else{
		var editAmount =  document.frmbanknonpoactivity.edit_amount.value;		
		limit = parseFloat(limit) + parseFloat(editAmount);
		//alert(maxAmount);
		if(type==2){
			if(limit > parseFloat(maxAmount)){
				//maxAmount = parseFloat(maxAmount) + parseFloat(editAmount);
				limit = parseFloat(maxAmount);
			}			
		}
		//alert("limit = "+limit);

		var amount = parseFloat(result);
		//alert("amount = "+amount);

		if(parseFloat(amount)>parseFloat(limit)){//parseFloat(main)){
			if(type==2){
				if(accId==0){
					alert("No account selected");
					document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>.focus();
				}else{				
					alert("Maximum transaction limit for \""+coaName+"\" is "+formatFloat(""+limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
				}
			}else{
				alert("Maximum transaction limit is "+formatFloat(""+limit,'', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
			}
			result = parseFloat(editAmount);			
			amount = limit;
		}

		if(type==2){
			//var amount = parseFloat(result) - parseFloat(editAmount);
		}else{
			//var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		}
		//alert("amount = "+amount);
		document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	
	//document.frmbanknonpoactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
}

function cmdSubmitCommand(){
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.SAVE%>";
	document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdBanknonpoPayment(oid){
	<%if(cntActivity>0){%>
		document.frmbanknonpoactivity.hidden_bankarchive.value=oid;
		document.frmbanknonpoactivity.command.value="<%=JSPCommand.EDIT%>";
		document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
		document.frmbanknonpoactivity.action="banknonpopaymentdetailprint.jsp";
		document.frmbanknonpoactivity.submit();
	<%}else{%>
		alert('Please finish and post activity transaction before go to payment archive');
	<%}%>
	
}

//===============================================================================================

function cmdAdd(){
	document.frmbanknonpoactivity.select_idx.value="-1";
	//document.frmbanknonpoactivity.hidden_banknonpo_payment_id.value="0";
	document.frmbanknonpoactivity.hidden_banknonpo_payment_activity_id.value="0";
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.ADD%>";
	document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdAsk(idx){
	//document.frmbanknonpoactivity.select_idx.value=idx;
	document.frmbanknonpoactivity.hidden_banknonpo_payment_activity_id.value=0;
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.ASK%>";
	document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdConfirmDelete(oidTransactionActivityDetail){
	document.frmbanknonpoactivity.hidden_banknonpo_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.DELETE%>";
	document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdSave(){
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdEdit(idxx){
	document.frmbanknonpoactivity.select_idx.value=idxx;
	document.frmbanknonpoactivity.hidden_banknonpo_payment_activity_id.value=0;
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.EDIT%>";
	document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdCancel(oidTransactionActivityDetail){
	document.frmbanknonpoactivity.hidden_banknonpo_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.EDIT%>";
	document.frmbanknonpoactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdBack(){
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.BACK%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdListFirst(){
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.FIRST%>";
	document.frmbanknonpoactivity.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdListPrev(){
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.PREV%>";
	document.frmbanknonpoactivity.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdListNext(){
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.NEXT%>";
	document.frmbanknonpoactivity.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

function cmdListLast(){
	document.frmbanknonpoactivity.command.value="<%=JSPCommand.LAST%>";
	document.frmbanknonpoactivity.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmbanknonpoactivity.action="banknonpoactivity.jsp";
	document.frmbanknonpoactivity.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidTransactionActivityDetail){
	document.frmimage.hidden_banknonpo_payment_activity_id.value=oidTransactionActivityDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="banknonpoactivity.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Bank&nbsp;&raquo;&nbsp;Non PO&nbsp;&raquo;&nbsp;Payment</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Activity</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbanknonpoactivity" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_banknonpo_payment_activity_id" value="<%=oidTransactionActivityDetail%>">
                          <input type="hidden" name="hidden_banknonpo_payment_id" value="<%=oidBanknonpoPayment%>">
						  <input type="hidden" name="hidden_bankarchive" value="<%=oidBanknonpoPayment%>">
						  
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
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_OPERATOR_ID) %>&nbsp;&nbsp;</div>
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
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="66%"> 
                                                        <%
														Vendor vnd = new Vendor();
														try{
															vnd = DbVendor.fetchExc(banknonpoPayment.getVendorId());
														}
														catch(Exception e){
														}
														%>
                                                        <%=vnd.getCode()+ " - "+vnd.getName()%> </td>
                                                      <td width="2%"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                      <td width="14%">&nbsp;</td>
                                                      <td width="18%"> </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%" valign="top"> 
                                                  <%=vnd.getAddress()%></td>
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
                                                <td width="13%" nowrap>Payment 
                                                  from Account</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="34%"> <b> 
                                                  <%
													Coa coay = new Coa();
													try{
														coay = DbCoa.fetchExc(banknonpoPayment.getCoaId());
													}
													catch(Exception e){
													}
										  			%>
                                                  <%=coay.getCode()+ " - "+coay.getName()%> </b></td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Payment Method</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="34%"> 
                                                  <%
										
													PaymentMethod pm = new PaymentMethod();
													try{
														pm = DbPaymentMethod.fetchExc(banknonpoPayment.getPaymentMethodId());
													}
													catch(Exception ex){
													}
										  			%>
                                                  <%=pm.getDescription()%> </td>
                                                <td width="12%">Journal Number</td>
                                                <td width="39%"> <%=banknonpoPayment.getJournalNumber()%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Bank Reference 
                                                  Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="34%"> <%=banknonpoPayment.getRefNumber()%></td>
                                                <td width="12%">Transaction Date</td>
                                                <td width="39%"> <%=JSPFormater.formatDate(banknonpoPayment.getTransDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" height="16">Amount 
                                                  <%=baseCurrency.getCurrencyCode()%></td>
                                                <td width="2%">&nbsp;</td>
                                                <td height="8" width="34%"> <%=JSPFormater.formatNumber(banknonpoPayment.getAmount(), "#,###.##")%> </td>
                                                <td width="12%" height="16">Invoice 
                                                  Number </td>
                                                <td width="39%" height="16"> <%=banknonpoPayment.getInvoiceNumber()%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Memo</td>
                                                <td width="2%">&nbsp;</td>
                                                <td colspan="3" valign="top"> 
                                                  <%=banknonpoPayment.getMemo()%> </td>
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
                                                            <td class="tabin"><a href="javascript:cmdBanknonpoPayment('<%=oidBanknonpoPayment%>')" class="tablink">Disbursement</a></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tab">Activity</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="13" height="10"> 
                                                              <%if(cntActivity==0){
																 if(DbCoaActivityBudget.bankNonpoPredefined(oidBanknonpoPayment)){																	
															%>
                                                              [ <a href="javascript:cmdPredefined('<%=oidBanknonpoPayment%>')"><b>Predefined</b></a> 
                                                              ] [ <a href="javascript:cmdResetIsDirect()"><b>Reset 
                                                              Predefined</b></a> 
                                                              ] 
                                                              <%}else{%>
                                                              <font color="#990000"> 
                                                              [ no predefined 
                                                              ] </font> 
                                                              <%}}%>
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
                                                                  <td  class="tablehdr" width="5%" height="20">Direct</td>
                                                                  <td  class="tablehdr" width="8%" height="20">Type</td>
                                                                  <td class="tablehdr" width="27%" height="20">Account</td>
                                                                  <td class="tablehdr" width="39%" height="20">Activity</td>
                                                                  <td class="tablehdr" width="21%" height="20">Amount 
                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                </tr>
                                                                <%if(listBanknonpoPaymentActivity!=null && listBanknonpoPaymentActivity.size()>0){
													for(int i=0; i<listBanknonpoPaymentActivity.size(); i++){
																												
														TransactionActivityDetail crd = new TransactionActivityDetail();
														try{
															crd = (TransactionActivityDetail)listBanknonpoPaymentActivity.get(i);
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
                                                                <%
									
												if(((iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK) || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && i==recIdx){%>
                                                                <tr> 
                                                                  <td class="tablecell" width="5%"> 
                                                                    <div align="center"> 
                                                                      <input type="hidden" name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_IS_DIRECT]%>" value="<%=crd.getIsDirect()%>">
                                                                      <%if(crd.getIsDirect()==1){%>
                                                                      <img src="../images/yesx.gif" width="17" height="14"> 
                                                                      <%}%>
                                                                    </div>
                                                                  </td>
                                                                  <td class="tablecell" width="8%"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_TYPE]%>" onChange="javascript:checkNumber2()">
                                                                        <%for(int xx=0; xx<DbTransactionActivityDetail.activities.length; xx++){%>
                                                                        <option value="<%=xx%>" <%if(xx==crd.getType()){%>selected<%}%>><%=DbTransactionActivityDetail.activities[xx]%></option>
                                                                        <%}%>
                                                                      </select>
                                                                    </div>
                                                                  </td>
                                                                  <td width="27%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>" onChange="javascript:checkNumber2()">
                                                                        <option value="0">- None -</option>
                                                                        <%
																		for(int i123 = 0; i123<bnpDetailsX.size(); i123++){ 
																			BanknonpoPaymentDetail ppd = (BanknonpoPaymentDetail)bnpDetailsX.get(i123);
																			Coa co = new Coa();
																			try{
																				co = DbCoa.fetchExc(ppd.getCoaId());
																			}
																			catch(Exception e){
																			}																
																		%>
                                                                        <option value="<%=co.getOID()%>" <%if(co.getOID()==crd.getCoaId()){%>selected<%}%>><%=co.getCode()+ " - "+co.getName()%></option>
                                                                        <%}%>
                                                                      </select>
                                                                      <%= ((jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_COA_ID)).length()>0) ?  "<br>"+jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_COA_ID) : "" %></div>
                                                                  </td>
                                                                  <td width="39%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_MODULE_ID]%>" onChange="javascript:checkNumber2();checkHeader()">
                                                                        <option value="0">- 
                                                                        None -</option>
                                                                        <%if(modules!=null && modules.size()>0){
																		for(int x=0; x<modules.size(); x++){
																			Module d = (Module)modules.get(x);
																			
																			String str = "";
																			if(d.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_H)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_A)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_SA)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_SSA)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			
																			String strx= "";
																			if(d.getDescription().length()>60){
																				strx = d.getCode()+" - "+ (d.getDescription()).substring(0, 60) + "...";
																			}
																			else{
																				strx = d.getCode()+" - "+ (d.getDescription());
																			}
																			if(!d.getPositionLevel().equalsIgnoreCase(I_Project.ACCOUNT_LEVEL_POSTABLE))
																				str = str + strx.toUpperCase();
																			else
																				str = str + strx;																				
																			%>
                                                                        <option value="<%=d.getOID()%>" <%if(crd.getModuleId()==d.getOID()){%>selected<%}%>><%=str%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_MODULE_ID) %></div>
                                                                  </td>
                                                                  <td width="21%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                      <input type="text" name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="25" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
                                                                      <%= jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                <%}else{%>
                                                                <tr> 
                                                                  <td class="<%=cssString%>" width="5%"> 
                                                                    <div align="center"> 
                                                                      <%if(crd.getIsDirect()==1){%>
                                                                      <img src="../images/yesx.gif" width="17" height="14"> 
                                                                      <%}%>
                                                                    </div>
                                                                  </td>
                                                                  <td class="<%=cssString%>" width="8%"> 
                                                                    <%if(cntActivity==0){%>
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=DbTransactionActivityDetail.activities[crd.getType()]%></a> 
                                                                    <%}else{%>
                                                                    <%=DbTransactionActivityDetail.activities[crd.getType()]%> 
                                                                    <%}%>
                                                                  </td>
                                                                  <td width="27%" class="<%=cssString%>" nowrap> 
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
                                                                  <td width="39%" class="<%=cssString%>" nowrap> 
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
                                                                  <td width="21%" class="<%=cssString%>"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                                <%}}%>
                                                                <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && recIdx==-1 ){%>
                                                                <tr> 
                                                                  <td class="tablecell" width="5%"> 
                                                                    <input type="hidden" name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_IS_DIRECT]%>" value="1">
                                                                  </td>
                                                                  <td class="tablecell" width="8%"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_TYPE]%>" onChange="javascript:checkNumber2()">
                                                                        <%for(int xx=0; xx<DbTransactionActivityDetail.activities.length; xx++){%>
                                                                        <option value="<%=xx%>" <%if(xx==banknonpoActivityDetail.getType()){%>selected<%}%>><%=DbTransactionActivityDetail.activities[xx]%></option>
                                                                        <%}%>
                                                                      </select>
                                                                    </div>
                                                                  </td>
                                                                  <td width="27%" class="tablecell"> 
                                                                    <div align="center">
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>" onChange="javascript:checkNumber2()">
                                                                        <option value="0">- None -</option>
                                                                        <%
																		for(int i123 = 0; i123<bnpDetailsX.size(); i123++){ 
																			BanknonpoPaymentDetail ppd = (BanknonpoPaymentDetail)bnpDetailsX.get(i123);
																			Coa co = new Coa();
																			try{
																				co = DbCoa.fetchExc(ppd.getCoaId());
																			}
																			catch(Exception e){
																			}																
																		%>
                                                                        <option value="<%=co.getOID()%>" <%if(co.getOID()==banknonpoActivityDetail.getCoaId()){%>selected<%}%>><%=co.getCode()+ " - "+co.getName()%></option>
                                                                        <%}%>
                                                                      </select>
                                                                      <%= ((jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_COA_ID)).length()>0) ?  "<br>"+jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_COA_ID) : "" %></div>
                                                                  </td>
                                                                  <td width="39%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_MODULE_ID]%>" onChange="javascript:checkNumber2();checkHeader()">
                                                                        <option value="0">- 
                                                                        None -</option>
                                                                        <%if(modules!=null && modules.size()>0){
																		for(int x=0; x<modules.size(); x++){
																			Module d = (Module)modules.get(x);
																			
																			String str = "";
																			if(d.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_H)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_A)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_SA)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_SSA)){
																				str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																			}
																			
																			String strx= "";
																			if(d.getDescription().length()>60){
																				strx = d.getCode()+" - "+ (d.getDescription()).substring(0, 60) + "...";
																			}
																			else{
																				strx = d.getCode()+" - "+ (d.getDescription());
																			}
																			if(!d.getPositionLevel().equalsIgnoreCase(I_Project.ACCOUNT_LEVEL_POSTABLE))
																				str = str + strx.toUpperCase();
																			else
																				str = str + strx;																				
																			%>
                                                                        <option value="<%=d.getOID()%>" <%if(banknonpoActivityDetail.getModuleId()==d.getOID()){%>selected<%}%>><%=str%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_MODULE_ID) %></div>
                                                                  </td>
                                                                  <td width="21%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(banknonpoActivityDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="25" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
                                                                      <%= jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                  </td>
                                                                </tr>
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
                                                      <td width="76%"> 
                                                        <%
										  
										  //if((cntActivity==0 && balance!=0) || iJSPCommand==JSPCommand.EDIT){
										  if((cntActivity==0)){// || iJSPCommand==JSPCommand.EDIT){
										  
										  if(iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ASK && iErrCode==0 && iErrCodeMain==0){
										  	
											//out.println("in here 1");
											
										  		//if(balance!=0){
										  %>
                                                        <a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a> 
                                                        <%//	}
										  }else{
										  //	out.println("in here");
										  
										  %>
                                                        <%
											  	//==============================update============================
											  	
											  	if((iJSPCommand==JSPCommand.SUBMIT || iJSPCommand==JSPCommand.POST) && (iErrCode!=0 || iErrCodeMain!=0)){
													iJSPCommand = JSPCommand.SAVE;
												}
												
												//=================================================================
											  
												ctrLine.setLocationImg(approot+"/images/ctr_line");
												ctrLine.initDefault();
												ctrLine.setTableWidth("90%");
												String scomDel = "javascript:cmdAsk('"+oidTransactionActivityDetail+"')";
												String sconDelCom = "javascript:cmdConfirmDelete('"+oidTransactionActivityDetail+"')";
												String scancel = "javascript:cmdEdit('"+recIdx+"')";
												if(listBanknonpoPaymentActivity!=null && listBanknonpoPaymentActivity.size()>0){
													ctrLine.setBackCaption("Cancel");
												}
												else{
													ctrLine.setBackCaption("");
												}
												ctrLine.setJSPCommandStyle("command");
												ctrLine.setDeleteCaption("Delete");
												
												ctrLine.setOnMouseOut("MM_swapImgRestore()");
												ctrLine.setOnMouseOverSave("MM_swapImage('save','','"+approot+"/images/savenew2.gif',1)");
												ctrLine.setSaveImage("<img src=\""+approot+"/images/savenew.gif\" name=\"save\" height=\"22\" border=\"0\">");
												
												//ctrLine.setOnMouseOut("MM_swapImgRestore()");
												ctrLine.setOnMouseOverBack("MM_swapImage('back','','"+approot+"/images/cancel2.gif',1)");
												ctrLine.setBackImage("<img src=\""+approot+"/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");
												
												ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','"+approot+"/images/delete2.gif',1)");
												ctrLine.setDeleteImage("<img src=\""+approot+"/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");
												
												ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','"+approot+"/images/cancel2.gif',1)");
												ctrLine.setEditImage("<img src=\""+approot+"/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");
												
												
												ctrLine.setWidthAllJSPCommand("90");
												ctrLine.setErrorStyle("warning");
												ctrLine.setErrorImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
												ctrLine.setQuestionStyle("warning");
												ctrLine.setQuestionImage(approot+"/images/error.gif\" width=\"20\" height=\"20");
												ctrLine.setInfoStyle("success");
												ctrLine.setSuccessImage(approot+"/images/success.gif\" width=\"20\" height=\"20");
												
												if(iErrCode==0 && iErrCodeMain!=0){
													ctrLine.setSaveJSPCommand("javascript:cmdFixing()");
												}
			
												if (privDelete){
													ctrLine.setConfirmDelJSPCommand(sconDelCom);
													ctrLine.setDeleteJSPCommand(scomDel);
													ctrLine.setEditJSPCommand(scancel);
												}else{ 
													ctrLine.setConfirmDelCaption("");
													ctrLine.setDeleteCaption("");
													ctrLine.setEditCaption("");
												}
			
												if(privAdd == false  && privUpdate == false){
													ctrLine.setSaveCaption("");
												}
			
												if (privAdd == false){
													ctrLine.setAddCaption("");
												}
												
												//========================update=============================
												if(iErrCode==0 && iErrCodeMain!=0){
													iErrCode = iErrCodeMain;
													msgString = msgStringMain;
												}
												//===========================================================
												
												%>
                                                        <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                        <%}}%>
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
																//out.println("<br>banknonpoPayment.getAmount() : "+banknonpoPayment.getAmount());
																
																balance = banknonpoPayment.getAmount() - totalDetail;
																%>
                                                                <input type="hidden" name="total_detail" value="<%=totalDetail%>">
                                                                <%=JSPFormater.formatNumber(totalDetail, "#,###.##")%></b></div>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td width="49%"> 
                                                              <div align="right"><b>Out 
                                                                Of Balance <%=baseCurrency.getCurrencyCode()%> :</b></div>
                                                            </td>
                                                            <td width="51%"> 
                                                              <div align="right"><b> 
                                                                <%if(balance>0){%>
                                                                <%=JSPFormater.formatNumber(balance, "#,###.##")%> 
                                                                <%}else{%>
                                                                <font color="#FF0000"><%=JSPFormater.formatNumber(balance, "#,###.##")%></font> 
                                                                <%}%>
                                                                </b></div>
                                                            </td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%if(banknonpoPayment.getAmount()!=0 && iErrCode==0 && iErrCodeMain==0 && balance==0 && cntActivity==0){%>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td height="2">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                                      <td width="60%">&nbsp;</td>
                                                      <td width="32%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                          <table border="0" cellpadding="5" cellspacing="0" class="info" width="220" align="right">
                                                            <tr> 
                                                              <td width="20"><img src="../images/inform.gif" width="20" height="20"></td>
                                                              <td width="200" nowrap>Activity 
                                                                is ready to be posted</td>
                                                            </tr>
                                                          </table>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <%if(cntActivity!=0){%>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td height="2">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="4%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="9%">&nbsp;</td>
                                                      <td width="49%">&nbsp;</td>
                                                      <td width="36%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                          <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                            <tr> 
                                                              <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                              <td width="220">Activity 
                                                                has been posted 
                                                                successfully</td>
                                                            </tr>
                                                          </table>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
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
				//document.frmbanknonpoactivity.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value= formatFloat('<%=totalDetail%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
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
