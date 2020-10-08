 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//boolean dreportPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_DONORREPORT, AppMenu.M2_MENU_DONORREPORT);
%>
<%
	if(session.getValue("DONOR_WORKPLAN")!=null){
		session.removeValue("DONOR_WORKPLAN");
	}

//jsp content
int iJSPCommand = JSPRequestValue.requestCommand(request);
ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();
long periodId = JSPRequestValue.requestLong(request, "period_id");

int reportType = JSPRequestValue.requestInt(request, "report_type");
int amountType = JSPRequestValue.requestInt(request, "amount_type");

if(periodId==0){
	periodId = openAp.getOID();
}

ActivityPeriod apx = new ActivityPeriod();
try{
	apx = DbActivityPeriod.fetchExc(periodId);
}
catch(Exception e){
}


Vector modules = DbModule.list(0,0, "activity_period_id="+periodId, "code");

int coutSubModule = DbModule.getCount("activity_period_id="+periodId+" and (level='S')");

//out.println("activity_period_id="+periodId+" and (level='M' or level='S')");

Vector listReport = new Vector();
SesReportWorkplan sesReport = new SesReportWorkplan();	

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<%if(!dreportPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
function cmdChangeParam(){
	document.form1.action="workplandetail.jsp";
	document.form1.submit();
}

function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptDonorWorkplanXLS?oid=<%=appSessUser.getLoginId()%>&amountType=<%=amountType%>&act=<%=periodId%>");
}

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/printxls2.gif')">
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
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Donor Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Workplan Detail</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <tr> 
                                    <td height="13"> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="16%">&nbsp;</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="83%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="16%" nowrap><b>Amount <%=baseCurrencyCode%> In</b> &nbsp; 
                                            <select name="amount_type" onChange="javascript:cmdChangeParam()">
                                              <option value="0" <%if(amountType==0){%>selected<%}%>>-</option>
                                              <option value="1" <%if(amountType==1){%>selected<%}%>>Thousand</option>
                                              <option value="2" <%if(amountType==2){%>selected<%}%>>Million</option>
                                            </select>
                                          </td>
                                          <td width="1%"><img src="../images/spacer.gif" width="19" height="13"></td>
                                          <td width="83%"><span class="level1"><b> 
                                            <%
									Vector tempPeriod = DbActivityPeriod.list(0,0, "", "start_date desc");
									%>
                                            Activity Period &nbsp; 
                                            <select name="period_id" onChange="javascript:cmdChangeParam()">
                                              <%if(tempPeriod!=null && tempPeriod.size()>0){
										  		for(int i=0; i<tempPeriod.size(); i++){
													ActivityPeriod ap = (ActivityPeriod)tempPeriod.get(i);
										  %>
                                              <option value="<%=ap.getOID()%>" <%if(ap.getOID()==periodId){%>selected<%}%>><%=ap.getName()%></option>
                                              <%}}%>
                                            </select>
                                            </b></span></td>
                                        </tr>
                                        <tr> 
                                          <td width="16%" nowrap height="21">&nbsp;</td>
                                          <td width="1%" height="21">&nbsp;</td>
                                          <td width="83%" height="21">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="20"> 
                                      <div align="center"><span class="level1"><font size="+1"><b>Workplan 
                                        Detail Report</b></font></span></div>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td height="20">
                                      <div align="center"><b> Period : <%=apx.getName()%></b></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="20">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="30%"> 
                                      <table width="100%" border="0" cellpadding="0" height="20" cellspacing="0">
                                        <tr> 
                                          <td width="4%" class="tablehdr" height="20">&nbsp;</td>
                                          <td width="4%" class="tablehdr" height="20">&nbsp;</td>
                                          <td width="14%" class="tablehdr" height="20">&nbsp;</td>
                                          <td width="14%" class="tablehdr" height="20">&nbsp;</td>
                                          <td width="13%" class="tablehdr" height="20">&nbsp;</td>
                                          <td width="13%" class="tablehdr" height="20">&nbsp;</td>
                                          <td width="10%" class="tablehdr" height="20">&nbsp;</td>
                                          <td colspan="2" class="tablehdr" height="20">Indirect 
                                            Expense </td>
                                          <td width="10%" class="tablehdr" height="20">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="4%" class="tablehdr" height="20"> 
                                            <div align="center"><b><font color="#FFFFFF">Code</font></b></div>
                                          </td>
                                          <td width="4%" class="tablehdr" height="20">Level</td>
                                          <td width="14%" class="tablehdr" height="20">Description</td>
                                          <td width="14%" class="tablehdr" height="20">Output 
                                            &amp; Deliverable</td>
                                          <td width="13%" class="tablehdr" height="20">Performance 
                                            Indicator </td>
                                          <td width="13%" class="tablehdr" height="20">Assumptions 
                                            &amp; Risk</td>
                                          <td width="10%" class="tablehdr" height="20">Direct 
                                            Cost</td>
                                          <td width="9%" class="tablehdr" height="20">Compensation</td>
                                          <td width="9%" class="tablehdr" height="20">Other 
                                            Overhead </td>
                                          <td width="10%" class="tablehdr" height="20">Total</td>
                                        </tr>
                                        <%
										double totalFA =  0;										
										double totalLog = 0;
										double grandTotalDirect = 0;
										double grandTotalInDirect = 0;
										
										double grandTotalFa = 0;
										double grandTotalLogs = 0;
										
										if(modules!=null && modules.size()>0){
										
												totalFA = DbTransactionActivityDetail.getTotalFA(periodId);
												totalLog = DbTransactionActivityDetail.getTotalLog(periodId);
												
												grandTotalDirect = DbTransactionActivityDetail.getGrandTotalDirectActivity(periodId, modules);
												grandTotalInDirect = DbTransactionActivityDetail.getGrandTotalInDirectActivity(periodId, modules);
												
												//thousand
												if(amountType==1){
													totalFA = totalFA/1000;
													totalLog = totalLog/1000;
													grandTotalDirect = grandTotalDirect/1000;
													grandTotalInDirect = grandTotalInDirect/1000;
												}
												else if(amountType==2){
													totalFA = totalFA/1000000;
													totalLog = totalLog/1000000;
													grandTotalDirect = grandTotalDirect/1000000;
													grandTotalInDirect = grandTotalInDirect/1000000;
												}
												
												
										
												for(int x=0; x<modules.size(); x++){
													Module d = (Module)modules.get(x);
													
													String str = "";
													String cls = "tablecell";
													boolean isBold = false;
													String bgcolor = "";
													boolean isMiring = false;
													
													String sb = "";
																										
													if(d.getLevel().equals("M")){
														//sb = "xxx";//&nbsp;&nbsp;&nbsp;";
														//sb = "&nbsp;&nbsp;&nbsp;&nbsp;";
														cls = "tablecell1";
														//bgcolor = "bgcolor=\"#B0C55F\"";
														bgcolor = "class=\"tablecell\"";
														isBold = true;
													}
													else if(d.getLevel().equals("S")){
														//sb = "xxx";//&nbsp;&nbsp;&nbsp;";
														//sb = "&nbsp;&nbsp;&nbsp;&nbsp;";
														cls = "tablecell1";
														//bgcolor = "bgcolor=\"#B8D293\"";
														bgcolor = "class=\"tablecell1\"";
														isBold = true;
													}
													else if(d.getLevel().equals("H")){
														isBold = true;
														bgcolor = "";//class=\"tablecell1\"";
														//bgcolor = "bgcolor=\"#E1ECD2\"";
														//sb = "xxxxxx";//"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
														//sb = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}
													else if(d.getLevel().equals("A")){
														cls = "";
														isBold = false;
														bgcolor = "";//class=\"tablecell1\"";
														//sb = "xxxxxxxxx";//"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
														//sb = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}
													else if(d.getLevel().equals("SA")){
														cls = "";
														isBold = false;
														bgcolor = "";//class=\"tablecell1\"";
														isMiring = true;
														//sb = "xxxxxxxxx";//"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
														//sb = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
													}
													
													str = sb;
													
													str = "";
													
													double direct = DbTransactionActivityDetail.getTotalDirectActivity(periodId, d.getOID());
													double inDirect = 0;//DbTransactionActivityDetail.getTotalInDirectActivity(periodId, d.getOID());
													
													if(d.getLevel().equals("M") || d.getLevel().equals("S")){
														inDirect = DbTransactionActivityDetail.getTotalInDirectActivity(periodId, d.getOID());
													}
													
													
													double fa = 0;
													double logs = 0;
													double grandTotal = 0;
													//thousand
													if(amountType==1){
														direct = direct/1000;
														inDirect = inDirect/1000;
													}
													else if(amountType==2){
														direct = direct/1000000;
														inDirect = inDirect/1000000;
													}
													
													//prorata
													if(d.getLevel().equals("M") || d.getLevel().equals("S")){
														if(reportType==0){
															if(grandTotalDirect+grandTotalInDirect==0){
																fa = 0;
																logs = 0;
															}else{
																fa = ((direct + inDirect)/(grandTotalDirect+grandTotalInDirect)) * totalFA;
																logs = ((direct + inDirect)/(grandTotalDirect+grandTotalInDirect))  * totalLog;
															}
														}
														//bagi sama rata per moodule
														else{
															if(coutSubModule==0){
																fa = 0;
																logs = 0;
															}else{
																fa = totalFA/coutSubModule;
																logs = totalLog/coutSubModule;
															}
															
															if(d.getLevel().equals(I_Project.ACTIVITY_CODE_M)){
																int count = DbModule.getCount("parent_id="+d.getOID());
																fa = fa * count;
																logs = logs * count;
															}
														}
													}
													
													if(d.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
														grandTotalFa = grandTotalFa + fa;
														grandTotalLogs = grandTotalLogs + logs;														
													}
													
													grandTotal = direct + inDirect + fa + logs;
													
													//add detail
													sesReport = new SesReportWorkplan();
													sesReport.setCode(d.getCode());
													sesReport.setLevel(d.getLevel());
													sesReport.setDescription(str+d.getDescription());
													sesReport.setOutput(str+d.getOutputDeliver());
													sesReport.setIndicator(str+d.getPerformIndicator());
													sesReport.setRisk(str+d.getAssumRisk());
													sesReport.setDirectCost(direct);
													sesReport.setCompensation(inDirect);
													sesReport.setOverhead(fa+logs);
													sesReport.setTotal(grandTotal);
													int fnt = 0;
													if(isBold)
														fnt = 1;
													sesReport.setFont(fnt);
													sesReport.setTemp("Detail");
													listReport.add(sesReport);
													
										%>
                                        <tr> 
                                          <td width="4%" <%=bgcolor%> height="20" valign="top"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=d.getCode()%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></td>
                                          <td width="4%" <%=bgcolor%> height="20" valign="top"> 
                                            <div align="center"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=d.getLevel()%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></div>
                                          </td>
                                          <td width="14%" <%=bgcolor%> height="20" valign="top"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=str+d.getDescription()%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></td>
                                          <td width="14%" <%=bgcolor%> height="20" valign="top"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=str+d.getOutputDeliver()%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></td>
                                          <td width="13%" <%=bgcolor%> height="20" valign="top"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=str+d.getPerformIndicator()%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></td>
                                          <td width="13%" <%=bgcolor%> height="20" valign="top"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=str+d.getAssumRisk()%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></td>
                                          <td width="10%" <%=bgcolor%> height="20" nowrap valign="top"> 
                                            <div align="right"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=(direct==0) ? "" : JSPFormater.formatNumber(direct, "#,###")%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></div>
                                          </td>
                                          <td width="9%" <%=bgcolor%> height="20" nowrap valign="top"> 
                                            <div align="right"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=(inDirect==0) ? "" : JSPFormater.formatNumber(inDirect, "#,###")%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></div>
                                          </td>
                                          <td width="9%" <%=bgcolor%> height="20" nowrap valign="top"> 
                                            <div align="right"> <font size="1"> 
                                              <%//=fa+"<br>"%>
                                              <%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=(fa==0) ? "" : JSPFormater.formatNumber(fa+logs, "#,###")%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></div>
                                          </td>
                                          <td width="10%" <%=bgcolor%> height="20" nowrap valign="top"> 
                                            <div align="right"><font size="1"><%=(isMiring) ? "<i>" : ""%><%=(isBold) ? "<b>" : ""%><%=(grandTotal==0) ? "" : JSPFormater.formatNumber(grandTotal, "#,###")%><%=(isBold) ? "</b>" : ""%><%=(isMiring) ? "</i>" : ""%></font></div>
                                          </td>
                                        </tr>
                                        <%
										if(d.getLevel().equals("M") || d.getLevel().equals("S")){%>
                                        <!--tr> 
                                          <td colspan="10" height="1"></td>
                                        </tr-->
										<tr> 
                                          <td colspan="10" height="1" background="<%=approot%>/images/line1.gif"><img src="<%=approot%>/images/line1.gif"></td>
                                        </tr>
                                        <%
										}else{%>
                                        <tr> 
                                          <td colspan="10" height="1" background="<%=approot%>/images/line1.gif"><img src="<%=approot%>/images/line1.gif"></td>
                                        </tr>
                                        <%}
										%>
                                        <%}}%>
										<%
													//add detail
													sesReport = new SesReportWorkplan();
													sesReport.setRisk("TOTAL EXPENDITURE");
													sesReport.setDirectCost(grandTotalDirect);
													sesReport.setCompensation(grandTotalInDirect);
													sesReport.setOverhead(grandTotalFa+grandTotalLogs);
													sesReport.setTotal(grandTotalDirect+grandTotalInDirect+grandTotalFa+grandTotalLogs);
													sesReport.setTemp("EndDetail");
													listReport.add(sesReport);										
										%>
                                        <!--level Liquid Assets-->
                                        <tr bgcolor="#B0C55F"> 
                                          <td colspan="6" height="20"> 
                                            <div align="right"><b>TOTAL EXPENDITURE 
                                              : </b><span class="level2"><b>&nbsp;</b></span></div>
                                          </td>
                                          <td width="10%" height="20" align="right"><b><font size="1"><%=JSPFormater.formatNumber(grandTotalDirect, "#,###")%></font></b></td>
                                          <td width="9%" height="20" align="right"><b><font size="1"><%=JSPFormater.formatNumber(grandTotalInDirect, "#,###")%></font></b></td>
                                          <td width="9%" height="20" align="right"><b><font size="1"><%=JSPFormater.formatNumber(grandTotalFa+grandTotalLogs, "#,###")%></font></b></td>
                                          <td width="10%" height="20" align="right"><b><font size="1"><%=JSPFormater.formatNumber(grandTotalDirect+grandTotalInDirect+grandTotalFa+grandTotalLogs, "#,###")%></font></b></td>
                                        </tr>
                                        <tr>
                                          <td width="4%" height="20">&nbsp;</td>
                                          <td width="4%" height="20">&nbsp;</td>
                                          <td width="14%" height="20">&nbsp;</td>
                                          <td width="14%" height="20">&nbsp;</td>
                                          <td width="13%" height="20">&nbsp;</td>
                                          <td width="13%" height="20">&nbsp;</td>
                                          <td width="10%" height="20">&nbsp;</td>
                                          <td width="9%" height="20">&nbsp;</td>
                                          <td width="9%" height="20">&nbsp;</td>
                                          <td width="10%" height="20">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="4%" height="20">&nbsp;</td>
                                          <td width="4%" height="20">&nbsp;</td>
                                          <td width="14%" height="20">&nbsp;</td>
                                          <td width="14%" height="20">&nbsp;</td>
                                          <td width="13%" height="20">&nbsp;</td>
                                          <td width="13%" height="20"> 
                                            <div align="right"><b>TOTAL F&amp;A 
                                              : &nbsp;</b></div>
                                          </td>
                                          <td width="10%" height="20"> 
                                            <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalFA, "#,###")%></b></font></div>
                                          </td>
                                          <td width="9%" height="20"><font size="1">&nbsp;</font></td>
                                          <td width="9%" height="20"><font size="1">&nbsp;</font></td>
                                          <td width="10%" height="20"><font size="1">&nbsp;</font></td>
                                        </tr>
										<%
													//add detail
													sesReport = new SesReportWorkplan();
													sesReport.setTemp("End");
													listReport.add(sesReport);

													//add detail
													sesReport = new SesReportWorkplan();
													sesReport.setDescription("TOTAL F&A");
													sesReport.setTotal(totalFA);
													sesReport.setTemp("Total");
													listReport.add(sesReport);	
													
													//add detail
													sesReport = new SesReportWorkplan();
													sesReport.setDescription("TOTAL LOGISTIC");
													sesReport.setTotal(totalLog);
													sesReport.setTemp("Total");
													listReport.add(sesReport);										
										
										%>
                                        <tr> 
                                          <td width="4%" height="20"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                          <td width="4%" height="20">&nbsp;</td>
                                          <td width="14%" height="20">&nbsp;</td>
                                          <td width="14%" height="20">&nbsp;</td>
                                          <td width="13%" height="20">&nbsp;</td>
                                          <td width="13%" height="20"> 
                                            <div align="right"><b>TOTAL LOGISTIC 
                                              : &nbsp;</b></div>
                                          </td>
                                          <td width="10%" height="20"> 
                                            <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalLog, "#,###")%></b></font></div>
                                          </td>
                                          <td width="9%" height="20"><font size="1">&nbsp;</font></td>
                                          <td width="9%" height="20"><font size="1">&nbsp;</font></td>
                                          <td width="10%" height="20"><font size="1">&nbsp;</font></td>
                                        </tr>
                                        <tr> 
                                          <td width="4%">&nbsp;</td>
                                          <td width="4%"></td>
                                          <td width="14%"></td>
                                          <td width="14%"></td>
                                          <td width="13%"></td>
                                          <td width="13%"></td>
                                          <td width="10%"><font size="1">&nbsp;</font></td>
                                          <td width="9%"><font size="1">&nbsp;</font></td>
                                          <td width="9%"><font size="1">&nbsp;</font></td>
                                          <td width="10%"><font size="1">&nbsp;</font></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="30%">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="30%"> 
                                      <table width="30%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="71">&nbsp;</td>
                                          <td width="45">&nbsp;</td>
                                          <td width="76">&nbsp; </td>
                                          <td width="176">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="30%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="30%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="30%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td width="30%">&nbsp;</td>
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
                          </table>
							<%
								session.putValue("DONOR_WORKPLAN", listReport);							
							%>								  						  
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
