
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
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
            if (session.getValue("PROFIT_MULTIPLE") != null) {
                session.removeValue("PROFIT_MULTIPLE");
            }

            String grpType = JSPRequestValue.requestString(request, "groupType");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            String accGroup = JSPRequestValue.requestString(request, "acc_group");
            int valShowList = JSPRequestValue.requestInt(request, "showlist");

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

            /*variable declaration*/
            int recordToGet = 10;
            int iErrCode = JSPMessage.NONE;
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
            String cssString = "tablecell1";
            Vector listReport = new Vector();
            SesReportBs sesReport = new SesReportBs();
            Vector vSesDep = new Vector();

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

            String where = " to_days(start_date) >= to_days('" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "')" +
                    " and to_days(end_date)<=to_days('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "')";

            Vector temp = DbPeriode.list(0, 0, where, "start_date");

            /*** LANG ***/
            String[] langFR = {"Show List", "Account With Transaction", "All", "Year", "PROFIT & LOSS STATEMENT", "MULTIPLE PERIODS", //0-5
                "Description", "Total", "Net Income"}; //6-8
            String[] langNav = {"Financial Report", "Profit & Loss Multiple Period"};

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Akun Dengan Transaksi", "Semua", "Tahun", "LAPORAN LABA RUGI", "MULTI PERIODE", //0-5
                    "Keterangan", "Total", "Pendapatan Bersih"}; //6-8
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Laba Rugi Multi Periode"};
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
            
            function cmdGO(){
                document.frmcoa.action="profitlossmultiple.jsp";
                document.frmcoa.command.value="<%=JSPCommand.LIST%>";
                document.frmcoa.submit();
            }
            
            function cmdPrintJournal(){	 
                window.open("<%=printroot%>.report.RptProfitLossMultiplePDF?oid=<%=appSessUser.getLoginId()%>&year=<%=yearselect%>");
                }
                
                function cmdPrintJournalXLS(){	 
                    window.open("<%=printroot%>.report.RptProfitLossMultipleXLS?oid=<%=appSessUser.getLoginId()%>&year=<%=yearselect%>");
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
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="2">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"></td>
                                                                            </tr>             
                                                                            <tr align="left" valign="top"> 
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
                                                                            </tr>
                                                                            <%if (isGereja || (vSeg != null && vSeg.size() > 0)) {%>
                                                                            <tr align="left" valign="top"> 
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
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">
                                                                                    <table width="280" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="middle">
                                                                                            <td width="100"><%=langFR[3]%></td>
                                                                                            <td width="180" colspan="0"> 
                                                                                                <select name="year">
                                                                                                    <option value="<%=year%>" <%if (year == yearselect) {%>selected<%}%>><%=(year + 1900)%></option>
                                                                                                    <option value="<%=year - 1%>" <%if ((year - 1) == yearselect) {%>selected<%}%>><%=year - 1 + 1900%></option>
                                                                                                    <option value="<%=year - 2%>" <%if ((year - 2) == yearselect) {%>selected<%}%>><%=year - 2 + 1900%></option>
                                                                                                </select>
                                                                                            </td>                                                              
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
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
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" colspan="3"></td>
                                                                            </tr>                          
                                                                            <tr align="left" valign="top">
                                                                                <td height="20" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                                                                        <tr> 
                                                                                            <td height="20" valign="middle" align="center"><font face="arial" size="4"><b><%=langFR[4]%></b></font></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                          
                                                                            <%
            Periode periode = DbPeriode.getOpenPeriod();
            String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");
                                                                            %>        
                                                                            <tr align="left" valign="top">
                                                                                <td height="20" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                                                                        <tr> 
                                                                                            <td height="20" valign="middle" align="center"><font face="arial" size=="3"><b><%=langFR[5]%></b></font></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                          
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" valign="middle" colspan="3"></td>
                                                                            </tr>                                  
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">                                        
                                                                                        <tr> 
                                                                                            <td class="tablehdr" height="22"><div align="center"><b><font color="#FFFFFF"><%=langFR[6]%></font></b></div></td>
                                                                                            <%
            for (int ix = 0; ix < temp.size(); ix++) {
                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablehdr" width="100"><%=per.getName()%></td>
                                                                                            <%}%>
                                                                                            <td width="100" class="tablehdr" height="22"><%=langFR[7]%></td>
                                                                                        </tr>
                                                                                        <!--level ACC_GROUP_REVENUE-->
                                                                                 <%
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, temp, "CD", whereMd) != 0 || valShowList != 1) {	//add Group Header

                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_REVENUE);
                sesReport.setFont(1);
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_REVENUE%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
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

                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {

                        str = switchLevel(coa.getLevel());
                        str1 = switchLevel1(coa.getLevel());

                        if (valShowList == 1) {
                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD", temp, whereMd) != 0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd) != 0)) {	//add detail
                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "CD"));
                                sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "CD"));
                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                vSesDep = new Vector();
                                for (int ix = 0; ix < temp.size(); ix++) {
                                    Periode per = (Periode) temp.get(ix);
                                    vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "CD", whereMd));
                                }
                                sesReport.setDepartment(vSesDep);
                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "CD", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%				}
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd) != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd));
                                                                                                            sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd));
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "CD", whereMd));
                                                                                                            }
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "CD", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%					}
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, temp, "CD", whereMd) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_REVENUE);
                                                                                                sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, temp, "CD", whereMd));
                                                                                                sesReport.setStrAmount("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, temp, "CD", whereMd));
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", per, whereMd));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_REVENUE%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", per, whereMd), coa.getStatus())%></b></div></td>
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
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, temp, "CD", whereMd), coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                }
            }
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, temp, "CD", whereMd) != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <!--level 2-->
                                                                                        <!--level ACC_GROUP_EXPENSE-->
                                                                                 <%
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Group Header
                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_COST_OF_SALES);
                sesReport.setFont(1);
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_COST_OF_SALES%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>
                                                                                        <%	}%>									
                                                                                        <%
            if (listCoa != null && listCoa.size() > 0) {
                String str = "";
                String str1 = "";
                for (int i = 0; i < listCoa.size(); i++) {
                    coa = (Coa) listCoa.get(i);
                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                        str = switchLevel(coa.getLevel());
                        str1 = switchLevel1(coa.getLevel());
                        if (valShowList == 1) {
                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC", temp, whereMd) != 0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd) != 0)) {	//add detail
                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                vSesDep = new Vector();
                                for (int ix = 0; ix < temp.size(); ix++) {
                                    Periode per = (Periode) temp.get(ix);
                                    vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd));
                                }
                                sesReport.setDepartment(vSesDep);
                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%				}
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd) != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                                                                                            sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd));
                                                                                                            }
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%              }
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_COST_OF_SALES);
                                                                                                sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, temp, "DC", whereMd));
                                                                                                sesReport.setStrAmount("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, temp, "DC", whereMd));
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", per, whereMd));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_COST_OF_SALES%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>                                                                                                        
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", per, whereMd), coa.getStatus())%></b></div></td>
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
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, temp, "DC", whereMd), coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                }
            }
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%	}%>
                                                                                        <!--level 3-->
                                                                                        <!--level ACC_GROUP_EXPENSE-->
                                                                                 <%
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Group Header
                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_EXPENSE);
                sesReport.setFont(1);
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_EXPENSE%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell"></td>
                                                                                        </tr>	
                                                                                        <%	}%>								
                                                                                        <%
            if (listCoa != null && listCoa.size() > 0) {
                String str = "";
                String str1 = "";
                for (int i = 0; i < listCoa.size(); i++) {
                    coa = (Coa) listCoa.get(i);

                    if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                        str = switchLevel(coa.getLevel());
                        str1 = switchLevel1(coa.getLevel());
                        if (valShowList == 1) {
                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC", temp, whereMd) != 0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd) != 0)) {	//add detail
                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                vSesDep = new Vector();
                                for (int ix = 0; ix < temp.size(); ix++) {
                                    Periode per = (Periode) temp.get(ix);
                                    vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd));
                                }
                                sesReport.setDepartment(vSesDep);
                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%				}
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd) != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                                                                                            sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd));
                                                                                                            }
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>	
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%					}
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_EXPENSE);
                                                                                                sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, temp, "DC", whereMd));
                                                                                                sesReport.setStrAmount("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, temp, "DC", whereMd));
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", per, whereMd));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_EXPENSE%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", per, whereMd), coa.getStatus())%></b></div></td>
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
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, temp, "DC", whereMd), coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                }
            }
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <!--level 4-->
                                                                                        <!--level ACC_GROUP_OTHER_REVENUE-->
                                                                                 <%
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, temp, "CD", whereMd) != 0 || valShowList != 1) {	//add Group Header
                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_OTHER_REVENUE);
                sesReport.setFont(1);
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_REVENUE%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
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
                        if (valShowList == 1) {
                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD", temp, whereMd) != 0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd) != 0)) {	//add detail
                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd));
                                sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd));
                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                vSesDep = new Vector();
                                for (int ix = 0; ix < temp.size(); ix++) {
                                    Periode per = (Periode) temp.get(ix);
                                    vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "CD", whereMd));
                                }
                                sesReport.setDepartment(vSesDep);
                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>	
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "CD", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%				}
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd) != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd));
                                                                                                            sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd));
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "CD", whereMd));
                                                                                                            }
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>													
                                                                                                        
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "CD", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "CD", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%		}
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, temp, "CD", whereMd) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_OTHER_REVENUE);
                                                                                                sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, temp, "CD", whereMd));
                                                                                                sesReport.setStrAmount("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, temp, "CD", whereMd));
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", per, whereMd));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_OTHER_REVENUE%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", per, whereMd), coa.getStatus())%></b></div></td>
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
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, temp, "CD", whereMd), coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                }
            }
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, temp, "CD", whereMd) != 0 || valShowList != 1) {	//add Space
                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>										  
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <!--level 5-->
                                                                                        <!--level ACC_GROUP_OTHER_EXPENSE-->
                                                                                 <%
            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Group Header
                sesReport = new SesReportBs();
                sesReport.setType("Group Level");
                sesReport.setDescription(I_Project.ACC_GROUP_OTHER_EXPENSE);
                sesReport.setFont(1);
                vSesDep = new Vector();
                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_EXPENSE%></b></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
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
                        if (valShowList == 1) {
                            if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC", temp, whereMd) != 0) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd) != 0)) {	//add detail
                                sesReport = new SesReportBs();
                                sesReport.setType(coa.getStatus());
                                sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                vSesDep = new Vector();
                                for (int ix = 0; ix < temp.size(); ix++) {
                                    Periode per = (Periode) temp.get(ix);
                                    vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd));
                                }
                                sesReport.setDepartment(vSesDep);
                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%				}
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd) != 0)) {	//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                                                                                            sesReport.setStrAmount("" + DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd));
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            vSesDep = new Vector();
                                                                                                            for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                                Periode per = (Periode) temp.get(ix);
                                                                                                                vSesDep.add("" + DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd));
                                                                                                            }
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap><%if (coa.getStatus().equals("HEADER")) {%><b><%}%><%=strTotal + str + coa.getCode() + " - " + coa.getName()%><%if (coa.getStatus().equals("HEADER")) {%></b><%}%></td>                                          
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="<%=cssString%>">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>	
                                                                                                        <td width="90%" class="<%=cssString%>" nowrap>
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), per, "DC", whereMd), coa.getStatus())%></div></td>
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
                                                                                                        <div align="right"><%=strDisplay(DbCoa.getCoaBalance(coa.getOID(), temp, "DC", whereMd), coa.getStatus())%></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>									
                                                                                        <%					}
                                                                                                    }
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Group Footer
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType("Footer Group Level");
                                                                                                sesReport.setDescription("Total " + I_Project.ACC_GROUP_OTHER_EXPENSE);
                                                                                                sesReport.setAmount(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, temp, "DC", whereMd));
                                                                                                sesReport.setStrAmount("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, temp, "DC", whereMd));
                                                                                                sesReport.setFont(1);
                                                                                                vSesDep = new Vector();
                                                                                                for (int ix = 0; ix < temp.size(); ix++) {
                                                                                                    Periode per = (Periode) temp.get(ix);
                                                                                                    vSesDep.add("" + DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", per, whereMd));
                                                                                                }
                                                                                                sesReport.setDepartment(vSesDep);
                                                                                                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_OTHER_EXPENSE%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                        Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>
                                                                                                        
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", per, whereMd), coa.getStatus())%></b></div></td>
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
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, temp, "DC", whereMd), coa.getStatus())%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                }
            }

            if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, temp, "DC", whereMd) != 0 || valShowList != 1) {	//add Space

                sesReport = new SesReportBs();
                sesReport.setType("Space");
                sesReport.setDescription("");
                vSesDep = new Vector();

                for (int ix = 0; ix < temp.size(); ix++) {
                    Periode per = (Periode) temp.get(ix);
                    vSesDep.add("0");
                }
                sesReport.setDepartment(vSesDep);
                listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                                                                                            Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell1"></td>
                                                                                            <%}%>										  									  										  
                                                                                            <td class="tablecell1"></td>
                                                                                        </tr>
                                                                                        <%}%>                                                                                        
                                                                                        <%
            sesReport = new SesReportBs();
            sesReport.setType("Last Level");
            sesReport.setDescription("Net Income");
            sesReport.setAmount(DbCoa.getNetIncomeByPeriod(temp, whereMd));
            sesReport.setStrAmount("" + (DbCoa.getNetIncomeByPeriod(temp, whereMd)));
            sesReport.setFont(1);
            vSesDep = new Vector();

            for (int ix = 0; ix < temp.size(); ix++) {
                Periode per = (Periode) temp.get(ix);
                vSesDep.add("" + DbCoa.getNetIncomeByPeriod(per, whereMd));
            }

            sesReport.setDepartment(vSesDep);
            listReport.add(sesReport);
                                                                                        %>										
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%=langFR[8]%></b></span></td>
                                                                                            <%for (int ix = 0; ix < temp.size(); ix++) {
                Periode per = (Periode) temp.get(ix);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td width="5%"></td>                                                                                                        
                                                                                                        <td width="90%" class="tablecell2" nowrap>
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getNetIncomeByPeriod(per, whereMd), "")%></b></div></td>
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
                                                                                                        <div align="right"><b><%=strDisplay(DbCoa.getNetIncomeByPeriod(temp, whereMd), "")%></b></div></td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>												  			  
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <%
            session.putValue("PROFIT_MULTIPLE", listReport);
                                                                %>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container"></td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container"> 
                                                                        <%if (listCoa != null && listCoa.size() > 0) {%>
                                                                        <table width="200" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>                                                                                
                                                                                <td width="60"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                                                                <td width="20">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="60">&nbsp;</td>
                                                                                <td width="0">&nbsp;</td>
                                                                                <td width="120">&nbsp;</td>
                                                                                <td width="20">&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td width="60">&nbsp;</td>
                                                                                <td width="0">&nbsp;</td>
                                                                                <td width="120">&nbsp;</td>
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
