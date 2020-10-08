
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
boolean privAdd = true;
boolean privUpdate = true;
boolean privDelete = true;
boolean masterPriv = true;
boolean masterPrivView = true;
boolean masterPrivUpdate = true; 
%>
<!-- Jsp Block -->
<%
            
if(session.getValue("REPORT_COGS")!=null){ 
	session.removeValue("REPORT_COGS");
}            
String strdate1 = JSPRequestValue.requestString(request, "start_date");
String strdate2 = JSPRequestValue.requestString(request, "end_date");                           
Date startDate = (strdate1 == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
Date endDate = (strdate2 == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
int chkInvDate = 0;            
long locationId = JSPRequestValue.requestLong(request, "src_location_id"); 
int sortBy = JSPRequestValue.requestInt(request, "src_sort_by");
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

Vector result = new Vector();

if(iJSPCommand == JSPCommand.SEARCH){ 
	result = SessCogsBySection.getCogsBySectionReport(startDate, endDate, locationId, sortBy);        
	session.putValue("REPORT_COGS", result);
	session.putValue("REPORT_COGS_USER", user.getLoginId());
        Location loc = new Location();
        if(locationId!=0){
            try{
                loc = DbLocation.fetchExc(locationId);
            }
            catch(Exception e){
            }
        }
        session.putValue("REPORT_COGS_FILTER",  "Filtered by Store : "+((locationId==0) ? "All Store" : loc.getName())+", Date from : "+JSPFormater.formatDate(startDate, "dd-MM-yyyy")+", to "+JSPFormater.formatDate(endDate, "dd-MM-yyyy"));
}
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Sales System</title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!masterPriv || !masterPrivView) {%>
                window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptCogsBySectionXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                document.frmsales.action="rptcogssection.jsp?menu_idx=<%=menuIdx%>";
                document.frmsales.submit();
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
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr> 
                                                                <td valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                                                        <tr> 
                                                                            <td valign="top"> 
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                                    <!--DWLayoutTable-->
                                                                                    <tr> 
                                                                                        <td width="100%" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> 
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                            
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                                                                                                                                                                                        
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                
                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                              Report </font><font class="tit1">&raquo; 
                                                              <span class="lvl2">CoGS 
                                                              by Section<br>
                                                              </span></font></b></td>
                                                                                                                                <td width="40%" height="23"> 
                                                                                                                                    <%@ include file = "../main/userpreview.jsp" %>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr > 
                                                                                                                                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                <tr> 
                                                                  <td width="8%" height="14" nowrap>&nbsp;</td>
                                                                  <td colspan="2" height="14">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="10%" height="22">Date 
                                                                    Between</td>
                                                                  <td colspan="3" height="22"> 
                                                                    <table cellpadding="0" cellspacing="0">
                                                                      <tr> 
                                                                        <td > 
                                                                          <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                        </td>
                                                                        <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                        </td>
                                                                        <td> &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                                        </td>
                                                                        <td> 
                                                                          <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                        </td>
                                                                        <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                        </td>
                                                                      </tr>
                                                                    </table>
                                                                  </td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="8%" height="22">Location</td>
                                                                  <td width="38%" height="22"> 
                                                                    <%
            Vector vLoc = DbLocation.list(0, 0, "", "name");
                                                                                                                                                %>
                                                                    <select name="src_location_id">
                                                                      <option>-</option>
                                                                      <%if (vLoc != null && vLoc.size() > 0){
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                      <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                      <%}
            }%>
                                                                    </select>
                                                                  </td>
                                                                  <td width="54%" height="22">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                  <td width="8%" height="22">Order 
                                                                    By </td>
                                                                  <td width="38%" height="22"> 
                                                                    <select name="src_sort_by">
                                                                      <option value="0" <%if(sortBy==0){%>selected<%}%>>Code</option>
                                                                      <option value="1" <%if(sortBy==1){%>selected<%}%>>Name</option>
                                                                    </select>
                                                                  </td>
                                                                  <td width="54%" height="22">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="8%" height="33">&nbsp;</td>
                                                                  <td width="38%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                  <td width="54%" height="33">&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                  <td width="8%" height="15">&nbsp;</td>
                                                                  <td width="38%" height="15">&nbsp; 
                                                                  </td>
                                                                  <td width="54%" height="15">&nbsp;</td>
                                                                </tr>
                                                              </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                            <%
															if (result != null && result.size() >0 ){
															%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    
                                                              <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                <tr height="20"> 
                                                                  <td class="tablehdr" width="7%">Code</td>
                                                                  <td class="tablehdr" width="34%" >Group/Section 
                                                                    Name</td>
                                                                  <td class="tablehdr" width="11%">Qty</td>
                                                                  <td class="tablehdr" width="11%">Sales</td>
                                                                  <td class="tablehdr" width="11%">Net 
                                                                    Sales </td>
                                                                  <td class="tablehdr" width="10%">CoGS</td>
                                                                  <td class="tablehdr" width="11%">Margin</td>
                                                                  <td class="tablehdr" width="5%">%</td>
                                                                </tr>
                                                                <%
																
																double totQty = 0;
																double totSales = 0;
																double totNetSales = 0;
																double totCoGS = 0;
																double totMargin = 0;
																
																
																for(int i=0; i<result.size(); i++){
																
																	Vector temp = (Vector)result.get(i); 
																	String qtyStr = (String)temp.get(2); 
																	double qty = (qtyStr==null) ? 0 : Double.parseDouble(qtyStr);
																	String salesStr = (String)temp.get(3); 
																	double sales = (salesStr==null) ? 0 : Double.parseDouble(salesStr);
																	String disconStr = (String)temp.get(4); 
																	double discon = (disconStr==null) ? 0 : Double.parseDouble(disconStr);
																	String cogsStr = (String)temp.get(5); 
																	double cogs = (cogsStr==null) ? 0 : Double.parseDouble(cogsStr);
																	
																	totQty = totQty + qty;
																	totSales = totSales + sales;
																	totNetSales = totNetSales + sales - discon;
																	totCoGS = totCoGS + cogs;
																	totMargin = totMargin + sales - discon - cogs;
                                                                                                                                        
                                                                %>
                                                                <tr height="20">  
                                                                  <td class="tablecell" align="center" width="7%"><%=(String)temp.get(0)%></td>
                                                                  <td class="tablecell" align="left" width="34%"><%=(String)temp.get(1)%></td>
                                                                  <td class="tablecell" align="right" width="11%"><%=JSPFormater.formatNumber(qty, "#,###.##")%></td>
                                                                  <td class="tablecell" align="right" width="11%"><%=JSPFormater.formatNumber(sales, "#,###.##")%></td>
                                                                  <td class="tablecell" align="right" width="11%"><%=JSPFormater.formatNumber(sales-discon, "#,###.##")%></td>
                                                                  <td class="tablecell" align="right" width="10%"><%=JSPFormater.formatNumber(cogs, "#,###.##")%></td>
                                                                  <td class="tablecell" align="right" width="11%"><%=JSPFormater.formatNumber((sales-discon)-cogs, "#,###.##")%></td>
                                                                  <td class="tablecell" align="right" width="5%"><%=JSPFormater.formatNumber((((sales-discon)-cogs)/(sales-discon))*100, "#,###.##")%></td>
                                                                </tr>
                                                                <%}%>
                                                                <tr height="20"> 
                                                                  <td class="tablecell" align="right">&nbsp;</td>
                                                                  <td class="tablecell" align="right"><b>TOTAL</b>&nbsp;&nbsp;</td>
                                                                  <td class="tablecell" align="right"><b><%=JSPFormater.formatNumber(totQty, "#,###.##")%></b></td>
                                                                  <td class="tablecell" align="right" width="11%"><b><%=JSPFormater.formatNumber(totSales, "#,###.##")%></b></td>
                                                                  <td class="tablecell" align="right" width="11%"><b><%=JSPFormater.formatNumber(totNetSales, "#,###.##")%></b></td>
                                                                  <td class="tablecell" align="right" width="10%"><b><%=JSPFormater.formatNumber(totCoGS, "#,###.##")%></b></td>
                                                                  <td class="tablecell" align="right" width="11%"><b><%=JSPFormater.formatNumber(totMargin, "#,###.##")%></b></td>
                                                                  <td class="tablecell" align="right" width="5%"><b><%=JSPFormater.formatNumber((totMargin/totNetSales)*100, "#,###.##")%></b></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="8" height="25"></td>
                                                                </tr>
                                                                <tr> 
                                                                  <td colspan="8">&nbsp; 
                                                                  </td>
                                                                </tr>
                                                              </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp; 
                                                                                                                                    
                                                                                                                                </td>     
                                                                                                                            </tr> 
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr>     
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </form>
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
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
            <%@ include file="../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

