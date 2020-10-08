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

	/*public String drawList(Vector objectClass ,  long pcrId)

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
			PettycashReplenishment pcr = (PettycashReplenishment)objectClass.get(i);
			 Vector rowx = new Vector();
			 if(pcrId == pcr.getOID())
				 index = i;

			rowx.add(String.valueOf(pcr.getReplaceCoaId()));

			rowx.add(String.valueOf(pcr.getReplaceFromCoaId()));

			rowx.add(pcr.getMemo());

			String str_dt_Date = ""; 
			try{
				Date dt_Date = pcr.getDate();
				if(dt_Date==null){
					dt_Date = new Date();
				}

				str_dt_Date = Formater.formatDate(dt_Date, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_Date = ""; }

			rowx.add(str_dt_Date);

			String str_dt_TransDate = ""; 
			try{
				Date dt_TransDate = pcr.getTransDate();
				if(dt_TransDate==null){
					dt_TransDate = new Date();
				}

				str_dt_TransDate = Formater.formatDate(dt_TransDate, "dd MMMM yyyy");
			}catch(Exception e){ str_dt_TransDate = ""; }

			rowx.add(str_dt_TransDate);

			rowx.add(String.valueOf(pcr.getOperatorId()));

			rowx.add(String.valueOf(pcr.getReplaceAmount()));

			rowx.add(pcr.getJournalPrefix());

			rowx.add(String.valueOf(pcr.getJournalCounter()));

			lstData.add(rowx);
			lstLinkData.add(String.valueOf(pcr.getOID()));
		}

		return ctrlist.drawList(index);
	}
	*/

%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long oidPettycashReplenishment = JSPRequestValue.requestLong(request, "hidden_pettycash_replenishment_id");

if(iJSPCommand==JSPCommand.NONE){
	iJSPCommand = JSPCommand.EDIT;
}


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

PettycashReplenishment pcr = ctrlPettycashReplenishment.getPettycashReplenishment();
msgString =  ctrlPettycashReplenishment.getMessage();

Vector openPaymants = DbPettycashExpense.list(0,0, "pettycash_replenishment_id="+pcr.getOID(), "");//getOpenPayment(oidReplaceCoa);

//out.println(openPaymants);

//posting journal
if(pcr.getOID()!=0 && iJSPCommand==JSPCommand.POST && pcr.getStatus().equals(I_Project.STATUS_POSTED)){
	DbPettycashReplenishment.postJournal(pcr);
}

//out.println("iJSPCommand : "+iJSPCommand);

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

/*function cmdPrintJournal(oidPettycashReplenishment){
	window.open("<%=printroot%>.report.RptPCReplenishmentPDF?oid=<%=appSessUser.getLoginId()%>&pcReplenishment_id=<%=oidPettycashReplenishment%>");
}*/

<%if(iJSPCommand==JSPCommand.PRINT){%>
	//alert('print out');
	window.open("<%=printroot%>.report.RptPCReplenishmentPDF?oid=<%=appSessUser.getLoginId()%>&pcReplenishment_id=<%=oidPettycashReplenishment%>");
<%}%>

function cmdPrintJournal(oidPettycashReplenishment){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.PRINT%>";
	document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value=oidPettycashReplenishment;
	//document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishmentconfirm.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdChangeIt(){
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.SUBMIT%>";
	document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishment.jsp";
	document.frmpettycashreplenishment.submit();
}

