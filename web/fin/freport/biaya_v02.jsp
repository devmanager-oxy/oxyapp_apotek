
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.fms.report.RptBiayaOperasiDireksi" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>	
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT, AppMenu.PRIV_DELETE);
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
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###");
        } else if (amount == 0) {
            displayStr = "";
        }
        if (coaStatus.equals("HEADER")) {
            displayStr = "<b>" + displayStr + "</b>";
        }
        return displayStr;
    }

    public String strDisplay(double amount) {
        String displayStr = "";
        if (amount < 0) {
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###");
        } else if (amount == 0) {
            displayStr = "";
        }
        return displayStr;
    }

    public String getContentDisplay(String stt, String str) {
        String result = "";
        if (stt.equals("HEADER")) {
            result = "<b>";
        }
        result = result + str;
        if (stt.equals("HEADER")) {
            result = result + "</b>";
        }
        return result;
    }

%> 
<%

            //pnlType = 0, biaya | pnlType = 1, pendapatan
            int pnlType = JSPRequestValue.requestInt(request, "pnl_type");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidPeriod = JSPRequestValue.requestLong(request, "oid_period");

            Periode periode = new Periode();
            Vector listCoa = new Vector(1, 1);
            Coa coa = new Coa();
            Vector listReport = new Vector();

            double total = 0;
            double totalUmum = 0;
            double totalPerencanaan = 0;
            double totalKeuangan = 0;

            String strTotal = "";
            String strTotalUmum = "";
            String strTotalPerencanaan = "";
            String strTotalKeuangan = "";

            String where = "";
            String cssString = "tablecell1";
            RptBiayaOperasiDireksi sesReport = new RptBiayaOperasiDireksi();

            if (oidPeriod != 0 && iJSPCommand == JSPCommand.SUBMIT) {
                periode = DbPeriode.fetchExc(oidPeriod);
                where = DbCoa.colNames[DbCoa.COL_ACCOUNT_GROUP] + "='" + I_Project.ACC_GROUP_EXPENSE + "'";
                listCoa = DbCoa.list(0, 0, where, "code");
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
            function cmdSearch(){
                document.frmcoa.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmcoa.action="biaya_v02.jsp";
                document.frmcoa.submit();
            }
            
            function cmdPrintXls(){	 
                window.open("<%=printroot%>.report.RptBiayaOperasiDireksiXls?oid=<%=appSessUser.getLoginId()%>&pnl_type=<%=pnlType%>");
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
            String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Biaya Operasi Direksi</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcoa" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="pnl_type" value="<%=pnlType%>">
                                                            <input type="hidden" name=oid_period" value="<%=oidPeriod%>">                          
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" align="left" colspan="3">Period&nbsp;&nbsp;
                                                                                    <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_NAME]);
            Vector p_value = new Vector(1, 1);
            Vector p_key = new Vector(1, 1);

            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                    p_value.add(period.getName().trim());
                    p_key.add("" + period.getOID());
                }
            }
                                                                                    %>
                                                                                    <%= JSPCombo.draw("oid_period", "Select...", String.valueOf(oidPeriod), p_key, p_value, "", "formElemen") %>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" align="left" colspan="3"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></td>
                                                                            </tr>
                                                                            
                                                                            <%
            if (listCoa != null && listCoa.size() > 0) {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" align="center" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><font size="+1"><b>BIAYA OPERASI DIREKSI</b></font></span></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="20" valign="middle" align="center" colspan="3"><span class="level1"><b><font size="3">BULAN <%=periode.getName()%></font></b></span></td>
                                                                            </tr>
                                                                            <% }%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="10" valign="middle" colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3" class="page"> 
                                                                                
                                                                                
                                                                                
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                        <%
            if (listCoa != null && listCoa.size() > 0) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablehdr" height="22" width="40%"><font size="1">URAIAN</font></td>
                                                                                            <td class="tablehdr" height="22" width="15%"><font size="1">TOTAL</font></td>
                                                                                            <td class="tablehdr" height="22" width="15%"><font size="1">DIRUT masuk ke UMUM</font></td>
                                                                                            <td class="tablehdr" height="22" width="15%"><font size="1">DIRUT masuk ke PERNCANAAN</font></td>
                                                                                            <td class="tablehdr" height="22" width="15%"><font size="1">DIRUT masuk ke KEUANGAN</font></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        String space = "";
                                                                                            String strTotalBiaya = "";
                                                                                            String strBiayaUmum = "";
                                                                                            String strBiayaPerencanaan = "";
                                                                                            String strBiayaKeuangan = "";

                                                                                            for (int i = 0; i < listCoa.size(); i++) {
                                                                                                coa = (Coa) listCoa.get(i);
                                                                                                if (coa.getLevel() == 1 || coa.getLevel() == 2 ||
                                                                                                        (coa.getLevel() == 3 && coa.getOID() == 3084) ||
                                                                                                        (coa.getLevel() == 4 && coa.getAccRefId() == 3084)) {
                                                                                                    
                                                                                                    space = switchLevel(coa.getLevel());
                                                                                                    
                                                                                                    double totalBiaya = DbCoa.getCoaBalanceRecursif(coa, periode, "DC");
                                                                                                    double biayaPerencanaan = totalBiaya * 0.3214;
                                                                                                    double biayaKeuangan = biayaPerencanaan;
                                                                                                    double biayaUmum = totalBiaya - biayaPerencanaan - biayaKeuangan;
                                                                                                    strTotalBiaya = strDisplay(totalBiaya, coa.getStatus());
                                                                                                    strBiayaUmum = strDisplay(biayaUmum, coa.getStatus());
                                                                                                    strBiayaPerencanaan = strDisplay(biayaPerencanaan, coa.getStatus());
                                                                                                    strBiayaKeuangan = strDisplay(biayaKeuangan, coa.getStatus());

                                                                                                    total += totalBiaya;
                                                                                                    totalUmum += biayaUmum;
                                                                                                    totalPerencanaan += biayaPerencanaan;
                                                                                                    totalKeuangan += biayaKeuangan;
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <font size="1"><%=getContentDisplay(coa.getStatus(), space + coa.getCode() + " - " + coa.getName())%></font>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), strTotalBiaya)%> </font></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), strBiayaUmum)%> </font></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), strBiayaPerencanaan)%> </font></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), strBiayaKeuangan)%> </font></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                    sesReport = new RptBiayaOperasiDireksi();

                                                                                                    sesReport.setCoaName(coa.getName());
                                                                                                    sesReport.setCoaCode(coa.getCode());
                                                                                                    sesReport.setCoaLevel(coa.getLevel());
                                                                                                    sesReport.setCoaStatus(coa.getStatus());
                                                                                                    sesReport.setUraian(getContentDisplay(coa.getStatus(), space + coa.getCode() + " - " + coa.getName()));
                                                                                                    sesReport.setTotalBiaya(totalBiaya);
                                                                                                    sesReport.setBiayaUmum(biayaUmum);
                                                                                                    sesReport.setBiayaPerencanaan(biayaPerencanaan);
                                                                                                    sesReport.setBiayaKeuangan(biayaKeuangan);

                                                                                                    listReport.add(sesReport);
                                                                                                }
                                                                                            }//end for cogs

                                                                                            strTotal = strDisplay(total, coa.getStatus());
                                                                                            strTotalUmum = strDisplay(totalUmum, coa.getStatus());
                                                                                            strTotalPerencanaan = strDisplay(totalPerencanaan, coa.getStatus());
                                                                                            strTotalKeuangan = strDisplay(totalKeuangan, coa.getStatus());

                                                                                            session.putValue("BIAYAOPERASIDIREKSI", listReport);
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablehdr" nowrap> 
                                                                                                <font size="1">TOTAL BIAYA</font>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), strTotal)%> </font></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), strTotalUmum)%> </font></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <div align="right"> <font size="1"><%=getContentDisplay(coa.getStatus(), strTotalPerencanaan)%> </font></div>
                                                                                            </td>
                                                                                            <td class="<%=cssString%>" nowrap> 
                                                                                                <div align="right"><font size="1"><%=getContentDisplay(coa.getStatus(), strTotalKeuangan)%> </font></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                        } else {//end list coa !=null
                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="tablecell1" colspan="7">Please click search button to show report</td>
                                                                                        </tr>                                                                                            
                                                                                        <%}%>
                                                                                    </table>                                                                                    
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <% if (listCoa != null && listCoa.size() > 0) {%>
                                                                                    <a href="javascript:cmdPrintXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printxls" width="120" height="22" border="0"></a>
                                                                                    <% } %>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
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
            <%@ include file="../main/footer.jsp"%>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
