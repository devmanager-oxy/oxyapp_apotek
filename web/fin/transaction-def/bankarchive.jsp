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
boolean bankPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_ARCHIVES);
//boolean bankDepPriv =  QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_DEPOSIT);
//boolean bankPOPriv =  QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_ON_PO);
//boolean bankNonPriv =  QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BANK, AppMenu.M2_MENU_BANK_PAYMENT_NON_PO);
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
	long oidBankArchive = JSPRequestValue.requestLong(request, "hidden_bankarchive");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "journal_number";

	CmdBankArchive cmdBankArchive = new CmdBankArchive(request);
	JSPLine jspLine = new JSPLine();
	Vector listBankArchive = new Vector(1,1);
	BankArchive bankArchive = new BankArchive();//cmdBankArchive.getBankArchive();
	JspBankArchive jspBankArchive = new JspBankArchive(request, bankArchive);

	// switch statement	
	iErrCode = cmdBankArchive.action(iCommand , oidBankArchive);
	
	// end switch
	jspBankArchive.requestEntityObject(bankArchive);// cmdBankArchive.getForm();
	
	bankArchive = jspBankArchive.getEntityObject();

	//count list All BankArchive
	//int vectSize = DbBankDeposit.getCount(whereClause);
	//out.println("test : "+vectSize);

	//recordToGet = vectSize;
	//out.println(jspBankArchive.getErrors());
	
	msgString =  cmdBankArchive.getMessage();
	//out.println("test : "+msgString);
	
	//out.println("itd = "+bankArchive.getIgnoreTransactionDate());
	
	if(iCommand==JSPCommand.NONE){
		bankArchive.setIgnoreInputDate(1);
		bankArchive.setIgnoreTransactionDate(1);
	}
		
	
	//modify where clause base on search for
	if(bankArchive.getIgnoreTransactionDate()==0)
	{//trans_date
		whereClause = "trans_date = '" + JSPFormater.formatDate(bankArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
	}
	if(!bankArchive.getJournalNumber().equals(""))
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "journal_number like '%" + bankArchive.getJournalNumber() + "%'";
	}
	if(bankArchive.getPeriodeId()!=0)
	{
		Periode periode = new Periode();
		try{
			periode = DbPeriode.fetchExc(bankArchive.getPeriodeId());
		}catch(Exception e){}
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() +"'";
	}
	if(bankArchive.getIgnoreInputDate()==0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(bankArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(bankArchive.getEndDate(), "yyyy-MM-dd") +"'";
	}	
	
	//out.println("<br>whereClause : "+whereClause+ " ---- <br>"+ bankArchive.getIgnoreTransactionDate());
	//whereClause = "";

	//int vectSize = DbBankDeposit.getCount(whereClause);
	int vectSize = 0;
	if(bankArchive.getSearchFor().equals("bankdeposit"))
	{
		vectSize = DbBankDeposit.getCount(whereClause);
	}else if(bankArchive.getSearchFor().equals("paymentbaseonpo"))
	{
		vectSize = DbBankpoPayment.getCount(whereClause);
	}else if(bankArchive.getSearchFor().equals("paymentnonpo"))
	{
		vectSize = DbBanknonpoPayment.getCount(whereClause);
	}

	
	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST))
	{
		start = cmdBankArchive.actionList(iCommand, start, vectSize, recordToGet);
//		out.println("ubah start "+iCommand+" "+ start+" "+ vectSize+" "+ recordToGet);
	} 

	
	// get record to display
	if(bankArchive.getSearchFor().equals("bankdeposit"))
	{
		listBankArchive = DbBankDeposit.list(start,recordToGet, whereClause , orderClause);
	}else if(bankArchive.getSearchFor().equals("paymentbaseonpo"))
	{
		listBankArchive = DbBankpoPayment.list(start,recordToGet, whereClause , orderClause);	
	}else if(bankArchive.getSearchFor().equals("paymentnonpo"))
	{
		listBankArchive = DbBanknonpoPayment.list(start,recordToGet, whereClause , orderClause);
	}
	
	//out.println("<br>start : "+start);
	//out.println("<br>vectSize : "+vectSize);
	
	//out.println("<br>listBankArchive : "+listBankArchive);
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

