
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1; %>
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
            displayStr = "(" + JSPFormater.formatNumber(amount * -1, "#,###.##") + ")";
        } else if (amount > 0) {
            displayStr = JSPFormater.formatNumber(amount, "#,###.##");
        } else if (amount == 0) {
            displayStr = "";
        }
        return displayStr;
    }

%>
<%
            if (session.getValue("BS_STANDARD") != null) {
                session.removeValue("BS_STANDARD");
            }

            String grpType = JSPRequestValue.requestString(request, "groupType");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoa = JSPRequestValue.requestLong(request, "hidden_coa_id");

            int valShowList = JSPRequestValue.requestInt(request, "showlist");

            if (valShowList == 0) {
                valShowList = 1;
            }

            /*variable declaration*/
            int recordToGet = 10;
//int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "code";

            Vector listCoa = new Vector(1, 1);

            int vectSize = DbCoa.getCount(whereClause);
            recordToGet = vectSize;

            Coa coa = new Coa();

            /* get record to display */
            if (iJSPCommand == JSPCommand.LIST) {
                listCoa = DbCoa.list(start, recordToGet, whereClause, orderClause);
            }

            String strTotal = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            String strTotal1 = "       ";
            String cssString = "tablecell1";
            String displayStr = "";
            String displayStr_lastYear = "";

            double coaSummary1 = 0;
            double coaSummary2 = 0;
            double coaSummary3 = 0;
            double coaSummary4 = 0;
            double coaSummary5 = 0;
            double coaSummary6 = 0;
            
            double anggaranSummary1 = 0;
            double anggaranSummary2 = 0;
            double anggaranSummary3 = 0;
            double anggaranSummary4 = 0;
            double anggaranSummary5 = 0;
            double anggaranSummary6 = 0;
            
            double coaSummary1_lastYear = 0;
            double coaSummary2_lastYear = 0;
            double coaSummary3_lastYear = 0;
            double coaSummary4_lastYear = 0;
            double coaSummary5_lastYear = 0;
            double coaSummary6_lastYear = 0;

            double coaSum1 = 0;
            double coaSum1_lastYear = 0;
            double coaSum2 = 0;
            double coaSum2_lastYear = 0;
            double coaSum3 = 0;
            double coaSum3_lastYear = 0;
            double coaSum4 = 0;
            double coaSum4_lastYear = 0;
            double coaSum5 = 0;
            double coaSum5_lastYear = 0;
            double coaSum6 = 0;
            double coaSum6_lastYear = 0;

            Vector listReport = new Vector();
            SesReportBs sesReport = new SesReportBs();

            double totalAktiva = 0;
            double totalPasiva = 0;
            
            double totalAktiva_lastYear = 0;
            double totalPasiva_lastYear = 0;

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
            function cmdChangeList(){
                document.frmcoa.action="bsstandard_v02.jsp";
                document.frmcoa.submit();
            }
            
            function cmdSearch(){
                document.frmcoa.action="bsstandard_v02.jsp";
                document.frmcoa.command.value="<%=JSPCommand.LIST%>";
                document.frmcoa.submit();
            }    
            
            function cmdPrintJournal(){	 
                window.open("<%=printroot%>.report.RptBSStandardPDF?oid=<%=appSessUser.getLoginId()%>");
                }
                
                function cmdPrintJournalXLS(){	 
                    window.open("<%=printroot%>.report.RptBSStandardXLS?oid=<%=appSessUser.getLoginId()%>");
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
                            <!-- #EndEditable -->                            </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                        <!-- #EndEditable -->                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Financial Report</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Balance Sheet Detail</span></font>";
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
                                                                    <td colspan="3" class="container">
                                                                        <table width="100%" border="0">   
                                                                            <tr>
                                                                                <td colspan="6" align="center">&nbsp;</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="6" align="left" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; vertical-align:bottom;">
                                                                                    <table border="0">
                                                                                        <tr>
                                                                                            <td>
                                                                                                Show List :
                                                                                                <select name="showlist" onChange="javascript:cmdChangeList()">
                                                                                                    <option value="1" <%if (valShowList == 1) {%>selected<%}%>>Hide Acc. Without Transaction</option>
                                                                                                    <option value="2" <%if (valShowList == 2) {%>selected<%}%>>All</option>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td>
                                                                                                &nbsp;&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a>															
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td colspan="6" align="left">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            if (iJSPCommand == JSPCommand.LIST) {
                                                                            %>
                                                                            <%
                                                                                Periode periode = DbPeriode.getOpenPeriod();
                                                                                String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");

                                                                                int lastYear = DbPeriode.getOpenPeriod().getStartDate().getYear() + 1900 - 1;
                                                                            %>  
                                                                            <tr>
                                                                                <td colspan="6" align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:15px; font-weight:bold;">BALANCE SHEET</td>
                                                                            </tr>	
                                                                            <tr>
                                                                                <td colspan="6" align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:13px; font-weight:bold;"><%=openPeriod%></td>
                                                                            </tr>	
                                                                            <tr>
                                                                                <td colspan="6">&nbsp;</td>
                                                                            </tr>	
                                                                            <%
                                                                                int monthLast = periode.getEndDate().getMonth() + 1;
                                                                                String endPeriodLastYear = lastYear + "-" + monthLast + "-" + periode.getEndDate().getDate();
                                                                                Date dtendPeriodLastYear = JSPFormater.formatDate(endPeriodLastYear, "yyyy-MM-dd");
                                                                            %>
                                                                            <tr>
                                                                                <td width="40%" rowspan="2" class="tablehdr" align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold;">URAIAN</td>
                                                                                <td width="15%" rowspan="2" class="tablehdr" align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold;">REALISASI<BR>
                                                                                    PER<BR>
                                                                                <%=JSPFormater.formatDate(dtendPeriodLastYear, "dd MMM yyyy")%></td>
                                                                                <td width="15%" rowspan="2" class="tablehdr" align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold;">ANGGARAN<br />
                                                                                    PER<br />
                                                                                <%=JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy")%></td>
                                                                                <td width="15%" rowspan="2" class="tablehdr" align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold;">REALISASI<br />
                                                                                    PER<br />
                                                                                <%=JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy")%></td>
                                                                                <td width="15%" colspan="2" class="tablehdr" align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold;">%<BR>
                                                                                    TERHADAP<BR>                                                                                
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td align="center" class="tablehdr" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold;"><%=lastYear%></td>
                                                                                <td align="center" class="tablehdr" style="font-family:Arial, Helvetica, sans-serif; font-size:12px; font-weight:bold;">ANGG</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="tablecell" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">&nbsp;<b>Activa</b></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>                                                                                
                                                                            </tr>
                                                                            <%
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Top Level");
                                                                                sesReport.setDescription("Activa");
                                                                                sesReport.setFont(1);
                                                                                listReport.add(sesReport);

                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LIQUID_ASSET, "DC") != 0 || valShowList != 1){	//add Group Header

                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_LIQUID_ASSET);
                                                                                    sesReport.setFont(1);

                                                                                    listReport.add(sesReport);
                                                                            %>       
                                                                            <tr>
                                                                                <td class="tablecell" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                &nbsp;<b><%=strTotal + I_Project.ACC_GROUP_LIQUID_ASSET%></b></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>                                                                                
                                                                            </tr>       
                                                                            <%
                                                                                }
                                                                            %>
                                                                            
                                                                            <%

                                                                                if (listCoa != null && listCoa.size() > 0) {

                                                                                    coaSummary1 = 0;
                                                                                    coaSummary1_lastYear = 0;
                                                                                    anggaranSummary1 = 0;
                                                                                    
                                                                                    String str = "";
                                                                                    String str1 = "";

                                                                                    for (int iCoa = 0; iCoa < listCoa.size(); iCoa++) {

                                                                                        coa = (Coa) listCoa.get(iCoa);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LIQUID_ASSET)) {

                                                                                            str = switchLevel(coa.getLevel());
                                                                                            str1 = switchLevel1(coa.getLevel());
                                                                                            double amountCoa = 0;
                                                                                            double amountCoa_lastYear = 0;
                                                                                            double anggaran = 0;

                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                amountCoa = DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC");
                                                                                                amountCoa_lastYear = DbCoa.getCoaBalanceByHeaderLastYear(coa.getOID(), "DC");
                                                                                                anggaran = DbCoa.getCoaBudget(coa.getOID());
                                                                                            }
                                                                                            
                                                                                            coaSummary1 = coaSummary1 + amountCoa;
                                                                                            coaSummary1_lastYear = coaSummary1_lastYear + amountCoa_lastYear;
                                                                                            anggaranSummary1 = anggaranSummary1 + anggaran;
                                                                                            
                                                                                            displayStr = strDisplay(amountCoa, coa.getStatus());
                                                                                            displayStr_lastYear = strDisplay(amountCoa_lastYear, coa.getStatus());

                                                                                            if (valShowList == 1){
                                                                                                
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC") != 0) || ((coa.getStatus().equals("HEADER")) && ( amountCoa != 0 || amountCoa_lastYear != 0))) {	//add detail
                                                                                                    
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setAmount(amountCoa);
                                                                                                    sesReport.setStrAmount("" + amountCoa);
                                                                                                    sesReport.setAmountPrevYear(amountCoa_lastYear);
                                                                                                    sesReport.setStrAmountPrevYear("" + amountCoa_lastYear);
                                                                                                    sesReport.setFont(0);
                                                                                                    listReport.add(sesReport);         
                                                                                                                     
                                                                                                    double persnThdRealisasi = 0;
                                                                                                    double persenAnggaran = 0;
                                                                                                    
                                                                                                    if(amountCoa_lastYear != 0){    
                                                                                                        persnThdRealisasi = (amountCoa/amountCoa_lastYear)*100; 
                                                                                                    }
                                                                                                    if(anggaran != 0){
                                                                                                        persenAnggaran = (amountCoa/anggaran)*100;
                                                                                                    }
                                                                                                    
                                                                            %>
                                                                            <tr>                                                                                
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persnThdRealisasi%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>                                                                                
                                                                            </tr>
                                                                            <%
                                                                                                                                                                            }

                                                                                                                                                                        } else {

                                                                                                                                                                            if ((coa.getStatus().equals("HEADER")) || ((coa.getStatus().equals("HEADER")) && amountCoa != 0)) {	//add detail

                                                                                                                                                                                sesReport = new SesReportBs();
                                                                                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                                                                                sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                                                                                sesReport.setAmount(amountCoa);
                                                                                                                                                                                sesReport.setStrAmount("" + amountCoa);
                                                                                                                                                                                sesReport.setAmountPrevYear(amountCoa_lastYear);
                                                                                                                                                                                sesReport.setStrAmountPrevYear("" + amountCoa_lastYear);
                                                                                                                                                                                sesReport.setFont(0);
                                                                                                                                                                                listReport.add(sesReport);
                                                                                                                                                                                
                                                                                                                                                                                double persen = 0;
                                                                                                                                                                                double persenAnggaran = 0;
                                                                                                                                                                                
                                                                                                                                                                                if(amountCoa_lastYear != 0){
                                                                                                                                                                                    persen = ( amountCoa/amountCoa_lastYear )*100;
                                                                                                                                                                                }
                                                                                                                                                                                
                                                                                                                                                                                if(anggaran != 0){
                                                                                                                                                                                    persenAnggaran = (amountCoa/anggaran)*100;
                                                                                                                                                                                }
                                                                            %>    
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>
                                                                            <%
                                                                                                                                                                            }
                                                                                                                                                                        }
                                                                                                                                                                    }

                                                                                                                                                                    if (coaSummary1 < 0) {
                                                                                                                                                                        displayStr = "(" + JSPFormater.formatNumber(coaSummary1 * -1, "#,###.##") + ")";
                                                                                                                                                                    } else if (coaSummary1 > 0) {
                                                                                                                                                                        displayStr = JSPFormater.formatNumber(coaSummary1, "#,###.##");
                                                                                                                                                                    } else if (coaSummary1 == 0) {
                                                                                                                                                                        displayStr = "";
                                                                                                                                                                    }
                                                                                        
                                                                                                                                                                    if (coaSummary1_lastYear < 0) {
                                                                                                                                                                        displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary1_lastYear * -1, "#,###.##") + ")";
                                                                                                                                                                    } else if (coaSummary1_lastYear > 0) {
                                                                                                                                                                        displayStr_lastYear = JSPFormater.formatNumber(coaSummary1_lastYear, "#,###.##");
                                                                                                                                                                    } else if (coaSummary1_lastYear == 0) {
                                                                                                                                                                        displayStr_lastYear = "";
                                                                                                                                                                    }

                                                                                                                                                                }
                                                                                                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LIQUID_ASSET, "DC") != 0 || valShowList != 1) {	//add Group Footer
                                                                                                                                                                    sesReport = new SesReportBs();
                                                                                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                                                                                    sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_LIQUID_ASSET);
                                                                                                                                                                    sesReport.setAmount(coaSummary1);
                                                                                                                                                                    sesReport.setStrAmount("" + coaSummary1);
                                                                                                                                                                    sesReport.setAmountPrevYear(coaSummary1_lastYear);
                                                                                                                                                                    sesReport.setStrAmountPrevYear("" + coaSummary1_lastYear);
                                                                                                                                                                    sesReport.setFont(1);
                                                                                                                                                                    listReport.add(sesReport);
                                                                                                                                                                    
                                                                                                                                                                    double persen = 0;
                                                                                                                                                                    double persenAnggaran = 0;
                                                                                                                                                                    
                                                                                                                                                                    if(coaSummary1_lastYear != 0){
                                                                                                                                                                        persen = ( coaSummary1 / coaSummary1_lastYear )*100;
                                                                                                                                                                    }
                                                                                                                                                                    
                                                                                                                                                                    if(anggaranSummary1 != 0){
                                                                                                                                                                        persenAnggaran = (coaSummary1/anggaranSummary1)*100;
                                                                                                                                                                    }
                                                                            %>  
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b><%=strTotal + "Sub Total " + I_Project.ACC_GROUP_LIQUID_ASSET%></b></span></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=anggaranSummary1%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=displayStr%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=persen%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>    
                                                                            <%
                                                                                    }
                                                                                }
                                                                            %>
                                                                            <%
                                                                            
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Top Level");
                                                                                sesReport.setDescription("Activa");
                                                                                sesReport.setFont(1);
                                                                                listReport.add(sesReport);

                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET, "DC") != 0 || valShowList != 1) {	//add Group Header

                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_FIXED_ASSET);
                                                                                    sesReport.setFont(1);

                                                                                    listReport.add(sesReport);
                                                                            %>       
                                                                            <tr>
                                                                                <td class="tablecell" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                &nbsp;<b><%=strTotal + I_Project.ACC_GROUP_FIXED_ASSET%></b></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>                                                                                
                                                                            </tr>       
                                                                            <%
                                                                                }
                                                                            %>
                                                                            <%

                                                                                if (listCoa != null && listCoa.size() > 0) {

                                                                                    coaSummary2 = 0;
                                                                                    coaSummary2_lastYear = 0;
                                                                                    anggaranSummary2 = 0;
                                                                                    
                                                                                    String strCoa = "";
                                                                                    String strCoa1 = "";

                                                                                    for (int iCoa = 0; iCoa < listCoa.size(); iCoa++) {

                                                                                        coa = (Coa) listCoa.get(iCoa);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_FIXED_ASSET)) {

                                                                                            strCoa = switchLevel(coa.getLevel());
                                                                                            strCoa1 = switchLevel1(coa.getLevel());
                                                                                            
                                                                                            double amountCoa = 0;
                                                                                            double amountCoa_lastYear = 0;
                                                                                            double anggaran = 0;

                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                amountCoa = DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC");
                                                                                                amountCoa_lastYear = DbCoa.getCoaBalanceByHeaderLastYear(coa.getOID(), "DC");
                                                                                                anggaran = DbCoa.getCoaBudget(coa.getOID());
                                                                                            }

                                                                                            coaSummary2 = coaSummary2 + amountCoa;
                                                                                            coaSummary2_lastYear = coaSummary2_lastYear + amountCoa_lastYear;
                                                                                            anggaranSummary2 = anggaranSummary2 + anggaran;
                                                                                                    
                                                                                            displayStr = strDisplay(amountCoa, coa.getStatus());
                                                                                            displayStr_lastYear = strDisplay(amountCoa_lastYear, coa.getStatus());

                                                                                            if (valShowList == 1) {
                                                                                                
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC") != 0) || ((coa.getStatus().equals("HEADER")) && amountCoa != 0)) {	//add detail
                                                                                                    
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + strCoa1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setAmount(amountCoa);
                                                                                                    sesReport.setStrAmount("" + amountCoa);
                                                                                                    sesReport.setAmountPrevYear(amountCoa_lastYear);
                                                                                                    sesReport.setStrAmountPrevYear("" + amountCoa_lastYear);
                                                                                                    sesReport.setFont(0);
                                                                                                    listReport.add(sesReport);
                                                                                                    
                                                                                                    double persen = 0;
                                                                                                    double persenAnggaran = 0;                                                                                                    
                                                                                                    
                                                                                                    if(amountCoa_lastYear != 0){
                                                                                                        persen = ( amountCoa/amountCoa_lastYear ) * 100;
                                                                                                    }
                                                                                                    if(anggaran != 0){
                                                                                                        persenAnggaran = ( amountCoa/anggaran ) * 100;
                                                                                                    }
                                                                            %>
                                                                            <tr>                                                                                
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + strCoa + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>                                                                                
                                                                            </tr>
                                                                            <%
                                                                                                                                                                            }

                                                                                                                                                                        } else {

                                                                                                                                                                            if ((coa.getStatus().equals("HEADER")) || ((coa.getStatus().equals("HEADER")) && amountCoa != 0)) {	//add detail

                                                                                                                                                                                sesReport = new SesReportBs();
                                                                                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                                                                                sesReport.setDescription(strTotal1 + strTotal1 + strCoa1 + coa.getCode() + " - " + coa.getName());
                                                                                                                                                                                sesReport.setAmount(amountCoa);
                                                                                                                                                                                sesReport.setStrAmount("" + amountCoa);
                                                                                                                                                                                sesReport.setAmount(amountCoa);
                                                                                                                                                                                sesReport.setStrAmountPrevYear("" + amountCoa_lastYear);
                                                                                                                                                                                sesReport.setAmountPrevYear(amountCoa_lastYear);
                                                                                                                                                                                sesReport.setFont(0);
                                                                                                                                                                                listReport.add(sesReport);
                                                                                                                                                                                
                                                                                                                                                                                double persen = 0;
                                                                                                                                                                                double persenAnggaran = 0;
                                                                                                                                                                                
                                                                                                                                                                                if(amountCoa_lastYear != 0){
                                                                                                                                                                                    persen = (amountCoa/amountCoa_lastYear)*100;
                                                                                                                                                                                }
                                                                                                                                                                                
                                                                                                                                                                                if(anggaran != 0){
                                                                                                                                                                                    persenAnggaran = (amountCoa/anggaran)*100;
                                                                                                                                                                                }

                                                                            %>    
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + strCoa + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>                                                                            
                                                                            <%
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
                                                                                        
                                                                                                                                                                    if (coaSummary2_lastYear < 0) {
                                                                                                                                                                        displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary2_lastYear * -1, "#,###.##") + ")";
                                                                                                                                                                    } else if (coaSummary2_lastYear > 0) {
                                                                                                                                                                        displayStr = JSPFormater.formatNumber(coaSummary2_lastYear, "#,###.##");
                                                                                                                                                                    } else if (coaSummary2_lastYear == 0) {
                                                                                                                                                                        displayStr_lastYear = "";
                                                                                                                                                                    }

                                                                                                                                                                }
                                                                                                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_FIXED_ASSET, "DC") != 0 || valShowList != 1) {	//add Group Footer
                                                                                                                                                                    sesReport = new SesReportBs();
                                                                                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                                                                                    sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_FIXED_ASSET);
                                                                                                                                                                    sesReport.setAmount(coaSummary2);
                                                                                                                                                                    sesReport.setStrAmount("" + coaSummary2);
                                                                                                                                                                    sesReport.setAmountPrevYear(coaSummary2_lastYear);
                                                                                                                                                                    sesReport.setStrAmountPrevYear("" + coaSummary2_lastYear);
                                                                                                                                                                    sesReport.setFont(1);
                                                                                                                                                                    listReport.add(sesReport);
                                                                                                                                                                    
                                                                                                                                                                    double persen = 0;
                                                                                                                                                                    double persenAnggaran = 0;
                                                                                                                                                                    
                                                                                                                                                                    if(coaSummary2_lastYear != 0){
                                                                                                                                                                        persen = ( coaSummary2 / coaSummary2_lastYear)*100;
                                                                                                                                                                    }
                                                                                                                                                                    
                                                                                                                                                                    if(anggaranSummary2 != 0){
                                                                                                                                                                        persenAnggaran = ( coaSummary2 / anggaranSummary2)*100;
                                                                                                                                                                        
                                                                                                                                                                    }
                                                                            %>  
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b><%=strTotal + "Sub Total " + I_Project.ACC_GROUP_FIXED_ASSET%></b></span></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=anggaranSummary2%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=displayStr%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=persen%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=persenAnggaran%></b></div></td>
                                                                            </tr>    
                                                                            <%
                                                                                    }
                                                                                }
                                                                            %>
                                                                            <%
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Top Level");
                                                                                sesReport.setDescription("Activa");
                                                                                sesReport.setFont(1);
                                                                                listReport.add(sesReport);

                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_ASSET, "DC") != 0 || valShowList != 1) {	//add Group Header

                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_OTHER_ASSET);
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);
                                                                            %>       
                                                                            <tr>
                                                                                <td class="tablecell" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                &nbsp;<b><%=strTotal + I_Project.ACC_GROUP_OTHER_ASSET %></b></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>                                                                                
                                                                            </tr>       
                                                                            <%
                                                                                }
                                                                            %>
                                                                            
                                                                            <%

                                                                                if (listCoa != null && listCoa.size() > 0) {

                                                                                    coaSummary3 = 0;
                                                                                    coaSummary3_lastYear = 0;
                                                                                    anggaranSummary3 = 0;
                                                                                    String strCoa = "";
                                                                                    String strCoa1 = "";

                                                                                    for (int iCoa = 0; iCoa < listCoa.size(); iCoa++) {

                                                                                        coa = (Coa) listCoa.get(iCoa);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_ASSET)) {

                                                                                            strCoa = switchLevel(coa.getLevel());
                                                                                            strCoa1 = switchLevel1(coa.getLevel());
                                                                                            double amountCoa = 0;
                                                                                            double amountCoa_lastYear = 0;
                                                                                            double anggaran = 0;

                                                                                            if (coa.getStatus().equals("HEADER")){
                                                                                                amountCoa = DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC");
                                                                                                amountCoa_lastYear = DbCoa.getCoaBalanceByHeaderLastYear(coa.getOID(), "DC");
                                                                                                anggaran = DbCoa.getCoaBudget(coa.getOID());
                                                                                            }

                                                                                            coaSummary3 = coaSummary3 + amountCoa;
                                                                                            coaSummary3_lastYear = coaSummary3_lastYear + amountCoa_lastYear;
                                                                                            anggaranSummary3 = anggaranSummary3 + anggaran;
                                                                                            
                                                                                            displayStr = strDisplay(amountCoa, coa.getStatus());
                                                                                            displayStr_lastYear = strDisplay(amountCoa_lastYear, coa.getStatus());

                                                                                            if (valShowList == 1) {
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC") != 0) || ((coa.getStatus().equals("HEADER")) && amountCoa != 0)) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + strCoa1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setAmount(amountCoa);
                                                                                                    sesReport.setStrAmount("" + amountCoa);
                                                                                                    sesReport.setAmountPrevYear(amountCoa_lastYear);
                                                                                                    sesReport.setStrAmountPrevYear("" + amountCoa_lastYear);
                                                                                                    sesReport.setFont(0);
                                                                                                    listReport.add(sesReport);
                                                                                                    
                                                                                                    double persen = 0;
                                                                                                    double persenAnggaran = 0;
                                                                                                    
                                                                                                    if(amountCoa_lastYear != 0){
                                                                                                        persen = (amountCoa/amountCoa_lastYear)*100;
                                                                                                    }
                                                                                                    
                                                                                                    if(anggaran != 0){
                                                                                                        persenAnggaran = (amountCoa/anggaran)*100;
                                                                                                    }
                                                                                                    
                                                                            %>
                                                                            
                                                                            
                                                                            <tr>                                                                                
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + strCoa + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>                                                                                
                                                                            </tr>
                                                                            <%
                                                                                                                                                                            }

                                                                                                                                                                        } else {

                                                                                                                                                                            if ((coa.getStatus().equals("HEADER")) || ((coa.getStatus().equals("HEADER")) && amountCoa != 0)) {	//add detail

                                                                                                                                                                                sesReport = new SesReportBs();
                                                                                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                                                                                sesReport.setDescription(strTotal1 + strTotal1 + strCoa1 + coa.getCode() + " - " + coa.getName());
                                                                                                                                                                                sesReport.setAmount(amountCoa);
                                                                                                                                                                                sesReport.setStrAmount("" + amountCoa);
                                                                                                                                                                                sesReport.setAmountPrevYear(amountCoa_lastYear);
                                                                                                                                                                                sesReport.setStrAmountPrevYear("" + amountCoa_lastYear);
                                                                                                                                                                                sesReport.setFont(0);
                                                                                                                                                                                listReport.add(sesReport);
                                                                                                                                                                                
                                                                                                                                                                                double persen = 0;
                                                                                                                                                                                double persenAnggaran = 0;
                                                                                                                                                                                
                                                                                                                                                                                if(amountCoa_lastYear != 0){
                                                                                                                                                                                    persen = (amountCoa/amountCoa_lastYear)*100;
                                                                                                                                                                                }
                                                                                                                                                                                
                                                                                                                                                                                if(amountCoa_lastYear != 0){
                                                                                                                                                                                    persenAnggaran = (amountCoa/anggaran)*100;
                                                                                                                                                                                }

                                                                            %>    
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + strCoa + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>                                                                            
                                                                            <%
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
                                                                                        
                                                                                        
                                                                                                                                                                    if (coaSummary3_lastYear < 0) {
                                                                                                                                                                        displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary3_lastYear * -1, "#,###.##") + ")";
                                                                                                                                                                    } else if (coaSummary3_lastYear > 0) {
                                                                                                                                                                        displayStr_lastYear = JSPFormater.formatNumber(coaSummary3_lastYear, "#,###.##");
                                                                                                                                                                    } else if (coaSummary3_lastYear == 0) {
                                                                                                                                                                        displayStr_lastYear = "";
                                                                                                                                                                    }

                                                                                                                                                                }
                                                                                    
                                                                                                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_OTHER_ASSET, "DC") != 0 || valShowList != 1) {	//add Group Footer
                                                                                                                                                                    sesReport = new SesReportBs();
                                                                                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                                                                                    sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_OTHER_ASSET);
                                                                                                                                                                    sesReport.setAmount(coaSummary3);
                                                                                                                                                                    sesReport.setStrAmount("" + coaSummary3);
                                                                                                                                                                    sesReport.setAmountPrevYear(coaSummary3_lastYear);
                                                                                                                                                                    sesReport.setStrAmountPrevYear("" + coaSummary3_lastYear);
                                                                                                                                                                    sesReport.setFont(1);
                                                                                                                                                                    listReport.add(sesReport);
                                                                                                                                                                    
                                                                                                                                                                    double persen = 0;
                                                                                                                                                                    double persenAnggaran = 0;
                                                                                                                                                                    
                                                                                                                                                                    if(coaSummary3_lastYear != 0){
                                                                                                                                                                        persen = ( coaSummary3 / coaSummary3_lastYear ) * 100;
                                                                                                                                                                    }
                                                                                                                                                                    if(anggaranSummary3 != 0){
                                                                                                                                                                        persenAnggaran = ( coaSummary3 / anggaranSummary3 ) * 100;
                                                                                                                                                                    }
                                                                            %>  
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b><%=strTotal + "Sub Total " + I_Project.ACC_GROUP_OTHER_ASSET%></b></span></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=anggaranSummary3%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=displayStr%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=persen%></b></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><b><%=persenAnggaran%></b></div></td>
                                                                            </tr>    
                                                                            <%
                                                                                    }
                                                                                }

                                                                                totalAktiva = coaSummary1 + coaSummary2 + coaSummary3;
                                                                                totalAktiva_lastYear = coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear;

                                                                                if (coaSummary1 + coaSummary2 + coaSummary3 < 0) {
                                                                                    displayStr = "(" + JSPFormater.formatNumber((coaSummary1 + coaSummary2 + coaSummary3) * -1, "#,###.##") + ")";
                                                                                } else if (coaSummary1 + coaSummary2 + coaSummary3 > 0) {
                                                                                    displayStr = JSPFormater.formatNumber((coaSummary1 + coaSummary2 + coaSummary3), "#,###.##");
                                                                                } else if (coaSummary1 + coaSummary2 + coaSummary3 == 0) {
                                                                                    displayStr = "";
                                                                                }
                                                                                
                                                                                if (coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear < 0) {
                                                                                    displayStr_lastYear = "(" + JSPFormater.formatNumber((coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear) * -1, "#,###.##") + ")";
                                                                                } else if (coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear > 0) {
                                                                                    displayStr_lastYear = JSPFormater.formatNumber((coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear), "#,###.##");
                                                                                } else if (coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear == 0) {
                                                                                    displayStr_lastYear = "";
                                                                                }
                                                                                
