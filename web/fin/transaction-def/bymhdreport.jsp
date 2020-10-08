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
		
	String header = "";
	
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
		header = "Titipan Uang";		
		whereClause = (whereClause.length()>0) ? whereClause + " and type=1" : "type=1";
		vectSize = DbCashReceive.getCount(whereClause);
	}
	else if(cashArchive.getSearchFor().equals("cashpayment")){
		header = "Pembayaran Titipan Uang";
		whereClause = (whereClause.length()>0) ? whereClause + " and type=2" : "type=2";
		vectSize = DbCashReceive.getCount(whereClause);
	}
	else if(cashArchive.getSearchFor().equals("paymentpettycash"))
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

	//out.println("whereClause : "+whereClause);
	
	// get record to display
	if(cashArchive.getSearchFor().equals("cashreceive") || cashArchive.getSearchFor().equals("cashpayment"))
	{
		listCashArchive = DbCashReceive.list(start,recordToGet, whereClause , orderClause);
		//out.println("listCashArchive : "+listCashArchive);
		
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
<!--



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
		document.frmcasharchive.action="bymhdarchive.jsp";
		document.frmcasharchive.submit();
	}

	function cmdEditReceipt(oidReceive){
		document.frmcasharchive.hidden_casharchive.value=oidReceive;
		document.frmcasharchive.action="titipandetailprint.jsp";
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
		document.frmcasharchive.action="bymhdarchive.jsp";
		document.frmcasharchive.submit();
	}

	function cmdListPrev(){
		document.frmcasharchive.command.value="<%=JSPCommand.PREV%>";
		document.frmcasharchive.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmcasharchive.action="bymhdarchive.jsp";
		document.frmcasharchive.submit();
		}

	function cmdListNext(){
		document.frmcasharchive.command.value="<%=JSPCommand.NEXT%>";
		document.frmcasharchive.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmcasharchive.action="bymhdarchive.jsp";
		document.frmcasharchive.submit();
	}

	function cmdListLast(){
		document.frmcasharchive.command.value="<%=JSPCommand.LAST%>";
		document.frmcasharchive.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmcasharchive.action="bymhdarchive.jsp";
		document.frmcasharchive.submit();
	}


	//-------------- script control line -------------------
//-->
</script>
<!--End Region JavaScript-->
<!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
					  String navigator = "<font class=\"lvl1\">BYMHD</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">BYMHD Report</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <span class="level1">BYMHD</span> 
                        &raquo; <span class="level2">BYMHD Arsip<br>
                        </span><!-- #EndEditable --></td>
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
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="26%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="26%"> 
                                      <div align="center"><b>PENJELASAN BIAYA 
                                        YANG MASIH HARUS DIBAYAR</b></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <div align="center"> 
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
                                        <%= JSPCombo.draw(jspCashArchive.colNames[JspCashArchive.JSP_PERIODE_ID],"", sel_p, p_key, p_value, "", "formElemen") %> </div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="1">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td valign="top"> 
                                      <table width="70%" border="0" cellspacing="1" cellpadding="1" align="center">
                                        <tr> 
                                          <td width="5%" class="tablehdr">No</td>
                                          <td width="33%" class="tablehdr">Uraian</td>
                                          <td width="20%" class="tablehdr">Jumlah</td>
                                          <td width="42%" class="tablehdr">Keterangan</td>
                                        </tr>
                                        <tr> 
                                          <td width="5%" class="tablecell1">&nbsp;</td>
                                          <td width="33%" class="tablecell1">&nbsp;</td>
                                          <td width="20%" class="tablecell1">&nbsp;</td>
                                          <td width="42%" class="tablecell1">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="5%" class="tablecell">&nbsp;</td>
                                          <td width="33%" class="tablecell">&nbsp;</td>
                                          <td width="20%" class="tablecell">&nbsp;</td>
                                          <td width="42%" class="tablecell">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="5%">&nbsp;</td>
                                          <td width="33%">&nbsp;</td>
                                          <td width="20%">&nbsp;</td>
                                          <td width="42%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
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
