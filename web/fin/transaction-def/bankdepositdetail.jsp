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
boolean bankPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT);
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspBankDepositDetail frmObject, BankDepositDetail objEntity, Vector objectClass,  long bankDepositDetailId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tablehdr");
		ctrlist.setCellStyle("tablecell");
		ctrlist.setHeaderStyle("tablehdr");
		ctrlist.addHeader("Cash Receive Id","14%");
		ctrlist.addHeader("Coa Id","14%");
		ctrlist.addHeader("Foreign Currency Id","14%");
		ctrlist.addHeader("Foreign Amount","14%");
		ctrlist.addHeader("Booked Rate","14%");
		ctrlist.addHeader("Amount","14%");
		ctrlist.addHeader("Memo","14%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		Vector rowx = new Vector(1,1);
		ctrlist.reset();
		int index = -1;
		String whereCls = "";
		String orderCls = "";

		/* selected CoaId*/
		Vector coaid_value = new Vector(1,1);
		Vector coaid_key = new Vector(1,1);
		coaid_value.add("");
		coaid_key.add("---select---");

		/* selected ForeignCurrencyId*/
		Vector foreigncurrencyid_value = new Vector(1,1);
		Vector foreigncurrencyid_key = new Vector(1,1);
		foreigncurrencyid_value.add("");
		foreigncurrencyid_key.add("---select---");

		for (int i = 0; i < objectClass.size(); i++) {
			 BankDepositDetail bankDepositDetail = (BankDepositDetail)objectClass.get(i);
			 rowx = new Vector();
			 if(bankDepositDetailId == bankDepositDetail.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_BANK_DEPOSIT_ID] +"\" value=\""+bankDepositDetail.getBankDepositId()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspBankDepositDetail.JSP_COA_ID],null, ""+bankDepositDetail.getCoaId(), coaid_value , coaid_key, "formElemen", ""));
				rowx.add(JSPCombo.draw(frmObject.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID],null, ""+bankDepositDetail.getForeignCurrencyId(), foreigncurrencyid_value , foreigncurrencyid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT] +"\" value=\""+bankDepositDetail.getForeignAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_BOOKED_RATE] +"\" value=\""+bankDepositDetail.getBookedRate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_AMOUNT] +"\" value=\""+bankDepositDetail.getAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_MEMO] +"\" value=\""+bankDepositDetail.getMemo()+"\" class=\"formElemen\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(bankDepositDetail.getOID())+"')\">"+String.valueOf(bankDepositDetail.getBankDepositId())+"</a>");
				rowx.add(String.valueOf(bankDepositDetail.getCoaId()));
				rowx.add(String.valueOf(bankDepositDetail.getForeignCurrencyId()));
				rowx.add(String.valueOf(bankDepositDetail.getForeignAmount()));
				rowx.add(String.valueOf(bankDepositDetail.getBookedRate()));
				rowx.add(String.valueOf(bankDepositDetail.getAmount()));
				rowx.add(bankDepositDetail.getMemo());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_BANK_DEPOSIT_ID] +"\" value=\""+objEntity.getBankDepositId()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspBankDepositDetail.JSP_COA_ID],null, ""+objEntity.getCoaId(), coaid_value , coaid_key, "formElemen", ""));
				rowx.add(JSPCombo.draw(frmObject.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID],null, ""+objEntity.getForeignCurrencyId(), foreigncurrencyid_value , foreigncurrencyid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT] +"\" value=\""+objEntity.getForeignAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_BOOKED_RATE] +"\" value=\""+objEntity.getBookedRate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspBankDepositDetail.JSP_MEMO] +"\" value=\""+objEntity.getMemo()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}
	
	public Vector addNewDetail(Vector listBankDepositDetail, BankDepositDetail bankDepositDetail){
		boolean found = false;
		if(listBankDepositDetail!=null && listBankDepositDetail.size()>0){
			for(int i=0; i<listBankDepositDetail.size(); i++){
				BankDepositDetail cr = (BankDepositDetail)listBankDepositDetail.get(i);
				if(cr.getCoaId()==bankDepositDetail.getCoaId() && cr.getForeignCurrencyId()==bankDepositDetail.getForeignCurrencyId()){
					//jika coa sama dan currency sama lakukan penggabungan
					cr.setForeignAmount(cr.getForeignAmount()+bankDepositDetail.getForeignAmount());
					cr.setAmount(cr.getAmount()+bankDepositDetail.getAmount());
					found = true;
				}
			}
		}
		
		if(!found){
			listBankDepositDetail.add(bankDepositDetail);
		}
		
		return listBankDepositDetail;
	}
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				BankDepositDetail crd = (BankDepositDetail)listx.get(i);
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

