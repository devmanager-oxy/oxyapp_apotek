 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%

	if(session.getValue("GL_REPORT")!=null){
		session.removeValue("GL_REPORT");
	}

	if(session.getValue("GL_REPORT_PDF")!=null){
		session.removeValue("GL_REPORT_PDF");
	}

Periode p = DbPeriode.getOpenPeriod();

Date startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
Date endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_date"), "dd/MM/yyyy");
/*Date dt = new Date();
if(startDate.getYear()<dt.getYear()){
	startDate.setDate(1);
	startDate.setMonth(0);
	startDate.setYear(dt.getYear());
}
if(startDate.getYear()>dt.getYear()){
	startDate = p.getStartDate();
}
if(endDate.getYear()<dt.getYear()){
	endDate = p.getEndDate();	
}
if(endDate.getYear()>dt.getYear()){
	endDate.setDate(31);
	endDate.setMonth(11);
	endDate.setYear(dt.getYear());	
}
*/


//jsp content
Vector coas = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_STATUS]+"<>'"+I_Project.ACCOUNT_LEVEL_HEADER+"'", DbCoa.colNames[DbCoa.COL_CODE]);

//Prepare Report
Vector listReport = new Vector();
SesReportBs sesReport = new SesReportBs();
SesReportGl sesReportGl = new SesReportGl();
Vector vSesDep = new Vector();
Vector listReportGL = new Vector();
SesReportGl sesReportDetail = new SesReportGl();

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--
function cmdPrintJournalXLS(){	 
	window.open("<%=printroot%>.report.RptGLStandardXLS?oid=<%=appSessUser.getLoginId()%>&period=<%=JSPFormater.formatDate(startDate, "dd/MM/yyyy")%> - <%=JSPFormater.formatDate(endDate, "dd/MM/yyyy")%>");
}

