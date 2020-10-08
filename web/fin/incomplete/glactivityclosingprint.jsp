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

	
	
	
	public Vector addNewDetail(Vector listGlActivity, TransactionActivityDetail activityDetail){
		boolean found = false;
		//diblok sementara
		if(listGlActivity!=null && listGlActivity.size()>0){
			for(int i=0; i<listGlActivity.size(); i++){
				TransactionActivityDetail cr = (TransactionActivityDetail)listGlActivity.get(i);
				if(cr.getType()==activityDetail.getType() && cr.getModuleId()==activityDetail.getModuleId() && cr.getDonorId()==activityDetail.getDonorId()){
					//jika coa sama dan currency sama lakukan penggabungan					
					cr.setAmount(cr.getAmount()+activityDetail.getAmount());
					found = true;
				}
			}
		}
		
		if(!found){
			listGlActivity.add(activityDetail);
		}
		
		return listGlActivity;
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

//main data

int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidGl = JSPRequestValue.requestLong(request, "hidden_glarchive");
int recIdx = JSPRequestValue.requestInt(request, "select_idx");
ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();

//out.println("oidGl : "+oidGl);

//========================update===============================
if(iJSPCommand==JSPCommand.NONE){
	if(session.getValue("GLACTIVITY_DETAIL")!=null){
		session.removeValue("GLACTIVITY_DETAIL");
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

CmdGl ctrlGl = new CmdGl(request);

Vector listGl = new Vector(1,1);

/*switch statement */
int iErrCodeMain = 0;//ctrlGl.action(iJSPCommand , oidGl);
/* end switch*/
JspGl jspGl = ctrlGl.getForm();

/*count list All Gl*/
int vectSize = DbGl.getCount(whereClause);

Gl gl = new Gl();//ctrlGl.getGl();

try{
	gl = DbGl.fetchExc(oidGl);
}
catch(Exception e){
}

//out.println("gl : "+totalDebet);

String msgStringMain =  "";//ctrlGl.getMessage();

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
long oidTransactionActivityDetail = JSPRequestValue.requestLong(request, "hidden_gl_activity_id");

/*variable declaration*/
//int recordToGet = 10;
//String msgString = "";
//int iErrCode = JSPMessage.NONE;
//String whereClause = "";
//String orderClause = "";

CmdTransactionActivityDetail ctrlTransactionActivityDetail = new CmdTransactionActivityDetail(request);
//JSPLine ctrLine = new JSPLine();
Vector listGlActivity = new Vector(1,1);

/*switch statement */
iErrCode = ctrlTransactionActivityDetail.action(iJSPCommand , oidTransactionActivityDetail);
/* end switch*/
JspTransactionActivityDetail jspTransactionActivityDetail = ctrlTransactionActivityDetail.getForm();

//out.println(jspTransactionActivityDetail.getErrors());

TransactionActivityDetail pettycashActivityDetail = ctrlTransactionActivityDetail.getTransactionActivityDetail();
msgString =  ctrlTransactionActivityDetail.getMessage();

if(session.getValue("GLACTIVITY_DETAIL")!=null){
	listGlActivity = (Vector)session.getValue("GLACTIVITY_DETAIL");
}

if(iJSPCommand==JSPCommand.SUBMIT){
	if(iErrCode==0){
		if(recIdx==-1){		
			listGlActivity = addNewDetail(listGlActivity, pettycashActivityDetail);
			//listGlActivity.add(pettycashActivityDetail);
		}
		else{
			//listGlActivity.set(recIdx, pettycashActivityDetail);
			listGlActivity.remove(recIdx);
			listGlActivity = addNewDetail(listGlActivity, pettycashActivityDetail);
		}
	}
}
if(iJSPCommand==JSPCommand.DELETE){
	listGlActivity.remove(recIdx);
}

//out.println("<br>sebelum save : "+listGlActivity);

if(iJSPCommand==JSPCommand.SAVE){
	if(gl.getOID()!=0){
		long oidFlag = DbTransactionActivityDetail.saveAllDetail(oidGl, listGlActivity);
		DbGl.postActivityStatus(oidFlag, oidGl);
		//listGlActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+gl.getOID(), "");
	}
}

//out.println("jspTransactionActivityDetail : "+jspTransactionActivityDetail.getErrors());
//out.println("<br>"+listGlActivity);

session.putValue("GLACTIVITY_DETAIL", listGlActivity);

String wherex = "(account_group='"+I_Project.ACC_GROUP_EXPENSE+"' or account_group='"+I_Project.ACC_GROUP_OTHER_EXPENSE+"') "+
				" and (location_id="+sysLocation.getOID()+" or location_id=0)";

//Vector incomeCoas = DbCoa.list(0,0, wherex, "code");

//Vector currencies = DbCurrency.list(0,0,"", "");

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_PETTY_CASH+"' and location_id="+sysCompany.getSystemLocation(), "");
									  
ExchangeRate eRate = DbExchangeRate.getStandardRate();

Vector accountBalance = DbAccLink.getPettyCashAccountBalance(accLinks);

//out.println("accountBalance : "+accountBalance);

Vector listGlDetail = DbGlDetail.list(0,0, "gl_id="+gl.getOID(), "");

double balance = 0;
double totalDetail = getTotalDetail(listGlActivity);
double totalDebet = getTotalDetail(listGlDetail, 0);

balance = totalDebet - totalDetail; 

//gl.setAmount(totalDetail);

if(iJSPCommand==JSPCommand.SUBMIT && iErrCode==0 && iErrCodeMain==0 && recIdx==-1){
	iJSPCommand = JSPCommand.ADD;
	pettycashActivityDetail = new TransactionActivityDetail();
}

Vector modules = DbModule.list(0,0, "activity_period_id="+openAp.getOID(), "code");

Vector donors = DbDonor.list(0,0, "", "");

//count dari input ke database
int cntActivity = DbTransactionActivityDetail.getCount("transaction_id="+oidGl); 
if(cntActivity>0){
	listGlActivity = DbTransactionActivityDetail.list(0,0, "transaction_id="+gl.getOID(), "");
}

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

<%if(!closingPriv || !closingPrivView || !closingPrivUpdate){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

<!--
//=======================================update===========================================================
function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptGLActPDF?oid=<%=appSessUser.getLoginId()%>&gl_id=<%=gl.getOID()%>"); }

function cmdClickIt(){
	document.frmpglactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.select();
}



function cmdFixing(){	
	document.frmpglactivity.command.value="<%=JSPCommand.POST%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();	
}

function cmdNewJournal(){	
	document.frmpglactivity.command.value="<%=JSPCommand.NONE%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();	
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


function checkNumber2(){
	var idx = document.frmpglactivity.select_idx.value;
	//alert('in mee');
	var max = document.frmpglactivity.gl_amount.value;
	//alert(max);
	
	var totalDetail = document.frmpglactivity.total_detail.value;
	totalDetail = cleanNumberFloat(totalDetail, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	var detail = document.frmpglactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value;
	detail = removeChar(detail);	
	document.frmpglactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(detail, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	
	detail = cleanNumberFloat(detail, sysDecSymbol, usrDigitGroup, usrDecSymbol);
	
	if(parseFloat(max)<(parseFloat(totalDetail)+parseFloat(detail))){
		//alert('maximum expense is '+max);
		detail = parseFloat(max)-parseFloat(totalDetail);	
		document.frmpglactivity.<%=jspTransactionActivityDetail.colNames[jspTransactionActivityDetail.JSP_AMOUNT]%>.value = formatFloat(detail, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
	}
	
	//alert("totalDetail : "+totalDetail);
	//alert("detail : "+detail);
	
}

function cmdSubmitCommand(){
	document.frmpglactivity.command.value="<%=JSPCommand.SAVE%>";
	document.frmpglactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdGl(oid){
	<%if(cntActivity>0){%>
		document.frmpglactivity.hidden_glarchive.value=oid;
		document.frmpglactivity.command.value="<%=JSPCommand.EDIT%>";
		document.frmpglactivity.prev_command.value="<%=prevJSPCommand%>";
		document.frmpglactivity.action="glclosing.jsp";
		document.frmpglactivity.submit();
	<%}else{%>
		alert('Please finish and post activity transaction before go to payment archive');
	<%}%>
	
}

//===============================================================================================

function cmdAdd(){
	document.frmpglactivity.select_idx.value="-1";
	document.frmpglactivity.hidden_glarchive.value="0";
	document.frmpglactivity.hidden_gl_activity_id.value="0";
	document.frmpglactivity.command.value="<%=JSPCommand.ADD%>";
	document.frmpglactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdAsk(idx){
	document.frmpglactivity.select_idx.value=idx;
	document.frmpglactivity.hidden_gl_activity_id.value=0;
	document.frmpglactivity.command.value="<%=JSPCommand.ASK%>";
	document.frmpglactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdConfirmDelete(oidTransactionActivityDetail){
	document.frmpglactivity.hidden_gl_activity_id.value=oidTransactionActivityDetail;
	document.frmpglactivity.command.value="<%=JSPCommand.DELETE%>";
	document.frmpglactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdSave(){
	document.frmpglactivity.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpglactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdEdit(idxx){
	document.frmpglactivity.select_idx.value=idxx;
	document.frmpglactivity.hidden_gl_activity_id.value=0;
	document.frmpglactivity.command.value="<%=JSPCommand.EDIT%>";
	document.frmpglactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdCancel(oidTransactionActivityDetail){
	document.frmpglactivity.hidden_gl_activity_id.value=oidTransactionActivityDetail;
	document.frmpglactivity.command.value="<%=JSPCommand.EDIT%>";
	document.frmpglactivity.prev_command.value="<%=prevJSPCommand%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdBack(){
	document.frmpglactivity.command.value="<%=JSPCommand.BACK%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdListFirst(){
	document.frmpglactivity.command.value="<%=JSPCommand.FIRST%>";
	document.frmpglactivity.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdListPrev(){
	document.frmpglactivity.command.value="<%=JSPCommand.PREV%>";
	document.frmpglactivity.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdListNext(){
	document.frmpglactivity.command.value="<%=JSPCommand.NEXT%>";
	document.frmpglactivity.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

function cmdListLast(){
	document.frmpglactivity.command.value="<%=JSPCommand.LAST%>";
	document.frmpglactivity.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpglactivity.action="glactivityclosing.jsp";
	document.frmpglactivity.submit();
}

//-------------- script form image -------------------

function cmdDelPict(oidTransactionActivityDetail){
	document.frmimage.hidden_gl_activity_id.value=oidTransactionActivityDetail;
	document.frmimage.command.value="<%=JSPCommand.POST%>";
	document.frmimage.action="glactivityclosing.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/close2.gif')">
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
                        </span> &raquo; <span class="level2">Journal Activity<br>
                        </span><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpglactivity" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_gl_activity_id" value="<%=oidTransactionActivityDetail%>">
                          <input type="hidden" name="hidden_glarchive" value="<%=oidGl%>">
						 
						  
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
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspGl.getErrorMsg(jspGl.JSP_OPERATOR_ID) %>&nbsp;&nbsp;</div>
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
                                                <td width="29%">&nbsp;</td>
                                                <td width="11%" nowrap>&nbsp;</td>
                                                <td width="48%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" nowrap>Journal 
                                                  Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="29%"><%=gl.getJournalNumber()%></td>
                                                <td width="11%" nowrap>Transaction 
                                                  Date</td>
                                                <td width="48%"> <b><a id="tot_saldo_akhir"></a><%=JSPFormater.formatDate((gl.getTransDate()==null) ? new Date() : gl.getTransDate(), "dd/MM/yyyy")%></b> </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Reference Number</td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="29%"> <%=gl.getRefNumber()%> </td>
                                                <td width="11%">Amount <%=baseCurrency.getCurrencyCode()%></td>
                                                <td width="48%"><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%> 
                                                  <input type="hidden" name="gl_amount" value="<%=totalDebet%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="16">Memo</td>
                                                <td width="2%" height="16">&nbsp;</td>
                                                <td colspan="2" valign="top"> 
                                                  <%=gl.getMemo()%> </td>
                                                <td width="48%" height="16">&nbsp; </td>
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
                                                            <td class="tabin"><a href="javascript:cmdGl('<%=oidGl%>')" class="tablink">Disbursement</a></td>
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
                                                                  <td  class="tablehdr" width="7%" height="20">Direct</td>
                                                                  <td  class="tablehdr" width="11%" height="20">Type</td>
                                                                  <td class="tablehdr" width="35%" height="20">Account</td>
                                                                  <td class="tablehdr" width="28%" height="20">Activity</td>
                                                                  <td class="tablehdr" width="19%" height="20">Amount 
                                                                    <%=baseCurrency.getCurrencyCode()%></td>
                                                                </tr>
                                                                <%if(listGlActivity!=null && listGlActivity.size()>0){
													for(int i=0; i<listGlActivity.size(); i++){
																												
														TransactionActivityDetail crd = new TransactionActivityDetail();
														try{
															crd = (TransactionActivityDetail)listGlActivity.get(i);
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
                                                                <%}else{%>
                                                                <tr> 
                                                                  <td class="<%=cssString%>" width="7%" height="17"> 
                                                                    <div align="center">
                                                                      <%if(crd.getIsDirect()==1){%>
                                                                      <img src="../images/yesx.gif" width="17" height="14"> 
                                                                      <%}%>
                                                                    </div>
                                                                  </td>
                                                                  <td class="<%=cssString%>" width="11%" height="17"> 
                                                                    <%if(cntActivity==0){%>
                                                                    <a href="javascript:cmdEdit('<%=i%>')"><%=DbTransactionActivityDetail.activities[crd.getType()]%></a> 
                                                                    <%}else{%>
                                                                    <%=DbTransactionActivityDetail.activities[crd.getType()]%> 
                                                                    <%}%>
                                                                  </td>
                                                                  <td width="35%" class="<%=cssString%>" nowrap height="17">
																   <%
																  Coa cecxx = new Coa();
																  try{
																  	cecxx = DbCoa.fetchExc(crd.getCoaId());
																  }
																  catch(Exception e){
																  
																  }
																  %>
                                                                    <%=cecxx.getCode()+" - "+cecxx.getName()%> </td>
                                                                  <td width="28%" class="<%=cssString%>" nowrap height="17"> 
                                                                    <%if(crd.getModuleId()!=0){
																  		Module mdl = new Module();
																  		try{
																			mdl = DbModule.fetchExc(crd.getModuleId());
																		}
																		catch(Exception e){
																		}
																		
																		if(mdl.getDescription().length()>40){
																  	%>
                                                                    <a href="" title="<%=mdl.getDescription()%>"><%=mdl.getCode()+" - "+((mdl.getDescription().length()>40) ? (mdl.getDescription().substring(0, 40)+"...") : mdl.getDescription())%></a> 
                                                                    <%}else{%>
                                                                    <%=mdl.getCode()+" - "+mdl.getDescription()%> 
                                                                    <%}}else{%>
                                                                    -
<%}%>
                                                                  </td>
                                                                  <td width="19%" class="<%=cssString%>" height="17"> 
																  	<%
																		String listAmount = "";
																		if(crd.getAmount()<0)
																			listAmount = JSPFormater.formatNumber((crd.getAmount()*-1), "#,###.##");
																		else
																			listAmount = JSPFormater.formatNumber(crd.getAmount(), "#,###.##");
																	%>
                                                                    <div align="right"><%=listAmount%></div>
                                                                  </td>
                                                                </tr>
                                                                <%}%>
                                                                <%}}%>
                                                                <%
									
									//out.println("iJSPCommand : "+iJSPCommand);
									//out.println("iErrCode : "+iErrCode);
									
									if((iJSPCommand==JSPCommand.ADD || (iJSPCommand==JSPCommand.SUBMIT && iErrCode!=0)) && recIdx==-1 ){%>
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
                                                      <td width="76%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a> 
													  &nbsp;&nbsp;&nbsp;
													  <a href="<%=approot%>/incomplete/closinglist.jsp?menu_idx=7"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a>
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
																//out.println("<br>totalDebet : "+totalDebet);
																
																//balance = totalDebet - totalDetail;
																%>
                                                                <input type="hidden" name="total_detail" value="<%=totalDetail%>">
                                                                <%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b></div>
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
                                                <td colspan="5">&nbsp; </td>
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
                          <script language="JavaScript">
				//cmdGetBalance();
				//document.frmpglactivity.<%//=jspGl.colNames[jspGl.JSP_AMOUNT]%>.value= formatFloat('<%=totalDetail%>', '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
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
