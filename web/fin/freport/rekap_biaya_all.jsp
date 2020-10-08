
<%-- 
    Document   : rekap_biaya_all
    Created on : Apr 20, 2011, 11:13:41 AM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_DELETE);
%>
<%
            if (session.getValue("REKAP_BIAYA") != null) {
                session.removeValue("REKAP_BIAYA");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");

            int valShowList = JSPRequestValue.requestInt(request, "showlist");

            if (valShowList == 0) {
                valShowList = 1;
            }

            int valShowLevel = JSPRequestValue.requestInt(request, "showlevel");
            String strShowLevel = JSPRequestValue.requestString(request, "showlevel");

            if (strShowLevel.equals("")) {
                valShowLevel = -1;
            }

            /*variable declaration*/
            int recordToGet = 10;
//int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "code";

            Vector listCoa = new Vector(1, 1);

            int vectSize = DbCoa.getCount(whereClause);
            recordToGet = vectSize;

            Coa coa = new Coa();

            /* get record to display */
            listCoa = DbCoa.list(start, recordToGet, whereClause, orderClause);

            String strTotal = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            String strTotal1 = "       ";
            String cssString = "tablecell4";

            String displayStr = "";
            String displayStr_lastYear = "";

            String displayStrSD = "";
            String displayStrSD_lastYear = "";

            double coaSummary1 = 0;
            double coaSummary2 = 0;
            double coaSummary3 = 0;
            double coaSummary4 = 0;
            double coaSummary5 = 0;

            double coaSummary1SD = 0;
            double coaSummary2SD = 0;
            double coaSummary3SD = 0;
            double coaSummary4SD = 0;
            double coaSummary5SD = 0;

            double anggaran1 = 0;
            double anggaran2 = 0;
            double anggaran3 = 0;
            double anggaran4 = 0;
            double anggaran5 = 0;

            double anggaran1SD = 0;
            double anggaran2SD = 0;
            double anggaran3SD = 0;
            double anggaran4SD = 0;
            double anggaran5SD = 0;

            double coaSummary1_lastYear = 0;
            double coaSummary2_lastYear = 0;
            double coaSummary3_lastYear = 0;
            double coaSummary4_lastYear = 0;
            double coaSummary5_lastYear = 0;

            double coaSummary1SD_lastYear = 0;
            double coaSummary2SD_lastYear = 0;
            double coaSummary3SD_lastYear = 0;
            double coaSummary4SD_lastYear = 0;
            double coaSummary5SD_lastYear = 0;

            Vector listReport = new Vector();
            SesReportBs sesReport = new SesReportBs();

            String[] langFR = {"Show List", "Account With Transaction", "All", "PROFIT & LOSS STATEMENT", "PERIOD", "Description", "Total", "Net Income"}; //0-6
            String[] langNav = {"Financial Report", "Profit & Loss Standard"};

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "REALISASI BIAYA OPERASI", "PERIODE", "Keterangan", "Total", "Pendapatan Bersih"}; //0-6
                langFR = langID;
                String[] navID = {"Laporan Keuangan", "Rekap Biaya Seluruhnya"};
                langNav = navID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <title><%=systemTitle%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/default.css" rel="stylesheet" type="text/css" />
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        function cmdChangeList(){
            document.frmcoa.action="rekap_biaya_all.jsp";
            document.frmcoa.submit();
        }
        
        function cmdPrintJournal(){	 
            window.open("<%=printroot%>.report.RptProfitLossPDF?oid=<%=appSessUser.getLoginId()%>");
            }
            
            function cmdPrintJournalXLS(){	 
                window.open("<%=printroot%>.report.RptProfitLossORIXLS?oid=<%=appSessUser.getLoginId()%>");
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
%>
<%@ include file="../main/navigator.jsp"%>
                                <!-- #EndEditable --></td>
                            </tr>
                            <!--tr> 
<td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                            </tr-->
                            <tr> 
                                <td><!-- #BeginEditable "content" --> 
                                    <form name="frmcoa" method ="post" action="">
                                        <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                        <input type="hidden" name="start" value="<%=start%>">
                                        <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                        <input type="hidden" name="hidden_coa_id" value="<%=oidCoa%>">
                                        <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr align="left" valign="top"> 
                                                <td height="8"  colspan="3" class="container"> 
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" colspan="3"></td>
                                                        </tr>             
                                                        <tr align="left" valign="top"> 
                                                            <td height="8" valign="middle" colspan="3">
                                                                <table width="280" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr align="left" valign="middle">
                                                                        <td width="100" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;"><%=langFR[0]%> : </td>
                                                                        <td width="180" colspan="0">&nbsp; 
                                                                            <select name="showlist" onChange="javascript:cmdChangeList()">
                                                                                <option value="1" <%if (valShowList == 1) {%>selected<%}%>><%=langFR[1]%></option>
                                                                                <option value="2" <%if (valShowList == 2) {%>selected<%}%>><%=langFR[2]%></option>
                                                                            </select>
                                                                        </td>                                                              
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>									
                                                        <tr align="left" valign="top"> 
                                                            <td height="40" colspan="3">&nbsp</td>
                                                        </tr> 
                                                        <tr align="left" valign="top"> 
                                                            <td colspan="3" style="font-family:Arial, Helvetica, sans-serif; font-size:18px; text-align:center; font-weight:bold ; color:#2b5e04;" ><%=langFR[3]%></td>
                                                        </tr> 
                                                        <%
            Periode periode = DbPeriode.getOpenPeriod();
            Periode periodeLastYear = DbPeriode.getOpnPeriodLastYear();

            String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");
                                                        %>
                                                        <tr align="left" valign="top"> 
                                                            <td colspan="3" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; text-align:center; font-weight:bold ; color:#2b5e04;" >S/D <%=JSPFormater.formatDate(periode.getEndDate(), "MMM yyyy")%></td>
                                                        </tr> 
                                                        <tr align="left" valign="top"> 
                                                            <td height="20" colspan="3">&nbsp</td>
                                                        </tr> 
                                                        <tr align="left" valign="top"> 
                                                            <td colspan="3">
                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">                                                                                        
                                                                    <tr>
                                                                        <td rowspan="4" class="tablecell2">URAIAN</td>
                                                                        <td height="38" colspan="5" class="tablecell2"><%=JSPFormater.formatDate(periode.getEndDate(), "MMMM yyyy") %></td>
                                                                        <td colspan="5" class="tablecell2">S/D <%=JSPFormater.formatDate(periode.getEndDate(), "MMMM yyyy") %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="tablecell2">REALISASI</td>
                                                                        <td class="tablecell2">ANGGARAN</td>
                                                                        <td class="tablecell2">REALISASI</td>
                                                                        <td colspan="2" rowspan="2" class="tablecell2">%</td>
                                                                        <td class="tablecell2">REALISASI</td>
                                                                        <td class="tablecell2">ANGG</td>
                                                                        <td class="tablecell2">REALISASI</td>
                                                                        <td colspan="2" rowspan="2" class="tablecell2">%</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="tablecell2"><%=JSPFormater.formatDate(periode.getEndDate(), "MMMM") %></td>
                                                                        <td class="tablecell2"><%=JSPFormater.formatDate(periode.getEndDate(), "MMMM") %></td>
                                                                        <td class="tablecell2"><%=JSPFormater.formatDate(periode.getEndDate(), "MMMM") %></td>
                                                                        <td class="tablecell2">S/D <%=JSPFormater.formatDate(periode.getEndDate(), "MMMM") %></td>
                                                                        <td class="tablecell2">S/D <%=JSPFormater.formatDate(periode.getEndDate(), "MMMM") %></td>
                                                                        <td class="tablecell2">S/D <%=JSPFormater.formatDate(periode.getEndDate(), "MMMM") %></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td class="tablecell2"><%=periode.getEndDate().getYear() + 1900 - 1 %></td>
                                                                        <td class="tablecell2"><%=periode.getEndDate().getYear() + 1900 %></td>
                                                                        <td class="tablecell2"><%=periode.getEndDate().getYear() + 1900 %></td>
                                                                        <td class="tablecell2"><%=periode.getEndDate().getYear() + 1900 - 1  %></td>
                                                                        <td class="tablecell2">ANGG</td>
                                                                        <td class="tablecell2"><%=periode.getEndDate().getYear() + 1900 - 1 %></td>
                                                                        <td class="tablecell2"><%=periode.getEndDate().getYear() + 1900 %></td>
                                                                        <td class="tablecell2"><%=periode.getEndDate().getYear() + 1900 %></td>
                                                                        <td class="tablecell2"><%=periode.getEndDate().getYear() + 1900 - 1 %></td>
                                                                        <td class="tablecell2">ANGG</td>
                                                                    </tr>
                                                                    <!--level ACC_GROUP_REVENUE-->
<%
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD") != 0 || valShowList != 1) {	//add Group Header

                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_REVENUE);
                sesReport.setFont(1);
                listReport.add(sesReport);
