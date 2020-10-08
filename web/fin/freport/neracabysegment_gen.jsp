
<%-- 
    Document   : neracabysegment_gen
    Created on : Jul 17, 2013, 1:41:15 PM
    Author     : Roy Andika
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.reportform.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_DELETE);
%>
<%!
    public String getFormated(double amount, boolean isBold) {
        if (isBold) {
            return "";
        } else {
            if (amount >= 0) {
                return JSPFormater.formatNumber(amount, "#,###.##");
            } else {
                return "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
            }
        }
    }
%>
<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");

            if (iJSPCommand == JSPCommand.NONE) {
                previewType = 1;
            }

            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            Company company = DbCompany.getCompany();

            Periode period = new Periode();
            if (periodId != 0) {
                try {
                    period = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }
            } else {
                period = DbPeriode.getOpenPeriod();
            }

            boolean reportExist = false;
            if (iJSPCommand == JSPCommand.VIEW) {
                reportExist = DbRptFms.getReport(DbRptFms.REPORT_TYPE_NERACA, periodId, previewType, user.getOID());
            }

            Date reportDate = new Date();
            Date endPeriod = period.getEndDate();
            if (reportDate.after(endPeriod)) {
                reportDate = endPeriod;
            }

//jika periode adalah peride 13 lawannya period 13 tahun lalu
            if (period.getType() == DbPeriode.TYPE_PERIOD13) {
                reportDate = period.getStartDate();
            }

            Date dtx = (Date) reportDate.clone();
            dtx.setYear(dtx.getYear() - 1);

//last year
            Date dt = period.getStartDate();
            Date startDate = (Date) dt.clone();
            startDate.setYear(startDate.getYear() - 1);
            startDate.setDate(startDate.getDate() + 10);

            Periode lastPeriod = DbPeriode.getPeriodByTransDate(startDate);

//if periode 13 then get prev period 13
            if (period.getType() == DbPeriode.TYPE_PERIOD13) {
                lastPeriod = DbPeriode.getLastYearPeriod13(period);
            }

            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

            /*** LANG ***/
            String[] langFR = {"Show List", "Account With Transaction", "All", "BALANCE SHEET", "PERIOD", //0-4
                "Description", "Total", "And"}; //5-7
            String[] langNav = {"Financial Report", "Detail", "Balance Sheet", "Period", "Preview", "Location"};
            String title = "";

            try {
                title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA_EN");
            } catch (Exception e) {
            }

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "NERACA", "PERIODE", //0-4
                    "Keterangan", "Total", "Dan"}; //5-7
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Penjelasan", "Neraca", "Periode", "Preview", "Lokasi"};
                langNav = navID;

                try {
                    title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA");
                } catch (Exception e) {
                }
            }


            Vector listRptMain = new Vector();
            RptFms rptFms = new RptFms();
            try {
                if (iJSPCommand == JSPCommand.LIST) {
                    listRptMain = DbRptFms.list(0, 1, DbRptFms.colNames[DbRptFms.COL_TYPE_REPORT] + " = " + DbRptFms.REPORT_TYPE_NERACA + " and " + DbRptFms.colNames[DbRptFms.COL_PERIOD_SEARCH_ID] + " = " + periodId, DbRptFms.colNames[DbRptFms.COL_REPORT_DATE] + " desc ");
                    if (listRptMain != null && listRptMain.size() > 0) {
                        rptFms = (RptFms) listRptMain.get(0);
                        rptFms = DbRptFms.fetchExc(rptFms.getOID());
                    }
                }
            } catch (Exception e) {
            }


            Vector rptAKTPrevious = new Vector();
            Vector rptPSVPrevious = new Vector();

            Vector rptAKTNow = new Vector();
            Vector rptPSVNow = new Vector();

            rptAKTPrevious = DbRptFmsDetail.list(0, 0, DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_ID] + " = " + rptFms.getOID() + " and " + DbRptFmsDetail.colNames[DbRptFmsDetail.COL_CURRENT_PERIOD] + " = " + DbRptFmsDetail.PERIOD_PREVIOUS + " and " + DbRptFmsDetail.colNames[DbRptFmsDetail.COL_TYPE] + " = " + DbRptFmsDetail.TYPE_AKTIVA, DbRptFmsDetail.colNames[DbRptFmsDetail.COL_SQUENCE]);
            rptPSVPrevious = DbRptFmsDetail.list(0, 0, DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_ID] + " = " + rptFms.getOID() + " and " + DbRptFmsDetail.colNames[DbRptFmsDetail.COL_CURRENT_PERIOD] + " = " + DbRptFmsDetail.PERIOD_PREVIOUS + " and " + DbRptFmsDetail.colNames[DbRptFmsDetail.COL_TYPE] + " = " + DbRptFmsDetail.TYPE_PASIVA, DbRptFmsDetail.colNames[DbRptFmsDetail.COL_SQUENCE]);

            rptAKTNow = DbRptFmsDetail.list(0, 0, DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_ID] + " = " + rptFms.getOID() + " and " + DbRptFmsDetail.colNames[DbRptFmsDetail.COL_CURRENT_PERIOD] + " = " + DbRptFmsDetail.PERIOD_CURRENT + " and " + DbRptFmsDetail.colNames[DbRptFmsDetail.COL_TYPE] + " = " + DbRptFmsDetail.TYPE_AKTIVA, DbRptFmsDetail.colNames[DbRptFmsDetail.COL_SQUENCE]);
            rptPSVNow = DbRptFmsDetail.list(0, 0, DbRptFmsDetail.colNames[DbRptFmsDetail.COL_RPT_FMS_ID] + " = " + rptFms.getOID() + " and " + DbRptFmsDetail.colNames[DbRptFmsDetail.COL_CURRENT_PERIOD] + " = " + DbRptFmsDetail.PERIOD_CURRENT + " and " + DbRptFmsDetail.colNames[DbRptFmsDetail.COL_TYPE] + " = " + DbRptFmsDetail.TYPE_AKTIVA, DbRptFmsDetail.colNames[DbRptFmsDetail.COL_SQUENCE]);

            int totAKT = rptAKTPrevious.size();

            if (totAKT < rptAKTNow.size()) {
                totAKT = rptAKTNow.size();
            }

