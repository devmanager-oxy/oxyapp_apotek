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
	
	if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + " status='OPEN'";
	

	Vector listPurchases = new Vector();
	listPurchases= DbPurchase.list(0,0, whereClause , orderClause);
	
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



<%if(!purchasePriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>

	function cmdSearch(){
		document.frmbankarchive.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmbankarchive.prev_command.value="<%=prevCommand%>";
		document.frmbankarchive.action="purchasealloc_list.jsp";
		document.frmbankarchive.submit();
	}

	function cmdEditDeposit(oidPurchase){
		document.frmbankarchive.hidden_purchase_id.value=oidPurchase;
		document.frmbankarchive.command.value="<%=JSPCommand.EDIT%>";
		document.frmbankarchive.action="purchaseitem_alloc.jsp";
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
		document.frmbankarchive.action="purchasealloc_list.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListPrev(){
		document.frmbankarchive.command.value="<%=JSPCommand.PREV%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmbankarchive.action="purchasealloc_list.jsp";
		document.frmbankarchive.submit();
		}

	function cmdListNext(){
		document.frmbankarchive.command.value="<%=JSPCommand.NEXT%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmbankarchive.action="purchasealloc_list.jsp";
		document.frmbankarchive.submit();
	}

	function cmdListLast(){
		document.frmbankarchive.command.value="<%=JSPCommand.LAST%>";
		document.frmbankarchive.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmbankarchive.action="purchasealloc_list.jsp";
		document.frmbankarchive.submit();
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
					  String navigator = "<font class=\"lvl1\">Purchase</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Allocate Cost</span></font>";
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
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                          <input type="hidden" name="hidden_purchase_id" value="<%=oidBankArchive%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr align="left" valign="top"> 
                              <td height="8"  colspan="3" class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <!--DWLayoutTable-->
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;<b><font size="2">Purchase Order 
                                      List To be Allocated For Cost Sharring</font></b></td>
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
                                      <span class="command"> </span> </td>
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
<!-- #EndTemplate --></html>
