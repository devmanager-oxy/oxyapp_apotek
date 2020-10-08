
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

        /*if(amount>=0){
        return (isBold) ? "<b>"+JSPFormater.formatNumber(amount, "#,###.##")+"</b>" : JSPFormater.formatNumber(amount, "#,###.##");
        }
        else{
        return (isBold) ? "<b>("+JSPFormater.formatNumber(amount*-1, "#,###.##")+")</b>" : "("+JSPFormater.formatNumber(amount*-1, "#,###.##")+")";
        }*/

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

    public String getIndoDate(Date dt) {

        String dateFrmt = "";

        if (dt.getMonth() == 0) {
            dateFrmt = dateFrmt + dt.getDate() + " JANUARI";
        }
        if (dt.getMonth() == 1) {
            dateFrmt = dateFrmt + dt.getDate() + " FEBRUARI";
        }
        if (dt.getMonth() == 2) {
            dateFrmt = dateFrmt + dt.getDate() + " MARET";
        }
        if (dt.getMonth() == 3) {
            dateFrmt = dateFrmt + dt.getDate() + " APRIL";
        }
        if (dt.getMonth() == 4) {
            dateFrmt = dateFrmt + dt.getDate() + " MEI";
        }
        if (dt.getMonth() == 5) {
            dateFrmt = dateFrmt + dt.getDate() + " JUNI";
        }
        if (dt.getMonth() == 6) {
            dateFrmt = dateFrmt + dt.getDate() + " JULI";
        }
        if (dt.getMonth() == 7) {
            dateFrmt = dateFrmt + dt.getDate() + " AGUSTUS";
        }
        if (dt.getMonth() == 8) {
            dateFrmt = dateFrmt + dt.getDate() + " SEPTEMBER";
        }
        if (dt.getMonth() == 9) {
            dateFrmt = dateFrmt + dt.getDate() + " OKTOBER";
        }
        if (dt.getMonth() == 10) {
            dateFrmt = dateFrmt + dt.getDate() + " NOVEMBER";
        }
        if (dt.getMonth() == 11) {
            dateFrmt = dateFrmt + dt.getDate() + " DESEMBER";
        }

        int yr = dt.getYear() + 1900;

        dateFrmt = dateFrmt + " " + yr;

        return dateFrmt;

    }

%>

<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");
            int reportRange = JSPRequestValue.requestInt(request, "report_range");
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");

            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            Vector rptDetails = DbRptFormatDetail.list(0, 0, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + oidRptFormat, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

            Company company = DbCompany.getCompany();

            Periode period = DbPeriode.getOpenPeriod();
            if (periodId != 0) {
                try {
                    period = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }
            }

//last year
            Date dt = period.getStartDate();
            Date startDate = (Date) dt.clone();
            startDate.setYear(startDate.getYear() - 1);
            startDate.setDate(startDate.getDate() + 10);

            Periode lastPeriod = DbPeriode.getPeriodByTransDate(startDate);

//if periode 13 then get prev period 13
            if (period.getType() == DbPeriode.TYPE_PERIOD13) {
                System.out.println("----- periode 13 : yes");
                lastPeriod = DbPeriode.getLastYearPeriod13(period);
            }

            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));
            Coa coaLabaLalu = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_LALU"));

            String indukLaba1 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_1");
            String indukLaba2 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_2");
            String indukLaba3 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_3");
            String indukLaba4 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_4");

            Date reportDate = new Date();
            Date endPeriod = period.getEndDate();
            if (reportDate.after(endPeriod)) {
                reportDate = endPeriod;
            }

            Date dtx = (Date) reportDate.clone();
            dtx.setYear(dtx.getYear() - 1);


            /*** LANG ***/
            String[] langFR = {"Period", "Preview", "All Account", "Account > 0", "NO", "DESCRIPTION", "REALIZATION UNTIL"}; //0-6
            String[] langNav = {"Financial Report", "Detail", "Profit & Loss"};
            String title = "";

            try {
                title = DbSystemProperty.getValueByName("TITLE_REPORT_LABA_RUGI_EN");
            } catch (Exception e) {
            }

            if (lang == LANG_ID) {
                String[] langID = {"Periode", "Tampilkan", "Semua Perkiraan", "Perkiraan > 0", "NO", "URAIAN", "REALISASI S/D"}; //0-6
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Penjelasan", "Laba Rugi"};
                langNav = navID;
                
                try {
                    title = DbSystemProperty.getValueByName("TITLE_REPORT_LABA_RUGI");
                } catch (Exception e) {
                }
            }
