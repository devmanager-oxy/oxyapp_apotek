
<%-- 
    Document   : neracabysegment
    Created on : Feb 23, 2013, 8:36:40 PM
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
%>
<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidRptFormat = JSPRequestValue.requestLong(request, "rpt_format_id");
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            long segment1ID = JSPRequestValue.requestLong(request, "segment1ID");
            int previewType = JSPRequestValue.requestInt(request, "preview_type");

            if (session.getValue("NERACA_REPORT_AKTIVA") != null) {
                session.removeValue("NERACA_REPORT_AKTIVA");
            }

            if (session.getValue("NERACA_REPORT_PASIVA") != null) {
                session.removeValue("NERACA_REPORT_PASIVA");
            }

            if (iJSPCommand == JSPCommand.NONE) {
                previewType = 1;
            }

            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");

            Periode period = new Periode();
            if (periodId != 0) {
                try {
                    period = DbPeriode.fetchExc(periodId);
                } catch (Exception e) {
                }
            } else {
                period = (Periode) periods.get(0);
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
                lastPeriod = DbPeriode.getLastYearPeriod13(period);
            }

            Coa coaLabaBerjalan = DbCoa.getCoaByCode(DbSystemProperty.getValueByName("CODE_LABA_TAHUN_BERJALAN"));

            /*** LANG ***/
            String[] langFR = {"Show List", "Account With Transaction", "All", "BALANCE SHEET", "PERIOD", //0-4
                "Description", "Total", "And"}; //5-7
            String[] langNav = {"Financial Report", "Detail", "Balance Sheet", "Period", "Preview", "Location"};
            String title = "";
            String[] langMonth = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};

            try {
                title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA_EN");
            } catch (Exception e) {
            }

            if (lang == LANG_ID) {
                String[] langID = {"Tampilkan Daftar", "Perkiraan Dengan Transaksi", "Semua", "NERACA", "PERIODE", //0-4
                    "Keterangan", "Total", "Dan"}; //5-7
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Penjelasan", "Neraca", "Periode", "Preview", "Lokasi"};
                langNav = navID;

                String[] langMonthID = {"Januari", "Februari", "Maret", "April", "Mei", "June", "Juli", "Agustus", "September", "Oktober", "November", "Desember"};
                langMonth = langMonthID;

                try {
                    title = DbSystemProperty.getValueByName("TITLE_PENJELASAN_NERACA");
                } catch (Exception e) {
                }

            }

            Vector reportAktivaXLS = new Vector();
            Vector reportPasivaXLS = new Vector();
            String monthPrev = dtx.getDate() + " " + langMonth[dtx.getMonth()].toUpperCase() + " " + (dtx.getYear() + 1900);
            String month = reportDate.getDate() + " " + langMonth[reportDate.getMonth()].toUpperCase() + " " + (reportDate.getYear() + 1900);
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
            // Identify a caption for all images. This can also be set inline for each image.
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>         
        <script type="text/javascript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%> 
            
            function cmdReload(){                
                document.form1.command.value="<%=JSPCommand.VIEW%>";
                document.form1.action="neracabysegment.jsp?menu_idx=<%=menuIdx%>";
                document.form1.submit();
            }
            
            function cmdPrintJournalXLS(){	 
                window.open("<%=printroot%>.report.RptNeracaXLS?oid=<%=appSessUser.getLoginId()%>&period_id=<%=periodId%>&segment1_id=<%=segment1ID%>&lang=<%=lang%>");
                }
                
                function cmdGO(){                
                    document.form1.command.value="<%=JSPCommand.LIST%>";
                    document.form1.action="neracabysegment.jsp?menu_idx=<%=menuIdx%>";
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
                                                            <input type="hidden" name="rpt_format_id" value="<%=oidRptFormat%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr> 
                                                                                <td colspan="4" align="left" height="10"></td>
                                                                            </tr>    
                                                                            <tr> 
                                                                                <td colspan="4" align="left">
                                                                                    <table border="0" cellpadding="1" cellspacing="1">                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" > 
                                                                                                <table border="0" style="border:1px solid #ABA8A8" cellspacing="0" cellpadding="2">
                                                                                                    <tr height="15">
                                                                                                        <td width="10" height="7"></td>
                                                                                                        <td width="70" height="7"></td>
                                                                                                        <td width="1"></td>
                                                                                                        <td width="10" height="7"></td>
                                                                                                    </tr>    
                                                                                                    <tr>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langNav[3]%></td>
                                                                                                        <td width="1">:</td>
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
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>  
                                                                                                    <%
            boolean isParent = DbSegmentDetail.isParent();
            if (isParent) {
                Vector listSegment = DbSegment.list(0, 0, DbSegment.colNames[DbSegment.COL_COUNT] + " = 1", null);
                if (listSegment != null && listSegment.size() > 0) {
                    Segment s = (Segment) listSegment.get(0);
                    Vector listSegmentDetail = DbSegmentDetail.list(0, 0, DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + s.getOID(), DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
                    if (listSegmentDetail != null && listSegmentDetail.size() > 0) {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=s.getName() %></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <select name="segment1ID" class="fontarial">
                                                                                                                <%
                                                                                                                for (int t = 0; t < listSegmentDetail.size(); t++) {
                                                                                                                    SegmentDetail sd = (SegmentDetail) listSegmentDetail.get(t);
                                                                                                                %>
                                                                                                                <option value="<%=sd.getOID()%>" <%if (segment1ID == sd.getOID()) {%>selected<%}%> > <%=sd.getName()%></option>
                                                                                                                <%}%>option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%
                    }
                }
            }%>
                                                                                                    <tr>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langNav[4]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <select name="preview_type" onchange="javascript:cmdReload()">
                                                                                                                <option value="0" <%if (previewType == 0) {%>selected<%}%>>All Account</option>
                                                                                                                <option value="1" <%if (previewType == 1) {%>selected<%}%>>Account &gt; 0 Only</option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td colspan ="2"></td>
                                                                                                        <td colspan ="2">&nbsp;&nbsp;&nbsp;<input type="button" name="Button" value="GO" onClick="javascript:cmdGO()"></td>
                                                                                                    </tr> 
                                                                                                    <tr>
                                                                                                        <td width="10" height="7"></td>
                                                                                                        <td colspan="2" height="7"></td>
                                                                                                        <td width="10" height="7"></td>
                                                                                                    </tr>  
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%if (iJSPCommand == JSPCommand.LIST) {%>
                                                                            <tr> 
                                                                                <td height="23" colspan="4">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="23" colspan="4"> 
                                                                                    <div align="center"><b><font face="arial" size="2"><%=title%></font></b></div>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <%
    if (segment1ID != 0) {
        SegmentDetail sd = new SegmentDetail();
        try {
            sd = DbSegmentDetail.fetchExc(segment1ID);
        } catch (Exception e) {
        }
        if (sd.getOID() != 0) {
                                                                            %>
                                                                            <tr> 
                                                                                <td height="23" colspan="4"> 
                                                                                    <div align="center"><b><font face="arial" size="2"><%=sd.getName().toUpperCase()%></font></b></div>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <%}
    }%>
                                                                            <tr> 
                                                                                <td height="23" colspan="4"> <font face="arial" > 
                                                                                    <div align="center"><b>( <i><%=monthPrev%> <%=langFR[7]%> <%=month%></i> )</b></div></font>
                                                                                </td>                                                                                
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <%

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="2%"  class="tablehdr">NO</td>
                                                                                            <td width="33%" class="tablehdr">URAIAN</td>
                                                                                            <td width="15%" class="tablehdr">REALISASI<br>PER<br><%=monthPrev%></td>
                                                                                            <td width="17%" class="tablehdr">REALISASI<br>PER<br><%=month%></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="3"><div align="center"><b>1</b></div></td>
                                                                                            <td height="3"><div align="center"><b>2</b></div></td>
                                                                                            <td height="3"><div align="center"><b>3</b></div></td>
                                                                                            <td height="3"><div align="center"><b>4</b></div></td>
                                                                                        </tr>                                                                                        
                                                                                        <tr> 
                                                                                            <td height="22"></td>
                                                                                            <td height="22"><b><font color="#CC3300" size="2">AKTIVA</font></b></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                        </tr>
                                                                                        <%
    double totalAmountLY = 0;
    double totalAmountTY = 0;
    int seq = 0;

    for (int x = 0; x < I_Project.accGroup.length; x++) {

        Vector tempCoas = new Vector();
        if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LIQUID_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_FIXED_ASSET) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_OTHER_ASSET)) {
            tempCoas = DbCoa.listCoaNeraca(DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
        }

        if (tempCoas != null && tempCoas.size() > 0) {
            for (int i = 0; i < tempCoas.size(); i++) {

                CoaReport coa = (CoaReport) tempCoas.get(i);
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
                    amountLY = amountLY + DbCoaOpeningBalanceLocation.getOpeningBalance(lastPeriod, coa.getCoaId(), segment1ID);
                    amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getCoaId(), coa.getLevel(), coa.getAccountGroup(), segment1ID); 
                }

                amountTY = amountTY + DbCoaOpeningBalanceLocation.getOpeningBalance(period, coa.getCoaId(), segment1ID);
                amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getCoaId(), coa.getLevel(), coa.getAccountGroup(), segment1ID);

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
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"><%=seq%></td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(amountLY, isBold)%></div></td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(amountTY, isBold)%></div></td>
                                                                                        </tr>
                                                                                        <%
                    SessNeraca sNeraca = new SessNeraca();
                    sNeraca.setLevel(coa.getLevel());
                    sNeraca.setCoa(coa.getName());
                    sNeraca.setCode(coa.getCode());
                    sNeraca.setStatus(coa.getStatus());
                    sNeraca.setBalancePrevious(amountLY);
                    sNeraca.setBalance(amountTY);
                    reportAktivaXLS.add(sNeraca);

                }
            }
        }
    }%>                                                                     
                                                                                        <tr> 
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                        </tr>                                                                                        
                                                                                        <tr> 
                                                                                            <td height="22"></td>
                                                                                            <td height="22"><b><font color="#CC3300" size="2">TOTAL AKTIVA</font></b></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountLY, false)%></b></font></div></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountTY, false)%></b></font></div></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="22"></td>
                                                                                            <td height="22"></td>
                                                                                            <td height="22"></td>
                                                                                            <td height="22"></td>
                                                                                        </tr>                                                                                       
                                                                                        <tr> 
                                                                                            <td height="22"></td>
                                                                                            <td height="22"><b><font color="#CC3300" size="2">PASIVA</font></b></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"></font></div></td>
                                                                                        </tr>
                                                                                        <%
    totalAmountLY = 0;
    totalAmountTY = 0;
    seq = 0;

    for (int x = 0; x < I_Project.accGroup.length; x++) {

        Vector tempCoas = new Vector();
        if (I_Project.accGroup[x].equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES) || I_Project.accGroup[x].equals(I_Project.ACC_GROUP_EQUITY)) {
            tempCoas = DbCoa.listCoaNeraca(DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.accGroup[x] + "'", DbCoa.colNames[DbCoa.COL_CODE]);
        }

        if (tempCoas != null && tempCoas.size() > 0) {

            String indukLaba1 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_1");
            String indukLaba2 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_2");
            String indukLaba3 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_3");
            String indukLaba4 = DbSystemProperty.getValueByName("CODE_LABA_INDUK_4");

            for (int i = 0; i < tempCoas.size(); i++) {
                CoaReport coa = (CoaReport) tempCoas.get(i);

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

                //jika laba tahun berjalan, hitungnya beda
                if (coaLabaBerjalan.getCode().equals(coa.getCode())) {
                    if (lastPeriod.getOID() != 0) {
                        amountTY = amountTY + DbCoaOpeningBalanceLocation.getOpeningBalance(lastPeriod, coa.getCoaId(), segment1ID);
                        amountLY = amountLY + DbGlDetail.getTotalIncomeInPeriod(lastPeriod.getOID(), segment1ID) - DbGlDetail.getTotalExpenseInPeriod(lastPeriod.getOID(), segment1ID);
                    }
                    amountTY = amountTY + DbCoaOpeningBalanceLocation.getOpeningBalance(period, coa.getCoaId(), 0);
                    amountTY = amountTY + DbGlDetail.getTotalIncomeInPeriod(period.getOID(), segment1ID) - DbGlDetail.getTotalExpenseInPeriod(period.getOID(), segment1ID);
                } else {
                    if (lastPeriod.getOID() != 0) {
                        amountLY = amountLY + DbCoaOpeningBalanceLocation.getOpeningBalance(lastPeriod, coa.getCoaId(), segment1ID);
                        amountLY = amountLY + DbGlDetail.getAmountInPeriod(lastPeriod.getOID(), coa.getCoaId(), coa.getLevel(), coa.getAccountGroup(), segment1ID);
                    }
                    amountTY = amountTY + DbCoaOpeningBalanceLocation.getOpeningBalance(period, coa.getCoaId(), segment1ID);
                    amountTY = amountTY + DbGlDetail.getAmountInPeriod(period.getOID(), coa.getCoaId(), coa.getLevel(), coa.getAccountGroup(), segment1ID);
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
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>" align="center"><%=seq%> </td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><%=level + ((isBold) ? "<b>" + coa.getName() + "</b>" : coa.getName())%></td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(amountLY, isBold)%></div></td>
                                                                                            <td class="<%=((isBold) ? "tablecell1" : "tablecell")%>"><div align="right"><%=getFormated(amountTY, isBold)%></div></td>
                                                                                        </tr>
                                                                                        <%
                    SessNeraca sNeraca = new SessNeraca();
                    sNeraca.setLevel(coa.getLevel());
                    sNeraca.setCoa(coa.getName());
                    sNeraca.setCode(coa.getCode());
                    sNeraca.setStatus(coa.getStatus());
                    sNeraca.setBalancePrevious(amountLY);
                    sNeraca.setBalance(amountTY);
                    reportPasivaXLS.add(sNeraca);
                }
            }
        }
    }%>
                                                                                        <tr> 
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                            <td height="1" bgcolor="#609836"></td>
                                                                                        </tr>                                                                                        
                                                                                        <tr> 
                                                                                            <td height="22"></td>
                                                                                            <td height="22"><b><font color="#CC3300" size="2">TOTAL PASIVA</font></b></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountLY, false)%></b></font></div></td>
                                                                                            <td height="22"><div align="right"><font color="#CC3300" size="2"><b><%=getFormated(totalAmountTY, false)%></b></font></div></td>
                                                                                        </tr>   
                                                                                        <%
    session.putValue("NERACA_REPORT_AKTIVA", reportAktivaXLS);
    session.putValue("NERACA_REPORT_PASIVA", reportPasivaXLS);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td colspan="4" height="15">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4">
                                                                                                <a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr> 
                                                                                <td colspan="4" height="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="3" class="tablecell1">&nbsp;<i>Klik GO Button to searching the data...</i></td>
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