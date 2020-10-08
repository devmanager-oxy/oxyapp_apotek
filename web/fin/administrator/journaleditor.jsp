
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_JOURNAL_EDITOR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_ADMINISTRATOR, AppMenu.M2_MENU_JOURNAL_EDITOR, AppMenu.PRIV_VIEW);
%>
<%

            int iCommand = JSPRequestValue.requestCommand(request);
            String srcRefNumber = JSPRequestValue.requestString(request, "src_ref_number");
            int postedStatus = JSPRequestValue.requestInt(request, "posted_status");
            long oidGlArchive = 0;
            CmdGlArchive cmdGlArchive = new CmdGlArchive(request);
            GlArchive glArchive = new GlArchive();
            JspGlArchive jspGlArchive = new JspGlArchive(request, glArchive);
            int iErrCode = cmdGlArchive.action(iCommand, oidGlArchive);
            jspGlArchive.requestEntityObject(glArchive);
            glArchive = jspGlArchive.getEntityObject();

            Periode openPeriod = new Periode();
            Vector result = new Vector();

            if (iCommand == JSPCommand.NONE) {
                glArchive.setIgnoreTransactionDate(1);
                glArchive.setIgnoreInputDate(1);
                postedStatus = -1;
            } else {

                String whereClause = "";

                if (glArchive.getIgnoreTransactionDate() == 0 && glArchive.getTransactionDate() != null) {//trans_date
                    whereClause = ((whereClause.length() > 0) ? " and " : "") + " trans_date = '" + JSPFormater.formatDate(glArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
                }
                if (postedStatus != -1) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + "posted_status =" + postedStatus;
                }
                if (!glArchive.getJournalNumber().equals("")) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + "journal_number like '%" + glArchive.getJournalNumber() + "%'";
                }
                if (glArchive.getPeriodeId() != 0) {

                    try {
                        openPeriod = DbPeriode.fetchExc(glArchive.getPeriodeId());
                    } catch (Exception e) {
                    }
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + "period_id=" + glArchive.getPeriodeId();
                }
                if (glArchive.getIgnoreInputDate() == 0) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(glArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(glArchive.getEndDate(), "yyyy-MM-dd") + "'";
                }
                if (srcRefNumber != null && srcRefNumber.length() > 0) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + "ref_number like '%" + srcRefNumber + "%'";
                }

                if (openPeriod.getOID() != 0) {
                    result = DbGl.list(0, 0, whereClause, DbGl.colNames[DbGl.COL_DATE] + "," + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]);
                }
            }

            /*** LANG ***/
            String[] langFR = {"Ignore", "Period", "Input Date", "Transaction Date", "Journal Number", "Ref-Number", //0-5
                "Details Journal", "PERIOD", "Period Date", //6-8
                "Account Description", "CoA Type", "Debet", "Credit", "Description", "Balance", "Journal Status"}; //9-15

            String[] langNav = {"Financial Report", "Journal Detail"};

            if (lang == LANG_ID) {
                String[] langID = {"Abaikan", "Periode", "Tanggal Dibuat", "Tanggal Transaksi", "Nomor Jurnal", "Nomor Referensi",
                    "Jurnal Detail", "PERIODE", "Tanggal Periode",
                    "Perkiraan", "Tipe Perkiraan", "Debet", "Credit", "Keterangan", "Saldo", "Status Jurnal"
                };
                langFR = langID;

                String[] navID = {"Laporan Keuangan", "Jurnal Detail"};
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
        <!--
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        function cmdSearch(){
            document.form1.command.value="<%=JSPCommand.FIRST%>";
            document.form1.action="journaleditor.jsp";
            document.form1.submit();
        }
        
        function MM_swapImgRestore() { //v3.0
            var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
        }
        //-->
    </script>
    <!-- #EndEditable --> 
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                  <%@ include file="menu.jsp"%>
            <!-- #EndEditable --> </td>
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
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                    <tr> 
                                        <td colspan="2">&nbsp;</td>
                                    </tr>
                                    <tr height="22"> 
                                        <td width="14%" class="tablearialcell1">&nbsp;<%=langFR[1]%></td>
                                        <td width="86%">: 
                                            <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", "start_date desc");
            Vector p_value = new Vector(1, 1);
            Vector p_key = new Vector(1, 1);
            String sel_p = "" + glArchive.getPeriodeId();
            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                    p_value.add(period.getName().trim());
                    p_key.add("" + period.getOID());
                }
            }
                                            %>
                                        <%= JSPCombo.draw(jspGlArchive.colNames[JspGlArchive.JSP_PERIODE_ID], null, sel_p, p_key, p_value, "", "formElemen") %> </td>
                                    </tr>
                                    <tr> 
                                        <td class="tablearialcell1">&nbsp;<%=langFR[2]%></td>
                                        <td class="fontarial">: <%=JSPDate.drawDateWithStyle(jspGlArchive.colNames[jspGlArchive.JSP_START_DATE], (glArchive.getStartDate() == null) ? new Date() : glArchive.getStartDate(), 0, -10, "formElemen", "") %> &nbsp;&nbsp;to&nbsp;&nbsp; 
                                        <%=JSPDate.drawDateWithStyle(jspGlArchive.colNames[jspGlArchive.JSP_END_DATE], (glArchive.getEndDate() == null) ? new Date() : glArchive.getEndDate(), 0, -10, "formElemen", "") %> 
                                        <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreInputDate() == 1) {%>checked<%}%>>
                                               <%=langFR[0]%></td>
                                    </tr>
                                    <tr> 
                                        <td class="tablearialcell1">&nbsp;<%=langFR[3]%></td>
                                        <td class="fontarial">:                                                                  
                                        <%=JSPDate.drawDateWithStyle(jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE], (glArchive.getTransactionDate() == null) ? new Date() : glArchive.getTransactionDate(), 0, -10, "formElemen", "") %> 
                                        <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreTransactionDate() == 1) {%>checked<%}%>>
                                               <%=langFR[0]%> </td>
                                    </tr>
                                    <tr> 
                                        <td class="tablearialcell1">&nbsp;<%=langFR[4]%></td>
                                        <td class="fontarial">: 
                                            <input type="text" name="<%=jspGlArchive.colNames[jspGlArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= glArchive.getJournalNumber() %>">
                                        </td>
                                    </tr>
                                    <tr> 
                                        <td class="tablearialcell1">&nbsp;<%=langFR[5]%></td>
                                        <td class="fontarial">:  
                                            <input type="text" name="src_ref_number"  value="<%=srcRefNumber %>" >
                                        </td>
                                    </tr>
                                    <tr> 
                                        <td class="tablearialcell1">&nbsp;<%=langFR[15]%></td>
                                        <td class="fontarial">: 
                                            <select name="posted_status" class="fontarial">
                                                <option value="-1" <%if (postedStatus == -1) {%>selected<%}%>>-</option>
                                                <option value="0" <%if (postedStatus == 0) {%>selected<%}%>>UN-POSTED</option>
                                                <option value="1" <%if (postedStatus == 1) {%>selected<%}%>>POSTED</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr> 
                                        <td width="14%"> 
                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                <tr> 
                                                    <td width="19%"><a href="javascript:cmdSearch()"><img src="../images/search2.jpg" width="22" height="22" border="0"></a></td>
                                                    <td width="81%" class="fontarial"><a href="javascript:cmdSearch()">Get Report</a></td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td width="86%">&nbsp;</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>                                                
                        <tr> 
                            <td class="container">&nbsp;</td>
                        </tr>
                        
                        <%
            if (iCommand != JSPCommand.NONE) {

                if (glArchive.getIgnoreInputDate() == 0) {%>
                        <tr> 
                            <td class="container"> 
                                <div align="center"><b><%=langFR[2]%> : <%=JSPFormater.formatDate(glArchive.getStartDate(), "dd/MM/yyyy")%> - <%=JSPFormater.formatDate(glArchive.getEndDate(), "dd/MM/yyyy")%></b></div>
                            </td>
                        </tr>
                        <%}%>
                        <%if (glArchive.getIgnoreTransactionDate() == 0) {%>
                        <tr> 
                            <td class="container"> 
                                <div align="center"><b><font face="arial" size="1"><%=langFR[3]%> : <%=JSPFormater.formatDate(glArchive.getTransactionDate(), "dd/MM/yyyy")%></font></b></div>
                            </td>
                        </tr>
                        <%}
            }%>
                        <tr> 
                            <td class="container"> 
                                <div align="center">&nbsp;</div>
                            </td>
                        </tr>
                        <tr> 
                        <td class="container"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <%
            double grandTotalDebet = 0;
            double grandTotalCredit = 0;

            if (result != null && result.size() > 0) {
                for (int i = 0; i < result.size(); i++) {
                    Gl gl = (Gl) result.get(i);
                            %>
                            <tr> 
                                <td width="13%" class="tablehdr" height="17" nowrap><font face="arial" size="1"><%=langFR[2]%> 
                                : <%=JSPFormater.formatDate(gl.getDate(), "dd MMMM yyyy")%></font></td>
                                <td width="17%" class="tablehdr" height="17" nowrap><font face="arial" size="1"><%=langFR[3]%> : <%=JSPFormater.formatDate(gl.getTransDate(), "dd MMMM yyyy")%></font></td>
                                <td width="23%" class="tablehdr" height="17" nowrap><font face="arial" size="1"><%=langFR[4]%> : <%=gl.getJournalNumber()%>, <%=langFR[5]%> : <%=(gl.getRefNumber() == null || gl.getRefNumber().length() == 0) ? "-" : gl.getRefNumber()%></font></td>
                                <td width="2%" height="17">&nbsp;</td>
                                <td width="45%" height="17"><u><i><font face="arial" size="1"><%=gl.getMemo()%></font></i></u></td>
                            </tr>
                            <tr> 
                                <td colspan="5" height="1"></td>
                            </tr>
                            <tr> 
                                <td colspan="5"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0" align="right">
                                    <tr> 
                                        <td class="tablecell" height="18"> 
                                            <div align="center"><font size="1"><b><%=langFR[9]%></b></font></div>
                                        </td>
                                        <td class="tablecell" height="18" width="18%"> 
                                            <div align="center"><font size="1"><b><%=langFR[11]%></b></font></div>
                                        </td>
                                        <td class="tablecell" height="18" width="13%"> 
                                            <div align="center"><font size="1"><b><%=langFR[12]%></b></font></div>
                                        </td>
                                        <td class="tablecell" height="18" width="25%"> 
                                            <div align="center"><font size="1"><b><%=langFR[13]%></b></font></div>
                                        </td>
                                        <td class="tablecell" height="18" width="15%"> 
                                            <div align="center"><font size="1"><b>Segment</b></font></div>
                                        </td>
                                    </tr>                                                                        
                                    <%
                                    Vector details = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), "debet desc");
                                    double subTotDebet = 0;
                                    double subTotCredit = 0;
                                    if (details != null && details.size() > 0) {

                                        //check diff =================================
                                        boolean diff = false;
                                        int prevCl = 0;
                                        for (int x = 0; x < details.size(); x++) {
                                            GlDetail gld = (GlDetail) details.get(x);
                                            Coa coa = new Coa();
                                            try {
                                                coa = DbCoa.fetchExc(gld.getCoaId());
                                            } catch (Exception e) {
                                            }

                                            if (x == 0) {
                                                if (coa.getAccountClass() == DbCoa.ACCOUNT_CLASS_SP) {
                                                    prevCl = DbCoa.ACCOUNT_CLASS_SP;
                                                } else {
                                                    prevCl = 0;
                                                }
                                            } else {
                                                if (!diff) {
                                                    //coa = SP
                                                    if (coa.getAccountClass() == DbCoa.ACCOUNT_CLASS_SP) {
                                                        if (prevCl != DbCoa.ACCOUNT_CLASS_SP) {
                                                            diff = true;
                                                            break;
                                                        }
                                                    } //coa = NSP
                                                    else {
                                                        if (prevCl == DbCoa.ACCOUNT_CLASS_SP) {
                                                            diff = true;
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        //===============================================

                                        for (int x = 0; x < details.size(); x++) {
                                            GlDetail gld = (GlDetail) details.get(x);
                                            Coa coa = new Coa();
                                            try {
                                                coa = DbCoa.fetchExc(gld.getCoaId());
                                            } catch (Exception e) {
                                            }

                                            subTotDebet = subTotDebet + gld.getDebet();
                                            subTotCredit = subTotCredit + gld.getCredit();
                                            
                                            SegmentDetail sd = new SegmentDetail();
                                            try{
                                                if(gld.getSegment1Id() != 0){
                                                    sd = DbSegmentDetail.fetchExc(gld.getSegment1Id());
                                                }
                                            }catch(Exception e){}
                                    %>
                                    <tr> 
                                    <td <%if (!diff) {%>class="tablecell1"<%} else {%>bgcolor="#FF0000"<%}%> ><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td>
                                        
                                        <td <%if (!diff) {%>class="tablecell1"<%} else {%>bgcolor="#FF0000"<%}%> > 
                                            <div align="right"><font size="1"><%=(gld.getDebet() == 0) ? "" : JSPFormater.formatNumber(gld.getDebet(), "###,###.##")%>&nbsp;&nbsp;</font></div>
                                        </td>
                                        <td <%if (!diff) {%>class="tablecell1"<%} else {%>bgcolor="#FF0000"<%}%> > 
                                            <div align="right"><font size="1"><%=(gld.getCredit() == 0) ? "" : JSPFormater.formatNumber(gld.getCredit(), "###,###.##")%>&nbsp;&nbsp;</font></div>
                                        </td>
                                        <td class="tablecell1" ><font size="1"><%=gld.getMemo()%></font></td>
                                        <td class="tablecell1" ><font size="1"><%=sd.getName()%></font></td>
                                    </tr>                                                                      
                                    <%}
                                    }

                                    grandTotalDebet = grandTotalDebet + subTotDebet;
                                    grandTotalCredit = grandTotalCredit + subTotCredit;

                                    %>
                                    <tr> 
                                        <td class="tablecell" height="18"> 
                                            <div align="center"><font size="1"><b>Sub Total</b></font></div>
                                        </td>                                                                            
                                        <td <%if (JSPFormater.formatNumber(subTotDebet, "###,###.##").compareTo(JSPFormater.formatNumber(subTotCredit, "###,###.##")) == 0) {%>class="tablecell"<%} else {%>bgcolor="#FF0000"<%}%> height="18"> 
                                            <div align="right"><font size="1"><b><u><%=(subTotDebet == 0) ? "" : JSPFormater.formatNumber(subTotDebet, "###,###.##")%></u>&nbsp;&nbsp;</b></font></div>
                                        </td>
                                        <td <%if (JSPFormater.formatNumber(subTotDebet, "###,###.##").compareTo(JSPFormater.formatNumber(subTotCredit, "###,###.##")) == 0) {%>class="tablecell"<%} else {%>bgcolor="#FF0000"<%}%> height="18"> 
                                            <div align="right"><font size="1"><b><u><%=(subTotCredit == 0) ? "" : JSPFormater.formatNumber(subTotCredit, "###,###.##")%></u>&nbsp;&nbsp;</b></font></div>
                                        </td>
                                        <td class="tablecell"  height="18"><font size="1"></font></td>
                                        <td class="tablecell"  height="18"><font size="1"></font></td>
                                    </tr>
                                    <tr> 
                                        <td class="tablecell1" colspan="5">&nbsp;</td>                                                                            
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        
                        
                        <%}%>
                        <tr> 
                            <td colspan="5"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="0" align="right">
                                    <tr> 
                                        <td class="tablecell" width="33%" height="18"> 
                                            <div align="center"><b><span class="level2">Grand Total</span> </b></div>
                                        </td>
                                        <td class="tablecell" width="14%" height="18"> 
                                            <div align="right"><font color="#FF6600"><b><u><%=(grandTotalDebet == 0) ? "" : JSPFormater.formatNumber(grandTotalDebet, formNumbComp)%></u>&nbsp;&nbsp;</b></font></div>
                                        </td>
                                        <td class="tablecell" width="15%" height="18"> 
                                            <div align="right"><font color="#FF6600"><b><u><%=(grandTotalCredit == 0) ? "" : JSPFormater.formatNumber(grandTotalCredit, formNumbComp)%></u>&nbsp;&nbsp;</b></font></div>
                                        </td>
                                        <td class="tablecell" width="38%" height="18">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td class="tablecell1" width="33%"> 
                                            <div align="center"><b><span class="level2"><%=langFR[14]%></span></b></div>
                                        </td>
                                        <td class="tablecell1" width="14%">&nbsp;</td>
                                        <td class="tablecell1" width="15%"> 
                                            <div align="right"><b><%=(JSPFormater.formatNumber(grandTotalDebet, formNumbComp).compareTo(JSPFormater.formatNumber(grandTotalCredit, formNumbComp)) == 0) ? "-" : "<font color=\"red\">" + JSPFormater.formatNumber(grandTotalDebet - grandTotalCredit, formNumbComp) + "</font>"%>&nbsp;&nbsp;</b></div>
                                        </td>
                                        <td class="tablecell1" width="38%">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                        <td class="tablecell1" width="33%">&nbsp;</td>
                                        <td class="tablecell1" width="14%">&nbsp;</td>
                                        <td class="tablecell1" width="15%">&nbsp;</td>
                                        <td class="tablecell1" width="38%">&nbsp;</td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr > 
                            <td colspan="5" background="../images/line.gif"><img src="../images/line.gif" width="39" height="7"></td>
                        </tr>                        
                        <%} else {%>
                        <%if (iCommand == JSPCommand.NONE) {%>
                        <tr > 
                            <td colspan="5" class="fontarial"><i>Click seach button to searching the data...</i></td>
                        </tr>
                        <%} else {%>
                        <tr > 
                            <td colspan="5" class="fontarial"><i>Data not found...</i></td>
                        </tr>
                        <%}%>
                        <%}%>
                    </table>
                </td>
            </tr>
            <tr> 
                <td>&nbsp;</td>
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
<!-- #EndTemplate --></html>
