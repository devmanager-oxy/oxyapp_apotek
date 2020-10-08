
<%-- 
    Document   : budgetreport
    Created on : Apr 10, 2016, 4:23:57 PM
    Author     : Ang
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT_BUDGET);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_FIN_REP, AppMenu.M2_MN_REPORT_BUDGET, AppMenu.PRIV_VIEW);
%>

<%!
    public static double getRequestPeriod(long coaId, long periodeId, long segment1Id) {
        CONResultSet dbrs1 = null;
        double total=0;
        String whereSegment="";
        String wherePeriod="";
        
        if (periodeId !=0) {
            wherePeriod=" AND br.periode_id='"+ periodeId +"'";
        }
        
        if (segment1Id != 0) {
            whereSegment = " AND br.segment1_id='" + segment1Id + "'";
        }
        
        try {
            String sqlBudget ="SELECT SUM(brd.request) AS tot FROM budget_request br INNER JOIN budget_request_detail brd ON br.budget_request_id=brd.budget_request_id "
                    + " WHERE br.status not in ('3','4') AND brd.coa_id='"+ coaId +"'" + wherePeriod + whereSegment;
        
            dbrs1 = CONHandler.execQueryResult(sqlBudget);
            ResultSet rs1 = dbrs1.getResultSet();
            
            while (rs1.next()) {
                total  = rs1.getDouble("tot");
            }
            return total;
        }catch(Exception ex){
            return 0;
        } finally {
            CONResultSet.close(dbrs1);
        }
        
    }


    public static double getAmount(long coaId, long periodeId, Date startDate, Date endDate, long segment1Id) {
        CONResultSet dbrs = null;

        try {
            Periode p = DbPeriode.fetchExc(periodeId);
            String tahun = JSPFormater.formatDate(p.getStartDate(), "yyyy").toString();
            String bulan = JSPFormater.formatDate(p.getStartDate(), "MM").toString();
            String whereSegment = "";
            if (segment1Id != 0) {
                whereSegment = "AND gd.segment1_id='" + segment1Id + "'";
            }

            String sqlGL = "SELECT coa.saldo_normal, SUM(gd.debet-gd.credit) AS tot FROM gl INNER JOIN gl_detail gd ON gl.gl_id=gd.gl_id INNER JOIN coa ON gd.coa_id=coa.coa_id"
                    + " WHERE gl.posted_status='1' AND gd.coa_id='" + coaId + "' " + whereSegment + "  and gl.period_id='"+ periodeId +"' and (to_days(gl.trans_date) between to_days('"+ JSPFormater.formatDate(startDate, "yyyy-MM-dd") +"') and to_days('"+ JSPFormater.formatDate(endDate, "yyyy-MM-dd") +"')) group by coa.coa_id";//AND YEAR(gl.trans_date)='" + tahun + "' and month(gl.trans_date)='" + bulan + "'";
            //System.out.println("sqlGL : " + sqlGL);
            dbrs = CONHandler.execQueryResult(sqlGL);
            ResultSet rs = dbrs.getResultSet();

            double totalGl = 0;
            while (rs.next()) {
                totalGl = rs.getDouble("tot");
                if (rs.getString("saldo_normal").equalsIgnoreCase("Credit")) {
                    totalGl = rs.getDouble("tot") * -1;
                }
                if (rs.getDouble("tot")==0){
                    totalGl=0;
                }
            }
            rs.close();
            return totalGl;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }
%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            String grpType = JSPRequestValue.requestString(request, "groupType");
            String[] a = request.getParameterValues("segment1_id");
            long segment1Id = JSPRequestValue.requestLong(request, "segment1_id");
            long periodId = JSPRequestValue.requestLong(request, "period_id");
            Date startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
            Date endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_date"), "dd/MM/yyyy");

            String[] langNav = {"Financial Report", "Budget Used Report", "Segment", "Range Date"};

            if (lang == LANG_ID) {
                String[] navID = {"Laporan Keuangan", "Laporan Penggunaan Anggaran", "Segment", "Range Tanggal"};
                langNav = navID;
            }

            String whereClause = "";
            if (a != null && a.length > 0) {
                String str = "";
                for (int x = 0; x < a.length; x++) {
                    if (str != null && str.length() > 0) {
                        str = str + ",";
                    }
                    str = str + Long.parseLong(a[x].trim());
                }
                whereClause = " br." + DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID] + " in (" + str + ") ";
            } else {
                whereClause = " br." + DbBudgetRequest.colNames[DbBudgetRequest.COL_SEGMENT1_ID] + " = 0 ";
            }

            Vector segments = DbSegmentUser.userSegments(user.getOID(), 0);
            Vector periods = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");

            Periode p = new Periode();
            try {
                if (periodId != 0) {
                    p = DbPeriode.fetchExc(periodId);
                }
            } catch (Exception e) {
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />        
        <script type="text/javascript" src="<%=approot%>/js/jquery.min.js"></script>
        <link href="<%=approot%>/js/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="<%=approot%>/js/bootstrap.min.js"></script>
        <link href="<%=approot%>/js/bootstrap-multiselect.css" rel="stylesheet" type="text/css" />
        <script src="<%=approot%>/js/bootstrap-multiselect.js" type="text/javascript"></script>
        <script type="text/javascript">
            //    $(function () {
            //        $('#lstSegment').multiselect({
            //            includeSelectAllOption: true
            //        });
            //        $('#btnSelected').click(function () {
            //            var selected = $("#lstSegment option:selected");
            //            var message = "";
            //            selected.each(function () {
            //                message += $(this).text() + " " + $(this).val() + "\n";
            //            });
            //            alert(message);
            //       });
            //    });
        </script>
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
                window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
                function cmdSearch(){
                    document.frmbudgetreport.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmbudgetreport.action="budgetreport_month.jsp";
                    document.frmbudgetreport.submit();
                }
            
                function cmdPrint(){
                    window.open("<%=printroot%>.report.RptAnggaranMonthXLS?segment1Id=<%=segment1Id%>&periodId=<%=periodId%>&coaGroup=<%=grpType%>&startDate=&endDate=<%%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
                    //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif','../images/newdoc2.gif','../images/deletedoc2.gif')">
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
                                            <%@ include file="../calendar/calendarframe.jsp"%>
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
                                                        <form name="frmbudgetreport" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                                                               
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                    
                                                            <%try {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="4" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td colspan="3" height="10"></td>
                                                                                        </tr>         
                                                                                        <tr>
                                                                                            <td width="100" class="fontarial" style="padding:3px;">Period</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td> <!--
                                                                                                <select name="period_id">
                                                                                                    <%-- 
                                                                                                        if (periods != null && periods.size() > 0) {
                                                                                                            for (int i = 0; i < periods.size(); i++) {
                                                                                                                Periode per = (Periode) periods.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=per.getOID()%>" <%if (per.getOID() == periodId) {%>selected<%}%>><%=per.getName()%></option>
                                                                                                    <% }
                                                                                                        } --%>
                                                                                                </select> -->
                                                                                                <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" readonly style="text-align:center;">
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbudgetreport.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                &nbsp; - &nbsp;
                                                                                                <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" readonly style="text-align:center;">
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbudgetreport.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                            </td>                                                                                
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="100" class="fontarial" style="padding:3px;">Group</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td>
                                                                                                <select name="groupType" class="fontarial">
                                                                                                    <option value="All" <%if (grpType.equals("All")) {%>selected<%}%>>- Semua Group -</option>
                                                                                                    <%for (int i = 0; i < I_Project.accGroup.length; i++) {%>
                                                                                                    <option value="<%=I_Project.accGroup[i]%>" <%if (I_Project.accGroup[i].equals(grpType)) {%>selected<%}%>><%=I_Project.accGroup[i]%></option>
                                                                                                    <%}%>
                                                                                                </select>  
                                                                                            </td>                                                                                
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td width="100" class="fontarial" style="padding:3px;">Segment</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td>
                                                                                                <select name="segment1_id" id="lstSegment"   >
                                                                                                    <option value="0" <%if (segment1Id == 0) {%> selected<%}%> >All Location</option>
                                                                                                    <%
                                                                                                        if (segments != null && segments.size() > 0) {
                                                                                                            for (int i = 0; i < segments.size(); i++) {
                                                                                                                SegmentDetail sd = (SegmentDetail) segments.get(i);
                                                                                                                boolean selected = false;
                                                                                                                if (sd.getOID() == segment1Id) {
                                                                                                                    selected = true;
                                                                                                                }
                                                                                                                //if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.BACK) {
                                                                                                                //    selected = true;
                                                                                                                //} else {
                                                                                                                //    if (a != null) {
                                                                                                                //        for (int x = 0; x < a.length; x++) {
                                                                                                                //            if (sd.getOID() == Long.parseLong(a[x].trim())) {
                                                                                                                //                selected = true;
                                                                                                                //                break;
                                                                                                                //            }
                                                                                                                //        }
                                                                                                                //   }
                                                                                                                //}
%>

                                                                                                    <option value="<%=sd.getOID()%>" <%if (selected) {%> selected<%}%> ><%=sd.getName()%></option>
                                                                                                    <% }
                                                                                                        }%>
                                                                                                </select>
                                                                                            </td>                                                                                
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>

                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3">
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr>
                                                                                            <td width="20"><a href="javascript:cmdSearch()"><img src="../images/success.gif" border="0"></a></td>
                                                                                            <td class="fontarial"><a href="javascript:cmdSearch()"><i>Search</i></a></td>
                                                                                        </tr>

                                                                                </td>
                                                                            </tr> 
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> &nbsp;</td>
                                                                            </tr> 
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3">
                                                                                    <%
                                                                                        if (iJSPCommand == JSPCommand.SEARCH) {
                                                                                            String wherePeriod = "";
                                                                                            Periode pp = new Periode();//DbPeriode.fetchExc(periodId);
                                                                                            //wherePeriod = "year(start_date)='" + JSPFormater.formatDate(pp.getStartDate(), "yyyy") + "' and month(start_date)<='" + JSPFormater.formatDate(pp.getStartDate(), "MM") + "'";
                                                                                            wherePeriod = "((year(start_date) >= '"+JSPFormater.formatDate(startDate, "yyyy")+"' AND year(start_date) <= '"+JSPFormater.formatDate(endDate, "yyyy")+"') and (month(start_date) >= '"+JSPFormater.formatDate(startDate, "MM")+"' AND month(end_date) <= '"+JSPFormater.formatDate(endDate, "MM")+"'))";
                                                                                            Vector colPeriod = DbPeriode.list(0, 0, wherePeriod, DbPeriode.colNames[DbPeriode.COL_START_DATE]);
                                                                                    %>
                                                                                    <table border="0" cellpadding="0" cellspacing="1">
                                                                                        <tr>
                                                                                            <td class="tablehdr" width="35">No<td>
                                                                                            <td class="tablehdr" nowrap width="350">Akun Perkiraan<td>
                                                                                                <%
                                                                                                                                                                                            if (colPeriod != null && colPeriod.size() > 0) {
                                                                                                                                                                                                for (int is = 0; is < colPeriod.size(); is++) {
                                                                                                                                                                                                    Periode pr = (Periode) colPeriod.get(is);
                                                                                                %>
                                                                                            <td class="tablehdr" width="90" nowrap><%=pr.getName()%><td>
                                                                                                <%
                                                                                                                                                                                                }
                                                                                                                                                                                            }
                                                                                                %>
                                                                                            <td class="tablehdr" width="90" nowrap>Total<td>
                                                                                            <td class="tablehdr" width="90" nowrap>Request<td>
                                                                                            <td class="tablehdr" width="90" nowrap>Budget YTD<td>
                                                                                            <td class="tablehdr" width="90" nowrap>Selisih<td>
                                                                                        </tr>
                                                                                        <%
                        String grp = "";
                        if (grpType.compareTo("All") != 0) {
                            grp = "account_group = '" + grpType + "' ";
                        }
                        
                        int totalKolom=0;
                        
                        CONResultSet crs = null;
                        Vector coax = new Vector();
                        try {
                            coax = DbCoa.list(0, 0, grp, DbCoa.colNames[DbCoa.COL_CODE]);

                            if (coax != null && coax.size() > 0) {
                                for (int c = 0; c < coax.size(); c++) {
                                    Coa coaz = (Coa) coax.get(c);

                                    String str = "";
                                    switch (coaz.getLevel()) {
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

                                    String namaCoa = "";
                                    namaCoa = str + coaz.getCode() + " - " + coaz.getName();
                                    if (coaz.getStatus().equalsIgnoreCase("HEADER")) {
                                        namaCoa = "<b>" + str + coaz.getCode() + " - " + coaz.getName() + "</b>";
                                    }
                                    double budgetYTD = DbCoaBudget.getBudgetYTD(endDate.getYear() + 1900, coaz.getOID(), segment1Id);

                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="tablecell" width="35" align="center"><%=c + 1%><td>
                                                                                            <td class="tablecell" width="350"><%=namaCoa%><td>
                                                                                                <%
                                                                                                    double totPerCoa = 0;
                                                                                                    double reqPeriode = getRequestPeriod(coaz.getOID(), 0, segment1Id);
                                                                                                    if (colPeriod != null && colPeriod.size() > 0) {
                                                                                                        totalKolom = colPeriod.size() ;//+ 6;
                                                                                                        for (int isx = 0; isx < colPeriod.size(); isx++) {
                                                                                                            Periode prx = (Periode) colPeriod.get(isx);
                                                                                                            //double amount = getAmount(coaz.getOID(), prx.getOID(), segment1Id);
                                                                                                            double amount = getAmount(coaz.getOID(), prx.getOID(), startDate, endDate, segment1Id);
                                                                                                            
                                                                                                            if (coaz.getStatus().equalsIgnoreCase("POSTABLE")) {
                                                                                                                totPerCoa = totPerCoa + amount;
                                                                                                %>
                                                                                            <td class="tablecell" width="90" align="right"><%=JSPFormater.formatNumber(amount, "#,###.##")%><td>
                                                                                                <%
                                                                                                            } else {
                                                                                                %>
                                                                                            <td class="tablecell" width="90" align="right">&nbsp;<td>
                                                                                                <%                                                                                                                    }
                                                                                                            }
                                                                                                        }

                                                                                                        if (coaz.getStatus().equalsIgnoreCase("POSTABLE")) {
                                                                                                %>
                                                                                            <td class="tablecell" width="90" align="right"><%=JSPFormater.formatNumber(totPerCoa, "#,###.##")%><td>
                                                                                            <td class="tablecell" width="90" align="right"><%=JSPFormater.formatNumber(reqPeriode, "#,###.##")%><td>
                                                                                            <td class="tablecell" width="90" align="right"><%=JSPFormater.formatNumber(budgetYTD, "#,###.##")%><td>
                                                                                            <td class="tablecell" width="90" align="right"><%=JSPFormater.formatNumber(budgetYTD - totPerCoa - reqPeriode, "#,###.##")%><td>
                                                                                                <% } else {%>
                                                                                            <td class="tablecell" width="90" align="right">&nbsp;<td>
                                                                                            <td class="tablecell" width="90" align="right">&nbsp;<td>
                                                                                                <td class="tablecell" width="90" align="right">&nbsp;<td>
                                                                                            <td class="tablecell" width="90" align="right">&nbsp;<td>
                                                                                                <% }%>
                                                                                        </tr>
                                                                                        <%
            }
        }
    } catch (Exception ex) {
    }

                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="<%= totalKolom + 16 %>"><hr/></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    
                                                                                    <table>
                                                                                        <tr>
                                                                                            <td width="80"><a href="javascript:cmdPrint()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/print2.gif',1)"><img src="../images/print.gif" name="back" height="22" border="0" ></a></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%    }%>
                                                                                </td>
                                                                            </tr> 
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                
                                                            </table>
                                                            <%} catch (Exception e) {
                                                                            out.println(e.toString());
                                                                        }%>
                                                        </form>
                                                        <!-- #EndEditable --> </td>
                                                </tr>                                                
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                            <td height="25" colspan="2"> <!-- #BeginEditable "footer" --> 
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
