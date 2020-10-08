
<%-- 
    Document   : profitlossssegmentmtd_v03
    Created on : Jul 15, 2013, 10:54:03 AM
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
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_PROFIT_LOSS, AppMenu.PRIV_DELETE);
%>
<%!
    public String switchLevel(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 3:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 4:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
            case 5:
                str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
        }
        return str;
    }

    public String switchLevel1(int level) {
        String str = "";
        switch (level) {
            case 1:
                break;
            case 2:
                str = "       ";
                break;
            case 3:
                str = "              ";
                break;
            case 4:
                str = "                     ";
                break;
            case 5:
                str = "                            ";
                break;
        }
        return str;
    }

    public String strDisplay(double amount, String coaStatus) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###.##");
        } else if (amount == 0) {
            displayStr = "";
        }
        if (coaStatus.equals("HEADER")) {
            displayStr = "";
        }
        return displayStr;
    }

%>
<%
            if (session.getValue("PROFIT_MULTIPLE_MTD") != null) {
                session.removeValue("PROFIT_MULTIPLE_MTD");
            }

            if (session.getValue("PERIODE_MULTIPLE_MTD") != null) {
                session.removeValue("PERIODE_MULTIPLE_MTD");
            }

            if (session.getValue("SEGMENT1MTDIDMULTIPLE") != null) {
                session.removeValue("SEGMENT1MTDIDMULTIPLE");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            int valShowList = JSPRequestValue.requestInt(request, "showlist");
            long periodeId = JSPRequestValue.requestLong(request, "periode_id");
            boolean isGereja = DbSystemProperty.getModSysPropGereja();
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            String whereMd = "";
            String oidMd = "";
            long segment1Id = 0;

            if (vSeg != null && vSeg.size() > 0 && iJSPCommand != JSPCommand.NONE) {
                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {
                    int pg = iSeg + 1;
                    long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");
                    oidMd = oidMd + ";" + segment_id;

                    if (whereMd.length() > 0) {
                        whereMd = whereMd + " and ";
                    }
                    if (segment_id != 0) {
                        if (iSeg == 0) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                            segment1Id = segment_id;
                        } else if (iSeg == 1) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                        } else if (iSeg == 2) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                        } else if (iSeg == 3) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                        } else if (iSeg == 4) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                        } else if (iSeg == 5) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                        } else if (iSeg == 6) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                        } else if (iSeg == 7) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                        } else if (iSeg == 8) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                        } else if (iSeg == 9) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                        } else if (iSeg == 10) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                        } else if (iSeg == 11) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                        } else if (iSeg == 12) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                        } else if (iSeg == 13) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                        } else if (iSeg == 14) {
                            whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                        }
                    }
                }
            }

            if (valShowList == 0) {
                valShowList = 1;
            }

            Vector listCoa = new Vector(1, 1);
            Coa coa = new Coa();

            listCoa = DbCoa.list(0, 0, "", DbCoa.colNames[DbCoa.COL_CODE]);

            String strTotal = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            String strTotal1 = "       ";
            String cssString = "tablecell1";
            Vector listReport = new Vector();
            SesReportBs sesReport = new SesReportBs();
            Vector vSesDep = new Vector();

            Periode period = new Periode();
            try {
                period = DbPeriode.fetchExc(periodeId);
            } catch (Exception e) {
            }


            Date dt = new Date();
            dt.setDate(1);
            dt.setMonth(0);
            int year = dt.getYear();

            int yearselect = year;
            if (iJSPCommand != JSPCommand.NONE) {
                yearselect = JSPRequestValue.requestInt(request, "year");
            }

            dt.setYear(yearselect);
            Date endDate = (Date) dt.clone();
            endDate.setDate(31);
            endDate.setMonth(11);

            String where = "";
            if (period.getOID() != 0) {
                where = " to_days(start_date) <= to_days('" + JSPFormater.formatDate(period.getStartDate(), "yyyy-MM-dd") + "') ";
            }

            Vector temp = DbPeriode.list(0, 3, where, "start_date desc");

            /*** LANG ***/
            String[] langFR = {"Show List", "Account With Transaction", "All", "Year", "PROFIT & LOSS STATEMENT", "MULTIPLE PERIODS", //0-5
                "Description", "Total", "Net Income"}; //6-8
            String[] langNav = {"Financial Report", "Profit & Loss Multiple Period", "Previous Period", "Period", "Klik GO button to searching the data"};

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Akun Dengan Transaksi", "Semua", "Tahun", "LAPORAN LABA RUGI", "MULTI PERIODE", //0-5
                    "Keterangan", "Total", "Pendapatan Bersih"}; //6-8
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Laba Rugi Multi Periode", "Periode Sebelumnya", "Periode", "Klik tombol GO untuk melakukan pencarian"};
                langNav = navID;
            }


            double totalRev[];
            totalRev = new double[12];

            totalRev[0] = 0;
            totalRev[1] = 0;
            totalRev[2] = 0;
            totalRev[3] = 0;
            totalRev[4] = 0;
            totalRev[5] = 0;
            totalRev[6] = 0;
            totalRev[7] = 0;
            totalRev[8] = 0;
            totalRev[9] = 0;
            totalRev[10] = 0;
            totalRev[11] = 0;

            double totalCOS[];
            totalCOS = new double[12];

            totalCOS[0] = 0;
            totalCOS[1] = 0;
            totalCOS[2] = 0;
            totalCOS[3] = 0;
            totalCOS[4] = 0;
            totalCOS[5] = 0;
            totalCOS[6] = 0;
            totalCOS[7] = 0;
            totalCOS[8] = 0;
            totalCOS[9] = 0;
            totalCOS[10] = 0;
            totalCOS[11] = 0;

            double totalExp[];
            totalExp = new double[12];

            totalExp[0] = 0;
            totalExp[1] = 0;
            totalExp[2] = 0;
            totalExp[3] = 0;
            totalExp[4] = 0;
            totalExp[5] = 0;
            totalExp[6] = 0;
            totalExp[7] = 0;
            totalExp[8] = 0;
            totalExp[9] = 0;
            totalExp[10] = 0;
            totalExp[11] = 0;

            double totalORev[];
            totalORev = new double[12];

            totalORev[0] = 0;
            totalORev[1] = 0;
            totalORev[2] = 0;
            totalORev[3] = 0;
            totalORev[4] = 0;
            totalORev[5] = 0;
            totalORev[6] = 0;
            totalORev[7] = 0;
            totalORev[8] = 0;
            totalORev[9] = 0;
            totalORev[10] = 0;
            totalORev[11] = 0;

            double totalOExp[];
            totalOExp = new double[12];

            totalOExp[0] = 0;
            totalOExp[1] = 0;
            totalOExp[2] = 0;
            totalOExp[3] = 0;
            totalOExp[4] = 0;
            totalOExp[5] = 0;
            totalOExp[6] = 0;
            totalOExp[7] = 0;
            totalOExp[8] = 0;
            totalOExp[9] = 0;
            totalOExp[10] = 0;
            totalOExp[11] = 0;

            double totRev = 0;
            double totCOS = 0;
            double totExp = 0;
            double totORev = 0;
            double totOExp = 0;

            session.putValue("PERIODMTDIDMULTIPLE", "" + yearselect);

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
            
            function cmdGO(){
                document.frmcoa.action="profitlosssegmentmtd_v03.jsp";
                document.frmcoa.command.value="<%=JSPCommand.LIST%>";
                document.frmcoa.submit();
            }
                
                function cmdPrintJournalXLS(){	 
                    window.open("<%=printroot%>.report.RptProfitLossMultipleMTDXLS?oid=<%=appSessUser.getLoginId()%>&year=<%=yearselect%>");
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
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_coa_id" value="<%=oidCoa%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table border="0" width="900" cellpadding="1" cellspacing="1">                                                                                                                                        
                                                                            <tr>                                                                                                                                            
                                                                                <td colspan="3">                   
                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="320">                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" colspan="3">    
                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="0" cellpadding="2">
                                                                                                <tr align="left" valign="top"> 
                                                                                                    <td width="5"></td>
                                                                                                    <td height="10" valign="middle" colspan="3"></td>
                                                                                                    <td width="5"></td>
                                                                                                </tr>             
                                                                                                <tr align="left" valign="top"> 
                                                                                                    <td >&nbsp;</td>
                                                                                                    <td height="8" valign="middle" colspan="3">
                                                                                                        <table width="280" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr align="left" valign="middle">
                                                                                                                <td width="100"><%=langFR[0]%></td>
                                                                                                                <td width="180" colspan="0"> 
                                                                                                                    <select name="showlist">
                                                                                                                        <option value="1" <%if (valShowList == 1) {%>selected<%}%>><%=langFR[1]%></option>
                                                                                                                        <option value="2" <%if (valShowList == 2) {%>selected<%}%>><%=langFR[2]%></option>
                                                                                                                    </select>
                                                                                                                </td>                                                              
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                    <td >&nbsp;</td>
                                                                                                </tr>
                                                                                                <%if (isGereja || (vSeg != null && vSeg.size() > 0)) {%>
                                                                                                <tr align="left" valign="top"> 
                                                                                                    <td >&nbsp;</td>
                                                                                                    <td height="8" valign="middle" colspan="3">
                                                                                                        <table width="280" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <%
    if (vSeg != null && vSeg.size() > 0) {
        User usr = new User();
        try {
            usr = DbUser.fetch(appSessUser.getUserOID());
        } catch (Exception e) {
        }

        for (int xs = 0; xs < vSeg.size(); xs++) {
            Segment oSegment = (Segment) vSeg.get(xs);
            int pgs = xs + 1;
            long seg_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pgs + "_ID");
                                                                                                            %>
                                                                                                            <tr>
                                                                                                                <td width="100"><%=oSegment.getName()%></td>
                                                                                                                <td width="180">
                                                                                                                    <%
                                                                                                                    String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + oSegment.getOID();
                                                                                                                    switch (xs + 1) {
                                                                                                                        case 1:
                                                                                                                            if (usr.getSegment1Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment1Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 2:
                                                                                                                            if (usr.getSegment2Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment2Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 3:
                                                                                                                            if (usr.getSegment3Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment3Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 4:
                                                                                                                            if (usr.getSegment4Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment4Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 5:
                                                                                                                            if (usr.getSegment5Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment5Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 6:
                                                                                                                            if (usr.getSegment6Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment6Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 7:
                                                                                                                            if (usr.getSegment7Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment7Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 8:
                                                                                                                            if (usr.getSegment8Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment8Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 9:
                                                                                                                            if (usr.getSegment9Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment9Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 10:
                                                                                                                            if (usr.getSegment10Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment10Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 11:
                                                                                                                            if (usr.getSegment11Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment11Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 12:
                                                                                                                            if (usr.getSegment12Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment12Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 13:
                                                                                                                            if (usr.getSegment13Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment13Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 14:
                                                                                                                            if (usr.getSegment14Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment14Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 15:
                                                                                                                            if (usr.getSegment15Id() != 0) {
                                                                                                                                wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment15Id();
                                                                                                                            }
                                                                                                                            break;
                                                                                                                    }
                                                                                                                    Vector segDet = DbSegmentDetail.list(0, 0, wh, DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
                                                                                                                    %>
                                                                                                                    <select name="JSP_SEGMENT<%=xs + 1%>_ID" >
                                                                                                                        <option value="0" <%if (0 == seg_id) {%>selected<%}%>>- All Location - </option>
                                                                                                                        <%
                                                                                                                    for (int i = 0; i < segDet.size(); i++) {
                                                                                                                        SegmentDetail ap = (SegmentDetail) segDet.get(i);
                                                                                                                        %>
                                                                                                                        <option value="<%=ap.getOID()%>" <%if (ap.getOID() == seg_id) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                                                        <%
                                                                                                                    }
                                                                                                                        %>
                                                                                                                    </select>                                                                                    
                                                                                                                </td>
                                                                                                                <td></td>
                                                                                                                <td></td>
                                                                                                            </tr> 
                                                                                                            <%
        }
    }
                                                                                                            %> 
                                                                                                        </table>
                                                                                                    </td>
                                                                                                    <td >&nbsp;</td>
                                                                                                </tr>
                                                                                                <%}%>
                                                                                                <%
            Vector vPeriode = new Vector();
            vPeriode = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc ");
                                                                                                %>
                                                                                                <tr align="left" valign="top"> 
                                                                                                    <td >&nbsp;</td>
                                                                                                    <td height="8" valign="middle" colspan="3">
                                                                                                        <table width="280" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr align="left" valign="middle">
                                                                                                                <td width="100"><%=langFR[3]%></td>
                                                                                                                <td width="180" colspan="0"> 
                                                                                                                    <select name="periode_id">
                                                                                                                        <%
            if (vPeriode != null && vPeriode.size() > 0) {
                for (int i = 0; i < vPeriode.size(); i++) {
                    Periode p = (Periode) vPeriode.get(i);
                                                                                                                        %>
                                                                                                                        <option value="<%=p.getOID()%>" <%if (p.getOID() == periodeId) {%>selected<%}%>><%=p.getName()%></option>
                                                                                                                        <%
                }
            }%>                                                                                                    
                                                                                                                    </select>
                                                                                                                </td>                                                              
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                    <td >&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr align="left" valign="top"> 
                                                                                                    <td >&nbsp;</td>
                                                                                                    <td height="8" valign="middle" colspan="3">
                                                                                                        <table width="280" border="0" cellspacing="0" cellpadding="0">
                                                                                                            <tr align="left" valign="middle">
                                                                                                                <td width="100">&nbsp;</td>
                                                                                                                <td width="180" colspan="0"> 
                                                                                                                    <input type="button" name="Button" value="GO" onClick="javascript:cmdGO()">
                                                                                                                </td>                                                              
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                    <td >&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr align="left" valign="top"> 
                                                                                                    <td width="5"></td>
                                                                                                    <td height="10" valign="middle" colspan="3"></td>
                                                                                                    <td width="5"></td>
                                                                                                </tr>  
                                                                                            </table>
                                                                                            <td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" colspan="3"></td>
                                                                            </tr>   
                                                                            <%if (iJSPCommand == JSPCommand.LIST) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="30" valign="middle" colspan="3"></td>
                                                                            </tr>  
                                                                            <tr align="center" valign="top">
                                                                                <td height="20" valign="middle" colspan="3"> 
                                                                                    <font face="arial" size="4"><b><%=sysCompany.getName().toUpperCase()%></b></font>
                                                                                </td>
                                                                            </tr> 
                                                                            <tr align="center" valign="top">
                                                                                <td height="20" valign="middle" colspan="3"> 
                                                                                    <font face="arial" size="4"><b>PROFIT & LOSS STATEMENT</b></font>
                                                                                </td>
                                                                            </tr>                          
                                                                            <tr align="center" valign="top">
                                                                                <td height="20" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                                                                        <tr> 
                                                                                            <%if (segment1Id == 0) {%>
                                                                                            <td height="20" valign="middle" align="center"><font face="arial" size="4"><b>KONSOLIDASI</b></font></td>
                                                                                            <%} else {
    SegmentDetail sdx = new SegmentDetail();
    try {
        sdx = DbSegmentDetail.fetchExc(segment1Id);
    } catch (Exception e) {
    }
                                                                                            %>
                                                                                            <td height="20" valign="middle" align="center"><font face="arial" size="4"><b><%=sdx.getName().toUpperCase()%></b></font></td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                          
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" colspan="3"></td>
                                                                            </tr>                                  
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                                                                        <tr> 
                                                                                            <td class="tablehdr" height="22"><%=langFR[6]%></td>
                                                                                            <%
    int yearx = 0;
    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
        Periode per = (Periode) temp.get(ix);
        if (ix == 0) {
            yearx = per.getEndDate().getYear() + 1900;
        }
                                                                                            %>
                                                                                            <td class="tablehdr" width="100"><%=per.getName()%></td>
                                                                                            <%}%>
                                                                                            <td width="100" class="tablehdr" height="22">Year To Date</td>
                                                                                        </tr>
                                                                                        <!--level ACC_GROUP_REVENUE-->
                                                                                 <%

    double groupRev = DbCoa.getIsCoaBalanceByGroupMTD(I_Project.ACC_GROUP_REVENUE, temp, "CD", whereMd);
    if (groupRev != 0 || valShowList != 1) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_REVENUE);
        sesReport.setFont(1);
        vSesDep = new Vector();

                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_REVENUE%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());
                double amountBalance = DbCoa.getCoaBalanceMTDCD(coa.getOID(), temp, whereMd);
                double amountHeader = DbCoa.getIsCoaBalanceByHeaderMTD(coa.getOID(), "CD", whereMd, temp);

                if (valShowList == 1) {
                    if ((coa.getStatus().equals("HEADER") && amountHeader != 0) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                        sesReport = new SesReportBs();
                        sesReport.setType(coa.getStatus());
                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                        vSesDep = new Vector();
                        sesReport.setDepartment(vSesDep);
                        double totAmount = 0;
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode p = (Periode) temp.get(ix);
                                                                                                                double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, p, "CD");

                                                                                                                if ((p.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                    totAmount = totAmount + amount;
                                                                                                                }
                                                                                                                vSesDep.add("" + amount);
                                                                                                                totalRev[ix] = totalRev[ix] + amount;
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td> 
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(totAmount, coa.getStatus())%></div></td>
                                                                                                        <%totRev = totRev + totAmount;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(totAmount);
                                                                                                            sesReport.setStrAmount("" + totAmount);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            double totAmount = 0;

                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "CD");

                                                                                            if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                totAmount = totAmount + amount;
                                                                                                vSesDep.add("" + amount);
                                                                                            }

                                                                                            totalRev[ix] = totalRev[ix] + amount;
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>	
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(totAmount, coa.getStatus())%></div></td>
                                                                                                        <%totRev = totRev + totAmount;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(totAmount);
                                                                                                            sesReport.setStrAmount("" + totAmount);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (groupRev != 0 || valShowList != 1) {	//add Group Footer                                                                                                
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_REVENUE);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_REVENUE%></b></span></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                vSesDep.add("" + totalRev[ix]);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totalRev[ix], coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totRev, coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            sesReport.setAmount(totRev);
            sesReport.setStrAmount("" + totRev);
            sesReport.setDepartment(vSesDep);
            listReport.add(sesReport);
        }
    }
    if (groupRev != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>     
                                                                                        <!--level 2-->
                                                                                        <!--level ACC_GROUP_EXPENSE-->
                                                                                 <%
    double groupCOS = DbCoa.getIsCoaBalanceByGroupMTD(I_Project.ACC_GROUP_COST_OF_SALES, temp, "DC", whereMd);
    if (groupCOS != 0 || valShowList != 1) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_COST_OF_SALES);
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_COST_OF_SALES%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>
                                                                                        <%}%>									
                                                                                        <%
    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountBalance = DbCoa.getCoaBalanceMTD2(coa.getOID(), temp, whereMd);
                double amountHeader = DbCoa.getIsCoaBalanceByHeaderMTD(coa.getOID(), "DC", whereMd, temp);

                if (valShowList == 1) {

                    if ((coa.getStatus().equals("HEADER") && amountHeader != 0) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                        sesReport = new SesReportBs();
                        sesReport.setType(coa.getStatus());
                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                        double grandTotal = 0;
                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                        vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "DC");
                                                                                                                vSesDep.add("" + amount);
                                                                                                                if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                    grandTotal = grandTotal + amount;
                                                                                                                }
                                                                                                                totalCOS[ix] = totalCOS[ix] + amount;

                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(grandTotal, coa.getStatus())%></div></td>
                                                                                                        <%totCOS = totCOS + grandTotal;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(grandTotal);
                                                                                                            sesReport.setStrAmount("" + grandTotal);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            double grandTotal = 0;
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "DC");
                                                                                            if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                grandTotal = grandTotal + amount;
                                                                                            }
                                                                                            totalCOS[ix] = totalCOS[ix] + amount;
                                                                                            vSesDep.add("" + amount);

                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(grandTotal, coa.getStatus())%></div></td>
                                                                                                        <%totCOS = totCOS + grandTotal;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(grandTotal);
                                                                                                            sesReport.setStrAmount("" + grandTotal);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }			//add footer level

                                                                                            if (groupCOS != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_COST_OF_SALES);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                sesReport.setDepartment(vSesDep);

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_COST_OF_SALES%></b></span></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                vSesDep.add("" + totalCOS[ix]);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>                                                                                                        
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totalCOS[ix], coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totCOS, coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            sesReport.setAmount(totCOS);
            sesReport.setStrAmount("" + totCOS);
            listReport.add(sesReport);

        }
    }
    if (groupCOS != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <!--level 3-->
                                                                                        <!--level ACC_GROUP_EXPENSE-->
                                                                                 <%
    double groupExp = DbCoa.getIsCoaBalanceByGroupMTD(I_Project.ACC_GROUP_EXPENSE, temp, "DC", whereMd);

    if (groupExp != 0 || valShowList != 1) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_EXPENSE);
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_EXPENSE%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>	
                                                                                        <%}%>								
                                                                                        <%
    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountHeader = DbCoa.getIsCoaBalanceByHeaderMTD(coa.getOID(), "DC", whereMd, temp);
                double amountBalance = DbCoa.getCoaBalanceMTD2(coa.getOID(), temp, whereMd);

                if (valShowList == 1) {
                    if ((coa.getStatus().equals("HEADER") && amountHeader != 0) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                        sesReport = new SesReportBs();
                        sesReport.setType(coa.getStatus());
                        double grandTotal = 0;
                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                        vSesDep = new Vector();
                        sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "DC");
                                                                                                                vSesDep.add("" + amount);
                                                                                                                if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                    grandTotal = grandTotal + amount;
                                                                                                                }
                                                                                                                totalExp[ix] = totalExp[ix] + amount;
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(grandTotal, coa.getStatus())%></div></td>
                                                                                                        <%totExp = totExp + grandTotal;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(grandTotal);
                                                                                                            sesReport.setStrAmount("" + grandTotal);
                                                                                                            listReport.add(sesReport);

                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            double grandTotal = 0;
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            sesReport.setDepartment(vSesDep);

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "DC");
                                                                                            if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                grandTotal = grandTotal + amount;
                                                                                            }
                                                                                            vSesDep.add("" + amount);
                                                                                            totalExp[ix] = totalExp[ix] + amount;
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>	
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(grandTotal, coa.getStatus())%></div></td>
                                                                                                        <%totExp = totExp + grandTotal;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(grandTotal);
                                                                                                            sesReport.setStrAmount("" + grandTotal);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (groupExp != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_EXPENSE);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                sesReport.setDepartment(vSesDep);

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_EXPENSE%></b></span></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                vSesDep.add("" + totalExp[ix]);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totalExp[ix], coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totExp, coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            sesReport.setAmount(totExp);
            sesReport.setStrAmount("" + totExp);
            listReport.add(sesReport);
        }
    }
    if (groupExp != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <!--level 4-->
                                                                                        <!--level ACC_GROUP_OTHER_REVENUE-->
                                                                                 <%

    double groupORev = DbCoa.getIsCoaBalanceByGroupMTD(I_Project.ACC_GROUP_OTHER_REVENUE, temp, "CD", whereMd);
    if (groupORev != 0 || valShowList != 1) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_OTHER_REVENUE);
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_REVENUE%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}%>										  									  
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>									
                                                                                        <%}%>
                                                                                        <%
    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        for (int i = 0; i < listCoa.size(); i++) {

            coa = (Coa) listCoa.get(i);

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountBalance = DbCoa.getCoaBalanceMTD2(coa.getOID(), temp, whereMd);
                double amountHeader = DbCoa.getIsCoaBalanceByHeaderMTD(coa.getOID(), "CD", whereMd, temp);

                if (valShowList == 1) {
                    if ((coa.getStatus().equals("HEADER") && amountHeader != 0) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                        sesReport = new SesReportBs();
                        sesReport.setType(coa.getStatus());
                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                        double grandTotal = 0;
                        vSesDep = new Vector();
                        sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "CD");
                                                                                                                vSesDep.add("" + amount);
                                                                                                                if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                    grandTotal = grandTotal + amount;
                                                                                                                }
                                                                                                                totalORev[ix] = totalORev[ix] + amount;
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>	
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(grandTotal, coa.getStatus())%></div></td>
                                                                                                        <%totORev = totORev + grandTotal;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(grandTotal);
                                                                                                            sesReport.setStrAmount("" + grandTotal);
                                                                                                            listReport.add(sesReport);

                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            double grandTotal = 0;
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "CD");
                                                                                            if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                grandTotal = grandTotal + amount;
                                                                                            }
                                                                                            vSesDep.add("" + amount);
                                                                                            totalORev[ix] = totalORev[ix] + amount;
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>		
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(grandTotal, coa.getStatus())%></div></td>
                                                                                                        <%totORev = totORev + grandTotal;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(grandTotal);
                                                                                                            sesReport.setStrAmount("" + grandTotal);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (groupORev != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_OTHER_REVENUE);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_OTHER_REVENUE%></b></span></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                vSesDep.add("" + totalORev[ix]);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totalORev[ix], coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totORev, coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            sesReport.setAmount(totORev);
            sesReport.setStrAmount("" + totORev);
            listReport.add(sesReport);
        }
    }
    if (groupORev != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <!--level 5-->
                                                                                        <!--level ACC_GROUP_OTHER_EXPENSE-->
                                                                                 <%
    double groupOExp = DbCoa.getIsCoaBalanceByGroupMTD(I_Project.ACC_GROUP_OTHER_EXPENSE, temp, "DC", whereMd);
    if (groupOExp != 0 || valShowList != 1) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_OTHER_EXPENSE);
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_EXPENSE%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>	
                                                                                        <%}%>								
                                                                                        <%
    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountBalance = DbCoa.getCoaBalanceMTD2(coa.getOID(), temp, whereMd);
                double amountHeader = DbCoa.getIsCoaBalanceByHeaderMTD(coa.getOID(), "DC", whereMd, temp);

                if (valShowList == 1) {
                    if ((coa.getStatus().equals("HEADER") && amountHeader != 0) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                        sesReport = new SesReportBs();
                        sesReport.setType(coa.getStatus());
                        double grandTotal = 0;
                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());

                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                        vSesDep = new Vector();
                        sesReport.setDepartment(vSesDep);

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "DC");
                                                                                                                if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                    grandTotal = grandTotal + amount;
                                                                                                                }
                                                                                                                vSesDep.add("" + amount);
                                                                                                                totalOExp[ix] = totalOExp[ix] + amount;
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(grandTotal, coa.getStatus())%></div></td>
                                                                                                        <%totOExp = totOExp + grandTotal;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(grandTotal);
                                                                                                            sesReport.setStrAmount("" + grandTotal);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amountBalance != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            double grandTotal = 0;
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            double amount = DbCoa.getCoaBalancePNLMTD(coa.getOID(), whereMd, per, "DC");
                                                                                            if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                grandTotal = grandTotal + amount;
                                                                                            }
                                                                                            vSesDep.add("" + amount);
                                                                                            totalOExp[ix] = totalOExp[ix] + amount;
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>	
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(amount, coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(grandTotal, coa.getStatus())%></div></td>
                                                                                                        <%totOExp = totOExp + grandTotal;%>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(grandTotal);
                                                                                                            sesReport.setStrAmount("" + grandTotal);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (groupOExp != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_OTHER_EXPENSE);
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                sesReport.setDepartment(vSesDep);

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_OTHER_EXPENSE%></b></span></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                vSesDep.add("" + totalOExp[ix]);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totalOExp[ix], coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(totOExp, coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

            sesReport.setAmount(totOExp);
            sesReport.setStrAmount("" + totOExp);
            listReport.add(sesReport);
        }
    }

    if (groupOExp != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>										  									  										  
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>                                                                                        
                                                                                        <%
    double gTotal = totRev - totCOS - totExp + totORev - totOExp;
    sesReport = new SesReportBs();
    sesReport.setType("Last Level");
    sesReport.setDescription("Pendapatan Bersih");
    sesReport.setAmount(gTotal);
    sesReport.setStrAmount("" + (gTotal));
    sesReport.setFont(1);
    vSesDep = new Vector();
    sesReport.setDepartment(vSesDep);

                                                                                        %>										
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%=langFR[8]%></b></span></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
        double grandTotal = totalRev[ix] - totalCOS[ix] - totalExp[ix] + totalORev[ix] - totalOExp[ix];
        vSesDep.add("" + grandTotal);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>                                                                                                        
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(grandTotal, "")%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
    }
    listReport.add(sesReport);
                                                                                            %>										  
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(gTotal, "")%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td colspan="3" height="3" class="tablecell1">&nbsp;<i><%=langNav[4]%></i></td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <%
            session.putValue("PROFIT_MULTIPLE", listReport);
            session.putValue("PERIODE_MULTIPLE_MTD", temp);
            session.putValue("SEGMENT1MTDIDMULTIPLE", "" + segment1Id);
                                                                %>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container"></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container"> 
                                                                        <%if (iJSPCommand == JSPCommand.LIST && listCoa != null && listCoa.size() > 0) {%>
                                                                        <table width="200" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>                                                                                
                                                                                <td width="60"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                                                                <td width="20">&nbsp;</td>
                                                                            </tr>                                                                           
                                                                        </table>
                                                                        <%}%>
                                                                    </td>
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