function cmdAdd(){
	document.frmpettycashreplenishment.hidden_pettycash_replenishment_id.value="0";
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.NONE%>";
	//document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishmentconfirm.jsp";
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
	document.frmpettycashreplenishment.command.value="<%=JSPCommand.POST%>";
	//document.frmpettycashreplenishment.prev_command.value="<%=prevJSPCommand%>";
	document.frmpettycashreplenishment.action="pettycashreplenishmentconfirm.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/post_journal2.gif','../images/new2.gif','../images/close2.gif')">
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
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="hidden_pettycash_replenishment_id" value="<%=oidPettycashReplenishment%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" width="100%" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="top"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="77%">&nbsp;</td>
                                          <td width="23%" nowrap>
                                            <div align="right">Date : <%=JSPFormater.formatDate(pcr.getDate(), "dd MMMM yyyy")%>&nbsp;, &nbsp;Operator 
                                              : 
                                              <%
								User u = new User();
								try{
									u = DbUser.fetch(pcr.getOperatorId());
								}
								catch(Exception e){
								}
								%>
                                              <%=u.getLoginId()%>&nbsp;&nbsp;<%= jspPettycashReplenishment.getErrorMsg(jspPettycashReplenishment.JSP_OPERATOR_ID) %></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="2" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="15%" nowrap>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                                <td>&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="15%" nowrap height="22">Replenishment 
                                                  for Account</td>
                                                <td height="22"> <b> 
                                                  <%
										Coa coay = new Coa();
										try{
											coay = DbCoa.fetchExc(pcr.getReplaceCoaId());
										}
										catch(Exception e){
										}%>
                                                  <%=coay.getCode()+ " - "+coay.getName()%> </b></td>
                                                <td height="22">Journal Number</td>
                                                <td height="22"> <%=pcr.getJournalNumber()%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="15%" height="22">From 
                                                  Account</td>
                                                <td width="27%" height="22"> 
                                                  <%
										coay = new Coa();
										try{
											coay = DbCoa.fetchExc(pcr.getReplaceFromCoaId());
										}
										catch(Exception e){
										}%>
                                                  <%=coay.getCode()+ " - "+coay.getName()%> </td>
                                                <td width="11%" height="22">Transaction 
                                                  Date</td>
                                                <td width="47%" height="22"> <%=JSPFormater.formatDate((pcr.getTransDate()==null) ? new Date() : pcr.getTransDate(), "dd/MM/yyyy")%> </td>
                                              </tr>
                                              <tr> 
                                                <td width="15%" height="22">Memo</td>
                                                <td colspan="3" height="22"> <%= pcr.getMemo() %> </td>
                                              </tr>
                                              <tr> 
                                                <td width="15%" height="8"></td>
                                                <td width="27%" height="8"></td>
                                                <td width="11%" height="8"></td>
                                                <td width="47%" height="8"></td>
                                              </tr>
                                              <tr> 
                                                <td width="15%">&nbsp;</td>
                                                <td width="27%">&nbsp;</td>
                                                <td width="11%">&nbsp;</td>
                                                <td width="47%">&nbsp;</td>
                                              </tr>
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
                                              <%
									
									double total = 0;
									
									if(openPaymants!=null && openPaymants.size()>0){
											
									%>
                                              <tr> 
                                                <td colspan="4" class="page"> 
                                                  <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td width="13%" class="tablehdr"> 
                                                        <div align="center">Number</div>
                                                      </td>
                                                      <td width="14%" class="tablehdr"> 
                                                        <div align="center">Transaction 
                                                          Date</div>
                                                      </td>
                                                      <td width="60%" class="tablehdr"> 
                                                        <div align="center">Memo</div>
                                                      </td>
                                                      <td width="13%" class="tablehdr"> 
                                                        <div align="center">Amount(<%=baseCurrency.getCurrencyCode()%>)</div>
                                                      </td>
                                                    </tr>
                                                    <%
										  for(int i=0; i<openPaymants.size(); i++){
										  		PettycashExpense pe = (PettycashExpense)openPaymants.get(i);
												PettycashPayment pp = new PettycashPayment();//(PettycashPayment)openPaymants.get(i);
												Vector x = DbPettycashPayment.list(0,0, "pettycash_payment_id="+pe.getPettycashPaymentId(), "");
												if(x!=null && x.size()>0){
													pp = (PettycashPayment)x.get(0);
												}
												
												String cssName = "tablecell";
												if(i%2!=0){
													cssName = "tablecell1";
												}
												
												/*out.println("pe.getPettycashPaymentId() : "+pe.getPettycashPaymentId());
												
												try{
													pp = DbPettycashPayment.fetchExc(pe.getPettycashPaymentId());
												}
												catch(Exception e){
													out.println(e.toString());
												}*/
												total = total + pp.getAmount();
										  %>
                                                    <tr> 
                                                      <td width="13%" class="<%=cssName%>"><%=pp.getJournalNumber()%>&nbsp;</td>
                                                      <td width="14%" class="<%=cssName%>"> 
                                                        <div align="center"><%=JSPFormater.formatDate(pp.getTransDate(), "dd MMMM yyyy")%></div>
                                                      </td>
                                                      <td width="60%" class="<%=cssName%>"> 
                                                        <div align="left"><%=pp.getMemo()%></div>
                                                      </td>
                                                      <td width="13%" class="<%=cssName%>"> 
                                                        <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                      </td>
                                                    </tr>
                                                    <%}%>
                                                    <tr> 
                                                      <td width="13%" height="1"></td>
                                                      <td width="14%" height="1"></td>
                                                      <td width="60%" height="1"></td>
                                                      <td width="13%" height="1"></td>
                                                    </tr>
                                                    <tr> 
                                                      <td width="13%" class="tablecell">&nbsp;</td>
                                                      <td width="14%" class="tablecell">&nbsp;</td>
                                                      <td width="60%" class="tablecell"> 
                                                        <div align="right"><b>TOTAL 
                                                          : </b></div>
                                                      </td>
                                                      <td width="13%" class="tablecell"> 
                                                        <div align="right"><b> 
                                                          <input type="hidden" name="<%=jspPettycashReplenishment.colNames[JspPettycashReplenishment.JSP_REPLACE_AMOUNT] %>"  value="<%= JSPFormater.formatNumber(total, "#,###.##") %>" class="textdisabled" style="text-align:right" readOnly>
                                                          <%= JSPFormater.formatNumber(total, "#,###.##") %></b></div>
                                                      </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <%}else{%>
                                              <tr> 
                                                <td width="15%" height="13"><i><font color="#006600">expenses 
                                                  is empty</font></i></td>
                                                <td width="27%" height="13">&nbsp;</td>
                                                <td width="11%" height="13">&nbsp;</td>
                                                <td width="47%" height="13">&nbsp;</td>
                                              </tr>
                                              <%}%>
                                            </table>
                                          </td>
                                        </tr>
                                        <%if(pcr.getOID()!=0){%>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td height="2">&nbsp;</td>
                                              </tr>
                                              <!--tr> 
                                                <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                              </tr-->
                                            </table>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="5%"><a href="javascript:cmdPrintJournal('<%=oidPettycashReplenishment%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
                                                <td width="0%">&nbsp;</td>
                                                <td width="11%"> 
                                                  <div align="center">
                                                    <%if(pcr.getStatus().equals(I_Project.NA_PRINTED) || pcr.getStatus().equals(I_Project.NA_POSTED_STATUS)){%>
                                                    <%if(iJSPCommand!=JSPCommand.POST || iErrCode!=0){%>
                                                    <a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" width="92" height="22" border="0"></a> 
                                                    <%}else{%>
                                                    <a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../images/new2.gif',1)"><img src="../images/new.gif" name="new" height="22" border="0"></a> 
                                                    <%}}%>
                                                  </div>
                                                </td>
                                                <td width="29%">
												<%if(pcr.getStatus().equals(I_Project.NA_POSTED_STATUS)){%>
												<a href="<%=approot%>/home.jsp"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new11','','../images/close2.gif',1)"><img src="../images/close.gif" name="new11"  border="0"></a> 
												<%}%>
                                                </td>
                                                <td width="55%"> 
                                                  <%if(pcr.getStatus().equals(I_Project.NA_PRINTED) || pcr.getStatus().equals(I_Project.NA_POSTED_STATUS)){%>
												  <%if(iJSPCommand!=JSPCommand.POST || iErrCode!=0){%>
                                                  <table border="0" cellpadding="5" cellspacing="0" class="info" width="214" align="right">
                                                    <tr> 
                                                      <td width="18"><img src="../images/inform.gif" width="20" height="20"></td>
                                                      <td width="176" nowrap>Journal 
                                                        is ready to be posted</td>
                                                    </tr>
                                                  </table>
                                                  <%}else{%>
                                                  <table border="0" cellpadding="5" cellspacing="0" class="success" align="right">
                                                    <tr> 
                                                      <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                      <td width="210" nowrap>Data 
                                                        has been posted successfully 
                                                      </td>
                                                    </tr>
                                                  </table>
                                                  <%}}else{%>
												  <table border="0" cellpadding="5" cellspacing="0" class="info" width="281" align="right">
                                                    <tr> 
                                                      <td width="16"><img src="../images/inform.gif" width="20" height="20"></td>
                                                      <td width="245" nowrap>Replenishment 
                                                        is ready to be printed</td>
                                                    </tr>
                                                  </table>
												  <%}%>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                        <%}%>
                                        <tr> 
                                          <td width="77%">&nbsp;</td>
                                          <td width="23%">&nbsp;</td>
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
