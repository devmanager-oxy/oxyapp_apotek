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
//jsp content
	if(session.getValue("DONOR_IFC_GROUP")!=null){
		session.removeValue("DONOR_IFC_GROUP");
	}

int iJSPCommand = JSPRequestValue.requestCommand(request);
ActivityPeriod openAp = DbActivityPeriod.getOpenPeriod();
long periodId = JSPRequestValue.requestLong(request, "period_id");

int reportType = JSPRequestValue.requestInt(request, "report_type");
int amountType = JSPRequestValue.requestInt(request, "amount_type");

//out.println("reportType : "+reportType);
//out.println("amountType : "+amountType);


if(periodId==0){
	periodId = openAp.getOID();
}

//out.println("periodId : "+periodId);

ActivityPeriod apx = new ActivityPeriod();
try{
	apx = DbActivityPeriod.fetchExc(periodId);
}
catch(Exception e){
}


Vector modules = DbModule.list(0,0, "activity_period_id="+periodId+" and (level='M' or level='S')", "code");

int coutSubModule = DbModule.getCount("activity_period_id="+periodId+" and (level='S')");

//out.println("activity_period_id="+periodId+" and (level='M' or level='S')");

double totalFA = DbTransactionActivityDetail.getTotalFA(periodId);
double totalLog = DbTransactionActivityDetail.getTotalLog(periodId);
double grandTotal = DbTransactionActivityDetail.getGrandTotalByPeriod(periodId);
double totalOverHead = totalFA + totalLog;

