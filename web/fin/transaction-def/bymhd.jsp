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
boolean cashPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE);
%>
<!-- Jsp Block -->
<%!

	public String drawList(int iJSPCommand,JspCashReceiveDetail frmObject, CashReceiveDetail objEntity, Vector objectClass,  long cashReceiveDetailId, int iErrCode2)

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
			 CashReceiveDetail cashReceiveDetail = (CashReceiveDetail)objectClass.get(i);
			 rowx = new Vector();
			 if(cashReceiveDetailId == cashReceiveDetail.getOID())
				 index = i; 

			 if(index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK || (iErrCode2!=0 && cashReceiveDetailId!=0))){
					
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_CASH_RECEIVE_ID] +"\" value=\""+cashReceiveDetail.getCashReceiveId()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspCashReceiveDetail.JSP_COA_ID],null, ""+cashReceiveDetail.getCoaId(), coaid_value , coaid_key, "formElemen", ""));
				rowx.add(JSPCombo.draw(frmObject.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID],null, ""+cashReceiveDetail.getForeignCurrencyId(), foreigncurrencyid_value , foreigncurrencyid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT] +"\" value=\""+cashReceiveDetail.getForeignAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE] +"\" value=\""+cashReceiveDetail.getBookedRate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_AMOUNT] +"\" value=\""+cashReceiveDetail.getAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_MEMO] +"\" value=\""+cashReceiveDetail.getMemo()+"\" class=\"formElemen\">");
			}else{
				rowx.add("<a href=\"javascript:cmdEdit('"+String.valueOf(cashReceiveDetail.getOID())+"')\">"+String.valueOf(cashReceiveDetail.getCashReceiveId())+"</a>");
				rowx.add(String.valueOf(cashReceiveDetail.getCoaId()));
				rowx.add(String.valueOf(cashReceiveDetail.getForeignCurrencyId()));
				rowx.add(String.valueOf(cashReceiveDetail.getForeignAmount()));
				rowx.add(String.valueOf(cashReceiveDetail.getBookedRate()));
				rowx.add(String.valueOf(cashReceiveDetail.getAmount()));
				rowx.add(cashReceiveDetail.getMemo());
			} 

			lstData.add(rowx);
		}

		 rowx = new Vector();

		if(iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && iErrCode2!=0 && cashReceiveDetailId==0)){ 
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_CASH_RECEIVE_ID] +"\" value=\""+objEntity.getCashReceiveId()+"\" class=\"formElemen\">");
				rowx.add(JSPCombo.draw(frmObject.colNames[JspCashReceiveDetail.JSP_COA_ID],null, ""+objEntity.getCoaId(), coaid_value , coaid_key, "formElemen", ""));
				rowx.add(JSPCombo.draw(frmObject.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID],null, ""+objEntity.getForeignCurrencyId(), foreigncurrencyid_value , foreigncurrencyid_key, "formElemen", ""));
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT] +"\" value=\""+objEntity.getForeignAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE] +"\" value=\""+objEntity.getBookedRate()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_AMOUNT] +"\" value=\""+objEntity.getAmount()+"\" class=\"formElemen\">");
				rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspCashReceiveDetail.JSP_MEMO] +"\" value=\""+objEntity.getMemo()+"\" class=\"formElemen\">");

		}

		lstData.add(rowx);

		return ctrlist.draw();
	}
	
	public Vector addNewDetail(Vector listCashReceiveDetail, CashReceiveDetail cashReceiveDetail){
		boolean found = false;
		if(listCashReceiveDetail!=null && listCashReceiveDetail.size()>0){
			for(int i=0; i<listCashReceiveDetail.size(); i++){
				CashReceiveDetail cr = (CashReceiveDetail)listCashReceiveDetail.get(i);
				if(cr.getCoaId()==cashReceiveDetail.getCoaId() && cr.getForeignCurrencyId()==cashReceiveDetail.getForeignCurrencyId()){
					//jika coa sama dan currency sama lakukan penggabungan
					cr.setForeignAmount(cr.getForeignAmount()+cashReceiveDetail.getForeignAmount());
					cr.setAmount(cr.getAmount()+cashReceiveDetail.getAmount());
					found = true;
				}
			}
		}
		
		if(!found){
			listCashReceiveDetail.add(cashReceiveDetail);
		}
		
		return listCashReceiveDetail;
	}
	
	public double getTotalDetail(Vector listx){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				CashReceiveDetail crd = (CashReceiveDetail)listx.get(i);
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
long oidCashReceive = JSPRequestValue.requestLong(request, "hidden_cash_receive_id");
long oidCashReceiveDetail = JSPRequestValue.requestLong(request, "hidden_cash_receive_detail_id");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	//if(session.getValue("RECEIVE_DETAIL")!=null){
		session.removeValue("RECEIVE_DETAIL");
	//}
	oidCashReceive = 0;
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

CmdCashReceive ctrlCashReceive = new CmdCashReceive(request);
JSPLine ctrLine = new JSPLine();
Vector listCashReceive = new Vector(1,1);

/*switch statement */
int iErrCodeRec = ctrlCashReceive.action(iJSPCommand , oidCashReceive);
/* end switch*/
JspCashReceive jspCashReceive = ctrlCashReceive.getForm();

/*count list All CashReceive*/
int vectSize = DbCashReceive.getCount(whereClause);

CashReceive cashReceive = ctrlCashReceive.getCashReceive();
String msgStringRec =  ctrlCashReceive.getMessage();

//out.println("msgStringRec : "+msgStringRec);
//out.println("jspCashReceive : "+jspCashReceive.getErrors());

if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlCashReceive.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
listCashReceive = DbCashReceive.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
if (listCashReceive.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCashReceive = DbCashReceive.list(start,recordToGet, whereClause , orderClause);
}

System.out.println("\n -- start detail session ---\n");

Vector custs = DbVendor.list(0,0,"type=2", "");


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

CmdCashReceiveDetail ctrlCashReceiveDetail = new CmdCashReceiveDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listCashReceiveDetail = new Vector(1,1);

/*switch statement */
iErrCode = ctrlCashReceiveDetail.action(iJSPCommand , oidCashReceiveDetail);
/* end switch*/
JspCashReceiveDetail jspCashReceiveDetail = ctrlCashReceiveDetail.getForm();

/*count list All CashReceiveDetail*/
vectSize = DbCashReceiveDetail.getCount(whereClause);

/*switch list CashReceiveDetail*/
if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlCashReceiveDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

CashReceiveDetail cashReceiveDetail = ctrlCashReceiveDetail.getCashReceiveDetail();
msgString =  ctrlCashReceiveDetail.getMessage();

/* get record to display */
//listCashReceiveDetail = DbCashReceiveDetail.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
/*if (listCashReceiveDetail.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listCashReceiveDetail = DbCashReceiveDetail.list(start,recordToGet, whereClause , orderClause);
}
*/

if(session.getValue("RECEIVE_DETAIL")!=null){
	listCashReceiveDetail = (Vector)session.getValue("RECEIVE_DETAIL");
}

if(iJSPCommand==JSPCommand.SUBMIT){
	if(iErrCode==0){
		if(recIdx==-1){		
			listCashReceiveDetail.add(cashReceiveDetail);// = addNewDetail(listCashReceiveDetail, cashReceiveDetail);
			//listCashReceiveDetail.add(cashReceiveDetail);
		}
		else{
			//listCashReceiveDetail.set(recIdx, cashReceiveDetail);
			//listCashReceiveDetail.remove(recIdx);
			//listCashReceiveDetail = addNewDetail(listCashReceiveDetail, cashReceiveDetail);
			listCashReceiveDetail.set(recIdx, cashReceiveDetail);
		}
	}
}
if(iJSPCommand==JSPCommand.DELETE){
	listCashReceiveDetail.remove(recIdx);
}

if(iJSPCommand==JSPCommand.SAVE){
	if(cashReceive.getOID()!=0){
		DbCashReceiveDetail.saveAllDetail(cashReceive, listCashReceiveDetail);
		listCashReceiveDetail = DbCashReceiveDetail.list(0,0, "cash_receive_id="+cashReceive.getOID(), "");
		
		//posting ke journal
		DbCashReceive.postJournalKembaliTitipan(cashReceive, listCashReceiveDetail);
	}
}

System.out.println("\n -- xx detail session ---\n");

//out.println("<br>"+listCashReceiveDetail);

session.putValue("RECEIVE_DETAIL", listCashReceiveDetail);

String wherex = "((account_group='"+I_Project.ACC_GROUP_CURRENT_LIABILITIES+"' or account_group='"+I_Project.ACC_GROUP_LONG_TERM_LIABILITIES+"')"+// or account_group='"+I_Project.ACC_GROUP_OTHER_REVENUE+"')"+
				" and (location_id="+sysLocation.getOID()+" or location_id=0))";			
//only view postable account in combo				
if(isPostableOnly){
	wherex = wherex + " and status='"+I_Project.ACCOUNT_LEVEL_POSTABLE+"'";
}				 		
//out.println(wherex);				
Vector incomeCoas = DbCoa.list(0,0, wherex, "code");

//Vector incomeCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_GROUP_CASH_CREDIT, sysLocation.getOID());

//System.out.println("\n -- xxxx1 detail session ---\n");

Vector currencies = DbCurrency.list(0,0,"", "");

//System.out.println("\n -- xxxx2 detail session ---\n");

ExchangeRate eRate = DbExchangeRate.getStandardRate();

//System.out.println("\n -- xxxx3 detail session ---\n");

double balance = 0;
double totalDetail = getTotalDetail(listCashReceiveDetail);
cashReceive.setAmount(totalDetail);

//System.out.println("\n -- xxxx detail session ---\n");

//out.println("iErrCode : "+iErrCode);
//out.println("iErrCodeRec : "+iErrCodeRec);

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && iErrCodeRec==0 && recIdx==-1){
	iJSPCommand = JSPCommand.ADD;
	cashReceiveDetail = new CashReceiveDetail();
}

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_CASH+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");
Vector bankaccLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_BANK_DEPOSIT_DEBET+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");
if(bankaccLinks!=null && bankaccLinks.size()>0){
	for(int i=0; i<bankaccLinks.size(); i++){
		accLinks.add((AccLink)bankaccLinks.get(i));
	}
}

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">

