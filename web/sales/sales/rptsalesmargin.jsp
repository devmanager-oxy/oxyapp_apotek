
<%-- 
    Document   : rptsalesmargin
    Created on : Jul 28, 2013, 8:45:06 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_MARGIN);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_MARGIN, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_MARGIN, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%
            if (session.getValue("REPORT_MARGIN") != null) {
                session.removeValue("REPORT_MARGIN");
            }

            if (session.getValue("REPORT_MARGIN_PARAMETER") != null) {
                session.removeValue("REPORT_MARGIN_PARAMETER");
            }

            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            Vector result = new Vector();

            if (iJSPCommand == JSPCommand.SEARCH) {
                ReportParameter rp = new ReportParameter();
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                session.putValue("REPORT_MARGIN_PARAMETER", rp);
            }
            
            Vector vLoc = userLocations;
            String where = "";
            if (vLoc.size() != totLocationxAll) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                    if(where != null && where.length() > 0){where = where+",";}
                    where=where+us.getOID();
                }    
                if(where != null && where.length() > 0){
                    where =" and ps."+DbSales.colNames[DbSales.COL_LOCATION_ID]+" in ("+where+")";
                }
            }
            
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXLS(){	                       
                window.open("<%=printroot%>.report.RptSalesMarginXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmsales.action="rptsalesmargin.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                <span class="lvl2">Report Sales Margin<br></span></font></b></td>
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
                                                                                                                                    <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr>                                                                                                                                            
                                                                                                                                            <td class="tablecell1" >                                                                                                                                                
                                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" style="border:1px solid #ABA8A8">
                                                                                                                                                    <tr>
                                                                                                                                                        <td height="5" colspan="3"></td>
                                                                                                                                                    </tr>    
                                                                                                                                                    <tr> 
                                                                                                                                                        <td width="5">&nbsp;</td>
                                                                                                                                                        <td width="100" height="14" colspan="2"><i><b>Searching Parameter : </b></i></td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="5">&nbsp;</td>
                                                                                                                                                        <td height="14">Date Between</td>
                                                                                                                                                        <td >
                                                                                                                                                            <table cellpadding="0" cellspacing="0">
                                                                                                                                                                <tr>
                                                                                                                                                                    <td > 
                                                                                                                                                                        <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>    
                                                                                                                                                                        &nbsp;&nbsp;and&nbsp;&nbsp;
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                                    </td>
                                                                                                                                                                    <td>
                                                                                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                                    </td>                                                                                                                                                        
                                                                                                                                                                </tr>
                                                                                                                                                            </table>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>   
                                                                                                                                                    <tr> 
                                                                                                                                                        <td colspan="3">&nbsp;</td>
                                                                                                                                                    </tr>                                                                                                                                                  
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                        <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top">                                                                                                                             
                                                                                                                                <td height="22" valign="middle" colspan="4"></td> 
                                                                                                                            </tr>    
                                                                                                                            <%
            if (iJSPCommand == JSPCommand.SEARCH) {

                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="700" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablehdr" width="6%"><font face="arial">NO</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr"><font face="arial">LOCATION</td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="15%" ><font face="arial">OMSET</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="15%"><font face="arial">HPP</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablehdr" width="15%"><font face="arial">MARGIN <BR>(RP)</td>
                                                                                                                                            <td class="tablehdr" width="15%"><font face="arial">MARGIN <BR>(%)</td>
                                                                                                                                        </tr>   
                                                                                                                                        <%
                                                                                                                                CONResultSet crs = null;
                                                                                                                                try {

                                                                                                                                    String sql = "select locationid, name,sum(omset) as xomset,sum(hpp) as xhpp from ( " +
                                                                                                                                            " select l.location_id as locationid, l.name as name, sum((psd.qty * psd.selling_price)- psd.discount_amount) as omset ,sum( psd.qty * psd.cogs) as hpp  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_location l on ps.location_id = l.location_id " +
                                                                                                                                            " where ps.type in (0,1) "+where+" and to_days(ps.date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "')  and to_days(ps.date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') group by l.location_id union " +
                                                                                                                                            " select l.location_id as locationid, l.name as name, sum((psd.qty * psd.selling_price)- psd.discount_amount)*-1 as omset ,sum( psd.qty * psd.cogs)*-1 as hpp  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_location l on ps.location_id = l.location_id " +
                                                                                                                                            " where ps.type in (2,3) "+where+" and to_days(ps.date) >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "')  and to_days(ps.date) <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') group by l.location_id) as x group by locationid order by name ";

                                                                                                                                    crs = CONHandler.execQueryResult(sql);
                                                                                                                                    ResultSet rs = crs.getResultSet();
                                                                                                                                    int no = 1;
                                                                                                                                    while (rs.next()) {

                                                                                                                                        String name = "";
                                                                                                                                        double omset = 0;
                                                                                                                                        double hpp = 0;

                                                                                                                                        try {
                                                                                                                                            name = rs.getString("name");
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                        try {
                                                                                                                                            omset = rs.getDouble("xomset");
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                        try {
                                                                                                                                            hpp = rs.getDouble("xhpp");
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }

                                                                                                                                        double marginRp = omset - hpp;
                                                                                                                                        double marginPersen = (marginRp / omset) * 100;

                                                                                                                                        RptMargin rptMargin = new RptMargin();
                                                                                                                                        rptMargin.setName(name);
                                                                                                                                        rptMargin.setOmset(omset);
                                                                                                                                        rptMargin.setHpp(hpp);
                                                                                                                                        rptMargin.setMarginRp(marginRp);
                                                                                                                                        rptMargin.setMarginPersen(marginPersen);
                                                                                                                                        result.add(rptMargin);
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell" align="center"><font face="arial"><%=no%></font></td>                                                                                                                                            
                                                                                                                                            <td class="tablecell"><font face="arial"><%=name.toUpperCase()%></td>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><font face="arial"><%=JSPFormater.formatNumber(omset, "###,###.##")%></font></td>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><font face="arial"><%=JSPFormater.formatNumber(hpp, "###,###.##")%></font></td>                                                                                                                                            
                                                                                                                                            <td class="tablecell" align="right"><font face="arial"><%=JSPFormater.formatNumber(marginRp, "###,###.##")%></td>
                                                                                                                                            <td class="tablecell" align="right"><font face="arial"><%=JSPFormater.formatNumber(marginPersen, "###,###.##")%></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                        no++;
                                                                                                                                    }

                                                                                                                                } catch (Exception e) {

                                                                                                                                }

                                                                                                                                        %>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td>     
                                                                                                                            </tr> 
                                                                                                                            <%if (privPrint) {%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr>     
                                                                                                                            <%}%>
                                                                                                                            <%
                                                                                                                                session.putValue("REPORT_MARGIN", result);
                                                                                                                            } else {%>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"><i>Klik search button to searching the data..</i></td>     
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