Vector listReport = new Vector();
SesReportIfc sesReport = new SesReportIfc();	

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Finance System</title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--
<%if(!dreportPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
function cmdChangeParam(){
	document.form1.action="natureexpensecategory.jsp";
	document.form1.submit();
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptDonorIFCGroupPDF?oid=<%=appSessUser.getLoginId()%>&reportType=<%=reportType%>&amountType=<%=amountType%>&act=<%=periodId%>");
}

function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptDonorIFCGroupXLS?oid=<%=appSessUser.getLoginId()%>&reportType=<%=reportType%>&amountType=<%=amountType%>&act=<%=periodId%>");
}

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
            String navigator = "<font class=\"lvl1\">Donor Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Expense Group</span></font>";
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
						  <%try{%>	
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr> 
                            <td class="container"> 
                              <table width="70%" border="0" cellspacing="0" cellpadding="0" align="center">
                                <tr> 
                                  <td> 
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                      <tr> 
                                        <td width="48%">&nbsp;</td>
                                        <td width="2%">&nbsp;</td>
                                        <td width="20%">&nbsp;</td>
                                        <td width="1%">&nbsp;</td>
                                        <td width="29%">&nbsp;</td>
                                      </tr>
                                      <tr> 
                                        <td width="48%" nowrap>
                                          <div align="right"><b>F&amp;A And Logistic 
                                            Allocation</b> 
                                            <select name="report_type" onChange="javascript:cmdChangeParam()">
                                              <option value="0" <%if(reportType==0){%>selected<%}%>>Base 
                                              Line</option>
                                              <option value="1" <%if(reportType==1){%>selected<%}%>>Equaly 
                                              Devided Among Category</option>
                                            </select>
                                          </div>
                                        </td>
                                        <td width="2%" nowrap><img src="../images/spacer.gif" width="19" height="13"></td>
                                        <td width="20%" nowrap> 
                                          <div align="center"><b>Amount <%=baseCurrencyCode%> In</b> &nbsp; 
                                            <select name="amount_type" onChange="javascript:cmdChangeParam()">
                                              <option value="0" <%if(amountType==0){%>selected<%}%>>-</option>
                                              <option value="1" <%if(amountType==1){%>selected<%}%>>Thousand</option>
                                              <option value="2" <%if(amountType==2){%>selected<%}%>>Million</option>
                                            </select>
                                          </div>
                                        </td>
                                        <td width="1%"><img src="../images/spacer.gif" width="19" height="13"></td>
                                        <td width="29%" nowrap><span class="level1"><b> 
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
                                        <td width="48%" nowrap height="13">&nbsp;</td>
                                        <td width="2%" nowrap height="13">&nbsp;</td>
                                        <td width="20%" nowrap height="13">&nbsp;</td>
                                        <td width="1%" height="13">&nbsp;</td>
                                        <td width="29%" height="13">&nbsp;</td>
                                      </tr>
                                    </table>
                                  </td>
                                </tr>
                                <tr> 
                                  <td> 
                                    <div align="center"><span class="level1"><font size="+1"><b>Financial 
                                      Report To IFC</b></font></span></div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td> 
                                      <div align="center"><b><font size="3">By 
                                        Expenses Group</font></b></div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td> 
                                    <div align="center"><b>Period : <%=apx.getName()%></b></div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>&nbsp;</td>
                                </tr>
                                <tr> 
                                  <td> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                                        <tr> 
                                          <td width="63%" class="tablehdr" height="21">Expense 
                                            Group</td>
                                          <td width="22%" class="tablehdr" height="21">Total 
                                            Expenditure</td>
                                          <td width="15%" class="tablehdr" height="21">% 
                                            to Total</td>
                                        </tr>
                                        <%
								  Vector v123 = DbCoaGroupAlias.list(0,0, "", "");
								  
								  double totalCategory = DbTransactionActivityDetail.getTotalAmountByGroup(periodId);
								  //out.println("totalCategory : "+totalCategory);
								  
								  if(v123!=null && v123.size()>0){
								  	
								  int si = v123.size();
								  
								  for(int i=0; i<v123.size(); i++){
								  		
										CoaGroupAlias ec = (CoaGroupAlias)v123.get(i);
										
										String css = "tablecell";
										if(i%2>0){
											//css = "";
										}
										
										Vector detailCoas = DbTransactionActivityDetail.getDetailGroupCoaList(ec.getOID(), periodId);
										
										
										double amount = DbTransactionActivityDetail.getAmountByGroupId(ec.getOID(), periodId);
										
										//out.println("amount : "+amount);
										//out.println("totalOverHead : "+totalOverHead);
										//out.println("totalCategory : "+totalCategory);
										
										if(reportType==0){
											if(totalCategory==0){
												amount = amount;
											}else{											
												amount = amount + (amount/totalCategory * totalOverHead);
											}
										}
										else{
											if(si==0){
												amount = amount;
											}else{
												amount = amount + (totalOverHead/si);
											}
										}
										
										double percent = (amount/grandTotal) * 100;
										if(grandTotal==0){
											percent = 0;
										}												
										
										//out.println(periodId);
										
										if(amountType==1){
											  amount = amount/1000;	
										}
										else if(amountType==2){
											amount = amount/1000000;		
										}
													//add detail
													sesReport = new SesReportIfc();
													sesReport.setDescription(ec.getName());
													sesReport.setTotal(amount);
													sesReport.setPercent(percent);
													sesReport.setTemp("Detail");
													sesReport.setFont(1);
													listReport.add(sesReport);
										
								  %>
                                        <tr> 
                                          <td width="63%" class="<%=css%>" height="17"><b><%=ec.getName()%></b></td>
                                          <td width="22%" class="<%=css%>" height="17"> 
                                            <div align="right"><b><%=(amount==0) ? "" : JSPFormater.formatNumber(amount, "#,###.##")%></b></div>
                                          </td>
                                          <td width="15%" class="<%=css%>" height="17"> 
                                            <div align="right"><b><%=(percent==0) ? "" : JSPFormater.formatNumber(percent, "#,###.##")+"%"%></b></div>
                                          </td>
                                        </tr>
										<tr> 
                                          <td colspan="3" height="1"></td>
                                        </tr>
                                        <%
									  
									  if(detailCoas!=null && detailCoas.size()>0){
									  		for(int ix=0; ix<detailCoas.size(); ix++){
												Coa coa = (Coa)detailCoas.get(ix);
												
												String str = "tablecell1";
												if(ix%2!=0){
													//str = "";
												}
									  %>
                                        <tr> 
                                          <td width="63%" class="<%=str%>" height="17">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=coa.getName()%></td>
                                          <td width="22%" class="<%=str%>" height="17"> 
                                            <%
										  		amount = coa.getOpeningBalance();
												
												//out.println("totalOverHead : "+totalOverHead);
												//out.println("<br>amount : "+JSPFormater.formatNumber(amount,"#,###"));											
												//out.println("<br>totalCategory : "+JSPFormater.formatNumber(totalCategory, "#,###"));
												
												if(reportType==0){
													if(totalCategory==0){
														amount = amount;
													}else{
														amount = amount + (amount/totalCategory * totalOverHead);
													}
												}
												else{
													if(si==0){
														amount = amount;
													}else{
														amount = amount + (totalOverHead/si);
													}
												}
												
												//out.println("<br>amount : "+amount);
												//out.println("<br>grandTotal : "+JSPFormater.formatNumber(grandTotal, "#,###"));
												
												percent = (amount/grandTotal) * 100;
												if(grandTotal==0){
													percent = 0;
												}		
												
												//out.println("<br>amount/grandTotal : "+JSPFormater.formatNumber(percent, "#,###.##"));
												
												
												//out.println(periodId);
												
												if(amountType==1){
													  amount = amount/1000;	
												}
												else if(amountType==2){
													amount = amount/1000000;		
												}
													//add detail
													sesReport = new SesReportIfc();
													sesReport.setDescription("          "+coa.getName());
													sesReport.setTotal(amount);
													sesReport.setPercent(percent);
													sesReport.setTemp("Detail");
													listReport.add(sesReport);
												
										  %>
                                            <div align="right"><%=(amount==0) ? "" : JSPFormater.formatNumber(amount, "#,###.##")%></div>
                                          </td>
                                          <td width="15%" class="<%=str%>" height="17"> 
                                            <div align="right"><%=(percent==0) ? "" : JSPFormater.formatNumber(percent, "#,###.##")+"%"%></div>
                                          </td>
                                        </tr>
										<tr> 
                                          <td colspan="3" height="1"></td>
                                        </tr>
                                        <%}}%>
                                        <%}}%>
											<%
													//add detail
													sesReport = new SesReportIfc();
													sesReport.setTemp("Detail");
													listReport.add(sesReport);
											%>
										
                                        <tr bgcolor="#B0C55F"> 
                                          <td width="63%" height="21"> 
                                            <div align="center"><b><font color="#000000">Grand 
                                              Total </font></b></div>
                                          </td>
                                          <td width="22%" height="21"> 
                                            <%
										if(amountType==1){
											  grandTotal = grandTotal/1000;	
										  }
										  else if(amountType==2){
											  grandTotal = grandTotal/1000000;		
										  }
										%>
                                            <div align="right"><b><font color="#000000"><%=(grandTotal==0) ? "" : JSPFormater.formatNumber(grandTotal, "#,###.##")%></font></b></div>
                                          </td>
                                          <td width="15%" height="21"> 
                                            <div align="right"><b><font color="#000000">100%</font></b></div>
                                          </td>
                                        </tr>
										<%													
													//add detail
													sesReport = new SesReportIfc();
													sesReport.setDescription("Grand Total");
													sesReport.setTotal(grandTotal);
													sesReport.setPercent(100);
													sesReport.setFont(1);
													sesReport.setTemp("Detail");
													listReport.add(sesReport);										
										%>									  										
                                        <tr> 
                                          <td width="63%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="63%">&nbsp;</td>
                                          <td width="22%">&nbsp;</td>
                                          <td width="15%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="63%" height="20"> 
                                            <div align="right"><b>TOTAL F&amp;A 
                                              : </b></div>
                                          </td>
                                          <td width="22%" height="20"> 
                                            <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalFA, "#,###")%></b></font></div>
                                          </td>
                                          <td width="15%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td width="63%" height="20"> 
                                            <div align="right"><b>TOTAL LOGISTIC 
                                              : </b></div>
                                          </td>
                                          <td width="22%" height="20"> 
                                            <div align="right"><font size="1"><b><%=JSPFormater.formatNumber(totalLog, "#,###")%></b></font></div>
                                          </td>
                                          <td width="15%">&nbsp;</td>
                                        </tr>
                                      </table>
                                  </td>
                                </tr>
										<%
													//add detail
													sesReport = new SesReportIfc();													
													sesReport.setTemp("End");
													listReport.add(sesReport);										

													//add detail
													sesReport = new SesReportIfc();
													sesReport.setDescription("TOTAL F&A");
													sesReport.setTotal(totalFA);
													sesReport.setTemp("Total");
													listReport.add(sesReport);																				
													//add detail
													sesReport = new SesReportIfc();
													sesReport.setDescription("TOTAL LOGISTIC");
													sesReport.setTotal(totalLog);
													sesReport.setTemp("Total");
													listReport.add(sesReport);																				

										%>								
                                  <tr> 
                                    <td width="30%">&nbsp; </td>
                                  </tr>  
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
                        </table>
							<%
								session.putValue("DONOR_IFC_GROUP", listReport);							
							%>								 												
						<%}catch(Exception e){
							out.println(e.toString());
						}%>
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