<%if(!cashPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

//=======================================update===========================================================

function cmdPrintJournal(){	 
	//window.open("<%=printroot%>.report.RptCashReceiptPDF?oid=<%=appSessUser.getLoginId()%>&crd_id=<%=cashReceive.getOID()%>");
	window.open("<%=printroot%>.report.RptBymhdPDF?oid=<%=appSessUser.getLoginId()%>&crd_id=<%=cashReceive.getOID()%>");
}


function cmdClickMe(){
	var x = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value;	
	document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.select();
}

function cmdFixing(){	
	document.frmcashreceivedetail.command.value="<%=JSPCommand.POST%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();	
}

function cmdNewJournal(){	
	document.frmcashreceivedetail.command.value="<%=JSPCommand.NONE%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();	
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
	var st = document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_AMOUNT]%>.value;		
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_AMOUNT]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber2(){
	
	//alert("in check number 2");
	
	var main = document.frmcashreceivedetail.<%=jspCashReceive.colNames[jspCashReceive.JSP_AMOUNT]%>.value;		
	main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var currTotal = document.frmcashreceivedetail.total_detail.value;
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
	var idx = document.frmcashreceivedetail.select_idx.value;		
	var booked = document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_BOOKED_RATE]%>.value;		
	booked = cleanNumberFloat(booked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var st = document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_AMOUNT]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var result2 = 0;
	
	//alert("main : "+main+", currTotal : "+currTotal+", idx : "+idx+", booked : "+booked+", result : "+result);
	
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(currTotal) + parseFloat(result);
		document.frmcashreceivedetail.<%=jspCashReceive.colNames[jspCashReceive.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		/*alert("amount : "+amount+", main : "+main+", idx  xxx ");
		
		if(amount>parseFloat(main)){
			alert("Amount over the maximum allowed, \nsystem will reset the data");
			result = parseFloat(main)-parseFloat(currTotal);
			result2 = result/parseFloat(booked);			
			document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value = formatFloat(result2, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
			result2 = document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value;
			result2 = cleanNumberFloat(result2, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			
			alert("result2 : "+result2);
			
			document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_AMOUNT]%>.value = formatFloat(parseFloat(result2) * parseFloat(booked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		}*/
	}
	//edit
	else{
		var editAmount =  document.frmcashreceivedetail.edit_amount.value;
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		document.frmcashreceivedetail.<%=jspCashReceive.colNames[jspCashReceive.JSP_AMOUNT]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		/*if(amount>parseFloat(main)){
			alert("Amount over the maximum allowed, \nsystem will reset the data");
			result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));
			result2 = result/parseFloat(booked);
			document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value = formatFloat(result2, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
			result2 = document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value;
			result2 = cleanNumberFloat(result2, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			alert("result2 : "+result2);
			document.frmcashreceivedetail.<%=jspCashReceiveDetail.colNames[jspCashReceiveDetail.JSP_AMOUNT]%>.value = formatFloat(parseFloat(result2) * parseFloat(booked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		}*/
	}
	
	
}

