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
boolean bankPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO);
%>
<!-- Jsp Block -->
<%!

	
	
	
	public Vector addNewDetail(Vector listBanknonpoPaymentDetail, BanknonpoPaymentDetail banknonpoPaymentDetail){
		boolean found = false;
		if(listBanknonpoPaymentDetail!=null && listBanknonpoPaymentDetail.size()>0){
			for(int i=0; i<listBanknonpoPaymentDetail.size(); i++){
				BanknonpoPaymentDetail cr = (BanknonpoPaymentDetail)listBanknonpoPaymentDetail.get(i);
				if(cr.getForeignCurrencyId()==banknonpoPaymentDetail.getForeignCurrencyId() && cr.getCoaId()==banknonpoPaymentDetail.getCoaId() && cr.getDepartmentId()==banknonpoPaymentDetail.getDepartmentId()){
				
					System.out.println("\nis accummulated ... \n");
					
					//jika coa sama dan currency sama lakukan penggabungan					
					cr.setForeignAmount(cr.getForeignAmount() + banknonpoPaymentDetail.getForeignAmount() );
					cr.setAmount(cr.getAmount()+banknonpoPaymentDetail.getAmount());
					
					System.out.println("\ncr.setAmount : "+cr.getAmount()+" \n");
					
					listBanknonpoPaymentDetail.set(i, cr);
					
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
//out.println(iJSPCommand);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidBanknonpoPayment = JSPRequestValue.requestLong(request, "hidden_banknonpo_payment_id");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");
long xxx = JSPRequestValue.requestLong(request, "xxx");

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	//if(session.getValue("BNOPPAYMENT_DETAIL")!=null){
		session.removeValue("BNOPPAYMENT_DETAIL");
	//}
	oidBanknonpoPayment = 0;
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

CmdBanknonpoPayment ctrlBanknonpoPayment = new CmdBanknonpoPayment(request);
JSPLine ctrLine = new JSPLine();
Vector listBanknonpoPayment = new Vector(1,1);

/*switch statement */
int iErrCodeMain = ctrlBanknonpoPayment.action(iJSPCommand , oidBanknonpoPayment);
/* end switch*/
JspBanknonpoPayment jspBanknonpoPayment = ctrlBanknonpoPayment.getForm();

/*count list All BanknonpoPayment*/
int vectSize = DbBanknonpoPayment.getCount(whereClause);

BanknonpoPayment banknonpoPayment = ctrlBanknonpoPayment.getBanknonpoPayment();
String msgStringMain =  ctrlBanknonpoPayment.getMessage();

System.out.println("\n -- start detail session ---\n");

if(oidBanknonpoPayment==0){
	oidBanknonpoPayment = banknonpoPayment.getOID();
}

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
long oidBanknonpoPaymentDetail = JSPRequestValue.requestLong(request, "hidden_banknonpo_payment_detail_id");

/*variable declaration*/
//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdBanknonpoPaymentDetail ctrlBanknonpoPaymentDetail = new CmdBanknonpoPaymentDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listBanknonpoPaymentDetail = new Vector(1,1);

/*switch statement */
iErrCode = ctrlBanknonpoPaymentDetail.action(iJSPCommand , oidBanknonpoPaymentDetail);
/* end switch*/
JspBanknonpoPaymentDetail jspBanknonpoPaymentDetail = ctrlBanknonpoPaymentDetail.getForm();

BanknonpoPaymentDetail banknonpoPaymentDetail = ctrlBanknonpoPaymentDetail.getBanknonpoPaymentDetail();
msgString =  ctrlBanknonpoPaymentDetail.getMessage();

/* get record to display */
//listBanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
/*if (listBanknonpoPaymentDetail.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listBanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(start,recordToGet, whereClause , orderClause);
}
*/

if(session.getValue("BNOPPAYMENT_DETAIL")!=null){
	listBanknonpoPaymentDetail = (Vector)session.getValue("BNOPPAYMENT_DETAIL");
}

if(iJSPCommand==JSPCommand.SUBMIT){// || iJSPCommand==JSPCommand.POST){
	if(iErrCode==0){
		if(recIdx==-1){		
			listBanknonpoPaymentDetail.add(banknonpoPaymentDetail);// = addNewDetail(listBanknonpoPaymentDetail, banknonpoPaymentDetail);
			//listBanknonpoPaymentDetail.add(banknonpoPaymentDetail);
		}
		else{
			//listBanknonpoPaymentDetail.set(recIdx, banknonpoPaymentDetail);
			//listBanknonpoPaymentDetail.remove(recIdx);
			//listBanknonpoPaymentDetail = addNewDetail(listBanknonpoPaymentDetail, banknonpoPaymentDetail);
			listBanknonpoPaymentDetail.set(recIdx, banknonpoPaymentDetail);
		}
	}
}
if(iJSPCommand==JSPCommand.DELETE){
	listBanknonpoPaymentDetail.remove(recIdx);
}

if(iJSPCommand==JSPCommand.SAVE){
	if(banknonpoPayment.getOID()!=0){
		DbBanknonpoPaymentDetail.saveAllDetail(banknonpoPayment, listBanknonpoPaymentDetail);
		listBanknonpoPaymentDetail = DbBanknonpoPaymentDetail.list(0,0, "banknonpo_payment_id="+banknonpoPayment.getOID(), "");
		
		//posting journal
		DbBanknonpoPayment.postJournal(banknonpoPayment, listBanknonpoPaymentDetail);
	}
}

//out.println("jspBanknonpoPaymentDetail : "+jspBanknonpoPaymentDetail.getErrors());
//out.println("<br>"+listBanknonpoPaymentDetail);

session.putValue("BNOPPAYMENT_DETAIL", listBanknonpoPaymentDetail);

//String wherex = "(account_group='"+I_Project.ACC_GROUP_EXPENSE+"' or account_group='"+I_Project.ACC_GROUP_OTHER_EXPENSE+"') and  "+
//				"(location_id="+sysLocation.getOID()+" or location_id=0)";
				//" and "+DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]+"<>0";
//				" ((location_id="+sysLocation.getOID()+" or location_id=0) and ("+DbCoa.colNames[DbCoa.COL_COA_CATEGORY_ID]+"<>0 or status='HEADER')"+				
//				" and (coa_id not in (select coa_id from acc_link)))";								
//only view postable account in combo				
//if(isPostableOnly){
//	wherex = wherex + " and status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'";
//}
//Vector expenseCoas = DbCoa.list(0,0, wherex, "code");					

Vector expenseCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_BANK_NOPO_PAYMENT_DEBET, sysLocation.getOID());

Vector empAdvance = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_EMPLOYEE_ADVANCE+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");

Vector currencies = DbCurrency.list(0,0,"", "");

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_BANK_NOPO_PAYMENT_CREDIT+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");
									  
ExchangeRate eRate = DbExchangeRate.getStandardRate();

Vector accountBalance = DbAccLink.getBankAccountBalance(accLinks);

Vector vendors = DbVendor.list(0,0, "", "");

//out.println("accountBalance : "+accountBalance);


double balance = 0;
double totalDetail = getTotalDetail(listBanknonpoPaymentDetail);

banknonpoPayment.setAmount(totalDetail);

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && iErrCodeMain==0 && recIdx==-1){
	iJSPCommand = JSPCommand.ADD;
	banknonpoPaymentDetail = new BanknonpoPaymentDetail();
}

//out.println("banknonpoPayment : "+banknonpoPayment.getVendorId());

if(iJSPCommand==JSPCommand.PRINT){
	banknonpoPayment.setVendorId(xxx);	
	/*if(iErrCode==0 && iErrCodeMain==0){
		iJSPCommand = JSPCommand.ADD;
	}
	else{
		iJSPCommand = JSPCommand.SUBMIT;
	}*/
	iJSPCommand = JSPCommand.ADD;
	recIdx = -1;
	banknonpoPaymentDetail = new BanknonpoPaymentDetail();
}


String whereDep = "";
//if(isPostableOnly){
//	whereDep = "level="+sysCompany.getDepartmentLevel();
//}
Vector deps = DbDepartment.list(0,0, whereDep, "code");

//out.println("recIdx : "+recIdx);


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

//=======================================update===========================================================

function cmdDepartment(){
	var oid = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID]%>.value;
	<%if(deps!=null && deps.size()>0){
		for(int i=0; i<deps.size(); i++){
			Department d = (Department)deps.get(i);
	%>
			if(oid=='<%=d.getOID()%>'){
				<%if(d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
					Department d0 = (Department)deps.get(0);
				%>
					alert("Non postable department\nplease select another department");
					document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
				<%}%>
			}
	<%}}%>
}

function cmdTypeChange(){
	var type = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_TYPE]%>.value;
	//alert (type);

	if(type=="0"){
		document.all.noActivity.style.display="none";
		document.all.withActivity.style.display="";
		<%if(iJSPCommand==JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iErrCode!=0){%>			
			document.all.noActivity1.style.display="none";
			document.all.withActivity1.style.display="";
		<%}%>
		document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>.value=0;
	}else if(type=="1"){
		document.all.noActivity.style.display="";			
		document.all.withActivity.style.display="none";		
		<%if(iJSPCommand==JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iErrCode!=0){%>			
			document.all.noActivity1.style.display="";
			document.all.withActivity1.style.display="none";	
		<%}%>			
		document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>.value=1;
	}	
	
}

