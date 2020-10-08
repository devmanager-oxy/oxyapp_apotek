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
<!-- Jsp Block -->
<%!

	
	
	
	public Vector addNewDetail(Vector listPettycashPaymentDetail, PettycashPaymentDetail pettycashPaymentDetail){
		boolean found = false;
		if(listPettycashPaymentDetail!=null && listPettycashPaymentDetail.size()>0){
			for(int i=0; i<listPettycashPaymentDetail.size(); i++){
				PettycashPaymentDetail cr = (PettycashPaymentDetail)listPettycashPaymentDetail.get(i);
				if(cr.getCoaId()==pettycashPaymentDetail.getCoaId() && cr.getDepartmentId()==pettycashPaymentDetail.getDepartmentId()){
					//jika coa sama dan currency sama lakukan penggabungan					
					cr.setAmount(cr.getAmount()+pettycashPaymentDetail.getAmount());
					found = true;
				}
			}
		}
		
		if(!found){
			listPettycashPaymentDetail.add(pettycashPaymentDetail);
		}
		
		return listPettycashPaymentDetail;
	}
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				PettycashPaymentDetail crd = (PettycashPaymentDetail)listx.get(i);
				result = result + crd.getAmount();
			}
		}
		return result;
	}
	
	public static String getAccountRecursif(Coa coa, long oid, boolean isPostableOnly){	
		
		System.out.println("in recursif : "+coa.getOID());
		
		String result = "";
		if(!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
			
			System.out.println("not postable ...");
			
			Vector coas = DbCoa.list(0,0, "acc_ref_id="+coa.getOID(), "code");
			
			System.out.println(coas);
			
			if(coas!=null && coas.size()>0){
				for(int i=0; i<coas.size(); i++){
					
					Coa coax = (Coa)coas.get(i);												
					String str = "";
													
					if(!isPostableOnly){
						switch(coax.getLevel()){
							case 1 : 											
								break;
							case 2 : 
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 3 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 4 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;
							case 5 :
								str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								break;				
						}
					}
					
					result = result + "<option value=\""+coax.getOID()+"\""+((oid==coax.getOID()) ? "selected" : "")+">"+str+coax.getCode()+" - "+coax.getName()+"</option>";
					
					if(!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)){
						result = result + getAccountRecursif(coax, oid, isPostableOnly);
					}
					
					
				}
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

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	//if(session.getValue("PPPAYMENT_DETAIL")!=null){
		session.removeValue("PPPAYMENT_DETAIL");
	//}
	oidPettycashPayment = 0;
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

CmdPettycashPayment ctrlPettycashPayment = new CmdPettycashPayment(request);
JSPLine ctrLine = new JSPLine();
Vector listPettycashPayment = new Vector(1,1);

/*switch statement */
int iErrCodeMain = ctrlPettycashPayment.action(iJSPCommand , oidPettycashPayment);
/* end switch*/
JspPettycashPayment jspPettycashPayment = ctrlPettycashPayment.getForm();

/*count list All PettycashPayment*/
int vectSize = DbPettycashPayment.getCount(whereClause);

PettycashPayment pettycashPayment = ctrlPettycashPayment.getPettycashPayment();
String msgStringMain =  ctrlPettycashPayment.getMessage();

if(oidPettycashPayment==0){
	oidPettycashPayment = pettycashPayment.getOID();
}

System.out.println("\n -- start detail session ---\n");

%>
<%

//detail 

//bagian CASH RECEIVE DETAIL
//===================================update============================
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
}
//=====================================================================

//int iJSPCommand = JSPRequestValue.requestJSPCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPettycashPaymentDetail = JSPRequestValue.requestLong(request, "hidden_pettycash_payment_detail_id");

/*variable declaration*/
//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdPettycashPaymentDetail ctrlPettycashPaymentDetail = new CmdPettycashPaymentDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listPettycashPaymentDetail = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPettycashPaymentDetail.action(iJSPCommand , oidPettycashPaymentDetail);
/* end switch*/
JspPettycashPaymentDetail jspPettycashPaymentDetail = ctrlPettycashPaymentDetail.getForm();

PettycashPaymentDetail pettycashPaymentDetail = ctrlPettycashPaymentDetail.getPettycashPaymentDetail();
msgString =  ctrlPettycashPaymentDetail.getMessage();

/* get record to display */
//listPettycashPaymentDetail = DbPettycashPaymentDetail.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
/*if (listPettycashPaymentDetail.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listPettycashPaymentDetail = DbPettycashPaymentDetail.list(start,recordToGet, whereClause , orderClause);
}
*/

if(session.getValue("PPPAYMENT_DETAIL")!=null){
	listPettycashPaymentDetail = (Vector)session.getValue("PPPAYMENT_DETAIL");
}

if(iJSPCommand==JSPCommand.SUBMIT){
	if(iErrCode==0){
		if(recIdx==-1){		
			//listPettycashPaymentDetail = addNewDetail(listPettycashPaymentDetail, pettycashPaymentDetail);
			listPettycashPaymentDetail.add(pettycashPaymentDetail);
		}
		else{
			listPettycashPaymentDetail.set(recIdx, pettycashPaymentDetail);
			//listPettycashPaymentDetail.remove(recIdx);
			//listPettycashPaymentDetail = addNewDetail(listPettycashPaymentDetail, pettycashPaymentDetail);
		}
	}
}
if(iJSPCommand==JSPCommand.DELETE){
	if(listPettycashPaymentDetail!=null && listPettycashPaymentDetail.size()>recIdx){
		listPettycashPaymentDetail.remove(recIdx);	
	}
}

if(iJSPCommand==JSPCommand.SAVE){
	if(pettycashPayment.getOID()!=0){
		DbPettycashPaymentDetail.saveAllDetail(pettycashPayment, listPettycashPaymentDetail);
		listPettycashPaymentDetail = DbPettycashPaymentDetail.list(0,0, "pettycash_payment_id="+pettycashPayment.getOID(), "");
		
		//posting journal
		DbPettycashPayment.postJournal(pettycashPayment, listPettycashPaymentDetail);
	}
}

//out.println("jspPettycashPaymentDetail : "+jspPettycashPaymentDetail.getErrors());
//out.println("<br>"+listPettycashPaymentDetail);

session.putValue("PPPAYMENT_DETAIL", listPettycashPaymentDetail);

//String wherex = "(account_group='"+I_Project.ACC_GROUP_EXPENSE+"' or account_group='"+I_Project.ACC_GROUP_COST_OF_SALES+"'"+
//				" or account_group='"+I_Project.ACC_GROUP_OTHER_EXPENSE+"') and  "+
//				" ((location_id="+sysLocation.getOID()+" or location_id=0))";// and ("+DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]+"<>0))";// or status='HEADER')"+				
				//" and (coa_id not in (select coa_id from acc_link)))";			
//only view postable account in combo				
//if(isPostableOnly){
//	wherex = wherex + " and status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'";
//}
//out.println(wherex);								
//Vector incomeCoas = DbCoa.list(0,0, wherex, "code");

Vector incomeCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_PETTY_CASH, sysLocation.getOID());