function cmdUpdateExchange(){
	var idCurr = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
	
	<%if(currencies!=null && currencies.size()>0){
		for(int i=0; i<currencies.size(); i++){
			Currency cx = (Currency)currencies.get(i);
	%>
			if(idCurr=='<%=cx.getOID()%>'){
				<%if(cx.getCurrencyCode().equals(IDRCODE)){%>
					document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
				<%}
				else if(cx.getCurrencyCode().equals(USDCODE)){%>
					document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueUsd()%>";
				<%}
				else if(cx.getCurrencyCode().equals(EURCODE)){%>
					document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueEuro()%>";
				<%}%>
			}	
	<%}}%>
	
	var famount = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value;
	
	famount = removeChar(famount);
	famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert(famount);
	
	var fbooked = document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>.value;
	fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	//alert(fbooked);
	
	if(!isNaN(famount)){
		document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
		document.frmcashreceivedetail.<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
		//alert('!isNaN');		
	}
	
	checkNumber2();
}

//===============================================================================================

function cmdAdd(){	
	document.frmcashreceivedetail.select_idx.value="-1";
	document.frmcashreceivedetail.hidden_cash_receive_id.value="0";
	document.frmcashreceivedetail.hidden_cash_receive_detail_id.value="0";
	document.frmcashreceivedetail.command.value="<%=JSPCommand.ADD%>";
	document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdAsk(oidCashReceiveDetail){
	document.frmcashreceivedetail.select_idx.value=oidCashReceiveDetail;
	document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
	document.frmcashreceivedetail.command.value="<%=JSPCommand.ASK%>";
	document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdConfirmDelete(oidCashReceiveDetail){
	document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
	document.frmcashreceivedetail.command.value="<%=JSPCommand.DELETE%>";
	document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdSave(){
	document.frmcashreceivedetail.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdSubmitCommand(){
	document.frmcashreceivedetail.command.value="<%=JSPCommand.SAVE%>";
	document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdEdit(oidCashReceiveDetail){
	document.frmcashreceivedetail.select_idx.value=oidCashReceiveDetail;
	document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
	document.frmcashreceivedetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdCancel(oidCashReceiveDetail){
	document.frmcashreceivedetail.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
	document.frmcashreceivedetail.command.value="<%=JSPCommand.EDIT%>";
	document.frmcashreceivedetail.prev_command.value="<%=prevJSPCommand%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdBack(){
	document.frmcashreceivedetail.command.value="<%=JSPCommand.BACK%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdListFirst(){
	document.frmcashreceivedetail.command.value="<%=JSPCommand.FIRST%>";
	document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdListPrev(){
	document.frmcashreceivedetail.command.value="<%=JSPCommand.PREV%>";
	document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdListNext(){
	document.frmcashreceivedetail.command.value="<%=JSPCommand.NEXT%>";
	document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}

function cmdListLast(){
	document.frmcashreceivedetail.command.value="<%=JSPCommand.LAST%>";
	document.frmcashreceivedetail.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmcashreceivedetail.action="bymhd.jsp";
	document.frmcashreceivedetail.submit();
}





//-------------- script form image -------------------

function cmdDelPict(oidCashReceiveDetail){
	document.frmimage.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="bymhd.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/close2.gif','../images/savedoc2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
					  String navigator = "<font class=\"lvl1\">BYMHD</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">BYMHD Payment</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcashreceivedetail" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_cash_receive_detail_id" value="<%=oidCashReceiveDetail%>">
                          <input type="hidden" name="hidden_cash_receive_id" value="<%=oidCashReceive%>">
                          <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
						  <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_TYPE]%>" value="<%=DbCashReceive.TYPE_BYMHD%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top"> 
                                          <td height="8" valign="top" colspan="3" width="99%"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td colspan="4"> 
                                                  <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="37%" nowrap> 
                                                        <div align="right">Date 
                                                          : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, 
                                                          &nbsp;Operator : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_OPERATOR_ID) %>&nbsp;</div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" valign="top"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <!--tr> 
                                                      <td width="12%">Uraian</td>
                                                      <td width="1%">&nbsp;</td>
                                                      <td width="33%"> 
                                                        <select name="<%=JspCashReceive.colNames[JspCashReceive.JSP_CUSTOMER_ID]%>">
                                                          <%if(custs!=null && custs.size()>0){
										  for(int i=0; i<custs.size(); i++){
										  		Vendor cu = (Vendor)custs.get(i);
												
										  %>
                                                          <option <%if(cashReceive.getCustomerId()==cu.getOID()){%>selected<%}%> value="<%=cu.getOID()%>"><%=cu.getCode()+" - "+cu.getName()%></option>
                                                          <%}}else{%>
                                                          <option>select ..</option>
                                                          <%}%>
                                                        </select>
                                                      </td>
                                                      <td width="12%">&nbsp;</td>
                                                      <td width="42%">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="5" height="10"></td>
                                                    </tr-->
                                                    <tr> 
                                                      <td width="12%" nowrap>Dibayarkan 
                                                        Dari Akun</td>
                                                      <td width="1%">&nbsp;</td>
                                                      <td colspan="3"> 
                                                        <select name="<%=JspCashReceive.colNames[JspCashReceive.JSP_COA_ID]%>">
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
                                                          <option <%if(cashReceive.getCoaId()==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
                                                          <%=getAccountRecursif(coa, cashReceive.getCoaId(), isPostableOnly)%> 
                                                          <%}}else{%>
                                                          <option>select ..</option>
                                                          <%}%>
                                                        </select>
                                                        <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_COA_ID) %> </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="12%">Dialokasikan 
                                                        Oleh</td>
                                                      <td width="1%">&nbsp;</td>
                                                      <td width="33%"> 
                                                        <%
									  	Vector employees = DbEmployee.list(0,0, "location_id="+sysCompany.getSystemLocation()+" or location_id=0", "");									  
									  %>
                                                        <select name="<%=JspCashReceive.colNames[JspCashReceive.JSP_RECEIVE_FROM_ID]%>">
                                                          <%if(employees!=null && employees.size()>0){
										  	for(int i=0; i<employees.size(); i++){
												Employee em = (Employee)employees.get(i);
										  %>
                                                          <option <%if(cashReceive.getReceiveFromId()==em.getOID()){%>selected<%}%> value="<%=em.getOID()%>"><%=em.getEmpNum()+ " - "+em.getName()%></option>
                                                          <%}}else{%>
                                                          <option>select ..</option>
                                                          <%}%>
                                                        </select>
                                                        <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_RECEIVE_FROM_ID) %> </td>
                                                      <td width="12%">Nomor Jurnal</td>
                                                      <td width="42%"> 
                                                        <%
									  int counter = DbCashReceive.getNextCounter(DbCashReceive.TYPE_BYMHD);
									  String strNumber = DbCashReceive.getNextNumber(counter,DbCashReceive.TYPE_BYMHD);
									  
									  if(cashReceive.getOID()!=0){
											strNumber = cashReceive.getJournalNumber();
									  }
									  
									  %>
                                                        <%=strNumber%> 
                                                        <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_NUMBER]%>">
                                                        <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_COUNTER]%>">
                                                        <input type="hidden" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_JOURNAL_PREFIX]%>">
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="12%">Jumlah <%=baseCurrency.getCurrencyCode()%></td>
                                                      <td width="1%"> 
                                                        <div align="right"></div>
                                                      </td>
                                                      <td width="33%"> 
                                                        <input type="text" name="<%=JspCashReceive.colNames[JspCashReceive.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:checkNumber()" class="readonly" readOnly>
                                                        <%= jspCashReceive.getErrorMsg(JspCashReceive.JSP_AMOUNT) %> </td>
                                                      <td width="12%">Tanggal 
                                                        Transaksi</td>
                                                      <td width="42%"> 
                                                        <input name="<%=JspCashReceive.colNames[JspCashReceive.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((cashReceive.getTransDate()==null) ? new Date() : cashReceive.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcashreceivedetail.<%=JspCashReceive.colNames[JspCashReceive.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                        <%= jspCashReceive.getErrorMsg(jspCashReceive.JSP_TRANS_DATE) %> </td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="12%">Keterangan</td>
                                                      <td width="1%">&nbsp;</td>
                                                      <td colspan="3"> 
                                                        <textarea name="<%=JspCashReceive.colNames[JspCashReceive.JSP_MEMO]%>" cols="45" rows="2"><%=cashReceive.getMemo()%></textarea>
                                                        <%= jspCashReceive.getErrorMsg(jspCashReceive.JSP_MEMO) %> </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="20" valign="middle" colspan="3" class="comment" width="99%">&nbsp;</td>
                                        </tr>
                                        <%
							try{
							%>
                                        <tr align="left" valign="top"> 
                                          <td  valign="middle" colspan="3" width="99%"> 
                                            <table width="99%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td class="boxed1"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td rowspan="2"  class="tablehdr" nowrap width="10%">Uraian</td>
                                                      <td rowspan="2"  class="tablehdr" nowrap width="10%">Akun 
                                                        Hutang - Keterangan</td>
                                                      <td colspan="2" class="tablehdr"> 
                                                        Mata Uang</td>
                                                      <td rowspan="2" class="tablehdr" width="12%">Booked 
                                                        Rate</td>
                                                      <td rowspan="2" class="tablehdr" width="13%">Jumlah 
                                                        <%=baseCurrency.getCurrencyCode()%></td>
                                                      <td rowspan="2" class="tablehdr" width="46%">Keterangan</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="6%" class="tablehdr">Kode</td>
                                                      <td width="13%" class="tablehdr"> 
                                                        Jumlah</td>
                                                    </tr>
                                                    <%if(listCashReceiveDetail!=null && listCashReceiveDetail.size()>0){
										for(int i=0; i<listCashReceiveDetail.size(); i++){
											CashReceiveDetail crd = (CashReceiveDetail)listCashReceiveDetail.get(i);
											Coa c = new Coa();
											try{
												c = DbCoa.fetchExc(crd.getCoaId());
											}
											catch(Exception e){
											}
											
											String cssName = "tablecell";
											if(i%2!=0){
												cssName = "tablecell1";
											}
											
											
									%>
                                                    <%
									
									if(((iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK) || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && i==recIdx){%>
                                                    <tr> 
                                                      <td class="<%=cssName%>" width="10%"> 
                                                        <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CUSTOMER_ID]%>">
                                                          <%if(custs!=null && custs.size()>0){
										  for(int x=0; x<custs.size(); x++){
										  		Vendor cu = (Vendor)custs.get(x);
												
										  %>
                                                          <option <%if(crd.getCustomerId()==cu.getOID()){%>selected<%}%> value="<%=cu.getOID()%>"><%=cu.getCode()+" - "+cu.getName()%></option>
                                                          <%}}else{%>
                                                          <option>select ..</option>
                                                          <%}%>
                                                        </select>
                                                      </td>
                                                      <td class="<%=cssName%>" width="10%"> 
                                                        <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_COA_ID]%>">
                                                          <%if(incomeCoas!=null && incomeCoas.size()>0){
											for(int x=0; x<incomeCoas.size(); x++){
												Coa coax = (Coa)incomeCoas.get(x);
												
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
												
										%>
                                                          <option value="<%=coax.getOID()%>" <%if(crd.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
                                                          <%}}%>
                                                        </select>
                                                        <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_COA_ID) %> </td>
                                                      <td width="6%" class="<%=cssName%>"> 
                                                        <div align="center"> 
                                                          <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
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
                                                      <td width="13%" class="<%=cssName%>"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                          <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                      </td>
                                                      <td width="12%" class="<%=cssName%>"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>"  class="readonly rightalign" readOnly>
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="<%=cssName%>"> 
                                                        <div align="center"> 
                                                          <input type="hidden" name="edit_amount" value="<%=crd.getAmount()%>">
                                                          <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                          <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_AMOUNT) %> </div>
                                                      </td>
                                                      <td width="46%" class="<%=cssName%>"> 
                                                        <div align="left"> 
                                                          <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_MEMO]%>" size="25" value="<%=crd.getMemo()%>">
                                                        </div>
                                                      </td>
                                                    </tr>
                                                    <%}else{%>
                                                    <tr> 
                                                      <td class="<%=cssName%>" nowrap width="10%">
													  <%
												Vendor cx = new Vendor();
												try{
													cx = DbVendor.fetchExc(crd.getCustomerId());
												}
												catch(Exception e){
												}
												%>
                                                        <%if(cashReceive.getOID()==0){%>
                                                        <a href="javascript:cmdEdit('<%=i%>')"><%=cx.getCode()+" - "+cx.getName()%></a> 
                                                        <%}else{%>
                                                        <%=cx.getCode()+" - "+cx.getName()%> 
                                                        <%}%>
													  </td>
                                                      <td class="<%=cssName%>" nowrap width="10%"> 
                                                        
                                                        <%=c.getCode()%> 
                                                        &nbsp;-&nbsp; <%=c.getName()%></td>
                                                      <td width="6%" class="<%=cssName%>"> 
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
                                                      <td width="13%" class="<%=cssName%>"> 
                                                        <div align="right"> <%=JSPFormater.formatNumber(crd.getForeignAmount(), "#,###.##")%> </div>
                                                      </td>
                                                      <td width="12%" class="<%=cssName%>"> 
                                                        <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>
                                                      </td>
                                                      <td width="13%" class="<%=cssName%>"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(crd.getAmount(), "#,###.##")%></div>
                                                      </td>
                                                      <td width="46%" class="<%=cssName%>"><%=crd.getMemo()%></td>
                                                    </tr>
                                                    <%}%>
                                                    <%}}%>
                                                    <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && recIdx==-1 ){%>
                                                    <tr> 
                                                      <td class="tablecell" width="10%"> 
                                                        <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_CUSTOMER_ID]%>">
                                                          <%if(custs!=null && custs.size()>0){
										  for(int x=0; x<custs.size(); x++){
										  		Vendor cu = (Vendor)custs.get(x);
												
										  %>
                                                          <option <%if(cashReceiveDetail.getCustomerId()==cu.getOID()){%>selected<%}%> value="<%=cu.getOID()%>"><%=cu.getCode()+" - "+cu.getName()%></option>
                                                          <%}}else{%>
                                                          <option>select ..</option>
                                                          <%}%>
                                                        </select>
                                                      </td>
                                                      <td class="tablecell" width="10%"> 
                                                        <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_COA_ID]%>">
                                                          <%if(incomeCoas!=null && incomeCoas.size()>0){
											for(int x=0; x<incomeCoas.size(); x++){
												Coa coax = (Coa)incomeCoas.get(x);
												
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
												
										%>
                                                          <option value="<%=coax.getOID()%>" <%if(cashReceiveDetail.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
                                                          <%}}%>
                                                        </select>
                                                        <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_COA_ID) %> </td>
                                                      <td width="6%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <select name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                            <%if(currencies!=null && currencies.size()>0){
										  		for(int x=0; x<currencies.size(); x++){
													Currency c = (Currency)currencies.get(x);
										  %>
                                                            <option value="<%=c.getOID()%>" <%if(cashReceiveDetail.getForeignCurrencyId()==c.getOID()){%>selected<%}%>><%=c.getCurrencyCode()%></option>
                                                            <%}}%>
                                                          </select>
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_FOREIGN_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getForeignAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                          <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_FOREIGN_AMOUNT) %> </div>
                                                      </td>
                                                      <td width="12%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getBookedRate(), "#,###.##")%>" style="text-align:right"  class="readonly rightalign" readOnly>
                                                        </div>
                                                      </td>
                                                      <td width="13%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber(cashReceiveDetail.getAmount(), "#,###.##")%>" style="text-align:right" size="15"  class="readonly rightalign" readOnly>
                                                          <%= jspCashReceiveDetail.getErrorMsg(JspCashReceiveDetail.JSP_AMOUNT) %> </div>
                                                      </td>
                                                      <td width="46%" class="tablecell"> 
                                                        <div align="left"> 
                                                          <input type="text" name="<%=JspCashReceiveDetail.colNames[JspCashReceiveDetail.JSP_MEMO]%>" size="25" value="<%=cashReceiveDetail.getMemo()%>">
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
                                                          <%if(iErrCodeRec==0 || iErrCode!=0){%>
                                                          <tr> 
                                                            <td> 
                                                              <%
										  
										  if(cashReceive.getOID()==0){
										  
										  if(iJSPCommand!=JSPCommand.ADD && iJSPCommand!=JSPCommand.EDIT && iJSPCommand!=JSPCommand.ASK && iErrCode==0 && iErrCodeRec==0){
										  	
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
											  	
											  	if((iJSPCommand==JSPCommand.SUBMIT || iJSPCommand==JSPCommand.POST) && (iErrCode!=0 || iErrCodeRec!=0)){
													iJSPCommand = JSPCommand.SAVE;
												}
												
												//=================================================================
											  
												ctrLine.setLocationImg(approot+"/images/ctr_line");
												ctrLine.initDefault();
												ctrLine.setTableWidth("90%");
												String scomDel = "javascript:cmdAsk('"+oidCashReceiveDetail+"')";
												String sconDelCom = "javascript:cmdConfirmDelete('"+oidCashReceiveDetail+"')";
												String scancel = "javascript:cmdEdit('"+oidCashReceiveDetail+"')";
												if(listCashReceiveDetail!=null && listCashReceiveDetail.size()>0){
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
												
												if(iErrCode==0 && iErrCodeRec!=0){
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
                                                                  <td width="253" nowrap><%=msgStringRec%></td>
                                                                </tr>
                                                              </table>
                                                            </td>
                                                          </tr>
                                                          <tr> 
                                                            <td height="5"></td>
                                                          </tr>
                                                          <tr> 
                                                            <td><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new111','','../images/close2.gif',1)"></a> 
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
										//out.println("<br>cashReceive.getAmount() : "+cashReceive.getAmount());
										
										balance = cashReceive.getAmount() - totalDetail;
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
                                            </table>
                                          </td>
                                        </tr>
                                        <% 
						  }catch(Exception exc){ 
						  }%>
                                        <%if(cashReceive.getAmount()!=0 && iErrCode==0 && iErrCodeRec==0 && balance==0 && cashReceive.getOID()==0){%>
                                        <tr align="left" valign="top"> 
                                          <td height="1" valign="middle" colspan="3" width="99%"> 
                                            <table width="99%" border="0" cellspacing="0" cellpadding="0">
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
                                          <td valign="middle" colspan="3" width="99%"> 
                                            <table width="99%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="11%"><a href="javascript:cmdSubmitCommand()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                                <td width="63%">&nbsp;</td>
                                                <td width="26%"> 
                                                  <table border="0" cellpadding="5" cellspacing="0" class="info" width="219" align="right">
                                                    <tr> 
                                                      <td width="16"><img src="../images/inform.gif" width="20" height="20"></td>
                                                      <td width="183" nowrap>Journal 
                                                        is ready to be posted</td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%}%>
                                        <%if(cashReceive.getOID()!=0){%>
                                        <tr align="left" valign="top"> 
                                          <td height="1" valign="middle" colspan="3" width="99%"> 
                                            <table width="99%" border="0" cellspacing="0" cellpadding="0">
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
                                          <td valign="middle" colspan="3" width="99%"> 
                                            <table width="99%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="6%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                <td width="8%"><a href="javascript:cmdNewJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1','','../images/new2.gif',1)"><img src="../images/new.gif" name="new1" width="71" height="22" border="0"></a></td>
                                                <td width="45%"><a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a></td>
                                                <td width="41%"> 
                                                  <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                    <tr> 
                                                      <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                      <td width="220">Journal 
                                                        has been posted successfully</td>
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
							<%if(iErrCode!=0 || iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT){%>
								//alert("in error javascript");
								cmdUpdateExchange();
							<%}%>
							</script>
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