<%if(!bankPriv && (!bankDepPriv && !bankPOPriv && !bankNonPriv)){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	function cmdResetStart(){
		document.frmbankarchive.start.value="0";	
	}

	function cmdSearch(){
		document.frmbankarchive.start.value="0";	
		document.frmbankarchive.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmbankarchive.prev_command.value="<%=prevCommand%>";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdEditDeposit(oidBankDeposit){
		document.frmbankarchive.hidden_bankarchive.value=oidBankDeposit;
		document.frmbankarchive.action="bankdepositprint.jsp";
		document.frmbankarchive.submit();
	}

	function cmdEditpoPayment(oidBankpoPayment){
		document.frmbankarchive.hidden_bankarchive.value=oidBankpoPayment;
		document.frmbankarchive.action="bankpopaymentprint.jsp";
		document.frmbankarchive.submit();
	}
	
	function cmdEditnonpoPayment(oidBanknonpoPayment){
		document.frmbankarchive.hidden_bankarchive.value=oidBanknonpoPayment;
		document.frmbankarchive.action="banknonpopaymentdetailprint.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListFirst(){
		document.frmbankarchive.command.value="<%=JSPCommand.FIRST%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListPrev(){
		document.frmbankarchive.command.value="<%=JSPCommand.PREV%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
		}

	function cmdListNext(){
		document.frmbankarchive.command.value="<%=JSPCommand.NEXT%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListLast(){
		document.frmbankarchive.command.value="<%=JSPCommand.LAST%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmbankarchive.action="bankarchive.jsp";
		document.frmbankarchive.submit();
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
					  String navigator = "<font class=\"lvl1\">Bank</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Archives</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmbankarchive" method ="post" action="">
							<input type="hidden" name="command" value="<%=iCommand%>">
							<input type="hidden" name="vectSize" value="<%=vectSize%>">
							<input type="hidden" name="start" value="<%=start%>">
							<input type="hidden" name="prev_command" value="<%=prevCommand%>">
							<input type="hidden" name="hidden_bankarchive" value="<%=oidBankArchive%>">
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
													//out.println("Search : "+bankArchive.getSearchFor());
												%>
                                                  <select name="<%=jspBankArchive.colNames[jspBankArchive.JSP_SEARCH_FOR] %>" onChange="javascript:cmdSearch()">
                                                    <%if(bankDepView){%>
                                                    <option value="bankdeposit" <%if(bankArchive.getSearchFor().equals("bankdeposit")){%> selected <%}%>>Bank 
                                                    Deposit</option>
                                                    <%}%>
                                                    <%if(bankPOView){%>
                                                    <option value="paymentbaseonpo" <%if(bankArchive.getSearchFor().equals("paymentbaseonpo")){%> selected <%}%>>PO 
                                                    Based Payment </option>
                                                    <%}%>
                                                    <%if(bankNonpoView){%>
                                                    <option value="paymentnonpo" <%if(bankArchive.getSearchFor().equals("paymentnonpo")){%> selected <%}%>>Non 
                                                    PO Based Payment </option>
                                                    <%}%>
                                                  </select>
                                                </td>
                                                <td width="10%">Input Date</td>
                                                <td width="51%"> 
                                                  <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getStartDate()==null) ? new Date() : bankArchive.getStartDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                  &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;&nbsp;&nbsp;&nbsp; 
                                                  <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getEndDate()==null) ? new Date() : bankArchive.getEndDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>	
                                                  <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if(bankArchive.getIgnoreInputDate()==1){ %>checked<%}%>>
                                                  Ignore </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Journal Number</td>
                                                <td width="26%"> 
                                                  <input type="text" name="<%=jspBankArchive.colNames[jspBankArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= bankArchive.getJournalNumber() %>">
                                                </td>
                                                <td width="10%">Transaction Date</td>
                                                <td width="51%"> 
                                                  <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((bankArchive.getTransactionDate()==null) ? new Date() : bankArchive.getTransactionDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.<%=jspBankArchive.colNames[jspBankArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>	
                                                  <input name="<%=jspBankArchive.colNames[jspBankArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if(bankArchive.getIgnoreTransactionDate()==1){ %>checked<%}%>>
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
														String sel_p = ""+bankArchive.getPeriodeId();
														if(p!=null && p.size()>0){
															for(int i=0; i<p.size(); i++){
																Periode period = (Periode)p.get(i);
																p_value.add(period.getName().trim());
																p_key.add(""+period.getOID());										
																//System.out.println(tc.getCountryName().trim().equalsIgnoreCase(currencyy.getCountryName().trim()));
															}
														}
													%>
                                                  <%= JSPCombo.draw(jspBankArchive.colNames[JspBankArchive.JSP_PERIODE_ID],"", sel_p, p_key, p_value, "", "formElemen") %> </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="5"></td>
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
                                  <%if(bankArchive.getSearchFor().equals("bankdeposit") && bankDepView){%>
                                  <tr> 
                                    <td><b><font size="2">&nbsp;Bank Deposit </font></b> 
                                    </td>
                                  </tr>
                                  <%}else if(bankArchive.getSearchFor().equals("paymentbaseonpo") && bankPOView){%>
                                  <tr> 
                                    <td><b><font size="2">&nbsp;PO Based Payment</font></b> 
                                    </td>
                                  </tr>
                                  <%}else if(bankNonpoView){								  	
								  %>
                                  <tr> 
                                    <td><b><font size="2">&nbsp;Non PO Based Payment</font></b> 
                                    </td>
                                  </tr>
                                  <%}%>
                                  <tr> 
                                    <td height="3"></td>
                                  </tr>
                                  <%
								  
								  if(listBankArchive!=null && listBankArchive.size()>0){
													
										if(!bankArchive.getSearchFor().equals(""))
										{
											if(bankArchive.getSearchFor().equals("bankdeposit") && bankDepView)
											{
								  %>
                                  <tr> 
                                    <td class="boxed1"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="10%" class="tablehdr">Journal 
                                            Number</td>
                                          <td height="26" width="25%" class="tablehdr">Deposit 
                                            to Account</td>
                                          <td width="15%" class="tablehdr">Amount 
                                            IDR</td>
                                          <td width="10%" class="tablehdr">Transaction 
                                            Date</td>
                                          <td width="40%" class="tablehdr">Memo</td>
                                        </tr>
                                        <%												
													if(listBankArchive!=null && listBankArchive.size()>0)
													{
														for(int i=0; i<listBankArchive.size(); i++)
														{															
															BankDeposit bd = (BankDeposit)listBankArchive.get(i);
															//out.println("i = "+i);

															Coa coa = new Coa();
															try{
																coa = DbCoa.fetchExc(bd.getCoaId());
															}
															catch(Exception e){}
															if(i%2!=0)
															{
																//out.println("ganjil = "+i);															
											%>
                                        <tr> 
                                          <td class="tablecell"><a href="javascript:cmdEditDeposit('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell"><%=getSubstring(bd.getMemo())%></td>
                                        </tr>
                                        <%
															}else
															{
																//out.println("genap = "+i);
											%>
                                        <tr> 
                                          <td class="tablecell1"><a href="javascript:cmdEditDeposit('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell1"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell1"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell1"><%=getSubstring(bd.getMemo())%></td>
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
											}else if(bankArchive.getSearchFor().equals("paymentbaseonpo") && bankPOView)
											{
								  %>
                                  <tr> 
                                    <td class="boxed1"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="6%" class="tablehdr">Journal 
                                            Number</td>
                                          <td height="26" width="11%" class="tablehdr">Payment 
                                            from Account</td>
                                          <td width="5%" class="tablehdr">Payment 
                                            Method</td>
                                          <td width="12%" class="tablehdr">Cheque/Transfer 
                                            Number</td>
                                          <td width="8%" class="tablehdr">Payment 
                                            IDR</td>
                                          <td width="9%" class="tablehdr">Transaction 
                                            Date</td>
                                          <td width="13%" class="tablehdr">Vendor</td>
                                          <td width="6%" class="tablehdr">Journal 
                                            Status </td>
                                          <td width="30%" class="tablehdr">Memo</td>
                                        </tr>
                                        <%
													if(listBankArchive!=null && listBankArchive.size()>0)
													{
														for(int i=0; i<listBankArchive.size(); i++)
														{															
															BankpoPayment bp = (BankpoPayment)listBankArchive.get(i);
															//out.println("i = "+i);

															Coa coa = new Coa();
															try{
																coa = DbCoa.fetchExc(bp.getCoaId());
															}
															catch(Exception e){}
																													  
															Vendor vx = new Vendor();
															try{
																vx = DbVendor.fetchExc(bp.getVendorId());
															}
															catch(Exception e){}
															
															PaymentMethod pm = new PaymentMethod();
															try{
																pm = DbPaymentMethod.fetchExc(bp.getPaymentMethodId());
															}
															catch(Exception e){}
															if(i%2!=0)
															{
																//out.println("ganjil = "+i);															
											%>
                                        <tr> 
                                          <td class="tablecell" width="6%" nowrap><a href="javascript:cmdEditpoPayment('<%=bp.getOID()%>')"><%=bp.getJournalNumber()%></a></td>
                                          <td class="tablecell" width="11%" nowrap><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell" align="center" width="5%" nowrap>
                                            <div align="left"><%=pm.getDescription()%></div>
                                          </td>
                                          <td class="tablecell" width="12%" nowrap><%=bp.getRefNumber()%></td>
                                          <td class="tablecell" width="8%" nowrap> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="9%" nowrap> 
                                            <div align="center"><%=JSPFormater.formatDate(bp.getTransDate(), "dd-MMM-yyyy")%></div>
                                          </td>
                                          <td class="tablecell" width="13%" nowrap><%=vx.getName()%></td>
                                          <td class="tablecell" width="6%" nowrap> 
                                            <div align="center"><%=bp.getStatus()%></div>
                                          </td>
                                          <td class="tablecell" width="30%"><%=getSubstring1(bp.getMemo())%></td>
                                        </tr>
                                        <%
															}else 
															{
																//out.println("genap = "+i);
											%>
                                        <tr> 
                                          <td class="tablecell1" width="6%" nowrap><a href="javascript:cmdEditpoPayment('<%=bp.getOID()%>')"><%=bp.getJournalNumber()%></a></td>
                                          <td class="tablecell1" width="11%" nowrap><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell1" align="center" width="5%" nowrap>
                                            <div align="left"><%=pm.getDescription()%></div>
                                          </td>
                                          <td class="tablecell1" width="12%" nowrap><%=bp.getRefNumber()%></td>
                                          <td class="tablecell1" width="8%" nowrap> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="9%" nowrap> 
                                            <div align="center"><%=JSPFormater.formatDate(bp.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell1" width="13%" nowrap><%=vx.getName()%></td>
                                          <td class="tablecell1" width="6%" nowrap> 
                                            <div align="center"><%=bp.getStatus()%></div>
                                          </td>
                                          <td class="tablecell1" width="30%"><%=getSubstring1(bp.getMemo())%></td>
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
											}else if(bankArchive.getSearchFor().equals("paymentnonpo") && bankNonpoView)
											{
								  %>
                                  <tr> 
                                    <td class="boxed1"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td width="7%" class="tablehdr">Journal 
                                            Number</td>
                                          <td height="26" width="16%" class="tablehdr">Payment 
                                            from Account</td>
                                          <td width="8%" class="tablehdr">Payment 
                                            Method</td>
                                          <td width="12%" class="tablehdr">Bank 
                                            Reference</td>
                                          <td width="10%" class="tablehdr">Amount 
                                            IDR</td>
                                          <td width="9%" class="tablehdr">Transaction 
                                            Date</td>
                                          <td width="13%" class="tablehdr">Vendor</td>
                                          <td width="19%" class="tablehdr">Memo</td>
                                          <td width="6%" class="tablehdr">Activity</td>
                                        </tr>
                                        <%
													if(listBankArchive!=null && listBankArchive.size()>0)
													{
														for(int i=0; i<listBankArchive.size(); i++)
														{															
															BanknonpoPayment bp = (BanknonpoPayment)listBankArchive.get(i);
															//out.println("i = "+i);

															Coa coa = new Coa();
															try{
																coa = DbCoa.fetchExc(bp.getCoaId());
															}
															catch(Exception e){}
																													  
															Vendor vx = new Vendor();
															try{
																vx = DbVendor.fetchExc(bp.getVendorId());
															}
															catch(Exception e){}
															
															PaymentMethod pm = new PaymentMethod();
															try{
																pm = DbPaymentMethod.fetchExc(bp.getPaymentMethodId());
															}
															catch(Exception e){}
															if(i%2!=0)
															{
																//out.println("ganjil = "+i);															
											%>
                                        <tr> 
                                          <td class="tablecell" width="7%"><a href="javascript:cmdEditnonpoPayment('<%=bp.getOID()%>')"><%=bp.getJournalNumber()%></a></td>
                                          <td class="tablecell" width="16%"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell" align="center" width="8%"><%=pm.getDescription()%></td>
                                          <td class="tablecell" width="12%"><%=bp.getRefNumber()%></td>
                                          <td class="tablecell" width="10%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="9%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bp.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell" width="13%"><%=vx.getName()%></td>
                                          <td class="tablecell" width="19%"><%=getSubstring1(bp.getMemo())%></td>
                                          <td class="tablecell" width="6%"> 
                                            <div align="center"> 
                                              <%if(bp.getActivityStatus().equals(I_Project.NA_POSTED_STATUS)){%>
                                              <img src="../images/yesx.gif" width="17" height="14"> 
                                              <%}else{
											  if(bp.getType()==1){%>
                                              Advance 
                                              <%}else{%>
                                              - 
                                              <%}}%>
                                            </div>
                                          </td>
                                        </tr>
                                        <%
															}else
															{
																//out.println("genap = "+i);
											%>
                                        <tr> 
                                          <td class="tablecell1" width="7%"><a href="javascript:cmdEditnonpoPayment('<%=bp.getOID()%>')"><%=bp.getJournalNumber()%></a></td>
                                          <td class="tablecell1" width="16%"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell1" align="center" width="8%"><%=pm.getDescription()%></td>
                                          <td class="tablecell1" width="12%"><%=bp.getRefNumber()%></td>
                                          <td class="tablecell1" width="10%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="9%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bp.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell1" width="13%"><%=vx.getName()%></td>
                                          <td class="tablecell1" width="19%"><%=getSubstring1(bp.getMemo())%></td>
                                          <td class="tablecell1" width="6%"> 
                                            <div align="center"> 
                                              <%if(bp.getActivityStatus().equals(I_Project.NA_POSTED_STATUS)){%>
                                              <img src="../images/yesx.gif" width="17" height="14"> 
                                              <%}else{											  
											  if(bp.getType()==1){											  
											  %>
                                              Advance 
                                              <%}else{%>
                                              - 
                                              <%}}%>
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
											}
										}
									}else{
								  %>
                                  <tr align="left" valign="top"> 
                                    <td align="left" colspan="7" class="boxed1" width="99%"> 
                                      <table width="100%">
                                        <tr align="left" valign="top"> 
                                          <td height="21" align="left" colspan="7" class="tablehdr" width="99%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top"> 
                                          <td height="25" align="left" colspan="7" class="tablecell" width="99%"> 
                                            <%if(iCommand==JSPCommand.NONE){%>
                                            Please click on the search button 
                                            to find your data 
                                            <%}else{%>
                                            List is empty 
                                            <%}%>
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
