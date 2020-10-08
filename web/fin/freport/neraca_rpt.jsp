
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
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_NERACA, AppMenu.PRIV_DELETE);
%>
<%!
    public String getFormated(double amount, boolean isBold, String CURRFORMAT) {

        if (amount >= 0) {
            return (isBold) ? "<b>" + JSPFormater.formatNumber(amount, CURRFORMAT) + "</b>" : JSPFormater.formatNumber(amount, CURRFORMAT);
        } else {
            return (isBold) ? "<b>(" + JSPFormater.formatNumber(amount * -1, CURRFORMAT) + ")</b>" : "(" + JSPFormater.formatNumber(amount * -1, CURRFORMAT) + ")";
        }
    }

%>
<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");
            String var = JSPRequestValue.requestStringExcTitikKoma(request, "hidden_var");
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            int reportRange = JSPRequestValue.requestInt(request, "report_range");
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            int selFormat = JSPRequestValue.requestInt(request, "rpt_format");
            boolean isGereja = DbSystemProperty.getModSysPropGereja();
            String whereMd = "";
            String oidMd = "";
            Vector actPeriods = DbActivityPeriod.list(0, 0, "", "");
            if (vSeg != null && vSeg.size() > 0) {

                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {

                    //Segment obSegment = (Segment) vSeg.get(iSeg);
                    int pg = iSeg + 1;
                    long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");
                    oidMd = oidMd + ";" + segment_id;

                    if (whereMd.length() > 0) {
                        whereMd = whereMd + " and ";
                    }
                    if (iSeg == 0) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
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

            System.out.println(" where MD " + whereMd);

            String currFormat = "#,###";

            session.removeValue("NERACA_RPT");

            Vector rptResult = new Vector();

            RptFormat rptFormat = new RptFormat();

            String title = "";
            try {
                rptFormat = DbRptFormat.fetchExc(oidRptFormat);
                title = rptFormat.getReportTitle();
            } catch (Exception e) {
            }

            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            Vector rptDetails = DbRptFormatDetail.list(0, 0, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_RPT_FORMAT_ID] + "=" + oidRptFormat, DbRptFormatDetail.colNames[DbRptFormatDetail.COL_SQUENCE]);

            rptResult.add(periods);
            rptResult.add(rptDetails);

            session.putValue("NERACA_RPT", rptResult);

            Company company = DbCompany.getCompany();

            Periode period = DbPeriode.getOpenPeriod();
            if (periodId != 0) {
                try {
                    period = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }
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

            /*** LANG ***/
            String[] langFR = {"Period", "PER", "AND", "NO", "DESCRIPTION", "REALIZATION", "BUDGET", "AGAINST"}; //0-7
            String[] langNav = {"Financial Report", "Balance Sheet"};

            if (lang == LANG_ID) {
                String[] langID = {"Periode", "PER", "DAN", "NO", "URAIAN", "REALISASI", "ANGGARAN", "TERHADAP"};
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Neraca"};
                langNav = navID;
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
        <%if (selFormat == 1) {%>
        //alert("in");
        //window.location="neraca_rpt_mth.jsp?rpt_format_id=<%//=oidRptFormat%>//&period_id=<%//=periodId%>//&rpt_format=<%//=selFormat%>//";
        <%}%>
        
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>            
        
        function cmdGO(){
            document.frmneraca.action="neraca_rpt.jsp";
            document.frmneraca.submit();
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
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                        <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                        <td><!-- #BeginEditable "content" --> 
                            <form id="form1" name="frmneraca" method="post" action="">
                            <input type="hidden" name="command">
                            <input type="hidden" name="rpt_format_id" value="<%=oidRptFormat%>">
                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
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
                                                <td colspan="4">
                                                <table border="0">
                                                <%if (isGereja || (vSeg != null && vSeg.size() > 0)){%>
                                                <%
    if (vSeg != null && vSeg.size() > 0){

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
                                                    <td ><%=oSegment.getName()%></td>
                                                    <td >
                                                        <%
                                                        String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + oSegment.getOID();

                                                        switch (xs + 1) {
                                                            case 1:
                                                                //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                                                                //maka akan di tampikan sesuai dengan segment yang ditentukan
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
                                                        Vector segDet = DbSegmentDetail.list(0, 0, wh, "");
                                                        %>
                                                        <select name="JSP_SEGMENT<%=xs + 1%>_ID" >
                                                            <%if (actPeriods != null && actPeriods.size() > 0) {
                                                            for (int i = 0; i < segDet.size(); i++) {
                                                                SegmentDetail ap = (SegmentDetail) segDet.get(i);
                                                            %>
                                                            <option value="<%=ap.getOID()%>" <%if (ap.getOID() == seg_id) {%>selected<%}%>><%=ap.getName()%></option>
                                                            <%
                                                            }
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
                                                <%}%>
                                                <td height="5"><%=langFR[0]%></td>
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
                                                    <input type="button" name="Button" value="GO" onClick="javascript:cmdGO()">
                                                </td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                            </tr>   
                                        </table>
                                    </td>
                                </tr>
                                <tr> 
                                    <td width="7%" nowrap height="23"><b></b></td>                                    
                                    <td width="19%" height="23" nowrap></td>
                                    <td width="41%" height="23"> 
                                        <div align="center"><b><%=company.getName().toUpperCase()%></b></div>
                                    </td>
                                    <td width="33%" height="23">&nbsp;</td>
                                </tr>
                                <tr> 
                                    <td width="7%" nowrap height="23"><b><%if (rptFormat.getReportType() == DbRptFormat.REPORT_TYPE_PROFITLOSS) {%>Format<%}%></b></td>
                                    <td width="19%" height="23">
                                        <%if (rptFormat.getReportType() == DbRptFormat.REPORT_TYPE_PROFITLOSS) {%>                                          
                                        <select name="rpt_format">
                                            <option value="0" <%if (selFormat == 0) {%>selected<%}%>>MTD Format</option>
                                            <option value="1" <%if (selFormat == 1) {%>selected<%}%>>MTD &amp; YTD Format</option>
                                        </select>
                                        <%}%>
                                    </td>
                                    <td width="41%" height="23"> 
                                        <div align="center"><b><%=title.toUpperCase()%></b></div>
                                    </td>
                                    <td width="33%" height="23">&nbsp;</td>
                                </tr>
                                <tr> 
                                    <td width="7%" nowrap height="23"><b>&nbsp;</b></td>
                                    <td width="19%" height="23">&nbsp; </td>
                                    <td width="41%" height="23"> 
                                        <div align="center"><b><%=langFR[1]%> <%=(JSPFormater.formatDate(dtx, "dd MMM yyyy")).toUpperCase()%> <%=langFR[2]%> <%=(JSPFormater.formatDate(reportDate, "dd MMM yyyy")).toUpperCase()%></b></div>
                                    </td>
                                    <td width="33%" height="23">&nbsp;</td>
                                </tr>
                                <tr> 
                                    <td colspan="4" height="3"></td>
                                </tr>
                            </table>
                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                <tr> 
                                    <td rowspan="2" class="tablehdr"><%=langFR[3]%></td>
                                    <td rowspan="2" class="tablehdr"><%=langFR[4]%></td>
                                    <td rowspan="2" class="tablehdr"><%=langFR[5]%><br><%=langFR[1]%><br><%=JSPFormater.formatDate(dtx, "dd MMM yyyy")%></td>
                                    <td rowspan="2" class="tablehdr"><%=langFR[6]%><br><%=langFR[1]%><br><%=JSPFormater.formatDate(reportDate, "dd MMM yyyy")%></td>
                                    <td rowspan="2" class="tablehdr"><%=langFR[5]%><br><%=langFR[1]%><br><%=JSPFormater.formatDate(reportDate, "dd MMM yyyy")%></td>
                                    <td colspan="2" class="tablehdr" height="24">% <%=langFR[7]%></td>
                                </tr>
                                <tr> 
                                    <td width="9%" class="tablehdr"><%=JSPFormater.formatDate(dtx, "yyyy")%></td>
                                    <td width="8%" class="tablehdr"><%=langFR[6]%></td>
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
                                    <td width="16%" height="3"> 
                                        <div align="center"><b>4</b></div>
                                    </td>
                                    <td width="17%" height="3"> 
                                        <div align="center"><b>5</b></div>
                                    </td>
                                    <td width="9%" height="3"> 
                                        <div align="center"><b>5:3</b></div>
                                    </td>
                                    <td width="8%" height="3"> 
                                        <div align="center"><b>5:4</b></div>
                                    </td>
                                </tr>
                                <%if (rptDetails != null && rptDetails.size() > 0) {

                int seq = 0;

                for (int i = 0; i < rptDetails.size(); i++) {

                    boolean isBold = false;

                    seq = seq + 1;

                    RptFormatDetail rpd = (RptFormatDetail) rptDetails.get(i);

                    int count = DbRptFormatDetail.getCount(DbRptFormatDetail.colNames[DbRptFormatDetail.COL_REF_ID] + "=" + rpd.getOID());
                    int countCoas = DbRptFormatDetailCoa.getCount(DbRptFormatDetailCoa.colNames[DbRptFormatDetailCoa.COL_RPT_FORMAT_DETAIL_ID] + "=" + rpd.getOID());

                    String level = "";
                    if (rpd.getLevel() == 1) {
                        level = "<img src=\"../images/spacer.gif\" width=\"20\" height=\"1\">";
                    } else if (rpd.getLevel() == 2) {                        
                        level = "<img src=\"../images/spacer.gif\" width=\"30\" height=\"1\">";
                    } else if (rpd.getLevel() == 3) {                        
                        level = "<img src=\"../images/spacer.gif\" width=\"40\" height=\"1\">";
                    } else if (rpd.getLevel() == 4) {                        
                        level = "<img src=\"../images/spacer.gif\" width=\"50\" height=\"1\">";
                    } else if (rpd.getLevel() == 5) {                        
                        level = "<img src=\"../images/spacer.gif\" width=\"60\" height=\"1\">";
                    } else if (rpd.getLevel() == 6) {                        
                        level = "<img src=\"../images/spacer.gif\" width=\"70\" height=\"1\">";
                    } else if (rpd.getLevel() == 7) {
                        level = "<img src=\"../images/spacer.gif\" width=\"80\" height=\"1\">";
                    }

                    double amountLY = 0;
                    double budgetTY = 0;
                    double amountTY = 0;
                    
                    if (isGereja){
                        amountLY = DbGlDetail.getRealisasiLastYear(rpd.getOID(), period, whereMd);
                        budgetTY = DbCoaBudget.getRealisasiCurrentYear(rpd.getOID(), period);
                        amountTY = DbGlDetail.getRealisasiCurrentYear(rpd.getOID(), period, whereMd);
                    } else {
                        if(vSeg != null && vSeg.size() > 0){
                            amountLY = DbGlDetail.getRealisasiLastYear(rpd.getOID(), period, whereMd);
                            budgetTY = DbCoaBudget.getRealisasiCurrentYear(rpd.getOID(), period);
                            amountTY = DbGlDetail.getRealisasiCurrentYear(rpd.getOID(), period, whereMd);
                        }else{
                            amountLY = DbGlDetail.getRealisasiLastYear(rpd.getOID(), period);
                            budgetTY = DbCoaBudget.getRealisasiCurrentYear(rpd.getOID(), period);
                            amountTY = DbGlDetail.getRealisasiCurrentYear(rpd.getOID(), period);
                        }
                    }

                    if (rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) {
                        isBold = true;
                    }

                    if (rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) {

                        seq = seq - 1;
                                %>
                                <tr> 
                                    <td width="2%" height="1" bgcolor="#609836"></td>
                                    <td width="33%" height="1" bgcolor="#609836"></td>
                                    <td width="15%" height="1" bgcolor="#609836"></td>
                                    <td width="16%" height="1" bgcolor="#609836"></td>
                                    <td width="17%" height="1" bgcolor="#609836"></td>
                                    <td width="9%" height="1" bgcolor="#609836"></td>
                                    <td width="8%" height="1" bgcolor="#609836"></td>
                                </tr>
                                <%}%>
                                <tr> 
                                    <td width="2%" class="tablecell"> 
                                        <%
                                                    if (rpd.getType() != DbRptFormatDetail.RPT_TYPE_TOTAL) {
                                        %>
                                        <div align="center"><%=seq%></div>
                                        <%}%>
                                    </td>
                                    
                                    <td width="33%" class="tablecell" nowrap><%=((rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) ? "<b>" + level + rpd.getDescription() + "</b>" : (level + ((count > 0) ? "<b>" + rpd.getDescription() + "</b>" : rpd.getDescription())))%><%//=((rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) ? "<div align=\"center\"><b>" + rpd.getDescription() + "</b></div>" : (level + ((count > 0) ? "<b>" + rpd.getDescription() + "</b>" : rpd.getDescription())))%></td>
                                    <td width="15%" class="tablecell"> 
                                        <div align="right"><%=(countCoas > 0) ? getFormated(amountLY, isBold, CURRFORMAT) : ""%></div>
                                    </td>
                                    <td width="16%" class="tablecell"> 
                                        <div align="right"><%=(countCoas > 0) ? getFormated(budgetTY, isBold, CURRFORMAT) : ""%></div>
                                    </td>
                                    <td width="17%" class="tablecell"> 
                                        <div align="right"><%=(countCoas > 0) ? getFormated(amountTY, isBold, CURRFORMAT) : ""%></div>
                                    </td>
                                    <td width="9%" class="tablecell"> 
                                        <div align="center"><%=(countCoas > 0) ? getFormated((amountTY / amountLY) * 100, isBold, CURRFORMAT) : ""%></div>
                                    </td>
                                    <td width="8%" class="tablecell"> 
                                        <div align="center"><%=(countCoas > 0) ? getFormated((amountTY / budgetTY) * 100, isBold, CURRFORMAT) : ""%></div>
                                    </td>
                                </tr>
                                <%
                                                    if (rpd.getType() == DbRptFormatDetail.RPT_TYPE_TOTAL) {
                                %>
                                <tr> 
                                    <td width="2%" height="1" bgcolor="#609836"></td>
                                    <td width="33%" height="1" bgcolor="#609836"></td>
                                    <td width="15%" height="1" bgcolor="#609836"></td>
                                    <td width="16%" height="1" bgcolor="#609836"></td>
                                    <td width="17%" height="1" bgcolor="#609836"></td>
                                    <td width="9%" height="1" bgcolor="#609836"></td>
                                    <td width="8%" height="1" bgcolor="#609836"></td>
                                </tr>
                                <tr> 
                                    <td width="2%" height="10"></td>
                                    <td width="33%" height="10"></td>
                                    <td width="15%" height="10"></td>
                                    <td width="16%" height="10"></td>
                                    <td width="17%" height="10"></td>
                                    <td width="9%" height="10"></td>
                                    <td width="8%" height="10"></td>
                                </tr>
                                <%}
                }
            }%>
                                <tr> 
                                    <td width="2%">&nbsp;</td>
                                    <td width="33%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="16%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="8%">&nbsp;</td>
                                </tr>
                                <tr bgcolor="#609836"> 
                                    <td width="2%" height="3"></td>
                                    <td width="33%" height="3"></td>
                                    <td width="15%" height="3"></td>
                                    <td width="16%" height="3"></td>
                                    <td width="17%" height="3"></td>
                                    <td width="9%" height="3"></td>
                                    <td width="8%" height="3"></td>
                                </tr>
                                <tr> 
                                    <td width="2%">&nbsp;</td>
                                    <td width="33%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="16%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="8%">&nbsp;</td>
                                </tr>
                                <tr> 
                                    <td width="2%">&nbsp;</td>
                                    <td width="33%">&nbsp;</td>
                                    <td width="15%">&nbsp;</td>
                                    <td width="16%">&nbsp;</td>
                                    <td width="17%">&nbsp;</td>
                                    <td width="9%">&nbsp;</td>
                                    <td width="8%">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="7">
                                        <%
            out.print("<a href=\"../freport/print_neraca_rpt_priview.jsp?whereMd='" + whereMd + "'&rpt_format_id=" + oidRptFormat + "&period_id=" + periodId + "\"  onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");
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
