
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_GL, AppMenu.PRIV_VIEW);
%>
<%

            if (session.getValue("GL_REPORT") != null) {
                session.removeValue("GL_REPORT");
            }

            if (session.getValue("GL_REPORT_PDF") != null) {
                session.removeValue("GL_REPORT_PDF");
            }

            Periode p = DbPeriode.getOpenPeriod();
            Date startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
            Date endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_date"), "dd/MM/yyyy");
            int status = JSPRequestValue.requestInt(request, "status");
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);

            String posting = "YES";
            try {
                posting = DbSystemProperty.getValueByName("POSTING_INVOICE");
            } catch (Exception e) {
            }

            int msgBukuBesar = 0;// 0 default mengambil dari gl detail, 1 mengambil dari gl
            try {
                msgBukuBesar = Integer.parseInt(DbSystemProperty.getValueByName("MESSAGE_GENERAL_LEDGER"));
            } catch (Exception e) {
            }

            String whereMd = "";
            String whereMd2 = "";
            String whereCrd = "";
            String wherePpd = "";
            String whereBd = "";
            String where = "";

            String oidMd = "";
            long segment1Id = 0;

            String segmentx = "";

            for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {
                int pg = iSeg + 1;
                long segment_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + pg + "_ID");
                oidMd = oidMd + ";" + segment_id;

                if (segment_id != 0) {

                    if (whereMd.length() > 0) {
                        whereMd = whereMd + " and ";
                        whereMd2 = whereMd2 + " and ";
                        whereCrd = whereCrd + " and ";
                        wherePpd = wherePpd + " and ";
                        whereBd = whereBd + " and ";
                        where = where + " and ";
                        segmentx = segmentx + " | ";
                    }

                    SegmentDetail sd = new SegmentDetail();
                    try {
                        sd = DbSegmentDetail.fetchExc(segment_id);
                    } catch (Exception e) {
                    }
                    segmentx = segmentx + sd.getName();

                    if (iSeg == 0) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT1_ID] + " = " + segment_id;
                        segment1Id = segment_id;


                    } else if (iSeg == 1) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT2_ID] + " = " + segment_id;
                    } else if (iSeg == 2) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT3_ID] + " = " + segment_id;
                    } else if (iSeg == 3) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT4_ID] + " = " + segment_id;
                    } else if (iSeg == 4) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT5_ID] + " = " + segment_id;
                    } else if (iSeg == 5) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT6_ID] + " = " + segment_id;
                    } else if (iSeg == 6) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT7_ID] + " = " + segment_id;
                    } else if (iSeg == 7) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT8_ID] + " = " + segment_id;
                    } else if (iSeg == 8) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT9_ID] + " = " + segment_id;
                    } else if (iSeg == 9) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                        whereMd2 = whereMd2 + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT10_ID] + " = " + segment_id;
                    } else if (iSeg == 10) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT11_ID] + " = " + segment_id;
                    } else if (iSeg == 11) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT12_ID] + " = " + segment_id;
                    } else if (iSeg == 12) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT13_ID] + " = " + segment_id;
                    } else if (iSeg == 13) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT14_ID] + " = " + segment_id;
                    } else if (iSeg == 14) {
                        whereMd = whereMd + "gd." + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                        whereCrd = whereCrd + " crd." + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                        wherePpd = wherePpd + " ppd." + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                        whereBd = whereBd + " bd." + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                        where = where + DbModule.colNames[DbModule.COL_SEGMENT15_ID] + " = " + segment_id;
                    }
                }
            }

            if (whereCrd.length() > 0) {
                whereCrd = " and " + whereCrd;
                wherePpd = " and " + wherePpd;
                whereBd = " and " + whereBd;
                where = " and " + where;
            }
            if (whereMd2.length() > 0) {
                whereMd2 = " where " + whereMd2;
            }

            Vector coas = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_STATUS] + "<>'" + I_Project.ACCOUNT_LEVEL_HEADER + "'", DbCoa.colNames[DbCoa.COL_CODE]);

            Vector tmpXls = new Vector();
            Vector listReport = new Vector();
            SesReportBs sesReport = new SesReportBs();
            SesReportGl sesReportGl = new SesReportGl();
            Vector vSesDep = new Vector();
            Vector listReportGL = new Vector();
            SesReportGl sesReportDetail = new SesReportGl();

            /*** LANG (var ini juga digunakan pada proses export to excel) ***/
            String[] langFR = {"GENERAL LEDGER", "Acc. Group", //0-1
                "Date", "Journal Number", "Memo", "Debet", "Credit", "Balance", "Opening Balance", //2-8
                "Date of print", "Approved by", "Checked by", "Prepared by"};
            String[] langNav = {"Financial Report", "General Ledger"};

            if (lang == LANG_ID) {
                String[] langID = {"BUKU BESAR", "Kelompok Perkiraan",
                    "Tanggal", "Nomor Jurnal", "Keterangan", "Debet", "Kredit", "Saldo", "Saldo Awal", //2-8
                    "Dicetak tanggal", "Disetujui oleh", "Diperiksa oleh", "Disiapkan oleh"
                }; //9-12
                langFR = langID;
                String[] navID = {"Laporan Keuangan", "Buku Besar"};
                langNav = navID;
            }

            String wherex = "";
            if (whereMd.length() > 0) {
                wherex = " and " + whereMd;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournalXLS(){	 
                window.open("<%=printroot%>.report.RptGLStandardXLS?oid=<%=appSessUser.getLoginId()%>&segmentId=<%=segment1Id%>&period=<%=JSPFormater.formatDate(startDate, "dd/MM/yyyy")%> - <%=JSPFormater.formatDate(endDate, "dd/MM/yyyy")%>");
                }
                
                function cmdPrintJournal(){	 
                    window.open("<%=printroot%>.report.RptGLStandardPDF?oid=<%=appSessUser.getLoginId()%>&segmentId=<%=segment1Id%>&period=<%=JSPFormater.formatDate(startDate, "dd/MM/yyyy")%> - <%=JSPFormater.formatDate(endDate, "dd/MM/yyyy")%>");
                    }
                    
                    
                    function cmdBack(){
                        document.form1.command.value="<%=JSPCommand.BACK%>";
                        document.form1.action="glreport.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/print2.gif','../images/printxls2.gif')">
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
                                                        <form id="form1" name="form1" method="post" action="">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="start_date" value="<%=JSPFormater.formatDate(startDate, "dd/MM/yyyy") %>">
                                                            <input type="hidden" name="end_date" value="<%=JSPFormater.formatDate(endDate, "dd/MM/yyyy") %>">
                                                            <input type="hidden" name="status" value="<%=status%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td height="16">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            if (vSeg != null && vSeg.size() > 0) {
                for (int iSeg = 0; iSeg < vSeg.size(); iSeg++) {
                    long segmentx_id = JSPRequestValue.requestLong(request, "JSP_SEGMENT" + (iSeg + 1) + "_ID");
                                                                            %>  
                                                                            <input type="hidden" name="JSP_SEGMENT<%=iSeg + 1%>_ID" value="<%=segmentx_id%>">
                                                                            <%}
            }%>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <span class="level1">
                                                                                        <font size="+1">
                                                                                            <b> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="8%">&nbsp;</td>
                                                                                                        <td width="84%">
                                                                                                            <span class="level1"><font face="arial" size="+1"><b><div align="center"><%=langFR[0]%></div></b></font></span> 
                                                                                                        </td>
                                                                                                        <td width="8%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </b>
                                                                                        </font>
                                                                                    </span>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="fontarial"> 
                                                                                    <div align="center"><b><%=JSPFormater.formatDate(startDate, "dd MMM yyyy")%> - <%=JSPFormater.formatDate(endDate, "dd MMM yyyy")%></b></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="fontarial"> 
                                                                                    <div align="center"><b><%=segmentx%></b></div>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <%
            boolean dataReady = false;
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coa = (Coa) coas.get(i);
                    int ix = JSPRequestValue.requestInt(request, "box_" + coa.getOID());
                    if (ix == 1) {
                        dataReady = true;
                                                                            %>
                                                                            <input type="hidden" name="box_value<%=coa.getOID()%>" value="1" >
                                                                            <%
                                                                                    }
                                                                                    boolean isDebetPosition = false;

                                                                                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE) ||
                                                                                            coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                                                                        isDebetPosition = true;
                                                                                    }

                                                                                    if (ix == 1) {
                                                                            %>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr height="18"> 
                                                                                            <td class="tablehdr2"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="45%" class="fontarial">&nbsp;<B><%=coa.getCode() + " - " + coa.getName()%></B></td>
                                                                                                        <td width="7%">&nbsp;</td>
                                                                                                        <td width="48%" class="fontarial"> 
                                                                                                            <div align="right"><b><%=langFR[1]%> : <%=coa.getAccountGroup()%></b>&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%	//Detail Report PDF                                                                                
                                                                                sesReportDetail = new SesReportGl();
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td> 
                                                                                                <table width="100%"  height="20" cellpadding="1" cellspacing="1" align="right">
                                                                                                    <tr height="30"> 
                                                                                                        <td width="12%" class="tablearialhdr" align="center"><b><%=langFR[2]%></b></td>
                                                                                                        <td width="12%" class="tablearialhdr" align="center"><b><%=langFR[3]%></b></td>
                                                                                                        <td width="35%" class="tablearialhdr" align="center"><b><%=langFR[4]%></b></td>
                                                                                                        <td width="13%" class="tablearialhdr" align="center"><b><%=langFR[5]%></b></td>
                                                                                                        <td width="13%" class="tablearialhdr" align="center"><b><%=langFR[6]%></b></td>
                                                                                                        <td width="15%" class="tablearialhdr" align="center"><b><%=langFR[7]%></b></td>
                                                                                                    </tr>
                                                                                                    <%	//Detail Report PDF
                                                                                sesReportDetail = new SesReportGl();


                                                                                double openingBalance = 0;
                                                                                double totalCredit = 0;
                                                                                double totalDebet = 0;

                                                                                vSesDep = new Vector();
                                                                                //jika bukan expense dan revenue
                                                                                if (!(coa.getAccountGroup().equals("Expense") || coa.getAccountGroup().equals("Other Expense") ||
                                                                                        coa.getAccountGroup().equals("Revenue") || coa.getAccountGroup().equals("Other Revenue"))) {

                                                                                    if (status == 0) {
                                                                                        openingBalance = DbGlDetail.getGLOpeningBalanceLocation(startDate, coa, whereMd2, whereCrd, wherePpd, whereBd, where, wherex);
                                                                                    } else {
                                                                                        openingBalance = DbGlDetail.getGLOpeningBalanceLocation(startDate, coa, whereMd);
                                                                                    }

                                                                                                    %>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="tablearialcell1" align="center" >&nbsp;</td>
                                                                                                        <td class="tablearialcell1" align="center" >-</td>
                                                                                                        <td class="tablearialcell1" align="left" ><%=langFR[8]%></td>
                                                                                                        <td class="tablearialcell1" align="right" ><div align="right">-</div></td>
                                                                                                        <td class="tablearialcell1" align="right" ><div align="right">-</div></td>
                                                                                                        <td class="tablearialcell1" align="right" > 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%


                                                                                }// end jika bukan revenue 	
                                                                                boolean data = false;
                                                                                try {

                                                                                    CONResultSet crs = null;

                                                                                    String sql = "";

                                                                                    String sqlx = "";
                                                                                    if (posting.equals("YES")) {
                                                                                        sqlx = " union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + where +
                                                                                                " union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + whereBd;
                                                                                    } else {
                                                                                        sqlx = " union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and type=1 " + where +
                                                                                                " union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and b.type = 1 " + whereBd;
                                                                                    }

                                                                                    if (status == 0) {

                                                                                        sql = "select oid,coa_id,journal_number,trans_date,memo,debet,credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from ( " +
                                                                                                " select cr.cash_receive_id as oid,crd.coa_id as coa_id,cr.journal_number as journal_number,cr.trans_date as trans_date,crd.memo as memo,0 as debet,crd.amount as credit,crd.segment1_id,crd.segment2_id,crd.segment3_id,crd.segment4_id,crd.segment5_id,crd.segment6_id,crd.segment7_id,crd.segment8_id,crd.segment9_id,crd.segment10_id from cash_receive cr inner join cash_receive_detail crd on cr.cash_receive_id = crd.cash_receive_id where posted_status = 0 and crd.coa_id=" + coa.getOID() + " and to_days(cr.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(cr.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + whereCrd +
                                                                                                " union select cash_receive_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from cash_receive where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + where +
                                                                                                " union select pp.pettycash_payment_id as oid,ppd.coa_id,pp.journal_number,pp.trans_date,ppd.memo,ppd.amount as debet,0 as credit,ppd.segment1_id,ppd.segment2_id,ppd.segment3_id,ppd.segment4_id,ppd.segment5_id,ppd.segment6_id,ppd.segment7_id,ppd.segment8_id,ppd.segment9_id,ppd.segment10_id from pettycash_payment pp inner join pettycash_payment_detail ppd on pp.pettycash_payment_id = ppd.pettycash_payment_id  where pp.posted_status = 0 and ppd.coa_id=" + coa.getOID() + " and to_days(pp.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(pp.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + wherePpd +
                                                                                                " union select pettycash_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from pettycash_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + where +
                                                                                                " union select bank_deposit_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bank_deposit where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + where +
                                                                                                " union select b.bank_deposit_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,0 as debet,bd.amount as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bank_deposit b inner join bank_deposit_detail bd on b.bank_deposit_id = bd.bank_deposit_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + whereBd;
                                                                                                //" union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + where
                                                                                        //" union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + whereBd +
                                                                                                //
                                                                                        sql = sql + sqlx;
                                                                                        sql = sql + " union select banknonpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from banknonpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + where +
                                                                                                " union select bd.banknonpo_payment_detail_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from banknonpo_payment b inner join banknonpo_payment_detail bd on b.banknonpo_payment_id = bd.banknonpo_payment_id where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + whereBd;

                                                                                        if (msgBukuBesar == 0) {
                                                                                            sql = sql + " union select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,gd.memo as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(g.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + wherex + " ) as x " + whereMd2 + " order by trans_date ";
                                                                                        } else {
                                                                                            sql = sql + " union select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,concat(g.memo,gd.memo) as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(g.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + wherex + " ) as x " + whereMd2 + " order by trans_date ";
                                                                                        }
                                                                                    } else {

                                                                                        if (status == DbGl.POSTED) {

                                                                                            sql = "";
                                                                                            if (msgBukuBesar == 0) {
                                                                                                sql = "select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,gd.memo as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where g.posted_status = 1 and gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(g.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";
                                                                                            } else {
                                                                                                sql = "select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,concat(g.memo,gd.memo) as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where g.posted_status = 1 and gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(g.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";
                                                                                            }

                                                                                            if (whereMd != null && whereMd.length() > 0) {
                                                                                                sql = sql + " and " + whereMd;
                                                                                            }

                                                                                        } else {
                                                                                            
                                                                                            String sqly = "";
                                                                                            if (posting.equals("YES")) {
                                                                                                sqly = " union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + 
                                                                                                        " union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";
                                                                                            } else {
                                                                                                sqly = " union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and type = 1 " + 
                                                                                                        " union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') and b.type = 1 ";
                                                                                            }
                                                                                            
                                                                                            
                                                                                            sql = "select oid,coa_id,journal_number,trans_date,memo,debet,credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from ( " +
                                                                                                    " select cr.cash_receive_id as oid,crd.coa_id as coa_id,cr.journal_number as journal_number,cr.trans_date as trans_date,cr.memo as memo,0 as debet,crd.amount as credit,crd.segment1_id,crd.segment2_id,crd.segment3_id,crd.segment4_id,crd.segment5_id,crd.segment6_id,crd.segment7_id,crd.segment8_id,crd.segment9_id,crd.segment10_id from cash_receive cr inner join cash_receive_detail crd on cr.cash_receive_id = crd.cash_receive_id where posted_status = 0 and crd.coa_id=" + coa.getOID() + " and to_days(cr.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(cr.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                                                                                                    " union select cash_receive_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from cash_receive where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                                                                                                    " union select pp.pettycash_payment_id as oid,ppd.coa_id,pp.journal_number,pp.trans_date,ppd.memo,ppd.amount as debet,0 as credit,ppd.segment1_id,ppd.segment2_id,ppd.segment3_id,ppd.segment4_id,ppd.segment5_id,ppd.segment6_id,ppd.segment7_id,ppd.segment8_id,ppd.segment9_id,ppd.segment10_id from pettycash_payment pp inner join pettycash_payment_detail ppd on pp.pettycash_payment_id = ppd.pettycash_payment_id  where pp.posted_status = 0 and ppd.coa_id=" + coa.getOID() + " and to_days(pp.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(pp.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                                                                                                    " union select pettycash_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from pettycash_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + " union select bank_deposit_id as oid,coa_id,journal_number,trans_date,memo,amount as debet,0 as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bank_deposit where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                                                                                                    " union select b.bank_deposit_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,0 as debet,bd.amount as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bank_deposit b inner join bank_deposit_detail bd on b.bank_deposit_id = bd.bank_deposit_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";
                                                                                                    
                                                                                            sql = sql + sqly;        
                                                                                                    //" union select bankpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from bankpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + " union select b.bankpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.payment_amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from bankpo_payment b inner join bankpo_payment_detail bd on b.bankpo_payment_id = bd.bankpo_payment_id  where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " +
                                                                                            sql = sql +" union select banknonpo_payment_id as oid,coa_id,journal_number,trans_date,memo,0 as debet,amount as credit,segment1_id,segment2_id,segment3_id,segment4_id,segment5_id,segment6_id,segment7_id,segment8_id,segment9_id,segment10_id from banknonpo_payment where posted_status = 0 and coa_id=" + coa.getOID() + " and to_days(trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + " union select b.banknonpo_payment_id as oid,bd.coa_id,b.journal_number,b.trans_date,bd.memo,bd.amount as debet,0 as credit,bd.segment1_id,bd.segment2_id,bd.segment3_id,bd.segment4_id,bd.segment5_id,bd.segment6_id,bd.segment7_id,bd.segment8_id,bd.segment9_id,bd.segment10_id from banknonpo_payment b inner join banknonpo_payment_detail bd on b.banknonpo_payment_id = bd.banknonpo_payment_id where b.posted_status = 0 and bd.coa_id=" + coa.getOID() + " and to_days(b.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(b.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') ";

                                                                                            if (msgBukuBesar == 0) {
                                                                                                sql = sql + " union select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,gd.memo as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where g.posted_status = 0 and gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(g.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + " ) as x " + whereMd2 + " order by trans_date ";
                                                                                            } else {
                                                                                                sql = sql + " union select gd.gl_detail_id as oid,gd.coa_id,g.journal_number,g.trans_date as trans_date,concat(g.memo,gd.memo) as memo,gd.debet as debet,gd.credit as credit,gd.segment1_id,gd.segment2_id,gd.segment3_id,gd.segment4_id,gd.segment5_id,gd.segment6_id,gd.segment7_id,gd.segment8_id,gd.segment9_id,gd.segment10_id from gl g inner join gl_detail gd on g.gl_id = gd.gl_id where g.posted_status = 0 and gd.coa_id=" + coa.getOID() + " and to_days(g.trans_date) >= to_days('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "') and to_days(g.trans_date) <= to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "') " + " ) as x " + whereMd2 + " order by trans_date ";
                                                                                            }

                                                                                        }
                                                                                    }

                                                                                    crs = CONHandler.execQueryResult(sql);
                                                                                    ResultSet rs = crs.getResultSet();
                                                                                    int x = 0;
                                                                                    while (rs.next()) {

                                                                                        data = true;
                                                                                        if (x == 0) {
                                                                                            sesReportDetail = new SesReportGl();
                                                                                            sesReportDetail.setType("Coa");
                                                                                            sesReportDetail.setDescription(coa.getCode() + " - " + coa.getName());
                                                                                            sesReportDetail.setAccGroup(coa.getAccountGroup());
                                                                                            listReportGL.add(sesReportDetail);

                                                                                            sesReportDetail = new SesReportGl();
                                                                                            sesReportDetail.setType("Header");
                                                                                            listReportGL.add(sesReportDetail);

                                                                                            if (!(coa.getAccountGroup().equals("Expense") || coa.getAccountGroup().equals("Other Expense") ||
                                                                                                    coa.getAccountGroup().equals("Revenue") || coa.getAccountGroup().equals("Other Revenue"))) {

                                                                                                sesReportDetail = new SesReportGl();
                                                                                                sesReportDetail.setType("Detail");
                                                                                                sesReportDetail.setStrTransDate("-");
                                                                                                sesReportDetail.setJournalNumber("-");
                                                                                                sesReportDetail.setMemo(langFR[8]);
                                                                                                sesReportDetail.setDebet(0);
                                                                                                sesReportDetail.setCredit(0);
                                                                                                sesReportDetail.setBalance(openingBalance);
                                                                                                listReportGL.add(sesReportDetail);

                                                                                                sesReportGl = new SesReportGl();
                                                                                                sesReportGl.setStrTransDate("-");
                                                                                                sesReportGl.setJournalNumber("-");
                                                                                                sesReportGl.setMemo(langFR[8]);
                                                                                                sesReportGl.setDebet(0);
                                                                                                sesReportGl.setCredit(0);
                                                                                                sesReportGl.setBalance(openingBalance);
                                                                                                vSesDep.add(sesReportGl);
                                                                                            }
                                                                                        }

                                                                                        Date transDate = rs.getDate("trans_date");
                                                                                        double debet = rs.getDouble("debet");
                                                                                        double credit = rs.getDouble("credit");
                                                                                        String journalNumber = rs.getString("journal_number");
                                                                                        String memo = rs.getString("memo");
                                                                                        if (isDebetPosition) {
                                                                                            openingBalance = openingBalance + (debet - credit);
                                                                                        } else {
                                                                                            openingBalance = openingBalance + (credit - debet);
                                                                                        }
                                                                                        totalDebet = totalDebet + debet;
                                                                                        totalCredit = totalCredit + credit;

                                                                                        String styleCss = "";
                                                                                        if (x % 2 == 0) {
                                                                                            styleCss = "tablearialcell";
                                                                                        } else {
                                                                                            styleCss = "tablearialcell1";
                                                                                        }
                                                                                        x++;

                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td class="<%=styleCss%>"> 
                                                                                                            <div align="center"><%=JSPFormater.formatDate(transDate, "dd/MM/yyyy")%></div>
                                                                                                        </td>
                                                                                                        <td class="<%=styleCss%>"> 
                                                                                                            <div align="center"><%=journalNumber%></div>
                                                                                                        </td>
                                                                                                        <td class="<%=styleCss%>"><%=memo%></td>
                                                                                                        <td class="<%=styleCss%>"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(debet, "#,###.##") %></div>
                                                                                                        </td>
                                                                                                        <td class="<%=styleCss%>"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(credit, "#,###.##")%></div>
                                                                                                        </td>
                                                                                                        <td class="<%=styleCss%>"> 
                                                                                                            <div align="right"><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <%
                                                                                        sesReportDetail = new SesReportGl();
                                                                                        sesReportDetail.setType("Detail");
                                                                                        sesReportDetail.setStrTransDate(JSPFormater.formatDate(transDate, "dd/MM/yyyy"));
                                                                                        sesReportDetail.setTransDate(transDate);
                                                                                        sesReportDetail.setJournalNumber(journalNumber);
                                                                                        sesReportDetail.setMemo(memo);
                                                                                        sesReportDetail.setDebet(debet);
                                                                                        sesReportDetail.setCredit(credit);
                                                                                        sesReportDetail.setBalance(openingBalance);
                                                                                        listReportGL.add(sesReportDetail);

                                                                                        sesReportGl = new SesReportGl();
                                                                                        sesReportGl.setStrTransDate(JSPFormater.formatDate(transDate, "dd/MM/yyyy"));
                                                                                        sesReportGl.setTransDate(transDate);
                                                                                        sesReportGl.setJournalNumber(journalNumber);
                                                                                        sesReportGl.setMemo(memo);
                                                                                        sesReportGl.setDebet(debet);
                                                                                        sesReportGl.setCredit(credit);
                                                                                        sesReportGl.setBalance(openingBalance);
                                                                                        vSesDep.add(sesReportGl);

                                                                                    }

                                                                                } catch (Exception e) {
                                                                                }

                                                                                //Detail Report PDF
                                                                                if (data) {
                                                                                    sesReportDetail = new SesReportGl();
                                                                                    sesReportGl = new SesReportGl();


                                                                                    sesReportDetail.setType("Total");
                                                                                    sesReportDetail.setMemo("Total");
                                                                                    sesReportDetail.setDebet(totalDebet);
                                                                                    sesReportDetail.setCredit(totalCredit);
                                                                                    sesReportDetail.setBalance(openingBalance);
                                                                                    listReportGL.add(sesReportDetail);

                                                                                    sesReportGl.setMemo("Total");
                                                                                    sesReportGl.setDebet(totalDebet);
                                                                                    sesReportGl.setCredit(totalCredit);
                                                                                    sesReportGl.setBalance(openingBalance);
                                                                                    vSesDep.add(sesReportGl);
                                                                                }

                                                                                                    %>
                                                                                                    
                                                                                                    <tr height="1"> 
                                                                                                        <td colspan="6" bgcolor="#609836"></td>
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td class="tablearialcell1"></td>
                                                                                                        <td class="tablearialcell1"></td>
                                                                                                        <td class="tablearialcell1"> 
                                                                                                            <div align="right"><b>Total <%=baseCurrency.getCurrencyCode()%></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1"> 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalDebet, "#,###.##")%></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1"> 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(totalCredit, "#,###.##") %></b></div>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1"> 
                                                                                                            <div align="right"><b><%=JSPFormater.formatNumber(openingBalance, "#,###.##")%></b></div>
                                                                                                        </td>
                                                                                                    </tr>	
                                                                                                    <tr> 
                                                                                                        <td class="" height="3" colspan="6"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
                                                                                sesReport = new SesReportBs();
                                                                                if (data) {
                                                                                    sesReport.setDescription(coa.getCode() + " - " + coa.getName());
                                                                                    sesReport.setStrAmount(coa.getAccountGroup());
                                                                                    sesReport.setDepartment(vSesDep);
                                                                                    listReport.add(sesReport);
                                                                                }
                                                                            %>
                                                                            <%}
                }
            }%>                                                             
                                                                            <%if (dataReady == false) {%>
                                                                            <tr> 
                                                                                <td class="fontarial"><b><i>Data not found.....</i></b></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="50%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="15%"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back1','','../images/back2.gif',1)"><img src="../images/back.gif" name="back1"  border="0" height="22"></a></td>
                                                                                            <%if (dataReady) {%>
                                                                                            <td width="15%"><a href="javascript:cmdPrintJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1111','','../images/print2.gif',1)"><img src="../images/print.gif" name="new1111"  border="0" width="53" height="22"></a></td>
                                                                                            <td width="25%"><a href="javascript:cmdPrintJournalXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new1112','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="new1112"  border="0" width="120" height="22"></a></td>
                                                                                            <%}%>
                                                                                            <td width="60%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>                                                                           
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                            </table>
                                                            <%
            tmpXls.add(langFR); //add multi language
            tmpXls.add(listReport); //add report item
            session.putValue("GL_REPORT", tmpXls);
            session.putValue("GL_REPORT_PDF", listReportGL);							
                                                            %>
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
