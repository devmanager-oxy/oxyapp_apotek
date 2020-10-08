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
				if(cr.getIsDirect()==activityDetail.getIsDirect() && cr.getType()==activityDetail.getType() && cr.getModuleId()==activityDetail.getModuleId() && cr.getDonorId()==activityDetail.getDonorId()){
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
	if(session.getValue("INVACTIVITY_ITEMX")!=null){
		session.removeValue("INVACTIVITY_ITEMX");
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
	
if(invoice.getPurchaseId()!=0){
	try{
		purchase = DbPurchase.fetchExc(invoice.getPurchaseId());
	}
	catch(Exception e){
	}
}

//out.println("invoice : "+invoice.getGrandTotal());

String msgStringMain =  "";//ctrlInvoice.getMessage();

System.out.println("\n -- start detail session ---\n");

%>
<%
Vector listInvoiceActivity = new Vector(1,1);
//detail 
if(session.getValue("INVACTIVITY_ITEMX")!=null){
	listInvoiceActivity = (Vector)session.getValue("INVACTIVITY_ITEMX");
	if(iJSPCommand==JSPCommand.RESET && listInvoiceActivity!=null && listInvoiceActivity.size()>0){
		for(int i=0; i<listInvoiceActivity.size(); i++){
			TransactionActivityDetail xx = (TransactionActivityDetail)listInvoiceActivity.get(i);
			//if(xx.getIsDirect()==0){
			if(xx.getIsDirect()==0 && xx.getType()==DbTransactionActivityDetail.ACTIVITY_TYPE_MODULE){			
				listInvoiceActivity.remove(i);
				i=i-1;
			}			
		}
	}
}

//bagian CASH RECEIVE DETAIL
//===================================update============================
if(iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.RESET){
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
/*switch statement */
iErrCode = ctrlTransactionActivityDetail.action(iJSPCommand , oidTransactionActivityDetail);
/* end switch*/
JspTransactionActivityDetail jspTransactionActivityDetail = ctrlTransactionActivityDetail.getForm();

//out.println(jspTransactionActivityDetail.getErrors());

TransactionActivityDetail invoiceActivityDetail = ctrlTransactionActivityDetail.getTransactionActivityDetail();
msgString =  ctrlTransactionActivityDetail.getMessage();


if(iJSPCommand==JSPCommand.SUBMIT){
	if(iErrCode==0){
		if(recIdx==-1){		
			listInvoiceActivity = addNewDetail(listInvoiceActivity, invoiceActivityDetail);
			//listInvoiceActivity.add(invoiceActivityDetail);
		}
		else{
			//listInvoiceActivity.set(recIdx, invoiceActivityDetail);
			listInvoiceActivity.remove(recIdx);
			listInvoiceActivity = addNewDetail(listInvoiceActivity, invoiceActivityDetail);
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

session.putValue("INVACTIVITY_ITEMX", listInvoiceActivity);

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
	invoiceActivityDetail = new TransactionActivityDetail();
}

Vector modules = DbModule.list(0,0, "activity_period_id="+openAp.getOID(), "code");

Vector donors = DbDonor.list(0,0, "", "");

//count dari input ke database
int cntActivity = DbTransactionActivityDetail.getCount("transaction_id="+oidInvoice); 
if(cntActivity>0){
	listInvoiceActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+invoice.getOID(), "");
}

Vector expenseCategories = DbCoaCategory.list(0,0, "", "");
Vector natureExpenseCategories = DbCoaGroupAlias.list(0,0, "", "");

Vector invDetails = DbInvoiceItem.list(0,0, "invoice_id="+oidInvoice, "coa_id");
Vector invDetailsX = DbInvoiceItem.list(0,0, "invoice_id="+oidInvoice, "coa_id");
//System.out.println(invDetailsX.size());
long prevId = 0;
for(int i123 = 0; i123<invDetailsX.size(); i123++){ 
	InvoiceItem ppd = (InvoiceItem)invDetailsX.get(i123);
	try{
		if(ppd.getCoaId()==prevId){
			invDetailsX.remove(i123);
		}
	}
	catch(Exception e){
	}
	prevId = ppd.getCoaId();
}
//System.out.println(invDetailsX.size());
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
<!--
//=======================================update===========================================================

<%if(!closingPriv || !closingPrivView || !closingPrivUpdate){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>


function cmdResetIsDirect(){
	document.frminvoiceitem.command.value="<%=JSPCommand.RESET%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptAccPaymentActPDF?oid=<%=appSessUser.getLoginId()%>&inv_id=<%=invoice.getOID()%>");
}

function cmdClickIt(){
	document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.select();
}

function cmdGetBalance(){
	
	
	
	//checkNumber();
}

function cmdFixing(){	
	document.frminvoiceitem.command.value="<%=JSPCommand.POST%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();	
}

function cmdNewJournal(){	
	document.frminvoiceitem.command.value="<%=JSPCommand.NONE%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();	
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
	var st = document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value;		
	var ab = 0;
	
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
	
	document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkHeader(){
	var x = document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_MODULE_ID]%>.value;
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
					document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_MODULE_ID]%>.value = 0;
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
	type = document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_TYPE]%>.value;		 	
	//alert("type = "+type);
	//combobox account
	accId = document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>.value;		 	
	//alert("accId = "+accId);
	//load invoice detail from database
	if(accId!=0 && type==2){
	<%
		for(int i123 = 0; i123<invDetails.size(); i123++){ 
			InvoiceItem ppd = (InvoiceItem)invDetails.get(i123);
			Coa co = new Coa();
			try{
				co = DbCoa.fetchExc(ppd.getCoaId());
				String strCoa = co.getCode() +" - "+ co.getName();
				System.out.println(co.getName());
				double tot = 0;
				for(int i2 = 0; i2<invDetails.size(); i2++){ 
					InvoiceItem ppd2 = (InvoiceItem)invDetails.get(i2);					
					if(ppd2.getCoaId()==ppd.getCoaId())
						tot = tot + (ppd2.getTotal()/invoice.getVatPercent())+ppd2.getTotal();
				}
	%>
				if(accId=='<%=ppd.getCoaId()%>'){
					//maxAmount = <%=ppd.getTotal()%>;	
					maxAmount = <%=tot%>;	
					coaName = '<%=strCoa%>';
				}
	<%	
			}catch(Exception e){
			}
		}

		if(listInvoiceActivity!=null && listInvoiceActivity.size()>0){
			for(int i=0; i<listInvoiceActivity.size(); i++){
				TransactionActivityDetail crd = (TransactionActivityDetail)listInvoiceActivity.get(i);
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
	var currTotal = document.frminvoiceitem.total_detail.value;
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
	//alert("currTotal = "+currTotal);
	var idx = document.frminvoiceitem.select_idx.value;
	
	//maximum INV on company
	var maxtransaction = document.frminvoiceitem.max_pcash_transaction.value;
	//alert("maxtransaction = "+maxtransaction);
	//INV Opening Balance
	var pbalanace = <%=balance%>;//document.frminvoiceitem.pcash_balance.value;
	//alert("pbalance = "+pbalanace);
	var limit = parseFloat(maxtransaction);
	//alert("limit = "+limit);	
	if(limit > parseFloat(pbalanace)){
		limit = parseFloat(pbalanace);
	}			
	if(type==2){
		if(limit > parseFloat(maxAmount) && parseFloat(maxAmount)>=0){
			limit = parseFloat(maxAmount);
		}			
	}
	//alert("limit = "+limit);	
	
	//textbox amount
	var st = document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value;		
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
					document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>.focus();
				}else{				
					alert("Maximum transaction limit for \""+coaName+"\" is "+formatFloat(""+limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
				}
			}else{
				alert("Maximum transaction limit is "+formatFloat(""+limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");		
			}
			result = limit;//"0";//parseFloat(limit)-parseFloat(currTotal);

		}
		
		var amount = parseFloat(result);
	
		document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	//edit
	else{
		var editAmount =  document.frminvoiceitem.edit_amount.value;		
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
					document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>.focus();
				}else{				
					alert("Maximum transaction limit for \""+coaName+"\" is "+formatFloat(""+limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
				}
			}else{
				alert("Maximum transaction limit is "+formatFloat(""+limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");		
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
		document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	
	//document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
}

function cmdSubmitCommand(){
	document.frminvoiceitem.command.value="<%=JSPCommand.SAVE%>";
	document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdInvoice(oid){
	<%if(cntActivity>0){%>
	document.frminvoiceitem.hidden_casharchive.value=oid;
	document.frminvoiceitem.command.value="<%=JSPCommand.EDIT%>";
	document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceitem.action="invoiceclosing.jsp";
	document.frminvoiceitem.submit();
	<%}else{%>
		alert('Please finish and post activity transaction before go to payment archive');
	<%}%>
	
}

function cmdPredefined(oid){
		document.frminvoiceitem.hidden_casharchive.value=oid;
		document.frminvoiceitem.command.value="<%=JSPCommand.EDIT%>";
		document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
		document.frminvoiceitem.action="invoiceactivityclosingpredefined.jsp";
		document.frminvoiceitem.submit();
	
}


//===============================================================================================

function cmdAdd(){
	document.frminvoiceitem.select_idx.value="-1";
	//document.frminvoiceitem.hidden_invoice_id.value="0";
	document.frminvoiceitem.hidden_invoice_activity_id.value="0";
	document.frminvoiceitem.command.value="<%=JSPCommand.ADD%>";
	document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdAsk(idx){
	//document.frminvoiceitem.select_idx.value=idx;
	document.frminvoiceitem.hidden_invoice_activity_id.value=0;
	document.frminvoiceitem.command.value="<%=JSPCommand.ASK%>";
	document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdConfirmDelete(oidTransactionActivityDetail){
	document.frminvoiceitem.hidden_invoice_activity_id.value=oidTransactionActivityDetail;
	document.frminvoiceitem.command.value="<%=JSPCommand.DELETE%>";
	document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdSave(){
	document.frminvoiceitem.command.value="<%=JSPCommand.SUBMIT%>";
	document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdEdit(idxx){
	document.frminvoiceitem.select_idx.value=idxx;
	document.frminvoiceitem.hidden_invoice_activity_id.value=0;
	document.frminvoiceitem.command.value="<%=JSPCommand.EDIT%>";
	document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdCancel(oidTransactionActivityDetail){
	document.frminvoiceitem.hidden_invoice_activity_id.value=oidTransactionActivityDetail;
	document.frminvoiceitem.command.value="<%=JSPCommand.EDIT%>";
	document.frminvoiceitem.prev_command.value="<%=prevJSPCommand%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdBack(){
	document.frminvoiceitem.command.value="<%=JSPCommand.BACK%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdListFirst(){
	document.frminvoiceitem.command.value="<%=JSPCommand.FIRST%>";
	document.frminvoiceitem.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdListPrev(){
	document.frminvoiceitem.command.value="<%=JSPCommand.PREV%>";
	document.frminvoiceitem.prev_command.value="<%=JSPCommand.PREV%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdListNext(){
	document.frminvoiceitem.command.value="<%=JSPCommand.NEXT%>";
	document.frminvoiceitem.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
}

function cmdListLast(){
	document.frminvoiceitem.command.value="<%=JSPCommand.LAST%>";
	document.frminvoiceitem.prev_command.value="<%=JSPCommand.LAST%>";
	document.frminvoiceitem.action="invoiceactivityclosing.jsp";
	document.frminvoiceitem.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/post_journal2.gif','../images/print2.gif','../images/close2.gif')">
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
                        <form name="frminvoiceitem" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_invoice_activity_id" value="<%=oidTransactionActivityDetail%>">
                          <input type="hidden" name="hidden_invoice_id" value="<%=oidInvoice%>">
						  <input type="hidden" name="hidden_casharchive" value="<%=oidInvoice%>">
						  
                          <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="max_pcash_transaction" value="<%=invoice.getGrandTotal()%>">
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
                                                <td width="10%" nowrap>Vendor 
                                                </td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"> 
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
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"><%=v.getAddress() + ((v.getCity().length()>0) ? ", "+v.getCity() : "") + ((v.getState().length()>0) ? "<br>"+v.getState() : "") + ((v.getCountryName().length()>0) ? ", "+v.getCountryName() : "") %></td>
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%">&nbsp;</td>
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="12%" align="left"  >Purchase 
                                                  Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td  width="28%" align="left"> 
                                                  <%=purchase.getJournalNumber()%> 
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_PURCHASE_ID]%>" value="<%=invoice.getPurchaseId()%>" class="formElemen">
                                                  <%=jspInvoice.getErrorMsg(JspInvoice.JSP_PURCHASE_ID)%> </td>
                                                <td  width="10%" align="left">Journal 
                                                  Number</td>
                                                <td width="38%"> 
                                                  <%
									  int counter = DbInvoice.getNextCounter();
									  String strNumber = DbInvoice.getNextNumber(counter);
									  
									  if(invoice.getOID()!=0){
											strNumber = invoice.getJournalNumber();
									  }
									  
									  %>
                                                  <%=strNumber%> 
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_JOURNAL_NUMBER]%>" value="<%=invoice.getJournalNumber()%>" class="formElemen">
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_JOURNAL_PREFIX]%>" value="<%=invoice.getJournalPrefix()%>" class="formElemen">
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_JOURNAL_COUNTER]%>" value="<%=invoice.getJournalCounter()%>" class="formElemen">
                                                  <%=jspInvoice.getErrorMsg(JspInvoice.JSP_JOURNAL_NUMBER)%></td>
                                              </tr>
                                              <tr> 
                                                <td width="12%" align="left"  >Purchase 
                                                  Currency </td>
                                                <td width="2%">&nbsp;</td>
                                                <td  width="28%" align="left"> 
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
                                                <td  width="50%" align="left"> 
                                                  <%=JSPFormater.formatDate((invoice.getTransDate()==null) ? new Date() : invoice.getTransDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="12%" align="left"  >Apply 
                                                  VAT</td>
                                                <td width="2%">&nbsp;</td>
                                                <td  width="28%" align="left"> 
                                                  <%if(invoice.getApplyVat()==1){%>
                                                  YES 
                                                  <%}else{%>
                                                  NO 
                                                  <%}%>
                                                  <input type="hidden" name="<%=JspInvoice.colNames[JspInvoice.JSP_APPLY_VAT]%>" value="<%=invoice.getApplyVat()%>">
                                                </td>
                                                <td  width="10%" align="left">Due 
                                                  Date</td>
                                                <td  width="50%" align="left"> 
                                                  <%=JSPFormater.formatDate((invoice.getDueDate()==null) ? new Date() : invoice.getDueDate(), "dd/MM/yyyy")%></td>
                                              </tr>
                                              <tr> 
                                                <td width="12%" align="left" height="18"  >Vendor 
                                                  Invoice Number</td>
                                                <td width="2%" height="18">&nbsp;</td>
                                                <td  width="28%" align="left" height="18"> 
                                                  <%=invoice.getVendorInvoiceNumber()%></td>
                                                <td width="13%" nowrap height="18">&nbsp;</td>
                                                <td width="38%" height="18">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="12%" align="left"  >Memo</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"><%=invoice.getMemo()%></td>
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" nowrap>&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%">&nbsp;</td>
                                                <td width="13%" nowrap>&nbsp;</td>
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
                                                              <%if(cntActivity==0){
																 if(DbCoaActivityBudget.invoicePredefined(oidInvoice)){																	
															%>
                                                              [ <a href="javascript:cmdPredefined('<%=oidInvoice%>')"><b>Predefined</b></a> 
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
                                                                  <td  class="tablehdr" width="6%" height="20">&nbsp;Direct&nbsp;</td>
                                                                  <td  class="tablehdr" width="12%" height="20">Type</td>
                                                                  <td class="tablehdr" width="21%" height="20">Account</td>
                                                                  <td class="tablehdr" width="40%" height="20">Activity</td>
                                                                  <td class="tablehdr" width="21%" height="20">Amount 
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
														
														Coa cx = new Coa();
														try{
															cx = DbCoa.fetchExc(crd.getCoaId());
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
                                                                  <td class="tablecell" width="6%"> 
                                                                    <div align="center"> 
                                                                      <input type="hidden" name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_IS_DIRECT]%>" value="<%=crd.getIsDirect()%>">
                                                                      <%if(crd.getIsDirect()==1){%>
                                                                      <img src="../images/yesx.gif" width="17" height="14"> 
                                                                      <%}%>
                                                                    </div>
                                                                  </td>
                                                                  <td class="tablecell" width="12%"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_TYPE]%>" onChange="javascript:checkNumber2()">
                                                                        <%for(int xx=0; xx<DbTransactionActivityDetail.activities.length; xx++){%>
                                                                        <option value="<%=xx%>" <%if(xx==crd.getType()){%>selected<%}%>><%=DbTransactionActivityDetail.activities[xx]%></option>
                                                                        <%}%>
                                                                      </select>
                                                                    </div>
                                                                  </td>
                                                                  <td width="21%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>" onChange="javascript:checkNumber2()">
                                                                        <option value="0">- 
                                                                        None -</option>
                                                                        <%																		
																		for(int i123 = 0; i123<invDetailsX.size(); i123++){ 
																			InvoiceItem ppd = (InvoiceItem)invDetailsX.get(i123);
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
                                                                  <td width="40%" class="tablecell"> 
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
																			
																			String strx= "";
																			if(d.getDescription().length()>30){
																				strx = d.getCode()+" - "+ (d.getDescription()).substring(0, 30) + "...";
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
                                                                  <td class="<%=cssString%>" width="6%"> 
                                                                    <div align="center"> 
                                                                      <%if(crd.getIsDirect()==1){%>
                                                                      <img src="../images/yesx.gif" width="17" height="14"> 
                                                                      <%}%>
                                                                    </div>
                                                                  </td>
                                                                  <td class="<%=cssString%>" width="12%"> 
                                                                    <%
																	
																	//out.println(crd.getIsDirect());
																	
																	if(cntActivity==0){%>
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=DbTransactionActivityDetail.activities[crd.getType()]%></a> 
                                                                    <%}else{%>
                                                                    <%=DbTransactionActivityDetail.activities[crd.getType()]%> 
                                                                    <%}%>
                                                                  </td>
                                                                  <td width="21%" class="<%=cssString%>" nowrap> 
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
                                                                  <td width="40%" class="<%=cssString%>" nowrap> 
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
                                                                  <td class="tablecell" width="6%"> 
                                                                    <input type="hidden" name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_IS_DIRECT]%>" value="1">
                                                                  </td>
                                                                  <td class="tablecell" width="12%"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_TYPE]%>" onChange="javascript:checkNumber2()">
                                                                        <%for(int xx=0; xx<DbTransactionActivityDetail.activities.length; xx++){%>
                                                                        <option value="<%=xx%>" <%if(xx==invoiceActivityDetail.getType()){%>selected<%}%>><%=DbTransactionActivityDetail.activities[xx]%></option>
                                                                        <%}%>
                                                                      </select>
                                                                    </div>
                                                                  </td>
                                                                  <td width="21%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_COA_ID]%>" onChange="javascript:checkNumber2()">
                                                                        <option value="0">- 
                                                                        None -</option>
                                                                        <%
																		for(int i123 = 0; i123<invDetailsX.size(); i123++){ 
																			InvoiceItem ppd = (InvoiceItem)invDetailsX.get(i123);
																			Coa co = new Coa();
																			try{
																				co = DbCoa.fetchExc(ppd.getCoaId());
																			}
																			catch(Exception e){
																			}																
																		%>
                                                                        <option value="<%=co.getOID()%>" <%if(co.getOID()==invoiceActivityDetail.getCoaId()){%>selected<%}%>><%=co.getCode()+ " - "+co.getName()%></option>
                                                                        <%}%>
                                                                      </select>
                                                                      <%= ((jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_COA_ID)).length()>0) ?  "<br>"+jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_COA_ID) : "" %></div>
                                                                  </td>
                                                                  <td width="40%" class="tablecell"> 
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
                                                                        <option value="<%=d.getOID()%>" <%if(invoiceActivityDetail.getModuleId()==d.getOID()){%>selected<%}%>><%=str%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspTransactionActivityDetail.getErrorMsg(jspTransactionActivityDetail.JSP_MODULE_ID) %></div>
                                                                  </td>
                                                                  <td width="21%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(invoiceActivityDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="25" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
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
												if(listInvoiceActivity!=null && listInvoiceActivity.size()>0){
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
																//out.println("<br>invoice.getGrandTotal() : "+invoice.getGrandTotal());
																
																balance = invoice.getGrandTotal() - totalDetail;
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
                                              <%if(invoice.getGrandTotal()!=0 && iErrCode==0 && iErrCodeMain==0 && balance==0 && cntActivity==0){%>
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
                                                      <td width="9%"><a href="<%=approot%>/incomplete/closinglist.jsp?menu_idx=7"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
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
				//document.frminvoiceitem.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value= formatFloat('<%=totalDetail%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
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
