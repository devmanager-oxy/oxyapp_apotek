

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.activity.*" %>
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

    public String namaBulan(int bul) {
        String str = "";
        switch (bul) {
            case 1:
                str = "Jan";
                break;
            case 2:
                str = "Feb";
                break;
            case 3:
                str = "Mar";
                break;
            case 4:
                str = "Apr";
                break;
            case 5:
                str = "Mei";
                break;
            case 6:
                str = "Jun";
                break;
            case 7:
                str = "Jul";
                break;
            case 8:
                str = "Agu";
                break;
            case 9:
                str = "Sep";
                break;
            case 10:
                str = "Okt";
                break;
            case 11:
                str = "Nop";
                break;
            case 12:
                str = "Des";
                break;
        }

        return str;
    }
%>
<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            Company company = DbCompany.getCompany();
            
            if (session.getValue("LIST_REPORT_ANGGARAN") != null) {
                session.removeValue("LIST_REPORT_ANGGARAN");
            }
            
            
            if (session.getValue("SEARCH_PARAMETER") != null) {
                session.removeValue("SEARCH_PARAMETER");
            }
            
            /*** LANG ***/
            String[] langNav = {"Financial Report", "Detail", "Balance Sheet", "Period", "Preview", "Location"};
            String title = "";

            try {
                title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA_EN");
            } catch (Exception e) {
            }

            if (lang == LANG_ID) {
                String[] navID = {"Laporan Keuangan", "Penjelasan", "Anggaran", "Periode", "Preview", "Lokasi"};
                langNav = navID;
                try {
                    title = "LAPORAN ANGGARAN";
                } catch (Exception e) {
                }
            }

            Vector periods = DbActivityPeriod.list(0, 0, "", DbActivityPeriod.colNames[DbActivityPeriod.COL_START_DATE] + " desc");
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            ActivityPeriod activityPeriod = new ActivityPeriod();
            Vector listVectorAll = new Vector();
            Vector listVector = new Vector();
            int loopMonth = 1;

            if (iJSPCommand == JSPCommand.LIST) {

                String whereMd = "";
                String whereGd = "";
                if (vSeg != null && vSeg.size() > 0) {

                    for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {
                        int pg = iSeg + 1;
                        long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");

                        if (segment_id != 0) {
                            if (whereMd.length() > 0) {
                                whereMd = whereMd + " and ";
                                whereGd = whereGd + " and ";
                            }
                            if (iSeg == 0) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT1_ID] + " = " + segment_id;
                            } else if (iSeg == 1) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT2_ID] + " = " + segment_id;
                            } else if (iSeg == 2) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT3_ID] + " = " + segment_id;
                            } else if (iSeg == 3) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT4_ID] + " = " + segment_id;
                            } else if (iSeg == 4) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT5_ID] + " = " + segment_id;
                            } else if (iSeg == 5) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT6_ID] + " = " + segment_id;
                            } else if (iSeg == 6) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT7_ID] + " = " + segment_id;
                            } else if (iSeg == 7) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT8_ID] + " = " + segment_id;
                            } else if (iSeg == 8) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT9_ID] + " = " + segment_id;
                            } else if (iSeg == 9) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT10_ID] + " = " + segment_id;
                            } else if (iSeg == 10) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID] + " = " + segment_id;
                            } else if (iSeg == 11) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT11_ID] + " = " + segment_id;
                            } else if (iSeg == 12) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT13_ID] + " = " + segment_id;
                            } else if (iSeg == 13) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT14_ID] + " = " + segment_id;
                            } else if (iSeg == 14) {
                                whereMd = whereMd + "m." + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                                whereGd = whereGd + "gd." + DbGlDetail.colNames[DbGlDetail.COL_SEGMENT15_ID] + " = " + segment_id;
                            }
                        }
                    }
                }

                listVectorAll = SessReportAnggaran.reportAnggaran(periodId, new Date(), whereMd);  
                activityPeriod = DbActivityPeriod.fetchExc(periodId);
                loopMonth = Integer.parseInt((String) listVectorAll.get(0));
                listVector = (Vector) listVectorAll.get(1);
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
            
            function cmdPrintXls(){	                       
                window.open("<%=printroot%>.report.RptAnggaranXLS?user_id=<%=appSessUser.getUserOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
            
            function cmdGO(){                
                document.form1.command.value="<%=JSPCommand.LIST%>";
                document.form1.action="report_anggaran.jsp?menu_idx=<%=menuIdx%>";
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
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="4" align="left" height="10"></td>
                                                                            </tr>    
                                                                            <tr> 
                                                                                <td colspan="4" align="left">
                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="370">                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" > 
                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="0" cellpadding="2">
                                                                                                    <tr height="15">
                                                                                                        <td width="5" height="7"></td>
                                                                                                        <td width="110" height="7"></td>
                                                                                                        <td colspan="2" height="7"></td>
                                                                                                        <td width="10" height="7"></td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td ></td>
                                                                                                        <td ><%=langNav[3]%></td>
                                                                                                        <td >:</td>
                                                                                                        <td>
                                                                                                            <select name="period_id">
                                                                                                                <%
            String strTahun = "";
            String strHeaderDipakai = JSPFormater.formatDate(new Date(), "MMM yyyy");
            if (periods != null && periods.size() > 0) {
                for (int i = 0; i < periods.size(); i++) {
                    ActivityPeriod per = (ActivityPeriod) periods.get(i);
                    if (per.getOID() == periodId) {
                        strTahun = String.valueOf(per.getEndDate().getYear() + 1900);
                        if ((new Date().getYear() + 1900) != (per.getEndDate().getYear() + 1900)) {
                            strHeaderDipakai = JSPFormater.formatDate(per.getEndDate(), "MMM yyyy");
                        }
                    }
                                                                                                                %>
                                                                                                                <option value="<%=per.getOID()%>" <%if (per.getOID() == periodId) {%>selected<%}%>><%=per.getName()%></option>
                                                                                                                <% }
            }
             session.putValue("SEARCH_PARAMETER", strTahun);   
            %>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>  
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
                                                                                                        <td ></td>
                                                                                                        <td ><%=oSegment.getName()%></td>
                                                                                                        <td >:</td>
                                                                                                        <td > 
                                                                                                            <%
                                                                                                            String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + oSegment.getOID();
                                                                                                            boolean isAll = false;

                                                                                                            switch (xs + 1) {
                                                                                                                case 1:
                                                                                                                    //Jika sama dengan 0 maka akan ditampilkan smua detail segment, tetapi jika tidak
                                                                                                                    //maka akan di tampikan sesuai dengan segment yang ditentukan
                                                                                                                    if (usr.getSegment1Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment1Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }

                                                                                                                    break;
                                                                                                                case 2:
                                                                                                                    if (usr.getSegment2Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment2Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 3:
                                                                                                                    if (usr.getSegment3Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment3Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 4:
                                                                                                                    if (usr.getSegment4Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment4Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 5:
                                                                                                                    if (usr.getSegment5Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment5Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 6:
                                                                                                                    if (usr.getSegment6Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment6Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 7:
                                                                                                                    if (usr.getSegment7Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment7Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 8:
                                                                                                                    if (usr.getSegment8Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment8Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 9:
                                                                                                                    if (usr.getSegment9Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment9Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 10:
                                                                                                                    if (usr.getSegment10Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment10Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 11:
                                                                                                                    if (usr.getSegment11Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment11Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 12:
                                                                                                                    if (usr.getSegment12Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment12Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 13:
                                                                                                                    if (usr.getSegment13Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment13Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 14:
                                                                                                                    if (usr.getSegment14Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment14Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                                case 15:
                                                                                                                    if (usr.getSegment15Id() != 0) {
                                                                                                                        wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + usr.getSegment15Id();
                                                                                                                    } else {
                                                                                                                        isAll = true;
                                                                                                                    }
                                                                                                                    break;
                                                                                                            }
                                                                                                            Vector segDet = DbSegmentDetail.list(0, 0, wh, "");
                                                                                                            %>
                                                                                                            <select name="JSP_SEGMENT<%=xs + 1%>_ID" >
                                                                                                                <%if (isAll) {%>	
                                                                                                                <option value="0">ALL</option>
                                                                                                                <%}%>
                                                                                                                <%if (segDet != null && segDet.size() > 0) {
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
                                                                                                    </tr>
                                                                                                    <%
                }
            }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td ></td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td><input type="button" name="Button" value="GO" onClick="javascript:cmdGO()"></td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td ></td>
                                                                                                        <td height="7"></td>
                                                                                                        <td colspan="2" height="7"></td>
                                                                                                        <td height="7"></td>
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
                                                                                <td colspan="4" height="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">
                                                                                    <table width="1850" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="100" class="tablearialhdr">Nomor Kegiatan</td>
                                                                                            <td class="tablearialhdr">Nama Kegiatan</td>
                                                                                            <td width="160" class="tablearialhdr">Anggaran</td>
                                                                                            <td width="70" class="tablearialhdr">COA</td>
                                                                                            <td width="70" class="tablearialhdr">Anggaran <%=strTahun%></td>
                                                                                            <td width="70" class="tablearialhdr">Dipakai s/d <%=strHeaderDipakai%></td>
                                                                                            <td width="70" class="tablearialhdr">Selisih</td>
                                                                                            <%
    for (int j = 0; j < loopMonth; j++) {
                                                                                            %>
                                                                                            <td width="70" class="tablearialhdr"><%=namaBulan(j + 1)%> <%=strTahun%></td>
                                                                                            <%
    }
                                                                                            %>
                                                                                        </tr>
                                                                                        <%
    String header02 = "";
    String strData01 = "";
    String strData02 = "";
    boolean statusSubTotal = false;
    
    double totAnggaran = 0;
    double totDiPakai = 0;
    double totSelisih = 0;
    double totMonth[] = new double[20];
    
    double anggaran = 0;
    double diPakai = 0;
    double selisih = 0;
    double month[] = new double[20];
    Vector vDetail = new Vector();
    
    if (listVector != null && listVector.size() > 0) {
        for (int i = 0; i < listVector.size(); i++) {
            Vector vecDetail = (Vector) listVector.get(i);
            Vector tmpvDetail = new Vector();
            
            tmpvDetail.add(String.valueOf(vecDetail.get(0)));
            tmpvDetail.add(String.valueOf(vecDetail.get(1)));
            tmpvDetail.add(String.valueOf(vecDetail.get(2)));
            tmpvDetail.add(String.valueOf(vecDetail.get(3)));
            tmpvDetail.add(String.valueOf(vecDetail.get(4)));
            tmpvDetail.add(String.valueOf(vecDetail.get(5)));
            
            statusSubTotal = false;
            if (header02.equals((String) vecDetail.get(1))) {
                strData01 = "";
                strData02 = "";
            } else {
                strData01 = (String) vecDetail.get(0);
                strData02 = (String) vecDetail.get(1);
                header02 = (String) vecDetail.get(1);
                if (i > 0) {
                    statusSubTotal = true;
                }
            }

            String description = "";
            long mbId = 0;
            long cId = 0;
            double anggaranx = 0;
            
            try{
                mbId = Long.parseLong(""+vecDetail.get(6));
            }catch(Exception e){}
            
            try{
                cId = Long.parseLong(""+vecDetail.get(7));
            }catch(Exception e){}
            
            tmpvDetail.add(String.valueOf(mbId));
            tmpvDetail.add(String.valueOf(cId));
            
            Vector vMB = DbModuleBudget.list(0, 0, DbModuleBudget.colNames[DbModuleBudget.COL_MODULE_ID]+" = "+mbId+" and "+DbModuleBudget.colNames[DbModuleBudget.COL_COA_ID]+"="+cId, null);            
            
            if(vMB != null && vMB.size() > 0){
                for(int t = 0;t < vMB.size();t++){                    
                    ModuleBudget mb = (ModuleBudget)vMB.get(t);
                    if(description != null && description.length() > 0){
                        description = description+"<BR>";
                    }
                    description = description+mb.getDescription();
                    anggaranx = anggaranx + mb.getAmount(); 
                }
            }
            
            if (statusSubTotal) {
                                                                                        %>
                                                                                        <tr height="25"> 
                                                                                            <td colspan="3" class="tablearialcell1"><div align="right"></div></td>
                                                                                            <td class="tablearialcell1"><div align="right"><b>SUB TOTAL</b></div></td>
                                                                                            <td class="tablearialcell1"><div align="right"><b><%=getFormated(anggaran, false)%><b></div></td>
                                                                                            <td class="tablearialcell1"><div align="right"><b><%=getFormated(diPakai, false)%><b></div></td>
                                                                                            <td class="tablearialcell1"><div align="right"><b><%=getFormated(selisih, false)%><b></div></td>
                                                                                            <%
                                                                                                    for (int n = 0; n < loopMonth; n++) {
                                                                                            %>
                                                                                            <td class="tablearialcell1"><div align="right"><b><%=getFormated(month[n], false)%><b></div></td>
                                                                                            <%
                                                                                                    }
                                                                                            %>
                                                                                        </tr>
                                                                                        <%
                anggaran = 0;
                diPakai = 0;
                selisih = 0;
                for (int n = 0; n < loopMonth; n++) {
                    month[n] = 0;
                }
            }
            
            double tmpAnggaran = 0;
            double tmpDipakai = 0;
            double tmpSelisih = 0;
            
            Vector result =  SessReportAnggaran.reportAnggaranDetail(mbId, cId,loopMonth,activityPeriod.getEndDate().getYear()+1900);
            
            try{
                tmpAnggaran = anggaranx;//Double.parseDouble((String) vecDetail.get(4));
                anggaran = anggaran + tmpAnggaran;
                totAnggaran =  totAnggaran + tmpAnggaran;
            }catch(Exception e){}
            
            for (int n = 0; n < loopMonth; n++) {
                //month[n] = month[n] + Double.parseDouble((String) vecDetail.get(8 + n));
                //totMonth[n] = totMonth[n] + Double.parseDouble((String) vecDetail.get(8 + n));
                double mt = 0;
                double tmpMt = 0;
                
                try{
                    mt = Double.parseDouble((String) result.get(n));
                }catch(Exception e){}
                
                try{
                    tmpMt = Double.parseDouble((String) result.get(n));
                }catch(Exception e){}
                
                month[n] = month[n] + mt;
                totMonth[n] = totMonth[n] + tmpMt;
                tmpDipakai = tmpDipakai + mt;
                tmpvDetail.add(String.valueOf(mt));                   
            }
            tmpvDetail.add(String.valueOf(tmpDipakai)); 
            
            try{
                //tmpDipakai = Double.parseDouble((String) vecDetail.get(loopMonth + 8));
                diPakai = diPakai + tmpDipakai;
                totDiPakai = totDiPakai + tmpDipakai;
            }catch(Exception e){}
            
            try{
                tmpSelisih = tmpAnggaran - tmpDipakai;
                selisih = selisih + tmpSelisih;
                totSelisih = totSelisih + tmpSelisih;
            }catch(Exception e){} 
            
            %>
                                                                                        <tr height="25"> 
                                                                                            <td class="tablearialcell" valign="top"><%=strData01%></td>
                                                                                            <td class="tablearialcell" valign="top"><%=strData02%></td>
                                                                                            <td class="tablearialcell" valign="top"><%=description%></td>
                                                                                            <td class="tablearialcell" valign="top"><%=vecDetail.get(3)%></td>
                                                                                            <td class="tablearialcell" valign="top"><div align="right"><%=getFormated(tmpAnggaran, false)%></div></td>
                                                                                            <td class="tablearialcell" valign="top"><div align="right"><%=getFormated(tmpDipakai, false)%></div></td>
                                                                                            <td class="tablearialcell" valign="top"><div align="right"><%=getFormated(tmpSelisih, false)%></div></td>
                                                                                            <%
                                                                                                for (int p = 0; p < loopMonth; p++) {
                                                                                                    double mt = 0;
                try{
                    mt = Double.parseDouble((String) result.get(p));
                }catch(Exception e){}
                
                                                                                                    
                                                                                            %>
                                                                                            <td class="tablearialcell" valign="top"><div align="right"><%=getFormated(mt, false)%></div></td>
                                                                                            <%
                                                                                                }
                                                                                            %>
                                                                                        </tr>
                                                                                        <%
                                                                             
                                                                             
                                                                             vDetail.add(tmpvDetail);
        }
    }
    
    Vector listVectorAll1 = new Vector();
    listVectorAll1.add(""+loopMonth);
    listVectorAll1.add(vDetail);
    session.putValue("LIST_REPORT_ANGGARAN", listVectorAll1); 
                                                                                        %>
                                                                                        <tr height="25"> 
                                                                                            <td colspan="3" class="tablearialcell1"><div align="right"></div></td>
                                                                                            <td class="tablearialcell1"><div align="right"><b>SUB TOTAL</b></div></td>
                                                                                            <td class="tablearialcell1"><div align="right"><b><%=getFormated(anggaran, false)%></b></div></td>
                                                                                            <td class="tablearialcell1"><div align="right"><b><%=getFormated(diPakai, false)%></b></div></td>
                                                                                            <td class="tablearialcell1"><div align="right"><b><%=getFormated(selisih, false)%></b></div></td>
                                                                                            <%
    for (int m = 0; m < loopMonth; m++) {
                                                                                            %>
                                                                                            <td class="tablearialcell1"><div align="right"><%=getFormated(month[m], false)%></div></td>
                                                                                            <%
    }
    anggaran = 0;
    diPakai = 0;
    selisih = 0;
    for (int n = 0; n < loopMonth; n++) {
        month[n] = 0;
    }
                                                                                            %>
                                                                                        </tr>
                                                                                        <tr height="25"> 
                                                                                            <td colspan="4" class="tablearialhdr"><div align="right">TOTAL KESELURUHAN</div></td>
                                                                                            <td class="tablearialhdr"><div align="right"><%=getFormated(totAnggaran, false)%></div></td>
                                                                                            <td class="tablearialhdr"><div align="right"><%=getFormated(totDiPakai, false)%></div></td>
                                                                                            <td class="tablearialhdr"><div align="right"><%=getFormated(totSelisih, false)%></div></td>
                                                                                            <%
    for (int o = 0; o < loopMonth; o++) {
                                                                                            %>
                                                                                            <td class="tablearialhdr"><div align="right"><%=getFormated(totMonth[o], false)%></div></td>
                                                                                            <%
    }
                                                                                            %>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3"><a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" height="22"  border="0"></a></td>
                                                                            </tr>
                                                                            
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3" class="tablearialcell1">&nbsp;<i>Klik GO Button to searching the data...</i></td>
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