//add footer level
                                                                                if (coaSummary1 + coaSummary2 + coaSummary3 != 0 || coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear != 0 || valShowList != 1) {	//add Group Footer
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Footer Top Level");
                                                                                    sesReport.setDescription("Total Activa");
                                                                                    sesReport.setAmount(coaSummary1 + coaSummary2 + coaSummary3);
                                                                                    sesReport.setStrAmount("" + (coaSummary1 + coaSummary2 + coaSummary3));
                                                                                    sesReport.setAmountPrevYear(coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear);
                                                                                    sesReport.setStrAmountPrevYear("" + (coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear));
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);
                                                                                    
                                                                                    double totAnggaran = anggaranSummary1 + anggaranSummary2 + anggaranSummary3;
                                                                                    
                                                                                    double persen = ((coaSummary1 + coaSummary2 + coaSummary3)/(coaSummary1_lastYear + coaSummary2_lastYear + coaSummary3_lastYear))*100;
                                                                                    double persenAnggaran = ((coaSummary1 + coaSummary2 + coaSummary3)/(totAnggaran))*100;
                                                                            %>
                                                                            <tr> 
                                                                                <td class="tablecell2" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b>Total Activa</b></span></td>
                                                                                <td class="tablecell2"><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                                <td class="tablecell2"><div align="right"><b><%=totAnggaran%></b></div></td>
                                                                                <td class="tablecell2"><div align="right"><b><%=displayStr%></b></div></td>
                                                                                <td class="tablecell2"><div align="right"><b><%=persen%></b></div></td>
                                                                                <td class="tablecell2"><div align="right"><b><%=persenAnggaran%></b></div></td>
                                                                            </tr>  
                                                                            <%
                                                                                }
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Space");
                                                                                sesReport.setDescription("");
                                                                                listReport.add(sesReport);
                                                                            %>
                                                                            <tr> 
                                                                                <td height="15" colspan="5">&nbsp;</td>
                                                                            </tr>
                                                                            <!--level 2-->
                                                                            <tr> 
                                                                                <td class="tablecell" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <b>Liabilities</b></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr> 
                                                                            <%	//add Top Header
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Top Level");
                                                                                sesReport.setDescription("Liabilities");
                                                                                sesReport.setFont(1);
                                                                                listReport.add(sesReport);

                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_CURRENT_LIABILITIES, "CD") != 0 || valShowList != 1) {	//add Group Header
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_CURRENT_LIABILITIES);
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);
                                                                            %>
                                                                            <tr> 
                                                                                <td class="tablecel1" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <b><%=strTotal + I_Project.ACC_GROUP_CURRENT_LIABILITIES%></b></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell2">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>    							
                                                                            <%	}%>
                                                                            
                                                                            <%

                                                                                if (listCoa != null && listCoa.size() > 0) {

                                                                                    coaSummary4 = 0;
                                                                                    coaSummary4_lastYear = 0;
                                                                                    anggaranSummary4 = 0;
                                                                                    String str = "";
                                                                                    String str1 = "";

                                                                                    for (int i = 0; i < listCoa.size(); i++) {

                                                                                        coa = (Coa) listCoa.get(i);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_CURRENT_LIABILITIES)) {
                                                                                            str = switchLevel(coa.getLevel());
                                                                                            str1 = switchLevel1(coa.getLevel());
                                                                                            
                                                                                            double amount = 0;
                                                                                            double amount_lastYear = 0;
                                                                                            double anggaran = 0;
                                                                                            
                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                amount = DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD");
                                                                                                amount_lastYear = DbCoa.getCoaBalanceByHeaderLastYear(coa.getOID(), "CD");
                                                                                                anggaran = DbCoa.getCoaBudget(coa.getOID());
                                                                                            }

                                                                                            coaSummary4 = coaSummary4 + amount;
                                                                                            coaSummary4_lastYear = coaSummary4_lastYear + amount_lastYear;
                                                                                            anggaranSummary4 = anggaranSummary4 + anggaran;
                                                                                            
                                                                                            displayStr = strDisplay(amount, coa.getStatus());
                                                                                            displayStr_lastYear = strDisplay(amount_lastYear, coa.getStatus());

                                                                                            if (valShowList == 1) {
                                                                                                
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD") != 0) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setAmount(amount);
                                                                                                    sesReport.setStrAmount("" + amount);
                                                                                                    sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                                                                                    sesReport.setAmountPrevYear(amount_lastYear);                                                                                                    
                                                                                                    sesReport.setFont(0);
                                                                                                    listReport.add(sesReport);
                                                                                                    
                                                                                                    double persen = 0;
                                                                                                    double persenAnggaran = 0;
                                                                                                    
                                                                                                    if(amount_lastYear != 0){
                                                                                                        persen = (amount/amount_lastYear)*100;
                                                                                                    }
                                                                                                    
                                                                                                    if(anggaran != 0){
                                                                                                        persenAnggaran = (amount/anggaran)*100;
                                                                                                    }
                                                                            %>
                                                                            
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>
                                                                            
                                                                            <%				}
                                                                                                                                                                        } else {
                                                                                                                                                                            if ((coa.getStatus().equals("HEADER")) || ((!coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                                                                                                sesReport = new SesReportBs();
                                                                                                                                                                                sesReport.setType(coa.getStatus());
                                                                                                                                                                                sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                                                                                                sesReport.setAmount(amount);
                                                                                                                                                                                sesReport.setStrAmount("" + amount);
                                                                                                                                                                                sesReport.setAmountPrevYear(amount_lastYear);
                                                                                                                                                                                sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                                                                                                                                                                sesReport.setFont(0);
                                                                                                                                                                                listReport.add(sesReport);
                                                                                                                                                                                
                                                                                                                                                                                double persen = 0;
                                                                                                                                                                                double persenAnggaran = 0;
                                                                                                                                                                                
                                                                                                                                                                                if(amount_lastYear != 0){
                                                                                                                                                                                    persen = (amount/amount_lastYear)*100;
                                                                                                                                                                                }
                                                                                                                                                                                
                                                                                                                                                                                if(anggaran != 0){
                                                                                                                                                                                    persenAnggaran = (amount/anggaran)*100;
                                                                                                                                                                                }
                                                                            %>
                                                                            
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>
                                                                            <%					}
                                                                                                                                                                        }
                                                                                                                                                                    }
                                                                                                                                                                    if (coaSummary4 < 0) {
                                                                                                                                                                        displayStr = "(" + JSPFormater.formatNumber(coaSummary4 * -1, "#,###.##") + ")";
                                                                                                                                                                    } else if (coaSummary4 < 0) {
                                                                                                                                                                        displayStr = JSPFormater.formatNumber(coaSummary4, "#,###.##");
                                                                                                                                                                    } else if (coaSummary4 == 0) {
                                                                                                                                                                        displayStr = "";
                                                                                                                                                                    }
                                                                                        
                                                                                                                                                                    if (coaSummary4_lastYear < 0) {
                                                                                                                                                                        displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary4_lastYear * -1, "#,###.##") + ")";
                                                                                                                                                                    } else if (coaSummary4_lastYear < 0) {
                                                                                                                                                                        displayStr_lastYear = JSPFormater.formatNumber(coaSummary4_lastYear, "#,###.##");
                                                                                                                                                                    } else if (coaSummary4_lastYear == 0) {
                                                                                                                                                                        displayStr_lastYear = "";
                                                                                                                                                                    }
                                                                                        
                                                                                                                                                                }				//add footer level
                                                                                                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_CURRENT_LIABILITIES, "CD") != 0 || valShowList != 1) {	//add Group Footer
                                                                                                                                                                    sesReport = new SesReportBs();
                                                                                                                                                                    sesReport.setType("Footer Group Level");
                                                                                                                                                                    sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_CURRENT_LIABILITIES);
                                                                                                                                                                    sesReport.setAmount(coaSummary4);
                                                                                                                                                                    sesReport.setStrAmount("" + coaSummary4);
                                                                                                                                                                    sesReport.setAmountPrevYear(coaSummary4_lastYear);
                                                                                                                                                                    sesReport.setStrAmountPrevYear("" + coaSummary4_lastYear);
                                                                                                                                                                    sesReport.setFont(1);
                                                                                                                                                                    listReport.add(sesReport);
                                                                                                                                                                    
                                                                                                                                                                    double persen = 0;
                                                                                                                                                                    double persenAnggaran = 0;
                                                                                                                                                                    
                                                                                                                                                                    if(coaSummary4_lastYear != 0){
                                                                                                                                                                        persen = (coaSummary4 / coaSummary4_lastYear)*100;
                                                                                                                                                                    }
                                                                                                                                                                    
                                                                                                                                                                    if(anggaranSummary4 != 0){
                                                                                                                                                                        persenAnggaran = (coaSummary4 / anggaranSummary4)*100;
                                                                                                                                                                    }
                                                                            %>
                                                                            
                                                                            <tr> 
                                                                                <td class="tablecell2" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_CURRENT_LIABILITIES%></b></span></td>
                                                                                <td class="tablecell2"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="tablecell2"><div align="right"><%=anggaranSummary4%></div></td>
                                                                                <td class="tablecell2"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="tablecell2"><div align="right"><%=persen%></div></td>
                                                                                <td class="tablecell2"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>
                                                                            <%
                                                                                    }
                                                                                }
                                                                            %>
                                                                            <!--level Long term liabilities-->
                                                                            <%
                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES, "CD") != 0 || valShowList != 1) {	//add Group Header
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Group Level");
                                                                                    sesReport.setDescription(strTotal1 + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);
                                                                            %>
                                                                            
                                                                            <tr> 
                                                                                <td class="tablecell" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <b><%=strTotal + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></b></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell2">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>
                                                                            <%	}%>	
                                                                            <%
                                                                                if (listCoa != null && listCoa.size() > 0) {
                                                                                    
                                                                                    coaSummary5 = 0;
                                                                                    coaSummary5_lastYear = 0;
                                                                                    coaSummary5 = 0;
                                                                                    
                                                                                    String str = "";
                                                                                    String str1 = "";
                                                                                    
                                                                                    for (int i = 0; i < listCoa.size(); i++) {
                                                                                        coa = (Coa) listCoa.get(i);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES)) {
                                                                                            str = switchLevel(coa.getLevel());
                                                                                            str1 = switchLevel1(coa.getLevel());
                                                                                            double amount = 0;
                                                                                            double amount_lastYear = 0;
                                                                                            double anggaran = 0;
                                                                                            
                                                                                            if (coa.getStatus().equals("HEADER")) {
                                                                                                amount = DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD");
                                                                                                amount_lastYear = DbCoa.getCoaBalanceByHeaderLastYear(coa.getOID(), "CD");
                                                                                                anggaran = DbCoa.getCoaBudget(coa.getOID());
                                                                                            }

                                                                                            coaSummary5 = coaSummary5 + amount;
                                                                                            coaSummary5_lastYear = coaSummary5_lastYear + amount_lastYear;
                                                                                            anggaranSummary5 = anggaranSummary5 + anggaran;
                                                                                            
                                                                                            displayStr = strDisplay(amount, coa.getStatus());
                                                                                            
                                                                                            if (valShowList == 1) {
                                                                                                
                                                                                                if ((coa.getStatus().equals("HEADER") && DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD") != 0) || ((coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setAmount(amount);
                                                                                                    sesReport.setStrAmount("" + amount);
                                                                                                    
                                                                                                    sesReport.setAmountPrevYear(amount_lastYear);
                                                                                                    sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                                                                                    
                                                                                                    sesReport.setFont(0);
                                                                                                    listReport.add(sesReport);
                                                                                                    
                                                                                                    double persen = 0;
                                                                                                    double persenAnggaran = 0;
                                                                                                    
                                                                                                    if(amount_lastYear != 0){
                                                                                                        persen = (amount/amount_lastYear) * 100;
                                                                                                    }
                                                                                                    
                                                                                                    if(anggaran != 0){
                                                                                                        persenAnggaran = (amount/anggaran) * 100;
                                                                                                    }
                                                                                                    
                                                                                                    
                                                                            %>
                                                                            
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>
                                                                           
                                                                            <%				}
                                                                                        } else {
                                                                                            if ((coa.getStatus().equals("HEADER")) || ((coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                sesReport = new SesReportBs();
                                                                                                sesReport.setType(coa.getStatus());
                                                                                                sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                sesReport.setAmount(amount);
                                                                                                sesReport.setStrAmount("" + amount);
                                                                                                sesReport.setAmountPrevYear(amount_lastYear);
                                                                                                sesReport.setStrAmountPrevYear("" + amount_lastYear);
                                                                                                sesReport.setFont(0);
                                                                                                listReport.add(sesReport);
                                                                                                
                                                                                                double persen = 0;
                                                                                                double persenAnggaran = 0;
                                                                                                
                                                                                                if(amount_lastYear != 0){
                                                                                                    persen = (amount / amount_lastYear)*100;
                                                                                                }
                                                                                                
                                                                                                if(anggaran != 0){
                                                                                                    persenAnggaran = (amount / anggaran)*100;
                                                                                                }
                                                                            %>                                                                                        
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=anggaran%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persen%></div></td>
                                                                                <td class="<%=cssString%>"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>
                                                                            <%					}
                                                                                        }
                                                                                    }
                                                                                    if (coaSummary5 < 0) {
                                                                                        displayStr = "(" + JSPFormater.formatNumber(coaSummary5 * -1, "#,###.##") + ")";
                                                                                    } else if (coaSummary5 > 0) {
                                                                                        displayStr = JSPFormater.formatNumber(coaSummary5, "#,###.##");
                                                                                    } else if (coaSummary5 == 0) {
                                                                                        displayStr = "";
                                                                                    }
                                                                                        
                                                                                    if (coaSummary5_lastYear < 0) {
                                                                                        displayStr_lastYear = "(" + JSPFormater.formatNumber(coaSummary5_lastYear * -1, "#,###.##") + ")";
                                                                                    } else if (coaSummary5_lastYear > 0) {
                                                                                        displayStr_lastYear = JSPFormater.formatNumber(coaSummary5_lastYear, "#,###.##");
                                                                                    } else if (coaSummary5_lastYear == 0) {
                                                                                        displayStr_lastYear = "";
                                                                                    }   
                                                                                }	
                                                                                    		//add footer level
                                                                                if (DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_LONG_TERM_LIABILITIES, "CD") != 0 || valShowList != 1) {	//add Group Footer
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Footer Group Level");
                                                                                    sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES);
                                                                                    sesReport.setAmount(coaSummary5);
                                                                                    sesReport.setStrAmount("" + coaSummary5);
                                                                                    sesReport.setAmountPrevYear(coaSummary5_lastYear);
                                                                                    sesReport.setStrAmountPrevYear("" + coaSummary5_lastYear);
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);
                                                                                    
                                                                                    double persen = 0;
                                                                                    double persenAnggaran = 0;
                                                                                    
                                                                                    if(coaSummary5_lastYear != 0){
                                                                                        persen = (coaSummary5/coaSummary5_lastYear)*100;                                                                                           
                                                                                    }
                                                                                    
                                                                                    if(anggaranSummary5 != 0){
                                                                                        persenAnggaran = (coaSummary5/anggaranSummary5) * 100;                                                                                        
                                                                                    }
                                                                            %>
                                                                            
                                                                            <tr> 
                                                                                <td class="tablecell2" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_LONG_TERM_LIABILITIES%></b></span></td>
                                                                                <td class="tablecell"><div align="right"><%=displayStr_lastYear%></div></td>
                                                                                <td class="tablecell"><div align="right"><%=anggaranSummary5%></div></td>
                                                                                <td class="tablecell2"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="tablecell"><div align="right"><%=persen%></div></td>
                                                                                <td class="tablecell"><div align="right"><%=persenAnggaran%></div></td>
                                                                            </tr>                                                                                        
                                                                            <%
                                                                                    }

                                                                                }

                                                                                if (coaSummary4 + coaSummary5 < 0) {
                                                                                    displayStr = "(" + JSPFormater.formatNumber((coaSummary4 + coaSummary5) * -1, "#,###.##") + ")";
                                                                                } else if (coaSummary4 + coaSummary5 > 0) {
                                                                                    displayStr = JSPFormater.formatNumber(coaSummary4 + coaSummary5, "#,###.##");
                                                                                } else if (coaSummary4 + coaSummary5 == 0) {
                                                                                    displayStr = "";
                                                                                }
                                                                                
                                                                                if (coaSummary4_lastYear + coaSummary5_lastYear < 0) {
                                                                                    displayStr_lastYear = "(" + JSPFormater.formatNumber((coaSummary4_lastYear + coaSummary5_lastYear) * -1, "#,###.##") + ")";
                                                                                } else if (coaSummary4_lastYear + coaSummary5_lastYear > 0) {
                                                                                    displayStr_lastYear = JSPFormater.formatNumber(coaSummary4_lastYear + coaSummary5_lastYear, "#,###.##");
                                                                                } else if (coaSummary4_lastYear + coaSummary5_lastYear == 0) {
                                                                                    displayStr_lastYear = "";
                                                                                }
                                                                                