Vector currencies = DbCurrency.list(0,0,"", "");

//Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_PETTY_CASH_CREDIT+"' and location_id="+sysCompany.getSystemLocation(), "");
Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_PETTY_CASH_CREDIT+"'", "");
									  
ExchangeRate eRate = DbExchangeRate.getStandardRate();

Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

//out.println("accountBalance : "+accountBalance);

double balance = 0;
double totalDetail = getTotalDetail(listPettycashPaymentDetail);

pettycashPayment.setAmount(totalDetail);

//if(((iJSPCommand==JSPCommand.SUBMIT && recIdx==-1) || iJSPCommand==JSPCommand.DELETE) && iErrCode==0 && iErrCodeMain==0){
if(((iJSPCommand==JSPCommand.SUBMIT && recIdx==-1)) && iErrCode==0 && iErrCodeMain==0){
	iJSPCommand = JSPCommand.ADD;
	pettycashPaymentDetail = new PettycashPaymentDetail();
	recIdx = -1;
}


String whereDep = "";
//if(isPostableOnly){
//	whereDep = "level="+sysCompany.getDepartmentLevel();
//}
Vector deps = DbDepartment.list(0,0, whereDep, "code");


%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
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

function cmdDepartment(){
	var oid = document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_DEPARTMENT_ID]%>.value;
	<%if(deps!=null && deps.size()>0){
		for(int i=0; i<deps.size(); i++){
			Department d = (Department)deps.get(i);
	%>
			if(oid=='<%=d.getOID()%>'){
				<%if(d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
					Department d0 = (Department)deps.get(0);
				%>
					alert("Non postable department\nplease select another department");
					document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
				<%}%>
			}
	<%}}%>
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptPCPaymentPDF?oid=<%=appSessUser.getLoginId()%>&pcPayment_id=<%=pettycashPayment.getOID()%>");
}