//main

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidBankDeposit = JSPRequestValue.requestLong(request, "hidden_bank_deposit_id");
long oidBankDepositDetail = JSPRequestValue.requestLong(request, "hidden_bank_deposit_detail_id");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	//if(session.getValue("BANK_DEPOSIT")!=null){
		session.removeValue("BANK_DEPOSIT");
	//}
	oidBankDeposit = 0;
	//iJSPCommand = JSPCommand.ADD;
	recIdx = -1;
}
//===============================================================

//out.println("recIdx : "+recIdx);


/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdBankDeposit ctrlBankDeposit = new CmdBankDeposit(request);
JSPLine ctrLine = new JSPLine();
Vector listBankDeposit = new Vector(1,1);

/*switch statement */
int iErrCodeMain = ctrlBankDeposit.action(iJSPCommand , oidBankDeposit);
/* end switch*/
JspBankDeposit jspBankDeposit = ctrlBankDeposit.getForm();

/*count list All BankDeposit*/
int vectSize = DbBankDeposit.getCount(whereClause);

BankDeposit bankDeposit = ctrlBankDeposit.getBankDeposit();
String msgStringMain =  ctrlBankDeposit.getMessage();

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlBankDeposit.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listBankDeposit = DbBankDeposit.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listBankDeposit.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listBankDeposit = DbBankDeposit.list(start,recordToGet, whereClause , orderClause);
}

System.out.println("\n -- start detail session ---\n");


%>
<%

//bagian CASH RECEIVE DETAIL
//===================================update============================
if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.ADD;
}
//=====================================================================

//item detail

//int iJSPCommand = JSPRequestValue.requestJSPCommand(request);
//int start = JSPRequestValue.requestInt(request, "start");
//int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");


/*variable declaration*/
//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdBankDepositDetail ctrlBankDepositDetail = new CmdBankDepositDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listBankDepositDetail = new Vector(1,1);

/*switch statement */
iErrCode = ctrlBankDepositDetail.action(iJSPCommand , oidBankDepositDetail);
/* end switch*/
JspBankDepositDetail jspBankDepositDetail = ctrlBankDepositDetail.getForm();

/*count list All BankDepositDetail*/
vectSize = DbBankDepositDetail.getCount(whereClause);

/*switch list BankDepositDetail*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlBankDepositDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

BankDepositDetail bankDepositDetail = ctrlBankDepositDetail.getBankDepositDetail();
msgString =  ctrlBankDepositDetail.getMessage();

/* get record to display */
//listBankDepositDetail = DbBankDepositDetail.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
/*if (listBankDepositDetail.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listBankDepositDetail = DbBankDepositDetail.list(start,recordToGet, whereClause , orderClause);
}
*/

if(session.getValue("BANK_DEPOSIT")!=null){
	listBankDepositDetail = (Vector)session.getValue("BANK_DEPOSIT");
}

if(iJSPCommand==JSPCommand.SUBMIT){
	if(iErrCode==0){
		if(recIdx==-1){		
			listBankDepositDetail.add(bankDepositDetail);// = addNewDetail(listBankDepositDetail, bankDepositDetail);
			//listBankDepositDetail.add(bankDepositDetail);
		}
		else{
			//listBankDepositDetail.set(recIdx, bankDepositDetail);
			//listBankDepositDetail.remove(recIdx);
			//listBankDepositDetail = addNewDetail(listBankDepositDetail, bankDepositDetail);
			listBankDepositDetail.set(recIdx, bankDepositDetail);
		}
	}
}
if(iJSPCommand==JSPCommand.DELETE){
	listBankDepositDetail.remove(recIdx);
}

