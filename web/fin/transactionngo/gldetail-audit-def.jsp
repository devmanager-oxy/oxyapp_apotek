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
boolean glPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_NEWGL);
%>
<!-- Jsp Block -->
<%!

	
	public Vector addNewDetail(Vector listGlDetail, GlDetail glDetail){
		boolean found = false;
		if(listGlDetail!=null && listGlDetail.size()>0){
			for(int i=0; i<listGlDetail.size(); i++){
				GlDetail cr = (GlDetail)listGlDetail.get(i);
				if(cr.getCoaId()==glDetail.getCoaId() && cr.getForeignCurrencyId()==glDetail.getForeignCurrencyId()){
					//jika coa sama dan currency sama lakukan penggabungan
					cr.setForeignCurrencyAmount(cr.getForeignCurrencyAmount()+glDetail.getForeignCurrencyAmount());
					if(cr.getDebet()>0 && glDetail.getDebet()>0){
						cr.setDebet(cr.getDebet()+glDetail.getDebet());
						found = true;
					}
					else{
					
						if(cr.getCredit()>0 && glDetail.getCredit()>0){
							cr.setCredit(cr.getCredit()+glDetail.getCredit());
							found = true;
						}
					}
					
				}
			}
		}
		
		if(!found){
			listGlDetail.add(glDetail);
		}
		
		return listGlDetail;
	}
	
	public double getTotalDetail(Vector listx, int typex){
		double result = 0;
		if(listx!=null && listx.size()>0){
			for(int i=0; i<listx.size(); i++){
				GlDetail crd = (GlDetail)listx.get(i);
				//debet
				if(typex==0){
					result = result + crd.getDebet();
				}
				//credit
				else{
					result = result + crd.getCredit();
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
long oidGl = JSPRequestValue.requestLong(request, "hidden_gl_id");
long oidGlDetail = JSPRequestValue.requestLong(request, "hidden_gl_detail_id");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");

int nonAct = JSPRequestValue.requestInt(request, "set_non_act");




/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";


Gl gl = new Gl();
try{
	gl = DbGl.fetchExc(oidGl);
}
catch(Exception e){
}

boolean glUpdate = false;
if(iJSPCommand==JSPCommand.SAVE){
	String note = JSPRequestValue.requestString(request, JspGl.colNames[JspGl.JSP_MEMO]); 
	if(note.length()>0){	
		gl.setMemo(note);
		DbGl.updateExc(gl);
		glUpdate = true;	
	}
}

GlDetail glDetail = new GlDetail();

if(iJSPCommand==JSPCommand.POST){
	
	//out.println("post item");

	try{
		glDetail = DbGlDetail.fetchExc(oidGlDetail);
	}
	catch(Exception e){
	}
	
	JspGlDetail jdt = new JspGlDetail(request, glDetail);
	jdt.requestEntityObject(glDetail);
	
	//out.println("glDetail.getDebet() : "+glDetail.getDebet());
	//out.println("glDetail.getCredit() : "+glDetail.getCredit());
	//out.println("jdt.getErrors() : "+jdt.getErrors());
	
	if(jdt.errorSize()>0) {
		glUpdate = false;//"error saving item .."
		//out.println("error ne bli ...");
	}		
	else{
		//out.println("update item");
		//out.println("oidGlDetail : "+oidGlDetail);
		
		//glDetail.setGlId(oidGl);
		//glDetail.setOID(oidGlDetail);
		
		GlDetail glDetailOld = new GlDetail();
		try{
			glDetailOld = DbGlDetail.fetchExc(oidGlDetail);
			
			glDetailOld.setDebet(glDetail.getDebet());
			glDetailOld.setCredit(glDetail.getCredit());
			glDetailOld.setDepartmentId(glDetail.getDepartmentId());
			glDetailOld.setCoaId(glDetail.getCoaId());			
			glDetailOld.setForeignCurrencyId(glDetail.getForeignCurrencyId());
			glDetailOld.setForeignCurrencyAmount(glDetail.getForeignCurrencyAmount());
			glDetailOld.setMemo(glDetail.getMemo());
			glDetailOld.setBookedRate(glDetail.getBookedRate());
			glDetailOld.setIsDebet(glDetail.getIsDebet());
			glDetailOld.setDepartmentId(glDetail.getDepartmentId());
			glDetailOld.setSectionId(glDetail.getSectionId());
			
			DbGlDetail.updateExc(glDetailOld);
			
			glUpdate = true;	
			
		}
		catch(Exception e){
			out.println(e.toString());
		}
					
	}
}




Vector listGlDetail = DbGlDetail.list(0,0, "gl_id="+gl.getOID(), "");

//out.println("<br>"+listGlDetail);



String wherex = "(location_id="+sysLocation.getOID()+" or location_id=0)";


Vector incomeCoas = DbCoa.list(0,0, wherex, "code");

Vector currencies = DbCurrency.list(0,0,"", "");

ExchangeRate eRate = DbExchangeRate.getStandardRate();

int vectSize = DbGlDetail.getCount(whereClause);


double totalDebet = getTotalDetail(listGlDetail, 0);
double totalCredit = getTotalDetail(listGlDetail, 1);


String whereDep = "";

Vector deps = DbDepartment.list(0,0, whereDep, "code");

int iErrCodeMain  = 0;
double balance = 0;

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<!--



function cmdSaveDoc(){
	document.frmgl.command.value="<%=JSPCommand.SAVE%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdSaveItem(){
	document.frmgl.command.value="<%=JSPCommand.POST%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

<%if(!glPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

//=======================================update===========================================================

function cmdDepartment(){
	var oid = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>.value;
	<%if(deps!=null && deps.size()>0){
		for(int i=0; i<deps.size(); i++){
			Department d = (Department)deps.get(i);
	%>
			if(oid=='<%=d.getOID()%>'){
				<%if(d.getType().equals(I_Project.ACCOUNT_LEVEL_HEADER)){
					Department d0 = (Department)deps.get(0);
				%>
					alert("Non postable department\nplease select another department");
					document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>.value="<%=d0.getOID()%>";
				<%}%>
			}
	<%}}%>
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptGLPDF?oid=<%=appSessUser.getLoginId()%>&gl_id=<%=gl.getOID()%>");
}

function cmdClickMe(){
	var x = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;	
	document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.select();
}

function cmdFixing(){	
	document.frmgl.command.value="<%=JSPCommand.POST%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();	
}

function cmdNewJournal(){	
	document.frmgl.command.value="<%=JSPCommand.NONE%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();	
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
	var st = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;		
	
	result = removeChar(st);
	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
}

function checkNumber2(){
	
	//alert("in check number 2");
	
	var main = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;		
	main = cleanNumberFloat(main, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var currTotal = document.frmgl.total_detail.value;
	currTotal = cleanNumberFloat(currTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);				
	var idx = document.frmgl.select_idx.value;		
	var booked = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;		
	booked = cleanNumberFloat(booked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var st = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;		
	result = removeChar(st);	
	result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var result2 = 0;
	
	//alert("main : "+main+", currTotal : "+currTotal+", idx : "+idx+", booked : "+booked+", result : "+result);
	
	//add
	if(parseFloat(idx)<0){

		var amount = parseFloat(currTotal) + parseFloat(result);
		document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		/*alert("amount : "+amount+", main : "+main+", idx  xxx ");
		
		if(amount>parseFloat(main)){
			alert("Amount over the maximum allowed, \nsystem will reset the data");
			result = parseFloat(main)-parseFloat(currTotal);
			result2 = result/parseFloat(booked);			
			document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value = formatFloat(result2, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
			result2 = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
			result2 = cleanNumberFloat(result2, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			
			alert("result2 : "+result2);
			
			document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value = formatFloat(parseFloat(result2) * parseFloat(booked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		}*/
	}
	//edit
	else{
		var editAmount =  document.frmgl.edit_amount.value;
		var amount = parseFloat(currTotal) - parseFloat(editAmount) + parseFloat(result);
		document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value=formatFloat(amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		
		/*if(amount>parseFloat(main)){
			alert("Amount over the maximum allowed, \nsystem will reset the data");
			result = parseFloat(main)-(parseFloat(currTotal)-parseFloat(editAmount));
			result2 = result/parseFloat(booked);
			document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value = formatFloat(result2, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
			result2 = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
			result2 = cleanNumberFloat(result2, sysDecSymbol, usrDigitGroup, usrDecSymbol);
			alert("result2 : "+result2);
			document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value = formatFloat(parseFloat(result2) * parseFloat(booked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		}*/
	}
	
	
}

function updateDebetCredit(){
	var dbt = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>.value;
	var amount = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
	var erate = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;
	amount = removeChar(amount);
	amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	erate = removeChar(erate);
	erate = cleanNumberFloat(erate, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	//alert(dbt+", amount : "+amount+", erate : "+erate);
	//debet
	if(parseInt(dbt)==0){
		document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value = formatFloat(parseFloat(amount) * parseFloat(erate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value = "0";
	}
	//credit
	else{
		document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value = formatFloat(parseFloat(amount) * parseFloat(erate), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
		document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value = "0";
	}
}

function cmdUpdateExchange(){
	
	<%if(iJSPCommand!=JSPCommand.BACK && !((iJSPCommand==JSPCommand.SUBMIT || iJSPCommand==JSPCommand.SAVE) && iErrCode==0)){%>	
		
		var isDebet = 0;
		
		isDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>.value; 
		
		var idCurr = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>.value;
		
		<%if(currencies!=null && currencies.size()>0){
			for(int i=0; i<currencies.size(); i++){
				Currency cx = (Currency)currencies.get(i);
		%>
				if(idCurr=='<%=cx.getOID()%>'){
					<%if(cx.getCurrencyCode().equals(IDRCODE)){%>
						document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value="<%=eRate.getValueIdr()%>";
					<%}
					else if(cx.getCurrencyCode().equals(USDCODE)){%>
						document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value = formatFloat(<%=eRate.getValueUsd()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueUsd()%>";
					<%}
					else if(cx.getCurrencyCode().equals(EURCODE)){%>
						document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value= formatFloat(<%=eRate.getValueEuro()%>, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //"<%=eRate.getValueEuro()%>";
					<%}%>
				}	
		<%}}%>
		
		var famount = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value;
		
		famount = removeChar(famount);
		famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert(famount);
		
		var fbooked = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>.value;
		fbooked = cleanNumberFloat(fbooked, sysDecSymbol, usrDigitGroup, usrDecSymbol);
		
		//alert(fbooked);
		
		if(!isNaN(famount)){
			if(parseInt(isDebet)==0){
				
				var defaultDebet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
				defaultDebet = cleanNumberFloat(defaultDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
				
				var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
				credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				var totalCredit = document.frmgl.total_credit.value;
				totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) - parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;		
				
				var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
				debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				var totalDebet = document.frmgl.total_debet.value;
				totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(defaultDebet) + parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;		
				
				document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= "0.00";//formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
			}
			else{			
				
				var defaultCredit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
				defaultCredit = cleanNumberFloat(defaultCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				
				document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value= formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
				
				var debet = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value;
				debet = cleanNumberFloat(debet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				var totalDebet = document.frmgl.total_debet.value;
				totalDebet = cleanNumberFloat(totalDebet, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				document.frmgl.total_debet.value= formatFloat(parseFloat(totalDebet) - parseFloat(debet), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;		
				
				var credit = document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>.value;
				credit = cleanNumberFloat(credit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				var totalCredit = document.frmgl.total_credit.value;
				totalCredit = cleanNumberFloat(totalCredit, sysDecSymbol, usrDigitGroup, usrDecSymbol);
				document.frmgl.total_credit.value= formatFloat(parseFloat(totalCredit) -parseFloat(defaultCredit) + parseFloat(credit), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;		
				
				document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value= "0.00";//formatFloat(parseFloat(famount) * parseFloat(fbooked), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); //;
			}
			document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>.value= formatFloat(famount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
			//alert('!isNaN');		
		}
	<%}%>	
	
	var totalDebetx = document.frmgl.total_debet.value;
	totalDebetx = cleanNumberFloat(totalDebetx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	var totalCreditx = document.frmgl.total_credit.value;
	totalCreditx = cleanNumberFloat(totalCreditx, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	if(parseFloat(totalDebetx)==parseFloat(totalCreditx)){
		document.all.tot_balance.innerHTML = "-";//formatFloat(parseFloat(totalDebetx)-parseFloat(totalCreditx), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
	else{	
		document.all.tot_balance.innerHTML = formatFloat(parseFloat(totalDebetx)-parseFloat(totalCreditx), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
	
	//checkNumber2();
}

function cmdActivity(oid){
	<%if(oidGl!=0){%>
		document.frmgl.hidden_gl_id.value=oid;
		document.frmgl.command.value="<%=JSPCommand.NONE%>";
		document.frmgl.prev_command.value="<%=prevJSPCommand%>";
		document.frmgl.action="glactivity.jsp";
		document.frmgl.submit();
	<%}else{%>
		alert('Please finish and post this journal before continue to activity data.');
	<%}%>
	
}

//===============================================================================================

function cmdAdd(){	
	document.frmgl.select_idx.value="-1";
	document.frmgl.hidden_gl_id.value="0";
	document.frmgl.hidden_gl_detail_id.value="0";
	document.frmgl.command.value="<%=JSPCommand.ADD%>";
	document.frmgl.prev_command.value="<%=prevJSPCommand%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdAsk(oidGlDetail){
	document.frmgl.select_idx.value=oidGlDetail;
	document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
	document.frmgl.command.value="<%=JSPCommand.ASK%>";
	document.frmgl.prev_command.value="<%=prevJSPCommand%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdConfirmDelete(oidGlDetail){
	document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
	document.frmgl.command.value="<%=JSPCommand.DELETE%>";
	document.frmgl.prev_command.value="<%=prevJSPCommand%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdSave(){
	document.frmgl.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmgl.prev_command.value="<%=prevJSPCommand%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdSubmitCommand(){
	document.frmgl.command.value="<%=JSPCommand.SAVE%>";
	document.frmgl.prev_command.value="<%=prevJSPCommand%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdEdit(x, oidGlDetail){
	document.frmgl.select_idx.value=x;
	document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
	document.frmgl.command.value="<%=JSPCommand.EDIT%>";
	document.frmgl.prev_command.value="<%=prevJSPCommand%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdCancel(oidGlDetail){
	document.frmgl.hidden_gl_detail_id.value=oidGlDetail;
	document.frmgl.command.value="<%=JSPCommand.EDIT%>";
	document.frmgl.prev_command.value="<%=prevJSPCommand%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdBack(){
	document.frmgl.command.value="<%=JSPCommand.BACK%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdListFirst(){
	document.frmgl.command.value="<%=JSPCommand.FIRST%>";
	document.frmgl.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdListPrev(){
	document.frmgl.command.value="<%=JSPCommand.PREV%>";
	document.frmgl.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdListNext(){
	document.frmgl.command.value="<%=JSPCommand.NEXT%>";
	document.frmgl.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}

function cmdListLast(){
	document.frmgl.command.value="<%=JSPCommand.LAST%>";
	document.frmgl.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmgl.action="gldetail-audit.jsp";
	document.frmgl.submit();
}





//-------------- script form image -------------------

function cmdDelPict(oidGlDetail){
	document.frmimage.hidden_gl_detail_id.value=oidGlDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="gldetail-audit.jsp";
	document.frmimage.submit();
}

//-------------- script control line -------------------
//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
					  String navigator = "<font class=\"lvl1\">General Journal</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Journal Detail</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmgl" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_gl_detail_id" value="<%=oidGlDetail%>">
                          <input type="hidden" name="hidden_gl_id" value="<%=oidGl%>">
                          <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="select_idx" value="<%=recIdx%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_TYPE]%>" value="<%=I_Project.JOURNAL_TYPE_GENERAL_LEDGER%>">
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
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="23%">&nbsp;</td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="55%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Journal Number</td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="23%"> 
                                                  <%
									  int counter = DbGl.getNextCounter();
									  String strNumber = DbGl.getNextNumber(counter);
									  
									  if(gl.getOID()!=0){
									  		//out.println("in oid nol");									  
											strNumber = gl.getJournalNumber();
									  }
									  
									  %>
                                                  <%=strNumber%> 
                                                  <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_NUMBER]%>">
                                                  <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_COUNTER]%>">
                                                  <input type="hidden" name="<%=JspGl.colNames[JspGl.JSP_JOURNAL_PREFIX]%>">
                                                </td>
                                                <td width="9%">Transaction Date</td>
                                                <td width="55%"> 
                                                  <input name="<%=JspGl.colNames[JspGl.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((gl.getTransDate()==null) ? new Date() : gl.getTransDate(), "dd/MM/yyyy")%>" size="11">
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmgl.<%=JspGl.colNames[JspGl.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Reference Number</td>
                                                <td width="3%">&nbsp;</td>
                                                <td width="23%"> 
                                                  <input type="text" name="<%=JspGl.colNames[JspGl.JSP_REF_NUMBER]%>" size="35" value="<%=gl.getRefNumber()%>">
                                                </td>
                                                <td width="9%">&nbsp;</td>
                                                <td width="55%">&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Memo</td>
                                                <td width="3%">&nbsp;</td>
                                                <td colspan="3"> 
                                                  <textarea name="<%=JspGl.colNames[JspGl.JSP_MEMO]%>" cols="120" rows="2"><%=gl.getMemo()%></textarea>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="14" valign="middle" colspan="3" class="comment"> 
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
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                <td class="tab">Journal</td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"> 
                                                  <%
												//out.println("gl.getNotActivityBase() : "+gl.getNotActivityBase());
												%>
                                                </td>
                                                <%if(gl.getNotActivityBase()==0){%>
                                                <td class="tabin"> 
                                                  <%if(true){%>
                                                  <a href="javascript:cmdActivity('<%=oidGl%>')" class="tablink">Activity</a> 
                                                  <%}else{%>
                                                  <a href="#" class="tablink" title="petty cash payment required">Activity</a> 
                                                  <%}%>
                                                </td>
                                                <%}else{%>
                                                <td nowrap class="tabheader"><font color="#FF0000">&nbsp;GL 
                                                  with no expense account, ( Non 
                                                  activity transaction )</font></td>
                                                <%}%>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"><font color="#FF0000"> 
                                                  </font></td>
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
                                                      <td rowspan="2"  class="tablehdr" nowrap width="21%">Account 
                                                        - Description</td>
                                                      <td rowspan="2" class="tablehdr" width="19%">Department 
                                                      </td>
                                                      <td colspan="2" class="tablehdr">Currency</td>
                                                      <td rowspan="2" class="tablehdr" width="7%">Booked 
                                                        Rate</td>
                                                      <td rowspan="2" class="tablehdr" width="15%">Debet 
                                                        <%=baseCurrency.getCurrencyCode()%></td>
                                                      <td rowspan="2" class="tablehdr" width="15%">Credit 
                                                        <%=baseCurrency.getCurrencyCode()%> </td>
                                                      <td rowspan="2" class="tablehdr" width="15%">Description</td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="4%" class="tablehdr">Code</td>
                                                      <td width="19%" class="tablehdr"> 
                                                        Amount</td>
                                                    </tr>
                                                    <%if(listGlDetail!=null && listGlDetail.size()>0){
										for(int i=0; i<listGlDetail.size(); i++){
											GlDetail crd = (GlDetail)listGlDetail.get(i);
											
											if(crd.getDebet()>0){
												crd.setIsDebet(0);
											}
											else{
												crd.setIsDebet(1);
											}
											
											Coa c = new Coa();
											try{
												c = DbCoa.fetchExc(crd.getCoaId());
											}
											catch(Exception e){
											}
											
									%>
                                                    <%
									
									if(((iJSPCommand==JSPCommand.EDIT || iJSPCommand==JSPCommand.ASK) || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && i==recIdx){%>
                                                    <tr> 
                                                      <td class="tablecell" width="21%"> 
                                                        <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_COA_ID]%>">
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
                                                      </td>
                                                      <td width="19%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment()">
                                                            <option value="0">TOTAL 
                                                            CORPORATE</option>
                                                            <%if(deps!=null && deps.size()>0){
																		long oidx = crd.getDepartmentId();
																		if(crd.getSectionId()!=0){
																			oidx = crd.getSectionId();
																		}
																		if(crd.getSubSectionId()!=0){
																			oidx = crd.getSubSectionId();
																		}
																		if(crd.getJobId()!=0){
																			oidx = crd.getJobId();
																		}
															
															
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
                                                            <option value="<%=d.getOID()%>" <%if(oidx==d.getOID()){%>selected<%}%>><%=str+d.getCode()+" - "+d.getName()%></option>
                                                            <%}}%>
                                                          </select>
                                                        </div>
                                                      </td>
                                                      <td width="4%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
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
                                                      <td width="19%" class="tablecell" nowrap> 
                                                        <div align="center"> 
                                                          <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>" onChange="javascript:updateDebetCredit()">
                                                            <option value="0" <%if(crd.getIsDebet()==0){%>selected<%}%>>DEBET</option>
                                                            <option value="1" <%if(crd.getIsDebet()==1){%>selected<%}%>>CREDIT</option>
                                                          </select>
                                                          <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>" size="20" value="<%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%>" style="text-align:right" readOnly class="readonly">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        <div align="right"> 
                                                          <input type="hidden" name="edit_amount" value="<%=crd.getDebet()%>">
                                                          <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>" value="<%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%>" style="text-align:right" size="20" readOnly class="readonly">
                                                          <input type="hidden" name="default_debet">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        <div align="right"> 
                                                          <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>" value="<%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%>" style="text-align:right" size="20" readOnly class="readonly">
                                                          <input type="hidden" name="default_credit">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell"><%=crd.getMemo()%></td>
                                                    </tr>
                                                    <%}else{%>
                                                    <tr> 
                                                      <td class="tablecell" nowrap width="21%" height="17"> 
                                                        <a href="javascript:cmdEdit('<%=i%>','<%=crd.getOID()%>')"> 
                                                        <%if(gl.getOID()==0){%>
                                                        <%=c.getCode()%> 
                                                        <%}else{%>
                                                        <%=c.getCode()%> 
                                                        <%}%>
                                                        &nbsp;-&nbsp; <%=c.getName()%></a></td>
                                                      <td width="19%" class="tablecell" height="17" nowrap> 
                                                        <%if(crd.getDepartmentId()==0){%>
                                                        TOTAL CORPORATE 
                                                        <%}else{
															long oidx = crd.getDepartmentId();
															if(crd.getSectionId()!=0){
																oidx = crd.getSectionId();
															}
															if(crd.getSubSectionId()!=0){
																oidx = crd.getSubSectionId();
															}
															if(crd.getJobId()!=0){
																oidx = crd.getJobId();
															}
														
														    Department d = new Department();
														    try{
																d = DbDepartment.fetchExc(oidx);
														    }
														  	catch(Exception e){
														    }
																  
															%>
                                                        <%=d.getCode()+" - "+d.getName()%> 
                                                        <%}%>
                                                      </td>
                                                      <td width="4%" class="tablecell" height="17"> 
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
                                                      <td width="19%" class="tablecell" height="17"> 
                                                        <div align="right"> <%=JSPFormater.formatNumber(crd.getForeignCurrencyAmount(), "#,###.##")%> </div>
                                                      </td>
                                                      <td width="7%" class="tablecell" height="17"> 
                                                        <div align="right"> <%=JSPFormater.formatNumber(crd.getBookedRate(), "#,###.##")%> </div>
                                                      </td>
                                                      <td width="15%" class="tablecell" height="17"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(crd.getDebet(), "#,###.##")%></div>
                                                      </td>
                                                      <td width="15%" class="tablecell" height="17"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(crd.getCredit(), "#,###.##")%></div>
                                                      </td>
                                                      <td width="15%" class="tablecell" height="17"><%=crd.getMemo()%></td>
                                                    </tr>
                                                    <%}%>
                                                    <%}}%>
                                                    <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SUBMIT && (iErrCode!=0 || iErrCodeMain!=0))) && recIdx==-1){%>
                                                    <tr> 
                                                      <td class="tablecell" width="21%"> 
                                                        <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_COA_ID]%>">
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
                                                          <option value="<%=coax.getOID()%>" <%if(glDetail.getCoaId()==coax.getOID()){%>selected<%}%>><%=str+coax.getCode()+" - "+coax.getName()%></option>
                                                          <%}}%>
                                                        </select>
                                                      </td>
                                                      <td width="19%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEPARTMENT_ID]%>" onChange="javascript:cmdDepartment()">
                                                            <option value="0">TOTAL 
                                                            CORPORATE</option>
                                                            <%if(deps!=null && deps.size()>0){
																		
																		long oidx = glDetail.getDepartmentId();
																		if(glDetail.getSectionId()!=0){
																			oidx = glDetail.getSectionId();
																		}
																		if(glDetail.getSubSectionId()!=0){
																			oidx = glDetail.getSubSectionId();
																		}
																		if(glDetail.getJobId()!=0){
																			oidx = glDetail.getJobId();
																		}
															
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
                                                            <option value="<%=d.getOID()%>" <%if(oidx==d.getOID()){%>selected<%}%>><%=str+d.getCode()+" - "+d.getName()%></option>
                                                            <%}}%>
                                                          </select>
                                                        </div>
                                                      </td>
                                                      <td width="4%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_ID]%>" onChange="javascript:cmdUpdateExchange()">
                                                            <%if(currencies!=null && currencies.size()>0){
										  		for(int x=0; x<currencies.size(); x++){
													Currency c = (Currency)currencies.get(x);
										  %>
                                                            <option value="<%=c.getOID()%>" <%if(glDetail.getForeignCurrencyId()==c.getOID()){%>selected<%}%>><%=c.getCurrencyCode()%></option>
                                                            <%}}%>
                                                          </select>
                                                        </div>
                                                      </td>
                                                      <td width="19%" class="tablecell" nowrap> 
                                                        <div align="center"> 
                                                          <select name="<%=JspGlDetail.colNames[JspGlDetail.JSP_IS_DEBET]%>" onChange="javascript:updateDebetCredit()">
                                                            <option value="0" <%if(glDetail.getIsDebet()==0){%>selected<%}%>>DEBET</option>
                                                            <option value="1" <%if(glDetail.getIsDebet()==1){%>selected<%}%>>CREDIT</option>
                                                          </select>
                                                          <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_FOREIGN_CURRENCY_AMOUNT]%>" size="20" value="<%=JSPFormater.formatNumber(glDetail.getForeignCurrencyAmount(), "#,###.##")%>" style="text-align:right" onBlur="javascript:cmdUpdateExchange()" onClick="javascript:cmdClickMe()">
                                                        </div>
                                                      </td>
                                                      <td width="7%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_BOOKED_RATE]%>" size="7" value="<%=JSPFormater.formatNumber(glDetail.getBookedRate(), "#,###.##")%>" style="text-align:right" readOnly class="readonly">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>" value="<%=JSPFormater.formatNumber(glDetail.getDebet(), "#,###.##")%>" style="text-align:right" size="20" readOnly class="readonly">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="<%=JspGlDetail.colNames[JspGlDetail.JSP_CREDIT]%>" value="<%=JSPFormater.formatNumber(glDetail.getCredit(), "#,###.##")%>" style="text-align:right" size="20" readOnly class="readonly">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell"><%=glDetail.getMemo()%></td>
                                                    </tr>
                                                    <%}%>
                                                    <tr> 
                                                      <td class="tablecell" colspan="5" height="1"></td>
                                                      <td width="15%" class="tablecell" height="1"> 
                                                        <div align="right"></div>
                                                      </td>
                                                      <td width="15%" class="tablecell" height="1"> 
                                                        <div align="right"></div>
                                                      </td>
                                                      <td width="15%" class="tablecell" height="1">&nbsp;</td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="5"> 
                                                        <div align="right"><b>TOTAL 
                                                          : </b></div>
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="total_debet" value="<%=JSPFormater.formatNumber(totalDebet, "#,###.##")%>" style="text-align:right" size="20" readOnly class="readonly">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell"> 
                                                        <div align="center"> 
                                                          <input type="text" name="total_credit" value="<%=JSPFormater.formatNumber(totalCredit, "#,###.##")%>" style="text-align:right" size="20" readOnly class="readonly">
                                                        </div>
                                                      </td>
                                                      <td width="15%" class="tablecell">&nbsp;</td>
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
							try{
							%>
                                  <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="25%">&nbsp;</td>
                                          <td width="52%">&nbsp;</td>
                                          <td width="23%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="25%">&nbsp; </td>
                                          <td width="52%"> 
                                            <div align="right"></div>
                                          </td>
                                          <td width="23%" class="boxed1"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="41%" nowrap><b>Out 
                                                  of Balance <%=baseCurrency.getCurrencyCode()%> :</b></td>
                                                <td width="59%"> 
                                                  <div align="right"><b><a id="tot_balance"></a></b></div>
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
                                  <%if(totalDebet>0 && iErrCode==0 && iErrCode==0 && balance==0 && gl.getOID()==0){%>
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
                                    <td valign="middle" colspan="3">&nbsp; </td>
                                  </tr>
                                  <%}%>
                                  <%if(gl.getOID()!=0){%>
                                  <tr align="left" valign="top"> 
                                    <td height="1" valign="middle" colspan="3"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td height="2"> 
                                            <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="34%"><a href="javascript:cmdSaveDoc()"><img src="../images/savedoc.gif" width="115" height="22" border="0"></a></td>
                                                <td width="65%"><a href="javascript:cmdSaveItem()"><img src="../images/save.gif" width="55" height="22" border="0"></a></td>
                                                <td width="0%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="34%">&nbsp;</td>
                                                <td width="65%">&nbsp;</td>
                                                <td width="0%">&nbsp;</td>
                                                <td width="1%">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3">&nbsp; </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3"><%
										if( iJSPCommand==JSPCommand.SAVE){
										  if(glUpdate){%>
                                            <font color="#0000FF"> Sukses update 
                                            gl atau item ...</font> 
                                            <%}else{%>
                                      <font color="#FF0000">process error ...</font>
<%}}%></td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td valign="middle" colspan="3">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top">
                                    <td valign="middle" colspan="3">&nbsp;</td>
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
				//document.frmgl.<%=JspGlDetail.colNames[JspGlDetail.JSP_DEBET]%>.value="<%=JSPFormater.formatNumber(totalDebet, "#,###.##")%>";
				<%if(iJSPCommand==JSPCommand.ADD || iJSPCommand==JSPCommand.EDIT || iErrCode!=0){%>
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