%>
<html>
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>         
        <script type="text/javascript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%> 
            
            function cmdReload(){                
                document.form1.command.value="<%=JSPCommand.VIEW%>";
                document.form1.action="neracabysegment.jsp?menu_idx=<%=menuIdx%>";
                document.form1.submit();
            }
            
            function cmdGEN(){                
                document.form1.command.value="<%=JSPCommand.LIST%>";
                document.form1.action="neracabysegment.jsp?menu_idx=<%=menuIdx%>";
                document.form1.submit();
            }
            
            function cmdVIEW(){                
                document.form1.command.value="<%=JSPCommand.LIST%>";
                document.form1.action="neracabysegment.jsp?menu_idx=<%=menuIdx%>";
                document.form1.submit();
            }
            
            function cmdGO(){                
                document.form1.command.value="<%=JSPCommand.LIST%>";
                document.form1.action="neracabysegment.jsp?menu_idx=<%=menuIdx%>";
                document.form1.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;</font><span class=\"lvl2\">" + langNav[2] + "</span>";
                                           %>
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form id="frmneraca" name="form1" method="post" action="">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="rpt_format_id" value="<%=oidRptFormat%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="4" align="left" height="10"></td>
                                                                            </tr>    
                                                                            <tr> 
                                                                                <td colspan="4" align="left">
                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="300">                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" > 
                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="0" cellpadding="2">
                                                                                                    <tr height="15">
                                                                                                        <td width="10" height="7"></td>
                                                                                                        <td colspan="2" height="7"></td>
                                                                                                        <td width="10" height="7"></td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langNav[3]%></td>
                                                                                                        <td>:&nbsp;
                                                                                                            <select name="period_id" onchange="javascript:cmdReload()">
                                                                                                                <%
            if (periods != null && periods.size() > 0) {
                for (int i = 0; i < periods.size(); i++) {
                    Periode per = (Periode) periods.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=per.getOID()%>" <%if (per.getOID() == periodId) {%>selected<%}%>><%=per.getName()%></option>
                                                                                                                <% }
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>  
                                                                                                    <tr>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langNav[4]%></td>
                                                                                                        <td >:&nbsp;
                                                                                                            <select name="preview_type" onchange="javascript:cmdReload()">
                                                                                                                <option value="0" <%if (previewType == 0) {%>selected<%}%>>All Account</option>
                                                                                                                <option value="1" <%if (previewType == 1) {%>selected<%}%>>Account &gt; 0 Only</option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td colspan ="2"></td>
                                                                                                        <td colspan ="2">
                                                                                                            &nbsp;&nbsp;
                                                                                                            <input type="button" name="Button" value="GENERATE" onClick="javascript:cmdGEN()">&nbsp;
                                                                                                            <%if (reportExist) {%>
                                                                                                            <input type="button" name="Button" value="VIEW" onClick="javascript:cmdVIEW()">
                                                                                                            <%}%>    
                                                                                                            &nbsp;&nbsp;&nbsp;<input type="button" name="Button" value="GO" onClick="javascript:cmdGO()">
                                                                                                        </td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td width="10" height="7"></td>
                                                                                                        <td colspan="2" height="7"></td>
                                                                                                        <td width="10" height="7"></td>
                                                                                                    </tr>  
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand == JSPCommand.LIST) {%>
                                                                            <tr> 
                                                                                <td height="23" colspan="4"> 
                                                                                    <div align="center"><b><font face="arial" size="2"><%=company.getName().toUpperCase()%></font></b></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="23" colspan="4"> 
                                                                                    <div align="center"><b><font face="arial" size="2"><%=title%></font></b></div>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="23" colspan="4"> 
                                                                                    <div align="center"><b><font face="arial" size="2">GENERATE DATE : <%=JSPFormater.formatDate(rptFms.getReportDate(), "dd MMM yyyy HH:mm:ss")%></font></b></div>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            
                                                                            <tr> 
                                                                                <td height="23" colspan="4"> <font face="arial" size="2"> 
                                                                                    <div align="center"><b></b></div></font>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="2%"  class="tablehdr">NO</td>
                                                                                            <td width="33%" class="tablehdr">URAIAN</td>
                                                                                            <td width="15%" class="tablehdr">REALISASI<br>PER<br><%=JSPFormater.formatDate(dtx, "dd MMMM yyyy")%></td>
                                                                                            <td width="17%" class="tablehdr">REALISASI<br>PER<br><%=JSPFormater.formatDate(reportDate, "dd MMMM yyyy")%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="3"><div align="center"><b>1</b></div></td>
                                                                                            <td height="3"><div align="center"><b>2</b></div></td>
                                                                                            <td height="3"><div align="center"><b>3</b></div></td>
                                                                                            <td height="3"><div align="center"><b>4</b></div></td>
                                                                                        </tr>                                                                                        
                                                                                        <tr> 
                                                                                            <td height="22"></td>
                                                                                            <td height="22"><b><font color="#CC3300" size="2">AKTIVA</font></b></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        int seq = 0;
    if (totAKT != 0) {
        for (int i = 0; i < totAKT; i++) {
            RptFmsDetail rptPrev = new RptFmsDetail();
            RptFmsDetail rptNow = new RptFmsDetail();
            try {
                rptPrev = (RptFmsDetail) rptAKTPrevious.get(i);
            } catch (Exception e) {
            }
            try {
                rptNow = (RptFmsDetail) rptAKTNow.get(i);
            } catch (Exception e) {
            }

            String level = "";
            if (rptPrev.getLevel() == 1) {
            } else if (rptPrev.getLevel() == 2) {
                level = "<img src=\"../images/spacer.gif\" width=\"20\" height=\"1\">";
            } else if (rptPrev.getLevel() == 3) {
                level = "<img src=\"../images/spacer.gif\" width=\"40\" height=\"1\">";
            } else if (rptPrev.getLevel() == 4) {
                level = "<img src=\"../images/spacer.gif\" width=\"60\" height=\"1\">";
            } else if (rptPrev.getLevel() == 5) {
                level = "<img src=\"../images/spacer.gif\" width=\"80\" height=\"1\">";
            }
            seq = seq + 1;
            boolean isBold = (rptPrev.getStatus().equals("HEADER")) ? true : false;
                                                                                        %>
                                                                                         <tr> 
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"><%=seq%></td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + rptPrev.getDescription() + "</b>" : rptPrev.getDescription())%></td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(rptPrev.getAmount(), isBold)%></div></td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(rptNow.getAmount(), isBold)%></div></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3" class="tablecell1">&nbsp;<i>Klik GO Button to searching the data...</i></td>
                                                                            </tr>
                                                                            <%}%>
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
    <!-- #EndTemplate -->
</html>