if(iJSPCommand==JSPCommand.SAVE){
	if(bankDeposit.getOID()!=0){
		DbBankDepositDetail.saveAllDetail(bankDeposit, listBankDepositDetail);
		listBankDepositDetail = DbBankDepositDetail.list(0,0, "bank_deposit_id="+bankDeposit.getOID(), "");
		
		//posting ke journal
		DbBankDeposit.postJournal(bankDeposit, listBankDepositDetail);
	}
}

//out.println("<br>"+listBankDepositDetail);

session.putValue("BANK_DEPOSIT", listBankDepositDetail);

//String wherex = " ((account_group='"+I_Project.ACC_GROUP_REVENUE+"' or account_group='"+I_Project.ACC_GROUP_OTHER_REVENUE+"') "+
//				" and (location_id="+sysLocation.getOID()+" or location_id=0))";
//only view postable account in combo				
//if(isPostableOnly){
//	wherex = wherex + " and status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'";
//}
//Vector incomeCoas = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_CASH+"' and location_id="+sysCompany.getSystemLocation(), "");

Vector incomeCoas = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_BANK_DEPOSIT_CREDIT+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");

//Vector incomeCoas = DbCoa.list(0,0, wherex, "code");

Vector currencies = DbCurrency.list(0,0,"", "");

ExchangeRate eRate = DbExchangeRate.getStandardRate();

double balance = 0;
double totalDetail = getTotalDetail(listBankDepositDetail);
bankDeposit.setAmount(totalDetail);

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && iErrCodeMain==0 && recIdx==-1){
	iJSPCommand = JSPCommand.ADD;
	bankDepositDetail = new BankDepositDetail();
}

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_BANK_DEPOSIT_DEBET+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");

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

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptBankDepositPDF?oid=<%=appSessUser.getLoginId()%>&dep_id=<%=bankDeposit.getOID()%>");//,"budget","scrollbars=no,height=400,width=400,addressbar=no,menubar=no,toolbar=no,location=no,");  				
}

function cmdClickMe(){
	var x = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value;	
	document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.select();
}

function cmdFixing(){	
	document.frmbankdepositdetail.command.value="<%=JSPCommand.POST%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();	
}