%>
                                                                    <tr>
                                                                        <td class="tablecell12"><%=I_Project.ACC_GROUP_REVENUE%></td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                        <td class="tablecell12">&nbsp;</td>
                                                                    </tr>
                                                                    <%
            }
                                                                    %>
                                                                    <%
            if (listCoa != null && listCoa.size() > 0) {

                coaSummary1 = 0;
                coaSummary1_lastYear = 0;

                coaSummary1SD = 0;
                coaSummary1SD_lastYear = 0;

                anggaran1 = 0;
                anggaran1SD = 0;

                String str = "";
                String str1 = "";

                String strAnggaran = "";
                String strAnggaranSD = "";

                double angg = 0;
                double anggSD = 0;

                for (int i = 0; i < listCoa.size(); i++) {

                    coa = (Coa) listCoa.get(i);

                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {

                        str = DbCoa.switchLevel(coa.getLevel());
                        str1 = DbCoa.switchLevel1(coa.getLevel());

                        double amount = DbCoa.getCoaBalanceCD(coa.getOID());
                        double amount_lastYear = DbCoa.getCoaBalanceCDLastYear(coa.getOID());

                        //untuk perhitungan realisasi sampai dengan periode tertentu
                        double amountSD = DbCoa.getCoaBalanceToPeriode(periode, coa.getOID());
                        double amountSD_lastYear = DbCoa.getCoaBalanceToPeriode(periodeLastYear, coa.getOID());

                        coaSummary1 = coaSummary1 + amount;
                        coaSummary1_lastYear = coaSummary1_lastYear + amount_lastYear;

                        coaSummary1SD = coaSummary1SD + amountSD;
                        coaSummary1SD_lastYear = coaSummary1SD_lastYear + amountSD_lastYear;

                        if (coa.getStatus().equals("HEADER")) {

                            strAnggaran = "&nbsp;";
                            strAnggaranSD = "&nbsp;";

                        } else {

                            angg = DbCoa.getCoaBudgetDetail(coa.getOID());
                            anggSD = DbCoa.getCoaBudgetDetailSD(periode, coa.getOID());

                            anggaran1 = anggaran1 + angg;
                            strAnggaran = JSPFormater.formatNumber(angg, "#,###.##");

                            anggaran1SD = anggaran1SD + anggSD;
                            strAnggaranSD = JSPFormater.formatNumber(anggSD, "#,###.##");

                        }

                        displayStr = DbCoa.strDisplay(amount, coa.getStatus());
                        displayStr_lastYear = DbCoa.strDisplay(amount_lastYear, coa.getStatus());

                        displayStrSD = DbCoa.strDisplay(amountSD, coa.getStatus());
                        displayStrSD_lastYear = DbCoa.strDisplay(amountSD_lastYear, coa.getStatus());

                        if (valShowList == 1) {

                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD") != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail

                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());

                                sesReport.setAmount(amount);
                                sesReport.setAmountPrevYear(amount_lastYear);
                                sesReport.setStrAmount("" + amount);
                                sesReport.setStrAmountPrevYear("" + amount_lastYear);

                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                listReport.add(sesReport);

                                double persnThdRealisasi = 0;
                                double persenAnggaran = 0;

                                double persnThdRealisasiSD = 0;
                                double persenAnggaranSD = 0;

                                String strPersnThdRealisasi = "";
                                String strPersenAnggaran = "";

                                String strPersnThdRealisasiSD = "";
                                String strPersenAnggaranSD = "";

                                if (coa.getStatus().equals("HEADER")) {

                                    strPersnThdRealisasi = "&nbsp;";
                                    strPersenAnggaran = "&nbsp;";

                                    strPersnThdRealisasiSD = "&nbsp;";
                                    strPersenAnggaranSD = "&nbsp;";

                                } else {

                                    if (amount_lastYear != 0) {
                                        persnThdRealisasi = (amount / amount_lastYear) * 100;
                                        strPersnThdRealisasi = JSPFormater.formatNumber(persnThdRealisasi, "#,###.##");

                                        persnThdRealisasiSD = (amountSD / amountSD_lastYear) * 100;
                                        strPersnThdRealisasiSD = JSPFormater.formatNumber(persnThdRealisasiSD, "#,###.##");
                                    }

                                    if (angg != 0) {

                                        persenAnggaran = (amount / angg) * 100;
                                        strPersenAnggaran = JSPFormater.formatNumber(persenAnggaran, "#,###.##");

                                    } else {

                                        strPersenAnggaran = "0.00";
                                    }

                                    if (anggSD != 0) {

                                        persenAnggaranSD = (amountSD / anggSD) * 100;
                                        strPersenAnggaranSD = JSPFormater.formatNumber(persenAnggaranSD, "#,###.##");

                                    } else {

                                        strPersenAnggaranSD = "0.00";

                                    }
                                }

                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaranSD%></div></td>
                                                                    </tr>
                                                                    <%				}
                                                                                } else {

                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType(coa.getStatus());
                                                                                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                        sesReport.setAmount(amount);
                                                                                        sesReport.setAmountPrevYear(amount_lastYear);
                                                                                        sesReport.setStrAmount("" + amount);
                                                                                        sesReport.setAmountPrevYear(amount_lastYear);
                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                        listReport.add(sesReport);

                                                                                        double persnThdRealisasi = 0;
                                                                                        double persenAnggaran = 0;

                                                                                        double persnThdRealisasiSD = 0;
                                                                                        double persenAnggaranSD = 0;

                                                                                        String strPersnThdRealisasi = "";
                                                                                        String strPersenAnggaran = "";

                                                                                        String strPersnThdRealisasiSD = "";
                                                                                        String strPersenAnggaranSD = "";

                                                                                        if (coa.getStatus().equals("HEADER")) {

                                                                                            strPersnThdRealisasi = "&nbsp;";
                                                                                            strPersenAnggaran = "&nbsp;";

                                                                                            strPersnThdRealisasiSD = "&nbsp;";
                                                                                            strPersenAnggaranSD = "&nbsp;";

                                                                                        } else {

                                                                                            if (amount_lastYear != 0) {

                                                                                                persnThdRealisasi = (amount / amount_lastYear) * 100;
                                                                                                strPersnThdRealisasi = JSPFormater.formatNumber(persnThdRealisasi, "#,###.##");

                                                                                                persnThdRealisasiSD = (amount / amountSD_lastYear) * 100;
                                                                                                strPersnThdRealisasiSD = JSPFormater.formatNumber(persnThdRealisasiSD, "#,###.##");

                                                                                            }

                                                                                            if (angg != 0) {

                                                                                                persenAnggaran = (amount / angg) * 100;
                                                                                                strPersenAnggaran = JSPFormater.formatNumber(persenAnggaran, "#,###.##");

                                                                                            } else {

                                                                                                strPersenAnggaran = "0.00";
                                                                                            }

                                                                                            if (anggSD != 0) {

                                                                                                persenAnggaranSD = (amountSD / anggSD) * 100;
                                                                                                strPersenAnggaranSD = JSPFormater.formatNumber(persenAnggaranSD, "#,###.##");

                                                                                            } else {

                                                                                                strPersenAnggaranSD = "0.00";
                                                                                            }


                                                                                        }
                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaranSD%></td>
                                                                    </tr>                                         
                                                                    <%					}
                                                                                }
                                                                            }
                                                                            if (coaSummary1 < 0) {
                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary1 * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary1 > 0) {
                                                                                displayStr = JSPFormater.formatNumber(coaSummary1, "#,###.##");
                                                                            } else if (coaSummary1 == 0) {
                                                                                displayStr = "";
                                                                            }

                                                                            if (coaSummary1_lastYear < 0) {
                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary1_lastYear * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary1_lastYear > 0) {
                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary1_lastYear, "#,###.##");
                                                                            } else if (coaSummary1_lastYear == 0) {
                                                                                displayStr_lastYear = "";
                                                                            }


                                                                            if (coaSummary1SD < 0) {
                                                                                displayStrSD = "(" + JSPFormater.formatNumber(coaSummary1SD * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary1SD > 0) {
                                                                                displayStrSD = JSPFormater.formatNumber(coaSummary1SD, "#,###.##");
                                                                            } else if (coaSummary1SD == 0) {
                                                                                displayStrSD = "";
                                                                            }

                                                                            if (coaSummary1SD_lastYear < 0) {
                                                                                displayStrSD_lastYear = "(" + JSPFormater.formatNumber(coaSummary1SD_lastYear * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary1SD_lastYear > 0) {
                                                                                displayStrSD_lastYear = JSPFormater.formatNumber(coaSummary1SD_lastYear, "#,###.##");
                                                                            } else if (coaSummary1SD_lastYear == 0) {
                                                                                displayStrSD_lastYear = "";
                                                                            }

                                                                        }

                                                                        //add footer level
                                                                        if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD") != 0 || valShowList != 1) {	//add Group Footer
                                                                            sesReport = new SesReportBs();
                                                                            sesReport.setType("Footer Group Level");
                                                                            sesReport.setDescription("Total " + I_Project.ACC_GROUP_REVENUE);
                                                                            sesReport.setAmount(coaSummary1);
                                                                            sesReport.setStrAmount("" + coaSummary1);
                                                                            sesReport.setAmountPrevYear(coaSummary1_lastYear);
                                                                            sesReport.setStrAmountPrevYear("" + coaSummary1_lastYear);
                                                                            sesReport.setFont(1);
                                                                            listReport.add(sesReport);
                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell2"><b><%="Total " + I_Project.ACC_GROUP_REVENUE%></b></td>
                                                                        <td class="tablecell2"><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                        <td class="tablecell2"><div align="right"><b><%=anggaran1%></b></div></td>
                                                                        <td class="tablecell2"><div align="right"><b><%=displayStr%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2"><div align="right"><b><%=displayStrSD_lastYear%></b></div></td>
                                                                        <td class="tablecell2"><div align="right"><b><%=anggaran1SD%></b></div></td>
                                                                        <td class="tablecell2"><div align="right"><b><%=displayStrSD%></b></div></td>
                                                                        <td class="tablecell2">&nbsp;</td>
                                                                        <td class="tablecell2">&nbsp;</td>
                                                                    </tr>                                                                                        
                                                                    <%
                }
            }

            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD") != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                listReport.add(sesReport);
                                                                    %>
                                                                    <tr>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                        <td class="tablecell1">&nbsp;</td>
                                                                    </tr>   
                                                                    <%}%>   
                                                                    
                                                                                                                                                           
                                                                    <!--level 2-->
                                                                    <!--level ACC_GROUP_EXPENSE-->
