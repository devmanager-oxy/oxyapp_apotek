
<%-- 
    Document   : neracasaldo
    Created on : Nov 11, 2011, 11:32:14 AM
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
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.session.*" %>
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
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");            
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");
            int accountType = JSPRequestValue.requestInt(request, "type_account");
            int levAccount = JSPRequestValue.requestInt(request, "level_account");

            String where = "";

            if (levAccount == 1) {
                where = where + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 1;
            } else if (levAccount == 2) {
                where = where + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 1 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 2;
            } else if (levAccount == 3) {
                where = where + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 1 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 2 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 3;
            } else if (levAccount == 4) {
                where = where + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 1 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 2 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 3 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 4;
            } else if (levAccount == 5) {
                where = where + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 1 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 2 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 3 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 4 + " OR " + DbCoa.colNames[DbCoa.COL_LEVEL] + " = " + 5;
            }

            System.out.println("where :" + where);

            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            Vector rptDetails = DbRptFormatDetail.list(0, 0, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + oidRptFormat, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

            Company company = DbCompany.getCompany();

            Periode period = DbPeriode.getOpenPeriod();
            if (periodId != 0) {
                try {
                    period = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {}
            }

            Date reportDate = new Date();
            Date endPeriod = period.getEndDate();
            if (reportDate.after(endPeriod)) {
                reportDate = endPeriod;
            }

            if (period.getType() == DbPeriode.TYPE_PERIOD13) {
                reportDate = period.getStartDate();
            }


            Date dtx = (Date) reportDate.clone();
            dtx.setYear(dtx.getYear() - 1);

            Date dt = period.getStartDate();
            Date startDate = (Date) dt.clone();
            startDate.setYear(startDate.getYear() - 1);
            startDate.setDate(startDate.getDate() + 10);

            Periode lastPeriod = DbPeriode.getPeriodByTransDate(startDate);

            if (period.getType() == DbPeriode.TYPE_PERIOD13) {
                System.out.println("----- periode 13 : yes");
                lastPeriod = DbPeriode.getLastYearPeriod13(period);
            }
            
            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            
            String[] langFR = {"Show List", "Account With Transaction", "All", "BALANCE SHEET", "PERIOD", //0-4
                "Description", "Total"}; //5-6

            String[] langNav = {"Financial Report", "Balance Sheet", "Period", "Priview", "Level", "Type"};

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "NERACA", "PERIODE", //0-4
                    "Keterangan", "Total"}; //5-6
                langFR = langID;
                String[] navID = {"Laporan Keuangan", "Naraca Saldo", "Periode", "Priview", "Level", "Type"};
                langNav = navID;
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
            hs.captionId = 'the-caption';            
            hs.outlineType = 'rounded-white';
        </script>         
        <script type="text/javascript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%> 
            
            function cmdGO(){
                document.form1.action="neracasaldo.jsp";
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
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title">
                                                        <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                        %>
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <tr> 
                                                    <td>
                                                        <form id="frmneraca" name="form1" method="post" action="">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="rpt_format_id" value="<%=oidRptFormat%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="4">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="23">
                                                                                    <table width="500">
                                                                                        <tr>
                                                                                            <td><B><%=langNav[5]%></B></td>
                                                                                            <td>
                                                                                                <select name="type_account">
                                                                                                    <option value="1" <%if (accountType == 1) {%>selected<%}%>>Aktiva</option>
                                                                                                    <option value="2" <%if (accountType == 2) {%>selected<%}%>>Pasiva</option>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td><b><%=langNav[4]%></b></td>
                                                                                            <td>
                                                                                                <select name="level_account">
                                                                                                    <option value="1" <%if (levAccount == 1) {%>selected<%}%>>1</option>
                                                                                                    <option value="2" <%if (levAccount == 2) {%>selected<%}%>>2</option>
                                                                                                    <option value="3" <%if (levAccount == 3) {%>selected<%}%>>3</option>
                                                                                                    <option value="4" <%if (levAccount == 4) {%>selected<%}%>>4</option>
                                                                                                    <option value="5" <%if (levAccount == 5) {%>selected<%}%>>5</option>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td><b><%=langNav[2]%></b></td>
                                                                                            <td>
                                                                                                <select name="period_id">
                                                                                                    <%if (periods != null && periods.size() > 0) {
                for (int i = 0; i < periods.size(); i++) {
                    Periode per = (Periode) periods.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=per.getOID()%>" <%if (per.getOID() == periodId) {%>selected<%}%>><%=per.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="2">
                                                                                                <a href="javascript:cmdGO()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/search2.gif',1)"><img src="../images/search.gif" name="post" height="21" border="0" width="59"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="15"></td>
                                                                            </tr>
                                                                             <%
            if (accountType == 1 || accountType == 2) {
                                                                            %>
                                                                            <tr>
                                                                                <td colspan="4" height="23"> 
                                                                                    <div align="center"><b><%=company.getName().toUpperCase()%></b></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="23"><div align="center"><b><%=langNav[1].toUpperCase()%></b></div></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="23"> 
                                                                                    <div align="center"><b>PER <%=JSPFormater.formatDate(dtx, "dd MMMM yyyy").toUpperCase()%> DAN <%=JSPFormater.formatDate(reportDate, "dd MMMM yyyy").toUpperCase()%></b></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="15"></td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <%
            if (accountType == 1 || accountType == 2) {
                                                                            %>
                                                                            <tr height="25">
                                                                                <td class="tablehdr" width="4%">NO</td>
                                                                                <td class="tablehdr" width="36%">URAIAN</td>
                                                                                <td class="tablehdr" width="15%">SALDO AWAL</td>
                                                                                <td class="tablehdr" width="15%">DEBET</td>
                                                                                <td class="tablehdr" width="15%">CREDIT</td>
                                                                                <td class="tablehdr" width="15%">SALDO</td>
                                                                            </tr>
                                                                            <%
            }
            if (accountType == 1) {
                                                                            %>
                                                                            <tr> 
                                                                                <td >&nbsp;</td>
                                                                                <td ><b><font color="#CC3300" size="2">AKTIVA</font></b></td>
                                                                                <td >&nbsp;</td>
                                                                                <td >&nbsp;</td>
                                                                                <td >&nbsp;</td>
                                                                                <td >&nbsp;</td>
                                                                            </tr>
                                                                            <%

                                                                                double totalSaldoAwal = 0;
                                                                                double totalDebet = 0;
                                                                                double totalCredit = 0;
                                                                                double totalSaldo = 0;

                                                                                int seq = 0;

                                                                                for (int x = 0; x < I_Project.accGroup.length; x++){

                                                                                    Vector tempCoas = new Vector();

                                                                                    if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LIQUID_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_FIXED_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)) {

                                                                                        String whereClause = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'";

                                                                                        if (where.length() > 0) {
                                                                                            whereClause = whereClause + " AND ( " + where + " )";
                                                                                        }

                                                                                        tempCoas = DbCoa.list(0, 0, whereClause, DbCoa.colNames[DbCoa.COL_CODE]);
                                                                                    }

                                                                                    if (tempCoas != null && tempCoas.size() > 0) {

                                                                                        for (int i = 0; i < tempCoas.size(); i++){

                                                                                            Coa coa = (Coa) tempCoas.get(i);

                                                                                            boolean isBold = (coa.getStatus().equals("HEADER")) ? true : false;

                                                                                            String level = "";
                                                                                            if (coa.getLevel() == 1) {
                                                                                            } else if (coa.getLevel() == 2) {
                                                                                                level = "<img src=\"../images/spacer.gif\" width=\"20\" height=\"1\">";
                                                                                            } else if (coa.getLevel() == 3) {
                                                                                                level = "<img src=\"../images/spacer.gif\" width=\"40\" height=\"1\">";
                                                                                            } else if (coa.getLevel() == 4) {
                                                                                                level = "<img src=\"../images/spacer.gif\" width=\"60\" height=\"1\">";
                                                                                            } else if (coa.getLevel() == 5) {
                                                                                                level = "<img src=\"../images/spacer.gif\" width=\"80\" height=\"1\">";
                                                                                            }

                                                                                            double saldoAwal = 0;
                                                                                            double debet = 0;
                                                                                            double credit = 0;
                                                                                            double saldo = 0;

                                                                                            saldoAwal = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                                                                                            debet = SessNeracaSaldo.getDebet(coa.getOID(), period.getOID());
                                                                                            credit = SessNeracaSaldo.getCredit(coa.getOID(), period.getOID());
                                                                                            saldo = saldoAwal + debet - credit;

                                                                                            if (!isBold) {
                                                                                                totalSaldoAwal = totalSaldoAwal + saldoAwal;
                                                                                                totalDebet = totalDebet + debet;
                                                                                                totalCredit = totalCredit + credit;
                                                                                                totalSaldo = totalSaldo + saldo;
                                                                                            }

                                                                                            boolean isOpen = false;

                                                                                            if (previewType == 0) {
                                                                                                isOpen = true;
                                                                                            }

                                                                                            if (isOpen) {
                                                                                                seq = seq + 1;

                                                                            %>
                                                                            <tr> 
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"><%=seq%></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=isBold ? "<b>" : ""%><%=getFormated(saldoAwal, false)%><%=isBold ? "</b>" : ""%></div></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=isBold ? "<b>" : ""%><%=getFormated(debet, false)%><%=isBold ? "</b>" : ""%></div></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=isBold ? "<b>" : ""%><%=getFormated(credit, false)%><%=isBold ? "</b>" : ""%></div></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=isBold ? "<b>" : ""%><%=getFormated(saldo, false)%> <%=isBold ? "</b>" : ""%></div></td>
                                                                            </tr>
                                                                            <%}
                                                                                        }
                                                                                    }
                                                                                }%>
                                                                            <tr> 
                                                                                <td colspan="6" height="1" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>&nbsp;</td>
                                                                                <td><b><font color="#CC3300" size="2">TOTAL AKTIVA</font></b></td>
                                                                                <td><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalSaldoAwal, false)%></b></font></div></td>
                                                                                <td><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalDebet, false)%></b></font></div></td>
                                                                                <td><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalCredit, false)%></b></font></div></td>
                                                                                <td><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalSaldo, false)%></b></font></div></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6" height="1" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6" height="3" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6">
                                                                                    <%
            out.print("<a href=\"../freport/neracasaldo_priview.jsp?type=" + accountType + "&where='" + where + "'&periode_id="+ period.getOID()+ "\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
                                                                                    %>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%
            if (accountType == 2) {
                                                                            %>
                                                                            <tr> 
                                                                                <td height="22"></td>
                                                                                <td height="22"><b><font color="#CC3300" size="2">PASIVA</font></b></td>
                                                                                <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                            </tr>
                                                                            <%
                                                                         
                                                                                int seq = 0;

                                                                                double totalSaldoAwal = 0;
                                                                                double totalDebet = 0;
                                                                                double totalCredit = 0;
                                                                                double totalSaldo = 0;

                                                                                for (int x = 0; x < I_Project.accGroup.length; x++) {

                                                                                    Vector tempCoas = new Vector();

                                                                                    if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EQUITY)) {
                                                                                        
                                                                                        String whereClause = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'";

                                                                                        if (where.length() > 0) {
                                                                                            whereClause = whereClause + " AND ( " + where + " )";
                                                                                        }
                                                                                        
                                                                                        tempCoas = DbCoa.list(0, 0, whereClause, DbCoa.colNames[DbCoa.COL_CODE]);
                                                                                    }

                                                                                    if (tempCoas != null && tempCoas.size() > 0) {

                                                                                        for (int i = 0; i < tempCoas.size(); i++) {

                                                                                            Coa coa = (Coa) tempCoas.get(i);

                                                                                            boolean isBold = (coa.getStatus().equals("HEADER")) ? true : false;

                                                                                            String level = "";
                                                                                            if (coa.getLevel() == 1) {
                                                                                            //level = "<img src=\"../images/spacer.gif\" width=\"25\" height=\"1\">";
                                                                                            } else if (coa.getLevel() == 2) {
                                                                                                //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                level = "<img src=\"../images/spacer.gif\" width=\"20\" height=\"1\">";
                                                                                            } else if (coa.getLevel() == 3) {
                                                                                                //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                level = "<img src=\"../images/spacer.gif\" width=\"40\" height=\"1\">";
                                                                                            } else if (coa.getLevel() == 4) {
                                                                                                //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                level = "<img src=\"../images/spacer.gif\" width=\"60\" height=\"1\">";
                                                                                            } else if (coa.getLevel() == 5) {
                                                                                                //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                                                                                level = "<img src=\"../images/spacer.gif\" width=\"80\" height=\"1\">";
                                                                                            }

                                                                                            double saldoAwal = 0;
                                                                                            double debet = 0;
                                                                                            double credit = 0;
                                                                                            double saldo = 0;
                                                                                            
                                                                                            if (coaLabaBerjalan.getCode().equals(coa.getCode())) {                                                                                                
                                                                                                saldoAwal = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                                                                                                credit = DbGlDetail.getTotalIncomeInPeriod(period.getOID());                                                                                                
                                                                                                debet = DbGlDetail.getTotalExpenseInPeriod(period.getOID());
                                                                                                saldo = saldoAwal + credit - debet;
                                                                                            }else{
                                                                                                saldoAwal = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                                                                                                debet = SessNeracaSaldo.getDebet(coa.getOID(), period.getOID());
                                                                                                credit = SessNeracaSaldo.getCredit(coa.getOID(), period.getOID());
                                                                                                saldo = saldoAwal + credit - debet;
                                                                                            }
                                                                                            
                                                                                            //saldo awal = 0;
                                                                                            // debet : select sum(gd.credit)-sum(gd.debet) from gl_detail gd inner join coa co on gd.coa_id = co.coa_id inner join gl g on gd.gl_id = g.gl_id where (co.account_group = 'Revenue' or co.account_group = 'Other Revenue') and g.trans_date between '2012-01-01' and '2012-07-31';
                                                                                            // credit select sum(gd.debet)-sum(gd.credit) from gl_detail gd inner join coa co on gd.coa_id = co.coa_id inner join gl g on gd.gl_id = g.gl_id where (co.account_group = 'Expense' or co.account_group = 'Other Expense') and g.trans_date between '2012-01-01' and '2012-07-31';

                                                                                            if (!isBold) {
                                                                                                totalSaldoAwal = totalSaldoAwal + saldoAwal;
                                                                                                totalDebet = totalDebet + debet;
                                                                                                totalCredit = totalCredit + credit;
                                                                                                totalSaldo = totalSaldo + saldo;
                                                                                            }

                                                                                            boolean isOpen = false;
                                                                                            if (previewType == 0) {
                                                                                                isOpen = true;
                                                                                            }

                                                                                            if (isOpen) {

                                                                                                seq = seq + 1;

                                                                            %>
                                                                            <tr> 
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"><%=seq%> </td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=isBold ? "<b>" : ""%><%=getFormated(saldoAwal, false)%><%=isBold ? "</b>" : ""%></div></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=isBold ? "<b>" : ""%><%=getFormated(debet, false)%><%=isBold ? "</b>" : ""%></div></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=isBold ? "<b>" : ""%><%=getFormated(credit, false)%><%=isBold ? "</b>" : ""%></div></td>
                                                                                <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=isBold ? "<b>" : ""%><%=getFormated(saldo, false)%><%=isBold ? "</b>" : ""%></div></td>
                                                                            </tr>
                                                                            <%}
                                                                                        }
                                                                                    }
                                                                                }

                                                                            %>
                                                                            <tr> 
                                                                                <td height="1" bgcolor="#609836"></td>
                                                                                <td height="1" bgcolor="#609836"></td>
                                                                                <td height="1" bgcolor="#609836"></td>
                                                                                <td height="1" bgcolor="#609836"></td>
                                                                                <td height="1" bgcolor="#609836"></td>
                                                                                <td height="1" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="22"></td>
                                                                                <td height="22"><b><font color="#CC3300" size="2">TOTAL PASIVA</font></b></td>
                                                                                <td height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalSaldoAwal, false)%></b></font></div></td>
                                                                                <td height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalDebet, false)%></b></font></div></td>
                                                                                <td height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalCredit, false)%></b></font></div></td>
                                                                                <td height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalSaldo, false)%></b></font></div></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan = "6" height="1" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6" height="3" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="6">
                                                                                    <%
            out.print("<a href=\"../freport/neracasaldo_priview.jsp?type="+ accountType +"&where='"+ where +"'&periode_id="+ period.getOID()+"\"  onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
                                                                                    %>
                                                                                </td>
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