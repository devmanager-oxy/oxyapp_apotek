
<%-- 
    Document   : rptselisihsetoran
    Created on : Mar 1, 2015, 9:01:55 AM
    Author     : Roy
--%>


<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "java.sql.ResultSet" %> 
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = true;
            boolean privView = true;
            boolean privPrint = true;
%>
<!-- Jsp Block -->
<%

            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");

            if (session.getValue("REPORT_SETORAN_KASIR") != null) {
                session.removeValue("REPORT_SETORAN_KASIR");
            }

            if (session.getValue("REPORT_SETORAN_KASIR_PARAMETER") != null) {
                session.removeValue("REPORT_SETORAN_KASIR_PARAMETER");
            }

            if (tanggal == null) {
                tanggal = new Date();
            }

            if (tanggalEnd == null) {
                tanggalEnd = new Date();
            }

            Vector vpar = new Vector();
            vpar.add("" + locationId);
            vpar.add("" + JSPFormater.formatDate(tanggal, "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(tanggalEnd, "dd/MM/yyyy"));
            vpar.add("" + user.getFullName());

            Vector report = new Vector();
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
            
            function cmdPrintXls(){	                       
                window.open("<%=printroot%>.report.ReportSetoranXLS?user_id=<%=appSessUser.getUserOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.action="rptselisihsetoran.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Report Setoran Kasir<br>
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
                                                                                                                                            <td width="80" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td width="2" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr size="23"> 
                                                                                                                                            <td class="tablearialcell" nowrap>&nbsp;&nbsp;Date</td>
                                                                                                                                            <td class="fontarial">:</td>
                                                                                                                                            <td colspan="2" > 
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                                                                        </td>
                                                                                                                                                        <td>&nbsp;&nbsp;to&nbsp;&nbsp;</td>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr size="23">
                                                                                                                                            <td class="tablearialcell">&nbsp;&nbsp;Location</td>
                                                                                                                                            <td class="fontarial">:</td>
                                                                                                                                            <td colspan="2">
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>          
                                                                                                                                                <select name="src_location_id" class="fontarial" onChange="javascript:cmdchange()">                                                                                                                                                           
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>           
                                                                                                                                            </td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr> 
                                                                                                                                            <td >&nbsp;</td>
                                                                                                                                            <td colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>                                                                  </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">&nbsp;</td>                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="4">
                                                                                                                                                <table border="0" cellspacing="1" cellpadding="0">                                                                                                                                        
                                                                                                                                                    <tr height="26">                                                                                                 
                                                                                                                                                        <td width="100" class="tablearialhdr">TANGGAL</td>
                                                                                                                                                        <td width="100" class="tablearialhdr">CASH</td>
                                                                                                                                                        <td width="100" class="tablearialhdr">CARD</td>
                                                                                                                                                        <td width="100" class="tablearialhdr">CASH BACK</td>
                                                                                                                                                        <td width="100" class="tablearialhdr">SETORAN TOKO</td>
                                                                                                                                                        <td width="100" class="tablearialhdr">SYSTEM</td>
                                                                                                                                                        <td width="100" class="tablearialhdr">SELISIH</td>                                                                                                                                                        
                                                                                                                                                    </tr>                                                                                                                                                    
                                                                                                                                                    <%
            try {
                int typeReport = SessReportClosing.getTypeReport(locationId);
                CONResultSet crs = null;

                String where = DbSales.colNames[DbSales.COL_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + " 23:59:59' ";
                if (locationId != 0) {
                    where = where + " and " + DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " = " + locationId;
                }

                String sql = "select date from pos_sales where " + where + " group by year(date),month(date),day(date) order by date";

                String style = "";
                int nomor = 1;

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                double totCash = 0;
                double totCard = 0;
                double totDebit = 0;
                double totCashBack = 0;

                while (rs.next()) {
                    Date tgl = rs.getDate("date");
                    if (nomor % 2 == 0) {
                        style = "tablearialcell";
                    } else {
                        style = "tablearialcell1";
                    }

                    Vector tmpReport = new Vector();

                    Vector vshift = SQLGeneral.getShift(locationId, tgl);
                    // sub total
                    double subCash = 0;
                    double subCard = 0;
                    double subDebit = 0;
                    double subCashBack = 0;

                    if (vshift != null && vshift.size() > 0) {

                        for (int j = 0; j < vshift.size(); j++) {

                            Shift shift = (Shift) vshift.get(j);
                            SalesClosingJournal salesClosing = new SalesClosingJournal();
                            if (typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_JOURNAL || typeReport == DbSegmentDetail.TYPE_SALES_SINGLE_PAYMENT_POST_ONE_SHIFT) {
                                salesClosing = SessReportClosing.getDataSummaryClosingSinglePayment(tgl, locationId, shift.getOID());
                            } else if (typeReport == DbSegmentDetail.TYPE_SALES_MULTY_PAYMENT_POST_ONE_JOURNAL ||
                                    typeReport == DbSegmentDetail.TYPE_SALES_MULTY_PAYMENT_POST_ONE_SHIFT ||
                                    typeReport == DbSegmentDetail.TYPE_SALES_MULTY_PAYMENT_POST_ONE_MONTH) {
                                salesClosing = SessReportClosing.getDataSummaryClosingMultyPayment(tgl, locationId, shift.getOID());
                            }

                            subCash = subCash + salesClosing.getCash();
                            subCard = subCard + salesClosing.getCCard();
                            subDebit = subDebit + salesClosing.getDCard();
                            subCashBack = subCashBack + salesClosing.getCashBack();

                            totCash = totCash + salesClosing.getCash();
                            totCard = totCard + salesClosing.getCCard();
                            totDebit = totDebit + salesClosing.getDCard();
                            totCashBack = totCashBack + salesClosing.getCashBack();
                        }
                    }

                    tmpReport.add(JSPFormater.formatDate(tgl, "dd/MM/yyyy"));
                    tmpReport.add("" + subCash);
                    tmpReport.add("" + (subCard + subDebit));
                    tmpReport.add("" + subCashBack);
                    tmpReport.add("" + 0.00);
                    tmpReport.add("" + 0.00);
                    tmpReport.add("" + 0.00);
                    report.add(tmpReport);

                                                                                                                                                    %>
                                                                                                                                                    <tr height="23">                                                                                                                                                        
                                                                                                                                                        <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(tgl, "dd-MMM")%></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(subCash, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber((subCard + subDebit), "###,###.##") %></td>                                                                                                                                                        
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(subCashBack, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##") %></td>
                                                                                                                                                        <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(0.00, "###,###.##") %></td>
                                                                                                                                                    </tr>   
                                                                                                                                                    <%
                                                                                                                                                            nomor++;
                                                                                                                                                        }%>
                                                                                                                                                    <%if (nomor != 1) {%>
                                                                                                                                                    <tr height="23">                                                                                                                                                        
                                                                                                                                                        <td bgcolor="#CCCCCC" class="fontarial" align="center"><b>TOTAL</b></td>
                                                                                                                                                        <td bgcolor="#CCCCCC" class="fontarial" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totCash, "###,###.##") %></b></td>
                                                                                                                                                        <td bgcolor="#CCCCCC" class="fontarial" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber((totCard + totDebit), "###,###.##") %></b></td>                                                                                                                                                        
                                                                                                                                                        <td bgcolor="#CCCCCC" class="fontarial" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(totCashBack, "###,###.##") %></b></td>
                                                                                                                                                        <td bgcolor="#CCCCCC" class="fontarial" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(0.00, "###,###.##") %></b></td>
                                                                                                                                                        <td bgcolor="#CCCCCC" class="fontarial" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(0.00, "###,###.##") %></b></td>
                                                                                                                                                        <td bgcolor="#CCCCCC" class="fontarial" align="right" style="padding:3px;"><b><%=JSPFormater.formatNumber(0.00, "###,###.##") %></b></td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <%
                                                                                                                                                    if (privPrint) {
                                                                                                                                                         session.putValue("REPORT_SETORAN_KASIR",report);
                                                                                                                                                         session.putValue("REPORT_SETORAN_KASIR_PARAMETER",vpar);
                                                                                                                                                    %>
                                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                                        <td height="22" valign="middle" colspan="7"> 
                                                                                                                                                            &nbsp;
                                                                                                                                                        </td>     
                                                                                                                                                    </tr>                                                                                                                                                      
                                                                                                                                                    <tr align="left" valign="top"> 
                                                                                                                                                        <td height="22" valign="middle" colspan="7"> 
                                                                                                                                                            <a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                                        </td>     
                                                                                                                                                    </tr>  
                                                                                                                                                    <%}%>
                                                                                                                                                    <%}%>                                                                                                                                                    
                                                                                                                                                    <%
    }catch(Exception e) {}
                                                                                                                                                    %>
                                                                                                                                                    
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td height="15" colspan="4"></td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr>                                                                                                                
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                                
                                                                                                            </table>
                                                                                                        </form>
                                                                                                    </td>
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


