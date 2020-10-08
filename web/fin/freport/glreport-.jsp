
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REP_GL, AppMenu.PRIV_DELETE);
%>
<%
//jsp content
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            Date startDate = new Date();
            Date endDate = new Date();
            if (iJSPCommand == JSPCommand.NONE) {
                Periode p = DbPeriode.getOpenPeriod();
                startDate = p.getStartDate();
                endDate = new Date();
            }
            boolean isGereja = DbSystemProperty.getModSysPropGereja();
            Vector vSeg = DbSegment.list(0, 0, "", DbSegment.colNames[DbSegment.COL_COUNT]);

            Vector coas = DbCoa.list(0, 0, "", DbCoa.colNames[DbCoa.COL_CODE]);

            /*** LANG ***/
            String[] langFR = {"Please select General Ledger Parameters", "Start Date", "End Date", "Account Included", //0-3
                "Include", "Code", "Account"}; //4-6
            String[] langNav = {"Financial Report", "General Ledger"};

            if (lang == LANG_ID) {
                String[] langID = {"Pilih salah satu parameter Buku Besar", "Tanggal Mulai", "Tanggal Berakhir", "Perkiraan yang termasuk", //0-3
                    "Termasuk", "Kode", "Perkiraan"}; //4-6
                langFR = langID;
                String[] navID = {"Laporan Keuangan", "Buku Besar"};
                langNav = navID;
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
            
             function setChecked1(val){
                 <%
                 for (int k = 0; k < coas.size(); k++) {
                     Coa c = (Coa) coas.get(k);
                     if (!c.getStatus().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                 %>
                     document.glreport.box_<%=c.getOID()%>.checked=val;
                 <%
                     }
                 }%>
             }
            
            function cmdSearch(){
                document.glreport.action="gl.jsp";
                document.glreport.submit();
            }
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                                   <%@ include file="../calendar/calendarframe.jsp"%>
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
                                                        <form id="form1" name="glreport" method="post" action="">
                                                            <input type="hidden" name="command">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td colspan="5">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="5"><%=langFR[0]%> : </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="5%">&nbsp;</td>
                                                                                <td width="69%">&nbsp;</td>
                                                                                <td width="5%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%"><%=langFR[1]%></td>
                                                                                <td width="13%" nowrap> 
                                                                                    <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.glreport.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                </td>
                                                                                <td width="8%"><%=langFR[2]%></td>
                                                                                <td width="66%" nowrap> 
                                                                                    <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.glreport.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                </td>
                                                                                <td width="5%">&nbsp;</td>
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
                                                                                <td width="8%">&nbsp;</td><td width="13%">&nbsp;</td><td width="5%">&nbsp;</td><td width="69%">&nbsp;</td><td width="5%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="3" nowrap><%=langFR[3]%> : <a href="javascript:setChecked1(1)">Check All</a> | <a href="javascript:setChecked1(0)">Release 
                                                                                All</a></td>
                                                                                <td width="69%"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="3%"><a href="javascript:cmdSearch()"><img src="../images/success.gif" border="0"></a></td>                                                                                            
                                                                                            <td width="97%"><a href="javascript:cmdSearch()">Generate Report</a></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="5%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4">&nbsp;</td><td width="5%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4"> 
                                                                                    <table width="59%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="8%" class="tablehdr"><%=langFR[4]%></td><td width="79%" class="tablehdr"><%=langFR[6]%></td>
                                                                                        </tr>
                                                                                        <%if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coa = (Coa) coas.get(i);

                    String level = "";
                    if (coa.getLevel() == 1) {
                        level = "";//"<img src=\"../images/spacer.gif\" width=\"20\" height=\"1\">";
                    } else if (coa.getLevel() == 2) {
                        //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        level = "<img src=\"../images/spacer.gif\" width=\"25\" height=\"1\">";
                    } else if (coa.getLevel() == 3) {
                        //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        level = "<img src=\"../images/spacer.gif\" width=\"50\" height=\"1\">";
                    } else if (coa.getLevel() == 4) {
                        //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        level = "<img src=\"../images/spacer.gif\" width=\"75\" height=\"1\">";
                    } else if (coa.getLevel() == 5) {
                        //level = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        level = "<img src=\"../images/spacer.gif\" width=\"100\" height=\"1\">";
                    }

                    boolean isBold = false;
                    if (coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {
                        isBold = true;
                    }

                    String cls = "tablecell";
                    if (i % 2 > 0) {
                        cls = "tablecell1";
                    }

                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="8%" class="<%=cls%>"> 
                                                                                                <div align="center"> 
                                                                                                    <%if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_HEADER)) {%>
                                                                                                    <input type="checkbox" name="box_<%=coa.getOID()%>" value="1" checked>
                                                                                                    <%}%>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td width="79%" class="<%=cls%>">
                                                                                                <%if (isBold) {%>
                                                                                                <b>
                                                                                                    <%}%>
                                                                                                    <%=level + coa.getCode() + " - " + coa.getName()%>
                                                                                                    <%if (isBold) {%>
                                                                                                </b>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}
            }%>
                                                                                        <tr> 
                                                                                            <td width="8%">&nbsp;</td>
                                                                                            <td width="79%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="5%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="5%">&nbsp;</td>
                                                                                <td width="69%">&nbsp;</td>
                                                                                <td width="5%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="8%">&nbsp;</td>
                                                                                <td width="13%">&nbsp;</td>
                                                                                <td width="5%">&nbsp;</td>
                                                                                <td width="69%">&nbsp;</td>
                                                                                <td width="5%">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td>&nbsp;</td>
                                                                </tr>
                                                                <tr> 
                                                                    <td>&nbsp;</td>
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