%>
<html >
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
            <%if(!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdGO(){
                document.form1.action="income_penjelasan.jsp";
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;</font><font class=\"lvl1\">" + langNav[1] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;</font><span class=\"lvl2\">" + langNav[2] + "</span>";
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
                                                                                <td width="7%">&nbsp;</td>
                                                                                <td width="19%">&nbsp;</td>
                                                                                <td width="41%">&nbsp;</td>
                                                                                <td width="33%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="7%" nowrap height="23">&nbsp;</td>
                                                                                <td width="19%" height="23">&nbsp;</td>
                                                                                <td width="41%" height="23">&nbsp;</td>
                                                                                <td width="33%" height="23">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="7%" nowrap height="23"><b><%=langFR[0]%></b></td>
                                                                                <td width="19%" height="23">
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
                                                                                <td width="41%" height="23"> 
                                                                                    <div align="center"><b><%=company.getName().toUpperCase()%></b></div>
                                                                                </td>
                                                                                <td width="33%" height="23">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="7%" nowrap height="23"><b><%=langFR[1]%></b></td>
                                                                                <td width="19%" height="23">
                                                                                    <select name="preview_type">
                                                                                        <option value="0" <%if (previewType == 0) {%>selected<%}%>><%=langFR[2]%></option>
                                                                                        <option value="1" <%if (previewType == 1) {%>selected<%}%>><%=langFR[3]%></option>
                                                                                    </select>
                                                                                    <input type="button" name="Button" value="GO" onClick="javascript:cmdGO()">
                                                                                </td>
                                                                                <td width="41%" height="23"> 
                                                                                    <div align="center"><b><%=title%></b></div>
                                                                                </td>
                                                                                <td width="33%" height="23">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="7%" nowrap height="23"><b>&nbsp;</b></td>
                                                                                <td width="19%" height="23">&nbsp; </td>
                                                                                <td width="41%" height="23"> 
                                                                                    <div align="center"><b><%=langFR[0]%>&nbsp;<%=period.getName()%></b></div>
                                                                                </td>
                                                                                <td width="33%" height="23">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3"></td>
                                                                            </tr>
                                                                        </table>
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td class="tablehdr"><%=langFR[4]%></td>
                                                                                <td class="tablehdr"><%=langFR[5]%></td>
                                                                                <td class="tablehdr"><%=langFR[6]%><br><%=getIndoDate(dtx)%></td>
                                                                                <td class="tablehdr"><%=langFR[6]%><br><%=getIndoDate(reportDate)%></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="3"> 
                                                                                    <div align="center"><b>1</b></div>
                                                                                </td>
                                                                                <td width="33%" height="3"> 
                                                                                    <div align="center"><b>2</b></div>
                                                                                </td>
                                                                                <td width="15%" height="3"> 
                                                                                    <div align="center"><b>3</b></div>
                                                                                </td>
                                                                                <td width="17%" height="3"> 
                                                                                    <div align="center"><b>4</b></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="22"></td>
                                                                                <td width="33%" height="22"><b><font size="2" color="#CC3300">PENDAPATAN</font></b></td>
                                                                                <td width="15%" height="22"> 
                                                                                    <div align="right"><font color="#CC3300" size="2"></font></div>
                                                                                </td>
                                                                                <td width="17%" height="22"> 
                                                                                    <div align="right"><font color="#CC3300" size="2"></font></div>
                                                                                </td>
                                                                            </tr>
                                                                            <!--tr> 
                                    <td width="2%" height="1" bgcolor="#609836"></td>
                                    <td width="33%" height="1" bgcolor="#609836"></td>
                                    <td width="15%" height="1" bgcolor="#609836"></td>
                                    <td width="17%" height="1" bgcolor="#609836"></td>
                                  </tr-->
                                  <%

            double totalAmountLY = 0;
            double totalBudgetTY = 0;
            double totalAmountTY = 0;
            int seq = 0;

            for (int x = 0; x < I_Project.accGroup.length; x++) {

                Vector tempCoas = new Vector();

                if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_REVENUE) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_REVENUE) //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EQUITY)
                        ) {
                    tempCoas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
                }

                System.out.println("LANG_ID : " + LANG_ID);
                System.out.println("x : " + x);

                if (tempCoas != null && tempCoas.size() > 0) {

                    for (int i = 0; i < tempCoas.size(); i++) {

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


                        double amountLY = 0;
                        double budgetTY = 0;
                        double amountTY = 0;


                        amountLY = DbCoaOpeningBalance.getOpeningBalance(lastPeriod, coa.getOID());
                        amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getOID());

                        //this year
                        amountTY = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                        amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getOID());

                        //total
                        if (!isBold) {
                            totalAmountLY = totalAmountLY + amountLY;
                            totalBudgetTY = totalBudgetTY + budgetTY;
                            totalAmountTY = totalAmountTY + amountTY;
                        }

                        boolean isOpen = false;
                        if (previewType == 0) {
                            isOpen = true;
                        } else if (amountLY != 0 || amountTY != 0) {
                            isOpen = true;
                        }

                        if (isOpen) {

                            seq = seq + 1;

                                                                                          %>
                                                                            <tr> 
                                                                                <td width="2%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"> 
                                                                                <%=seq%> </td>
                                                                                <td width="33%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
                                                                                <td width="15%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"> 
                                                                                    <div align="right"><%=getFormated(amountLY, isBold)%></div>
                                                                                </td>
                                                                                <td width="17%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"> 
                                                                                    <div align="right"><%=getFormated(amountTY, isBold)%></div>
                                                                                </td>
                                                                            </tr>
                                                                            <%}
                    }
                }
            }%>
                                                                            <tr> 
                                                                                <td width="2%" height="1" bgcolor="#609836"></td>
                                                                                <td width="33%" height="1" bgcolor="#609836"></td>
                                                                                <td width="15%" height="1" bgcolor="#609836"></td>
                                                                                <td width="17%" height="1" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="22"></td>
                                                                                <td width="33%" height="22"><b><font color="#CC3300" size="2">TOTAL 
                                                                                PENDAPATAN</font></b></td>
                                                                                <td width="15%" height="22"> 
                                                                                    <div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountLY, false)%></b></font></div>
                                                                                </td>
                                                                                <td width="17%" height="22"> 
                                                                                    <div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountTY, false)%></b></font></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="1" bgcolor="#609836"></td>
                                                                                <td width="33%" height="1" bgcolor="#609836"></td>
                                                                                <td width="15%" height="1" bgcolor="#609836"></td>
                                                                                <td width="17%" height="1" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="22"></td>
                                                                                <td width="33%" height="22"></td>
                                                                                <td width="15%" height="22"></td>
                                                                                <td width="17%" height="22"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="22"></td>
                                                                                <td width="33%" height="22"><b><font color="#CC3300" size="2">BIAYA</font></b></td>
                                                                                <td width="15%" height="22"> 
                                                                                    <div align="right"><font color="#CC3300" size="2"></font></div>
                                                                                </td>
                                                                                <td width="17%" height="22"> 
                                                                                    <div align="right"><font color="#CC3300" size="2"></font></div>
                                                                                </td>
                                                                            </tr>
                                                                            <%

            double totalAmountLYEx = 0;
            //totalBudgetTY = 0;
            double totalAmountTYEx = 0;
            seq = 0;

            for (int x = 0; x < I_Project.accGroup.length; x++) {

                Vector tempCoas = new Vector();

                if (//I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LIQUID_ASSET)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_FIXED_ASSET)
                        //|| I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)
                        I_Project.accGroup[x].equals(I_Project.ACC_GROUP_COST_OF_SALES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EXPENSE) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                    tempCoas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
                }

                //System.out.println("LANG_ID : "+LANG_ID);
                //System.out.println("x : "+x);

                if (tempCoas != null && tempCoas.size() > 0) {

                    for (int i = 0; i < tempCoas.size(); i++) {

                        Coa coa = (Coa) tempCoas.get(i);

                        boolean isBold = (coa.getStatus().equals("HEADER")) ? true : false;

                        //int count = DbRptFormatDetail.getCount(DbRptFormatDetail.colNames[DbRptFormatDetail.COL_REF_ID]+"="+rpd.getOID());
                        //int countCoas = DbRptFormatDetailCoa.getCount(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID]+"="+rpd.getOID());

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

                        double amountLY = 0;
                        double budgetTY = 0;
                        double amountTY = 0;

                        //jika laba tahun berjalan, hitungnya beda
                        if (coaLabaBerjalan.getCode().equals(coa.getCode())) {
                            amountLY = DbCoaOpeningBalance.getOpeningBalance(lastPeriod, coa.getOID());
                            amountLY = amountLY + DbGlDetail.getTotalIncomeInPeriod(lastPeriod.getOID()) - DbGlDetail.getTotalExpenseInPeriod(lastPeriod.getOID());
                            //amountLY = DbGlDetail.getRealisasiLastYear(coa.getOID(), period);	

                            //this year
                            //amountTY = DbGlDetail.getRealisasiCurrentYear(coa.getOID(), period);	
                            amountTY = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                            amountTY = amountTY + DbGlDetail.getTotalIncomeInPeriod(period.getOID()) - DbGlDetail.getTotalExpenseInPeriod(period.getOID());
                        //}
                        } else {
                            amountLY = DbCoaOpeningBalance.getOpeningBalance(lastPeriod, coa.getOID());
                            amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getOID());
                            //amountLY = DbGlDetail.getRealisasiLastYear(coa.getOID(), period);	

                            //this year
                            //amountTY = DbGlDetail.getRealisasiCurrentYear(coa.getOID(), period);	
                            amountTY = DbCoaOpeningBalance.getOpeningBalance(period, coa.getOID());
                            amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getOID());
                        //}	
                        }

                        if (!isBold) {
                            totalAmountLYEx = totalAmountLYEx + amountLY;
                            // totalBudgetTY = totalBudgetTY + budgetTY;
                            totalAmountTYEx = totalAmountTYEx + amountTY;
                        }

                        boolean isOpen = false;
                        if (previewType == 0) {
                            isOpen = true;
                        } else {
                            if (amountLY != 0 || amountTY != 0) {
                                isOpen = true;
                            } else {
                                if (coa.getCode().equals(indukLaba1) || coa.getCode().equals(indukLaba2) || coa.getCode().equals(indukLaba3) || coa.getCode().equals(indukLaba4)) {
                                    isOpen = true;
                                }
                            }
                        }

                        if (isOpen) {

                            seq = seq + 1;

                                                                            %>
                                                                            <tr> 
                                                                                <td width="2%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"> 
                                                                                <%=seq%> </td>
                                                                                <td width="33%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
                                                                                <td width="15%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"> 
                                                                                    <div align="right"><%=getFormated(amountLY, isBold)%></div>
                                                                                </td>
                                                                                <td width="17%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"> 
                                                                                    <div align="right"><%=getFormated(amountTY, isBold)%></div>
                                                                                </td>
                                                                            </tr>
                                                                            <%}
                    }
                }
            }%>
                                                                            <tr> 
                                                                                <td width="2%" height="1" bgcolor="#609836"></td>
                                                                                <td width="33%" height="1" bgcolor="#609836"></td>
                                                                                <td width="15%" height="1" bgcolor="#609836"></td>
                                                                                <td width="17%" height="1" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="22"></td>
                                                                                <td width="33%" height="22"><b><font color="#CC3300" size="2">TOTAL 
                                                                                BIAYA</font></b></td>
                                                                                <td width="15%" height="22"> 
                                                                                    <div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountLYEx, false)%></b></font></div>
                                                                                </td>
                                                                                <td width="17%" height="22"> 
                                                                                    <div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountTYEx, false)%></b></font></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="1" bgcolor="#609836"></td>
                                                                                <td width="33%" height="1" bgcolor="#609836"></td>
                                                                                <td width="15%" height="1" bgcolor="#609836"></td>
                                                                                <td width="17%" height="1" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%"><font size="2" color="#CC3300"></font></td>
                                                                                <td width="33%"><b><font color="#CC3300" size="2">LABA</font></b></td>
                                                                                <td width="15%"> 
                                                                                    <div align="right"><font size="2" color="#CC3300"><b><%=getFormated(totalAmountLY - totalAmountLYEx, false)%></b></font></div>
                                                                                </td>
                                                                                <td width="17%"> 
                                                                                    <div align="right"><font size="2" color="#CC3300"><b><%=getFormated(totalAmountTY - totalAmountTYEx, false)%></b></font></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="3" bgcolor="#609836"></td>
                                                                                <td width="33%" height="3" bgcolor="#609836"></td>
                                                                                <td width="15%" height="3" bgcolor="#609836"></td>
                                                                                <td width="17%" height="3" bgcolor="#609836"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%">&nbsp;</td>
                                                                                <td width="33%">&nbsp;</td>
                                                                                <td width="15%">&nbsp;</td>
                                                                                <td width="17%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%">&nbsp;</td>
                                                                                <td width="33%">&nbsp;</td>
                                                                                <td width="15%">&nbsp;</td>
                                                                                <td width="17%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="7">
                                                                                    <%
            out.print("<a href=\"../freport/income_penjelasan_print_priview.jsp?preview_type=" + previewType + "&rpt_format_id=" + oidRptFormat + "&period_id=" + periodId + "\"  onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
                                                                                    %>
                                                                                </td>
                                                                            </tr>
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
