
<%-- 
    Document   : reportbudgetsuplierop
    Created on : Feb 9, 2015, 3:39:03 PM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_BUDGET_REPORT_GA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_BUDGET_REPORT_GA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_BUDGET_REPORT_GA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_BUDGET_REPORT_GA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_BUDGET_REPORT_GA, AppMenu.PRIV_DELETE);
%>            
<%            
            session.removeValue("DATE_TRANS_DATE");
            int iCommand = JSPRequestValue.requestCommand(request);            
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            int pkp = JSPRequestValue.requestInt(request, "pkp");
            int nonpkp = JSPRequestValue.requestInt(request, "nonpkp");
            long vendorId = JSPRequestValue.requestLong(request, "vendor");            

            Date dateFrom = JSPFormater.formatDate(JSPRequestValue.requestString(request, "date_from"), "dd/MM/yyyy");
            Date dateTo = JSPFormater.formatDate(JSPRequestValue.requestString(request, "date_to"), "dd/MM/yyyy");
            
            Vector dateTrans = new Vector();
            
            SessReportBudgetSuplier dtTrans1 = new SessReportBudgetSuplier();
            SessReportBudgetSuplier dtTrans2 = new SessReportBudgetSuplier();
            dtTrans1.setTransDate(dateFrom);
            dtTrans2.setTransDate(dateTo);
            dateTrans.add(dtTrans1);
            dateTrans.add(dtTrans2);
            
            session.putValue("DATE_TRANS_DATE", dateTrans);
            if(iCommand == JSPCommand.NONE){                
                ignore = 1;
                nonpkp = 1;
                pkp = 1;
            }

            Vector list = new Vector();
            if(iCommand == JSPCommand.LIST){                
                list = SessReportAnggaran.getBudgetSuplier(vendorId,dateFrom,dateTo, ignore,pkp,nonpkp,DbVendor.VENDOR_TYPE_GA);
            }

            
            String[] langNav = {"Report", "Budget Report Suplier"};

            if (lang == LANG_ID) {
                String[] langID = {};

                String[] navID = {"Laporan", "Laporan Budget Suplier"};
                langNav = navID;
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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptBudgetSuplierOpPDF?vendorId=<%=vendorId%>&dateFrom=<%=dateFrom%>&dateTo=<%=dateTo%>&ignore=<%=ignore%>&pkp=<%=pkp%>&nonpkp=<%=nonpkp%>&user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdPrintJournalXLS(){	                       
                window.open("<%=printroot%>.report.RptBudgetSuplierOpXLS?vendorId=<%=vendorId%>&dateFrom=<%=dateFrom%>&dateTo=<%=dateTo%>&ignore=<%=ignore%>&pkp=<%=pkp%>&nonpkp=<%=nonpkp%>&user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdSearch(){                                
                document.form1.command.value="<%=JSPCommand.LIST%>";
                document.form1.action="reportbudgetsuplierop.jsp";
                document.form1.submit();
            }
            
            function MM_swapImgRestore() { //v3.0
                var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
            }
            //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <%@ include file="../calendar/calendarframe.jsp"%>
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
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --> 
                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + " ( Operational )</span></font>";
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
                                                            <input type="hidden" name="valxx">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="2">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="10%">Vendor</td>
                                                                                <td width="90%"> 
                                                                                <%
            Vector result = new Vector(1, 1);
            result = DbVendor.list(0, 0, DbVendor.colNames[DbVendor.COL_TYPE]+" = "+DbVendor.VENDOR_TYPE_GA, DbVendor.colNames[DbVendor.COL_NAME]);

                                                                                %>
                                                                                <select name="vendor">
                                                                                    <%if (result != null && result.size() > 0) {%>
                                                                                    <option value = "0" <%if (vendorId == 0) {%> selected <%}%> >ALL..</option>
                                                                                    <%
    for (int ix = 0; ix < result.size(); ix++){        
        Vendor vendor = (Vendor) result.get(ix);
                                                                                    %>                                                                            
                                                                                    <option value = "<%=vendor.getOID()%>" <%if (vendor.getOID() == vendorId) {%> selected <%}%> ><%=vendor.getName()%></option>
                                                                                    <%}%>                                                                            
                                                                                    <%}%>
                                                                                </select>    
                                                                            </tr>            
                                                                            <tr> 
                                                                                <td >Trans. Date</td>
                                                                                <td >
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td>
                                                                                                <input name="date_from" value="<%=JSPFormater.formatDate((dateFrom == null) ? new Date() : dateFrom, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                            </td>
                                                                                            <td>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.date_from);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                            </td> 
                                                                                            <td>&nbsp;&nbsp;To&nbsp;&nbsp;</td>
                                                                                            <td>
                                                                                                <input name="date_to" value="<%=JSPFormater.formatDate((dateTo == null) ? new Date() : dateTo, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                            </td>
                                                                                            <td>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.form1.date_to);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                            </td> 
                                                                                            <td>
                                                                                                <input type="checkbox" name = "ignore" value = "1" <%if(ignore==1){%>checked<%}%>>
                                                                                            </td> 
                                                                                            <td>
                                                                                                &nbsp;Ignore
                                                                                            </td> 
                                                                                        </tr>    
                                                                                    </table>     
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <tr> 
                                                                                <td >Status Pajak</td>
                                                                                <td align="left">
                                                                                    <table border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr>
                                                                                            <td><input type="checkbox" name = "nonpkp" value = "1" <%if(nonpkp==1){%>checked<%}%>></td> 
                                                                                            <td>Non Pkp</td>
                                                                                            <td>&nbsp;&nbsp;<input type="checkbox" name = "pkp" value = "1" <%if(pkp==1){%>checked<%}%>></td> 
                                                                                            <td>&nbsp;Pkp</td>
                                                                                        </tr>    
                                                                                    </table>     
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <tr>
                                                                                <td colspan="2">&nbsp;</td> 
                                                                            </tr>    
                                                                            <tr>
                                                                                <td colspan="2"> 
                                                                                    <table border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td ><a href="javascript:cmdSearch()"><img src="../images/search2.jpg" width="22" height="22" border="0"></a></td>
                                                                                            <td ><a href="javascript:cmdSearch()">Get Report</a></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="2">&nbsp;</td> 
                                                                            </tr> 
                                                                            <%if(list != null && list.size() > 0){%>
                                                                            <tr> 
                                                                                <td colspan="2">
                                                                                    <table width="800" cellpadding="0" cellspacing="1">                                                                                        
                                                                                        <tr height="25">
                                                                                            <td class="tablehdr" width="5%">NO</td>
                                                                                            <td class="tablehdr">NAMA SUPLIER</td>
                                                                                            <td class="tablehdr" width="15%">TRANS. DATE</td>
                                                                                            <td class="tablehdr" width="10%">DIVISI</td>
                                                                                            <td class="tablehdr" width="15%">NO TT</td>
                                                                                            <td class="tablehdr" width="15%">NILAI</td>
                                                                                            <td class="tablehdr" width="15%">JUMLAH<BR>YANG DIBAYAR</td>
                                                                                        </tr>
                                                                                        <%
                                                                                        String v = "";
                                                                                        double tot = 0;
                                                                                        double totAmount = 0;
                                                                                        int number = 1;
                                                                                        for(int i = 0; i < list.size() ; i++){
                                                                                            SessReportBudgetSuplier srbs = new SessReportBudgetSuplier();     
                                                                                            srbs = (SessReportBudgetSuplier)list.get(i);
                                                                                            
                                                                                            int count = 0;
                                                                                            int counter = 0;
                                                                                            for(int t = 0; t < list.size(); t++){ 
                                                                                                 SessReportBudgetSuplier ck = new SessReportBudgetSuplier();     
                                                                                                 ck = (SessReportBudgetSuplier)list.get(t);
                                                                                                 //if(ck.getVendorId() == srbs.getVendorId()){
                                                                                                 if(ck.getSuplier().compareToIgnoreCase(srbs.getSuplier())==0){
                                                                                                    count ++;
                                                                                                    counter = ck.getCounter();
                                                                                                 }
                                                                                            }
                                                                                            if(v.compareToIgnoreCase(srbs.getSuplier()) != 0){
                                                                                               tot = 0; 
                                                                                            }
                                                                                            
                                                                                            tot = tot + srbs.getValue();
                                                                                        %>
                                                                                        <tr height="20">
                                                                                            <td class="tablecell" align="center">
                                                                                                <%if(v.equalsIgnoreCase("") || v.compareToIgnoreCase(srbs.getSuplier()) != 0){%>
                                                                                                    <%=number%>
                                                                                                <%number = number+1;}%>
                                                                                            </td>
                                                                                            <td class="tablecell" align="left">
                                                                                                <%if(v.equalsIgnoreCase("") || v.compareToIgnoreCase(srbs.getSuplier()) != 0){%>
                                                                                                &nbsp;&nbsp;<%=srbs.getSuplier()%>
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="tablecell" align="center"><%=JSPFormater.formatDate(srbs.getTransDate(),"dd/MM/yyyy") %></td>
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                            <td  class="tablecell" align="center"><%=srbs.getNoTT()%></td>
                                                                                            <td  class="tablecell" align="right">
                                                                                                <%if(count > 1){%>
                                                                                                <%=JSPFormater.formatNumber(srbs.getValue(), "#,###.##")%>&nbsp;&nbsp;
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td  class="tablecell" align="right">                                                                                                
                                                                                                <%if(count == 1){
                                                                                                    totAmount = totAmount + srbs.getValue();    
                                                                                                %>
                                                                                                <B><%=JSPFormater.formatNumber(srbs.getValue(), "#,###.##")%></B>&nbsp;&nbsp;
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%if(count > 1 && counter == srbs.getCounter()){%>
                                                                                        <tr height="20">
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                            <td align="center" class="tablecell"><B>TOTAL</B></td>
                                                                                            <td align="right" class="tablecell">
                                                                                                <%
                                                                                                if(counter == srbs.getCounter()){
                                                                                                    totAmount = totAmount + tot ;
                                                                                                %>
                                                                                                <B><%=JSPFormater.formatNumber(tot, "#,###.##")%></B>&nbsp;&nbsp;
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr >
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                            <td colspan="4" background="../images/line.gif" valign="top"><img src="../images/line.gif"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
                                                                                         v = srbs.getSuplier();
                                                                                        }
                                                                                        %>
                                                                                        <tr >                                                                                            
                                                                                            <td colspan="7" background="../images/line.gif" valign="top"><img src="../images/line.gif"></td>
                                                                                        </tr>
                                                                                        <tr height="25">
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell" align="center"><B>GRAND TOTAL</B></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <td colspan="4" valign="top" class="tablecell" align="right"><B><%=JSPFormater.formatNumber(totAmount, "#,###.##")%></B>&nbsp;&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td> 
                                                                            </tr>   
                                                                            <tr> 
                                                                                <td>                                                                            
                                                                                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a>
                                                                                </td>    
                                                                                <td>                                                                            
                                                                                    &nbsp;&nbsp;<a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printx','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printx" border="0"></a>
                                                                                </td>    
                                                                            </tr>    
                                                                            <%
                                                                               
                                                                            }
                                                                            %>
                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                                                                                           
                                                            </table>
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
