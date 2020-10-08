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
boolean purchasePriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_PURCHASE, AppMenu.M2_MENU_PURCHASE_ARCHIVES);
%>
<!-- Jsp Block -->
<%!
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
	int iJSPCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidBankArchive = JSPRequestValue.requestLong(request, "hidden_purchase_id");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "journal_number";//trans_date";

	String poNumber = JSPRequestValue.requestString(request, "ponumber");		
	String poStatus = JSPRequestValue.requestString(request, "postatus");		
	long poPeriod = JSPRequestValue.requestLong(request, "poperiod");		
	Date poInputStart = (JSPRequestValue.requestString(request, "poinputstart")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "poinputstart"), "dd/MM/yyyy");		
	Date poInputEnd = (JSPRequestValue.requestString(request, "poinputend")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "poinputend"), "dd/MM/yyyy");		//JSPRequestValue.requestString(request, "poinputend");		
	int poInputIgnore = JSPRequestValue.requestInt(request, "poinputignore");		
	Date poTransDate = (JSPRequestValue.requestString(request, "potransdate")==null) ? new Date() : JSPFormater.formatDate(JSPRequestValue.requestString(request, "potransdate"), "dd/MM/yyyy");		//JSPRequestValue.requestString(request, "potransdate");		
	int poTransIgnore = JSPRequestValue.requestInt(request, "potransignore");
	
	if(iJSPCommand==JSPCommand.NONE || iJSPCommand==JSPCommand.BACK){
		poInputIgnore = 1;
		poTransIgnore = 1;
	}
	
	
	/*out.println("poNumber : "+poNumber);
	out.println("<br>poStatus : "+poStatus);
	out.println("<br>poPeriod : "+poPeriod);
	out.println("<br>poInputStart : "+poInputStart);
	out.println("<br>poInputEnd : "+poInputEnd);
	out.println("<br>poInputIgnore : "+poInputIgnore);
	out.println("<br>poTransDate : "+poTransDate);
	out.println("<br>poTransIgnore : "+poTransIgnore);
	*/
	
			
	
	//modify where clause base on search for
	if(poTransIgnore==0)
	{//trans_date
		whereClause = "trans_date = '" + JSPFormater.formatDate(poTransDate, "yyyy-MM-dd") + "'";
	}
	if(!poNumber.equals(""))
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "journal_number like '%" + poNumber + "%'";
	}
	if(poStatus.length()>0){
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "status = '" + poStatus + "'";
	}
	if(poPeriod!=0)
	{
		Periode periode = new Periode();
		try{
			periode = DbPeriode.fetchExc(poPeriod);
		}catch(Exception e){}
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() +"'";
	}
	if(poInputIgnore==0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(poInputStart, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(poInputEnd, "yyyy-MM-dd") +"'";
	}	
	
	//out.println("<br>whereClause : "+whereClause);
	//whereClause = "";

	int vectSize = DbPurchase.getCount(whereClause);
	
	if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
		(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
	{
		
		CmdBankArchive cmdBankArchive = new CmdBankArchive(request);
		start = cmdBankArchive.actionList(iJSPCommand, start, vectSize, recordToGet);
//		out.println("ubah start "+iJSPCommand+" "+ start+" "+ vectSize+" "+ recordToGet);
	} 

	Vector listPurchases = new Vector();
	if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
		(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST || iJSPCommand==JSPCommand.SUBMIT || iJSPCommand==JSPCommand.BACK))
	{
		 listPurchases= DbPurchase.list(start,recordToGet, whereClause , orderClause);
	}
	
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

<%if(!purchasePriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	function cmdSearch(){
		document.frmbankarchive.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmbankarchive.prev_command.value="<%=prevCommand%>";
		document.frmbankarchive.action="purchasearchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdEditDeposit(oidPurchase){
		document.frmbankarchive.hidden_purchase_id.value=oidPurchase;
		document.frmbankarchive.action="purchaseprint.jsp";
		document.frmbankarchive.submit();
	}
	
	function cmdEditnonpoPayment(oidPurchase){
		document.frmbankarchive.hidden_purchase_id.value=oidPurchase;
		document.frmbankarchive.action="banknonpopaymentdetailprint.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListFirst(){
		document.frmbankarchive.command.value="<%=JSPCommand.FIRST%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmbankarchive.action="purchasearchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListPrev(){
		document.frmbankarchive.command.value="<%=JSPCommand.PREV%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmbankarchive.action="purchasearchive.jsp";
		document.frmbankarchive.submit();
		}

	function cmdListNext(){
		document.frmbankarchive.command.value="<%=JSPCommand.NEXT%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmbankarchive.action="purchasearchive.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListLast(){
		document.frmbankarchive.command.value="<%=JSPCommand.LAST%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmbankarchive.action="purchasearchive.jsp";
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
					  String navigator = "<font class=\"lvl1\">Purchase</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Archive</span></font>";
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
							<input type="hidden" name="command" value="<%=iJSPCommand%>">
							<input type="hidden" name="vectSize" value="<%=vectSize%>">
							<input type="hidden" name="start" value="<%=start%>">
							<input type="hidden" name="prev_command" value="<%=prevCommand%>">
							<input type="hidden" name="hidden_purchase_id" value="<%=oidBankArchive%>">
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
                                                <td width="10%">PO Number</td>
                                                <td width="20%"> 
                                                  <input type="text" name="ponumber"  value="<%= poNumber %>">
                                                </td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="60%">&nbsp; </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Status</td>
                                                <td width="20%"> 
                                                  <select name="postatus">
                                                    <option value="">All</option>
                                                    <%for(int i=0; i<I_Project.purchStatusString.length; i++){%>
                                                    <option value="<%=I_Project.purchStatusString[i]%>" <%if(poStatus.equals(I_Project.purchStatusString[i])){%>selected<%}%>><%=I_Project.purchStatusString[i]%></option>
                                                    <%}%>
                                                  </select>
                                                </td>
                                                <td width="10%">Input Date</td>
                                                <td width="60%"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="15%" nowrap> 
                                                        <input name="poinputstart" value="<%=JSPFormater.formatDate((poInputStart==null) ? new Date() : poInputStart, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.poinputdatestart);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                        &nbsp;&nbsp;</td>
                                                      <td width="1%"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                      <td width="2%">&nbsp;&nbsp;to</td>
                                                      <td width="1%" nowrap><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                      <td width="18%" nowrap> 
                                                        <input name="poinputdateend" value="<%=JSPFormater.formatDate((poInputEnd==null) ? new Date() : poInputEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.poinputdateend);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                      <td width="1%"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                      <td width="62%"> 
                                                        <input name="poinputignore" type="checkBox" class="formElemen"  value="1" <%if(poInputIgnore==1){ %>checked<%}%>>
                                                        Ignore </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td width="10%">Periode</td>
                                                <td width="20%"> 
                                                  <% 
														Vector p = new Vector(1,1);
														p = DbPeriode.list(0,0, "", "NAME");
														Vector p_value = new Vector(1,1);
														Vector p_key = new Vector(1,1);
														String sel_p = ""+poPeriod;
														if(p!=null && p.size()>0){
															for(int i=0; i<p.size(); i++){
																Periode period = (Periode)p.get(i);
																p_value.add(period.getName().trim());
																p_key.add(""+period.getOID());										
																//System.out.println(tc.getCountryName().trim().equalsIgnoreCase(currencyy.getCountryName().trim()));
															}
														}
													%>
                                                  <%= JSPCombo.draw("poperiod","", sel_p, p_key, p_value, "", "formElemen") %> </td>
                                                <td width="10%">Transaction Date</td>
                                                <td width="60%"> 
                                                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                      <td width="15%" nowrap> 
                                                        <input name="potransdate" value="<%=JSPFormater.formatDate((poTransDate==null) ? new Date() : poTransDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbankarchive.potransdate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                      <td width="2%"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                      <td width="83%"> 
                                                        <input name="potransignore" type="checkBox" class="formElemen"  value="1" <%if(poTransIgnore==1){ %>checked<%}%>>
                                                        Ignore </td>
                                                    </tr>
                                                  </table>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="3"></td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="20"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="4" height="5"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;<b><font size="2">Purchase Order 
                                      List</font></b></td>
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
                                          <td height="26" width="14%" class="tablehdr">Vendor</td>
                                          <td width="20%" class="tablehdr">Vendor 
                                            Address </td>
                                          <td width="6%" class="tablehdr">Currency</td>
                                          <td width="12%" class="tablehdr">Total</td>
                                          <td width="10%" class="tablehdr">Transaction 
                                            Date</td>
                                          <td width="22%" class="tablehdr">Memo</td>
                                          <td width="7%" class="tablehdr">Status</td>
                                        </tr>
                                        <%												
													if(listPurchases!=null && listPurchases.size()>0)
													{
														for(int i=0; i<listPurchases.size(); i++)
														{															
															Purchase bd = (Purchase)listPurchases.get(i);
															//out.println("i = "+i);

															Vendor vnd = new Vendor();
															try{
																vnd = DbVendor.fetchExc(bd.getVendorId());
															}
															catch(Exception e){
															}
															
															if(i%2!=0)
															{
																//out.println("ganjil = "+i);															
											%>
                                        <tr> 
                                          <td class="tablecell" width="9%"><a href="javascript:cmdEditDeposit('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell" width="14%"><%=vnd.getCode()+" - "+vnd.getName()%></td>
                                          <td class="tablecell" width="20%"><%=vnd.getAddress()%></td>
                                          <td class="tablecell" width="6%"> 
                                            <div align="center"> 
                                              <%
										  Currency c = new Currency();
										  try{
										  		c = DbCurrency.fetchExc(bd.getCurrencyId());
										  }
										  catch(Exception e){
										  }
										  %>
                                              <%=c.getCurrencyCode()%> </div>
                                          </td>
                                          <td class="tablecell" width="12%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bd.getTotal(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell" width="10%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell" width="22%"><%=getSubstring(bd.getMemo())%></td>
                                          <td class="tablecell" width="7%"> 
                                            <div align="center"><%=bd.getStatus()%></div>
                                          </td>
                                        </tr>
                                        <%
															}else
															{
																//out.println("genap = "+i);
											%>
                                        <tr> 
                                          <td class="tablecell1" width="9%"><a href="javascript:cmdEditDeposit('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell1" width="14%"><%=vnd.getCode()+" - "+vnd.getName()%></td>
                                          <td class="tablecell1" width="20%"><%=vnd.getAddress()%></td>
                                          <td class="tablecell1" width="6%"> 
                                            <div align="center"> 
                                              <%
										  Currency c = new Currency();
										  try{
										  		c = DbCurrency.fetchExc(bd.getCurrencyId());
										  }
										  catch(Exception e){
										  }
										  %>
                                              <%=c.getCurrencyCode()%></div>
                                          </td>
                                          <td class="tablecell1" width="12%"> 
                                            <div align="right"><%=JSPFormater.formatNumber(bd.getTotal(), "#,###.##")%></div>
                                          </td>
                                          <td class="tablecell1" width="10%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell1" width="22%"><%=getSubstring(bd.getMemo())%></td>
                                          <td class="tablecell1" width="7%"> 
                                            <div align="center"><%=bd.getStatus()%></div>
                                          </td>
                                        </tr>
                                        <%
															}
															
														}
													}else{%>
                                        <tr> 
                                          <td class="tablecell1" colspan="8" height="25"> 
                                            <%if(iJSPCommand==JSPCommand.NONE){%>
                                            Please click the search button to 
                                            find your data. 
                                            <%}else{%>
                                            Data is empty. 
                                            <%}%>
                                          </td>
                                        </tr>
                                        <%}
																					
											%>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" colspan="7" class="command" width="99%">&nbsp;</td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                      <span class="command"> 
                                      <% 
											int cmd = 0;
											if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) 
												cmd = iJSPCommand; 
											else
											{
												if(iJSPCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE)
													cmd = JSPCommand.FIRST;
												else 
													cmd = prevCommand; 
											} 
											
											JSPLine jspLine = new JSPLine();
											
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
								   
								   
								   if(listPurchases!=null && listPurchases.size()>0){
										%>
                                      <%=jspLine.drawImageListLimit(cmd,vectSize,start,recordToGet)%> 
                                      <%}%>
                                      </span> </td>
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
						  <%if(iJSPCommand==JSPCommand.NONE){%>
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
