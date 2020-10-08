
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

            boolean isGereja = DbSystemProperty.getModSysPropGereja();
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            String whereMd = "";
            String oidMd = "";

            if (iJSPCommand == JSPCommand.NONE) {

                if (vSeg != null && vSeg.size() > 0) {
                    User usr = new User();
                    try {
                        usr = DbUser.fetch(appSessUser.getUserOID());
                    } catch (Exception e) {
                    }

                    for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {
                        Segment sg = (Segment) vSeg.get(iSeg);
                        String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + sg.getOID();

                        switch (iSeg + 1) {
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
                    }
                }
            }

            if (vSeg != null && vSeg.size() > 0 && iJSPCommand != JSPCommand.NONE) {

                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++){
                    int pg = iSeg + 1;
                    long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");
                    oidMd = oidMd + ";" + segment_id;

                    if (whereMd.length() > 0) {
                        whereMd = whereMd + " and ";
                    }
                    if (segment_id != 0) {
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
            }

            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            
            Company company = DbCompany.getCompany();
            
            Periode period = new Periode();
            if(periodId != 0){
                try{
                    period = DbPeriode.fetchExc(periodId);
                }catch(Exception e){}
            }else{
                period = DbPeriode.getOpenPeriod();
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
                System.out.println("----- periode 13 : yes");
                lastPeriod = DbPeriode.getLastYearPeriod13(period);
            }

            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

            /*** LANG ***/
            String[] langFR = {"Show List", "Account With Transaction", "All", "BALANCE SHEET", "PERIOD", //0-4
                "Description", "Total"}; //5-6
            String[] langNav = {"Financial Report", "Detail", "Balance Sheet", "Period", "Preview", "Location"};
            String title = "";

            try {
                title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA_EN");
            } catch (Exception e) {
            }

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "NERACA", "PERIODE", //0-4
                    "Keterangan", "Total"}; //5-6
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Penjelasan", "Neraca", "Periode", "Preview", "Lokasi"};
                langNav = navID;

                try {
                    title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA");
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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%> 
            
            function cmdGO(){
                document.form1.action="neraca_penjelasan.jsp";
                document.form1.command.value="<%=JSPCommand.LIST%>";
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
                                                                                <td colspan="4" align="left">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr> 
                                                                                <td colspan="4" align="left">
                                                                                    <table border="0" cellspacing="0" cellpadding="2">
                                                                                        <tr>
                                                                                            <td width="65"><%=langNav[3]%></td>
                                                                                            <td>
                                                                                                <select name="period_id">
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
                                                                                        </tr>  
                                                                                        <%
            if (isGereja || (vSeg != null && vSeg.size() > 0)) {
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
                                                                                            <td ><%=oSegment.getName()%></td>
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
                                                                                                    Vector segDet = DbSegmentDetail.list(0, 0, wh, "");
                                                                                                %>
                                                                                                <select name="JSP_SEGMENT<%=xs + 1%>_ID" >
                                                                                                    <option value="0" <%if (0 == seg_id) {%>selected<%}%>>All Location</option>
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
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td ><%=langNav[4]%></td>
                                                                                            <td >
                                                                                                <select name="preview_type">
                                                                                                    <option value="0" <%if (previewType == 0) {%>selected<%}%>>All Account</option>
                                                                                                    <option value="1" <%if (previewType == 1) {%>selected<%}%>>Account &gt; 0 Only</option>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr> 
                                                                                        <tr>
                                                                                            <td >&nbsp;</td>
                                                                                            <td><input type="button" name="Button" value="GO" onClick="javascript:cmdGO()"></td>
                                                                                        </tr> 
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="7%" nowrap height="23"></td>
                                                                                <td width="19%" height="23"></td>
                                                                                <td width="41%" height="23"> 
                                                                                    <div align="center"><b><font face="arial" size="2"><%=company.getName().toUpperCase()%></font></b></div>
                                                                                </td>
                                                                                <td width="33%" height="23">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="7%" nowrap height="23"></td>
                                                                                <td width="19%" height="23"></td>
                                                                                <td width="41%" height="23"> 
                                                                                    <div align="center"><b><font face="arial" size="2"><%=title%></font></b></div>
                                                                                </td>
                                                                                <td width="33%" height="23">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="7%" nowrap height="23"><b>&nbsp;</b></td>
                                                                                <td width="19%" height="23">&nbsp; </td>
                                                                                <td width="41%" height="23"><font face="arial" size="2"> 
                                                                                    <div align="center"><b>PER <%=JSPFormater.formatDate(dtx, "dd MMMM yyyy")%> DAN <%=JSPFormater.formatDate(reportDate, "dd MMMM yyyy")%></b></div></font>
                                                                                </td>
                                                                                <td width="33%" height="23">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td class="tablehdr">NO</td>
                                                                                <td class="tablehdr">URAIAN</td>
                                                                                <td class="tablehdr">REALISASI<br>PER<br><%=JSPFormater.formatDate(dtx, "dd MMMM yyyy")%></td>
                                                                                <td class="tablehdr">REALISASI<br>PER<br><%=JSPFormater.formatDate(reportDate, "dd MMMM yyyy")%></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="3"><div align="center"><b>1</b></div></td>
                                                                                <td width="33%" height="3"><div align="center"><b>2</b></div></td>
                                                                                <td width="15%" height="3"><div align="center"><b>3</b></div></td>
                                                                                <td width="17%" height="3"><div align="center"><b>4</b></div></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="22"></td>
                                                                                <td width="33%" height="22"><b><font color="#CC3300" size="2">AKTIVA</font></b></td>
                                                                                <td width="15%" height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                <td width="17%" height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                            </tr>
                                                                            <%
            double totalAmountLY = 0;
            double totalAmountTY = 0;
            int seq = 0;

            for (int x = 0; x < I_Project.accGroup.length; x++) {

                Vector tempCoas = new Vector();
                if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LIQUID_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_FIXED_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)) {
                    tempCoas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
                }

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
                        double amountTY = 0;

                        if (lastPeriod.getOID() != 0) {
                            amountLY = DbGlDetail.getOpeningBalancePrevious(lastPeriod, coa.getOID(), whereMd);
                            amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getOID(), whereMd);
                        }

                        //this year                        
                        amountTY = DbGlDetail.getOpeningBalancePrevious(period, coa.getOID(), whereMd);
                        amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getOID(), whereMd);

                        //total
                        if (!isBold) {
                            totalAmountLY = totalAmountLY + amountLY;
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
                                                                                <td width="2%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"><%=seq%> </td>
                                                                                <td width="33%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
                                                                                <td width="15%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(amountLY, isBold)%></div></td>
                                                                                <td width="17%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(amountTY, isBold)%></div></td>
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
                                                                                <td width="33%" height="22"><b><font color="#CC3300" size="2">TOTAL AKTIVA</font></b></td>
                                                                                <td width="15%" height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountLY, false)%></b></font></div></td>
                                                                                <td width="17%" height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountTY, false)%></b></font></div></td>
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
                                                                                <td width="33%" height="22"><b><font color="#CC3300" size="2">PASIVA</font></b></td>
                                                                                <td width="15%" height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                <td width="17%" height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                            </tr>
                                                                            <%
            totalAmountLY = 0;
            totalAmountTY = 0;
            seq = 0;

            for (int x = 0; x < I_Project.accGroup.length; x++) {

                Vector tempCoas = new Vector();
                if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EQUITY)) {
                    tempCoas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
                }

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
                        double amountTY = 0;

                        String indukLaba1 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_1");
                        String indukLaba2 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_2");
                        String indukLaba3 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_3");
                        String indukLaba4 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_4");

                        //jika laba tahun berjalan, hitungnya beda
                        if (coaLabaBerjalan.getCode().equals(coa.getCode())) {
                            if (lastPeriod.getOID() != 0) {
                                amountLY = DbGlDetail.getOpeningBalancePrevious(lastPeriod, coa.getOID(), whereMd);
                                amountLY = amountLY + DbGlDetail.getTotalIncomeInPeriod(lastPeriod.getOID(), whereMd) - DbGlDetail.getTotalExpenseInPeriod(lastPeriod.getOID(), whereMd);
                            }
                            amountTY = DbGlDetail.getOpeningBalancePrevious(period, coa.getOID(), whereMd);
                            amountTY = amountTY + DbGlDetail.getTotalIncomeInPeriod(period.getOID(), whereMd) - DbGlDetail.getTotalExpenseInPeriod(period.getOID(), whereMd);
                        } else {
                            if (lastPeriod.getOID() != 0) {
                                amountLY = DbGlDetail.getOpeningBalancePrevious(lastPeriod, coa.getOID(), whereMd);
                                amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getOID(), whereMd);
                            }
                            amountTY = DbGlDetail.getOpeningBalancePrevious(period, coa.getOID(), whereMd);
                            amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getOID(), whereMd);
                        }

                        if (!isBold) {
                            totalAmountLY = totalAmountLY + amountLY;
                            totalAmountTY = totalAmountTY + amountTY;
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
                                                                                <td width="2%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"><%=seq%> </td>
                                                                                <td width="33%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
                                                                                <td width="15%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(amountLY, isBold)%></div></td>
                                                                                <td width="17%" class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(amountTY, isBold)%></div></td>
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
                                                                                <td width="33%" height="22"><b><font color="#CC3300" size="2">TOTAL PASIVA</font></b></td>
                                                                                <td width="15%" height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountLY, false)%></b></font></div></td>
                                                                                <td width="17%" height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountTY, false)%></b></font></div></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="2%" height="1" bgcolor="#609836"></td>
                                                                                <td width="33%" height="1" bgcolor="#609836"></td>
                                                                                <td width="15%" height="1" bgcolor="#609836"></td>
                                                                                <td width="17%" height="1" bgcolor="#609836"></td>
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
                                                                                <td colspan=4>
                                                                                    <% out.print("<a href=\"../freport/neraca_penjelasan_print_priview.jsp?rpt_format_id=" + oidRptFormat + "&period_id=" + periodId + "&preview_type=" + previewType + "&whereMd=" + whereMd + "\"  onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/print.gif\" name=\"print\" height=\"22\" border=\"0\"></a></div>");%>
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