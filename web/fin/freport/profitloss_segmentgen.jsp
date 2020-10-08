
<%-- 
    Document   : profitloss_segmentgen
    Created on : Apr 28, 2015, 10:14:29 AM
    Author     : Roy
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

    public String strDisplay(double amount, String coaStatus, int header) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
        } else if (amount >= 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###.##");
        }

        if (header == 1) {
            if (coaStatus.equals("POSTABLE")) {
                displayStr = "";
            }
        } else {
            if (coaStatus.equals("HEADER")) {
                displayStr = "";
            }
        }

        return displayStr;
    }

%>
<%
            if (session.getValue("PROFIT_MULTIPLE_GEN") != null) {
                session.removeValue("PROFIT_MULTIPLE_GEN");
            }

            if (session.getValue("PERIODE_MULTIPLE_MTD_GEN") != null) {
                session.removeValue("PERIODE_MULTIPLE_MTD_GEN");
            }

            if (session.getValue("SEGMENT1MTDIDMULTIPLE_GEN") != null) {
                session.removeValue("SEGMENT1MTDIDMULTIPLE_GEN");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            int valShowList = JSPRequestValue.requestInt(request, "showlist");
            int totalMonth = JSPRequestValue.requestInt(request, "total_month");
            long periodeId = JSPRequestValue.requestLong(request, "periode_id");
            int typeProfit = JSPRequestValue.requestInt(request, "type_profit");
            int onlyHeader = JSPRequestValue.requestInt(request, "only_header");

            if (iJSPCommand == JSPCommand.NONE) {
                totalMonth = 3;
            }

            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            String whereMd = "";
            String oidMd = "";
            long segment1Id = 0;

            long oidGrossOperProfit = 0;
            try {
                oidGrossOperProfit = Long.parseLong(DbSystemProperty.getValueByName("OID_GROSS_OF_OPERATING_PROFITS_MARGIN"));
            } catch (Exception e) {
            }

            if (vSeg != null && vSeg.size() > 0 && iJSPCommand != JSPCommand.NONE) {
                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {
                    int pg = iSeg + 1;
                    long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");
                    oidMd = oidMd + ";" + segment_id;

                    if (segment_id != 0) {
                        if (whereMd.length() > 0) {
                            whereMd = whereMd + " and ";
                        }

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
                yearselect = JSPRequestValue.requestInt(request, "select_year");
            }

            dt.setYear(yearselect);
            Date endDate = (Date) dt.clone();
            endDate.setDate(31);
            endDate.setMonth(11);

            String where = "";
            if (period.getOID() != 0) {
                where = " to_days(start_date) <= to_days('" + JSPFormater.formatDate(period.getStartDate(), "yyyy-MM-dd") + "') ";
            }

            Vector temp = DbPeriode.list(0, totalMonth, where, "start_date desc");

            /*** LANG ***/
            String[] langFR = {"Show List", "Account With Transaction", "All Account", "Year", "PROFIT & LOSS STATEMENT", "MULTIPLE PERIODS", //0-5
                "Description", "Total", "Net Income"}; //6-8
            String[] langNav = {"Financial Report", "Profit & Loss", "Previous Period", "Period", "Klik GO button to searching the data", "Month", "Year", "Searching Parameter"};

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Perkiraan", "Akun Dengan Transaksi", "Semua Akun", "Tahun", "LAPORAN LABA RUGI", "MULTI PERIODE", //0-5
                    "Keterangan", "Total", "Pendapatan Bersih"}; //6-8
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Laba Rugi", "Periode Sebelumnya", "Periode", "Klik tombol GO untuk melakukan pencarian", "Bulan", "Tahun", "Parameter Pencarian"};
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

            double totalNetOp[];
            totalNetOp = new double[12];

            totalNetOp[0] = 0;
            totalNetOp[1] = 0;
            totalNetOp[2] = 0;
            totalNetOp[3] = 0;
            totalNetOp[4] = 0;
            totalNetOp[5] = 0;
            totalNetOp[6] = 0;
            totalNetOp[7] = 0;
            totalNetOp[8] = 0;
            totalNetOp[9] = 0;
            totalNetOp[10] = 0;
            totalNetOp[11] = 0;


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
            double totNetOp = 0;

            double totSubRev = 0;
            double totSubCOS = 0;
            double totSubExp = 0;
            double totSubORev = 0;
            double totSubOExp = 0;
            double totSubNetOp = 0;

            session.putValue("PERIODMTDIDMULTIPLE", "" + yearselect);

            if (iJSPCommand == JSPCommand.LIST) {
                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                    Periode per = (Periode) temp.get(ix);
                    SessGeneratePNL.genPNL(segment1Id, per.getOID());
                }
            }

            String codeMappingCogs = "";
            try {
                codeMappingCogs = DbSystemProperty.getValueByName("MAPPING_CODE_COGS");
            } catch (Exception e) {
            }
            Hashtable mappingCogs = new Hashtable();
            Hashtable strMapping = new Hashtable();
            StringTokenizer strTokenizer = new StringTokenizer(codeMappingCogs, ",");
            try {
                while (strTokenizer.hasMoreTokens()) {
                    String str = strTokenizer.nextToken();
                    StringTokenizer token = new StringTokenizer(str, "=");
                    if (token.hasMoreTokens()) {
                        String split1 = token.nextToken();
                        String split2 = token.nextToken();
                        strMapping.put(split1, split2);
                    }
                }
            } catch (Exception e) {
            }
            
            Hashtable mappingCogsYtd = new Hashtable();

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
                document.all.closecmd.style.display="none";
                document.all.closemsg.style.display="";
                document.frmcoa.action="profitloss_segmentgen.jsp";
                document.frmcoa.command.value="<%=JSPCommand.LIST%>";
                document.frmcoa.submit();
            }
            
            function cmdReloadType(){
                document.frmcoa.action="profitloss_segmentgen.jsp";
                document.frmcoa.command.value="<%=JSPCommand.ASSIGN%>";
                document.frmcoa.submit();
            }
            
            
            function cmdPrintJournalXLS(){	 
                window.open("<%=printroot%>.report.RptProfitLossMultipleMDFGENXLS?oid=<%=appSessUser.getLoginId()%>&year=<%=yearselect%>");
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
                                                                        <table border="0" width="100%" cellpadding="1" cellspacing="1">          
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr>
                                                                                            <td colspan="6" height="10"></td>
                                                                                        </tr>    
                                                                                        <tr>                                                                                                         
                                                                                            <td colspan="6" ><table ><tr><td class="tablehdr"></td><td class="fontarial"><b><i><%=langNav[7]%> :</i></b></td></tr></table></td>
                                                                                        </tr>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td width="120" class="tablecell1">&nbsp;&nbsp;<%=langFR[0]%></td>
                                                                                            <td width="2" class="fontarial">:</td>
                                                                                            <td width="280"> 
                                                                                                <select name="showlist" class="fontarial">
                                                                                                    <option value="1" <%if (valShowList == 1) {%>selected<%}%>><%=langFR[1]%></option>
                                                                                                    <option value="2" <%if (valShowList == 2) {%>selected<%}%>><%=langFR[2]%></option>
                                                                                                </select>
                                                                                            </td> 
                                                                                            <%if (typeProfit == 0) {%>
                                                                                            <td width="120" class="tablecell1">&nbsp;&nbsp;Total <%=langNav[5]%></td>
                                                                                            <td width="2" class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name="total_month" class="fontarial">
                                                                                                    <option value="1" <%if (totalMonth == 1) {%>selected<%}%>>1 <%=langNav[5]%></option>
                                                                                                    <option value="3" <%if (totalMonth == 3) {%>selected<%}%>>3 <%=langNav[5]%></option>
                                                                                                    <option value="6" <%if (totalMonth == 6) {%>selected<%}%>>6 <%=langNav[5]%></option>
                                                                                                </select>
                                                                                            </td> 
                                                                                            <%} else {%>
                                                                                            <td width="120">&nbsp;</td>
                                                                                            <td width="2" ></td>
                                                                                            <td ></td> 
                                                                                            <%}%>
                                                                                        </tr>     
                                                                                        <%
            if (vSeg != null && vSeg.size() > 0) {
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
                                                                                        
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablecell1">&nbsp;&nbsp;<%=oSegment.getName()%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
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
                                                                                            <td class="tablecell1">&nbsp;&nbsp;Only Header</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td ><input type="checkbox" name="only_header" value="1" <%if (onlyHeader == 1) {%> checked<%}%>  ></td>
                                                                                        </tr> 
                                                                                        <%
                    }

                }
            }%>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablecell1">&nbsp;&nbsp;Type</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name="type_profit" class="fontarial" onChange="javascript:cmdReloadType()">
                                                                                                    <option value="0" <%if (0 == typeProfit) {%>selected<%}%>>Month</option>                                                                                                    
                                                                                                    <option value="1" <%if (1 == typeProfit) {%>selected<%}%>>Year</option>                                                                                                    
                                                                                                </select>
                                                                                            </td> 
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                        </tr>  
                                                                                        <%if (typeProfit == 1) {%>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablecell1">&nbsp;&nbsp;Year</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name="select_year" class="fontarial">
                                                                                                    <option value="<%=year%>" <%if (year == yearselect) {%>selected<%}%>><%=(year + 1900)%></option>
                                                                                                    <option value="<%=year - 1%>" <%if ((year - 1) == yearselect) {%>selected<%}%>><%=year - 1 + 1900%></option>
                                                                                                    <option value="<%=year - 2%>" <%if ((year - 2) == yearselect) {%>selected<%}%>><%=year - 2 + 1900%></option>
                                                                                                </select>
                                                                                            </td> 
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                        </tr>  
                                                                                        <%
            }
            if (typeProfit == 0) {
                Vector vPeriode = new Vector();
                vPeriode = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc ");
                                                                                        %>
                                                                                        <tr align="left" height="22"> 
                                                                                            <td class="tablecell1">&nbsp;&nbsp;<%=langNav[5]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td > 
                                                                                                <select name="periode_id" class="fontarial">
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
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                            <td ></td>
                                                                                        </tr>     
                                                                                        <%}%>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="6">
                                                                                                <table width="800">
                                                                                                    <tr>
                                                                                                        <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <tr align="left" height="22" id="closecmd">                                                                                             
                                                                                            <td colspan="6"><input type="button" name="Button" value="GO" onClick="javascript:cmdGO()"></td>
                                                                                        </tr>
                                                                                        <tr id="closemsg" align="left" valign="top"> 
                                                                                            <td colspan="6" height="22" valign="middle" > 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">                      
                                                                                                    <tr> 
                                                                                                        <td><font color="#006600">Generate in progress, please wait .... </font> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td height="1">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td><img src="../images/progress_bar.gif" border="0"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>                                                                                                                                            
                                                                                <td colspan="3">&nbsp;</td>
                                                                            </tr>                                                                            
                                                                            <%if (iJSPCommand == JSPCommand.LIST) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" colspan="3"></td>
                                                                            </tr>                                                                              
                                                                            <tr align="center" valign="top">
                                                                                <td height="20" valign="middle" colspan="3"> 
                                                                                    <font face="arial" size="3"><b>PROFIT & LOSS STATEMENT</b></font>
                                                                                </td>
                                                                            </tr>                          
                                                                            <tr align="center" valign="top">
                                                                                <td height="20" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                                                                        <tr> 
                                                                                            <%if (segment1Id == 0) {%>
                                                                                            <td height="20" valign="middle" align="center"><font face="arial" size="3"><b>KONSOLIDASI</b></font></td>
                                                                                            <%} else {
    SegmentDetail sdx = new SegmentDetail();
    try {
        sdx = DbSegmentDetail.fetchExc(segment1Id);
    } catch (Exception e) {
    }
                                                                                            %>
                                                                                            <td height="20" valign="middle" align="center"><font face="arial" size="3"><b><%=sdx.getName().toUpperCase()%></b></font></td>
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
                                                                                        <tr height="26"> 
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
                                                                                            <td class="tablehdr" width="40">%</td>
                                                                                            <%}%>                                                                                            
                                                                                            <td width="100" class="tablehdr" height="22">Year To Date</td>
                                                                                            <td class="tablehdr" width="40">%</td>
                                                                                        </tr>
                                                                                        <!--level ACC_GROUP_REVENUE-->
                                                                                 <%

    listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " ='Revenue'", DbCoa.colNames[DbCoa.COL_CODE]);
    double groupRev = SessGeneratePNL.getIsCoaBalance(listCoa, temp, segment1Id);

    if (groupRev != 0 || valShowList != 1) {//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_REVENUE.toUpperCase());
        sesReport.setFont(1);
        vSesDep = new Vector();

                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_REVENUE.toUpperCase()%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>
                                                                                        <%

    }

    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        Hashtable balanceHeader = new Hashtable();
        double ytd = 0;

        String nameHeader = "";
        String status = "";

        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {

                if (status == "") {
                    status = coa.getStatus();
                    nameHeader = coa.getName();
                }

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountBalance = 0;
                Hashtable amounts = new Hashtable();
                double tmpYTD = SessGeneratePNL.getAmountLTB(coa, segment1Id, period);//DbCoa.getCoaBalancePNLYTD(coa, whereMd, period, "CD");
                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                    Periode p = (Periode) temp.get(ix);
                    double amount = SessGeneratePNL.getCoaBalancePNLMTD(coa, segment1Id, p);
                    if (amount != 0) {
                        amountBalance = amount;
                    }
                    //tmpYTD = tmpYTD + amount;
                    amounts.put("" + p.getOID(), "" + amount);
                }


                if (valShowList == 1) {
                    if (amountBalance != 0 || tmpYTD != 0) {	//add detail

                        if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                            sesReport = new SesReportBs();
                            sesReport.setType("Group Level");
                            sesReport.setDescription(nameHeader);
                            sesReport.setFont(2);
                            vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                                                        double amount = 0;
                                                                                                                        try {
                                                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                                                        } catch (Exception e) {
                                                                                                                            amount = 0;
                                                                                                                        }
                                                                                                                        double persen = 0;

                                                                                                                        if (balanceHeader != null) {
                                                                                                                            double amountHeader = 0;
                                                                                                                            try {
                                                                                                                                amountHeader = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                                                            } catch (Exception e) {
                                                                                                                                amountHeader = 0;
                                                                                                                            }

                                                                                                                            if (amountHeader != 0 && amount > 0) {
                                                                                                                                persen = (amount / amountHeader) * 100;
                                                                                                                            }
                                                                                                                        }

                                                                                                                        if (persen < 0) {
                                                                                                                            persen = 0;
                                                                                                                        }

                                                                                                                        vSesDep.add("" + amount);
                                                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                                                    ytd = totSubRev;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                                                    vSesDep.add("" + ytd);
                                                                                                                    double persenYTD = 0;
                                                                                                                    if (ytd != 0 && ytd > 0) {
                                                                                                                        persenYTD = (ytd / ytd) * 100;
                                                                                                                    }

                                                                                                                    if (persenYTD < 0) {
                                                                                                                        persenYTD = 0;
                                                                                                                    }
                                                                                                                    vSesDep.add("" + persenYTD);
                                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                                    listReport.add(sesReport);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                    totSubRev = 0;
                                                                                                                }

                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    balanceHeader = new Hashtable();
                                                                                                                    ytd = 0;
                                                                                                                    balanceHeader = amounts;
                                                                                                                    ytd = tmpYTD;
                                                                                                                }
                                                                                                                status = coa.getStatus();
                                                                                                                sesReport = new SesReportBs();
                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                vSesDep = new Vector();
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                double totAmount = tmpYTD;
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                                }
                                                                                                                Vector tmpMaping = new Vector();
                                                                                                                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                    Periode p = (Periode) temp.get(ix);

                                                                                                                    double amount = 0;
                                                                                                                    try {
                                                                                                                        amount = Double.parseDouble("" + amounts.get("" + p.getOID()));
                                                                                                                    } catch (Exception e) {
                                                                                                                        amount = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + amount);
                                                                                                                    if (!coa.getStatus().equals("HEADER")) {
                                                                                                                        totalRev[ix] = totalRev[ix] + amount;
                                                                                                                    }

                                                                                                                    double persen = 0;

                                                                                                                    if (balanceHeader != null) {
                                                                                                                        double amountHeader = 0;
                                                                                                                        try {
                                                                                                                            amountHeader = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                                                        } catch (Exception e) {
                                                                                                                            amountHeader = 0;
                                                                                                                        }

                                                                                                                        if (amountHeader != 0 && amount > 0) {
                                                                                                                            persen = (amount / amountHeader) * 100;
                                                                                                                        }
                                                                                                                    }

                                                                                                                    if (persen < 0) {
                                                                                                                        persen = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + persen);

                                                                                                                    if (!coa.getStatus().equals("HEADER")) {
                                                                                                                        tmpMaping.add(String.valueOf(amount));
                                                                                                                    }
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%}
                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    mappingCogs.put(String.valueOf(coa.getCode()), tmpMaping);
                                                                                                                }
                                                                                            %>	
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>
                                                                                                <%
                                                                                                                vSesDep.add("" + totAmount);
                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totSubRev = totSubRev + totAmount;
                                                                                                                    totRev = totRev + totAmount;
                                                                                                                    mappingCogsYtd.put(String.valueOf(coa.getCode()), String.valueOf(totAmount));
                                                                                                                }
                                                                                                %>
                                                                                            </td>
                                                                                            <%
                                                                                                                double persenYTD = 0;
                                                                                                                if (ytd != 0 && totAmount > 0) {
                                                                                                                    persenYTD = (totAmount / ytd) * 100;
                                                                                                                }

                                                                                                                if (persenYTD < 0) {
                                                                                                                    persenYTD = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                                sesReport.setAmount(totAmount);
                                                                                                                sesReport.setStrAmount("" + totAmount);
                                                                                                                listReport.add(sesReport);
                                                                                                            }
                                                                                                        } else {

                                                                                                            if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {

                                                                                                                sesReport = new SesReportBs();
                                                                                                                sesReport.setType("Group Level");
                                                                                                                sesReport.setDescription(nameHeader);
                                                                                                                sesReport.setFont(2);
                                                                                                                vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode p = (Periode) temp.get(ix);
                                                                                            double amount = 0;
                                                                                            try {
                                                                                                amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                            } catch (Exception e) {
                                                                                                amount = 0;
                                                                                            }
                                                                                            double persen = 0;

                                                                                            if (balanceHeader != null) {
                                                                                                double amountHeader = 0;
                                                                                                try {
                                                                                                    amountHeader = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                                } catch (Exception e) {
                                                                                                    amountHeader = 0;
                                                                                                }

                                                                                                if (amountHeader != 0 && amount > 0) {
                                                                                                    persen = (amount / amountHeader) * 100;
                                                                                                }
                                                                                            }

                                                                                            if (persen < 0) {
                                                                                                persen = 0;
                                                                                            }

                                                                                            vSesDep.add("" + amount);
                                                                                            vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                        ytd = totSubRev;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                        double persenYTD = 0;
                                                                                        if (ytd != 0) {
                                                                                            persenYTD = (ytd / ytd) * 100;
                                                                                        }

                                                                                        if (persenYTD < 0) {
                                                                                            persenYTD = 0;
                                                                                        }

                                                                                        vSesDep.add("" + ytd);
                                                                                        vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                 
                                                                                        <%

                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                listReport.add(sesReport);
                                                                                                                totSubRev = 0;

                                                                                                            }
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                balanceHeader = new Hashtable();
                                                                                                                ytd = 0;
                                                                                                                balanceHeader = amounts;
                                                                                                                ytd = tmpYTD;
                                                                                                            }
                                                                                                            status = coa.getStatus();

                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            double totAmount = tmpYTD;

                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap>
                                                                                                <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                            }
                                                                                                            Vector tmpMaping = new Vector();
                                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);

                                                                                                                double amount = 0;
                                                                                                                try {
                                                                                                                    amount = Double.parseDouble("" + amounts.get("" + per.getOID()));
                                                                                                                } catch (Exception e) {
                                                                                                                    amount = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + amount);

                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totalRev[ix] = totalRev[ix] + amount;
                                                                                                                }

                                                                                                                double persen = 0;

                                                                                                                if (balanceHeader != null) {
                                                                                                                    double amountHeader = 0;
                                                                                                                    try {
                                                                                                                        amountHeader = Double.parseDouble("" + balanceHeader.get("" + per.getOID()));
                                                                                                                    } catch (Exception e) {
                                                                                                                        amountHeader = 0;
                                                                                                                    }

                                                                                                                    if (amountHeader != 0) {
                                                                                                                        persen = (amount / amountHeader) * 100;
                                                                                                                    }

                                                                                                                }

                                                                                                                if (persen < 0) {
                                                                                                                    persen = 0;
                                                                                                                }
                                                                                                                vSesDep.add("" + persen);
                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    tmpMaping.add(String.valueOf(amount));
                                                                                                                }

                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%
                                                                                                            }
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                mappingCogs.put(String.valueOf(coa.getCode()), tmpMaping);                                                                                                                
                                                                                                            }
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>                                                                                                
                                                                                                <%
                                                                                                            vSesDep.add("" + totAmount);

                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                totSubRev = totSubRev + totAmount;
                                                                                                                totRev = totRev + totAmount;
                                                                                                                mappingCogsYtd.put(String.valueOf(coa.getCode()),String.valueOf(totAmount));
                                                                                                            }%>
                                                                                            </td>
                                                                                            <%
                                                                                                            double persenYTD = 0;
                                                                                                            if (ytd != 0) {
                                                                                                                persenYTD = (totAmount / ytd) * 100;
                                                                                                            }

                                                                                                            if (persenYTD < 0) {
                                                                                                                persenYTD = 0;
                                                                                                            }

                                                                                                            vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;" nowrap>
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(totAmount);
                                                                                                            sesReport.setStrAmount("" + totAmount);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }

                                                                                                    if ((i == listCoa.size() - 1) && coa.getStatus().equals("POSTABLE")) {
                                                                                        %>
                                                                                        
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(nameHeader);
                                                                                    sesReport.setFont(2);
                                                                                    vSesDep = new Vector();

                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                        double amount = 0;
                                                                                        try {
                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                        } catch (Exception e) {
                                                                                            amount = 0;
                                                                                        }
                                                                                        double persen = 0;
                                                                                        vSesDep.add("" + amount);

                                                                                        if (balanceHeader != null) {
                                                                                            double amountHeader = 0;
                                                                                            try {
                                                                                                amountHeader = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                            } catch (Exception e) {
                                                                                                amountHeader = 0;
                                                                                            }

                                                                                            if (amountHeader != 0) {
                                                                                                persen = (amount / amountHeader) * 100;
                                                                                            }
                                                                                        }

                                                                                        if (persen < 0) {
                                                                                            persen = 0;
                                                                                        }

                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                    ytd = totSubRev;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                    vSesDep.add("" + ytd);
                                                                                    double persenYTD = 0;
                                                                                    if (ytd != 0) {
                                                                                        persenYTD = (ytd / ytd) * 100;
                                                                                    }

                                                                                    if (persenYTD < 0) {
                                                                                        persenYTD = 0;
                                                                                    }
                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                        listReport.add(sesReport);
                                                                                                        totSubRev = 0;

                                                                                                    }
                                                                                                }				//add footer level

                                                                                                if (groupRev != 0 || valShowList != 1) {	//add Group Footer                                                                                                
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                    sesReport.setDescription("TOTAL " + I_Project.ACC_GROUP_REVENUE.toUpperCase());
                                                                                                    sesReport.setFont(3);
                                                                                                    vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><font color="#F60"><b><i><%="TOTAL " + I_Project.ACC_GROUP_REVENUE.toUpperCase()%></i></b></font></td>
                                                                                            <%
                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                        vSesDep.add("" + totalRev[ix]);
                                                                                        vSesDep.add("" + 0);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totalRev[ix], coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>                                                                                            
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totRev, coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>                                                                                             
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            vSesDep.add("" + totRev);
            vSesDep.add("" + 0);
            sesReport.setAmount(totRev);
            sesReport.setStrAmount("" + totRev);
            sesReport.setDepartment(vSesDep);
            listReport.add(sesReport);
        }
    }
    if (groupRev != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setFont(1);
        sesReport.setDescription("");
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
        }
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%> 
                                                                                        
                                                                                        <!--level ACC_COST_OF_SALES-->
                                                                                        <%
    listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " ='Cost Of Sales'", DbCoa.colNames[DbCoa.COL_CODE]);
    double groupCos = SessGeneratePNL.getIsCoaBalance(listCoa, temp, segment1Id);

    if (groupCos != 0 || valShowList != 1) {//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_COST_OF_SALES);
        sesReport.setFont(1);
        vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_COST_OF_SALES.toUpperCase()%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                vSesDep.add("0");
                                                                                                vSesDep.add("0");
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}
                                                                                            vSesDep.add("0");
                                                                                            vSesDep.add("0");
                                                                                            sesReport.setDepartment(vSesDep);
                                                                                            listReport.add(sesReport);
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>
                                                                                        <%

    }

    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        Hashtable balanceHeader = new Hashtable();
        double ytd = 0;

        String nameHeader = "";
        String status = "";

        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {

                if (status == "") {
                    status = coa.getStatus();
                    nameHeader = coa.getName();
                }

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountBalance = 0;
                Hashtable amounts = new Hashtable();
                double tmpYTD = SessGeneratePNL.getAmountLTB(coa, segment1Id, period);
                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                    Periode p = (Periode) temp.get(ix);
                    double amount = SessGeneratePNL.getCoaBalancePNLMTD(coa, segment1Id, p);
                    if (amount != 0) {
                        amountBalance = amount;
                    }
                    //tmpYTD = tmpYTD + amount;
                    amounts.put("" + p.getOID(), "" + amount);
                }


                if (valShowList == 1) {
                    if (amountBalance != 0 || tmpYTD != 0) {	//add detail
                        if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                            sesReport = new SesReportBs();
                            sesReport.setType("Group Level");
                            sesReport.setDescription(nameHeader);
                            sesReport.setFont(2);
                            vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                                                        double amount = 0;
                                                                                                                        try {
                                                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                                                        } catch (Exception e) {
                                                                                                                            amount = 0;
                                                                                                                        }
                                                                                                                        vSesDep.add("" + amount);
                                                                                                                        double persen = 0;

                                                                                                                        if (balanceHeader != null) {
                                                                                                                            double amountHeader = 0;
                                                                                                                            try {
                                                                                                                                amountHeader = totalRev[ix];
                                                                                                                            } catch (Exception e) {
                                                                                                                                amountHeader = 0;
                                                                                                                            }

                                                                                                                            if (amountHeader != 0) {
                                                                                                                                persen = (amount / amountHeader) * 100;
                                                                                                                            }
                                                                                                                        }
                                                                                                                        if (persen < 0) {
                                                                                                                            persen = 0;
                                                                                                                        }

                                                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                                                    ytd = totSubCOS;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                                                    vSesDep.add("" + ytd);
                                                                                                                    double persenYTD = 0;
                                                                                                                    if (totRev != 0) {
                                                                                                                        persenYTD = (ytd / totRev) * 100;
                                                                                                                    }

                                                                                                                    if (persenYTD < 0) {
                                                                                                                        persenYTD = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                                    listReport.add(sesReport);
                                                                                                                    totSubCOS = 0;
                                                                                                                }

                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    balanceHeader = new Hashtable();
                                                                                                                    ytd = 0;
                                                                                                                    balanceHeader = amounts;
                                                                                                                    ytd = tmpYTD;
                                                                                                                }
                                                                                                                status = coa.getStatus();
                                                                                                                sesReport = new SesReportBs();
                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                vSesDep = new Vector();
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                double totAmount = tmpYTD;
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                                }

                                                                                                                String idx = "";
                                                                                                                Vector valRev = new Vector();

                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    try {
                                                                                                                        idx = String.valueOf(strMapping.get(coa.getCode()));
                                                                                                                        if (idx != null && idx.length() > 0) {
                                                                                                                            valRev = (Vector) mappingCogs.get(idx);
                                                                                                                        }
                                                                                                                    } catch (Exception e) {
                                                                                                                    }

                                                                                                                }
                                                                                                                int revIdx = 0;

                                                                                                                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                    Periode p = (Periode) temp.get(ix);

                                                                                                                    double amount = 0;
                                                                                                                    try {
                                                                                                                        amount = Double.parseDouble("" + amounts.get("" + p.getOID()));
                                                                                                                    } catch (Exception e) {
                                                                                                                        amount = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + amount);
                                                                                                                    double amountRev = 0;
                                                                                                                    if (!coa.getStatus().equals("HEADER")) {
                                                                                                                        if (valRev != null && valRev.size() > 0) {
                                                                                                                            try {
                                                                                                                                amountRev = Double.parseDouble(String.valueOf(valRev.get(revIdx)));
                                                                                                                            } catch (Exception e) {
                                                                                                                            }
                                                                                                                        }

                                                                                                                        totalCOS[ix] = totalCOS[ix] + amount;
                                                                                                                    }

                                                                                                                    double persen = 0;

                                                                                                                    if (balanceHeader != null) {
                                                                                                                        double amountHeader = 0;
                                                                                                                        try {
                                                                                                                            amountHeader = totalRev[ix];
                                                                                                                        } catch (Exception e) {
                                                                                                                            amountHeader = 0;
                                                                                                                        }

                                                                                                                        if (amountHeader != 0) {
                                                                                                                            persen = (amount / amountHeader) * 100;
                                                                                                                        }
                                                                                                                    }

                                                                                                                    if (!coa.getStatus().equals("HEADER") && idx != null && idx.length() > 0 && !idx.equals("null")) {
                                                                                                                        if (amountRev != 0) {
                                                                                                                            persen = (amount / amountRev) * 100;
                                                                                                                        } else {
                                                                                                                            persen = 0;
                                                                                                                        }
                                                                                                                    }

                                                                                                                    if (persen < 0) {
                                                                                                                        persen = 0;
                                                                                                                    }
                                                                                                                    vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%
                                                                                                                    revIdx++;
                                                                                                                }
                                                                                            %>	
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>
                                                                                                <%
                                                                                                                vSesDep.add("" + totAmount);
                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totCOS = totCOS + totAmount;
                                                                                                                    totSubCOS = totSubCOS + totAmount;
                                                                                                                }%>
                                                                                            </td>
                                                                                            <%
                                                                                                                double persenYTD = 0;
                                                                                                                double totRevSub = 0;
                                                                                                                try{
                                                                                                                    totRevSub = Double.parseDouble(String.valueOf(mappingCogsYtd.get(idx)));
                                                                                                                }catch(Exception e){}
                                                                                                                
                                                                                                                //if (totRev != 0) {
                                                                                                                //    persenYTD = (totAmount / totRev) * 100;
                                                                                                                //}
                                                                                                                
                                                                                                                if (totRevSub != 0) {
                                                                                                                    persenYTD = (totAmount / totRevSub) * 100;
                                                                                                                }
                                                                                                                
                                                                                                                if (persenYTD < 0) {
                                                                                                                    persenYTD = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                                sesReport.setAmount(totAmount);
                                                                                                                sesReport.setStrAmount("" + totAmount);
                                                                                                                listReport.add(sesReport);
                                                                                                            }
                                                                                                        } else {

                                                                                                            if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Group Level");
                                                                                        sesReport.setDescription(nameHeader);
                                                                                        sesReport.setFont(2);
                                                                                        vSesDep = new Vector();
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode p = (Periode) temp.get(ix);
                                                                                            double amount = 0;
                                                                                            try {
                                                                                                amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                            } catch (Exception e) {
                                                                                                amount = 0;
                                                                                            }
                                                                                            double persen = 0;
                                                                                            vSesDep.add("" + amount);
                                                                                            if (balanceHeader != null) {
                                                                                                double amountHeader = 0;
                                                                                                try {
                                                                                                    amountHeader = totalRev[ix];
                                                                                                } catch (Exception e) {
                                                                                                    amountHeader = 0;
                                                                                                }

                                                                                                if (amountHeader != 0) {
                                                                                                    persen = (amount / amountHeader) * 100;
                                                                                                }
                                                                                            }

                                                                                            if (persen < 0) {
                                                                                                persen = 0;
                                                                                            }

                                                                                            vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                        ytd = totSubCOS;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep.add("" + ytd);

                                                                                        double persenYTD = 0;
                                                                                        if (totRev != 0) {
                                                                                            persenYTD = (ytd / totRev) * 100;
                                                                                        }

                                                                                        if (persenYTD < 0) {
                                                                                            persenYTD = 0;
                                                                                        }

                                                                                        vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                listReport.add(sesReport);
                                                                                                                totSubCOS = 0;
                                                                                                            }
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                balanceHeader = new Hashtable();
                                                                                                                ytd = 0;
                                                                                                                balanceHeader = amounts;
                                                                                                                ytd = tmpYTD;
                                                                                                            }
                                                                                                            status = coa.getStatus();

                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            double totAmount = tmpYTD;

                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap>
                                                                                                <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                            }

                                                                                                            String idx = "";
                                                                                                            Vector valRev = new Vector();

                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                try {
                                                                                                                    idx = String.valueOf(strMapping.get(coa.getCode()));
                                                                                                                    if (idx != null && idx.length() > 0) {
                                                                                                                        valRev = (Vector) mappingCogs.get(idx);
                                                                                                                    }
                                                                                                                } catch (Exception e) {
                                                                                                                }

                                                                                                            }
                                                                                                            int revIdx = 0;
                                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);

                                                                                                                double amount = 0;
                                                                                                                try {
                                                                                                                    amount = Double.parseDouble("" + amounts.get("" + per.getOID()));
                                                                                                                } catch (Exception e) {
                                                                                                                    amount = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + amount);
                                                                                                                double amountRev = 0;
                                                                                                                if (!coa.getStatus().equals("HEADER")) {

                                                                                                                    if (valRev != null && valRev.size() > 0) {
                                                                                                                        try {
                                                                                                                            amountRev = Double.parseDouble(String.valueOf(valRev.get(revIdx)));
                                                                                                                        } catch (Exception e) {
                                                                                                                        }
                                                                                                                    }
                                                                                                                    totalCOS[ix] = totalCOS[ix] + amount;
                                                                                                                }

                                                                                                                double persen = 0;

                                                                                                                if (balanceHeader != null) {
                                                                                                                    double amountHeader = 0;
                                                                                                                    try {
                                                                                                                        amountHeader = totalRev[ix];
                                                                                                                    } catch (Exception e) {
                                                                                                                        amountHeader = 0;
                                                                                                                    }

                                                                                                                    if (amountHeader != 0) {
                                                                                                                        persen = (amount / amountHeader) * 100;
                                                                                                                    }
                                                                                                                }

                                                                                                                if (!coa.getStatus().equals("HEADER") && idx != null && idx.length() > 0 && !idx.equals("null")) {
                                                                                                                    if (amountRev != 0) {
                                                                                                                        persen = (amount / amountRev) * 100;
                                                                                                                    } else {
                                                                                                                        persen = 0;
                                                                                                                    }
                                                                                                                }

                                                                                                                if (persen < 0) {
                                                                                                                    persen = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%
                                                                                                                revIdx++;
                                                                                                            }
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>  
                                                                                                <%if (!coa.getStatus().equals("HEADER")) {
                                                                                                                totCOS = totCOS + totAmount;
                                                                                                                totSubCOS = totSubCOS + totAmount;
                                                                                                            }
                                                                                                            vSesDep.add("" + totAmount);
                                                                                                %>
                                                                                                
                                                                                            </td>
                                                                                            <%
                                                                                                            double persenYTD = 0;
                                                                                                            double totRevSub = 0;
                                                                                                            try{
                                                                                                                totRevSub = Double.parseDouble(String.valueOf(mappingCogsYtd.get(idx)));
                                                                                                            }catch(Exception e){}
                                                                                                            if (totRevSub != 0) {
                                                                                                                persenYTD = (totAmount / totRevSub) * 100;
                                                                                                            }

                                                                                                            if (persenYTD < 0) {
                                                                                                                persenYTD = 0;
                                                                                                            }
                                                                                                            vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;" nowrap>
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(totAmount);
                                                                                                            sesReport.setStrAmount("" + totAmount);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }

                                                                                                    if ((i == listCoa.size() - 1) && coa.getStatus().equals("POSTABLE")) {
                                                                                        %>
                                                                                        
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(nameHeader);
                                                                                    sesReport.setFont(2);
                                                                                    vSesDep = new Vector();

                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                        double amount = 0;
                                                                                        try {
                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                        } catch (Exception e) {
                                                                                            amount = 0;
                                                                                        }
                                                                                        double persen = 0;
                                                                                        vSesDep.add("" + amount);

                                                                                        if (balanceHeader != null) {
                                                                                            double amountHeader = 0;
                                                                                            try {
                                                                                                amountHeader = totalRev[ix];
                                                                                            } catch (Exception e) {
                                                                                                amountHeader = 0;
                                                                                            }

                                                                                            if (amountHeader != 0) {
                                                                                                persen = (amount / amountHeader) * 100;
                                                                                            }
                                                                                        }

                                                                                        if (persen < 0) {
                                                                                            persen = 0;
                                                                                        }

                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                    ytd = totSubCOS;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                    double persenYTD = 0;
                                                                                    if (totRev != 0) {
                                                                                        persenYTD = (ytd / totRev) * 100;
                                                                                    }

                                                                                    if (persenYTD < 0) {
                                                                                        persenYTD = 0;
                                                                                    }


                                                                                    vSesDep.add("" + ytd);
                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                        listReport.add(sesReport);
                                                                                                        ytd = 0;
                                                                                                    }
                                                                                                }				//add footer level



                                                                                        %>
                                                                                        
                                                                                        
                                                                                        <%

                                                                                                if (groupRev != 0 || valShowList != 1) {	//add Group Footer                                                                                                
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                    sesReport.setDescription("TOTAL " + I_Project.ACC_GROUP_COST_OF_SALES.toUpperCase());
                                                                                                    sesReport.setFont(2);
                                                                                                    vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><font color="#F60"><b><i><%="TOTAL " + I_Project.ACC_GROUP_COST_OF_SALES.toUpperCase()%></i></b></font></td>
                                                                                            <%
                                                                                                                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                                                                                                vSesDep.add("" + totalCOS[ix]);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totalCOS[ix], coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totalRev[ix] != 0) {
                                                                                                    vSesDep.add("" + (totalCOS[ix] / totalRev[ix]) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totalCOS[ix] / totalRev[ix]) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>  
                                                                                                </font>
                                                                                            </td>                                                                                            
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totCOS, coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <%
                                                                                                                                                                                            vSesDep.add("" + totCOS);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totRev != 0) {
                                                                                                                                                                                                vSesDep.add("" + (totCOS / totRev) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totCOS / totRev) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>                                                                                                
                                                                                                </font>
                                                                                            </td>                                                                                             
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            sesReport.setAmount(totCOS);
            sesReport.setStrAmount("" + totCOS);
            sesReport.setDepartment(vSesDep);
            listReport.add(sesReport);
        }
    }
    if (groupRev != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
        }
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>                                                                                        
                                                                                        <%}%>  
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        
                                                                                        <%//Gross Profit %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><font color="#F60"><b><i>GROSS PROFIT</i></b></font></td>
                                                                                            <%
    sesReport = new SesReportBs();
    sesReport.setType("Group Level");
    sesReport.setDescription("GROSS PROFIT");
    sesReport.setFont(2);
    vSesDep = new Vector();

    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
        vSesDep.add("" + (totalRev[ix] - totalCOS[ix]));
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totalRev[ix] - totalCOS[ix], coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if ((totalRev[ix]) != 0) {
                                                                                                    vSesDep.add("" + ((totalRev[ix] - totalCOS[ix]) / totalRev[ix]) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(((totalRev[ix] - totalCOS[ix]) / totalRev[ix]) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>  
                                                                                                </font>
                                                                                            </td>                                                                                            
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <%
    vSesDep.add("" + (totRev - totCOS));
                                                                                                %>
                                                                                                <div align="right"><b><i><%=strDisplay(totRev - totCOS, coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totRev != 0) {
        vSesDep.add("" + ((totRev - totCOS) / totRev) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(((totRev - totCOS) / totRev) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>                                                                                                
                                                                                                </font>
                                                                                            </td>                                                                                             
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
    sesReport.setDepartment(vSesDep);
    listReport.add(sesReport);

    sesReport = new SesReportBs();
    sesReport.setType("Space");
    sesReport.setDescription("");
    sesReport.setFont(1);
    vSesDep = new Vector();
    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
        vSesDep.add("0");
        vSesDep.add("0");
    }
    vSesDep.add("0");
    vSesDep.add("0");
    sesReport.setDepartment(vSesDep);
    listReport.add(sesReport);

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <!--level ACC_COST_OF_EXPENSES-->
                                                                                        <%
    listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " ='Expense'", DbCoa.colNames[DbCoa.COL_CODE]);
    double groupExpense = SessGeneratePNL.getIsCoaBalance(listCoa, temp, segment1Id);

    if (groupExpense != 0 || valShowList != 1) {//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_EXPENSE);
        sesReport.setFont(1);
        vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_EXPENSE.toUpperCase()%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>
                                                                                        <%

    }

    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        Hashtable balanceHeader = new Hashtable();

        double ytd = 0;

        String nameHeader = "";
        String status = "";

        boolean totalBiaya = false;

        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {

                if (status == "") {
                    status = coa.getStatus();
                    nameHeader = coa.getName();
                }

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountBalance = 0;
                Hashtable amounts = new Hashtable();
                double tmpYTD = SessGeneratePNL.getAmountLTB(coa, segment1Id, period);
                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                    Periode p = (Periode) temp.get(ix);
                    double amount = SessGeneratePNL.getCoaBalancePNLMTD(coa, segment1Id, p);
                    if (amount != 0) {
                        amountBalance = amount;
                    }
                    //tmpYTD = tmpYTD + amount;
                    amounts.put("" + p.getOID(), "" + amount);
                }


                if (valShowList == 1) {
                    if (amountBalance != 0 || tmpYTD != 0) {	//add detail
                        if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                            sesReport = new SesReportBs();
                            sesReport.setType("Group Level");
                            sesReport.setDescription(nameHeader);
                            sesReport.setFont(2);
                            vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                                                        double amount = 0;
                                                                                                                        try {
                                                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                                                        } catch (Exception e) {
                                                                                                                            amount = 0;
                                                                                                                        }
                                                                                                                        vSesDep.add("" + amount);
                                                                                                                        double persen = 0;

                                                                                                                        if (balanceHeader != null) {
                                                                                                                            double amountHeader = 0;
                                                                                                                            try {
                                                                                                                                amountHeader = totalRev[ix];
                                                                                                                            } catch (Exception e) {
                                                                                                                                amountHeader = 0;
                                                                                                                            }

                                                                                                                            if (amountHeader != 0) {
                                                                                                                                persen = (amount / amountHeader) * 100;
                                                                                                                            }
                                                                                                                        }

                                                                                                                        if (persen < 0) {
                                                                                                                            persen = 0;
                                                                                                                        }
                                                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                                                    ytd = totSubExp;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%


                                                                                                                    vSesDep.add("" + ytd);
                                                                                                                    double persenYTD = 0;
                                                                                                                    if (totRev != 0) {
                                                                                                                        persenYTD = (ytd / totRev) * 100;
                                                                                                                    }

                                                                                                                    if (persenYTD < 0) {
                                                                                                                        persenYTD = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                                    listReport.add(sesReport);
                                                                                                                    totSubExp = 0;
                                                                                                                }

                                                                                                                if (coa.getOID() == oidGrossOperProfit) {

                                                                                                                    if (groupRev != 0 || valShowList != 1) {	//add Group Footer   
                                                                                                                        totalBiaya = false;
                                                                                                                        sesReport = new SesReportBs();
                                                                                                                        sesReport.setType("Footer Group Level");
                                                                                                                        sesReport.setDescription("GRAND TOTAL " + I_Project.ACC_GROUP_EXPENSE.toUpperCase());
                                                                                                                        sesReport.setFont(2);
                                                                                                                        vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><font color="#F60"><b><i><%="GRAND TOTAL " + I_Project.ACC_GROUP_EXPENSE.toUpperCase()%></i></b></font></td>
                                                                                            <%
                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                vSesDep.add("" + totalExp[ix]);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totalExp[ix], "POSTABLE", onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totalRev[ix] != 0) {
                                                                                                    vSesDep.add("" + (totalExp[ix] / totalRev[ix]) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totalExp[ix] / totalRev[ix]) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>  
                                                                                                </font>
                                                                                            </td>                                                                                            
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totExp, "POSTABLE", onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <%
                                                                                            vSesDep.add("" + totExp);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totRev != 0) {
                                                                                                vSesDep.add("" + (totExp / totRev) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totExp / totRev) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>                                                                                                
                                                                                                </font>
                                                                                            </td>                                                                                             
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
                                                                                            sesReport.setAmount(totExp);
                                                                                            sesReport.setStrAmount("" + totExp);
                                                                                            sesReport.setDepartment(vSesDep);
                                                                                            listReport.add(sesReport);
                                                                                        }

                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Space");
                                                                                        sesReport.setDescription("");
                                                                                        sesReport.setFont(1);
                                                                                        vSesDep = new Vector();
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            vSesDep.add("0");
                                                                                            vSesDep.add("0");
                                                                                        }
                                                                                        vSesDep.add("0");
                                                                                        vSesDep.add("0");
                                                                                        sesReport.setDepartment(vSesDep);
                                                                                        listReport.add(sesReport);
                                                                                        %>                                                                                        
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%

                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Group Level");
                                                                                        sesReport.setDescription("GROSS OF OPERATING PROFITS MARGIN");
                                                                                        sesReport.setFont(2);
                                                                                        vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablecell" ><font color="#F60"><i><b>GROSS OF OPERATING PROFITS MARGIN</b></i></font></td>
                                                                                            <%
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode p = (Periode) temp.get(ix);
                                                                                            double amount = 0;
                                                                                            try {
                                                                                                amount = totalRev[ix] - totalCOS[ix] - totalExp[ix];
                                                                                            } catch (Exception e) {
                                                                                                amount = 0;
                                                                                            }
                                                                                            vSesDep.add("" + amount);
                                                                                            double persen = 0;

                                                                                            if (balanceHeader != null) {
                                                                                                double amountHeader = 0;
                                                                                                try {
                                                                                                    amountHeader = totalRev[ix];
                                                                                                } catch (Exception e) {
                                                                                                    amountHeader = 0;
                                                                                                }

                                                                                                if (amountHeader != 0) {
                                                                                                    persen = (amount / amountHeader) * 100;
                                                                                                }
                                                                                            }
                                                                                            if (persen < 0) {
                                                                                                persen = 0;
                                                                                            }
                                                                                            vSesDep.add("" + persen);

                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totRev - totCOS - totExp), "###,###.##")%></i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep.add("" + (totRev - totCOS - totExp));
                                                                                        double persenYTD = 0;
                                                                                        if (totRev != 0) {
                                                                                            persenYTD = ((totRev - totCOS - totExp) / totRev) * 100;
                                                                                        }
                                                                                        if (persenYTD < 0) {
                                                                                            persenYTD = 0;
                                                                                        }
                                                                                        vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                        </tr>    
                                                                                        
                                                                                        <%
                                                                                        sesReport.setDepartment(vSesDep);
                                                                                        listReport.add(sesReport);

                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Space");
                                                                                        sesReport.setDescription("");
                                                                                        sesReport.setFont(1);
                                                                                        vSesDep = new Vector();
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            vSesDep.add("0");
                                                                                            vSesDep.add("0");
                                                                                        }
                                                                                        vSesDep.add("0");
                                                                                        vSesDep.add("0");
                                                                                        sesReport.setDepartment(vSesDep);
                                                                                        listReport.add(sesReport);
                                                                                        %>                                                                                        
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                                    listReport.add(sesReport);
                                                                                                                }

                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    balanceHeader = new Hashtable();
                                                                                                                    ytd = 0;
                                                                                                                    balanceHeader = amounts;
                                                                                                                    ytd = tmpYTD;
                                                                                                                }
                                                                                                                status = coa.getStatus();
                                                                                                                sesReport = new SesReportBs();
                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                vSesDep = new Vector();
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                double totAmount = tmpYTD;
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                                }
                                                                                                                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                    Periode p = (Periode) temp.get(ix);

                                                                                                                    double amount = 0;
                                                                                                                    try {
                                                                                                                        amount = Double.parseDouble("" + amounts.get("" + p.getOID()));
                                                                                                                    } catch (Exception e) {
                                                                                                                        amount = 0;
                                                                                                                    }

                                                                                                                    //if ((p.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                    //totAmount = totAmount + amount;
                                                                                                                    //}

                                                                                                                    vSesDep.add("" + amount);
                                                                                                                    if (!coa.getStatus().equals("HEADER")) {
                                                                                                                        totalExp[ix] = totalExp[ix] + amount;
                                                                                                                        totalNetOp[ix] = totalNetOp[ix] + amount;
                                                                                                                    }

                                                                                                                    double persen = 0;

                                                                                                                    if (balanceHeader != null) {
                                                                                                                        double amountHeader = 0;
                                                                                                                        try {
                                                                                                                            amountHeader = totalRev[ix];
                                                                                                                        } catch (Exception e) {
                                                                                                                            amountHeader = 0;
                                                                                                                        }

                                                                                                                        if (amountHeader != 0) {
                                                                                                                            persen = (amount / amountHeader) * 100;
                                                                                                                        }
                                                                                                                    }

                                                                                                                    if (persen < 0) {
                                                                                                                        persen = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>
                                                                                                <%
                                                                                                                vSesDep.add("" + totAmount);
                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totSubExp = totSubExp + totAmount;
                                                                                                                    totExp = totExp + totAmount;
                                                                                                                    totNetOp = totNetOp + totAmount;
                                                                                                                }%>
                                                                                            </td>
                                                                                            <%
                                                                                                                double persenYTD = 0;
                                                                                                                if (totRev != 0) {
                                                                                                                    persenYTD = (totAmount / totRev) * 100;
                                                                                                                }

                                                                                                                if (persenYTD < 0) {
                                                                                                                    persenYTD = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                                sesReport.setAmount(totAmount);
                                                                                                                sesReport.setStrAmount("" + totAmount);
                                                                                                                listReport.add(sesReport);
                                                                                                            }
                                                                                                        } else {

                                                                                                            if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Group Level");
                                                                                        sesReport.setDescription(nameHeader);
                                                                                        sesReport.setFont(2);
                                                                                        vSesDep = new Vector();
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode p = (Periode) temp.get(ix);
                                                                                            double amount = 0;
                                                                                            try {
                                                                                                amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                            } catch (Exception e) {
                                                                                                amount = 0;
                                                                                            }
                                                                                            double persen = 0;
                                                                                            vSesDep.add("" + amount);
                                                                                            if (balanceHeader != null) {
                                                                                                double amountHeader = 0;
                                                                                                try {
                                                                                                    amountHeader = totalRev[ix];
                                                                                                } catch (Exception e) {
                                                                                                    amountHeader = 0;
                                                                                                }

                                                                                                if (amountHeader != 0) {
                                                                                                    persen = (amount / amountHeader) * 100;
                                                                                                }
                                                                                            }

                                                                                            if (persen < 0) {
                                                                                                persen = 0;
                                                                                            }
                                                                                            vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                        ytd = totSubExp;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep.add("" + ytd);

                                                                                        double persenYTD = 0;
                                                                                        if (totRev != 0) {
                                                                                            persenYTD = (ytd / totRev) * 100;
                                                                                        }

                                                                                        if (persenYTD < 0) {
                                                                                            persenYTD = 0;
                                                                                        }

                                                                                        vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                listReport.add(sesReport);
                                                                                                                totSubExp = 0;
                                                                                                            }


                                                                                                            if (coa.getOID() == oidGrossOperProfit) {

                                                                                                                if (groupRev != 0 || valShowList != 1) {	//add Group Footer   
                                                                                                                    totalBiaya = false;
                                                                                                                    sesReport = new SesReportBs();
                                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                                    sesReport.setDescription("GRAND TOTAL " + I_Project.ACC_GROUP_EXPENSE.toUpperCase());
                                                                                                                    sesReport.setFont(2);
                                                                                                                    vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><font color="#F60"><b><i><%="GRAND TOTAL " + I_Project.ACC_GROUP_EXPENSE.toUpperCase()%></i></b></font></td>
                                                                                            <%
                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                vSesDep.add("" + totalExp[ix]);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totalExp[ix], "POSTABLE", onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totalRev[ix] != 0) {
                                                                                                    vSesDep.add("" + (totalExp[ix] / totalRev[ix]) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totalExp[ix] / totalRev[ix]) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>  
                                                                                                </font>
                                                                                            </td>                                                                                            
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totExp, "POSTABLE", onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <%
                                                                                            vSesDep.add("" + totExp);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totRev != 0) {
                                                                                                vSesDep.add("" + (totExp / totRev) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totExp / totRev) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>                                                                                                
                                                                                                </font>
                                                                                            </td>                                                                                             
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
                                                                                            sesReport.setAmount(totExp);
                                                                                            sesReport.setStrAmount("" + totExp);
                                                                                            sesReport.setDepartment(vSesDep);
                                                                                            listReport.add(sesReport);
                                                                                        }


                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Space");
                                                                                        sesReport.setDescription("");
                                                                                        sesReport.setFont(1);
                                                                                        vSesDep = new Vector();
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            vSesDep.add("0");
                                                                                            vSesDep.add("0");
                                                                                        }
                                                                                        vSesDep.add("0");
                                                                                        vSesDep.add("0");
                                                                                        sesReport.setDepartment(vSesDep);
                                                                                        listReport.add(sesReport);
                                                                                        %>                                                                                        
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%

                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Group Level");
                                                                                        sesReport.setDescription("GROSS OF OPERATING PROFITS MARGIN");
                                                                                        sesReport.setFont(2);
                                                                                        vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablecell" ><font color="#F60"><i><b>GROSS OF OPERATING PROFITS MARGIN</b></i></font></td>
                                                                                            <%
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode p = (Periode) temp.get(ix);
                                                                                            double amount = 0;
                                                                                            try {
                                                                                                amount = totalRev[ix] - totalCOS[ix] - totalExp[ix];
                                                                                            } catch (Exception e) {
                                                                                                amount = 0;
                                                                                            }
                                                                                            vSesDep.add("" + amount);
                                                                                            double persen = 0;

                                                                                            if (balanceHeader != null) {
                                                                                                double amountHeader = 0;
                                                                                                try {
                                                                                                    amountHeader = totalRev[ix];
                                                                                                } catch (Exception e) {
                                                                                                    amountHeader = 0;
                                                                                                }

                                                                                                if (amountHeader != 0) {
                                                                                                    persen = (amount / amountHeader) * 100;
                                                                                                }
                                                                                            }

                                                                                            if (persen < 0) {
                                                                                                persen = 0;
                                                                                            }
                                                                                            vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totRev - totCOS - totExp), "###,###.##")%></i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep.add("" + (totRev - totCOS - totExp));
                                                                                        double persenYTD = 0;
                                                                                        if (totRev != 0) {
                                                                                            persenYTD = ((totRev - totCOS - totExp) / totRev) * 100;
                                                                                        }

                                                                                        if (persenYTD < 0) {
                                                                                            persenYTD = 0;
                                                                                        }
                                                                                        vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                        </tr>      
                                                                                        <%
                                                                                        sesReport.setDepartment(vSesDep);
                                                                                        listReport.add(sesReport);

                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Space");
                                                                                        sesReport.setDescription("");
                                                                                        sesReport.setFont(1);
                                                                                        vSesDep = new Vector();
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            vSesDep.add("0");
                                                                                            vSesDep.add("0");
                                                                                        }
                                                                                        vSesDep.add("0");
                                                                                        vSesDep.add("0");
                                                                                        sesReport.setDepartment(vSesDep);
                                                                                        listReport.add(sesReport);
                                                                                        %>                                                                                        
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                listReport.add(sesReport);
                                                                                                            }



                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                balanceHeader = new Hashtable();
                                                                                                                ytd = 0;
                                                                                                                balanceHeader = amounts;
                                                                                                                ytd = tmpYTD;
                                                                                                            }
                                                                                                            status = coa.getStatus();

                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            double totAmount = tmpYTD;

                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap>
                                                                                                <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                            }

                                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);

                                                                                                                double amount = 0;
                                                                                                                try {
                                                                                                                    amount = Double.parseDouble("" + amounts.get("" + per.getOID()));
                                                                                                                } catch (Exception e) {
                                                                                                                    amount = 0;
                                                                                                                }

                                                                                                                //if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                //totAmount = totAmount + amount;
                                                                                                                //}

                                                                                                                vSesDep.add("" + amount);

                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totalExp[ix] = totalExp[ix] + amount;
                                                                                                                }

                                                                                                                double persen = 0;

                                                                                                                if (balanceHeader != null) {
                                                                                                                    double amountHeader = 0;
                                                                                                                    try {
                                                                                                                        amountHeader = totalRev[ix];
                                                                                                                    } catch (Exception e) {
                                                                                                                        amountHeader = 0;
                                                                                                                    }

                                                                                                                    if (amountHeader != 0) {
                                                                                                                        persen = (amount / amountHeader) * 100;
                                                                                                                    }

                                                                                                                }
                                                                                                                if (persen < 0) {
                                                                                                                    persen = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>  
                                                                                                <%if (!coa.getStatus().equals("HEADER")) {
                                                                                                                totExp = totExp + totAmount;
                                                                                                                totSubExp = totSubExp + totAmount;
                                                                                                            }
                                                                                                            vSesDep.add("" + totAmount);
                                                                                                %>
                                                                                                
                                                                                            </td>
                                                                                            <%
                                                                                                            double persenYTD = 0;
                                                                                                            if (totRev != 0) {
                                                                                                                persenYTD = (totAmount / totRev) * 100;
                                                                                                            }

                                                                                                            if (persenYTD < 0) {
                                                                                                                persenYTD = 0;
                                                                                                            }
                                                                                                            vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;" nowrap>
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(totAmount);
                                                                                                            sesReport.setStrAmount("" + totAmount);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }

                                                                                                    if ((i == listCoa.size() - 1) && coa.getStatus().equals("POSTABLE")) {
                                                                                        %>
                                                                                        
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(nameHeader);
                                                                                    sesReport.setFont(2);
                                                                                    vSesDep = new Vector();

                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                        double amount = 0;
                                                                                        try {
                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                        } catch (Exception e) {
                                                                                            amount = 0;
                                                                                        }
                                                                                        double persen = 0;
                                                                                        vSesDep.add("" + amount);

                                                                                        if (balanceHeader != null) {
                                                                                            double amountHeader = 0;
                                                                                            try {
                                                                                                amountHeader = totalRev[ix];
                                                                                            } catch (Exception e) {
                                                                                                amountHeader = 0;
                                                                                            }

                                                                                            if (amountHeader != 0) {
                                                                                                persen = (amount / amountHeader) * 100;
                                                                                            }
                                                                                        }
                                                                                        if (persen < 0) {
                                                                                            persen = 0;
                                                                                        }

                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                    ytd = totSubExp;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                    double persenYTD = 0;
                                                                                    if (totRev != 0) {
                                                                                        persenYTD = (ytd / totRev) * 100;
                                                                                    }

                                                                                    if (persenYTD < 0) {
                                                                                        persenYTD = 0;
                                                                                    }
                                                                                    vSesDep.add("" + ytd);
                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                        listReport.add(sesReport);
                                                                                                        totSubExp = 0;
                                                                                                    }
                                                                                                }				//add footer level



                                                                                        %>
                                                                                        
                                                                                        
                                                                                        <%
                                                                                                if (totalBiaya) {

                                                                                                    if (groupRev != 0 || valShowList != 1) {	//add Group Footer                                                                                                
                                                                                                        sesReport = new SesReportBs();
                                                                                                        sesReport.setType("Footer Group Level");
                                                                                                        sesReport.setDescription("GRAND TOTAL " + I_Project.ACC_GROUP_EXPENSE.toUpperCase());
                                                                                                        sesReport.setFont(2);
                                                                                                        vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><font color="#F60"><b><i><%="GRAND TOTAL " + I_Project.ACC_GROUP_EXPENSE.toUpperCase()%></i></b></font></td>
                                                                                            <%
                                                                                                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                    vSesDep.add("" + totalExp[ix]);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totalExp[ix], coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totalRev[ix] != 0) {
                                                                                                    vSesDep.add("" + (totalExp[ix] / totalRev[ix]) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totalExp[ix] / totalRev[ix]) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>  
                                                                                                </font>
                                                                                            </td>                                                                                            
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totExp, coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <%
                                                                                                vSesDep.add("" + totExp);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totRev != 0) {
                                                                                                    vSesDep.add("" + (totExp / totRev) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totExp / totRev) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>                                                                                                
                                                                                                </font>
                                                                                            </td>                                                                                             
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
                sesReport.setAmount(totExp);
                sesReport.setStrAmount("" + totExp);
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
            }
        }
    }

    if (groupRev != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
        }
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>                                                                                        
                                                                                        <%}%>  
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        
                                                                                        <!--level ACC_OTHER REVENUE-->
                                                                                        <%
    listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " ='Other Revenue'", DbCoa.colNames[DbCoa.COL_CODE]);
    double groupOtherRevenue = SessGeneratePNL.getIsCoaBalance(listCoa, temp, segment1Id);

    if (groupOtherRevenue != 0 || valShowList != 1) {//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_OTHER_REVENUE);
        sesReport.setFont(1);
        vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_REVENUE.toUpperCase()%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>
                                                                                        <%

    }

    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        Hashtable balanceHeader = new Hashtable();
        double ytd = 0;

        String nameHeader = "";
        String status = "";

        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {

                if (status == "") {
                    status = coa.getStatus();
                    nameHeader = coa.getName();
                }

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountBalance = 0;
                Hashtable amounts = new Hashtable();
                double tmpYTD = SessGeneratePNL.getAmountLTB(coa, segment1Id, period);
                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                    Periode p = (Periode) temp.get(ix);
                    double amount = SessGeneratePNL.getCoaBalancePNLMTD(coa, segment1Id, p);
                    if (amount != 0) {
                        amountBalance = amount;
                    }
                    //tmpYTD = tmpYTD + amount;
                    amounts.put("" + p.getOID(), "" + amount);
                }


                if (valShowList == 1) {
                    if (amountBalance != 0 || tmpYTD != 0) {	//add detail
                        if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                            sesReport = new SesReportBs();
                            sesReport.setType("Group Level");
                            sesReport.setDescription(nameHeader);
                            sesReport.setFont(2);
                            vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                                                        double amount = 0;
                                                                                                                        try {
                                                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                                                        } catch (Exception e) {
                                                                                                                            amount = 0;
                                                                                                                        }
                                                                                                                        vSesDep.add("" + amount);
                                                                                                                        double persen = 0;

                                                                                                                        if (balanceHeader != null) {
                                                                                                                            double amountHeader = 0;
                                                                                                                            try {
                                                                                                                                amountHeader = totalRev[ix];
                                                                                                                            } catch (Exception e) {
                                                                                                                                amountHeader = 0;
                                                                                                                            }

                                                                                                                            if (amountHeader != 0) {
                                                                                                                                persen = (amount / amountHeader) * 100;
                                                                                                                            }
                                                                                                                        }
                                                                                                                        if (persen < 0) {
                                                                                                                            persen = 0;
                                                                                                                        }

                                                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                                                    ytd = totSubORev;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                                                    vSesDep.add("" + ytd);
                                                                                                                    double persenYTD = 0;
                                                                                                                    if (totRev != 0) {
                                                                                                                        persenYTD = (ytd / totRev) * 100;
                                                                                                                    }

                                                                                                                    if (persenYTD < 0) {
                                                                                                                        persenYTD = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                                    listReport.add(sesReport);
                                                                                                                    totSubORev = 0;
                                                                                                                }

                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    balanceHeader = new Hashtable();
                                                                                                                    ytd = 0;
                                                                                                                    balanceHeader = amounts;
                                                                                                                    ytd = tmpYTD;
                                                                                                                }
                                                                                                                status = coa.getStatus();
                                                                                                                sesReport = new SesReportBs();
                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                vSesDep = new Vector();
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                double totAmount = tmpYTD;
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                                }
                                                                                                                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                    Periode p = (Periode) temp.get(ix);

                                                                                                                    double amount = 0;
                                                                                                                    try {
                                                                                                                        amount = Double.parseDouble("" + amounts.get("" + p.getOID()));
                                                                                                                    } catch (Exception e) {
                                                                                                                        amount = 0;
                                                                                                                    }

                                                                                                                    //if ((p.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                    //    totAmount = totAmount + amount;
                                                                                                                    //}

                                                                                                                    vSesDep.add("" + amount);

                                                                                                                    if (!coa.getStatus().equals("HEADER")) {
                                                                                                                        totalORev[ix] = totalORev[ix] + amount;
                                                                                                                    }

                                                                                                                    double persen = 0;

                                                                                                                    if (balanceHeader != null) {
                                                                                                                        double amountHeader = 0;
                                                                                                                        try {
                                                                                                                            amountHeader = totalRev[ix];
                                                                                                                        } catch (Exception e) {
                                                                                                                            amountHeader = 0;
                                                                                                                        }

                                                                                                                        if (amountHeader != 0) {
                                                                                                                            persen = (amount / amountHeader) * 100;
                                                                                                                        }
                                                                                                                    }
                                                                                                                    if (persen < 0) {
                                                                                                                        persen = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>
                                                                                                <%
                                                                                                                vSesDep.add("" + totAmount);
                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totORev = totORev + totAmount;
                                                                                                                    totSubORev = totSubORev + totAmount;
                                                                                                                }%>
                                                                                            </td>
                                                                                            <%
                                                                                                                double persenYTD = 0;
                                                                                                                if (totRev != 0) {
                                                                                                                    persenYTD = (totAmount / totRev) * 100;
                                                                                                                }

                                                                                                                if (persenYTD < 0) {
                                                                                                                    persenYTD = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                                sesReport.setAmount(totAmount);
                                                                                                                sesReport.setStrAmount("" + totAmount);
                                                                                                                listReport.add(sesReport);
                                                                                                            }
                                                                                                        } else {

                                                                                                            if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Group Level");
                                                                                        sesReport.setDescription(nameHeader);
                                                                                        sesReport.setFont(2);
                                                                                        vSesDep = new Vector();
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode p = (Periode) temp.get(ix);
                                                                                            double amount = 0;
                                                                                            try {
                                                                                                amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                            } catch (Exception e) {
                                                                                                amount = 0;
                                                                                            }
                                                                                            double persen = 0;
                                                                                            vSesDep.add("" + amount);
                                                                                            if (balanceHeader != null) {
                                                                                                double amountHeader = 0;
                                                                                                try {
                                                                                                    amountHeader = totalRev[ix];
                                                                                                } catch (Exception e) {
                                                                                                    amountHeader = 0;
                                                                                                }

                                                                                                if (amountHeader != 0) {
                                                                                                    persen = (amount / amountHeader) * 100;
                                                                                                }
                                                                                            }

                                                                                            if (persen < 0) {
                                                                                                persen = 0;
                                                                                            }
                                                                                            vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                        ytd = totSubORev;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep.add("" + ytd);

                                                                                        double persenYTD = 0;
                                                                                        if (totRev != 0) {
                                                                                            persenYTD = (ytd / totRev) * 100;
                                                                                        }

                                                                                        if (persenYTD < 0) {
                                                                                            persenYTD = 0;
                                                                                        }

                                                                                        vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                listReport.add(sesReport);
                                                                                                                totSubORev = 0;
                                                                                                            }
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                balanceHeader = new Hashtable();
                                                                                                                ytd = 0;
                                                                                                                balanceHeader = amounts;
                                                                                                                ytd = tmpYTD;
                                                                                                            }
                                                                                                            status = coa.getStatus();

                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            double totAmount = tmpYTD;

                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap>
                                                                                                <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                            }

                                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);

                                                                                                                double amount = 0;
                                                                                                                try {
                                                                                                                    amount = Double.parseDouble("" + amounts.get("" + per.getOID()));
                                                                                                                } catch (Exception e) {
                                                                                                                    amount = 0;
                                                                                                                }

                                                                                                                //if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                //    totAmount = totAmount + amount;
                                                                                                                //}

                                                                                                                vSesDep.add("" + amount);

                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totalORev[ix] = totalORev[ix] + amount;
                                                                                                                }

                                                                                                                double persen = 0;

                                                                                                                if (balanceHeader != null) {
                                                                                                                    double amountHeader = 0;
                                                                                                                    try {
                                                                                                                        amountHeader = totalRev[ix];
                                                                                                                    } catch (Exception e) {
                                                                                                                        amountHeader = 0;
                                                                                                                    }

                                                                                                                    if (amountHeader != 0) {
                                                                                                                        persen = (amount / amountHeader) * 100;
                                                                                                                    }

                                                                                                                }
                                                                                                                if (persen < 0) {
                                                                                                                    persen = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>  
                                                                                                <%if (!coa.getStatus().equals("HEADER")) {
                                                                                                                totORev = totORev + totAmount;
                                                                                                                totSubORev = totSubORev + totAmount;
                                                                                                            }
                                                                                                            vSesDep.add("" + totAmount);
                                                                                                %>
                                                                                                
                                                                                            </td>
                                                                                            <%
                                                                                                            double persenYTD = 0;
                                                                                                            if (totRev != 0) {
                                                                                                                persenYTD = (totAmount / totRev) * 100;
                                                                                                            }

                                                                                                            if (persenYTD < 0) {
                                                                                                                persenYTD = 0;
                                                                                                            }

                                                                                                            vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;" nowrap>
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(totAmount);
                                                                                                            sesReport.setStrAmount("" + totAmount);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }

                                                                                                    if ((i == listCoa.size() - 1) && coa.getStatus().equals("POSTABLE")) {
                                                                                        %>
                                                                                        
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(nameHeader);
                                                                                    sesReport.setFont(2);
                                                                                    vSesDep = new Vector();

                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                        double amount = 0;
                                                                                        try {
                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                        } catch (Exception e) {
                                                                                            amount = 0;
                                                                                        }
                                                                                        double persen = 0;
                                                                                        vSesDep.add("" + amount);

                                                                                        if (balanceHeader != null) {
                                                                                            double amountHeader = 0;
                                                                                            try {
                                                                                                amountHeader = totalRev[ix];
                                                                                            } catch (Exception e) {
                                                                                                amountHeader = 0;
                                                                                            }

                                                                                            if (amountHeader != 0) {
                                                                                                persen = (amount / amountHeader) * 100;
                                                                                            }
                                                                                        }

                                                                                        if (persen < 0) {
                                                                                            persen = 0;
                                                                                        }


                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                    ytd = totSubORev;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                    double persenYTD = 0;
                                                                                    if (totRev != 0) {
                                                                                        persenYTD = (ytd / totRev) * 100;
                                                                                    }

                                                                                    if (persenYTD < 0) {
                                                                                        persenYTD = 0;
                                                                                    }

                                                                                    vSesDep.add("" + ytd);
                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                        listReport.add(sesReport);
                                                                                                        totSubORev = 0;
                                                                                                    }
                                                                                                }				//add footer level



                                                                                        %>
                                                                                        
                                                                                        
                                                                                        <%

                                                                                                if (groupRev != 0 || valShowList != 1) {	//add Group Footer                                                                                                
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                    sesReport.setDescription("GRAND TOTAL " + I_Project.ACC_GROUP_OTHER_REVENUE.toUpperCase());
                                                                                                    sesReport.setFont(2);
                                                                                                    vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><font color="#F60"><b><i><%="GRAND TOTAL " + I_Project.ACC_GROUP_OTHER_REVENUE.toUpperCase()%></i></b></font></td>
                                                                                            <%
                                                                                                                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                                                                                                vSesDep.add("" + totalORev[ix]);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totalORev[ix], coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totalRev[ix] != 0) {
                                                                                                    vSesDep.add("" + (totalORev[ix] / totalRev[ix]) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totalORev[ix] / totalRev[ix]) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>  
                                                                                                </font>
                                                                                            </td>                                                                                            
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totORev, coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <%
                                                                                                                                                                                            vSesDep.add("" + totORev);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totRev != 0) {
                                                                                                                                                                                                vSesDep.add("" + (totORev / totRev) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totORev / totRev) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>                                                                                                
                                                                                                </font>
                                                                                            </td>                                                                                             
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            sesReport.setAmount(totExp);
            sesReport.setStrAmount("" + totExp);
            sesReport.setDepartment(vSesDep);
            listReport.add(sesReport);
        }
    }
    if (groupRev != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
        }
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>                                                                                        
                                                                                        <%}%>  
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>                                                                                        
                                                                                        <%

    sesReport = new SesReportBs();
    sesReport.setType("Group Level");
    sesReport.setDescription("NETT OF OPERATING PROFITS MARGIN");
    sesReport.setFont(2);
    vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablecell" ><font color="#F60"><i><b>NETT OF OPERATING PROFITS MARGIN</b></i></font></td>
                                                                                            <%
    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
        Periode p = (Periode) temp.get(ix);
        double amount = 0;
        try {
            amount = totalRev[ix] - totalCOS[ix] - totalExp[ix] + totalORev[ix];
        } catch (Exception e) {
            amount = 0;
        }
        vSesDep.add("" + amount);
        double persen = 0;

        double amountHeader = 0;
        try {
            amountHeader = totalRev[ix];
        } catch (Exception e) {
            amountHeader = 0;
        }

        if (amountHeader != 0) {
            persen = (amount / amountHeader) * 100;
        }

        if (persen < 0) {
            persen = 0;
        }

        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totRev - totCOS - totExp + totORev), "###,###.##")%></i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <%
    vSesDep.add("" + (totRev - totCOS - totExp + totORev));
    double persenYTDx = 0;
    if (totRev != 0) {
        persenYTDx = ((totRev - totCOS - totExp + totORev) / totRev) * 100;
    }

    if (persenYTDx < 0) {
        persenYTDx = 0;
    }

    vSesDep.add("" + persenYTDx);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTDx, "###,###.##")%>%</i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                        </tr>      
                                                                                        <%
    sesReport.setDepartment(vSesDep);
    listReport.add(sesReport);

                                                                                        %>
                                                                                        <%
    if (true) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
        }
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>   
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%> 
                                                                                        <!--level ACC_OTHER EXPENSE-->
                                                                                        <%
    listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " ='Other Expense'", DbCoa.colNames[DbCoa.COL_CODE]);
    double groupOtherExpense = SessGeneratePNL.getIsCoaBalance(listCoa, temp, segment1Id);

    if (groupOtherExpense != 0 || valShowList != 1) {//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_OTHER_EXPENSE);
        sesReport.setFont(1);
        vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_EXPENSE.toUpperCase()%></b></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                vSesDep.add("0");
                                                                                                vSesDep.add("0");
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}
                                                                                            vSesDep.add("0");
                                                                                            vSesDep.add("0");
                                                                                            sesReport.setDepartment(vSesDep);
                                                                                            listReport.add(sesReport);
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>
                                                                                        <%

    }

    if (listCoa != null && listCoa.size() > 0) {
        String str = "";
        String str1 = "";
        Hashtable balanceHeader = new Hashtable();
        double ytd = 0;

        String nameHeader = "";
        String status = "";
        int levelStatus = 0;

        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);
            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                if (status == "") {
                    status = coa.getStatus();
                    nameHeader = coa.getName();
                    levelStatus = coa.getLevel();
                }

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());

                double amountBalance = 0;
                Hashtable amounts = new Hashtable();
                double tmpYTD = SessGeneratePNL.getAmountLTB(coa, segment1Id, period);
                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                    Periode p = (Periode) temp.get(ix);
                    double amount = SessGeneratePNL.getCoaBalancePNLMTD(coa, segment1Id, p);
                    if (amount != 0) {
                        amountBalance = amount;
                    }
                    //tmpYTD = tmpYTD + amount;
                    amounts.put("" + p.getOID(), "" + amount);
                }


                if (valShowList == 1) {
                    if (amountBalance != 0 || tmpYTD != 0) {	//add detail
                        //Royif (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                        if (levelStatus > coa.getLevel()) {
                            sesReport = new SesReportBs();
                            sesReport.setType("Group Level");
                            sesReport.setDescription(nameHeader);
                            sesReport.setFont(2);
                            vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                                                        double amount = 0;
                                                                                                                        try {
                                                                                                                            amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                                                        } catch (Exception e) {
                                                                                                                            amount = 0;
                                                                                                                        }
                                                                                                                        vSesDep.add("" + amount);
                                                                                                                        double persen = 0;

                                                                                                                        if (balanceHeader != null) {
                                                                                                                            double amountHeader = 0;
                                                                                                                            try {
                                                                                                                                amountHeader = totalOExp[ix];
                                                                                                                            } catch (Exception e) {
                                                                                                                                amountHeader = 0;
                                                                                                                            }

                                                                                                                            if (amountHeader != 0) {
                                                                                                                                persen = (amount / amountHeader) * 100;
                                                                                                                            }
                                                                                                                        }

                                                                                                                        if (persen < 0) {
                                                                                                                            persen = 0;
                                                                                                                        }

                                                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                                                    ytd = totSubOExp;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                                                    vSesDep.add("" + ytd);
                                                                                                                    double persenYTD = 0;
                                                                                                                    if (totRev != 0) {
                                                                                                                        persenYTD = (ytd / totRev) * 100;
                                                                                                                    }

                                                                                                                    if (persenYTD < 0) {
                                                                                                                        persenYTD = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                    sesReport.setDepartment(vSesDep);
                                                                                                                    listReport.add(sesReport);
                                                                                                                    totSubOExp = 0;
                                                                                                                }

                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    balanceHeader = new Hashtable();
                                                                                                                    ytd = 0;
                                                                                                                    balanceHeader = amounts;
                                                                                                                    ytd = tmpYTD;
                                                                                                                }
                                                                                                                status = coa.getStatus();
                                                                                                                levelStatus = coa.getLevel();
                                                                                                                sesReport = new SesReportBs();
                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                                vSesDep = new Vector();
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                double totAmount = tmpYTD;
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                                if (coa.getStatus().equals("HEADER")) {
                                                                                                                    nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                                }
                                                                                                                for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                    Periode p = (Periode) temp.get(ix);

                                                                                                                    double amount = 0;
                                                                                                                    try {
                                                                                                                        amount = Double.parseDouble("" + amounts.get("" + p.getOID()));
                                                                                                                    } catch (Exception e) {
                                                                                                                        amount = 0;
                                                                                                                    }

                                                                                                                    //if ((p.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                    //    totAmount = totAmount + amount;
                                                                                                                    //}

                                                                                                                    vSesDep.add("" + amount);
                                                                                                                    if (!coa.getStatus().equals("HEADER")) {
                                                                                                                        totalOExp[ix] = totalOExp[ix] + amount;
                                                                                                                    }

                                                                                                                    double persen = 0;

                                                                                                                    if (balanceHeader != null) {
                                                                                                                        double amountHeader = 0;
                                                                                                                        try {
                                                                                                                            amountHeader = totalRev[ix];
                                                                                                                        } catch (Exception e) {
                                                                                                                            amountHeader = 0;
                                                                                                                        }

                                                                                                                        if (amountHeader != 0) {
                                                                                                                            persen = (amount / amountHeader) * 100;
                                                                                                                        }
                                                                                                                    }
                                                                                                                    if (persen < 0) {
                                                                                                                        persen = 0;
                                                                                                                    }

                                                                                                                    vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%}%>	
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>
                                                                                                <%
                                                                                                                vSesDep.add("" + totAmount);
                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totOExp = totOExp + totAmount;
                                                                                                                    totSubOExp = totSubOExp + totAmount;
                                                                                                                }%>
                                                                                            </td>
                                                                                            <%
                                                                                                                double persenYTD = 0;
                                                                                                                if (totRev != 0) {
                                                                                                                    persenYTD = (totAmount / totRev) * 100;
                                                                                                                }


                                                                                                                if (persenYTD < 0) {
                                                                                                                    persenYTD = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                                sesReport.setAmount(totAmount);
                                                                                                                sesReport.setStrAmount("" + totAmount);
                                                                                                                listReport.add(sesReport);
                                                                                                            }
                                                                                                        } else {

                                                                                                            //if (status.equals("POSTABLE") && coa.getStatus().equals("HEADER")) {
                                                                                                            if (levelStatus > coa.getLevel()) {
                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b><%=nameHeader%></b></i></td>
                                                                                            <%
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Group Level");
                                                                                        sesReport.setDescription(nameHeader);
                                                                                        sesReport.setFont(2);
                                                                                        vSesDep = new Vector();
                                                                                        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                            Periode p = (Periode) temp.get(ix);
                                                                                            double amount = 0;
                                                                                            try {
                                                                                                amount = Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                            } catch (Exception e) {
                                                                                                amount = 0;
                                                                                            }
                                                                                            double persen = 0;
                                                                                            vSesDep.add("" + amount);
                                                                                            if (balanceHeader != null) {
                                                                                                double amountHeader = 0;
                                                                                                try {
                                                                                                    amountHeader = totalRev[ix];
                                                                                                } catch (Exception e) {
                                                                                                    amountHeader = 0;
                                                                                                }

                                                                                                if (amountHeader != 0) {
                                                                                                    persen = (amount / amountHeader) * 100;
                                                                                                }
                                                                                            }
                                                                                            if (persen < 0) {
                                                                                                persen = 0;
                                                                                            }

                                                                                            vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}
                                                                                        ytd = totSubOExp;
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(ytd, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep.add("" + ytd);

                                                                                        double persenYTD = 0;
                                                                                        if (totRev != 0) {
                                                                                            persenYTD = (ytd / totRev) * 100;
                                                                                        }

                                                                                        if (persenYTD < 0) {
                                                                                            persenYTD = 0;
                                                                                        }
                                                                                        vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                        <%
                                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                                listReport.add(sesReport);
                                                                                                                totSubOExp = 0;
                                                                                                            }
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                balanceHeader = new Hashtable();
                                                                                                                ytd = 0;
                                                                                                                balanceHeader = amounts;
                                                                                                                ytd = tmpYTD;
                                                                                                            }
                                                                                                            status = coa.getStatus();
                                                                                                            levelStatus = coa.getLevel();
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            double totAmount = tmpYTD;

                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap>
                                                                                                <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%
                                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                                nameHeader = strTotal + str + "TOTAL " + coa.getName().toUpperCase();
                                                                                                            }

                                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                Periode per = (Periode) temp.get(ix);

                                                                                                                double amount = 0;
                                                                                                                try {
                                                                                                                    amount = Double.parseDouble("" + amounts.get("" + per.getOID()));
                                                                                                                } catch (Exception e) {
                                                                                                                    amount = 0;
                                                                                                                }

                                                                                                                //if ((per.getEndDate().getYear() + 1900) == yearx) {
                                                                                                                //    totAmount = totAmount + amount;
                                                                                                                //}

                                                                                                                vSesDep.add("" + amount);

                                                                                                                if (!coa.getStatus().equals("HEADER")) {
                                                                                                                    totalOExp[ix] = totalOExp[ix] + amount;
                                                                                                                }

                                                                                                                double persen = 0;

                                                                                                                if (balanceHeader != null) {
                                                                                                                    double amountHeader = 0;
                                                                                                                    try {
                                                                                                                        amountHeader = totalRev[ix];
                                                                                                                    } catch (Exception e) {
                                                                                                                        amountHeader = 0;
                                                                                                                    }

                                                                                                                    if (amountHeader != 0) {
                                                                                                                        persen = (amount / amountHeader) * 100;
                                                                                                                    }

                                                                                                                }
                                                                                                                if (persen < 0) {
                                                                                                                    persen = 0;
                                                                                                                }

                                                                                                                vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(amount, coa.getStatus(), onlyHeader)%></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><%=strDisplay(persen, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><%=strDisplay(totAmount, coa.getStatus(), onlyHeader)%></div>  
                                                                                                <%if (!coa.getStatus().equals("HEADER")) {
                                                                                                                totOExp = totOExp + totAmount;
                                                                                                                totSubOExp = totSubOExp + totAmount;
                                                                                                            }
                                                                                                            vSesDep.add("" + totAmount);
                                                                                                %>
                                                                                                
                                                                                            </td>
                                                                                            <%
                                                                                                            double persenYTD = 0;
                                                                                                            if (totRev != 0) {
                                                                                                                persenYTD = (totAmount / totRev) * 100;
                                                                                                            }
                                                                                                            if (persenYTD < 0) {
                                                                                                                persenYTD = 0;
                                                                                                            }

                                                                                                            vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;" nowrap>
                                                                                                <div align="right"><%=strDisplay(persenYTD, coa.getStatus(), onlyHeader)%><%if (!coa.getStatus().equals("HEADER")) {%>%<%}%></div>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%
                                                                                                            sesReport.setAmount(totAmount);
                                                                                                            sesReport.setStrAmount("" + totAmount);
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }

                                                                                                    if ((i == listCoa.size() - 1) && coa.getStatus().equals("POSTABLE")) {
                                                                                        %>
                                                                                        
                                                                                        <tr height="24"> 
                                                                                            <td class="<%=cssString%>" align="center"><i><b>TOTAL BIAYA LAIN-LAIN</b></i></td>
                                                                                            <%
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription("TOTAL BIAYA LAIN-LAIN");
                                                                                    sesReport.setFont(2);
                                                                                    vSesDep = new Vector();

                                                                                    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                        Periode p = (Periode) temp.get(ix);
                                                                                        double amount = 0;
                                                                                        try {
                                                                                            amount = totalOExp[ix];//Double.parseDouble("" + balanceHeader.get("" + p.getOID()));
                                                                                        } catch (Exception e) {
                                                                                            amount = 0;
                                                                                        }
                                                                                        double persen = 0;
                                                                                        vSesDep.add("" + amount);

                                                                                        if (balanceHeader != null) {
                                                                                            double amountHeader = 0;
                                                                                            try {
                                                                                                amountHeader = totalRev[ix];
                                                                                            } catch (Exception e) {
                                                                                                amountHeader = 0;
                                                                                            }

                                                                                            if (amountHeader != 0) {
                                                                                                persen = (amount / amountHeader) * 100;
                                                                                            }
                                                                                        }
                                                                                        if (persen < 0) {
                                                                                            persen = 0;
                                                                                        }

                                                                                        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">                                                                                                
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(totOExp, "###,###.##")%></i></b></div>
                                                                                            </td>
                                                                                            <%
                                                                                    double persenYTD = 0;
                                                                                    if (totRev != 0) {
                                                                                        persenYTD = (totOExp / totRev) * 100;
                                                                                    }
                                                                                    if (persenYTD < 0) {
                                                                                        persenYTD = 0;
                                                                                    }

                                                                                    vSesDep.add("" + ytd);
                                                                                    vSesDep.add("" + persenYTD);
                                                                                            %>
                                                                                            <td class="<%=cssString%>" style="padding:5px;">
                                                                                                <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTD, "###,###.##")%>%</i></b></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%

                                                                                                        sesReport.setDepartment(vSesDep);
                                                                                                        listReport.add(sesReport);
                                                                                                    }
                                                                                                }				//add footer level



                                                                                        %>
                                                                                        
                                                                                        
                                                                                        <%

                                                                                                if (groupRev != 0 || valShowList != 1) {	//add Group Footer                                                                                                
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                    sesReport.setDescription("GRAND TOTAL " + I_Project.ACC_GROUP_OTHER_EXPENSE.toUpperCase());
                                                                                                    sesReport.setFont(2);
                                                                                                    vSesDep = new Vector();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell" ><font color="#F60"><b><i><%="GRAND TOTAL " + I_Project.ACC_GROUP_OTHER_EXPENSE.toUpperCase()%></i></b></font></td>
                                                                                            <%
                                                                                                                                                                                            for (int ix = (temp.size() - 1); ix >= 0; ix--) {
                                                                                                                                                                                                vSesDep.add("" + totalOExp[ix]);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totalOExp[ix], coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totalRev[ix] != 0) {
                                                                                                    vSesDep.add("" + (totalOExp[ix] / totalRev[ix]) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totalOExp[ix] / totalRev[ix]) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>  
                                                                                                </font>
                                                                                            </td>                                                                                            
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                <div align="right"><b><i><%=strDisplay(totOExp, coa.getStatus(), onlyHeader)%></i></b></div>
                                                                                            </td>  
                                                                                            <%
                                                                                                                                                                                            vSesDep.add("" + totOExp);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <%if (totRev != 0) {
                                                                                                                                                                                                vSesDep.add("" + (totOExp / totRev) * 100);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totOExp / totRev) * 100, "###,###.##")%>%</i></b></div>
                                                                                                    <%} else {
    vSesDep.add("" + 0);
                                                                                                    %>
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(0.00, "###,###.##")%>%</i></b></div>
                                                                                                    <%}%>                                                                                                
                                                                                                </font>
                                                                                            </td>                                                                                             
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            sesReport.setAmount(totOExp);
            sesReport.setStrAmount("" + totOExp);
            sesReport.setDepartment(vSesDep);
            listReport.add(sesReport);
        }
    }

    if (groupOtherExpense != 0) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        sesReport.setFont(1);
        vSesDep = new Vector();
        for (int ix = (temp.size() - 1); ix >= 0; ix--) {
            vSesDep.add("0");
            vSesDep.add("0");
        }
        vSesDep.add("0");
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        listReport.add(sesReport);
                                                                                        %>   
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = (temp.size() - 1); ix >= 0; ix--) {%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%> 
                                                                                        
                                                                                        
                                                                                        
                                                                                        <%

    sesReport = new SesReportBs();
    sesReport.setType("Group Level");
    sesReport.setDescription("NETT  PROFIT  &  LOSS AFTER  TAX");
    sesReport.setFont(2);
    vSesDep = new Vector();

                                                                                        %>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablecell" ><font color="#F60"><i><b>NETT  PROFIT  &  LOSS AFTER  TAX</b></i></font></td>
                                                                                            <%
    for (int ix = (temp.size() - 1); ix >= 0; ix--) {
        Periode p = (Periode) temp.get(ix);
        double amount = 0;
        try {
            amount = totalRev[ix] - totalCOS[ix] - totalExp[ix] + totalORev[ix] - totalOExp[ix];
        } catch (Exception e) {
            amount = 0;
        }
        vSesDep.add("" + amount);
        double persen = 0;

        double amountHeader = 0;
        try {
            amountHeader = totalRev[ix];
        } catch (Exception e) {
            amountHeader = 0;
        }

        if (amountHeader != 0) {
            persen = (amount / amountHeader) * 100;
        }

        if (persen < 0) {
            persen = 0;
        }

        vSesDep.add("" + persen);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(amount, "###,###.##")%></i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(persen, "###,###.##")%>%</i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <%}%>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber((totRev - totCOS - totExp + totORev - totOExp), "###,###.##")%></i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                            <%
    vSesDep.add("" + (totRev - totCOS - totExp + totORev - totOExp));
    double persenYTDy = 0;
    if (totRev != 0) {
        persenYTDy = ((totRev - totCOS - totExp + totORev - totOExp) / totRev) * 100;
    }

    if (persenYTDy < 0) {
        persenYTDy = 0;
    }
    vSesDep.add("" + persenYTDy);
    sesReport.setDepartment(vSesDep);
    listReport.add(sesReport);
                                                                                            %>
                                                                                            <td class="tablecell" style="padding:5px;"><font color="#F60">                                                                                                
                                                                                                    <div align="right"><b><i><%=JSPFormater.formatNumber(persenYTDy, "###,###.##")%>%</i></b></div>
                                                                                                </font>
                                                                                            </td>
                                                                                        </tr> 
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td colspan="3" height="3" class="fontarial">&nbsp;<i><%=langNav[4]%> ..</i></td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <%
            session.putValue("PROFIT_MULTIPLE_GEN", listReport);
            session.putValue("PERIODE_MULTIPLE_MTD_GEN", temp);
            session.putValue("SEGMENT1MTDIDMULTIPLE_GEN", "" + segment1Id);
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
                                                            <script language="JavaScript">
                                                                document.all.closecmd.style.display="";
                                                                document.all.closemsg.style.display="none";
                                                            </script>
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