function cmdNewJournal(){	
	document.frmbankdepositdetail.command.value="<%=JSPCommand.NONE%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();	
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
	var st = document.frmbankdepositdetail.<%=JspBankDeposit.colNames[JspBankDeposit.JSP_AMOUNT]%>.value;		
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmbankdepositdetail.<%=JspBankDeposit.colNames[JspBankDeposit.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber2(){
	
	//alert("in check number 2");
	
	var main = document.frmbankdepositdetail.<%=jspBankDeposit.colNames[jspBankDeposit.JSP_AMOUNT]%>.value;		
	main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var currTotal = document.frmbankdepositdetail.total_detail.value;
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
	var idx = document.frmbankdepositdetail.select_idx.value;		
	var booked = document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_BOOKED_RATE]%>.value;		
	booked = cleanNumberFloat(booked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var st = document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_AMOUNT]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var result2 = 0;
	
	//alert("main : "+main+", currTotal : "+currTotal+", idx : "+idx+", booked : "+booked+", result : "+result);
	
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(currTotal) + parseFloat(result);
		document.frmbankdepositdetail.<%=jspBankDeposit.colNames[jspBankDeposit.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		/*alert("amount : "+amount+", main : "+main+", idx  xxx ");
		
		if(amount>parseFloat(main)){
			alert("Amount over the maximum allowed, \nsystem will reset the data");
			result = parseFloat(main)-parseFloat(currTotal);
			result2 = result/parseFloat(booked);			
			document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value = formatFloat(result2, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
			result2 = document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value;
			result2 = cleanNumberFloat(result2, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			
			alert("result2 : "+result2);
			
			document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_AMOUNT]%>.value = formatFloat(parseFloat(result2) * parseFloat(booked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		}*/
	}
	//edit
	else{
		var editAmount =  document.frmbankdepositdetail.edit_amount.value;
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		document.frmbankdepositdetail.<%=jspBankDeposit.colNames[jspBankDeposit.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		/*if(amount>parseFloat(main)){
			alert("Amount over the maximum allowed, \nsystem will reset the data");
			result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));
			result2 = result/parseFloat(booked);
			document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value = formatFloat(result2, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
			result2 = document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value;
			result2 = cleanNumberFloat(result2, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			alert("result2 : "+result2);
			document.frmbankdepositdetail.<%=jspBankDepositDetail.colNames[jspBankDepositDetail.JSP_AMOUNT]%>.value = formatFloat(parseFloat(result2) * parseFloat(booked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		}*/
	}
	
	
}

function cmdUpdateExchange(){
	var idCurr = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
	
	<%if(currencies!=null && currencies.size()>0){
		for(int i=0; i<currencies.size(); i++){
			Currency cx = (Currency)currencies.get(i);
	%>
			if(idCurr=='<%=cx.getOID()%>'){
				<%if(cx.getCurrencyCode().equals(IDRCODE)){%>
					document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
				<%}
				else if(cx.getCurrencyCode().equals(USDCODE)){%>
					document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueUsd()%>";
				<%}
				else if(cx.getCurrencyCode().equals(EURCODE)){%>
					document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueEuro()%>";
				<%}%>
			}	
	<%}}%>
	
	var famount = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value;
	
	famount = removeChar(famount);
	famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert(famount);
	
	var fbooked = document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>.value;
	fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert(fbooked);
	
	if(!isNaN(famount)){
		document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
		document.frmbankdepositdetail.<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		//alert('!isNaN');		
	}
	
	checkNumber2();
}

//===============================================================================================

function cmdAdd(){	
	document.frmbankdepositdetail.select_idx.value="-1";
	document.frmbankdepositdetail.hidden_bank_deposit_id.value="0";
	document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value="0";
	document.frmbankdepositdetail.command.value="<%=JSPCommand.ADD%>";
	document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdAsk(oidBankDepositDetail){
	document.frmbankdepositdetail.select_idx.value=oidBankDepositDetail;
	document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
	document.frmbankdepositdetail.command.value="<%=JSPCommand.ASK%>";
	document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdConfirmDelete(oidBankDepositDetail){
	document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
	document.frmbankdepositdetail.command.value="<%=JSPCommand.DELETE%>";
	document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdSave(){
	document.frmbankdepositdetail.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdSubmitCommand(){
	document.frmbankdepositdetail.command.value="<%=JSPCommand.SAVE%>";
	document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdEdit(oidBankDepositDetail){
	document.frmbankdepositdetail.select_idx.value=oidBankDepositDetail;
	document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
	document.frmbankdepositdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdCancel(oidBankDepositDetail){
	document.frmbankdepositdetail.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
	document.frmbankdepositdetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmbankdepositdetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdBack(){
	document.frmbankdepositdetail.command.value="<%=JSPCommand.BACK%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdListFirst(){
	document.frmbankdepositdetail.command.value="<%=JSPCommand.FIRST%>";
	document.frmbankdepositdetail.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdListPrev(){
	document.frmbankdepositdetail.command.value="<%=JSPCommand.PREV%>";
	document.frmbankdepositdetail.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdListNext(){
	document.frmbankdepositdetail.command.value="<%=JSPCommand.NEXT%>";
	document.frmbankdepositdetail.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}

function cmdListLast(){
	document.frmbankdepositdetail.command.value="<%=JSPCommand.LAST%>";
	document.frmbankdepositdetail.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmbankdepositdetail.action="bankdepositdetail.jsp";
	document.frmbankdepositdetail.submit();
}





//-------------- script form image -------------------

function cmdDelPict(oidBankDepositDetail){
	document.frmimage.hidden_bank_deposit_detail_id.value=oidBankDepositDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="bankdepositdetail.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Bank</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Deposit</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbankdepositdetail" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_bank_deposit_detail_id" value="<%=oidBankDepositDetail%>">
                          <input type="hidden" name="hidden_bank_deposit_id" value="<%=oidBankDeposit%>">
                          <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
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
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspBankDeposit.getErrorMsg(JspBankDeposit.JSP_OPERATOR_ID) %>&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="13%">&nbsp;</td>
                                                <td width="33%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Deposit to Account</td>
                                                <td width="33%"> 
                                                 
                                                  <select name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_COA_ID]%>">
                                                    <%if(accLinks!=null && accLinks.size()>0){
													  for(int i=0; i<accLinks.size(); i++){
															AccLink accLink = (AccLink)accLinks.get(i);
															Coa coa = new Coa();
															try{
																coa = DbCoa.fetchExc(accLink.getCoaId());
															}
															catch(Exception e){
															}
															
															if(bankDeposit.getCoaId()==0 && i==0){
																bankDeposit.setCoaId(accLink.getCoaId());
															}
													  %>
                                                    <option <%if(bankDeposit.getCoaId()==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
													<%=getAccountRecursif(coa, bankDeposit.getCoaId(), isPostableOnly)%>
                                                    <%}}else{%>
                                                    <option>select ..</option>
                                                    <%}%>
                                                  </select>
                                                  <%= jspBankDeposit.getErrorMsg(JspBankDeposit.JSP_COA_ID) %> </td>
                                                <td width="12%">Journal Number</td>
                                                <td width="42%"> 
                                                  <%
									  int counter = DbBankDeposit.getNextCounter(bankDeposit.getCoaId());
									  String strNumber = DbBankDeposit.getNextNumber(counter, bankDeposit.getCoaId());
									  //String strNumber = "[ auto ]";//DbBankDeposit.getNextNumber(counter, bankDeposit.getCoaId());
									  
									  if(bankDeposit.getOID()!=0){
											strNumber = bankDeposit.getJournalNumber();
									  }									  
									  
									  %>
                                                  <%=strNumber%> 
                                                  <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_NUMBER]%>">
                                                  <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_COUNTER]%>">
                                                  <input type="hidden" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_JOURNAL_PREFIX]%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Amount <%=baseCurrency.getCurrencyCode()%></td>
                                                <td width="33%"> 
                                                  <input type="text" name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_AMOUNT]%>" style="text-align:right" value="<%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%>" onBlur="javascript:checkNumber()"  class="readonly" readOnly>
                                                  <%//= jspBankDeposit.getErrorMsg(JspBankDeposit.JSP_AMOUNT) %>
                                                </td>
                                                <td width="12%">Transaction Date</td>
                                                <td width="42%"> 
                                                  <input name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((bankDeposit.getTransDate()==null) ? new Date() : bankDeposit.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankdepositdetail.<%=JspBankDeposit.colNames[JspBankDeposit.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%= jspBankDeposit.getErrorMsg(jspBankDeposit.JSP_TRANS_DATE) %> </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Memo</td>
                                                <td colspan="3"> 
                                                  <textarea name="<%=JspBankDeposit.colNames[JspBankDeposit.JSP_MEMO]%>" cols="50" rows="2"><%=bankDeposit.getMemo()%></textarea>
                                                  <%= jspBankDeposit.getErrorMsg(jspBankDeposit.JSP_MEMO) %> </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                  </tr>
                                  <%
							try{
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td class="boxed1"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td rowspan="2"  class="tablehdr" nowrap>Account 
                                                  - Description</td>
                                                <td colspan="2" class="tablehdr"> 
                                                  Currency</td>
                                                <td rowspan="2" class="tablehdr">Booked<br>
                                                  Rate</td>
                                                <td rowspan="2" class="tablehdr">Amount 
                                                  <%=baseCurrency.getCurrencyCode()%></td>
                                                <td rowspan="2" class="tablehdr">Description</td>
                                              </tr>
                                              <tr> 
                                                <td width="7%" class="tablehdr">Code</td>
                                                <td width="10%" class="tablehdr"> 
                                                  Amount</td>
                                              </tr>
                                              <%if(listBankDepositDetail!=null && listBankDepositDetail.size()>0){
										for(int i=0; i<listBankDepositDetail.size(); i++){
											BankDepositDetail crd = (BankDepositDetail)listBankDepositDetail.get(i);
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
                                                <td class="tablecell"> 
                                                  <div align="center"> 
                                                    <select name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_COA_ID]%>">
                                                      <%if(incomeCoas!=null && incomeCoas.size()>0){
											for(int x=0; x<incomeCoas.size(); x++){
											
												AccLink accLink = (AccLink)incomeCoas.get(x);
												Coa coax = new Coa();
												try{
													coax = DbCoa.fetchExc(accLink.getCoaId());
												}
												catch(Exception e){
												}
												
											
												//Coa coax = (Coa)incomeCoas.get(x);
												
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
												}
												*/
										%>
                                                      <option value="<%=coax.getOID()%>" <%if(crd.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
													  <%=getAccountRecursif(coax, crd.getCoaId(), isPostableOnly)%>
                                                      <%}}%>
                                                    </select>
                                                    <%= jspBankDepositDetail.getErrorMsg(JspBankDepositDetail.JSP_COA_ID) %> </div>
                                                </td>
                                                <td width="7%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <select name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
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
                                                <td width="10%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                    <%= jspBankDepositDetail.getErrorMsg(jspBankDepositDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                </td>
                                                <td width="13%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>" size="4" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>" style="text-align:right"  class="readonly rightalign" readOnly>
                                                  </div>
                                                </td>
                                                <td width="13%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                    <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                    <%= jspBankDepositDetail.getErrorMsg(JspBankDepositDetail.JSP_AMOUNT) %> </div>
                                                </td>
                                                <td width="46%" class="tablecell"> 
                                                  <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_MEMO]%>" size="30" value="<%=crd.getMemo()%>">
                                                </td>
                                              </tr>
                                              <%}else{%>
                                              <tr> 
                                                <td class="<%=cssString%>" nowrap> 
                                                  <%if(bankDeposit.getOID()==0){%>
                                                  <a href="javascript:cmdEdit('<%=i%>')"><%=c.getCode()%></a> 
                                                  <%}else{%>
                                                  <%=c.getCode()%> 
                                                  <%}%>
                                                  &nbsp;-&nbsp; <%=c.getName()%></td>
                                                <td width="7%" class="<%=cssString%>"> 
                                                  <div align="center"> 
                                                    <%
									  Currency xc = new Currency();
									  try{
									  		xc = DbCurrency.fetchExc(crd.getForeignCurrencyId());
									  }
									  catch(Exception e){
									  }									  
									  %>
                                                    <%=xc.getCurrencyCode()%> </div>
                                                </td>
                                                <td width="10%" class="<%=cssString%>"> 
                                                  <div align="right"> <%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%> </div>
                                                </td>
                                                <td width="13%" class="<%=cssString%>"> 
                                                  <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>
                                                </td>
                                                <td width="13%" class="<%=cssString%>"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                </td>
                                                <td width="46%" class="<%=cssString%>"><%=crd.getMemo()%></td>
                                              </tr>
                                              <%}%>
                                              <%}}%>
                                              <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && recIdx==-1 ){%>
                                              <tr> 
                                                <td class="tablecell"> 
                                                  <div align="center"> 
                                                    <select name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_COA_ID]%>">
                                                      <%if(incomeCoas!=null && incomeCoas.size()>0){
											for(int x=0; x<incomeCoas.size(); x++){
												
												//Coa coax = (Coa)incomeCoas.get(x);
												
												AccLink accLink = (AccLink)incomeCoas.get(x);
												Coa coax = new Coa();
												try{
													coax = DbCoa.fetchExc(accLink.getCoaId());
												}
												catch(Exception e){
												}
												
												
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
                                                      <option value="<%=coax.getOID()%>" <%if(bankDepositDetail.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
													  <%=getAccountRecursif(coax, bankDepositDetail.getCoaId(), isPostableOnly)%>
                                                      <%}}%>
                                                    </select>
                                                    <%= jspBankDepositDetail.getErrorMsg(JspBankDepositDetail.JSP_COA_ID) %> </div>
                                                </td>
                                                <td width="7%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <select name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                      <%if(currencies!=null && currencies.size()>0){
										  		for(int x=0; x<currencies.size(); x++){
													Currency c = (Currency)currencies.get(x);
										  %>
                                                      <option value="<%=c.getOID()%>" <%if(bankDepositDetail.getForeignCurrencyId()==c.getOID()){%>selected<%}%>><%=c.getCurrencyCode()%></option>
                                                      <%}}%>
                                                    </select>
                                                  </div>
                                                </td>
                                                <td width="10%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(bankDepositDetail.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                    <%= jspBankDepositDetail.getErrorMsg(jspBankDepositDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                </td>
                                                <td width="13%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_BOOKED_RATE]%>" size="4" value="<%=JSPFormater.formatNumber(bankDepositDetail.getBookedRate(), "#,###.##")%>" style="text-align:right"  class="readonly rightalign" readOnly>
                                                  </div>
                                                </td>
                                                <td width="13%" class="tablecell"> 
                                                  <div align="center"> 
                                                    <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(bankDepositDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                    <%= jspBankDepositDetail.getErrorMsg(JspBankDepositDetail.JSP_AMOUNT) %> </div>
                                                </td>
                                                <td width="46%" class="tablecell"> 
                                                  <div align="left">
                                                    <input type="text" name="<%=JspBankDepositDetail.colNames[JspBankDepositDetail.JSP_MEMO]%>" size="30" value="<%=bankDepositDetail.getMemo()%>">
                                                  </div>
                                                </td>
                                              </tr>
                                              <%}%>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td> 
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
                                                    <%if(iErrCodeMain==0 || iErrCode!=0 || listBankDepositDetail==null || listBankDepositDetail.size()==0){%>
                                                    <tr> 
                                                      <td> 
                                                        <%
										  
												if(bankDeposit.getOID()==0){
															  
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
												String scomDel = "javascript:cmdAsk('"+oidBankDepositDetail+"')";
												String sconDelCom = "javascript:cmdConfirmDelete('"+oidBankDepositDetail+"')";
												String scancel = "javascript:cmdEdit('"+oidBankDepositDetail+"')";
												if(listBankDepositDetail!=null && listBankDepositDetail.size()>0){
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
                                                          <%=baseCurrency.getCurrencyCode()%> : </b></div>
                                                      </td>
                                                      <td width="64%"> 
                                                        <div align="right"><b> 
                                                          <%
										
										
										//out.println("<br>totalDetail : "+totalDetail);
										//out.println("<br>bankDeposit.getAmount() : "+bankDeposit.getAmount());
										
										balance = bankDeposit.getAmount() - totalDetail;
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
                                          <td>&nbsp; </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <% 
						  }catch(Exception exc){ 
						  }%>
                                  <%if(bankDeposit.getAmount()!=0 && iErrCode==0 && iErrCodeMain==0 && balance==0 && bankDeposit.getOID()==0){%>
                                  <tr align="left" valign="top"> 
                                    <td height="1" valign="middle" colspan="3"> 
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
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="8%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                          <td width="58%">&nbsp;</td>
                                          <td width="34%"> 
                                            <table border="0" cellpadding="5" cellspacing="0" class="info" width="221" align="right">
                                              <tr> 
                                                <td width="15"><img src="../images/inform.gif" width="20" height="20"></td>
                                                <td width="186" nowrap>Journal 
                                                  is ready to be posted</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                  <%if(bankDeposit.getOID()!=0){%>
                                  <tr align="left" valign="top"> 
                                    <td height="1" valign="middle" colspan="3"> 
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
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="4%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                          <td width="3%">&nbsp;</td>
                                          <td width="10%"><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/new2.gif',1)"><img src="../images/new.gif" name="new1" width="71" height="22" border="0"></a></td>
                                          <td width="48%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                          <td width="35%"> 
                                            <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                              <tr> 
                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                <td width="220">Journal has been 
                                                  posted successfully</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}%>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="17%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command">&nbsp; </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
						  document.frmbankdepositdetail.<%=JspBankDeposit.colNames[JspBankDeposit.JSP_AMOUNT]%>.value="<%=JSPFormater.formatNumber(totalDetail, "#,###.##")%>";
						  <%if(iErrCode!=0 || iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT){%>
						  cmdUpdateExchange();
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
