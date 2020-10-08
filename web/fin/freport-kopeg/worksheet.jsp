 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
//boolean freportPriv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_FINANCEREPROT, AppMenu.M2_MENU_FINANCEREPROT);
%>
<%
//jsp content
Periode openPeriod = DbPeriode.getOpenPeriod();
Vector result = new Vector();
if(openPeriod.getOID()!=0){
	result = DbGl.list(0,0, DbGl.colNames[DbGl.COL_PERIOD_ID]+"="+openPeriod.getOID(), DbGl.colNames[DbGl.COL_DATE]+","+DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]);
}

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=systemTitle%></title>
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--



<%if(!freportPriv){%>
	window.location="<%=approot%>/nopriv.jsp";
<%}%>
<!--

//-->//-->
</script>
<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
					  String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Journal Detail</span></font>";
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
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="container">&nbsp;</td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <div align="center"><span class="level1"><font size="+1"><b>Jurnal 
                                  Detail </b></font></span></div>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <div align="center"><span class="level1"><b>PERIOD 
                                  <%=openPeriod.getName()%></b></span></div>
                              </td>
                            </tr>
                            <tr>
                              <td class="container">
                                <div align="center"><span class="level1"><%=JSPFormater.formatDate(openPeriod.getStartDate(), "dd MMMM yyyy")+ " - "+JSPFormater.formatDate(openPeriod.getEndDate(), "dd MMMM yyyy")%></span></div>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <div align="center">&nbsp;</div>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                  <%
								  double grandTotalDebet = 0;
								  double grandTotalCredit = 0;
								  
								  if(result!=null && result.size()>0){
								  		for(int i=0; i<result.size(); i++){
											Gl gl = (Gl)result.get(i);
								  %>
                                  <tr> 
                                    <td width="13%" class="tablehdr" height="17" nowrap>Date 
                                      : <%=JSPFormater.formatDate(gl.getDate(), "dd MMMM yyyy")%></td>
                                    <td width="17%" class="tablehdr" height="17" nowrap>Trans. 
                                      Date : <%=JSPFormater.formatDate(gl.getTransDate(), "dd MMMM yyyy")%></td>
                                    <td width="23%" class="tablehdr" height="17" nowrap>Journal 
                                      Number : <%=gl.getJournalNumber()%></td>
                                    <td width="2%" height="17">&nbsp;</td>
                                    <td width="45%" height="17"><u><i><%=gl.getMemo()%></i></u></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="5" height="1"></td>
                                  </tr>
                                  <tr> 
                                    <td colspan="5"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0" align="right">
                                        <tr> 
                                          <td class="tablecell" height="18" width="33%"> 
                                            <div align="center"><b>Account Description</b></div>
                                          </td>
                                          <td class="tablecell" height="18" width="14%"> 
                                            <div align="center"><b>Debet</b></div>
                                          </td>
                                          <td class="tablecell" height="18" width="15%"> 
                                            <div align="center"><b>Credit</b></div>
                                          </td>
                                          <td class="tablecell" height="18" width="38%"> 
                                            <div align="center"><b>Description</b></div>
                                          </td>
                                        </tr>
                                        <!--tr> 
                                          <td colspan="4" height="1"></td>
                                        </tr-->
                                        <%
										Vector details = DbGlDetail.list(0,0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID]+"="+gl.getOID(), "debet desc");
										double subTotDebet = 0;
										double subTotCredit = 0;
										if(details!=null && details.size()>0){
											for(int x=0; x<details.size(); x++){
												GlDetail gld = (GlDetail)details.get(x);
												Coa coa = new Coa();
												try{
													coa = DbCoa.fetchExc(gld.getCoaId());
												}
												catch(Exception e){
												}
												
												subTotDebet = subTotDebet + gld.getDebet();
												subTotCredit = subTotCredit + gld.getCredit();
										%>
                                        <tr> 
                                          <td class="tablecell1" width="33%"><%=coa.getCode()+" - "+coa.getName()%></td>
                                          <td class="tablecell1" width="14%"> 
                                            <div align="right"><%=(gld.getDebet()==0) ? "" : JSPFormater.formatNumber(gld.getDebet(), "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tablecell1" width="15%"> 
                                            <div align="right"><%=(gld.getCredit()==0) ? "" : JSPFormater.formatNumber(gld.getCredit(), "#,###.##")%>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tablecell1" width="38%"><%=gld.getMemo()%></td>
                                        </tr>
                                        <!--tr> 
                                          <td colspan="4" height="1"></td>
                                        </tr-->
                                        <%}}
										
										grandTotalDebet = grandTotalDebet + subTotDebet;
										grandTotalCredit = grandTotalCredit + subTotCredit;
										
										%>
                                        <tr> 
                                          <td class="tablecell" width="33%" height="18"> 
                                            <div align="center"><b>Sub Total </b></div>
                                          </td>
                                          <td class="tablecell" width="14%" height="18"> 
                                            <div align="right"><b><u><%=(subTotDebet==0) ? "" : JSPFormater.formatNumber(subTotDebet, "#,###.##")%></u>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <td class="tablecell" width="15%" height="18"> 
                                            <div align="right"><b><u><%=(subTotCredit==0) ? "" : JSPFormater.formatNumber(subTotCredit, "#,###.##")%></u>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <td class="tablecell" width="38%" height="18">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="33%">&nbsp;</td>
                                          <td class="tablecell1" width="14%">&nbsp;</td>
                                          <td class="tablecell1" width="15%">&nbsp;</td>
                                          <td class="tablecell1" width="38%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <%}}%>
                                  <tr> 
                                    <td colspan="5"> 
                                      <table width="100%" border="0" cellspacing="1" cellpadding="0" align="right">
                                        <tr> 
                                          <td class="tablecell" width="33%" height="18"> 
                                            <div align="center"><b><span class="level2">Grand 
                                              Total</span> </b></div>
                                          </td>
                                          <td class="tablecell" width="14%" height="18"> 
                                            <div align="right"><b><u><%=(grandTotalDebet==0) ? "" : JSPFormater.formatNumber(grandTotalDebet, "#,###.##")%></u>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <td class="tablecell" width="15%" height="18"> 
                                            <div align="right"><b><u><%=(grandTotalCredit==0) ? "" : JSPFormater.formatNumber(grandTotalCredit, "#,###.##")%></u>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <td class="tablecell" width="38%" height="18">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="33%"> 
                                            <div align="center"><b><span class="level2">Balance</span></b></div>
                                          </td>
                                          <td class="tablecell1" width="14%">&nbsp;</td>
                                          <td class="tablecell1" width="15%"> 
                                            <div align="right"><b><%=(grandTotalDebet==grandTotalCredit) ? "-" : "<font color=\"red\">"+JSPFormater.formatNumber(grandTotalDebet-grandTotalCredit, "#,###.##")+"</font>"%>&nbsp;&nbsp;</b></div>
                                          </td>
                                          <td class="tablecell1" width="38%">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                          <td class="tablecell1" width="33%">&nbsp;</td>
                                          <td class="tablecell1" width="14%">&nbsp;</td>
                                          <td class="tablecell1" width="15%">&nbsp;</td>
                                          <td class="tablecell1" width="38%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr > 
                                    <td colspan="5" background="../images/line.gif"><img src="../images/line.gif" width="39" height="7"></td>
                                  </tr>
                                </table>
                              </td>
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
