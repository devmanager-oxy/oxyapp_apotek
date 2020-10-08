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
boolean glPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_GENERALLEDGER, AppMenu.M2_MENU_GENERALLEDGER_ARCHIVES);
%>
<!-- Jsp Block -->
<%!
	public String getSubstring(String s)
	{
		if(s.length()>90)
		{
			s="<a href=\"#\" title=\""+s+"\"><font color=\"black\">"+s.substring(0,85)+"...</font></a>";
		}
		return s;
	}
%>

<%@ include file="../calendar/calendarframe.jsp"%>

<%
	int iCommand = JSPRequestValue.requestCommand(request);
	int start = JSPRequestValue.requestInt(request, "start");
	int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
	long oidGlArchive = JSPRequestValue.requestLong(request, "hidden_glarchive");
	String srcRefNumber = JSPRequestValue.requestString(request, "src_ref_number");

	// variable declaration
	int recordToGet = 10;
	String msgString = "";
	int iErrCode = JSPMessage.NONE;
	String whereClause = "";
	String orderClause = "journal_number";//trans_date";

	CmdGlArchive cmdGlArchive = new CmdGlArchive(request);
	JSPLine jspLine = new JSPLine();
	Vector listGlArchive = new Vector(1,1);
	GlArchive glArchive = new GlArchive();//cmdGlArchive.getGlArchive();
	JspGlArchive jspGlArchive = new JspGlArchive(request, glArchive);

	// switch statement	
	iErrCode = cmdGlArchive.action(iCommand , oidGlArchive);
	
	// end switch
	jspGlArchive.requestEntityObject(glArchive);// cmdGlArchive.getForm();
	
	glArchive = jspGlArchive.getEntityObject();

	msgString =  cmdGlArchive.getMessage();
	
	if(iCommand==JSPCommand.NONE){
		glArchive.setIgnoreTransactionDate(1);
		glArchive.setIgnoreInputDate(1);
	}	
	
	whereClause = "journal_type = "+I_Project.JOURNAL_TYPE_GENERAL_LEDGER;
	
	//modify where clause base on search for
	if(glArchive.getIgnoreTransactionDate()==0)
	{//trans_date
		whereClause = " and trans_date = '" + JSPFormater.formatDate(glArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
	}
	if(!glArchive.getJournalNumber().equals(""))
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "journal_number like '%" + glArchive.getJournalNumber() + "%'";
	}
	if(glArchive.getPeriodeId()!=0)
	{
		Periode periode = new Periode();
		try{
			periode = DbPeriode.fetchExc(glArchive.getPeriodeId());
		}catch(Exception e){}
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() +"'";
	}
	if(glArchive.getIgnoreInputDate()==0)
	{
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(glArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(glArchive.getEndDate(), "yyyy-MM-dd") +"'";
	}	
	if(srcRefNumber!=null && srcRefNumber.length()>0){
		if (whereClause != "") whereClause = whereClause + " and ";
		whereClause = whereClause + "ref_number like '%"+srcRefNumber+"%'";
	}
	
	//out.println("<br>whereClause : "+whereClause);
	//whereClause = "";

	int vectSize = 0;
	
	vectSize = DbGl.getCount(whereClause);
	
	
	if((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV )||
		(iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST || iCommand==JSPCommand.BACK || iCommand==JSPCommand.SUBMIT))
	{
		start = cmdGlArchive.actionList(iCommand, start, vectSize, recordToGet);
//		out.println("ubah start "+iCommand+" "+ start+" "+ vectSize+" "+ recordToGet);
		listGlArchive = DbGl.list(start,recordToGet, whereClause , orderClause);
	} 

	
	
	
	
	
	//out.println("<br>start : "+start);
	//out.println("<br>vectSize : "+vectSize);
	
	//out.println("<br>listGlArchive : "+listGlArchive);
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

<%if(!glPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>


	function cmdSearch(){
		document.frmglarchive.command.value="<%=JSPCommand.SUBMIT%>";
		document.frmglarchive.prev_command.value="<%=prevCommand%>";
		document.frmglarchive.action="glarchive.jsp";
		document.frmglarchive.submit();
	}

	function cmdEditGl(oidGl){
		document.frmglarchive.hidden_glarchive.value=oidGl;
		document.frmglarchive.action="glprint.jsp";
		document.frmglarchive.submit();
	}
	
	function cmdListFirst(){
		document.frmglarchive.command.value="<%=JSPCommand.FIRST%>";
		document.frmglarchive.prev_command.value="<%=JSPCommand.FIRST%>";
		document.frmglarchive.action="glarchive.jsp";
		document.frmglarchive.submit();
	}

	function cmdListPrev(){
		document.frmglarchive.command.value="<%=JSPCommand.PREV%>";
		document.frmglarchive.prev_command.value="<%=JSPCommand.PREV%>";
		document.frmglarchive.action="glarchive.jsp";
		document.frmglarchive.submit();
		}

	function cmdListNext(){
		document.frmglarchive.command.value="<%=JSPCommand.NEXT%>";
		document.frmglarchive.prev_command.value="<%=JSPCommand.NEXT%>";
		document.frmglarchive.action="glarchive.jsp";
		document.frmglarchive.submit();
	}

	function cmdListLast(){
		document.frmglarchive.command.value="<%=JSPCommand.LAST%>";
		document.frmglarchive.prev_command.value="<%=JSPCommand.LAST%>";
		document.frmglarchive.action="glarchive.jsp";
		document.frmglarchive.submit();
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
					  String navigator = "<font class=\"lvl1\">General Journal</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Archives</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frmglarchive" method ="post" action="">
							<input type="hidden" name="command" value="<%=iCommand%>">
							<input type="hidden" name="vectSize" value="<%=vectSize%>">
							<input type="hidden" name="start" value="<%=start%>">
							<input type="hidden" name="prev_command" value="<%=prevCommand%>">
							<input type="hidden" name="hidden_glarchive" value="<%=oidGlArchive%>">
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
                                                <td width="13%">Journal Number</td>
                                                <td width="26%"> 
                                                  <input type="text" name="<%=jspGlArchive.colNames[jspGlArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= glArchive.getJournalNumber() %>">
                                                </td>
                                                <td width="10%">&nbsp;</td>
                                                <td width="51%">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Ref. Number</td>
                                                <td width="26%"> 
                                                  <input type="text" name="src_ref_number"  value="<%=srcRefNumber %>">
                                                </td>
                                                <td width="10%">Input Date</td>
                                                <td width="51%"> 
                                                  <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getStartDate()==null) ? new Date() : glArchive.getStartDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" >
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                  &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;&nbsp;&nbsp;&nbsp; 
                                                  <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getEndDate()==null) ? new Date() : glArchive.getEndDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" >
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>	
                                                  <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if(glArchive.getIgnoreInputDate()==1){ %>checked<%}%>>
                                                  Ignore </td>
                                              </tr>
                                              <tr> 
                                                <td width="13%">Periode</td>
                                                <td width="26%"> 
                                                  <% 
														Vector p = new Vector(1,1);
														p = DbPeriode.list(0,0, "", "NAME");
														Vector p_value = new Vector(1,1);
														Vector p_key = new Vector(1,1);
														String sel_p = ""+glArchive.getPeriodeId();
														if(p!=null && p.size()>0){
															for(int i=0; i<p.size(); i++){
																Periode period = (Periode)p.get(i);
																p_value.add(period.getName().trim());
																p_key.add(""+period.getOID());										
																//System.out.println(tc.getCountryName().trim().equalsIgnoreCase(currencyy.getCountryName().trim()));
															}
														}
													%>
                                                  <%= JSPCombo.draw(jspGlArchive.colNames[JspGlArchive.JSP_PERIODE_ID],"", sel_p, p_key, p_value, "", "formElemen") %> </td>
                                                <td width="10%">Transaction Date</td>
                                                <td width="51%"> 
                                                  <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((glArchive.getTransactionDate()==null) ? new Date() : glArchive.getTransactionDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" >
                                                  <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmglarchive.<%=jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>	
                                                  <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if(glArchive.getIgnoreTransactionDate()==1){ %>checked<%}%>>
                                                  Ignore </td>
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
                                              <tr> 
                                                <td colspan="4"><b><font size="2">General 
                                                  Ledger List</font></b> </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td class="boxed1"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr> 
                                          <td height="26" width="13%" class="tablehdr">Journal 
                                            Number</td>
                                          <td width="13%" class="tablehdr">Transaction 
                                            Date</td>
                                          <td width="14%" class="tablehdr">Reference 
                                            Number</td>
                                          <td width="60%" class="tablehdr">Memo</td>
                                        </tr>
                                        <%												
										if(listGlArchive!=null && listGlArchive.size()>0)
										{
											for(int i=0; i<listGlArchive.size(); i++)
											{															
												Gl bd = (Gl)listGlArchive.get(i);
												//out.println("i = "+i);

												if(i%2!=0)
												{
																//out.println("ganjil = "+i);															
											%>
                                        <tr> 
                                          <td class="tablecell" width="13%"><a href="javascript:cmdEditGl('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell" width="13%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell" width="14%"> 
                                            <div align="left"><%=bd.getRefNumber()%></div>
                                          </td>
                                          <td class="tablecell" width="60%"><%=getSubstring(bd.getMemo())%></td>
                                        </tr>
                                        <%
											}else
											{
												//out.println("genap = "+i);
											%>
                                        <tr> 
                                          <td class="tablecell1" width="13%"><a href="javascript:cmdEditGl('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                          <td class="tablecell1" width="13%"> 
                                            <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                          </td>
                                          <td class="tablecell1" width="14%"> 
                                            <div align="left"><%=bd.getRefNumber()%></div>
                                          </td>
                                          <td class="tablecell1" width="60%"><%=getSubstring(bd.getMemo())%></td>
                                        </tr>
                                        <%
													}
												}
																							
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
                                  <%}//if list null
								  else{%>
                                  <tr> 
                                    <td class="tablecell1" colspan="7"> 
                                      <%if(iCommand==JSPCommand.NONE){%>
                                      Please click search button to get your data. 
                                      <%}else{%>
                                      Record is empty 
                                      <%}%>
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
