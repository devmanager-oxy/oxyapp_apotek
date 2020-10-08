<%@ page language="java"%>
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
	boolean privAdd 	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
	boolean privUpdate	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
	boolean privDelete	= true; //userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<%
boolean cashPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_ARCHIVES);


//boolean cashRecPriv =  QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_RECERIVE);
//boolean cashPayPriv =  QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_PAYMENT);
//boolean cashRepPriv =  QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_CASH, AppMenu.M2_MENU_CASH_PETTYCASH_REPLENISHMENT);
%>
<!-- Jsp Block -->
<%!
	public String getSubstring1(String s)
	{
		if(s.length()>60)
		{
			s="<a href=\"#\" title=\""+s+"\"><font color=\"black\">"+s.substring(0,55)+"...</font></a>";
		}
		return s;
	}
	public String getSubstring(String s)
	{
		if(s.length()>105)
		{
			s="<a href=\"#\" title=\""+s+"\"><font color=\"black\">"+s.substring(0,100)+"...</font></a>";
		}
		return s;
	}
%>

<%@ include file="../calendar/calendarframe.jsp"%>

<%
	int iCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidCashArchive = JSPRequestValue.requestLong(request, "hidden_casharchive");

	// variable declaration
	int recordToGet = 15;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "journal_number";

	CmdCashArchive cmdCashArchive = new CmdCashArchive(request);
	JSPLine jspLine = new JSPLine();
	Vector listCashArchive = new Vector(1,1);
	CashArchive cashArchive = new CashArchive();//cmdCashArchive.getCashArchive();
	JspCashArchive jspCashArchive = new JspCashArchive(request, cashArchive);

	int ignoreInputDate = JSPRequestValue.requestInt(request, jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_INPUT_DATE]);		
	int ignoreTransDate = JSPRequestValue.requestInt(request, jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_TRANSACTION_DATE]);
	
	if(iCommand==JSPCommand.NONE || iCommand==JSPCommand.BACK){
		ignoreTransDate = 1;
		ignoreInputDate = 1;
	}

	// switch statement	
	iErrCode = cmdCashArchive.action(iCommand , oidCashArchive);

	
	// end switch
	jspCashArchive.requestEntityObject(cashArchive);// cmdCashArchive.getForm();
	
	cashArchive = jspCashArchive.getEntityObject();

	// count list All CashArchive
	//int vectSize = DbCashReceive.getCount(whereClause);
//	out.println("test : "+vectSize);

	//recordToGet = vectSize;
	//out.println(jspCashArchive.getErrors());

	
	msgString =  cmdCashArchive.getMessage();
	//out.println("test : "+msgString);
	
	//out.println("itd = "+cashArchive.getIgnoreTransactionDate());
		
	
	//modify where clause base on search for
	if(cashArchive.getIgnoreTransactionDate()==0)
	{//trans_date
		whereClause = "trans_date = '" + JSPFormater.formatDate(cashArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
	}
	if(!cashArchive.getJournalNumber().equals(""))
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "journal_number like '%" + cashArchive.getJournalNumber() + "%'";
	}
	if(cashArchive.getPeriodeId()!=0)
	{
		Periode periode = new Periode();
		try{
			periode = DbPeriode.fetchExc(cashArchive.getPeriodeId());
		}catch(Exception e){}
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() +"'";
	}
	if(cashArchive.getIgnoreInputDate()==0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(cashArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(cashArchive.getEndDate(), "yyyy-MM-dd") +"'";
	}	
	
	//out.println("<br>whereClause : "+whereClause+ " ---- <br>"+ cashArchive.getIgnoreTransactionDate());
	//whereClause = "";

	//int vectSize = DbCashReceive.getCount(whereClause);
	int vectSize = 0;
	if(cashArchive.getSearchFor().equals("cashreceive"))
	{
		vectSize = DbCashReceive.getCount(whereClause);
	}else if(cashArchive.getSearchFor().equals("paymentpettycash"))
	{
		vectSize = DbPettycashPayment.getCount(whereClause);
	}else if(cashArchive.getSearchFor().equals("paymentreplenishmentcash"))
	{
		vectSize = DbPettycashReplenishment.getCount(whereClause);
	}

	
	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdCashArchive.actionList(iCommand, start, vectSize, recordToGet);
//		out.println("ubah start "+iCommand+" "+ start+" "+ vectSize+" "+ recordToGet);
	} 

	
	// get record to display
	if(cashArchive.getSearchFor().equals("cashreceive"))
	{
		whereClause = (whereClause.length()>0) ? whereClause + " and type=0" : "type=0";
		//out.println("whereClause : "+whereClause);
		listCashArchive = DbCashReceive.list(start,recordToGet, whereClause , orderClause);
	}else if(cashArchive.getSearchFor().equals("paymentpettycash"))
	{
		listCashArchive = DbPettycashPayment.list(start,recordToGet, whereClause , orderClause);
	}else if(cashArchive.getSearchFor().equals("paymentreplenishmentcash"))
	{
		listCashArchive = DbPettycashReplenishment.list(start,recordToGet, whereClause , orderClause);
	}
	
	//out.println("<br>start : "+start);
	//out.println("<br>vectSize : "+vectSize);
	
	//out.println("<br>listCashArchive : "+listCashArchive);
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=systemTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/default.css" rel="stylesheet" type="text/css" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!--Begin Region JavaScript-->
<script language="JavaScript">

