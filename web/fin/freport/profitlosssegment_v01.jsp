
<%-- 
    Document   : profitlosssegment_v01
    Created on : Mar 4, 2013, 12:25:35 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.payroll.*" %>
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
            if (session.getValue("PROFIT0YTD") != null) {
                session.removeValue("PROFIT0YTD");
            }
            
            if (session.getValue("PERIODIDYTD") != null) {
                session.removeValue("PERIODIDYTD");
            }
            
            if (session.getValue("LOCATIONIDYTD") != null) {
                session.removeValue("LOCATIONIDYTD");
            }
            
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");
            long periodeId = JSPRequestValue.requestLong(request, "periode_id");

            boolean isGereja = DbSystemProperty.getModSysPropGereja();
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);
            String whereMd = "";
            String oidMd = "";
            String whereLocation = "";
            long segment1Id = 0;

            if (vSeg != null && vSeg.size() > 0 && iJSPCommand != JSPCommand.NONE){

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
                            whereLocation = DbCoaOpeningBalanceLocation.colNames[DbCoaOpeningBalanceLocation.FLD_SEGMENT1_ID]+" = "+ segment_id;
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

            Periode periode = new Periode();
            if (periodeId == 0) {
                periode = DbPeriode.getOpenPeriod();
            } else {
                try {
                    periode = DbPeriode.fetchExc(periodeId);
                } catch (Exception e) {
                }
            }

            Date dt = periode.getStartDate();
            Date startDate = (Date) dt.clone();
            startDate.setYear(startDate.getYear() - 1);
            startDate.setDate(startDate.getDate() + 10);
            
            Periode lastPeriod = new Periode();
            try{
                lastPeriod = DbPeriode.getPeriodByTransDate(startDate);
            }catch(Exception e){}

            int valShowList = JSPRequestValue.requestInt(request, "showlist");
            if (valShowList == 0) {
                valShowList = 1;
            }

            Vector listCoa = new Vector(1, 1);
            Coa coa = new Coa();

            String strTotal = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            String strTotal1 = "       ";
            String cssString = "tablecell1";
            String displayStr = "";
            String displayStr1 = "";
            String strAmount = "";

            double coaSummary1 = 0;
            double coaSummary2 = 0;
            double coaSummary3 = 0;
            double coaSummary4 = 0;
            double coaSummary5 = 0;

            double totalPrevRev = 0;
            double totalPrevCOS = 0;
            double totalPrevExp = 0;
            double totalPrevORev = 0;
            double totalPrevOExp = 0;
            
            double totalRev = 0;
            double totalCOS = 0;
            double totalExp = 0;
            double totalORev = 0;
            double totalOExp = 0;

            Vector listReport = new Vector();
            SesReportBs sesReport = new SesReportBs();

            Vector vDep = new Vector();
            vDep = DbDepartment.list(0, 0, DbDepartment.colNames[DbDepartment.COL_LEVEL] + "=" + DbDepartment.LEVEL_DIREKTORAT, DbDepartment.colNames[DbDepartment.COL_CODE]);
            Vector vSesDep = new Vector();

            /*** LANG ***/
            String[] langFR = {"Show List", "Account With Transaction", "All", "PROFIT & LOSS STATEMENT", "PERIOD", "Department", //0-5
                "Description", "P&L Prev. Period", "Net Income", "Location"}; //6-9
            String[] langNav = {"Financial Report", "Profit & Loss (by Location)", "Previous Period", "Period","Klik GO button to searching the data"};

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "LAPORAN LABA RUGI", "PERIODE", "Departemen", //0-5
                    "Keterangan", "Laba Rugi Periode Sebelumnya", "Pendapatan Bersih", "Lokasi"}; //6-9
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Laba Rugi ( Lokasi) ", "Periode Sebelumnya", "Periode","Klik tombol GO untuk melakukan pencarian"};
                langNav = navID;
            }
            
            session.putValue("PERIODIDYTD", ""+periodeId);
            session.putValue("LOCATIONIDYTD", ""+segment1Id);
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
                document.frmcoa.action="profitlosssegment_v01.jsp";
                document.frmcoa.command.value="<%=JSPCommand.LIST%>";
                document.frmcoa.submit();
            }
            
            function cmdChangeList(){
                document.frmcoa.action="profitlosssegment_v01.jsp";
                document.frmcoa.submit();
            }
            
            function cmdPrintJournalXLS(){	 
                window.open("<%=printroot%>.report.RptProfitLossSegmentYTDXLS?oid=<%=appSessUser.getLoginId()%>");
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/printxls2.gif')">
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
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="2">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="320">                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" > 
                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="0" cellpadding="2">
                                                                                                    <tr height="10">
                                                                                                        <td colspan="4"></td>
                                                                                                    </tr>    
                                                                                                    <tr align="left" valign="middle"> 
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                        <td width="80"><%=langFR[0]%></td>
                                                                                                        <td width="180" colspan="0"> 
                                                                                                            <select name="showlist">
                                                                                                                <option value="1" <%if (valShowList == 1) {%>selected<%}%>><%=langFR[1]%></option>
                                                                                                                <option value="2" <%if (valShowList == 2) {%>selected<%}%>><%=langFR[2]%></option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%
            Vector vPeriode = new Vector();
            vPeriode = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc ");
                                                                                                    %>
                                                                                                    <tr align="left" valign="middle"> 
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langNav[3]%></td>
                                                                                                        <td > 
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
                                                                                                        <td >&nbsp;</td>
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
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td class="fontarial"><%=oSegment.getName()%></td>
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
                                                                                                                <option value="0" <%if (0 == seg_id) {%>selected<%}%>>< All <%=oSegment.getName()%> ></option>
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
                                                                                                        <td colspan="2"></td>
                                                                                                    </tr> 
                                                                                                    <%
                                                                                                            }
                                                                                                        }
                                                                                                    %>                                                                            
                                                                                                    <%}%>
                                                                                                    <tr align="left" valign="middle"> 
                                                                                                        <td colspan="2"></td>
                                                                                                        <td colspan="0"><input type="button" name="Button" value="GO" onClick="javascript:cmdGO()"></td>
                                                                                                    </tr>
                                                                                                    <tr height="10">
                                                                                                        <td colspan="4"></td>
                                                                                                    </tr> 
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" colspan="3"></td>
                                                                            </tr>
                                                                            <%if (iJSPCommand == JSPCommand.LIST) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font face = "arial" size="3"><b><%=langFR[3]%></b></font></span></td>
                                                                            </tr>
                                                                            <%    
    String prevPeriod = JSPFormater.formatDate(startDate, "MMM yyyy");                                                                                                                                                                                                       
    String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "MMM yyyy");    
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font face = "arial" size="3"><b><%=langFR[4]%> 
                                                                                <%=prevPeriod.toUpperCase()%> & <%=openPeriod.toUpperCase()%></b></font></span></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top">
                                                                                <td height="10" valign="middle" colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" valign="middle" colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                        <tr height="25"> 
                                                                                            <td width="400" class="tablehdr" height="22" nowrap>
                                                                                                <div align="center"><b><font color="#FFFFFF"><%=langFR[6].toUpperCase()%></font></b></div>
                                                                                            </td>
                                                                                            <td width="120" class="tablehdr" height="22" nowrap><%=prevPeriod.toUpperCase()%></td>
                                                                                            <td width="120" class="tablehdr" height="22" nowrap><%=openPeriod.toUpperCase()%></td>
                                                                                        </tr>
                                                                                        <!--level ACC_GROUP_REVENUE-->
            <%            
    double groupRev = DbCoa.getIsCoaBalanceByGroup(I_Project.ACC_GROUP_REVENUE, "CD", whereMd, periode, whereLocation);        
    
    if (valShowList != 1 || groupRev != 0){//add Group Header                
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_REVENUE);
        sesReport.setFont(1);
        vSesDep = new Vector();
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_REVENUE%></b></td>
                                                                                            <td class="tablecell" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}
    listCoa = DbCoa.list(0, 0, DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + " ='Revenue'", DbCoa.colNames[DbCoa.COL_CODE]);       
    if (listCoa != null && listCoa.size() > 0) {
        coaSummary1 = 0;
        String str = "";
        String str1 = "";

        for (int i = 0; i < listCoa.size(); i++) {

            coa = (Coa) listCoa.get(i);

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)){

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());
                double amount = 0;
                if (!coa.getStatus().equals("HEADER")) {                    
                    amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"CD");
                }

                strAmount = "" + amount;   
                coaSummary1 = coaSummary1 + amount;                            
                displayStr = strDisplay(amount, coa.getStatus());
                
                double balanceByHeader = DbCoa.getIsCoaBalanceByHeader(coa.getOID(), "CD", whereMd, periode, whereLocation); 
                if (valShowList == 1) {
                    
                    if ((coa.getStatus().equals("HEADER") && balanceByHeader != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {
                        double balancePrev = 0;
                        if (!coa.getStatus().equals("HEADER")) {   
                            balancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"CD");
                        }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap>
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(balancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevRev = totalPrevRev + balancePrev; %>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                                            vSesDep = new Vector();
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"CD");                                                                                                            
                                                                                                            }
                                                                                                            totalRev = totalRev + amount;                                                                                                            
                                                                                                            displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                                            vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right">
                                                                                                                <%=displayStr1%> 
                                                                                                                <%displayStr1 = "";%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                            //add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(balancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {
                                                                                                            
                                                                                                            double balancePrev = 0;
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                balancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"CD");
                                                                                                            }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(balancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevRev = totalPrevRev + balancePrev;%>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                        
                                                                                        if (!coa.getStatus().equals("HEADER")) {     
                                                                                            amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"CD");                                                                                        
                                                                                        }
                                                                                        totalRev = totalRev + amount ;
                                                                                        displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                        vSesDep = new Vector();
                                                                                        vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%> 
                                                                                                                <%displayStr1 = "";%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                        //add detail
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType(coa.getStatus());
                                                                                        sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                        sesReport.setAmount(amount);
                                                                                        sesReport.setStrAmount(strAmount);
                                                                                        sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                        sesReport.setDepartment(vSesDep);
                                                                                        if (!coa.getStatus().equals("HEADER")) {
                                                                                            sesReport.setBalance(balancePrev);
                                                                                        }
                                                                                        listReport.add(sesReport);
                                                                                            %>
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
                                                                                            }//add footer level
                                                                                            if (valShowList != 1 || groupRev != 0) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_REVENUE%></b></span></td>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=strDisplay(totalPrevRev, "")%></b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%                                                                                    
                                                                                    displayStr1 = strDisplay(totalRev, "");
                                                                                    vSesDep = new Vector();
                                                                                    vSesDep.add("" + totalRev);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=displayStr1%><%displayStr1 = "";%></b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            //add Group Footer
            sesReport = new SesReportBs();
            sesReport.setType("Footer Group Level");
            sesReport.setDescription("Total " + I_Project.ACC_GROUP_REVENUE);
            sesReport.setAmount(coaSummary1);
            sesReport.setStrAmount("" + coaSummary1);
            sesReport.setFont(1);
            sesReport.setDepartment(vSesDep);
            sesReport.setBalance(totalPrevRev);
            listReport.add(sesReport);
            
        }
    }

    if (valShowList != 1 || groupRev != 0 ) {//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <td class="tablecell1" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>                                                                                        
                                                                                        <!--level 2-->
                                                                                        <!--level ACC_GROUP_EXPENSE-->
            <%
    double groupCOS = DbCoa.getIsCoaBalanceByGroup(I_Project.ACC_GROUP_COST_OF_SALES, "DC", whereMd, periode, whereLocation);
           
    if (valShowList != 1 || groupCOS != 0) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_COST_OF_SALES);
        sesReport.setFont(1);
        vSesDep = new Vector();
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_COST_OF_SALES%></b></td>
                                                                                            <td class="tablecell" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
    listCoa = DbCoa.list(0, 0, "account_group='Cost Of Sales' ", "code");
    if (listCoa != null && listCoa.size() > 0) {
        coaSummary2 = 0;
        String str = "";
        String str1 = "";
        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());
                double amount = 0;
                if (!coa.getStatus().equals("HEADER")) {                    
                    amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"DC");                                                                                        
                }
                strAmount = "" + amount;
                coaSummary2 = coaSummary2 + amount;
                displayStr = strDisplay(amount, coa.getStatus());
                
                double balanceByHeader = DbCoa.getIsCoaBalanceByHeader(coa.getOID(), "DC", whereMd, periode, whereLocation);

                if (valShowList == 1) {
                    if (((!coa.getStatus().equals("HEADER")) && amount != 0) || (coa.getStatus().equals("HEADER") && balanceByHeader != 0)){
                        double openingBalancePrev = 0;
                        if (!coa.getStatus().equals("HEADER")) { 
                            openingBalancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"DC");     
                        }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap>
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>">                                                                                                         
                                                                                                            <div align="right"><%=strDisplay(openingBalancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevCOS = totalPrevCOS + openingBalancePrev;%>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                                            vSesDep = new Vector();                                                                                                            
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"DC"); 
                                                                                                            }
                                                                                                            totalCOS = totalCOS + amount;                                                                                                            
                                                                                                            displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                                            vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%><%displayStr1 = "";%></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%					//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(openingBalancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {                                                                                                            
                                                                                                            double openingBalancePrev = 0;
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                openingBalancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"DC");                                                                                                                
                                                                                                            }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(openingBalancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevCOS = totalPrevCOS + openingBalancePrev;%>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                        if (!coa.getStatus().equals("HEADER")) {     
                                                                                            amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"DC"); 
                                                                                        }
                                                                                        displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                        totalCOS = totalCOS + amount;
                                                                                        vSesDep = new Vector();
                                                                                        vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%> 
                                                                                                                <%displayStr1 = "";%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%						//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(openingBalancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                if (coaSummary2 < 0) {
                                                                                                    displayStr = "(" + JSPFormater.formatNumber(coaSummary2 * -1, "#,###.##") + ")";
                                                                                                } else if (coaSummary2 > 0) {
                                                                                                    displayStr = JSPFormater.formatNumber(coaSummary2, "#,###.##");
                                                                                                } else if (coaSummary2 == 0) {
                                                                                                    displayStr = "";
                                                                                                }
                                                                                            }				//add footer level
        
                                                                                            if (valShowList != 1 || groupCOS != 0 ) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_COST_OF_SALES%></b></span></td>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=strDisplay(totalPrevCOS, "")%></b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                            vSesDep = new Vector();                                                                            
                                                                            displayStr1 = strDisplay(totalCOS, "");
                                                                            vSesDep.add("" + totalCOS);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b>
                                                                                                                    <%=displayStr1%> 
                                                                                                                    <%displayStr1 = "";%>
                                                                                                            </b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%							//add Group Footer
            sesReport = new SesReportBs();
            sesReport.setType("Footer Group Level");
            sesReport.setDescription("Total " + I_Project.ACC_GROUP_COST_OF_SALES);
            sesReport.setAmount(coaSummary2);
            sesReport.setStrAmount("" + coaSummary2);
            sesReport.setFont(1);
            sesReport.setDepartment(vSesDep);
            sesReport.setBalance(totalPrevCOS);
            listReport.add(sesReport);
        }
    }

    if ( groupCOS != 0 || valShowList != 1) {	//add Space

        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        for (int i = 0; i < vDep.size(); i++) {
            vSesDep.add("0");
        }
        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <td class="tablecell1" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <!--level 3-->
                                                                                        <!--level ACC_GROUP_EXPENSE-->
                                        <%
                                        
    double groupExp = DbCoa.getIsCoaBalanceByGroup(I_Project.ACC_GROUP_EXPENSE, "DC", whereMd, periode, whereLocation);
                                       
    if ( valShowList != 1 || groupExp != 0) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_EXPENSE);
        sesReport.setFont(1);
        vSesDep = new Vector();
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_EXPENSE%></b></td>
                                                                                            <td class="tablecell" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
    listCoa = DbCoa.list(0, 0, "account_group='Expense' ", "code");
    if (listCoa != null && listCoa.size() > 0) {
        coaSummary3 = 0;
        String str = "";
        String str1 = "";

        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());
                double amount = 0;
                if (!coa.getStatus().equals("HEADER")) {
                    amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"DC");                        
                }
                strAmount = "" + amount;
                coaSummary3 = coaSummary3 + amount;
                displayStr = strDisplay(amount, coa.getStatus());
                double balanceByHeader = DbCoa.getIsCoaBalanceByHeader(coa.getOID(), "DC", whereMd, periode, whereLocation);
                
                if (valShowList == 1) {
                    if (((!coa.getStatus().equals("HEADER")) && amount != 0) || (coa.getStatus().equals("HEADER") && balanceByHeader != 0)) {
                        
                        double openingBalancePrev = 0;
                        if (!coa.getStatus().equals("HEADER")) { 
                            openingBalancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"DC"); 
                        }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(openingBalancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevExp = totalPrevExp + openingBalancePrev; %>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                                            vSesDep = new Vector();
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"DC");       
                                                                                                            }
                                                                                                            totalExp = totalExp+ amount;                                                                                                                                                                                                                 
                                                                                                            displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                                            vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%><%displayStr1 = "";%></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%					//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(openingBalancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {                                                                                                            
                                                                                                            double openingBalancePrev = 0;
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                openingBalancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"DC"); 
                                                                                                            }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(openingBalancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevExp = totalPrevExp + openingBalancePrev; %>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep = new Vector();
                                                                                        if (!coa.getStatus().equals("HEADER")) { 
                                                                                            amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"DC"); 
                                                                                        }
                                                                                        totalExp = totalExp + amount;
                                                                                        displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                        vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%><%displayStr1 = "";%></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%						//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(openingBalancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                if (coaSummary3 < 0) {
                                                                                                    displayStr = "(" + JSPFormater.formatNumber(coaSummary3 * -1, "#,###.##") + ")";
                                                                                                } else if (coaSummary3 > 0) {
                                                                                                    displayStr = JSPFormater.formatNumber(coaSummary3, "#,###.##");
                                                                                                } else if (coaSummary3 == 0) {
                                                                                                    displayStr = "";
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (valShowList != 1 || groupExp != 0) {                                                                                                
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_EXPENSE%></b></span></td>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=strDisplay(totalPrevExp, "")%></b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                            vSesDep = new Vector();
                                                                            double amount = totalExp;
                                                                            displayStr1 = strDisplay(amount, "");
                                                                            vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=displayStr1%> 
                                                                                                                    <%displayStr1 = "";%>
                                                                                                            </b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%							//add Group Footer
            sesReport = new SesReportBs();
            sesReport.setType("Footer Group Level");
            sesReport.setDescription("Total " + I_Project.ACC_GROUP_EXPENSE);
            sesReport.setAmount(coaSummary3);
            sesReport.setStrAmount("" + coaSummary3);
            sesReport.setFont(1);
            sesReport.setDepartment(vSesDep);
            sesReport.setBalance(totalPrevExp);
            listReport.add(sesReport);
        }
    }

    if (valShowList != 1 || groupExp != 0) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <td class="tablecell1" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        

                                                                                        <!--level 4-->
                                                                                        <!--level ACC_GROUP_OTHER_REVENUE-->
            <%
    double groupORev = DbCoa.getIsCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_REVENUE, "CD", whereMd, periode, whereLocation);      
            
    if ( valShowList != 1 || groupORev != 0) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_OTHER_REVENUE);
        sesReport.setFont(1);
        vSesDep = new Vector();
        vSesDep.add("0");

        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_REVENUE%></b></td>
                                                                                            <td class="tablecell" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
    listCoa = DbCoa.list(0, 0, "account_group='Other Revenue' ", "code");

    if (listCoa != null && listCoa.size() > 0) {
        coaSummary4 = 0;
        String str = "";
        String str1 = "";
        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());
                double amount = 0;
                if (!coa.getStatus().equals("HEADER")) {
                    amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"CD"); 
                }

                strAmount = "" + amount;
                coaSummary4 = coaSummary4 + amount;
                displayStr = strDisplay(amount, coa.getStatus());
                
                double balanceByHeader = DbCoa.getIsCoaBalanceByHeader(coa.getOID(), "CD", whereMd, periode, whereLocation);
                if (valShowList == 1) {
                    if ((coa.getStatus().equals("HEADER") && balanceByHeader != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {
                        double openingBalancePrev = 0;
                        if (!coa.getStatus().equals("HEADER")) { 
                            openingBalancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"CD"); 
                        }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(openingBalancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevORev = totalPrevORev + openingBalancePrev; %>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                                            vSesDep = new Vector();
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"CD");                                                                                                            
                                                                                                            }
                                                                                                            displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                                            vSesDep.add("" + amount);
                                                                                                            totalORev = totalORev + amount; 
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%> 
                                                                                                                <%displayStr1 = "";%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%					//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(openingBalancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {
                                                                                                            double openingBalancePrev = 0;
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                openingBalancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"CD"); 
                                                                                                            }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(openingBalancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevORev = totalPrevORev + openingBalancePrev; %>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep = new Vector();
                                                                                        if (!coa.getStatus().equals("HEADER")) { 
                                                                                            amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"CD");                                                                                        
                                                                                        }
                                                                                        displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                        totalORev = totalORev + amount;
                                                                                        vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%> 
                                                                                                                <%displayStr1 = "";%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%						//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(openingBalancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                if (coaSummary4 < 0) {
                                                                                                    displayStr = "(" + JSPFormater.formatNumber(coaSummary4 * -1, "#,###.##") + ")";
                                                                                                } else if (coaSummary4 > 0) {
                                                                                                    displayStr = JSPFormater.formatNumber(coaSummary4, "#,###.##");
                                                                                                } else if (coaSummary4 == 0) {
                                                                                                    displayStr = "";
                                                                                                }
                                                                                            }				//add footer level
                                                                                            if (groupORev != 0 || valShowList != 1) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_OTHER_REVENUE%></b></span></td>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=strDisplay(totalPrevORev, "")%></b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                            vSesDep = new Vector();
                                                                            double amount = totalORev;
                                                                            displayStr1 = strDisplay(amount, "");
                                                                            vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=displayStr1%> 
                                                                                                                    <%displayStr1 = "";%>
                                                                                                            </b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%							//add Group Footer
            sesReport = new SesReportBs();
            sesReport.setType("Footer Group Level");
            sesReport.setDescription("Total " + I_Project.ACC_GROUP_OTHER_REVENUE);
            sesReport.setAmount(coaSummary4);
            sesReport.setStrAmount("" + coaSummary4);
            sesReport.setFont(1);
            sesReport.setDepartment(vSesDep);
            sesReport.setBalance(totalPrevORev);
            listReport.add(sesReport);
        }
    }
    
    if (groupORev != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        vSesDep = new Vector();
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        sesReport.setDescription("");
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <td class="tablecell1" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        
                                                                                        <!--level 5-->
                                                                                        <!--level ACC_GROUP_OTHER_EXPENSE-->
                                        <%
     double groupOExp = DbCoa.getIsCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_EXPENSE, "DC", whereMd, periode, whereLocation);                                        
    if (groupOExp != 0 || valShowList != 1) {	//add Group Header
        sesReport = new SesReportBs();
        sesReport.setType("Group Level");
        sesReport.setDescription(I_Project.ACC_GROUP_OTHER_EXPENSE);
        sesReport.setFont(1);
        vSesDep = new Vector();
        vSesDep.add("0");

        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                 %>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><b><%=I_Project.ACC_GROUP_OTHER_EXPENSE%></b></td>
                                                                                            <td class="tablecell" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
    listCoa = DbCoa.list(0, 0, "account_group='Other Expense' ", "code");
    if (listCoa != null && listCoa.size() > 0) {
        coaSummary5 = 0;
        String str = "";
        String str1 = "";
        for (int i = 0; i < listCoa.size(); i++) {
            coa = (Coa) listCoa.get(i);

            if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {

                str = switchLevel(coa.getLevel());
                str1 = switchLevel1(coa.getLevel());
                double amount = 0;
                if (!coa.getStatus().equals("HEADER")) {
                    amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"DC"); 
                }

                strAmount = "" + amount;
                coaSummary5 = coaSummary5 + amount;
                displayStr = strDisplay(amount, coa.getStatus());
                
                double balanceByHeader = DbCoa.getIsCoaBalanceByHeader(coa.getOID(), "DC", whereMd, periode, whereLocation);
                
                if (valShowList == 1) {
                    if ((coa.getStatus().equals("HEADER") && balanceByHeader != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {                        
                        double openingBalancePrev = 0;
                        if (!coa.getStatus().equals("HEADER")) { 
                            openingBalancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"DC"); 
                        }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(openingBalancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevOExp = totalPrevOExp + openingBalancePrev;  %>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                                            vSesDep = new Vector();
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, periode, whereLocation,"DC");      
                                                                                                            }
                                                                                                            totalOExp = totalOExp + amount;
                                                                                                            displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                                            vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%><%displayStr1 = "";%></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%					//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(openingBalancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    } else {
                                                                                                        if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {
                                                                                                            double openingBalancePrev = 0;
                                                                                                            if (!coa.getStatus().equals("HEADER")) { 
                                                                                                                openingBalancePrev = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"DC"); 
                                                                                                            }
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                <b> 
                                                                                                    <%}%>
                                                                                                    <%=strTotal + str + coa.getCode() + " - " + coa.getName()%> 
                                                                                                    <%if (coa.getStatus().equals("HEADER")) {%>
                                                                                                </b> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=strDisplay(openingBalancePrev, coa.getStatus())%></div>
                                                                                                            <%totalPrevOExp = totalPrevOExp + openingBalancePrev;  %>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                                        vSesDep = new Vector();
                                                                                        if (!coa.getStatus().equals("HEADER")) { 
                                                                                            amount = DbCoa.getCoaBalancePNLYTD(coa.getOID(), whereMd, lastPeriod, whereLocation,"DC"); 
                                                                                        }
                                                                                        totalOExp = totalOExp + amount;                                                                                                                                                                           
                                                                                        displayStr1 = strDisplay(amount, coa.getStatus());
                                                                                        vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="<%=cssString%>"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="<%=cssString%>"> 
                                                                                                            <div align="right"><%=displayStr1%> 
                                                                                                                <%displayStr1 = "";%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%						//add detail
                                                                                                            sesReport = new SesReportBs();
                                                                                                            sesReport.setType(coa.getStatus());
                                                                                                            sesReport.setDescription(strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                            sesReport.setAmount(amount);
                                                                                                            sesReport.setStrAmount(strAmount);
                                                                                                            sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);
                                                                                                            sesReport.setDepartment(vSesDep);
                                                                                                            if (!coa.getStatus().equals("HEADER")) {
                                                                                                                sesReport.setBalance(openingBalancePrev);
                                                                                                            }
                                                                                                            listReport.add(sesReport);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                if (coaSummary5 < 0) {
                                                                                                    displayStr = "(" + JSPFormater.formatNumber(coaSummary5 * -1, "#,###.##") + ")";
                                                                                                } else if (coaSummary5 > 0) {
                                                                                                    displayStr = JSPFormater.formatNumber(coaSummary5, "#,###.##");
                                                                                                } else if (coaSummary5 == 0) {
                                                                                                    displayStr = "";
                                                                                                }
            
            
                                                                                            }				//add footer level
                                                                                            if (groupOExp != 0 || valShowList != 1) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%="Total " + I_Project.ACC_GROUP_OTHER_EXPENSE%></b></span></td>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=strDisplay(totalPrevOExp, "")%></b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
                                                                            vSesDep = new Vector();
                                                                            double amount = totalOExp;
                                                                            displayStr1 = strDisplay(amount, "");
                                                                            vSesDep.add("" + amount);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=displayStr1%> 
                                                                                                                    <%displayStr1 = "";%>
                                                                                                            </b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%							//add Group Footer
            sesReport = new SesReportBs();
            sesReport.setType("Footer Group Level");
            sesReport.setDescription("Total " + I_Project.ACC_GROUP_OTHER_EXPENSE);
            sesReport.setAmount(coaSummary5);
            sesReport.setStrAmount("" + coaSummary5);
            sesReport.setFont(1);
            sesReport.setDepartment(vSesDep);
            sesReport.setBalance(totalPrevOExp);
            listReport.add(sesReport);
        }
    }

    if (groupOExp != 0 || valShowList != 1) {	//add Space
        sesReport = new SesReportBs();
        sesReport.setType("Space");
        sesReport.setDescription("");
        vSesDep = new Vector();
        vSesDep.add("0");
        sesReport.setDepartment(vSesDep);
        sesReport.setBalance(0);
        listReport.add(sesReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" height="15"></td>
                                                                                            <td class="tablecell1" colspan="2"></td>
                                                                                        </tr>
                                                                                        <%}%>                                                                                        
                                                                                        <tr> 
                                                                                            <td class="tablecell2"><span class="level2"><b><%=langFR[8]%></b></span></td>
                                                                                            <%
    double grandTotalPrev = totalPrevRev - totalPrevCOS - totalPrevExp +  totalPrevORev - totalPrevOExp;
    if (grandTotalPrev < 0) {
        displayStr = "(" + JSPFormater.formatNumber(grandTotalPrev * -1, "#,###.##") + ")";
    } else if (grandTotalPrev > 0) {
        displayStr = JSPFormater.formatNumber((grandTotalPrev), "#,###.##");
    } else if (grandTotalPrev == 0) {
        displayStr = "";
    }
    
                                                                                            %>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b><%=displayStr1%><%displayStr1 = "";%></b></div>
                                                                                                        </td>
                                                                                                        <td width="5%">&nbsp;
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
    vSesDep = new Vector();
    double grandTotal = 0; 
    grandTotal = totalRev - totalCOS - totalExp +  totalORev - totalOExp;
    displayStr1 = strDisplay(grandTotal, "");
    vSesDep.add("" + grandTotal);
                                                                                            %>
                                                                                            <td class="tablecell2" align="right"> 
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="5%"></td>
                                                                                                        <td width="90%" class="tablecell2"> 
                                                                                                            <div align="right"><b>
                                                                                                                    <%
    if (grandTotal < 0) {
        displayStr = "(" + JSPFormater.formatNumber(grandTotal * -1, "#,###.##") + ")";
    } else if (grandTotal > 0) {
        displayStr = JSPFormater.formatNumber((grandTotal), "#,###.##");
    } else if (grandTotal == 0) {
        displayStr = "";
    }
                                                                                                                    %>
                                                                                                                    <%=displayStr%>
                                                                                                                    <%displayStr1 = "";%>
                                                                                                            </b></div>
                                                                                                        </td>
                                                                                                        <td width="5%"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <%
    sesReport = new SesReportBs();
    sesReport.setType("Last Level");
    sesReport.setDescription("Net Income");
    sesReport.setAmount(grandTotal);
    sesReport.setStrAmount("" + (grandTotal));
    sesReport.setFont(1);
    sesReport.setDepartment(vSesDep);
    sesReport.setBalance(grandTotalPrev);
    listReport.add(sesReport);
                                                                                            %>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}else{%>
                                                                            <tr> 
                                                                                <td colspan="3" height="3" class="tablecell1">&nbsp;<i><%=langNav[4]%></i></td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <%session.putValue("PROFIT0YTD", listReport);%>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3">&nbsp; </td>
                                                                </tr>
                                                                <%if (iJSPCommand == JSPCommand.LIST) {%>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" colspan="3" class="container">                                                                         
                                                                        <table width="200" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td width="60"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a></td>
                                                                                <td width="0">&nbsp;</td>
                                                                                <td width="120"></td>
                                                                                <td width="20">&nbsp;</td>
                                                                            </tr>
                                                                        </table>                                                                        
                                                                    </td>
                                                                </tr>
                                                                <%}%>
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