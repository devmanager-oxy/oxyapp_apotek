
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

            int iCommand = JSPRequestValue.requestCommand(request);
            String srcRefNumber = JSPRequestValue.requestString(request, "src_ref_number");
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
            } else {


                String whereClause = "";

                if (glArchive.getIgnoreTransactionDate() == 0 && glArchive.getTransactionDate() != null) {
                    whereClause = ((whereClause.length() > 0) ? " and " : "") + " trans_date = '" + JSPFormater.formatDate(glArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
                }
                if (!glArchive.getJournalNumber().equals("")) {
                    if (whereClause != "") {
                        whereClause = whereClause + " and ";
                    }
                    whereClause = whereClause + "journal_number like '%" + glArchive.getJournalNumber() + "%'";
                }
                if (glArchive.getPeriodeId() != 0) {
                    /*Periode periode = new Periode();
                    try{
                    periode = DbPeriode.fetchExc(glArchive.getPeriodeId());
                    }catch(Exception e){}
                    if (whereClause != "") whereClause = whereClause + " and ";
                    whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() +"'";
                     */
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
                    //result = DbGl.list(0,0, DbGl.colNames[DbGl.COL_PERIOD_ID]+"="+openPeriod.getOID(), DbGl.colNames[DbGl.COL_DATE]+","+DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]);
                    result = DbGl.list(0, 0, whereClause, DbGl.colNames[DbGl.COL_DATE] + "," + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER]);
                }
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=systemTitle%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        
        function cmdSearch(){
            document.form1.command.value="<%=JSPCommand.FIRST%>";
            document.form1.action="worksheet-errors.jsp";
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
                  <%@ include file="../main/menu.jsp"%>
                        <!-- #EndEditable --> </td>
                        <td width="100%" valign="top"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                    <td class="title"><!-- #BeginEditable "title" --> 
                        <%
            String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Journal Problem SP & NSP</span></font>";
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
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="container"> 
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                            <tr> 
                                                                <td width="14%"><b>Search Parameter</b></td>
                                                                <td width="86%">&nbsp;</td>
                                                            </tr>
                                                            <tr> 
                                                                <td width="14%">Periode</td>
                                                                <td width="86%"> 
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
                //System.out.println(tc.getCountryName().trim().equalsIgnoreCase(currencyy.getCountryName().trim()));
                }
            }
                                                                    %>
                                                                <%= JSPCombo.draw(jspGlArchive.colNames[JspGlArchive.JSP_PERIODE_ID], null, sel_p, p_key, p_value, "", "formElemen") %> </td>
                                                            </tr>
                                                            <tr> 
                                                                <td width="14%">Input Date</td>
                                                                <td width="86%"><%=JSPDate.drawDateWithStyle(jspGlArchive.colNames[jspGlArchive.JSP_START_DATE], (glArchive.getStartDate() == null) ? new Date() : glArchive.getStartDate(), 0, -10, "formElemen", "") %> &nbsp;&nbsp;&nbsp;&nbsp;to&nbsp;&nbsp;&nbsp;&nbsp; 
                                                                <%=JSPDate.drawDateWithStyle(jspGlArchive.colNames[jspGlArchive.JSP_END_DATE], (glArchive.getEndDate() == null) ? new Date() : glArchive.getEndDate(), 0, -10, "formElemen", "") %> 
                                                                <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreInputDate() == 1) {%>checked<%}%>>
                                                                       Ignore </td>
                                                            </tr>
                                                            <tr> 
                                                                <td width="14%">Transaction Date</td>
                                                                <td width="86%"> 
                                                                <%//=glArchive.getTransactionDate()%>
                                                                <%=JSPDate.drawDateWithStyle(jspGlArchive.colNames[jspGlArchive.JSP_TRANSACTION_DATE], (glArchive.getTransactionDate() == null) ? new Date() : glArchive.getTransactionDate(), 0, -10, "formElemen", "") %> 
                                                                <input name="<%=jspGlArchive.colNames[jspGlArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (glArchive.getIgnoreTransactionDate() == 1) {%>checked<%}%>>
                                                                       Ignore </td>
                                                            </tr>
                                                            <tr> 
                                                                <td width="14%">Journal Number</td>
                                                                <td width="86%"> 
                                                                    <input type="text" name="<%=jspGlArchive.colNames[jspGlArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= glArchive.getJournalNumber() %>">
                                                                </td>
                                                            </tr>
                                                            <tr> 
                                                                <td width="14%">Ref-Number</td>
                                                                <td width="86%"> 
                                                                    <input type="text" name="src_ref_number"  value="<%=srcRefNumber %>">
                                                                </td>
                                                            </tr>
                                                            <tr> 
                                                                <td width="14%"> 
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                        <tr>
                                                                            <td width="19%"><a href="javascript:cmdSearch()"><img src="../images/search2.jpg" width="22" height="22" border="0"></a></td>
                                                                            <td width="81%"><a href="javascript:cmdSearch()">Get 
                                                                            Report</a></td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                                <td width="86%">&nbsp;</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="container">
                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                            <tr>
                                                                <td>&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="tablecell1">&nbsp;</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td class="container"> 
                                                        <div align="center"><span class="level1"><font size="+1"><b>Jurnal 
                                                        Detail </b></font></span></div>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td class="container"> 
                                                        <div align="center"><span class="level1"><b>PERIOD 
                                                        <%=openPeriod.getName()%></b></span></div>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td class="container"> 
                                                        <div align="center"><span class="level1">Periode 
                                                        Date : <%=JSPFormater.formatDate(openPeriod.getStartDate(), "dd/MM/yyyy") + " - " + JSPFormater.formatDate(openPeriod.getEndDate(), "dd/MM/yyyy")%></span></div>
                                                    </td>
                                                </tr>
                                                <%
            if (iCommand != JSPCommand.NONE) {

                if (glArchive.getIgnoreInputDate() == 0) {%>
                                                <tr> 
                                                    <td class="container"> 
                                                        <div align="center"><b>Input Date : <%=JSPFormater.formatDate(glArchive.getStartDate(), "dd/MM/yyyy")%> - <%=JSPFormater.formatDate(glArchive.getEndDate(), "dd/MM/yyyy")%></b></div>
                                                    </td>
                                                </tr>
                                                <%}%>
                                                <%if (glArchive.getIgnoreTransactionDate() == 0) {%>
                                                <tr> 
                                                    <td class="container"> 
                                                        <div align="center"><b>Transaction Date : <%=JSPFormater.formatDate(glArchive.getTransactionDate(), "dd/MM/yyyy")%></b></div>
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

                    Vector details = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), "debet desc");

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

                    //check lagi
                    double debetSP = 0;
                    double creditSP = 0;
                    double debetNSP = 0;
                    double creditNSP = 0;
                    if (diff) {

                        for (int x = 0; x < details.size(); x++) {
                            GlDetail gld = (GlDetail) details.get(x);
                            Coa coa = new Coa();
                            try {
                                coa = DbCoa.fetchExc(gld.getCoaId());
                            } catch (Exception e) {
                            }

                            if (coa.getAccountClass() == DbCoa.ACCOUNT_CLASS_SP) {
                                debetSP = debetSP + gld.getDebet();
                                creditSP = creditSP + gld.getCredit();
                            } else {
                                debetNSP = debetNSP + gld.getDebet();
                                creditNSP = creditNSP + gld.getCredit();
                            }

                        }
                    }

                    if ((debetSP == creditSP) && (debetNSP == creditNSP)) {
                        diff = false;
                    }

                    //===============================================

                    if (diff) {


                                                            %>
                                                            <tr> 
                                                                <td width="13%" class="tablehdr" height="17" nowrap><font size="1">Date 
                                                                : <%=JSPFormater.formatDate(gl.getDate(), "dd MMMM yyyy")%></font></td>
                                                                <td width="17%" class="tablehdr" height="17" nowrap><font size="1">Trans. 
                                                                Date : <%=JSPFormater.formatDate(gl.getTransDate(), "dd MMMM yyyy")%></font></td>
                                                                <td width="23%" class="tablehdr" height="17" nowrap><font size="1">Journal 
                                                                Num : <%=gl.getJournalNumber()%>, Ref. Num : <%=(gl.getRefNumber() == null || gl.getRefNumber().length() == 0) ? "-" : gl.getRefNumber()%></font></td>
                                                                <td width="2%" height="17">&nbsp;</td>
                                                                <td width="45%" height="17"><u><i><font size="1"><%=gl.getMemo()%></font></i></u></td>
                                                            </tr>
                                                            <tr> 
                                                                <td colspan="5" height="1"></td>
                                                            </tr>
                                                            <tr> 
                                                                <td colspan="5"> 
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0" align="right">
                                                                        <tr> 
                                                                            <td class="tablecell" height="18" width="28%"> 
                                                                                <div align="center"><font size="1"><b>Account 
                                                                                Description</b></font></div>
                                                                            </td>
                                                                            <td class="tablecell" height="18" width="6%">
                                                                                <div align="center"><b><font size="1">Coa 
                                                                                Type</font></b></div>
                                                                            </td>
                                                                            <td class="tablecell" height="18" width="18%"> 
                                                                                <div align="center"><font size="1"><b>Debet</b></font></div>
                                                                            </td>
                                                                            <td class="tablecell" height="18" width="13%"> 
                                                                                <div align="center"><font size="1"><b>Credit</b></font></div>
                                                                            </td>
                                                                            <td class="tablecell" height="18" width="35%"> 
                                                                                <div align="center"><font size="1"><b>Description</b></font></div>
                                                                            </td>
                                                                        </tr>
                                                                        <!--tr> 
                                          <td colspan="4" height="1"></td>
                                        </tr-->
                                        <%

                                                                                      double subTotDebet = 0;
                                                                                      double subTotCredit = 0;
                                                                                      if (details != null && details.size() > 0) {

                                                                                          for (int x = 0; x < details.size(); x++) {
                                                                                              GlDetail gld = (GlDetail) details.get(x);
                                                                                              Coa coa = new Coa();
                                                                                              try {
                                                                                                  coa = DbCoa.fetchExc(gld.getCoaId());
                                                                                              } catch (Exception e) {
                                                                                              }

                                                                                              subTotDebet = subTotDebet + gld.getDebet();
                                                                                              subTotCredit = subTotCredit + gld.getCredit();



                                                                                 %>
                                                                        <tr> 
                                                                        <td <%if (!diff) {%>class="tablecell1"<%} else {%>bgcolor="#FF0000"<%}%> width="28%"><font size="1"><%=coa.getCode() + " - " + coa.getName()%></font></td>
                                                                            <td <%if (!diff) {%>class="tablecell1"<%} else {%>bgcolor="#FF0000"<%}%> width="6%"> 
                                                                                <div align="center">
                                                                                <%
                                                                                             if (coa.getAccountClass() == DbCoa.ACCOUNT_CLASS_SP) {
                                                                                                 out.println("SP");
                                                                                             } else {
                                                                                                 out.println("NSP");
                                                                                             }
                                                                                %>
                                                                                </div>
                                                                            </td>
                                                                            <td <%if (!diff) {%>class="tablecell1"<%} else {%>bgcolor="#FF0000"<%}%>  width="18%"> 
                                                                                <div align="right"><font size="1"><%=(gld.getDebet() == 0) ? "" : JSPFormater.formatNumber(gld.getDebet(), "#,###.##")%>&nbsp;&nbsp;</font></div>
                                                                            </td>
                                                                            <td <%if (!diff) {%>class="tablecell1"<%} else {%>bgcolor="#FF0000"<%}%>  width="13%"> 
                                                                                <div align="right"><font size="1"><%=(gld.getCredit() == 0) ? "" : JSPFormater.formatNumber(gld.getCredit(), "#,###.##")%>&nbsp;&nbsp;</font></div>
                                                                            </td>
                                                                            <td class="tablecell1" width="35%"><font size="1"><%=gld.getMemo()%></font></td>
                                                                        </tr>
                                                                        <!--tr> 
                                          <td colspan="4" height="1"></td>
                                        </tr-->
                                        <%}
                                                                                      }

                                                                                      grandTotalDebet = grandTotalDebet + subTotDebet;
                                                                                      grandTotalCredit = grandTotalCredit + subTotCredit;

                                                                                 %>
                                                                        <tr> 
                                                                            <td class="tablecell" width="28%" height="18"> 
                                                                                <div align="center"><font size="1"><b>Sub 
                                                                                Total </b></font></div>
                                                                            </td>
                                                                            <td class="tablecell" width="6%" height="18">&nbsp;</td>
                                                                            <td <%if (subTotDebet == subTotCredit) {%>class="tablecell"<%} else {%>bgcolor="#FF0000"<%}%> width="18%" height="18"> 
                                                                                <div align="right"><font size="1"><b><u><%=(subTotDebet == 0) ? "" : JSPFormater.formatNumber(subTotDebet, "#,###.##")%></u>&nbsp;&nbsp;</b></font></div>
                                                                            </td>
                                                                            <td <%if (subTotDebet == subTotCredit) {%>class="tablecell"<%} else {%>bgcolor="#FF0000"<%}%> width="13%" height="18"> 
                                                                                <div align="right"><font size="1"><b><u><%=(subTotCredit == 0) ? "" : JSPFormater.formatNumber(subTotCredit, "#,###.##")%></u>&nbsp;&nbsp;</b></font></div>
                                                                            </td>
                                                                            <td class="tablecell" width="35%" height="18"><font size="1"></font></td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td class="tablecell1" width="28%">&nbsp;</td>
                                                                            <td class="tablecell1" width="6%">&nbsp;</td>
                                                                            <td class="tablecell1" width="18%">&nbsp;</td>
                                                                            <td class="tablecell1" width="13%">&nbsp;</td>
                                                                            <td class="tablecell1" width="35%">&nbsp;</td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <%}
                }
            }%>
                                                            <tr> 
                                                                <td colspan="5"> 
                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0" align="right">
                                                                        <tr> 
                                                                            <td class="tablecell" width="33%" height="18"> 
                                                                                <div align="center"><b><span class="level2">Grand 
                                                                                Total</span> </b></div>
                                                                            </td>
                                                                            <td class="tablecell" width="14%" height="18"> 
                                                                                <div align="right"><font color="#FF6600"><b><u><%=(grandTotalDebet == 0) ? "" : JSPFormater.formatNumber(grandTotalDebet, "#,###.##")%></u>&nbsp;&nbsp;</b></font></div>
                                                                            </td>
                                                                            <td class="tablecell" width="15%" height="18"> 
                                                                                <div align="right"><font color="#FF6600"><b><u><%=(grandTotalCredit == 0) ? "" : JSPFormater.formatNumber(grandTotalCredit, "#,###.##")%></u>&nbsp;&nbsp;</b></font></div>
                                                                            </td>
                                                                            <td class="tablecell" width="38%" height="18">&nbsp;</td>
                                                                        </tr>
                                                                        <tr> 
                                                                            <td class="tablecell1" width="33%"> 
                                                                                <div align="center"><b><span class="level2">Balance</span></b></div>
                                                                            </td>
                                                                            <td class="tablecell1" width="14%">&nbsp;</td>
                                                                            <td class="tablecell1" width="15%"> 
                                                                                <div align="right"><b><%=(grandTotalDebet == grandTotalCredit) ? "-" : "<font color=\"red\">" + JSPFormater.formatNumber(grandTotalDebet - grandTotalCredit, "#,###.##") + "</font>"%>&nbsp;&nbsp;</b></div>
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