<%if(!cashPriv && (!cashRecPriv && !cashRepPriv && !cashPayPriv)){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	function cmdResetStart(){
		document.frmcasharchive.start.value="0";	
	}

	function cmdSearch(){
		document.frmcasharchive.start.value="0";	
		document.frmcasharchive.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmcasharchive.prev_command.value="<%=prevCommand%>";
		document.frmcasharchive.action="casharchive.jsp";
		document.frmcasharchive.submit();
	}

	function cmdEditReceipt(oidReceive){
		document.frmcasharchive.hidden_casharchive.value=oidReceive;
		document.frmcasharchive.action="cashreceivedetailprint.jsp";
		document.frmcasharchive.submit();
	}

	function cmdEditPayment(oidPayment){
		document.frmcasharchive.hidden_casharchive.value=oidPayment;
		document.frmcasharchive.action="pettycashpaymentdetailprint.jsp";
		document.frmcasharchive.submit();
	}
	
	function cmdEditReplenishment(oidReplenishment){
		document.frmcasharchive.hidden_casharchive.value=oidReplenishment;
		document.frmcasharchive.action="pettycashreplenishmentconfirmprint.jsp";
		document.frmcasharchive.submit();
	}

	function cmdListFirst(){
		document.frmcasharchive.command.value="<%=JSPCommand.FIRST%>";
		document.frmcasharchive.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmcasharchive.action="casharchive.jsp";
		document.frmcasharchive.submit();
	}

	function cmdListPrev(){
		document.frmcasharchive.command.value="<%=JSPCommand.PREV%>";
		document.frmcasharchive.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmcasharchive.action="casharchive.jsp";
		document.frmcasharchive.submit();
		}

	function cmdListNext(){
		document.frmcasharchive.command.value="<%=JSPCommand.NEXT%>";
		document.frmcasharchive.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmcasharchive.action="casharchive.jsp";
		document.frmcasharchive.submit();
	}

	function cmdListLast(){
		document.frmcasharchive.command.value="<%=JSPCommand.LAST%>";
		document.frmcasharchive.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmcasharchive.action="casharchive.jsp";
		document.frmcasharchive.submit();
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
<!--End Region JavaScript-->
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                  <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%>
				  <%@ include file="../calendar/calendarframe.jsp"%>
            <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td class="title"><!-- #BeginEditable "title" -->
					  <%
					  String navigator = "<font class=\"lvl1\">Cash</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Archives</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					 <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmcasharchive" method ="post" action="">
							<input type="hidden" name="command" value="<%=iCommand%>">
							<input type="hidden" name="vectSize" value="<%=vectSize%>">
							<input type="hidden" name="start" value="<%=start%>">
							<input type="hidden" name="prev_command" value="<%=prevCommand%>">
							<input type="hidden" name="hidden_casharchive" value="<%=oidCashArchive%>">
							<input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <!--DWLayoutTable-->
                                  <tr align="left" valign="top"> 
                                    <td width="100%" height="127" valign="top"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                          <td colspan="4" valign="top">
                                            <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></div>
                                          </td>
                                        </tr>
                                        <tr> 
                                          <td colspan="4" valign="top"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                              <tr> 
                                                <td width="13%">&nbsp;</td>
                                                <td width="26%">&nbsp;</td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="51%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Search for</td>
                                                <td width="26%"> 
                                                  <%
													//out.println("Search : "+cashArchive.getSearchFor());
												%>
                                                  <select name="<%=jspCashArchive.colNames[jspCashArchive.JSP_SEARCH_FOR] %>" onChange="javascript:cmdSearch()">
												  	<%if(cashRecView){%>
                                                    <option value="cashreceive" <%if(cashArchive.getSearchFor().equals("cashreceive")){%> selected <%}%>>Cash Receipt</option>
													<%}
													if(cashPayView){%>
                                                    <option value="paymentpettycash" <%if(cashArchive.getSearchFor().equals("paymentpettycash")){%> selected <%}%>>Payment Petty Cash</option>
													<%}
													if(cashRefView){%>
                                                    <option value="paymentreplenishmentcash" <%if(cashArchive.getSearchFor().equals("paymentreplenishmentcash")){%> selected <%}%>>Replenishment Petty Cash</option>
													<%}%>
                                                  </select>
                                                </td>
                                                <td width="10%">Input Date</td>
                                                <td width="51%"> 
                                                  <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getStartDate()==null) ? new Date() : cashArchive.getStartDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=jspCashArchive.colNames[jspCashArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                  &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;&nbsp;&nbsp;&nbsp; 
                                                  <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getEndDate()==null) ? new Date() : cashArchive.getEndDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=jspCashArchive.colNames[jspCashArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>	
                                                  <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if(ignoreInputDate==1){ %>checked<%}%>>
                                                  Ignore </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Journal Number</td>
                                                <td width="26%"> 
                                                  <input type="text" name="<%=jspCashArchive.colNames[jspCashArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= cashArchive.getJournalNumber() %>">
                                                </td>
                                                <td width="10%">Transaction Date</td>
                                                <td width="51%"> 
                                                  <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getTransactionDate()==null) ? new Date() : cashArchive.getTransactionDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=jspCashArchive.colNames[jspCashArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>	
                                                  <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if(ignoreTransDate==1){ %>checked<%}%>>
                                                  Ignore </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Periode</td>
                                                <td colspan="3"> 
                                                  <% 
														Vector p = new Vector(1,1);
														p = DbPeriode.list(0,0, "", "NAME");
														Vector p_value = new Vector(1,1);
														Vector p_key = new Vector(1,1);
														String sel_p = ""+cashArchive.getPeriodeId();
														if(p!=null && p.size()>0){
															for(int i=0; i<p.size(); i++){
																Periode period = (Periode)p.get(i);
																p_value.add(period.getName().trim());
																p_key.add(""+period.getOID());										
																//System.out.println(tc.getCountryName().trim().equalsIgnoreCase(currencyy.getCountryName().trim()));
															}
														}
													%>
                                                  <%= JSPCombo.draw(jspCashArchive.colNames[JspCashArchive.JSP_PERIODE_ID],"", sel_p, p_key, p_value, "", "formElemen") %> </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="1">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4"> <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4">&nbsp;</td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
								  <%
								   if(listCashArchive!=null && listCashArchive.size()>0)
								   {								  
										if(!cashArchive.getSearchFor().equals(""))
										{
											if(cashArchive.getSearchFor().equals("cashreceive") && cashRecPriv)
											{
								  %>
								  <tr>
								    <td><font size="3"><b><font size="2"><span class="level1">Cash 
                                      Receipt</span></font></b></font></td>
								  </tr>
								  <tr>
								    <td height="3"></td>
								  </tr>								  								  
								  <tr> 
                                    <td class="boxed1">
										
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="9%" class="tablehdr">Journal 
                                            Number</td>
                                          <td height="26" width="18%" class="tablehdr">Receipt 
                                            to Account</td>
                                          <td width="13%" class="tablehdr">Receipt 
                                            From</td>
                                          <td width="13%" class="tablehdr">Amount 
                                            IDR</td>
                                          <td width="9%" class="tablehdr">Transaction 
                                            Date</td>
                                          <td width="38%" class="tablehdr">Memo</td>
                                        </tr>
                                        <%												
													if(listCashArchive!=null && listCashArchive.size()>0)
													{
														for(int i=0; i<listCashArchive.size(); i++)
														{															
															CashReceive bd = (CashReceive)listCashArchive.get(i);
															//out.println("i = "+i);

															Coa coa = new Coa();
															try{
																coa = DbCoa.fetchExc(bd.getCoaId());
															}
															catch(Exception e){}
															
															Employee em = new Employee();
															try{
																em = DbEmployee.fetchExc(bd.getReceiveFromId());
															}
															catch(Exception e){}
															if(i%2!=0)
															{
																//out.println("ganjil = "+i);															
											%>
                                        <tr> 
                                          <td class="tablecell" width="9%"><a href="javascript:cmdEditReceipt('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell" width="18%"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell" width="13%"><%=em.getEmpNum()+ " - "+em.getName()%></td>
                                          <td class="tablecell" width="13%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="9%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell" width="38%"><%=getSubstring(bd.getMemo())%></td>
                                        </tr>
                                        <%
															}else
															{
																//out.println("genap = "+i);
											%>
                                        <tr> 
                                          <td class="tablecell1" width="9%"><a href="javascript:cmdEditReceipt('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell1" width="18%"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell1" width="13%"><%=em.getEmpNum()+ " - "+em.getName()%></td>
                                          <td class="tablecell1" width="13%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="9%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell1" width="38%"><%=getSubstring(bd.getMemo())%></td>
                                        </tr>
                                        <%
															}
														}
													}												
											%>
                                      </table>
									 </td>
                                  </tr>
								  <tr align="left" valign="top"> 
									<td height="8" align="left" colspan="7" class="command" width="99%"> 
									  <span class="command"> 
									  <% 
											int cmd = 0;
											if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) 
												cmd = iCommand; 
											else
											{
												if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
													cmd = JSPCommand.FIRST;
												else 
													cmd = prevCommand; 
											} 
											jspLine.setLocationImg(approot+"/images/ctr_line");
											jspLine.initDefault();
											
											jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
											jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
											jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
											jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
											
											jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
											jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
											jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
											jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								   
										%>
									  <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
								  </tr>
								  <%
											}else if(cashArchive.getSearchFor().equals("paymentpettycash") && cashPayPriv)
											{
								  %>
								  <tr>
								    <td><font size="3"><b><font size="2"><span class="level1">Petty 
                                      Cash Payment </span></font></b></font></td>
								  </tr>
								  <tr>
								    <td height="3"></td>
								  </tr>
								  <tr> 
                                    <td class="boxed1">
										
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="9%" class="tablehdr">Journal 
                                            Number</td>
                                          <td height="26" width="18%" class="tablehdr">Payment 
                                            from Account</td>
                                          <td width="19%" class="tablehdr">Amount 
                                            IDR</td>
                                          <td width="13%" class="tablehdr">Transaction 
                                            Date</td>
                                          <td width="34%" class="tablehdr">Memo</td>
                                          <td width="7%" class="tablehdr">Activity</td>
                                        </tr>
                                        <%												
													if(listCashArchive!=null && listCashArchive.size()>0)
													{
														for(int i=0; i<listCashArchive.size(); i++)
														{															
															PettycashPayment pp = (PettycashPayment)listCashArchive.get(i);
															//out.println("i = "+i);

															Coa coa = new Coa();
															try{
																coa = DbCoa.fetchExc(pp.getCoaId());
															}
															catch(Exception e){}
															if(i%2!=0)
															{
																//out.println("ganjil = "+i);															
											%>
                                        <tr> 
                                          <td class="tablecell" width="9%"><a href="javascript:cmdEditPayment('<%=pp.getOID()%>')"><%=pp.getJournalNumber()%></a></td>
                                          <td class="tablecell" width="18%"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell" width="19%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="13%"> 
                                            <div align="center"><%=JSPFormater.formatDate(pp.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell" width="34%"><%=getSubstring(pp.getMemo())%></td>
                                          <td class="tablecell" width="7%">
                                            <div align="center">
											<%if(pp.getActivityStatus().equals(I_Project.NA_POSTED_STATUS)){%>
											<img src="../images/yesx.gif" width="17" height="14">
											<%}else{%>
											-
											<%}%>
											</div>
                                          </td>
                                        </tr>
                                        <%
															}else
															{
																//out.println("genap = "+i);
											%>
                                        <tr> 
                                          <td class="tablecell1" width="9%"><a href="javascript:cmdEditPayment('<%=pp.getOID()%>')"><%=pp.getJournalNumber()%></a></td>
                                          <td class="tablecell1" width="18%"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell1" width="19%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="13%"> 
                                            <div align="center"><%=JSPFormater.formatDate(pp.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell1" width="34%"><%=getSubstring(pp.getMemo())%></td>
                                          <td class="tablecell1" width="7%">
                                            <div align="center">
											<%if(pp.getActivityStatus().equals(I_Project.NA_POSTED_STATUS)){%>
											<img src="../images/yesx.gif" width="17" height="14">
											<%}else{%>
											-
											<%}%>
											</div>
                                          </td>
                                        </tr>
                                        <%
															}
														}
													}												
											%>
                                      </table>
									 </td>
                                  </tr>
								  <tr align="left" valign="top"> 
									<td height="8" align="left" colspan="7" class="command" width="99%"> 
									  <span class="command"> 
									  <% 
											int cmd = 0;
											if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) 
												cmd = iCommand; 
											else
											{
												if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
													cmd = JSPCommand.FIRST;
												else 
													cmd = prevCommand; 
											} 
											jspLine.setLocationImg(approot+"/images/ctr_line");
											jspLine.initDefault();
											
											jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
											jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
											jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
											jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
											
											jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
											jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
											jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
											jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								   
										%>
									  <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
								  </tr>
								  <%
											}else if(cashArchive.getSearchFor().equals("paymentreplenishmentcash") && cashRepPriv)
											{
								  %>
								  <tr>
								    <td><font size="3"><b><font size="2"><span class="level1">Petty 
                                      Cash Replenishment</span></font></b></font></td>
								  </tr>
								  <tr>
								    <td height="3"></td>
								  </tr>
								  <tr> 
                                    <td class="boxed1">
										<table width="100%" border="0" cellspacing="1" cellpadding="1">											
										  <tr> 
											<td width="7%" class="tablehdr">Journal Number</td>										  
											<td height="26" width="20%" class="tablehdr">Replenishment for Account</td>
											<td width="20%" class="tablehdr">From Account</td>
											<td width="13%" class="tablehdr">Amount IDR</td>
											<td width="7%" class="tablehdr">Transaction Date</td>
											<td width="33%" class="tablehdr">Memo</td>
										  </tr>
										 	<%												
													if(listCashArchive!=null && listCashArchive.size()>0)
													{
														for(int i=0; i<listCashArchive.size(); i++)
														{															
															PettycashReplenishment pr = (PettycashReplenishment)listCashArchive.get(i);
															//out.println("i = "+i);

															Coa coa = new Coa();
															try{
																coa = DbCoa.fetchExc(pr.getReplaceCoaId());
															}
															catch(Exception e){}
															
															Coa coax = new Coa();
															try{
																coax = DbCoa.fetchExc(pr.getReplaceFromCoaId());
															}
															catch(Exception e){}
															
															if(i%2!=0)
															{
																//out.println("ganjil = "+i);															
											%>
										  <tr> 
											<td class="tablecell"><a href="javascript:cmdEditReplenishment('<%=pr.getOID()%>')"><%=pr.getJournalNumber()%></a></td>										  
											<td class="tablecell"><%=coa.getCode()+" - "+coa.getName()%></td>
											<td class="tablecell"><%=coax.getCode()+" - "+coax.getName()%></td>
											<td class="tablecell"><div align="right"><%=JSPFormater.formatNumber(pr.getReplaceAmount(), "#,###.##")%></div></td>
											<td class="tablecell"><div align="center"><%=JSPFormater.formatDate(pr.getTransDate(),"dd-MMM-yyyy")%></div></td>
											<td class="tablecell"><%=getSubstring1(pr.getMemo())%></td>
										  </tr>
										  	<%
															}else
															{
																//out.println("genap = "+i);
											%>
										  <tr> 
											<td class="tablecell1"><a href="javascript:cmdEditReplenishment('<%=pr.getOID()%>')"><%=pr.getJournalNumber()%></a></td>
											<td class="tablecell1"><%=coa.getCode()+" - "+coa.getName()%></td>
											<td class="tablecell1"><%=coax.getCode()+" - "+coax.getName()%></td>
											<td class="tablecell1"><div align="right"><%=JSPFormater.formatNumber(pr.getReplaceAmount(), "#,###.##")%></div></td>
											<td class="tablecell1"><div align="center"><%=JSPFormater.formatDate(pr.getTransDate(),"dd-MMM-yyyy")%></div></td>
											<td class="tablecell1"><%=getSubstring1(pr.getMemo())%></td>
										  </tr>
										  	<%
															}
														}
													}												
											%>
										</table>
									 </td>
                                  </tr>
								  <tr align="left" valign="top"> 
									<td height="8" align="left" colspan="7" class="command" width="99%"> 
									  <span class="command"> 
									  <% 
											int cmd = 0;
											if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )|| (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) 
												cmd = iCommand; 
											else
											{
												if(iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
													cmd = JSPCommand.FIRST;
												else 
													cmd = prevCommand; 
											} 
											jspLine.setLocationImg(approot+"/images/ctr_line");
											jspLine.initDefault();
											
											jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
											jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
											jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
											jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
											
											jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
											jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
											jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
											jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								   
										%>
									  <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> </span> </td>
								  </tr>
								  <%			
											}
										}
									}else
									{
								  %>
								  <tr> 
                                    <td class="boxed1">
										<table width="100%" border="0" cellspacing="1" cellpadding="1">																					  
										  <tr> 
											
                                          <td colspan="8" class="tablehdr" height="21">&nbsp;</td>										  
										  </tr>
										  <tr> 
										  <td class="tablecell1" colspan="8" height="25">
											<%if(iCommand==JSPCommand.NONE){%>
												Please click on the search button to find your data 
											<%}else{%>
												List is empty
											<%}%></td>
										  </tr>										  
										</table>
									 </td>
                                  </tr>
								  <%
									}
								  %>
                                </table>
                              </td>
                            </tr>							
                            <tr align="left" valign="top"> 
                              <td height="8" valign="middle" width="1%">&nbsp;</td>
                              <td height="8" colspan="2" width="83%">&nbsp; </td>
                            </tr>
                            <tr align="left" valign="top" > 
                              <td colspan="3" class="command">&nbsp; </td>
                            </tr>
                          </table>
						  <script language="JavaScript">
							<%if(iCommand==JSPCommand.NONE){%>
								cmdSearch();	
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
            <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