function cmdActivity(oid){
	<%if(oidBanknonpoPayment!=0){%>
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_id.value=oid;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.NONE%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpoactivity.jsp";
	document.frmbanknonpopaymentdetail.submit();
	<%}else{%>
		alert('Please finish and post this journal before continue to activity data.');
	<%}%>
	
}


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
	<%if(vendors!=null && vendors.size()>0){
		for(int i=0; i<vendors.size(); i++){
			Vendor vx = (Vendor)vendors.get(i);
			%>
			if('<%=vx.getOID()%>'==oid){
				found = true;
				document.frmbanknonpopaymentdetail.vnd_address.value="<%=vx.getAddress()+((vx.getCity().length()>0) ? ", "+ vx.getCity() : "") +((vx.getState().length()>0) ? ", "+ vx.getState() : "") %>";
			}
	<%}}%>		
	if(!found){
		document.frmbanknonpopaymentdetail.vnd_address.value="";
	}
}

function cmdClickIt(){
	document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.select();
}

function cmdGetBalance(){
	
	var x = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_COA_ID]%>.value;
	//alert(x);
	<%if(accountBalance!=null && accountBalance.size()>0){
		for(int i=0; i<accountBalance.size(); i++){
			Coa c = (Coa)accountBalance.get(i);
			//c.setOpeningBalance(c.getOpeningBalance()+banknonpoPayment.getAmount());
	%>
		if(x=='<%=c.getOID()%>'){
			document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
			
			//alert('<%=c.getOpeningBalance()%>');
			//if(<%=DbCoa.getCoaBalance(c.getOID())%><0)
			//{
			//	document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber((DbCoa.getCoaBalance(c.getOID())<0) ? DbCoa.getCoaBalance(c.getOID())*-1 : DbCoa.getCoaBalance(c.getOID()),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
			//}else
			//{
			//	document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber((DbCoa.getCoaBalance(c.getOID())<0) ? DbCoa.getCoaBalance(c.getOID())*-1 : DbCoa.getCoaBalance(c.getOID()),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
			//}
			
			<%if(c.getOpeningBalance()<0){%>
				document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance()*-1,"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
			<%}else{%>
				document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
			<%}%>

			document.frmbanknonpopaymentdetail.pcash_balance.value="<%=JSPFormater.formatNumber(c.getOpeningBalance(),"###.##")%>";
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
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.POST%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();	
}

function cmdNewJournal(){	
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.NONE%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
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
	var bnpAmount = "<%=banknonpoPayment.getAmount()%>";
	bnpAmount = removeChar(bnpAmount);	
	bnpAmount = cleanNumberFloat(bnpAmount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var limit = parseFloat(maxtransaction) ;//- parseFloat(bnpAmount);
	//if(limit > parseFloat(pbalanace)){
	//	limit = parseFloat(pbalanace);
	//}		
	
	var st = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert("result : "+result);
	
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(currTotal) + parseFloat(result);
		
		//alert("1. amount : "+amount);
		//alert("1. limit : "+limit);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
			//result = parseFloat(main)-parseFloat(currTotal);			
			result = 0;//parseFloat(limit)-parseFloat(currTotal);
			amount = 0;//limit - parseFloat(bnpAmount);
			
			document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 				
		}
		
		document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	//edit
	else{
		var editAmount =  document.frmbanknonpopaymentdetail.edit_amount.value;
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		
		if(amount>limit){//parseFloat(main)){
			alert("Maximum transaction limit is "+formatFloat(limit, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+", \nsystem will reset the data");
			//result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));			
			result = 0;//parseFloat(limit)-(parseFloat(currTotal)-parseFloat(editAmount));			
			amount = 0;//result;//limit - parseFloat(bnpAmount);
			
			//alert("limit : "+limit+", bnpAmount : "+bnpAmount+", amount : "+amount+", result : "+result);
			
			document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 				
		}
		
		document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>.value = formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
		
	}
	
	document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
}

function cmdUpdateExchange(){
	var idCurr = document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
	
	<%if(currencies!=null && currencies.size()>0){
		for(int i=0; i<currencies.size(); i++){
			Currency cx = (Currency)currencies.get(i);
	%>
			if(idCurr=='<%=cx.getOID()%>'){
				<%if(cx.getCurrencyCode().equals(IDRCODE)){%>
					document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
				<%}
				else if(cx.getCurrencyCode().equals(USDCODE)){%>
					document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueUsd()%>";
				<%}
				else if(cx.getCurrencyCode().equals(EURCODE)){%>
					document.frmbanknonpopaymentdetail.<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueEuro()%>";
				<%}%>
			}	
	<%}}%>
	
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
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

//===============================================================================================

function cmdAdd(){
	document.frmbanknonpopaymentdetail.select_idx.value="-1";
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_id.value="0";
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value="0";
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdAsk(idx){
	document.frmbanknonpopaymentdetail.select_idx.value=idx;
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=0;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.ASK%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdConfirmDelete(oidBanknonpoPaymentDetail){
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.DELETE%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdSave(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdEdit(idxx){
	document.frmbanknonpopaymentdetail.select_idx.value=idxx;
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=0;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdCancel(oidBanknonpoPaymentDetail){
	document.frmbanknonpopaymentdetail.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdBack(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.BACK%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdListFirst(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.FIRST%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdListPrev(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.PREV%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdListNext(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.NEXT%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

function cmdListLast(){
	document.frmbanknonpopaymentdetail.command.value="<%=JSPCommand.LAST%>";
	document.frmbanknonpopaymentdetail.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmbanknonpopaymentdetail.action="banknonpopaymentdetail.jsp";
	document.frmbanknonpopaymentdetail.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidBanknonpoPaymentDetail){
	document.frmimage.hidden_banknonpo_payment_detail_id.value=oidBanknonpoPaymentDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="banknonpopaymentdetail.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/add2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Bank</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Non PO Payment</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbanknonpopaymentdetail" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_banknonpo_payment_detail_id" value="<%=oidBanknonpoPaymentDetail%>">
                          <input type="hidden" name="hidden_banknonpo_payment_id" value="<%=oidBanknonpoPayment%>">
                          <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="max_pcash_transaction" value="<%=sysCompany.getMaxPettycashTransaction()%>">
                          <input type="hidden" name="pcash_balance" value="">
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
                                                  <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_OPERATOR_ID) %>&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="1">
                                              <tr> 
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="34%">&nbsp;</td>
                                                <td width="12%" nowrap>&nbsp;</td>
                                                <td width="39%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap><a href="javascript:cmdEditVendor()">Vendor</a></td>
                                                <td width="34%"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="18%"> 
                                                        <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_VENDOR_ID]%>" onChange="javascript:cmdVendor()">
                                                          <option value="0">- 
                                                          Select -</option>
                                                          <%if(vendors!=null && vendors.size()>0){
											  		for(int i=0; i<vendors.size(); i++){
														Vendor vx = (Vendor)vendors.get(i);
											  %>
                                                          <option value="<%=vx.getOID()%>" <%if(vx.getOID()==banknonpoPayment.getVendorId()){%>selected<%}%>><%=vx.getCode()%> - <%=vx.getName()%></option>
                                                          <%}}%>
                                                        </select>
                                                        <%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_VENDOR_ID) %></td>
                                                      <td width="2%"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                      <td width="14%"><a href="javascript:cmdNewVendor()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new12','','../images/add2.gif',1)"><img src="../images/add.gif" name="new12" width="49" height="22" border="0"></a></td>
                                                      <td width="66%"> 
                                                        <input type="hidden" name="xxx" value="<%=xxx%>">
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                                <td width="12%" nowrap>&nbsp;</td>
                                                <td width="39%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td colspan="3"><b><i> 
                                                  <textarea name="vnd_address" cols="50" rows="2" class="readonly" readOnly>Vendor address ..</textarea>
                                                  </i></b></td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>&nbsp;</td>
                                                <td width="34%">&nbsp;</td>
                                                <td width="12%" nowrap>&nbsp;</td>
                                                <td width="39%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>Type</td>
                                                <td colspan="3"> 
                                                  <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_TYPE]%>" onChange="javascript:cmdTypeChange()">
                                                    <%	
															for(int i=0; i<I_Project.nonpoTypeGroup.length; i++)
															{
													  %>
                                                    <option value="<%=i%>" <%if(i==banknonpoPayment.getType()) {%>selected<%}%>><%=I_Project.nonpoTypeGroup[i]%></option>
                                                    <%
															}									
													  %>
                                                  </select>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" nowrap>Payment 
                                                  from Account</td>
                                                <td width="34%"> <b> 
                                                  <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_COA_ID]%>" onChange="javascript:cmdGetBalance()">
                                                    <%if(accLinks!=null && accLinks.size()>0){
										  		for(int i=0; i<accLinks.size(); i++){
													AccLink acl = (AccLink)accLinks.get(i);
													Coa coay = new Coa();
													try{
														coay = DbCoa.fetchExc(acl.getCoaId());
													}
													catch(Exception e){
													}
													
													if(banknonpoPayment.getCoaId()==0 && i==0){
														banknonpoPayment.setCoaId(acl.getCoaId());
													}
													
										  %>
                                                    <option value="<%=acl.getCoaId()%>" <%if(acl.getCoaId()==banknonpoPayment.getCoaId()){%>selected<%}%>><%=coay.getCode()+ " - "+coay.getName()%></option>
                                                    <%=getAccountRecursif(coay, banknonpoPayment.getCoaId(), isPostableOnly)%> 
                                                    <%}}%>
                                                  </select>
                                                  <%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_COA_ID) %></b></td>
                                                <td width="12%" nowrap><b> Balance 
                                                  <%=baseCurrency.getCurrencyCode()%></b></td>
                                                <td width="39%"> 
                                                  <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_ACCOUNT_BALANCE]%>" readOnly style="text-align:right">
                                                  <b><a id="tot_saldo_akhir"></a></b> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Payment Method</td>
                                                <td width="34%"> 
                                                  <%
										Vector vpm = DbPaymentMethod.list(0,0, "", "");
										%>
                                                  <select name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_PAYMENT_METHOD_ID]%>">
                                                    <%if(vpm!=null && vpm.size()>0){
										  		for(int i=0; i<vpm.size(); i++){
													PaymentMethod pm = (PaymentMethod)vpm.get(i);
										  %>
                                                    <option value="<%=pm.getOID()%>" <%if(pm.getOID()==banknonpoPayment.getPaymentMethodId()){%>selected<%}%>><%=pm.getDescription()%></option>
                                                    <%}}%>
                                                  </select>
                                                </td>
                                                <td width="12%">Journal Number</td>
                                                <td width="39%"> 
                                                  <%
									  int counter = DbBanknonpoPayment.getNextCounter(banknonpoPayment.getCoaId());
									  String strNumber = DbBanknonpoPayment.getNextNumber(counter, banknonpoPayment.getCoaId());
									  
									  if(banknonpoPayment.getOID()!=0){
											strNumber = banknonpoPayment.getJournalNumber();
									  }
									  
									  %>
                                                  <%=strNumber%> 
                                                  <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_JOURNAL_NUMBER]%>">
                                                  <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_JOURNAL_COUNTER]%>">
                                                  <input type="hidden" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_JOURNAL_PREFIX]%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Bank Reference 
                                                  Number</td>
                                                <td width="34%"> 
                                                  <input type="text" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_REF_NUMBER]%>" value="<%=banknonpoPayment.getRefNumber()%>" size="25">
                                                  <%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_REF_NUMBER) %> </td>
                                                <td width="12%">Transaction Date</td>
                                                <td width="39%"> 
                                                  <input name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((banknonpoPayment.getTransDate()==null) ? new Date() : banknonpoPayment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbanknonpopaymentdetail.<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_TRANS_DATE) %> </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%" height="16">Amount 
                                                  <%=baseCurrency.getCurrencyCode()%></td>
                                                <td height="8" width="34%"> 
                                                  <input type="text" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(banknonpoPayment.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()"   class="readonly" readOnly size="25">
                                                  <%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_AMOUNT) %> </td>
                                                <td width="12%" height="16">Invoice 
                                                  Number </td>
                                                <td width="39%" height="16"> 
                                                  <input type="text" name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_INVOICE_NUMBER]%>" value="<%=banknonpoPayment.getInvoiceNumber()%>" size="25">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Memo</td>
                                                <td height="8" colspan="3"> 
                                                  <textarea name="<%=jspBanknonpoPayment.colNames[jspBanknonpoPayment.JSP_MEMO]%>" cols="50" rows="2"><%=banknonpoPayment.getMemo()%></textarea>
                                                  <%= jspBanknonpoPayment.getErrorMsg(jspBanknonpoPayment.JSP_MEMO) %> </td>
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
                                                          <tr id="withActivity"> 
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                            <td class="tab">Disbursement</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <%
															//out.println("applyActivity : "+applyActivity);
															if(applyActivity){%>
                                                            <td class="tabin"> 
                                                              <%if(true){%>
                                                              <a href="javascript:cmdActivity('<%=oidBanknonpoPayment%>')" class="tablink">Activity</a> 
                                                              <%}else{%>
                                                              <a href="#" class="tablink" title="petty cash payment required">Activity</a> 
                                                              <%}%>
                                                            </td>
                                                            <%}else{%>
                                                            <td class="tabheader">&nbsp; 
                                                            </td>
                                                            <%}%>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                          </tr>
                                                          <tr id="noActivity"> 
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                            <td class="tab">Disbursement</td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tabheader">&nbsp;</td>
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
                                                                <!--DWLayoutTable-->
                                                                <tr> 
                                                                  <td  class="tablehdr" rowspan="2" width="19%">Account 
                                                                    - Description</td>
                                                                  <td class="tablehdr" rowspan="2" width="15%">Department</td>
                                                                  <td class="tablehdr" colspan="2">Currency</td>
                                                                  <td class="tablehdr" rowspan="2" width="9%">Booked 
                                                                    <br>
                                                                    Rate </td>
                                                                  <td class="tablehdr" rowspan="2" width="12%">Amount 
                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                  <td class="tablehdr" rowspan="2" width="28%">Description</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td class="tablehdr" width="6%">Code</td>
                                                                  <td class="tablehdr" width="11%">Amount</td>
                                                                </tr>
                                                                <%if(listBanknonpoPaymentDetail!=null && listBanknonpoPaymentDetail.size()>0){
													for(int i=0; i<listBanknonpoPaymentDetail.size(); i++){
														BanknonpoPaymentDetail crd = (BanknonpoPaymentDetail)listBanknonpoPaymentDetail.get(i);
														System.out.println(crd.getCoaIdTemp());
														System.out.println(crd.getCoaId());
														Coa c = new Coa();
														try{
															if (banknonpoPayment.getType()==0)
															{
																c = DbCoa.fetchExc(crd.getCoaId());
															} else if (banknonpoPayment.getType()==1)
															{
																if (crd.getCoaIdTemp()==0)
																{
																	c = DbCoa.fetchExc(crd.getCoaId());
																}else
																{
																	c = DbCoa.fetchExc(crd.getCoaIdTemp());
																}
															}
														}
														catch(Exception e){
															System.out.println(e);
														}
														
														String cssString = "tablecell";
														if(i%2!=0){
															cssString = "tablecell1";
														}
														
												%>
                                                                <%
									
												if(((iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK) || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0))&& i==recIdx){%>
                                                                <tr> 
                                                                  <td class="tablecell" width="19%" valign="middle"> 
                                                                    <table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                      <tr id="withActivity1"> 
                                                                        <td> 
                                                                          <div align="center"> 
                                                                            <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID]%>">
                                                                              <%if(expenseCoas!=null && expenseCoas.size()>0){
																			for(int x=0; x<expenseCoas.size(); x++){
																				Coa coax = (Coa)expenseCoas.get(x);
																				
																				String str = "";
																				/*switch(coax.getLevel()){
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
																				}*/
																				
																		%>
                                                                              <option value="<%=coax.getOID()%>" <%if(crd.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
                                                                              <%=getAccountRecursif(coax, crd.getCoaId(), isPostableOnly)%> 
                                                                              <%}}%>
                                                                            </select>
                                                                            <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_COA_ID) %> 
                                                                          </div>
                                                                        </td>
                                                                      </tr>
                                                                      <tr id="noActivity1"> 
                                                                        <td> 
                                                                          <div align="center"> 
                                                                            <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TEMP]%>">
                                                                              <%if(empAdvance!=null && empAdvance.size()>0){
																			for(int x=0; x<empAdvance.size(); x++){
																				AccLink acl = (AccLink)empAdvance.get(x);
																				Coa coax = new Coa();
																				try{
																					coax = DbCoa.fetchExc(acl.getCoaId());
																				}
																				catch(Exception e){
																				}
																				
																				String str = "";
																				/*switch(coax.getLevel()){
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
																				}*/
																				
																		%>
                                                                              <option value="<%=coax.getOID()%>" <%if(crd.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
                                                                              <%=getAccountRecursif(coax, crd.getCoaId(), isPostableOnly)%> 
                                                                              <%}}%>
                                                                            </select>
                                                                            <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_COA_ID_TEMP) %> 
                                                                          </div>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                  <td width="15%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="hidden" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>" value="<%=banknonpoPayment.getType()%>">
                                                                      <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment()">
                                                                        <%if(deps!=null && deps.size()>0){
																		for(int x=0; x<deps.size(); x++){
																			Department d = (Department)deps.get(x);
																			
																			String str = "";
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
															
																			%>
                                                                        <option value="<%=d.getOID()%>" <%if(crd.getDepartmentId()==d.getOID()){%>selected<%}%>><%=str+d.getCode()+" - "+d.getName()%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="6%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                                        <%
											if(currencies!=null && currencies.size()>0){
										  		for(int x=0; x<currencies.size(); x++){
													Currency cx = (Currency)currencies.get(x);
										  	%>
                                                                        <option value="<%=cx.getOID()%>" <%if(crd.getForeignCurrencyId()==cx.getOID()){%>selected<%}%>><%=cx.getCurrencyCode()%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                    </div>
                                                                  </td>
                                                                  <td width="11%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:cmdUpdateExchange()" onClick="this.select()">
                                                                    </div>
                                                                  </td>
                                                                  <td width="9%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()"  class="readonly" readOnly>
                                                                    </div>
                                                                  </td>
                                                                  <td width="12%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                                      <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()"  class="readonly" readOnly>
                                                                      <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="28%" class="tablecell"> 
                                                                    <div align="left"> 
                                                                      <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_MEMO]%>" size="20" value="<%=crd.getMemo()%>">
                                                                    </div>
                                                                  </td>
                                                                </tr>
                                                                <%}else{%>
                                                                <tr> 
                                                                  <td class="<%=cssString%>" width="19%" nowrap> 
                                                                    <%if(banknonpoPayment.getOID()==0){%>
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%>&nbsp;-&nbsp; 
                                                                    <%=c.getName()%></a> 
                                                                    <%}else{%>
                                                                    <%=c.getCode()%>&nbsp;-&nbsp; 
                                                                    <%=c.getName()%> 
                                                                    <%}%>
                                                                  </td>
                                                                  <td width="15%" class="<%=cssString%>" nowrap> 
                                                                    <input type="hidden" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>" value="<%=banknonpoPayment.getType()%>">
                                                                    <%
																  Department d = new Department();
																  try{
																  	d = DbDepartment.fetchExc(crd.getDepartmentId());
																  }
																  catch(Exception e){
																  }
																  
																  %>
                                                                    <%=d.getCode()+" - "+d.getName()%></td>
                                                                  <td width="6%" class="<%=cssString%>"> 
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
                                                                  <td width="11%" class="<%=cssString%>"> 
                                                                    <div align="right"> 
                                                                      <%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="9%" class="<%=cssString%>"> 
                                                                    <div align="right"> 
                                                                      <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="12%" class="<%=cssString%>"> 
                                                                    <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                                  </td>
                                                                  <td width="28%" class="<%=cssString%>"><%=crd.getMemo()%></td>
                                                                </tr>
                                                                <%}%>
                                                                <%}}%>
                                                                <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && recIdx==-1){
									  if(listBanknonpoPaymentDetail.size()==1 && banknonpoPayment.getType()==1 && iErrCode==0 && iErrCodeMain==0)
									  {}else{
									%>
                                                                <tr> 
                                                                  <td class="tablecell" width="19%" valign="middle"> 
                                                                    <table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                      <tr id="withActivity1"> 
                                                                        <td> 
                                                                          <div align="center"> 
                                                                            <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID]%>">
                                                                              <%if(expenseCoas!=null && expenseCoas.size()>0){
																			for(int x=0; x<expenseCoas.size(); x++){
																				Coa coax = (Coa)expenseCoas.get(x);
																				
																				String str = "";
																				/*switch(coax.getLevel()){
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
																				}*/
																				
																		%>
                                                                              <option value="<%=coax.getOID()%>" <%if(banknonpoPaymentDetail.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
                                                                              <%=getAccountRecursif(coax, banknonpoPaymentDetail.getCoaId(), isPostableOnly)%> 
                                                                              <%}}%>
                                                                            </select>
                                                                            <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_COA_ID) %> 
                                                                          </div>
                                                                        </td>
                                                                      </tr>
                                                                      <tr id="noActivity1"> 
                                                                        <td> 
                                                                          <div align="center"> 
                                                                            <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TEMP]%>">
                                                                              <%if(empAdvance!=null && empAdvance.size()>0){
																			for(int x=0; x<empAdvance.size(); x++){
																				AccLink acl = (AccLink)empAdvance.get(x);
																				Coa coax = new Coa();
																				try{
																					coax = DbCoa.fetchExc(acl.getCoaId());
																				}
																				catch(Exception e){
																				}
																																								
																				String str = "";
																				/*switch(coax.getLevel()){
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
																				}*/
																				
																		%>
                                                                              <option value="<%=coax.getOID()%>" <%if(banknonpoPaymentDetail.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
                                                                              <%=getAccountRecursif(coax, banknonpoPaymentDetail.getCoaId(), isPostableOnly)%> 
                                                                              <%}}%>
                                                                            </select>
                                                                            <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_COA_ID_TEMP) %> 
                                                                          </div>
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                  <td width="15%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="hidden" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_COA_ID_TYPE]%>" value="<%=banknonpoPayment.getType()%>">
                                                                      <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment()">
                                                                        <%if(deps!=null && deps.size()>0){
																		for(int x=0; x<deps.size(); x++){
																			Department d = (Department)deps.get(x);
																			
																			String str = "";
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
															
																			%>
                                                                        <option value="<%=d.getOID()%>" <%if(banknonpoPaymentDetail.getDepartmentId()==d.getOID()){%>selected<%}%>><%=str+d.getCode()+" - "+d.getName()%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                      <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_DEPARTMENT_ID) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="6%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <select name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                                        <%
											if(currencies!=null && currencies.size()>0){
										  		for(int x=0; x<currencies.size(); x++){
													Currency cx = (Currency)currencies.get(x);
										  	%>
                                                                        <option value="<%=cx.getOID()%>" <%if(banknonpoPaymentDetail.getForeignCurrencyId()==cx.getOID()){%>selected<%}%>><%=cx.getCurrencyCode()%></option>
                                                                        <%}}%>
                                                                      </select>
                                                                    </div>
                                                                  </td>
                                                                  <td width="11%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_FOREIGN_AMOUNT]%>" value="<%=JSPFormater.formatNumber(banknonpoPaymentDetail.getForeignAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:cmdUpdateExchange()" onClick="this.select()">
                                                                    </div>
                                                                  </td>
                                                                  <td width="9%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_BOOKED_RATE]%>" value="<%=JSPFormater.formatNumber(banknonpoPaymentDetail.getBookedRate(), "#,###.##")%>" style="text-align:right" size="5" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()"  class="readonly" readOnly>
                                                                    </div>
                                                                  </td>
                                                                  <td width="12%" class="tablecell"> 
                                                                    <div align="center"> 
                                                                      <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(banknonpoPaymentDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15" onBlur="javascript:checkNumber2()" onClick="javascript:cmdClickIt()"  class="readonly" readOnly>
                                                                      <%= jspBanknonpoPaymentDetail.getErrorMsg(jspBanknonpoPaymentDetail.JSP_AMOUNT) %> 
                                                                    </div>
                                                                  </td>
                                                                  <td width="28%" class="tablecell"> 
                                                                    <div align="left"> 
                                                                      <input type="text" name="<%=jspBanknonpoPaymentDetail.colNames[jspBanknonpoPaymentDetail.JSP_MEMO]%>" size="20" value="<%=banknonpoPaymentDetail.getMemo()%>">
                                                                    </div>
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
                                                      <td width="78%"> 
                                                        <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                          <%if(iErrCodeMain==0 || iErrCode!=0 || listBanknonpoPaymentDetail==null || listBanknonpoPaymentDetail.size()==0){%>
                                                          <tr> 
                                                            <td> 
                                                              <%
										  
												if(banknonpoPayment.getOID()==0){
															  
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
												String scomDel = "javascript:cmdAsk('"+oidBanknonpoPaymentDetail+"')";
												String sconDelCom = "javascript:cmdConfirmDelete('"+oidBanknonpoPaymentDetail+"')";
												String scancel = "javascript:cmdEdit('"+oidBanknonpoPaymentDetail+"')";
												if(listBanknonpoPaymentDetail!=null && listBanknonpoPaymentDetail.size()>0){
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
                                                              <table border="0" cellpadding="2" cellspacing="0" class="warning" width="293" align="left">
                                                                <tr> 
                                                                  <td width="20"><img src="../images/error.gif" width="18" height="18"></td>
                                                                  <td width="253" nowrap><%=msgStringMain%></td>
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
										//out.println("<br>banknonpoPayment.getAmount() : "+banknonpoPayment.getAmount());
										
										balance = banknonpoPayment.getAmount() - totalDetail;
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
                                                <td colspan="4">&nbsp; </td>
                                              </tr>
                                              <%if(banknonpoPayment.getAmount()!=0 && iErrCode==0 && iErrCodeMain==0 && balance==0 && banknonpoPayment.getOID()==0){%>
                                              <tr> 
                                                <td colspan="4"> 
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
                                                <td colspan="4"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                                      <td width="64%">&nbsp;</td>
                                                      <td width="28%"> 
                                                        <table border="0" cellpadding="5" cellspacing="0" class="info" width="213" align="right">
                                                          <tr> 
                                                            <td width="12"><img src="../images/inform.gif" width="20" height="20"></td>
                                                            <td width="181" nowrap>Journal 
                                                              is ready to be posted</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <%if(banknonpoPayment.getOID()!=0){%>
                                              <tr> 
                                                <td colspan="4"> 
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
                                                <td colspan="4"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="3%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                      <td width="3%">&nbsp;</td>
                                                      <td width="9%"><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/new2.gif',1)"><img src="../images/new.gif" name="new1" width="71" height="22" border="0"></a></td>
                                                      <td width="47%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                      <td width="38%"> 
                                                        <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                          <tr> 
                                                            <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                            <td width="220">Journal 
                                                              has been posted 
                                                              successfully</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}%>
                                              <tr id="emptymessage"> 
                                                <td colspan="4"> 
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
                                                        <div align="right" class="msgnextaction"> 
                                                          <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right" width="317">
                                                            <tr> 
                                                              <td width="2"><img src="../images/error.gif" width="20" height="20"></td>
                                                              <td width="320" nowrap>Not 
                                                                enought bank balance 
                                                                to do any transaction</td>
                                                            </tr>
                                                          </table>
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
                          <script language="JavaScript">
				
				cmdGetBalance();
				cmdTypeChange();				
				<%
				out.println("iErrCode : "+iErrCode);					
				if(iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT || iErrCode!=0){%>					
					cmdUpdateExchange();
				<%}%>
				cmdVendor();
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