//add footer level
                                                                                if (coaSummary4 + coaSummary5 != 0 || valShowList != 1) {	//add Group Footer
                                                                                    
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Footer Top Level");
                                                                                    sesReport.setDescription("Total Liabilities");
                                                                                    sesReport.setAmount(coaSummary4 + coaSummary5);
                                                                                    sesReport.setStrAmount("" + (coaSummary4 + coaSummary5));
                                                                                    sesReport.setAmountPrevYear(coaSummary4_lastYear + coaSummary5_lastYear);
                                                                                    sesReport.setStrAmountPrevYear("" + (coaSummary4_lastYear + coaSummary5_lastYear));
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);
                                                                                    
                                                                                    double totalAnggaran = anggaranSummary4 + anggaranSummary5;
                                                                                    
                                                                                    double persen = 0;
                                                                                    double persenAnggaran = 0;
                                                                                    
                                                                                    double totalSum = coaSummary4 + coaSummary5;
                                                                                    double totalSum_lastYear = coaSummary4_lastYear + coaSummary5_lastYear;
                                                                                    
                                                                                    if(totalSum_lastYear != 0){
                                                                                        persen = (totalSum/totalSum_lastYear)*100;
                                                                                    }
                                                                                    
                                                                                    if(totalAnggaran != 0){
                                                                                        persenAnggaran = (totalSum/totalAnggaran)*100;
                                                                                    }
                                                                                    
                                                                            %>
                                                                            


                                                                            <tr> 
                                                                                <td class="tablecell2" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b>Total Liabilities</b></span></td>
                                                                                <td class="tablecel12"><div align="right"><b><%=displayStr_lastYear%></b></div></td>
                                                                                <td class="tablecel12"><div align="right"><b><%=totalAnggaran%></b></div></td>
                                                                                <td class="tablecell2"><div align="right"><b><%=displayStr%></b></div></td>
                                                                                <td class="tablecel12"><div align="right"><b><%=persenAnggaran%></b></div></td>
                                                                                <td class="tablecell2">&nbsp;</td>
                                                                            </tr>
                                                                            <%
                                                                                }
                                                                            %>
                                                                            <!--level 3-->
                                                                            <tr> 
                                                                                <td class="tablecell" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <b>Equity</b></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>
                                                                            <!--level equity-->
                <%
                                                                                if (listCoa != null && listCoa.size() > 0) {

                                                                                    coaSummary6 = 0;
                                                                                    String str = "";
                                                                                    String str1 = "";
                                                                                    for (int i = 0; i < listCoa.size(); i++) {
                                                                                        coa = (Coa) listCoa.get(i);

                                                                                        if (coa.getAccountGroup().equals(I_Project.ACC_GROUP_EQUITY)) {
                                                                                            str = switchLevel(coa.getLevel());
                                                                                            str1 = switchLevel1(coa.getLevel());
                                                                                            double amount = 0;//DbCoa.getCoaBalanceCD(coa.getOID());
                                                                                            if (coa.getStatus().equals("HEADER") && !coa.getCode().equals(DbSystemProperty.getValueByName("ID_HEADER_RETAINED_EARNING"))) {
                                                                                                amount = DbCoa.getCoaBalanceByHeader(coa.getOID(), "DC");
                                                                                            }
                                                                                            //out.println(amount);

                                                                                            //Retained Earnings
                                                                                            if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS"))) {
                                                                                                //ID_RETAINED_EARNINGS
                                                                                                double totalIncome = 0;
                                                                                                Coa coax = new Coa();
                                                                                                for (int ix = 0; ix < listCoa.size(); ix++) {
                                                                                                    coax = (Coa) listCoa.get(ix);
                                                                                                    if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_REVENUE)) {
                                                                                                        totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                                                                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_COST_OF_SALES)) {
                                                                                                        totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                                                                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_EXPENSE)) {
                                                                                                        totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                                                                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_REVENUE)) {
                                                                                                        totalIncome = totalIncome + DbCoa.getCoaBalanceCD(coax.getOID());
                                                                                                    } else if (coax.getAccountGroup().equals(I_Project.ACC_GROUP_OTHER_EXPENSE)) {
                                                                                                        totalIncome = totalIncome - DbCoa.getCoaBalance(coax.getOID());
                                                                                                    }
                                                                                                }
                                                                                                amount = totalIncome;

                                                                                            }

                                                                                            if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_BEGINING_BALANCE"))) {
                                                                                                amount = DbCoa.getCoaBalance(coa.getOID());//getSumOpeningBalance();										
                                                                                            }


                                                                                            coaSummary6 = coaSummary6 + amount;

                                                                                            displayStr = strDisplay(amount, coa.getStatus());
                                                                                            if (valShowList == 1) {
                                                                                                if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) || (coa.getStatus().equals("HEADER") && (DbCoa.getCoaBalanceByHeader(coa.getOID(), "CD")) != 0) || ((coa.getStatus().equals("HEADER")) && amount != 0)) //if ((coa.getStatus().equals("HEADER") && (DbCoa.getCoaBalanceByHeader(coa.getOID(),"CD"))!=0) || ((coa.getStatus().equals("HEADER")) && amount!=0))
                                                                                                {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setAmount(amount);
                                                                                                    sesReport.setStrAmount("" + amount);
                                                                                                    //sesReport.setFont(coa.getStatus().equals("HEADER") ? 1 : 0);											
                                                                                                    sesReport.setFont(0);
                                                                                                    listReport.add(sesReport);
                                                                                        %>
                                                                                        
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="<%=cssString%>" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>
                                                                            
                                                                            <%				}
                                                                                            } else {
                                                                                                if (coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNING")) || coa.getCode().equals(DbSystemProperty.getValueByName("ID_RETAINED_EARNINGS")) || (coa.getStatus().equals("HEADER")) || ((coa.getStatus().equals("HEADER")) && amount != 0)) {	//add detail
                                                                                                    sesReport = new SesReportBs();
                                                                                                    sesReport.setType(coa.getStatus());
                                                                                                    sesReport.setDescription(strTotal1 + strTotal1 + str1 + coa.getCode() + " - " + coa.getName());
                                                                                                    sesReport.setAmount(amount);
                                                                                                    sesReport.setStrAmount("" + amount);
                                                                                                    sesReport.setFont(0);
                                                                                                    listReport.add(sesReport);
                                                                            %>
                                                                            <tr> 
                                                                                <td class="<%=cssString%>" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <%=strTotal + strTotal + str + coa.getCode() + " - " + coa.getName()%></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="<%=cssString%>" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;"><div align="right"><%=displayStr%></div></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>
                                                                            
                                                                            <%					}
                                                                                            }
                                                                                        }
                                                                                        if (coaSummary6 < 0) {
                                                                                            displayStr = "(" + JSPFormater.formatNumber(coaSummary6 * -1, "#,###.##") + ")";
                                                                                        } else if (coaSummary6 > 0) {
                                                                                            displayStr = JSPFormater.formatNumber(coaSummary6, "#,###.##");
                                                                                        } else if (coaSummary6 == 0) {
                                                                                            displayStr = "";
                                                                                        }
                                                                                    }				//add footer level
                                                                                    if ((DbCoa.getCoaBalanceByGroup(I_Project.ACC_GROUP_EQUITY, "CD") != 0 + DbCoaOpeningBalance.getSumOpeningBalance()) || valShowList != 1) {	//add Group Footer
                                                                                        sesReport = new SesReportBs();
                                                                                        sesReport.setType("Footer Group Level");
                                                                                        sesReport.setDescription(strTotal1 + "Sub Total " + I_Project.ACC_GROUP_EQUITY);
                                                                                        sesReport.setAmount(coaSummary6);
                                                                                        sesReport.setStrAmount("" + coaSummary6);
                                                                                        sesReport.setFont(1);
                                                                                        listReport.add(sesReport);
                                                                            %>
                                                                            
                                                                            <tr> 
                                                                                <td class="tablecell2" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b><%=strTotal + " Sub Total " + I_Project.ACC_GROUP_EQUITY%></b></span></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell2" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;"><div align="right"><b><%=displayStr%></b></div></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>
                                                                            <%
                                                                                    }
                                                                                }

                                                                                if (coaSummary6 < 0) {
                                                                                    displayStr = "(" + JSPFormater.formatNumber((coaSummary6) * -1, "#,###.##") + ")";
                                                                                } else if (coaSummary6 < 0) {
                                                                                    displayStr = JSPFormater.formatNumber(coaSummary6, "#,###.##");
                                                                                } else if (coaSummary6 == 0) {
                                                                                    displayStr = "";
                                                                                }

                                                                                //add footer level
                                                                                if (coaSummary6 != 0 || valShowList != 1) {	//add Group Footer
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Footer Top Level");
                                                                                    sesReport.setDescription("Total Equity");
                                                                                    sesReport.setAmount(coaSummary6);
                                                                                    sesReport.setStrAmount("" + coaSummary6);
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);

                                                                            %>
                                                                            <tr> 
                                                                                <td class="tablecell2" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b>Total Equity</b></span></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell2" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;"><div align="right"><b><%=displayStr%></b></div></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>
                                                                            
                                                                            <%}


                                                                                totalPasiva = coaSummary4 + coaSummary5 + coaSummary6;

                                                                                //out.println("totalPasiva : "+totalPasiva);

                                                                                if (coaSummary4 + coaSummary5 + coaSummary6 < 0) {
                                                                                    displayStr = "(" + JSPFormater.formatNumber((coaSummary4 + coaSummary5 + coaSummary6) * -1, "#,###.##") + ")";
                                                                                } else if (coaSummary4 + coaSummary5 + coaSummary6 > 0) {
                                                                                    displayStr = JSPFormater.formatNumber((coaSummary4 + coaSummary5 + coaSummary6), "#,###.##");
                                                                                } else if (coaSummary4 + coaSummary5 + coaSummary6 == 0) {
                                                                                    displayStr = "";
                                                                                }
                                                                                //add footer level
                                                                                if (coaSummary6 != 0 || valShowList != 1) {	//add Group Footer
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Footer Top Level");
                                                                                    sesReport.setDescription("Total Liabilities & Equity");
                                                                                    sesReport.setAmount(coaSummary4 + coaSummary5 + coaSummary6);
                                                                                    sesReport.setStrAmount("" + (coaSummary4 + coaSummary5 + coaSummary6));
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);
                                                                            %>
                                                                            <tr> 
                                                                                <td class="tablecell2" nowrap style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">
                                                                                <span class="level2"><b>Total Liabilities & Equity</b></span></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell2" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;"><span class="level2"><div align="right"><b><%=displayStr%></b></div></span></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>
                                                                            <%
                                                                                }
                                                                                sesReport = new SesReportBs();
                                                                                sesReport.setType("Space");
                                                                                sesReport.setDescription("");
                                                                                listReport.add(sesReport);
                                                                            %>
                                                                            <tr>
                                                                                <td colspan="6" class="tablecell1" height="15"></td>
                                                                            </tr>
                                                                            <%

                                                                                totalAktiva = Double.parseDouble(JSPFormater.formatNumber(totalAktiva, "###.##"));
                                                                                totalPasiva = Double.parseDouble(JSPFormater.formatNumber(totalPasiva, "###.##"));

                                                                                if (totalAktiva - totalPasiva < 0) {
                                                                                    displayStr = "(" + JSPFormater.formatNumber((totalAktiva - totalPasiva) * -1, "#,###.##") + ")";
                                                                                } else if (totalAktiva - totalPasiva > 0) {
                                                                                    displayStr = JSPFormater.formatNumber(totalAktiva - totalPasiva, "#,###.##");
                                                                                } else if ((totalAktiva - totalPasiva) == 0) {
                                                                                    displayStr = "-";
                                                                                }

                                                                                //add footer level
                                                                                if (coaSummary4 + coaSummary5 != 0 || valShowList != 1) {	//add Group Footer
                                                                                    sesReport = new SesReportBs();
                                                                                    sesReport.setType("Footer Top Level");
                                                                                    sesReport.setDescription(strTotal1 + "");
                                                                                    sesReport.setAmount((coaSummary1 + coaSummary2 + coaSummary3) - (coaSummary4 + coaSummary5 + coaSummary6));
                                                                                    sesReport.setStrAmount("" + ((coaSummary1 + coaSummary2 + coaSummary3) - (coaSummary4 + coaSummary5 + coaSummary6)));
                                                                                    sesReport.setFont(1);
                                                                                    listReport.add(sesReport);
                                                                            %>                                                                            
                                                                            <tr> 
                                                                                <td class="tablecell2">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell2" style="font-family:Arial, Helvetica, sans-serif; font-size:12px;"><div align="right"><b><font color="red"><%=displayStr%></font></b></div></td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                                <td class="tablecell">&nbsp;</td>
                                                                            </tr>
                                                                            <%
                                                                                }

                                                                            %>
                                                                            <tr> 
                                                                                <td colspan="6" height="15"></td>
                                                                            </tr>
                                                                            <%
                                                                                session.putValue("BS_STANDARD", listReport);
                                                                            %>
                                                                            
                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="6">&nbsp; </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="6" class="container"> 
                                                                                    <%if ((listCoa != null && listCoa.size() > 0) || true) {%>
                                                                                    <table width="200" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td width="60"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"></a></td>
                                                                                            <td width="0">&nbsp;</td>
                                                                                            <td width="120"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printxls','','../images/printxls2.gif',1)"></a></td>
                                                                                            <td width="20">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                <%}%>                                                                    </td>
                                                                            </tr>
                                                                            <%
            } // End tag untuk yang show List
                                                                            %>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                
                                                            </table>
                                                        </form>
                                                    <!-- #EndEditable -->                                                    </td>
                                                </tr>
                                                
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                        </table>                                        </td>
                                    </tr>
                            </table>                            </td>
                        </tr>
                        <tr> 
                            <td height="25"> 
                                <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable -->                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>