function cmdClickIt(){
	document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.select();
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
			if(<%=DbCoa.getCoaBalance(c.getOID())%><0)
			{
				document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber((DbCoa.getCoaBalance(c.getOID())<0) ? DbCoa.getCoaBalance(c.getOID())*-1 : DbCoa.getCoaBalance(c.getOID()),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
			}else
			{
				document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber((DbCoa.getCoaBalance(c.getOID())<0) ? DbCoa.getCoaBalance(c.getOID())*-1 : DbCoa.getCoaBalance(c.getOID()),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
			}
			
			document.frmpettycashpaymentdetail.pcash_balance.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
			<%if(c.getOpeningBalance()<1 && iJSPCommand!=JSPCommand.SAVE){%>
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
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();	
}

function cmdNewJournal(){		
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
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
	
	var st = document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("result : "+result);
	
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(currTotal) + parseFloat(result);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
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
			alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
			//result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));			
			result = parseFloat(editAmount);			
			amount = limit;
		}
		
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		
		document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	
	document.frmpettycashpaymentdetail.<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
}

function cmdSubmitCommand(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SAVE%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdActivity(oid){
	<%if(oidPettycashPayment!=0){%>
		document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value=oid;
		document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NONE%>";
		document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
		document.frmpettycashpaymentdetail.action="pettycashpaymentactivity.jsp";
		document.frmpettycashpaymentdetail.submit();
	<%}else{%>
		alert('Please finish and post this journal before continue to activity data.');
	<%}%>
	
}

//===============================================================================================

function cmdAdd(){
	document.frmpettycashpaymentdetail.select_idx.value="-1";
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_id.value="0";
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value="0";
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdAsk(idx){
	document.frmpettycashpaymentdetail.select_idx.value=idx;
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.ASK%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdConfirmDelete(oidPettycashPaymentDetail){
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.DELETE%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdSave(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdEdit(idxx){
	document.frmpettycashpaymentdetail.select_idx.value=idxx;
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=0;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdCancel(oidPettycashPaymentDetail){
	document.frmpettycashpaymentdetail.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdBack(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.BACK%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListFirst(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListPrev(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListNext(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

function cmdListLast(){
	document.frmpettycashpaymentdetail.command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashpaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashpaymentdetail.action="pettycashpaymentdetail.jsp";
	document.frmpettycashpaymentdetail.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidPettycashPaymentDetail){
	document.frmimage.hidden_pettycash_payment_detail_id.value=oidPettycashPaymentDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="pettycashpaymentdetail.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Petty Cash</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Payment</span></font>";
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
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_pettycash_payment_detail_id" value="<%=oidPettycashPaymentDetail%>">
                          <input type="hidden" name="hidden_pettycash_payment_id" value="<%=oidPettycashPayment%>">
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
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_OPERATOR_ID) %>&nbsp;&nbsp;</div>
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
                                                <td width="10%" nowrap>Payment 
                                                  from Account</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <select name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_COA_ID]%>" onChange="javascript:cmdGetBalance()">
                                                    <%if(accLinks!=null && accLinks.size()>0){
														  for(int i=0; i<accLinks.size(); i++){
																AccLink accLink = (AccLink)accLinks.get(i);
																Coa coa = new Coa();
																try{
																	coa = DbCoa.fetchExc(accLink.getCoaId());
																}
																catch(Exception e){
																}
														  %>
                                                    <option <%if(pettycashPayment.getCoaId()==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
													<%=getAccountRecursif(coa, pettycashPayment.getCoaId(), isPostableOnly)%>
                                                    <%}}else{%>
                                                    <option>select ..</option>
                                                    <%}%>
                                                  </select>
                                                  <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_COA_ID) %> </td>
                                                <td width="13%" nowrap><b>Account 
                                                  Balance <%=baseCurrency.getCurrencyCode()%></b></td>
                                                <td width="38%"> 
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_ACCOUNT_BALANCE]%>" readOnly style="text-align:right">
                                                  <b><a id="tot_saldo_akhir"></a></b> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Amount <%=baseCurrency.getCurrencyCode()%></td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <input type="text" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()" class="readonly" readOnly>
                                                  <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_AMOUNT) %> </td>
                                                <td width="13%">Journal Number</td>
                                                <td width="38%"> 
                                                  <%
									  int counter = DbPettycashPayment.getNextCounter();
									  String strNumber = DbPettycashPayment.getNextNumber(counter);
									  
									  if(pettycashPayment.getOID()!=0){
											strNumber = pettycashPayment.getJournalNumber();
									  }
									  
									  %>
                                                  <%=strNumber%> 
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_NUMBER]%>">
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_COUNTER]%>">
                                                  <input type="hidden" name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_JOURNAL_PREFIX]%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="16">Memo</td>
                                                <td width="2%" height="16">&nbsp;</td>
                                                <td rowspan="2" width="37%" valign="top"> 
                                                  <textarea name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_MEMO]%>" cols="50" rows="3"><%=pettycashPayment.getMemo()%></textarea>
                                                  <%= (jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO).length()>0) ? "<br>"+jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_MEMO) : "" %> </td>
                                                <td width="13%" height="16">Transaction 
                                                  Date</td>
                                                <td width="38%" height="16"> 
                                                  <input name="<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((pettycashPayment.getTransDate()==null) ? new Date() : pettycashPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpettycashpaymentdetail.<%=jspPettycashPayment.colNames[jspPettycashPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%= jspPettycashPayment.getErrorMsg(jspPettycashPayment.JSP_TRANS_DATE) %> </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="13%">&nbsp;</td>
                                                <td width="38%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="5" valign="top"> 
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
                                                            <%if(applyActivity){%>
                                                            <td class="tabin"> 
                                                              <%if(true){%>
                                                              <a href="javascript:cmdActivity('<%=oidPettycashPayment%>')" class="tablink">Activity</a> 
                                                              <%}else{%>
                                                              <a href="#" class="tablink" title="petty cash payment required">Activity</a> 
                                                              <%}%>
                                                            </td>
                                                            <%}%>
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
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <tr> 
                                                                  <td  class="tablehdr" width="30%" height="20">Account 
                                                                    - Description</td>
                                                                  <td class="tablehdr" width="15%" height="20">Department</td>
                                                                  <td class="tablehdr" width="15%" height="20">Amount 
                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                  <td class="tablehdr" width="55%" height="20">Description</td>
                                                                </tr>
                                                                <%if(listPettycashPaymentDetail!=null && listPettycashPaymentDetail.size()>0){
													for(int i=0; i<listPettycashPaymentDetail.size(); i++){
														PettycashPaymentDetail crd = (PettycashPaymentDetail)listPettycashPaymentDetail.get(i);
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
                                                                  <td class="tablecell" width="30%"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>">
                                                                        <%if(incomeCoas!=null && incomeCoas.size()>0){
														for(int x=0; x<incomeCoas.size(); x++){
															Coa coax = (Coa)incomeCoas.get(x);
															
															String str = "";
															/*if(!isPostableOnly){
																switch(coax.getLevel()){
																	case 1 : 											
																		break;
																	case 2 : 
																		str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																		break;
																	case 3 :
																		str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																		break;
																	case 4 :
																		str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																		break;
																	case 5 :
																		str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																		break;				
																}
															}*/												
															%>
                                                                        <option value="<%=coax.getOID()%>" <%if(crd.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
																		<%=getAccountRecursif(coax, crd.getCoaId(), isPostableOnly)%>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_COA_ID) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="15%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment()">
                                                                        <%if(deps!=null && deps.size()>0){
																		for(int x=0; x<deps.size(); x++){
																			Department d = (Department)deps.get(x);
																			
																			String str = "";
																			//if(!isPostableOnly){
																				switch(d.getLevel()){
																					case 0 : 											
																						break;
																					case 1 : 
																						str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																						break;
																					case 2 :
																						str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																						break;
																					case 3 :
																						str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																						break;
																								
																				}
																			//}
																			%>
                                                                        <option value="<%=d.getOID()%>" <%if(crd.getDepartmentId()==d.getOID()){%>selected<%}%>><%=str+d.getCode()+" - "+d.getName()%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_DEPARTMENT_ID) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="15%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                      <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
                                                                      <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="55%" class="tablecell"> 
                                                                    <div align="left">
                                                                      <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_MEMO]%>" size="30" value="<%=crd.getMemo()%>">
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                <%}else{%>
                                                                <tr> 
                                                                  <td class="<%=cssString%>" width="30%"> 
                                                                    <%if(pettycashPayment.getOID()==0){%>
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%>&nbsp;-&nbsp; 
                                                                    <%=c.getName()%></a> 
                                                                    <%}else{%>
                                                                    <%=c.getCode()%>&nbsp;-&nbsp; 
                                                                    <%=c.getName()%> 
                                                                    <%}%>
                                                                  </td>
                                                                  <td width="15%" class="<%=cssString%>"> 
                                                                    <%
																  Department d = new Department();
																  try{
																  	d = DbDepartment.fetchExc(crd.getDepartmentId());
																  }
																  catch(Exception e){
																  }
																  
																  %>
                                                                    <%=d.getCode()+" - "+d.getName()%></td>
                                                                  <td width="15%" class="<%=cssString%>"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                  </td>
                                                                  <td width="55%" class="<%=cssString%>"><%=crd.getMemo()%></td>
                                                                </tr>
                                                                <%}%>
                                                                <%}}%>
                                                                <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && recIdx==-1 ){%>
                                                                <tr> 
                                                                  <td class="tablecell" width="30%"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_COA_ID]%>">
                                                                        <%if(incomeCoas!=null && incomeCoas.size()>0){
											for(int x=0; x<incomeCoas.size(); x++){
												Coa coax = (Coa)incomeCoas.get(x);
												
												String str = "";
												/*if(!isPostableOnly){
													switch(coax.getLevel()){
														case 1 : 											
															break;
														case 2 : 
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 3 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 4 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;
														case 5 :
															str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
															break;				
													}
												}*/
												%>
                                                                        <option value="<%=coax.getOID()%>" <%if(pettycashPaymentDetail.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
																		<%=getAccountRecursif(coax, pettycashPaymentDetail.getCoaId(), isPostableOnly)%>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_COA_ID) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="15%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment()">
                                                                        <%if(deps!=null && deps.size()>0){
																		for(int x=0; x<deps.size(); x++){
																			Department d = (Department)deps.get(x);
																			
																			String str = "";
																			//if(!isPostableOnly){
																				switch(d.getLevel()){
																					case 0 : 											
																						break;
																					case 1 : 
																						str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																						break;
																					case 2 :
																						str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																						break;
																					case 3 :
																						str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
																						break;
																								
																				}
																			//}
																			%>
                                                                        <option value="<%=d.getOID()%>" <%if(pettycashPaymentDetail.getDepartmentId()==d.getOID()){%>selected<%}%>><%=str+d.getCode()+" - "+d.getName()%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_DEPARTMENT_ID) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="15%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(pettycashPaymentDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()">
                                                                      <%= jspPettycashPaymentDetail.getErrorMsg(jspPettycashPaymentDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="55%" class="tablecell"> 
                                                                    <div align="left">
                                                                      <input type="text" name="<%=jspPettycashPaymentDetail.colNames[jspPettycashPaymentDetail.JSP_MEMO]%>" size="30" value="<%=pettycashPaymentDetail.getMemo()%>">
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
                                                      <td width="78%">&nbsp;</td>
                                                      <td width="22%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="78%"> 
                                                        <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                          <%if(iErrCodeMain==0 || iErrCode!=0 || listPettycashPaymentDetail==null || listPettycashPaymentDetail.size()==0){%>
                                                          <tr> 
                                                            <td> 
                                                              <%
										  
												if(pettycashPayment.getOID()==0){
															  
												  if((iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ASK && iErrCode==0 && iErrCodeMain==0)){
													
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
												String scomDel = "javascript:cmdAsk('"+oidPettycashPaymentDetail+"')";
												String sconDelCom = "javascript:cmdConfirmDelete('"+oidPettycashPaymentDetail+"')";
												String scancel = "javascript:cmdEdit('"+oidPettycashPaymentDetail+"')";
												if(listPettycashPaymentDetail!=null && listPettycashPaymentDetail.size()>0){
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
												
												//if(iErrCode==0 && iErrCodeMain!=0){
													//ctrLine.setSaveJSPCommand("javascript:cmdFixing()");
												//}
			
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
												//if(iErrCode==0 && iErrCodeMain!=0){
												//	iErrCode = iErrCodeMain;
												////	msgString = msgStringMain;
												//}
												//===========================================================
												
												%>
                                                              <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                              <%}}%>
                                                            </td>
                                                          </tr>
                                                          <%}else{%>
                                                          <tr> 
                                                            <td> 
                                                              <table border="0" cellpadding="2" cellspacing="0"width="293" align="left">
                                                                <tr> 
                                                                  <td width="20" class="warning" ><img src="../images/error.gif" width="18" height="18"></td>
                                                                  <td width="253"  class="warning"  nowrap><%=msgStringMain%></td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td height="5"></td>
                                                          </tr>
                                                          <tr> 
                                                            <td> 
                                                              <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                  <td width="63%"><a href="javascript:cmdFixing()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="savedoc21" height="22" border="0" width="115"></a></td>
                                                                  <td width="37%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new111','','../images/close2.gif',1)"><img src="../images/close.gif" name="new111"  border="0"></a></td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <%}%>
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
                                              <%if(pettycashPayment.getAmount()!=0 && iErrCode==0 && iErrCodeMain==0 && balance==0 && pettycashPayment.getOID()==0){%>
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
                                                      <td width="68%">&nbsp;</td>
                                                      <td width="24%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                          <table border="0" cellpadding="5" cellspacing="0" class="info" width="214" align="right">
                                                            <tr> 
                                                              <td width="8"><img src="../images/inform.gif" width="20" height="20"></td>
                                                              <td width="176" nowrap>Journal 
                                                                is ready to be 
                                                                posted</td>
                                                            </tr>
                                                          </table>
                                                        </div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <%if(pettycashPayment.getOID()!=0){%>
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
                                                      <td width="9%"><a href="<%=approot%>/transaction/pettycashpaymentdetail.jsp?menu_idx=1" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/new2.gif',1)"><img src="../images/new.gif" name="new1" width="71" height="22" border="0"></a></td>
                                                      <td width="49%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                      <td width="36%"> 
                                                        <div align="right" class="msgnextaction"> 
                                                          <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                            <tr> 
                                                              <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                              <td width="220">Journal 
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
                                                      <td> 
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
                                                      <td> 
                                                        <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right">
                                                          <tr> 
                                                            <td width="2"><img src="../images/error.gif" width="20" height="20"></td>
                                                            <td width="320" nowrap>Not 
                                                              enought petty cash 
                                                              balance to do any 
                                                              transaction</td>
                                                          </tr>
                                                        </table>
                                                      </td>
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
						
							cmdGetBalance();

						</script>
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