<%            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC") != 0 || valShowList != 1) {	//add Group Header
                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_COST_OF_SALES);
                sesReport.setFont(1);
                listReport.add(sesReport);
%>
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell" ><span class="level2"><b><%=I_Project.ACC_GROUP_COST_OF_SALES%></b></span></td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                        <td class="tablecell" >&nbsp;</td>
                                                                    </tr> 
                                                                    <%}%>									
                                                                    <%
            if (listCoa != null && listCoa.size() > 0) {

                anggaran2 = 0;
                anggaran2SD = 0;

                coaSummary2 = 0;
                coaSummary2_lastYear = 0;

                coaSummary2SD = 0;
                coaSummary2SD_lastYear = 0;

                String str = "";
                String str1 = "";

                String strSD = "";
                String str1SD = "";

                String strAnggaran = "";
                double angg = 0;

                String strAnggaranSD = "";
                double anggSD = 0;

                for (int i = 0; i < listCoa.size(); i++) {

                    coa = (Coa) listCoa.get(i);

                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {

                        str = DbCoa.switchLevel(coa.getLevel());
                        str1 = DbCoa.switchLevel1(coa.getLevel());

                        double amount = DbCoa.getCoaBalance(coa.getOID());
                        double amount_lastYear = DbCoa.getCoaBalanceLastYear(coa.getOID());

                        double amountSD = DbCoa.getCoaBalanceToPeriode(periode, coa.getOID());
                        double amountSD_lastYear = DbCoa.getCoaBalanceToPeriode(periodeLastYear, coa.getOID());

                        coaSummary2 = coaSummary2 + amount;
                        coaSummary2_lastYear = coaSummary2_lastYear + amount_lastYear;

                        coaSummary2SD = coaSummary2SD + amountSD;
                        coaSummary2SD_lastYear = coaSummary2SD_lastYear + amountSD_lastYear;

                        if (coa.getStatus().equals("HEADER")) {
                            strAnggaran = "&nbsp;";
                            strAnggaranSD = "&nbsp;";
                        } else {

                            angg = DbCoa.getCoaBudgetDetail(coa.getOID());
                            anggSD = DbCoa.getCoaBudgetDetailSD(periode, coa.getOID());

                            anggaran2 = anggaran2 + angg;
                            strAnggaran = JSPFormater.formatNumber(angg, "#,###.##");

                            anggaran2SD = anggaran2SD + anggSD;
                            strAnggaranSD = JSPFormater.formatNumber(anggSD, "#,###.##");

                        }

                        displayStr = DbCoa.strDisplay(amount, coa.getStatus());
                        displayStr_lastYear = DbCoa.strDisplay(amount_lastYear, coa.getStatus());

                        displayStrSD = DbCoa.strDisplay(amount, coa.getStatus());
                        displayStrSD_lastYear = DbCoa.strDisplay(amountSD_lastYear, coa.getStatus());

                        double persnThdRealisasi = 0;
                        double persenAnggaran = 0;

                        String strPersnThdRealisasi = "";
                        String strPersenAnggaran = "";

                        double persnThdRealisasiSD = 0;
                        double persenAnggaranSD = 0;

                        String strPersnThdRealisasiSD = "";
                        String strPersenAnggaranSD = "";

                        if (coa.getStatus().equals("HEADER")) {

                            strPersnThdRealisasi = "&nbsp;";
                            strPersenAnggaran = "&nbsp;";

                            strPersnThdRealisasiSD = "&nbsp;";
                            strPersenAnggaranSD = "&nbsp;";

                        } else {

                            if (amount_lastYear != 0) {
                                persnThdRealisasi = (amount / amount_lastYear) * 100;
                                strPersnThdRealisasi = JSPFormater.formatNumber(persnThdRealisasi, "#,###.##");

                                persnThdRealisasiSD = (amountSD / amountSD_lastYear) * 100;
                                strPersnThdRealisasiSD = JSPFormater.formatNumber(persnThdRealisasiSD, "#,###.##");
                            } else {
                                strPersnThdRealisasi = "0.00";
                                strPersnThdRealisasiSD = "0.00";
                            }

                            if (angg != 0) {

                                persenAnggaran = (amount / angg) * 100;
                                strPersenAnggaran = JSPFormater.formatNumber(persenAnggaran, "#,###.##");

                            } else {

                                strPersenAnggaran = "0.00";
                            }

                            if (anggSD != 0) {

                                persenAnggaranSD = (amountSD / anggSD) * 100;
                                strPersenAnggaranSD = JSPFormater.formatNumber(persenAnggaranSD, "#,###.##");

                            } else {

                                strPersenAnggaranSD = "0.00";
                            }

                        }

                        if (valShowList == 1) {
                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC") != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail

                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(amount);
                                sesReport.setStrAmount("" + amount);
                                sesReport.setAmountPrevYear(amount_lastYear);
                                sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                listReport.add(sesReport);
                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaranSD%></div></td>
                                                                    </tr> 
                                                                    
                                                                    <%				}
                                                                                } else {
                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail

                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType(coa.getStatus());
                                                                                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                        sesReport.setAmount(amount);
                                                                                        sesReport.setStrAmount("" + amount);
                                                                                        sesReport.setAmountPrevYear(amount_lastYear);
                                                                                        sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                        listReport.add(sesReport);


                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaranSD%></div></td>
                                                                    </tr> 							
                                                                    <%					}
                                                                                }
                                                                            }
                                                                            if (coaSummary2 < 0) {
                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary2 * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary2 > 0) {
                                                                                displayStr = JSPFormater.formatNumber(coaSummary2, "#,###.##");
                                                                            } else if (coaSummary2 == 0) {
                                                                                displayStr = "";
                                                                            }


                                                                            if (coaSummary2_lastYear < 0) {
                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary2_lastYear * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary2_lastYear > 0) {
                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary2_lastYear, "#,###.##");
                                                                            } else if (coaSummary2_lastYear == 0) {
                                                                                displayStr_lastYear = "";
                                                                            }


                                                                            if (coaSummary2SD < 0) {
                                                                                displayStrSD = "(" + JSPFormater.formatNumber(coaSummary2SD * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary2SD > 0) {
                                                                                displayStrSD = JSPFormater.formatNumber(coaSummary2SD, "#,###.##");
                                                                            } else if (coaSummary2SD == 0) {
                                                                                displayStrSD = "";
                                                                            }


                                                                            if (coaSummary2SD_lastYear < 0) {
                                                                                displayStrSD_lastYear = "(" + JSPFormater.formatNumber(coaSummary2SD_lastYear * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary2SD_lastYear > 0) {
                                                                                displayStrSD_lastYear = JSPFormater.formatNumber(coaSummary2SD_lastYear, "#,###.##");
                                                                            } else if (coaSummary2SD_lastYear == 0) {
                                                                                displayStrSD_lastYear = "";
                                                                            }
                                                                        }
                                                                        //add footer level
                                                                        if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC") != 0 || valShowList != 1) {	//add Group Footer
                                                                            sesReport = new SesReportBs();
                                                                            sesReport.setType("Footer Group Level");
                                                                            sesReport.setDescription("Total " + I_Project.ACC_GROUP_COST_OF_SALES);
                                                                            sesReport.setAmount(coaSummary2);
                                                                            sesReport.setStrAmount("" + coaSummary2);
                                                                            sesReport.setAmountPrevYear(coaSummary2_lastYear);
                                                                            sesReport.setStrAmountPrevYear("" + coaSummary2_lastYear);
                                                                            sesReport.setFont(1);
                                                                            listReport.add(sesReport);

                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell2" ><b><%="Total " + I_Project.ACC_GROUP_COST_OF_SALES%></b></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                        <td class="tablecell2" ><div align="right"><%=anggaran2%></div></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStr%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStrSD_lastYear%></b></div></td>
                                                                        <td class="tablecell2" ><div align="right"><%=anggaran2SD%></div></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStrSD%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                    </tr> 
                                                                    <%
                }
            }
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC") != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                listReport.add(sesReport);
                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                    </tr> 
                                                                    <%	}%>
                                                                    
                                                                    <!--level 3-->
                                                                    <!--level ACC_GROUP_EXPENSE-->
                                                                                 <%
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC") != 0 || valShowList != 1) {	//add Group Header
                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_EXPENSE);
                sesReport.setFont(1);
                listReport.add(sesReport);
                                                                                 %>     
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell12" ><%=I_Project.ACC_GROUP_EXPENSE%></td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                        <td class="tablecell12" >&nbsp;</td>
                                                                    </tr> 
                                                                    <%
            }
                                                                    %>								
                                                                    <%
            if (listCoa != null && listCoa.size() > 0) {

                anggaran3 = 0;
                coaSummary3 = 0;
                coaSummary3_lastYear = 0;
                String str = "";
                String str1 = "";
                String strAnggaran = "";
                double angg = 0;

                anggaran3SD = 0;
                coaSummary3SD = 0;
                coaSummary3SD_lastYear = 0;
                String strSD = "";
                String str1SD = "";
                String strAnggaranSD = "";
                double anggSD = 0;

                for (int i = 0; i < listCoa.size(); i++) {

                    coa = (Coa) listCoa.get(i);

                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {

                        str = DbCoa.switchLevel(coa.getLevel());
                        str1 = DbCoa.switchLevel1(coa.getLevel());

                        double amount = DbCoa.getCoaBalance(coa.getOID());
                        double amount_lastYear = DbCoa.getCoaBalanceLastYear(coa.getOID());

                        double amountSD = DbCoa.getCoaBalanceToPeriode(periode, coa.getOID());
                        double amountSD_lastYear = DbCoa.getCoaBalanceToPeriode(periodeLastYear, coa.getOID());

                        coaSummary3 = coaSummary3 + amount;
                        coaSummary3_lastYear = coaSummary3_lastYear + amount_lastYear;

                        coaSummary3SD = coaSummary3SD + amountSD;
                        coaSummary3SD_lastYear = coaSummary3SD_lastYear + amountSD_lastYear;

                        if (coa.getStatus().equals("HEADER")) {

                            strAnggaran = "&nbsp;";
                            strAnggaranSD = "&nbsp;";

                        } else {

                            angg = DbCoa.getCoaBudget(coa.getOID());
                            anggSD = DbCoa.getCoaBudgetDetailSD(periode, coa.getOID());

                            anggaran3 = anggaran3 + angg;
                            strAnggaran = "" + angg;

                            anggaran3SD = anggaran3SD + anggSD;
                            strAnggaranSD = JSPFormater.formatNumber(anggSD, "#,###.##");

                        }

                        double persnThdRealisasi = 0;
                        double persenAnggaran = 0;

                        String strPersnThdRealisasi = "";
                        String strPersenAnggaran = "";

                        double persnThdRealisasiSD = 0;
                        double persenAnggaranSD = 0;

                        String strPersnThdRealisasiSD = "";
                        String strPersenAnggaranSD = "";

                        if (coa.getStatus().equals("HEADER")) {

                            strPersnThdRealisasi = "&nbsp;";
                            strPersenAnggaran = "&nbsp;";

                            strPersnThdRealisasiSD = "&nbsp;";
                            strPersenAnggaranSD = "&nbsp;";

                        } else {

                            if (amount_lastYear != 0) {
                                persnThdRealisasi = (amount / amount_lastYear) * 100;
                                strPersnThdRealisasi = JSPFormater.formatNumber(persnThdRealisasi, "#,###.##");

                                persnThdRealisasiSD = (amountSD / amountSD_lastYear) * 100;
                                strPersnThdRealisasiSD = JSPFormater.formatNumber(persnThdRealisasiSD, "#,###.##");
                            } else {
                                strPersnThdRealisasi = "0.00";
                                strPersnThdRealisasiSD = "0.00";

                            }

                            if (angg != 0) {

                                persenAnggaran = (amount / angg) * 100;
                                strPersenAnggaran = JSPFormater.formatNumber(persenAnggaran, "#,###.##");

                            } else {

                                strPersenAnggaran = "0.00";
                            }

                            if (anggSD != 0) {

                                persenAnggaranSD = (amountSD / anggSD) * 100;
                                strPersenAnggaranSD = JSPFormater.formatNumber(persenAnggaranSD, "#,###.##");

                            } else {

                                strPersenAnggaranSD = "0.00";
                            }
                        }

                        displayStr = DbCoa.strDisplay(amount, coa.getStatus());
                        displayStr_lastYear = DbCoa.strDisplay(amount_lastYear, coa.getStatus());

                        displayStrSD = DbCoa.strDisplay(amountSD, coa.getStatus());
                        displayStrSD_lastYear = DbCoa.strDisplay(amountSD_lastYear, coa.getStatus());

                        if (valShowList == 1) {
                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC") != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(amount);
                                sesReport.setStrAmount("" + amount);
                                sesReport.setAmountPrevYear(amount_lastYear);
                                sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                listReport.add(sesReport);
                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                    </tr> 						
                                                                    <%				}
                                                                                } else {
                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType(coa.getStatus());
                                                                                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                        sesReport.setAmount(amount);
                                                                                        sesReport.setStrAmount("" + amount);
                                                                                        sesReport.setAmountPrevYear(amount_lastYear);
                                                                                        sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                        listReport.add(sesReport);

                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                    <td class="<%=cssString%>" <div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>                                                                                            
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaranSD%></div></td>
                                                                    </tr> 
                                                                    <%					}
                                                                                }
                                                                            }
                                                                            if (coaSummary3 < 0) {
                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary3 * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary3 > 0) {
                                                                                displayStr = JSPFormater.formatNumber(coaSummary3, "#,###.##");
                                                                            } else if (coaSummary3 == 0) {
                                                                                displayStr = "";
                                                                            }

                                                                            if (coaSummary3SD < 0) {
                                                                                displayStrSD = "(" + JSPFormater.formatNumber(coaSummary3SD * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary3SD > 0) {
                                                                                displayStrSD = JSPFormater.formatNumber(coaSummary3SD, "#,###.##");
                                                                            } else if (coaSummary3SD == 0) {
                                                                                displayStrSD = "";
                                                                            }

                                                                            if (coaSummary3_lastYear < 0) {
                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary3_lastYear * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary3_lastYear > 0) {
                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary3_lastYear, "#,###.##");
                                                                            } else if (coaSummary3_lastYear == 0) {
                                                                                displayStr_lastYear = "";
                                                                            }

                                                                            if (coaSummary3SD_lastYear < 0) {
                                                                                displayStrSD_lastYear = "(" + JSPFormater.formatNumber(coaSummary3SD_lastYear * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary3SD_lastYear > 0) {
                                                                                displayStrSD_lastYear = JSPFormater.formatNumber(coaSummary3SD_lastYear, "#,###.##");
                                                                            } else if (coaSummary3SD_lastYear == 0) {
                                                                                displayStrSD_lastYear = "";
                                                                            }

                                                                        }				//add footer level
                                                                        if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC") != 0 || valShowList != 1) {	//add Group Footer
                                                                            sesReport = new SesReportBs();
                                                                            sesReport.setType("Footer Group Level");
                                                                            sesReport.setDescription("Total " + I_Project.ACC_GROUP_EXPENSE);
                                                                            sesReport.setAmount(coaSummary3);
                                                                            sesReport.setStrAmount("" + coaSummary3);
                                                                            sesReport.setAmountPrevYear(coaSummary3_lastYear);
                                                                            sesReport.setStrAmountPrevYear("" + coaSummary3_lastYear);
                                                                            sesReport.setFont(1);
                                                                            listReport.add(sesReport);
                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell2" ><b><%="Total " + I_Project.ACC_GROUP_EXPENSE%></b></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                        <td class="tablecell2" ><div align="right"><%=anggaran3%></div></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStr%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStrSD_lastYear%></b></div></td>
                                                                        <td class="tablecell2" ><div align="right"><%=anggaran3SD%></div></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStrSD%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                    </tr> 
                                                                    <%
                }
            }
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC") != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                listReport.add(sesReport);
                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                    </tr> 
                                                                    
                                                                    <%	}%>
                                                                    
                                                                    <!--level 4-->
                                                                    <!--level ACC_GROUP_OTHER_REVENUE-->
                                                                                 <%            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD") != 0 || valShowList != 1) {	//add Group Header
                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_OTHER_REVENUE);
                sesReport.setFont(1);
                listReport.add(sesReport);
                                                                                 %>
                                                                                        
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell1" ><b><%=I_Project.ACC_GROUP_OTHER_REVENUE%></b></td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                    </tr> 
                                                                    <%
            }
                                                                    %>
                                                                    <%
            if (listCoa != null && listCoa.size() > 0) {

                anggaran4 = 0;
                coaSummary4 = 0;
                coaSummary4_lastYear = 0;
                String str = "";
                String str1 = "";
                String strAnggaran = "";
                double angg = 0;

                anggaran4SD = 0;
                coaSummary4SD = 0;
                coaSummary4SD_lastYear = 0;
                String strSD = "";
                String str1SD = "";
                String strAnggaranSD = "";
                double anggSD = 0;

                for (int i = 0; i < listCoa.size(); i++) {
                    coa = (Coa) listCoa.get(i);

                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {

                        str = DbCoa.switchLevel(coa.getLevel());
                        str1 = DbCoa.switchLevel1(coa.getLevel());

                        double amount = DbCoa.getCoaBalanceCD(coa.getOID());
                        double amount_lastYear = DbCoa.getCoaBalanceCDLastYear(coa.getOID());

                        double amountSD = DbCoa.getCoaBalanceToPeriode(periode, coa.getOID());
                        double amountSD_lastYear = DbCoa.getCoaBalanceToPeriode(periodeLastYear, coa.getOID());

                        coaSummary4 = coaSummary4 + amount;
                        displayStr = DbCoa.strDisplay(amount, coa.getStatus());

                        coaSummary4SD = coaSummary4SD + amountSD;
                        coaSummary4SD_lastYear = coaSummary4SD_lastYear + amountSD_lastYear;

                        if (coa.getStatus().equals("HEADER")) {

                            strAnggaran = "&nbsp;";
                            strAnggaranSD = "&nbsp;";

                        } else {

                            angg = DbCoa.getCoaBudget(coa.getOID());
                            anggSD = DbCoa.getCoaBudgetDetailSD(periode, coa.getOID());

                            anggaran4 = anggaran4 + angg;
                            strAnggaran = JSPFormater.formatNumber(angg, "#,###.##");

                            strAnggaran = "" + angg;
                            strAnggaranSD = JSPFormater.formatNumber(anggSD, "#,###.##");

                        }

                        if (coa.getStatus().equals("HEADER")) {
                            strAnggaran = "&nbsp;";
                        } else {
                            angg = DbCoa.getCoaBudget(coa.getOID());
                            anggaran3 = anggaran3 + angg;
                            strAnggaran = "" + angg;
                        }

                        double persnThdRealisasi = 0;
                        double persenAnggaran = 0;

                        String strPersnThdRealisasi = "";
                        String strPersenAnggaran = "";

                        double persnThdRealisasiSD = 0;
                        double persenAnggaranSD = 0;

                        String strPersnThdRealisasiSD = "";
                        String strPersenAnggaranSD = "";

                        if (coa.getStatus().equals("HEADER")) {

                            strPersnThdRealisasi = "&nbsp;";
                            strPersenAnggaran = "&nbsp;";

                            strPersnThdRealisasiSD = "&nbsp;";
                            strPersenAnggaranSD = "&nbsp;";

                        } else {

                            if (amount_lastYear != 0) {
                                persnThdRealisasi = (amount / amount_lastYear) * 100;
                                strPersnThdRealisasi = JSPFormater.formatNumber(persnThdRealisasi, "#,###.##");

                                persnThdRealisasiSD = (amountSD / amountSD_lastYear) * 100;
                                strPersnThdRealisasiSD = JSPFormater.formatNumber(persnThdRealisasiSD, "#,###.##");

                            } else {
                                strPersnThdRealisasi = "0.00";
                                strPersnThdRealisasiSD = "0.00";
                            }

                            if (angg != 0) {

                                persenAnggaran = (amount / angg) * 100;
                                strPersenAnggaran = JSPFormater.formatNumber(persenAnggaran, "#,###.##");

                            } else {

                                strPersenAnggaran = "0.00";
                            }

                            if (anggSD != 0) {

                                persenAnggaranSD = (amountSD / anggSD) * 100;
                                strPersenAnggaranSD = JSPFormater.formatNumber(persenAnggaranSD, "#,###.##");

                            } else {

                                strPersenAnggaranSD = "0.00";
                            }

                        }


                        coaSummary4_lastYear = coaSummary4_lastYear + amount_lastYear;
                        displayStr_lastYear = DbCoa.strDisplay(amount_lastYear, coa.getStatus());

                        coaSummary4SD_lastYear = coaSummary4SD_lastYear + amountSD_lastYear;
                        displayStrSD_lastYear = DbCoa.strDisplay(amountSD_lastYear, coa.getStatus());

                        if (valShowList == 1) {
                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD") != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(amount);
                                sesReport.setStrAmount("" + amount);

                                sesReport.setAmountPrevYear(amount_lastYear);
                                sesReport.setStrAmountPrevYear("" + amount_lastYear);

                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                listReport.add(sesReport);
                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                    </tr>
                                                                    
                                                                    <%				}
                                                                                } else {
                                                                                    if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType(coa.getStatus());
                                                                                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                        sesReport.setAmount(amount);
                                                                                        sesReport.setStrAmount("" + amount);
                                                                                        sesReport.setAmountPrevYear(amount_lastYear);
                                                                                        sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                        listReport.add(sesReport);
                                                                    %>
                                                                    

                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaranSD%></div></td>
                                                                    </tr>
                                                                    <%					}
                                                                                }
                                                                            }
                                                                            if (coaSummary4 < 0) {
                                                                                displayStr = "(" + JSPFormater.formatNumber(coaSummary4 * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary4 > 0) {
                                                                                displayStr = JSPFormater.formatNumber(coaSummary4, "#,###.##");
                                                                            } else if (coaSummary4 == 0) {
                                                                                displayStr = "";
                                                                            }

                                                                            if (coaSummary4_lastYear < 0) {
                                                                                displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary4_lastYear * -1, "#,###.##") + ")";
                                                                            } else if (coaSummary4_lastYear > 0) {
                                                                                displayStr_lastYear = JSPFormater.formatNumber(coaSummary4_lastYear, "#,###.##");
                                                                            } else if (coaSummary4_lastYear == 0) {
                                                                                displayStr_lastYear = "";
                                                                            }

                                                                        }
                                                                        //add footer level
                                                                        if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD") != 0 || valShowList != 1) {	//add Group Footer
                                                                            sesReport = new SesReportBs();
                                                                            sesReport.setType("Footer Group Level");
                                                                            sesReport.setDescription("Total " + I_Project.ACC_GROUP_OTHER_REVENUE);
                                                                            sesReport.setAmount(coaSummary4);
                                                                            sesReport.setStrAmount("" + coaSummary4);
                                                                            sesReport.setAmount(coaSummary4_lastYear);
                                                                            sesReport.setStrAmount("" + coaSummary4_lastYear);
                                                                            sesReport.setFont(1);
                                                                            listReport.add(sesReport);
                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell2" ><b><%="Total " + I_Project.ACC_GROUP_OTHER_REVENUE%></b></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                        <td class="tablecell2" ><div align="right"><%=anggaran4%></div></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStr%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStrSD_lastYear%></b></div></td>
                                                                    <td class="tablecell2" ><%=anggaran4SD%></div></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStrSD%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                    </tr>                                                                                       
                                                                    <%
                }
            }
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE,
                    "CD") != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                listReport.add(sesReport);
                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                    </tr>  
                                                                    <%	}%>
                                                                    <!--level 5-->
                                                                    <!--level ACC_GROUP_OTHER_EXPENSE-->
                                                                                 <%
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC") != 0 || valShowList != 1) {	//add Group Header
                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_OTHER_EXPENSE);
                sesReport.setFont(1);
                listReport.add(sesReport);
                                                                                 %>
                                                                                        

                                                                    <tr>                                                                                            
                                                                        <td class="tablecell1" ><b><%=I_Project.ACC_GROUP_OTHER_EXPENSE%></b></td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                    </tr> 	
                                                                    <%	}%>								
                                                                    
                                                                    
                                                                    <%            if (listCoa != null && listCoa.size() > 0) {

                anggaran5 = 0;
                coaSummary5 = 0;
                coaSummary5_lastYear = 0;
                String str = "";
                String str1 = "";
                String strAnggaran = "";
                double angg = 0;

                anggaran5SD = 0;
                coaSummary5SD = 0;
                coaSummary5SD_lastYear = 0;
                String strSD = "";
                String str1SD = "";
                String strAnggaranSD = "";
                double anggSD = 0;

                for (int i = 0; i < listCoa.size(); i++) {

                    coa = (Coa) listCoa.get(i);

                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                        str = DbCoa.switchLevel(coa.getLevel());
                        str1 = DbCoa.switchLevel1(coa.getLevel());

                        double amount = DbCoa.getCoaBalance(coa.getOID());
                        double amount_lastYear = DbCoa.getCoaBalanceLastYear(coa.getOID());

                        double amountSD = DbCoa.getCoaBalanceToPeriode(periode, coa.getOID());
                        double amountSD_lastYear = DbCoa.getCoaBalanceToPeriode(periodeLastYear, coa.getOID());

                        coaSummary5 = coaSummary5 + amount;
                        displayStr = DbCoa.strDisplay(amount, coa.getStatus());

                        coaSummary5SD = coaSummary5SD + amountSD;
                        coaSummary5SD_lastYear = coaSummary5SD_lastYear + amountSD_lastYear;

                        if (coa.getStatus().equals("HEADER")) {
                            strAnggaran = "&nbsp;";
                            strAnggaranSD = "&nbsp;";
                        } else {
                            angg = DbCoa.getCoaBudget(coa.getOID());
                            anggSD = DbCoa.getCoaBudgetDetailSD(periode, coa.getOID());

                            anggaran5 = anggaran5 + angg;
                            strAnggaran = "" + angg;

                            anggaran5SD = anggaran5SD + anggSD;
                            strAnggaranSD = "" + anggSD;
                        }

                        double persnThdRealisasi = 0;
                        double persenAnggaran = 0;

                        double persnThdRealisasiSD = 0;
                        double persenAnggaranSD = 0;

                        String strPersnThdRealisasi = "";
                        String strPersenAnggaran = "";

                        String strPersnThdRealisasiSD = "";
                        String strPersenAnggaranSD = "";

                        if (coa.getStatus().equals("HEADER")) {

                            strPersnThdRealisasi = "&nbsp;";
                            strPersenAnggaran = "&nbsp;";

                            strPersnThdRealisasiSD = "&nbsp;";
                            strPersenAnggaranSD = "&nbsp;";

                        } else {

                            if (amount_lastYear != 0) {
                                persnThdRealisasi = (amount / amount_lastYear) * 100;
                                strPersnThdRealisasi = JSPFormater.formatNumber(persnThdRealisasi, "#,###.##");
                                persnThdRealisasiSD = (amountSD / amountSD_lastYear) * 100;
                                strPersnThdRealisasiSD = JSPFormater.formatNumber(persnThdRealisasiSD, "#,###.##");
                            } else {
                                strPersnThdRealisasi = "0.00";
                                strPersnThdRealisasiSD = "0.00";
                            }

                            if (angg != 0) {

                                persenAnggaran = (amount / angg) * 100;
                                strPersenAnggaran = JSPFormater.formatNumber(persenAnggaran, "#,###.##");

                            } else {

                                strPersenAnggaran = "0.00";
                            }

                            if (anggSD != 0) {

                                persenAnggaranSD = (amountSD / anggSD) * 100;
                                strPersenAnggaranSD = JSPFormater.formatNumber(persenAnggaranSD, "#,###.##");

                            } else {

                                strPersenAnggaranSD = "0.00";
                            }

                        }


                        coaSummary5_lastYear = coaSummary5_lastYear + amount_lastYear;
                        displayStr_lastYear = DbCoa.strDisplay(amount_lastYear, coa.getStatus());

                        coaSummary5SD_lastYear = coaSummary5SD_lastYear + amount_lastYear;
                        displayStrSD_lastYear = DbCoa.strDisplay(amountSD_lastYear, coa.getStatus());

                        if (valShowList == 1) {

                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC") != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(amount);
                                sesReport.setStrAmount("" + amount);
                                sesReport.setAmountPrevYear(amount_lastYear);
                                sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                listReport.add(sesReport);
                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaranSD%></div></td>
                                                                    </tr> 							
                                                                    <%				}
                                                                                            } else {
                                                                                                if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setAmount(amount);
                                                                                                    sesReport.setStrAmount("" + amount);
                                                                                                    sesReport.setAmountPrevYear(amount_lastYear);
                                                                                                    sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                                                                                    sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                    listReport.add(sesReport);
                                                                    %>
                                                                    
                                                                    <tr>                                                                                            
                                                                        <td class="<%=cssString%>" ><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStr%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasi%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaran%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD_lastYear%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strAnggaranSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=displayStrSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersnThdRealisasiSD%></div></td>
                                                                        <td class="<%=cssString%>" ><div align="right"><%=strPersenAnggaranSD%></div></td>
                                                                    </tr> 
                                                                    <%					}
                        }
                    }
                    if (coaSummary5 < 0) {
                        displayStr = "(" + JSPFormater.formatNumber(coaSummary5 * -1, "#,###.##") + ")";
                    } else if (coaSummary5 > 0) {
                        displayStr = JSPFormater.formatNumber(coaSummary5, "#,###.##");
                    } else if (coaSummary5 == 0) {
                        displayStr = "";
                    }

                    if (coaSummary5SD < 0) {
                        displayStrSD = "(" + JSPFormater.formatNumber(coaSummary5SD * -1, "#,###.##") + ")";
                    } else if (coaSummary5SD > 0) {
                        displayStrSD = JSPFormater.formatNumber(coaSummary5SD, "#,###.##");
                    } else if (coaSummary5SD == 0) {
                        displayStrSD = "";
                    }

                    if (coaSummary5_lastYear < 0) {
                        displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary5_lastYear * -1, "#,###.##") + ")";
                    } else if (coaSummary5_lastYear > 0) {
                        displayStr_lastYear = JSPFormater.formatNumber(coaSummary5_lastYear, "#,###.##");
                    } else if (coaSummary5_lastYear == 0) {
                        displayStr_lastYear = "";
                    }

                    if (coaSummary5SD_lastYear < 0) {
                        displayStrSD_lastYear = "(" + JSPFormater.formatNumber(coaSummary5SD_lastYear * -1, "#,###.##") + ")";
                    } else if (coaSummary5SD_lastYear > 0) {
                        displayStrSD_lastYear = JSPFormater.formatNumber(coaSummary5SD_lastYear, "#,###.##");
                    } else if (coaSummary5SD_lastYear == 0) {
                        displayStrSD_lastYear = "";
                    }

                }
                //add footer level
                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC") != 0 || valShowList != 1) {	//add Group Footer

                    sesReport = new SesReportBs();
                    sesReport.setType("Footer Group Level");
                    sesReport.setDescription("Total " + I_Project.ACC_GROUP_OTHER_EXPENSE);
                    sesReport.setAmount(coaSummary5);
                    sesReport.setStrAmount("" + coaSummary5);
                    sesReport.setAmountPrevYear(coaSummary5_lastYear);
                    sesReport.setStrAmountPrevYear("" + coaSummary5_lastYear);
                    sesReport.setFont(1);
                    listReport.add(sesReport);
                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell2" ><b><%="Total " + I_Project.ACC_GROUP_OTHER_EXPENSE%></b></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                        <td class="tablecell2" ><div align="right"><%=anggaran5%></div></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStr%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStrSD_lastYear%></b></div></td>
                                                                        <td class="tablecell2" ><div align="right"><%=anggaran5SD%></div></td>
                                                                        <td class="tablecell2" ><div align="right"><b><%=displayStrSD%></b></div></td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                        <td class="tablecell2" >&nbsp;</td>
                                                                    </tr>
                                                                    <%
                }
            }
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC") != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                listReport.add(sesReport);
                                                                    %>
                                                                    <tr>                                                                                            
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                        <td class="tablecell1" >&nbsp;</td>
                                                                    </tr>
                                                                    <%}%>
                                                                    <%
            /*
            double anggaranTotal = 0;
            double anggaranTotalSD = 0;
            anggaranTotal = anggaran1 + anggaran2 + anggaran3 + anggaran4 + anggaran5;
            anggaranTotalSD = anggaran1SD + anggaran2SD + anggaran3SD + anggaran4SD + anggaran5SD;
            if (coaSummary1 - coaSummary2 - coaSummary3 + coaSummary4 - coaSummary5 < 0) {
            displayStr = "(" + JSPFormater.formatNumber((coaSummary1 - coaSummary2 - coaSummary3 + coaSummary4 - coaSummary5) * -1, "#,###.##") + ")";
            } else if (coaSummary1 - coaSummary2 - coaSummary3 + coaSummary4 - coaSummary5 > 0) {
            displayStr = JSPFormater.formatNumber((coaSummary1 - coaSummary2 - coaSummary3 + coaSummary4 - coaSummary5), "#,###.##");
            } else if (coaSummary1 - coaSummary2 - coaSummary3 + coaSummary4 - coaSummary5 == 0) {
            displayStr = "";
            }
            if (coaSummary1SD - coaSummary2SD - coaSummary3SD + coaSummary4SD - coaSummary5SD < 0) {
            displayStrSD = "(" + JSPFormater.formatNumber((coaSummary1SD - coaSummary2SD - coaSummary3SD + coaSummary4SD - coaSummary5SD) * -1, "#,###.##") + ")";
            } else if (coaSummary1SD - coaSummary2SD - coaSummary3SD + coaSummary4SD - coaSummary5SD > 0) {
            displayStrSD = JSPFormater.formatNumber((coaSummary1SD - coaSummary2SD - coaSummary3SD + coaSummary4SD - coaSummary5SD), "#,###.##");
            } else if (coaSummary1SD - coaSummary2SD - coaSummary3SD + coaSummary4SD - coaSummary5SD == 0) {
            displayStrSD = "";
            }
            if (coaSummary1_lastYear - coaSummary2_lastYear - coaSummary3_lastYear + coaSummary4_lastYear - coaSummary5_lastYear < 0) {
            displayStr_lastYear = "(" + JSPFormater.formatNumber((coaSummary1_lastYear - coaSummary2_lastYear - coaSummary3_lastYear + coaSummary4_lastYear - coaSummary5_lastYear) * -1, "#,###.##") + ")";
            } else if (coaSummary1_lastYear - coaSummary2_lastYear - coaSummary3_lastYear + coaSummary4_lastYear - coaSummary5_lastYear > 0) {
            displayStr_lastYear = JSPFormater.formatNumber((coaSummary1_lastYear - coaSummary2_lastYear - coaSummary3_lastYear + coaSummary4_lastYear - coaSummary5_lastYear), "#,###.##");
            } else if (coaSummary1_lastYear - coaSummary2_lastYear - coaSummary3_lastYear + coaSummary4_lastYear - coaSummary5_lastYear == 0) {
            displayStr_lastYear = "";
            }
            if (coaSummary1SD_lastYear - coaSummary2SD_lastYear - coaSummary3SD_lastYear + coaSummary4SD_lastYear - coaSummary5SD_lastYear < 0) {
            displayStrSD_lastYear = "(" + JSPFormater.formatNumber((coaSummary1SD_lastYear - coaSummary2SD_lastYear - coaSummary3SD_lastYear + coaSummary4SD_lastYear - coaSummary5SD_lastYear) * -1, "#,###.##") + ")";
            } else if (coaSummary1SD_lastYear - coaSummary2SD_lastYear - coaSummary3SD_lastYear + coaSummary4SD_lastYear - coaSummary5SD_lastYear > 0) {
            displayStrSD_lastYear = JSPFormater.formatNumber((coaSummary1SD_lastYear - coaSummary2SD_lastYear - coaSummary3SD_lastYear + coaSummary4SD_lastYear - coaSummary5SD_lastYear), "#,###.##");
            } else if (coaSummary1SD_lastYear - coaSummary2SD_lastYear - coaSummary3SD_lastYear + coaSummary4SD_lastYear - coaSummary5SD_lastYear == 0) {
            displayStrSD_lastYear = "";
            }
            sesReport = new SesReportBs();
            sesReport.setType("Last Level");
            sesReport.setDescription("Net Income");
            sesReport.setAmount(coaSummary1 - coaSummary2 - coaSummary3 + coaSummary4 - coaSummary5);
            sesReport.setStrAmount("" + (coaSummary1 - coaSummary2 - coaSummary3 + coaSummary4 - coaSummary5));
            sesReport.setAmountPrevYear(coaSummary1_lastYear - coaSummary2_lastYear - coaSummary3_lastYear + coaSummary4_lastYear - coaSummary5_lastYear);
            sesReport.setStrAmountPrevYear("" + (coaSummary1_lastYear - coaSummary2_lastYear - coaSummary3_lastYear + coaSummary4_lastYear - coaSummary5_lastYear));
            sesReport.setFont(1);
            listReport.add(sesReport);
             */%>	
                                                                                                                                        
                                                                </table>
                                                            </td>
                                                        </tr> 											  			  
                                                    </table>
                                                </td>
                                            </tr>
                                            <%
            session.putValue("REKAP_BIAYA", listReport);
                                            
                                            %>
                                            
                                            <tr align="left" valign="top"> 
                                                <td height="8" valign="middle" colspan="3">&nbsp; </td>
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