function cmdPrintJournal(){	 
	window.open("<%=printroot%>.report.RptGLStandardPDF?oid=<%=appSessUser.getLoginId()%>&period=<%=JSPFormater.formatDate(startDate, "dd/MM/yyyy")%> - <%=JSPFormater.formatDate(endDate, "dd/MM/yyyy")%>");
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/print2.gif','../images/printxls2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">General Ledger</span></font>";
					  %>
					  <%@ include file="../main/navigator.jsp"%>
					  <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form id="form1" name="form1" method="post" action="">
                          <input type="hidden" name="command">
						  <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td height="16">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> <span class="level1"><font size="+1"><b> 
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="8%"><a href="<%=approot%>/freport/glreport.jsp?menu_idx=<%=menuIdx%>"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new111','','../images/search2.gif',1)"><img src="../images/search.gif" name="new111"  border="0"></a></td>
                                          <td width="84%"><span class="level1"><font size="+1"><b> 
                                            <div align="center">GENERAL LEDGER</div>
                                            </b></font></span> </td>
                                          <td width="8%">&nbsp;</td>
                                        </tr>
                                      </table>
                                      </b></font></span></td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <div align="center"><b><%=JSPFormater.formatDate(startDate, "dd/MM/yyyy")%> - <%=JSPFormater.formatDate(endDate, "dd/MM/yyyy")%></b></div>
                                    </td>
                                  </tr>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <%if(coas!=null && coas.size()>0){
								  	for(int i=0; i<coas.size(); i++){
										Coa coa = (Coa)coas.get(i);
										
										boolean isDebetPosition = false;
            
										if( coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
											coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
											coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
											coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
											coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
											coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)                
										){
											isDebetPosition = true;
										}
										
										int ix = JSPRequestValue.requestInt(request, "box_"+coa.getOID());
										if(ix==1){
								  %>
                                  <tr> 
                                    <td> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                        <tr height="18"> 
                                          <td class="tablehdr2"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="45%" class="tablehdr2">&nbsp;<%=coa.getCode()+" - "+coa.getName()%></td>
                                                <td width="7%">&nbsp;</td>
                                                <td width="48%" class="tablehdr2"> 
                                                  <div align="right"><%=coa.getAccountGroup()%>&nbsp;</div>
                                                </td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
										<%	//Detail Report PDF
											sesReportDetail = new SesReportGl();	
											sesReportDetail.setType("Coa");
											sesReportDetail.setDescription(coa.getCode()+" - "+coa.getName());
											sesReportDetail.setAccGroup(coa.getAccountGroup());
											listReportGL.add(sesReportDetail);
										%>
                                        <%
										Vector temp = DbGlDetail.getGeneralLedger(startDate, endDate, coa.getOID());
										
										%>
                                        <tr> 
                                          <td> 
                                            <table width="98%"  height="20" cellpadding="1" cellspacing="1" align="right">
                                              <tr> 
                                                <td width="12%" class="tablecell" align="center"><b>Transaction 
                                                  Date</b></td>
                                                <td width="12%" class="tablecell" align="center"><b>Journal 
                                                  Number</b></td>
                                                <td width="35%" class="tablecell" align="center"><b>Memo</b></td>
                                                <td width="13%" class="tablecell" align="center"><b>Debet</b></td>
                                                <td width="13%" class="tablecell" align="center"><b>Credit</b></td>
                                                <td width="15%" class="tablecell" align="center"><b>Balance</b></td>
                                              </tr>
											<%	//Detail Report PDF
												sesReportDetail = new SesReportGl();	
												sesReportDetail.setType("Header");
												listReportGL.add(sesReportDetail);
											%>
                                              <%
											  
											  double openingBalance = DbGlDetail.getGeneralLedgerOpeningBalance(startDate, coa);
											  
											  double totalCredit = 0;
											  double totalDebet = 0;
											  %>
                                              <tr> 
                                                <td class="tablecell1" align="center" width="12%">&nbsp;</td>
                                                <td class="tablecell1" align="center" width="12%">-</td>
                                                <td class="tablecell1" align="left" width="35%">Opening 
                                                  Balance</td>
                                                <td class="tablecell1" align="right" width="13%"> 
                                                  <div align="right">-</div>
                                                </td>
                                                <td class="tablecell1" align="right" width="13%"> 
                                                  <div align="right">-</div>
                                                </td>
                                                <td class="tablecell1" align="right" width="15%"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div>
                                                </td>
                                              </tr>
											<%	//Detail Report PDF
												sesReportDetail = new SesReportGl();	
												sesReportDetail.setType("Detail");
												sesReportDetail.setStrTransDate("-");
												sesReportDetail.setJournalNumber("-");											  
												sesReportDetail.setMemo("Opening Balance");
												sesReportDetail.setDebet(0);
												sesReportDetail.setCredit(0);
												sesReportDetail.setBalance(openingBalance);
												listReportGL.add(sesReportDetail);
											%>
											  <%
												  vSesDep = new Vector();
												  sesReportGl = new SesReportGl();
												  sesReportGl.setStrTransDate("-");
												  sesReportGl.setJournalNumber("-");											  
												  sesReportGl.setMemo("Opening Balance");
												  sesReportGl.setDebet(0);
												  sesReportGl.setCredit(0);
												  sesReportGl.setBalance(openingBalance);
												  vSesDep.add(sesReportGl);
											  %>
                                              <%
											  if(temp!=null && temp.size()>0){
											  	for(int x=0; x<temp.size(); x++){
													Vector gld = (Vector)temp.get(x);
													Gl gl = (Gl)gld.get(0);
													GlDetail gd = (GlDetail)gld.get(1);
													
													if(isDebetPosition){
														openingBalance = openingBalance + (gd.getDebet() - gd.getCredit());
													}
													else{
														openingBalance = openingBalance + (gd.getCredit() - gd.getDebet());
													}
													totalDebet = totalDebet + gd.getDebet();
													totalCredit = totalCredit + gd.getCredit();
											  %>
                                              <tr> 
                                                <td class="tablecell1" width="12%"> 
                                                  <div align="center"><%=JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy")%></div>
                                                </td>
                                                <td class="tablecell1" width="12%"> 
                                                  <div align="center"><%=gl.getJournalNumber()%></div>
                                                </td>
                                                <td class="tablecell1" width="35%"> 
                                                  <%=gl.getMemo()%></td>
                                                <td class="tablecell1" width="13%"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(gd.getDebet(), "#,###.##") %></div>
                                                </td>
                                                <td class="tablecell1" width="13%"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(gd.getCredit(), "#,###.##")%></div>
                                                </td>
                                                <td class="tablecell1" width="15%"> 
                                                  <div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div>
                                                </td>
                                              </tr>
											<%	//Detail Report PDF
												sesReportDetail = new SesReportGl();	
												sesReportDetail.setType("Detail");
												sesReportDetail.setStrTransDate(JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy"));										  
												sesReportDetail.setTransDate(gl.getTransDate());
												sesReportDetail.setJournalNumber(gl.getJournalNumber());
												sesReportDetail.setMemo(gl.getMemo());
												sesReportDetail.setDebet(gd.getDebet());
												sesReportDetail.setCredit(gd.getCredit());
												sesReportDetail.setBalance(openingBalance);
												listReportGL.add(sesReportDetail);
											%>
											  <%
												  //vSesDep = new Vector();
												  sesReportGl = new SesReportGl();	
												  sesReportGl.setStrTransDate(JSPFormater.formatDate(gl.getTransDate(), "dd/MM/yyyy"));										  
												  sesReportGl.setTransDate(gl.getTransDate());
												  sesReportGl.setJournalNumber(gl.getJournalNumber());
												  sesReportGl.setMemo(gl.getMemo());
												  sesReportGl.setDebet(gd.getDebet());
												  sesReportGl.setCredit(gd.getCredit());
												  sesReportGl.setBalance(openingBalance);
												  vSesDep.add(sesReportGl);
											  %>

                                              <%}}%>
                                              <tr> 
                                                <td class="tablecell" height="15" width="12%"></td>
                                                <td class="tablecell" width="12%"></td>
                                                <td class="tablecell" width="35%"> 
                                                  <div align="right"><b>Total 
                                                    <%=baseCurrency.getCurrencyCode()%></b></div>
                                                </td>
                                                <td class="tablecell" width="13%"> 
                                                  <div align="right"><b><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b></div>
                                                </td>
                                                <td class="tablecell" width="13%"> 
                                                  <div align="right"><b><%=JSPFormater.formatNumber(totalCredit, "#,###.##") %></b></div>
                                                </td>
                                                <td class="tablecell" width="15%"> 
                                                  <div align="right"><b><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></b></div>
                                                </td>
                                              </tr>									
											<%	//Detail Report PDF
												sesReportDetail = new SesReportGl();	
												sesReportDetail.setType("Total");
												sesReportDetail.setMemo("Total");
												sesReportDetail.setDebet(totalDebet);
												sesReportDetail.setCredit(totalCredit);
												sesReportDetail.setBalance(openingBalance);
												listReportGL.add(sesReportDetail);
											%>		  
											  <%									  	
												  sesReportGl = new SesReportGl();											  
												  sesReportGl.setMemo("Total");
												  sesReportGl.setDebet(totalDebet);
												  sesReportGl.setCredit(totalCredit);
												  sesReportGl.setBalance(openingBalance);
												  vSesDep.add(sesReportGl);
											  %>

                                              <tr> 
                                                <td class="" height="3" colspan="6"></td>
                                              </tr>
                                            </table>
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
								  	<%
										sesReport = new SesReportBs();	
										sesReport.setDescription(coa.getCode()+" - "+coa.getName());
										sesReport.setStrAmount(coa.getAccountGroup());
										sesReport.setDepartment(vSesDep);										
										listReport.add(sesReport);
									%>
                                  <%}}}%>
                                  <tr> 
                                    <td>&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td> 
                                      <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                        <tr> 
                                          <td width="15%"><a href="javascript:cmdPrintJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1111','','../images/print2.gif',1)"><img src="../images/print.gif" name="new1111"  border="0" width="53" height="22"></a></td>
                                          <td width="25%"><a href="javascript:cmdPrintJournalXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1112','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="new1112"  border="0" width="120" height="22"></a></td>
                                          <td width="60%">&nbsp;</td>
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
                            <tr> 
                              <td>&nbsp;</td>
                            </tr>
                          </table>
							<%
								session.putValue("GL_REPORT", listReport);
								session.putValue("GL_REPORT_PDF", listReportGL);							
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
