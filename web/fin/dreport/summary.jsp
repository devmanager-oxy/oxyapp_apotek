 
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
	if(session.getValue("DONOR_SUMMARY")!=null){
		session.removeValue("DONOR_SUMMARY");
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


Vector modules = DbModule.list(0,0, "activity_period_id="+periodId+" and (level='M' or level='S')", "code");

int coutSubModule = DbModule.getCount("activity_period_id="+periodId+" and (level='S')");

//out.println("activity_period_id="+periodId+" and (level='M' or level='S')");

Vector listReport = new Vector();
SesReportDonor sesReport = new SesReportDonor();	

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
	document.form1.action="summary.jsp";
	document.form1.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptDonorSummaryPDF?oid=<%=appSessUser.getLoginId()%>&reportType=<%=reportType%>&amountType=<%=amountType%>&act=<%=periodId%>");
}

function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptDonorSummaryXLS?oid=<%=appSessUser.getLoginId()%>&reportType=<%=reportType%>&amountType=<%=amountType%>&act=<%=periodId%>");
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/print2.gif','../images/printxls2.gif')">
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
            String navigator = "<font class=\"lvl1\">Donor Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Summary</span></font>";
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
                                          <td width="28%" nowrap>&nbsp;</td>
                                          <td width="2%">&nbsp;</td>
                                          <td width="17%">&nbsp;</td>
                                          <td width="2%">&nbsp;</td>
                                          <td width="51%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="28%" nowrap><b>F&amp;A And 
                                            Logistic Allocation</b> &nbsp;&nbsp; 
                                            <select name="report_type" onChange="javascript:cmdChangeParam()">
                                              <option value="0" <%if(reportType==0){%>selected<%}%>>Base 
                                              Line</option>
                                              <option value="1" <%if(reportType==1){%>selected<%}%>>Equaly 
                                              Devided Among Component</option>
                                            </select>
                                          </td>
                                          <td width="2%"><img src="../images/spacer.gif" width="19" height="13"></td>
                                          <td width="17%" nowrap><b>Amount <%=baseCurrencyCode%> In</b> &nbsp; 
                                            <select name="amount_type" onChange="javascript:cmdChangeParam()">
                                              <option value="0" <%if(amountType==0){%>selected<%}%>>-</option>
                                              <option value="1" <%if(amountType==1){%>selected<%}%>>Thousand</option>
                                              <option value="2" <%if(amountType==2){%>selected<%}%>>Million</option>
                                            </select>
                                          </td>
                                          <td width="2%"><img src="../images/spacer.gif" width="19" height="13"></td>
                                          <td width="51%"><span class="level1"><b> 
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
                                          <td width="28%" nowrap height="22">&nbsp;</td>
                                          <td width="2%" height="22">&nbsp;</td>
                                          <td width="17%" nowrap height="22">&nbsp;</td>
                                          <td width="2%" height="22">&nbsp;</td>
                                          <td width="51%" height="22">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="20"> 
                                      <div align="center"><span class="level1"><font size="+1"><b>Activity 
                                        Summary Report</b></font></span></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="20">
                                      <div align="center"><b>Period : <%=apx.getName()%></b></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td height="20">&nbsp; </td>
                                  </tr>
                                  <tr> 
                                    <td width="30%"> 
                                      <table width="100%" border="0" cellpadding="0" height="20" cellspacing="0">
                                        <tr> 
                                          <td width="30%" class="tablehdr" height="21">Project 
                                            Component </td>
                                          <td width="13%" class="tablehdr" height="21">Direct 
                                            Expense</td>
                                          <td width="13%" class="tablehdr" height="21">Compensation</td>
                                          <td width="13%" class="tablehdr" height="21">FA 
                                            Allocation </td>
                                          <td width="13%" class="tablehdr" height="21">Logistic 
                                            Allocation </td>
                                          <td width="13%" class="tablehdr" height="21"> 
                                            Total</td>
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
													String str1 = "";
													String cls = "tablecell1";
													boolean isBold = true;													
													if(d.getLevel().equals(I_Project.ACTIVITY_CODE_M)){
														str = "";
														str1 = "";
														cls = "tablecell";
														isBold = true;
													}
													else if(d.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
														str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
														str1 = "        ";
														cls = "tablecell1";
														isBold = false;
													}
													
													
													double direct = DbTransactionActivityDetail.getTotalDirectActivity(periodId, d.getOID());
													double inDirect = DbTransactionActivityDetail.getTotalInDirectActivity(periodId, d.getOID());
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
													if(reportType==0){
														if(grandTotalDirect+grandTotalInDirect==0){
															fa = 0;
															logs = 0;
														}else{
															fa = ((direct + inDirect)/(grandTotalDirect+grandTotalInDirect)) * totalFA;
															logs = ((direct + inDirect)/(grandTotalDirect+grandTotalInDirect))  * totalLog;
														}
													}
													//bagi sama rata per module
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
													
													if(d.getLevel().equals(I_Project.ACTIVITY_CODE_S)){
														grandTotalFa = grandTotalFa + fa;
														grandTotalLogs = grandTotalLogs + logs;														
													}
													
													grandTotal = direct + inDirect + fa + logs;
													
													//add detail
													sesReport = new SesReportDonor();
													sesReport.setComponent(str1+d.getCode()+" - "+d.getDescription());
													sesReport.setExpenses(direct);
													sesReport.setConpensation(inDirect);
													sesReport.setFa(fa);
													sesReport.setLogistic(logs);
													sesReport.setTotal(grandTotal);
													int fnt = 0;
													if(isBold)
														fnt = 1;
													sesReport.setFont(fnt);
													sesReport.setTemp("Detail");
													listReport.add(sesReport);
													
										%>
                                        <tr> 
                                          <td width="30%" class="<%=cls%>" nowrap height="17"><%=str%><%=(isBold) ? "<b>" : ""%><%=d.getCode()%><%=(isBold) ? "</b>" : ""%> - <%=(isBold) ? "<b>" : ""%><%=d.getDescription()%><%=(isBold) ? "</b>" : ""%></td>
                                          <td width="13%" class="<%=cls%>" height="17" nowrap> 
                                            <div align="right"><%=(isBold) ? "<b>" : ""%><%=(direct==0) ? "" : JSPFormater.formatNumber(direct, "#,###")%><%=(isBold) ? "</b>" : ""%></div>
                                          </td>
                                          <td width="13%" class="<%=cls%>" height="17" nowrap> 
                                            <div align="right"><%=(isBold) ? "<b>" : ""%><%=(inDirect==0) ? "" : JSPFormater.formatNumber(inDirect, "#,###")%><%=(isBold) ? "</b>" : ""%></div>
                                          </td>
                                          <td width="13%" class="<%=cls%>" height="17" nowrap> 
                                            <div align="right"> 
                                              <%//=fa+"<br>"%>
                                              <%=(isBold) ? "<b>" : ""%><%=(fa==0) ? "" : JSPFormater.formatNumber(fa, "#,###")%><%=(isBold) ? "</b>" : ""%></div>
                                          </td>
                                          <td width="13%" class="<%=cls%>" height="17" nowrap> 
                                            <div align="right"> 
                                              <%//=logs+"<br>"%>
                                              <%=(isBold) ? "<b>" : ""%><%=(logs==0) ? "" : JSPFormater.formatNumber(logs, "#,###")%><%=(isBold) ? "</b>" : ""%></div>
                                          </td>
                                          <td width="13%" class="<%=cls%>" height="17" nowrap> 
                                            <div align="right"><%=(isBold) ? "<b>" : ""%><%=(grandTotal==0) ? "" : JSPFormater.formatNumber(grandTotal, "#,###")%><%=(isBold) ? "</b>" : ""%></div>
                                          </td>
                                        </tr>
										<tr> 
                                          <td colspan="10" height="1"></td>
                                        </tr>
                                        <%}}%>
                                        <tr> 
                                          <td height="8" class="tablecell">&nbsp;</td>
                                          <td width="13%" height="8" align="right" class="tablecell">&nbsp;</td>
                                          <td width="13%" height="8" align="right" class="tablecell">&nbsp;</td>
                                          <td width="13%" height="8" align="right" class="tablecell">&nbsp;</td>
                                          <td width="13%" height="8" align="right" class="tablecell">&nbsp;</td>
                                          <td width="13%" height="8" align="right" class="tablecell">&nbsp;</td>
                                        </tr>
											<%
													//add detail
													sesReport = new SesReportDonor();
													sesReport.setTemp("Detail");
													listReport.add(sesReport);
											%>
                                        <!--level Liquid Assets-->
                                        <tr  bgcolor="#B0C55F"> 
                                          <td height="19"> 
                                            <div align="center"><b><span class="level2"><font color="#000000">Total 
                                              Expenditure</font></span></b> </div>
                                          </td>
                                          <td width="13%" height="19" align="right"><b><%=JSPFormater.formatNumber(grandTotalDirect, "#,###")%></b></td>
                                          <td width="13%" height="19" align="right" ><b><%=JSPFormater.formatNumber(grandTotalInDirect, "#,###")%></b></td>
                                          <td width="13%" height="19" align="right"><b><%=JSPFormater.formatNumber(grandTotalFa, "#,###")%></b></td>
                                          <td width="13%" height="19" align="right"><b><%=JSPFormater.formatNumber(grandTotalLogs, "#,###")%></b></td>
                                          <td width="13%" height="19" align="right"><b><%=JSPFormater.formatNumber(grandTotalDirect+grandTotalInDirect+grandTotalFa+grandTotalLogs, "#,###")%></b></td>
                                        </tr>
										<%													
													//add detail
													sesReport = new SesReportDonor();
													sesReport.setComponent("Total Expenditure");
													sesReport.setExpenses(grandTotalDirect);
													sesReport.setConpensation(grandTotalInDirect);
													sesReport.setFa(grandTotalFa);
													sesReport.setLogistic(grandTotalLogs);
													sesReport.setTotal(grandTotalDirect+grandTotalInDirect+grandTotalFa+grandTotalLogs);
													sesReport.setFont(1);
													sesReport.setTemp("Detail");
													listReport.add(sesReport);										
										%>
                                        <!--tr> 
                                          <td colspan="6" height="2" background="../images/line.gif"><img src="../images/line.gif"></td>
                                        </tr-->
                                        <tr> 
                                          <td width="30%" height="17">&nbsp;</td>
                                          <td width="13%" height="17">&nbsp;</td>
                                          <td width="13%" height="17"></td>
                                          <td width="13%" height="17"></td>
                                          <td width="13%" height="17"></td>
                                          <td width="13%" height="17"></td>
                                        </tr>
                                        <tr> 
                                          <td width="30%" height="17">&nbsp;</td>
                                          <td width="13%" height="17">&nbsp;</td>
                                          <td width="13%" height="17"></td>
                                          <td width="13%" height="17"></td>
                                          <td width="13%" height="17"></td>
                                          <td width="13%" height="17"></td>
                                        </tr>
                                        <tr> 
                                          <td width="30%" height="20"> 
                                            <div align="right"><b>TOTAL F&amp;A 
                                              : </b></div>
                                          </td>
                                          <td width="13%" height="20"> 
                                            <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalFA, "#,###")%></b></font></div>
                                          </td>
                                          <td width="13%" height="20"></td>
                                          <td width="13%" height="20"></td>
                                          <td width="13%" height="20"></td>
                                          <td width="13%" height="20"></td>
                                        </tr>
										<%
													//add detail
													sesReport = new SesReportDonor();													
													sesReport.setTemp("End");
													listReport.add(sesReport);										

													//add detail
													sesReport = new SesReportDonor();
													sesReport.setComponent("TOTAL F&A");
													sesReport.setTotal(totalFA);
													sesReport.setTemp("Total");
													listReport.add(sesReport);																				
										%>
                                        <tr> 
                                          <td width="30%" height="20"> 
                                            <div align="right"><b>TOTAL LOGISTIC 
                                              : </b></div>
                                          </td>
                                          <td width="13%" height="20"> 
                                            <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalLog, "#,###")%></b></font></div>
                                          </td>
                                          <td width="13%" height="20"></td>
                                          <td width="13%" height="20"></td>
                                          <td width="13%" height="20"></td>
                                          <td width="13%" height="20"></td>
                                        </tr>
										<%
													//add detail
													sesReport = new SesReportDonor();
													sesReport.setComponent("TOTAL LOGISTIC");
													sesReport.setTotal(totalLog);
													sesReport.setTemp("Total");
													listReport.add(sesReport);																				
										%>										
                                        <tr> 
                                          <td width="30%"></td>
                                          <td width="13%"></td>
                                          <td width="13%"></td>
                                          <td width="13%"></td>
                                          <td width="13%"></td>
                                          <td width="13%"></td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td width="30%">&nbsp; </td>
                                  </tr>
							<%
								session.putValue("DONOR_SUMMARY", listReport);							
							%>								  
                                  <tr> 
                                    <td width="30%"> 
										<table width="200" border="0" cellspacing="0" cellpadding="0">
										  <tr> 
											<td width="60"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>
											<td width="0">&nbsp;</td>
											<td width="120"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
											<td width="20">&nbsp;</td>
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
