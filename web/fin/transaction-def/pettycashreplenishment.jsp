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
boolean cashPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT);
%>
<!-- Jsp Block -->
<%!

	/*public String drawList(Vector objectClass ,  long pettycashReplenishmentId)

	{
		JSPList ctrlist = new JSPList();
		ctrlist.setAreaWidth("100%");
		ctrlist.setListStyle("listgen");
		ctrlist.setTitleStyle("tableheader");
		ctrlist.setCellStyle("cellStyle");
		ctrlist.setHeaderStyle("tableheader");
		ctrlist.addHeader("Replace Coa Id","11%");
		ctrlist.addHeader("Replace From Coa Id","11%");
		ctrlist.addHeader("Memo","11%");
		ctrlist.addHeader("Date","11%");
		ctrlist.addHeader("Trans Date","11%");
		ctrlist.addHeader("Operator Id","11%");
		ctrlist.addHeader("Replace Amount","11%");
		ctrlist.addHeader("Journal Prefix","11%");
		ctrlist.addHeader("Journal Counter","11%");

		ctrlist.setLinkRow(0);
		ctrlist.setLinkSufix("");
		Vector lstData = ctrlist.getData();
		Vector lstLinkData = ctrlist.getLinkData();
		ctrlist.setLinkPrefix("javascript:cmdEdit('");
		ctrlist.setLinkSufix("')");
		ctrlist.reset();
		int index = -1;

		for (int i = 0; i < objectClass.size(); i++) {
			PettycashReplenishment pettycashReplenishment = (PettycashReplenishment)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(pettycashReplenishmentId == pettycashReplenishment.getOID())
				 index = i;

			rowx.add(String.valueOf(pettycashReplenishment.getReplaceCoaId()));

			rowx.add(String.valueOf(pettycashReplenishment.getReplaceFromCoaId()));

			rowx.add(pettycashReplenishment.getMemo());

			String str_dt_Date = ""; 
			try{
				Date dt_Date = pettycashReplenishment.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			String str_dt_TransDate = ""; 
			try{
				Date dt_TransDate = pettycashReplenishment.getTransDate();
				if(dt_TransDate==null){
					dt_TransDate = new Date();
				}

				str_dt_TransDate = Formater.formatDate(dt_TransDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_TransDate = ""; }

			rowx.add(str_dt_TransDate);

			rowx.add(String.valueOf(pettycashReplenishment.getOperatorId()));

			rowx.add(String.valueOf(pettycashReplenishment.getReplaceAmount()));

			rowx.add(pettycashReplenishment.getJournalPrefix());

			rowx.add(String.valueOf(pettycashReplenishment.getJournalCounter()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(pettycashReplenishment.getOID()));
		}

		return ctrlist.drawList(index);
	}
	*/
	
	public String getDefaultMemo(Vector openPaymants){
		String result = "";
		if(openPaymants!=null && openPaymants.size()>0){
			if(openPaymants.size()==1){
				PettycashPayment pp = (PettycashPayment)openPaymants.get(0);
				result = "Replenishment for payment number "+pp.getJournalNumber()+", transaction date "+JSPFormater.formatDate(pp.getTransDate(), "dd-MM-yyyy");				
			}
			else{
				PettycashPayment pp = (PettycashPayment)openPaymants.get(0);
				PettycashPayment pp1 = (PettycashPayment)openPaymants.get(openPaymants.size()-1);
				result = "Replenishment for payment number "+pp.getJournalNumber()+" to "+pp1.getJournalNumber()+", transaction date "+JSPFormater.formatDate(pp.getTransDate(), "dd-MM-yyyy")+" to "+JSPFormater.formatDate(pp1.getTransDate(), "dd-MM-yyyy");				
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
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPettycashReplenishment = JSPRequestValue.requestLong(request, "hidden_pettycash_replenishment_id");
long oidReplaceCoa = JSPRequestValue.requestLong(request, JspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_COA_ID]);

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
String orderClause = "";

CmdPettycashReplenishment ctrlPettycashReplenishment = new CmdPettycashReplenishment(request);
JSPLine ctrLine = new JSPLine();
Vector listPettycashReplenishment = new Vector(1,1);

/*switch statement */
iErrCode = ctrlPettycashReplenishment.action(iJSPCommand , oidPettycashReplenishment);
/* end switch*/
JspPettycashReplenishment jspPettycashReplenishment = ctrlPettycashReplenishment.getForm();

/*count list All PettycashReplenishment*/
int vectSize = DbPettycashReplenishment.getCount(whereClause);

PettycashReplenishment pettycashReplenishment = ctrlPettycashReplenishment.getPettycashReplenishment();
msgString =  ctrlPettycashReplenishment.getMessage();


if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
  (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
		start = ctrlPettycashReplenishment.actionList(iJSPCommand, start, vectSize, recordToGet);
 } 
/* end switch list*/

/* get record to display */
//listPettycashReplenishment = DbPettycashReplenishment.list(start,recordToGet, whereClause , orderClause);

/*handle condition if size of record to display = 0 and start > 0 	after delete*/
/*if (listPettycashReplenishment.size() < 1 && start > 0)
{
	 if (vectSize - recordToGet > recordToGet)
			start = start - recordToGet;   //go to JSPCommand.PREV
	 else{
		 start = 0 ;
		 iJSPCommand = JSPCommand.FIRST;
		 prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
	 }
	 listPettycashReplenishment = DbPettycashReplenishment.list(start,recordToGet, whereClause , orderClause);
}
*/


//Vector bankAccounts = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");
Vector bankAccounts = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_BANK_PO_PAYMENT_CREDIT+"'", "");

Vector bankBalance = DbAccLink.getBankAccountBalance(bankAccounts);

Vector currencies = DbCurrency.list(0,0,"", "");

Vector accLinks = DbAccLink.list(0,0, "type='"+I_Project.ACC_LINK_GROUP_PETTY_CASH_CREDIT+"' and (location_id="+sysCompany.getSystemLocation()+" or location_id=0)", "");

if(oidReplaceCoa==0){
	if(accLinks!=null && accLinks.size()>0){
		AccLink al = (AccLink)accLinks.get(0);
		oidReplaceCoa = al.getCoaId();
	}
}


Vector v = DbPettycashReplenishment.list(0,0, "status='"+I_Project.STATUS_NOT_POSTED+"'", "");

PettycashReplenishment prt = new PettycashReplenishment(); 
if(iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.SUBMIT){
	prt = DbPettycashReplenishment.getOpenReplenishment(oidReplaceCoa);
}
else{
	prt = pettycashReplenishment;
}

if(v!=null && v.size()>0){
	prt = (PettycashReplenishment)v.get(0);
}


Vector openPaymants = DbPettycashPayment.getOpenPayment(oidReplaceCoa);

if(openPaymants!=null && openPaymants.size()>0 && pettycashReplenishment.getOID()!=0 && iJSPCommand==JSPCommand.SAVE){
	DbPettycashExpense.insertExpenses(pettycashReplenishment.getOID(), openPaymants);
}

if(iJSPCommand==JSPCommand.NONE){
	pettycashReplenishment.setMemo(getDefaultMemo(openPaymants));
}

//out.println("oidReplaceCoa : "+oidReplaceCoa);
//out.println("openPaymants : "+openPaymants);
									  
//ExchangeRate eRate = DbExchangeRate.getStandardRate();



//out.println("iJSPCommand : "+iJSPCommand);
///out.println("prt.getOID() : "+prt.getOID());

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
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

var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
var usrDigitGroup = "<%=sUserDigitGroup%>";
var usrDecSymbol = "<%=sUserDecimalSymbol%>";

<%if(prt.getOID()!=0){%>
	window.location="pettycashreplenishmentconfirm.jsp?hidden_pettycash_replenishment_id=<%=prt.getOID()%>&menu_idx=1";
<%}%>

function cmdUpdate(){
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdGetBalance(){
	
	var x = document.frmpettycashreplenishment.<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_REPLACE_FROM_COA_ID]%>.value;
	//alert(x);
	<%if(bankBalance!=null && bankBalance.size()>0){
		for(int i=0; i<bankBalance.size(); i++){
			Coa c = (Coa)bankBalance.get(i);
	%>
		if(x=='<%=c.getOID()%>'){
			if(<%=DbCoa.getCoaBalance(c.getOID())%><0)
			{
				document.all.tot_saldo_akhir.innerHTML = "(" + formatFloat("<%=JSPFormater.formatNumber((DbCoa.getCoaBalance(c.getOID())<0) ? DbCoa.getCoaBalance(c.getOID())*-1 : DbCoa.getCoaBalance(c.getOID()),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace)+")";
			}else
			{
				document.all.tot_saldo_akhir.innerHTML = formatFloat("<%=JSPFormater.formatNumber((DbCoa.getCoaBalance(c.getOID())<0) ? DbCoa.getCoaBalance(c.getOID())*-1 : DbCoa.getCoaBalance(c.getOID()),"###.##")%>", '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
			}
			var total = 0;
			<%if(openPaymants!=null && openPaymants.size()>0){%>
				total = document.frmpettycashreplenishment.<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_AMOUNT] %>.value;
			<%}%>
			
			<%if(c.getOpeningBalance()<1){%>
				//alert('No account balance to do transaction.');
				document.all.command_line.style.display="none";
				document.all.emptymessage.style.display="";
			<%}else{%>
				//alert(parseFloat('<%=c.getOpeningBalance()%>'));
				//alert(parseFloat(total));
				if(parseFloat('<%=c.getOpeningBalance()%>')<parseFloat(total)){
					document.all.command_line.style.display="none";
					document.all.emptymessage.style.display="";
				}
				else{
					document.all.command_line.style.display="";
					document.all.emptymessage.style.display="none";
				}
			<%}%>
		}
	<%}}%>
	
	//checkNumber();
}

function cmdChangeIt(){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdAdd(){
	document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value="0";
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.ADD%>";
	document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdAsk(oidPettycashReplenishment){
	document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.ASK%>";
	document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdConfirmDelete(oidPettycashReplenishment){
	document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.DELETE%>";
	document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}
function cmdSave(){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.SAVE%>";
	document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
	}

function cmdEdit(oidPettycashReplenishment){
	document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishmentconfirm.jsp";
	document.frmpettycashreplenishment.submit();
	}

function cmdCancel(oidPettycashReplenishment){
	document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.EDIT%>";
	document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdBack(){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.BACK%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
	}

function cmdListFirst(){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashreplenishment.prev_command.value="<%=JSPCommand.FIRST%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdListPrev(){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashreplenishment.prev_command.value="<%=JSPCommand.PREV%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
	}

function cmdListNext(){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashreplenishment.prev_command.value="<%=JSPCommand.NEXT%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdListLast(){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashreplenishment.prev_command.value="<%=JSPCommand.LAST%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/save2.gif','../images/print2.gif','../images/post_journal2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Petty Cash</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Replenishment</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmpettycashreplenishment" method ="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                          <input type="hidden" name="hidden_pettycash_replenishment_id" value="<%=oidPettycashReplenishment%>">
                          <input type="hidden" name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_OPERATOR_ID]%>" value="<%=appSessUser.getUserOID()%>">
                          <input type="hidden" name="hidden_id_replace_coa" value="<%=oidReplaceCoa%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" width="100%" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td colspan="3"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="31%">&nbsp;</td>
                                                <td width="32%">&nbsp;</td>
                                                <td width="37%"> 
                                                  <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                                    : <%=appSessUser.getLoginId()%>&nbsp;&nbsp;<%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_OPERATOR_ID) %>&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="3" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="10%" nowrap>&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="36%">&nbsp;</td>
                                              </tr>
                                              <%if(v!=null && v.size()>0){%>
                                              <%}%>
                                              <tr> 
                                                <td width="10%" nowrap height="22">Replenishment 
                                                  for </td>
                                                <td width="42%" height="22"> <b> 
                                                  <select name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_COA_ID]%>" onChange="javascript:cmdUpdate()">
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
                                                    <option <%if(oidReplaceCoa==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
													<%=getAccountRecursif(coa, oidReplaceCoa, isPostableOnly)%>
                                                    <%}}else{%>
                                                    <option>select ..</option>
                                                    <%}%>
                                                  </select>
                                                  <%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_REPLACE_COA_ID) %> </b></td>
                                                <td width="12%" height="22">&nbsp;</td>
                                                <td width="36%" height="22">&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="22">Transaction 
                                                  Date</td>
                                                <td width="42%" height="22"> 
                                                  <input name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((pettycashReplenishment.getTransDate()==null) ? new Date() : pettycashReplenishment.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpettycashreplenishment.<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                  <%if(iJSPCommand!=JSPCommand.SUBMIT){%>
                                                  <%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_TRANS_DATE) %> 
                                                  <%}%>
                                                </td>
                                                <td width="12%" height="22">&nbsp;Journal 
                                                  Number</td>
                                                <td width="36%" height="22"> 
                                                  <%
									  int counter = DbPettycashReplenishment.getNextCounter();
									  String strNumber = DbPettycashReplenishment.getNextNumber(counter);
									  
									  if(pettycashReplenishment.getOID()!=0){
											strNumber = pettycashReplenishment.getJournalNumber();
									  }
									  
									  %>
                                                  <%=strNumber%> 
                                                  <input type="hidden" name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_JOURNAL_NUMBER]%>">
                                                  <input type="hidden" name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_JOURNAL_COUNTER]%>">
                                                  <input type="hidden" name="<%=jspPettycashReplenishment.colNames[jspPettycashReplenishment.JSP_JOURNAL_PREFIX]%>">
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="22">From 
                                                  Account</td>
                                                <td width="42%" height="22"> 
                                                  <select name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_FROM_COA_ID]%>" onChange="javascript:cmdGetBalance()">
                                                    <%if(bankAccounts!=null && bankAccounts.size()>0){
										  for(int i=0; i<bankAccounts.size(); i++){
										  		AccLink accLink = (AccLink)bankAccounts.get(i);
												Coa coa = new Coa();
												try{
													coa = DbCoa.fetchExc(accLink.getCoaId());
												}
												catch(Exception e){
												}
										  %>
                                                    <option <%if(pettycashReplenishment.getReplaceFromCoaId()==coa.getOID()){%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode()+" - "+coa.getName()%></option>
													<%=getAccountRecursif(coa, pettycashReplenishment.getReplaceFromCoaId(), isPostableOnly)%>
                                                    <%}}else{%>
                                                    <option>select ..</option>
                                                    <%}%>
                                                  </select>
                                                  <%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_REPLACE_COA_ID) %> &nbsp;&nbsp; </td>
                                                <td width="12%" height="22" nowrap>&nbsp;<b>Account 
                                                  Balance <%=baseCurrency.getCurrencyCode()%></b></td>
                                                <td width="36%" height="22"> <b><a id="tot_saldo_akhir"></a></b> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="22">Memo</td>
                                                <td colspan="3" height="22"> 
                                                  <textarea name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_MEMO] %>" class="formElemen" cols="50" rows="2"><%= pettycashReplenishment.getMemo() %></textarea>
                                                  <%if(iJSPCommand!=JSPCommand.SUBMIT){%>
                                                  <br>
                                                  <%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_MEMO) %> 
                                                  <%}%>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%" height="8"></td>
                                                <td width="42%" height="8"></td>
                                                <td width="12%" height="8"></td>
                                                <td width="36%" height="8"></td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">&nbsp;</td>
                                                <td width="42%">&nbsp;</td>
                                                <td width="12%">&nbsp;</td>
                                                <td width="36%">&nbsp;</td>
                                              </tr>
                                              <%
									
									double total = 0;
									
									if(openPaymants!=null && openPaymants.size()>0){
											
									%>
                                              <tr> 
                                                <td colspan="4"> 
                                                  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr > 
                                                      <td class="tabheader" width="1%"><img src="<%=approot%>/images/spacer.gif" width="15" height="10"></td>
                                                      <td class="tab" width="11%"> 
                                                        <div align="center">Disbursement</div>
                                                      </td>
                                                      <td class="tabheader" width="25%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <td class="tabheader" width="0%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <td class="tabheader" width="0%"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                      <td width="63%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" class="page"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="15%" class="tablehdr"> 
                                                        <div align="center">Number</div>
                                                      </td>
                                                      <td width="14%" class="tablehdr"> 
                                                        <div align="center">Transaction 
                                                          Date</div>
                                                      </td>
                                                      <td width="54%" class="tablehdr"> 
                                                        <div align="center">Memo</div>
                                                      </td>
                                                      <td width="17%" class="tablehdr"> 
                                                        <div align="center">Amount(<%=baseCurrency.getCurrencyCode()%>)</div>
                                                      </td>
                                                    </tr>
                                                    <%
										  for(int i=0; i<openPaymants.size(); i++){
												PettycashPayment pp = (PettycashPayment)openPaymants.get(i);
												total = total + pp.getAmount();
												
												String cssName = "tablecell";
												if(i%2!=0){
													cssName = "tablecell1";
												}
												
										  %>
                                                    <tr> 
                                                      <td width="15%" class="<%=cssName%>"><%=pp.getJournalNumber()%>&nbsp;</td>
                                                      <td width="14%" class="<%=cssName%>"> 
                                                        <div align="center"><%=JSPFormater.formatDate(pp.getTransDate(), "dd MMMM yyyy")%></div>
                                                      </td>
                                                      <td width="54%" class="<%=cssName%>"> 
                                                        <div align="left"><%=pp.getMemo()%></div>
                                                      </td>
                                                      <td width="17%" class="<%=cssName%>"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                      </td>
                                                    </tr>
                                                    <%}%>
                                                    <tr> 
                                                      <td width="15%" height="1"></td>
                                                      <td width="14%" height="1"></td>
                                                      <td width="54%" height="1"></td>
                                                      <td width="17%" height="1"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="15%" class="tablecell">&nbsp;</td>
                                                      <td width="14%" class="tablecell">&nbsp;</td>
                                                      <td width="54%" class="tablecell"> 
                                                        <div align="right"><b>TOTAL 
                                                          : </b></div>
                                                      </td>
                                                      <td width="17%" class="tablecell"> 
                                                        <div align="right"><b> 
                                                          <input type="hidden" name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_AMOUNT] %>"  value="<%=total%>" class="textdisabled" style="text-align:right" readOnly>
                                                          <%= JSPFormater.formatNumber(total, "#,###.##") %></b></div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}else{%>
                                              <tr> 
                                                <td colspan="4" height="13" class="boxed1"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="15%" class="tablehdr"> 
                                                        <div align="center">Number</div>
                                                      </td>
                                                      <td width="14%" class="tablehdr"> 
                                                        <div align="center">Transaction 
                                                          Date</div>
                                                      </td>
                                                      <td width="54%" class="tablehdr"> 
                                                        <div align="center">Memo</div>
                                                      </td>
                                                      <td width="17%" class="tablehdr"> 
                                                        <div align="center">Amount(<%=baseCurrency.getCurrencyCode()%>)</div>
                                                      </td>
                                                    </tr>
                                                    <tr> 
                                                      <td colspan="4" class="tablecell"> 
                                                        <i><font color="#990000">Data 
                                                        is empty</font></i></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="15%" height="1"></td>
                                                      <td width="14%" height="1"></td>
                                                      <td width="54%" height="1"></td>
                                                      <td width="17%" height="1"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="15%" class="tablecell">&nbsp;</td>
                                                      <td width="14%" class="tablecell">&nbsp;</td>
                                                      <td width="54%" class="tablecell"> 
                                                        <div align="right"><b>TOTAL 
                                                          : </b></div>
                                                      </td>
                                                      <td width="17%" class="tablecell"> 
                                                        <div align="right"><b> 
                                                          <input type="hidden" name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_AMOUNT] %>2"  value="<%=total%>" class="textdisabled" style="text-align:right" readOnly>
                                                          0.00</b></div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <i></i></td>
                                              </tr>
                                              <%}%>
                                              <tr> 
                                                <td colspan="4" id="command_line"> 
                                                  <%
										if(prt.getOID()==0){
										if(total>0){%>
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td colspan="4">&nbsp;</td>
                                                      <td width="74%">&nbsp;</td>
                                                    </tr>
                                                    <%if(iJSPCommand!=JSPCommand.SUBMIT && msgString!=null && msgString.length()>0){%>
                                                    <tr> 
                                                      <td colspan="4"> 
                                                        <table border="0" cellpadding="5" cellspacing="0" class="warning" align="left">
                                                          <tr> 
                                                            <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                            <td width="270" nowrap><%=msgString%></td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                      <td width="74%">&nbsp;</td>
                                                    </tr>
                                                    <%}%>
                                                    <tr> 
                                                      <td width="2%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/save2.gif',1)"><img src="../images/save.gif" name="new" height="22" border="0"></a></td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="16%">&nbsp;</td>
                                                      <td width="74%">&nbsp;</td>
                                                    </tr>
                                                  </table>
                                                  <%}else{%>
                                                  <br>
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
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
                                                    <%//if(iJSPCommand!=JSPCommand.SUBMIT && msgString!=null && msgString.length()>0){%>
                                                    <%//}%>
                                                    <tr> 
                                                      <td width="2%"><img src="../images/save.gif" width="55" height="22"></td>
                                                      <td width="6%">&nbsp;</td>
                                                      <td width="2%">&nbsp;</td>
                                                      <td width="16%">&nbsp;</td>
                                                      <td width="74%" class="msgnextaction"> 
                                                        <div align="left"></div>
                                                        <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right">
                                                          <tr> 
                                                            <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                            <td width="150" nowrap>No 
                                                              expenses to replace</td>
                                                          </tr>
                                                        </table>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <%}}%>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%if(prt.getOID()!=0){%>
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
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="5%"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                <td width="2%">&nbsp;</td>
                                                <td width="16%"><a href="javascript:cmdNewJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a></td>
                                                <td width="44%">&nbsp;</td>
                                                <td width="33%"> 
                                                  <div align="right" class="msgnextaction"> 
                                                    <table border="0" cellpadding="5" cellspacing="0" class="info" width="210" align="right">
                                                      <tr> 
                                                        <td width="20"><img src="../images/inform.gif" width="20" height="20"></td>
                                                        <td width="140" nowrap>Journal 
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
                                                  <div align="left" class="msgnextaction"> 
                                                    <table border="0" cellpadding="5" cellspacing="0" class="warning" align="right">
                                                      <tr> 
                                                        <td width="20"><img src="../images/error.gif" width="20" height="20"></td>
                                                        <td width="230" nowrap>Not 
                                                          enought bank balance 
                                                          to replace</td>
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
                                  <%
							try{
								if (listPettycashReplenishment.size()>0){
							%>
                                  <%  } 
						  }catch(Exception exc){ 
						  }%>
                                </table>
                              </td>
                            </tr>
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" colspan="3" width="100%">&nbsp; 
                              </td>
                            </tr>
                          </table>
                          <script language="JavaScript">
				cmdGetBalance();
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
