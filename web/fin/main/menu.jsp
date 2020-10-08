
<%
            menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
            Periode per13x = DbPeriode.getOpenPeriod13();
            boolean rptOnlyBTDC = true;
            int valxx = JSPRequestValue.requestInt(request, "valxx");

            String strAccountPeriod = "Account Period";
            String strCT = "Cash Transaction";
            String strBT = "Bank Transaction";
            String strAR = "Account Receivable";
            String strAP = "Account Payable";
            String strJournal = "Journal";
            String strFR = "Financial Report";
            String strDR = "Activity";
            String strMD = "Master Data";
            String strCP = "Close Period";
            String strAdministrator = "Administrator";
            String strCPNewPeriod = "Open New Period";
            String strBudget = "Budget";

            if (lang == LANG_ID) {
                strAccountPeriod = "Periode Perkiraan";
                strCT = "Transaksi Tunai";
                strAR = "Piutang";
                strAP = "Hutang";
                strJournal = "Jurnal";
                strFR = "Laporan Keuangan";
                strDR = "Kegiatan";
                strMD = "Data Induk";
                strCP = "Tutup Periode";
                strAdministrator = "Administrator";
                strBT = "Transaksi Bank";
                strCPNewPeriod = "Buka Periode Baru";
                strBudget = "Anggaran";
            }
%>
<table width="180" border="0" cellspacing="1" cellpadding="0" height="100%">
    <tr> 
        <td style="border-right:1px solid #A3B78E" bgcolor="B8CEA8" valign="top" align="left" >            
            <table border="0" cellspacing="0" cellpadding="0" width="170">
                <tr> 
                    <%
            Periode periodeXXX = DbPeriode.getOpenPeriod();
            String openPeriodXXX = JSPFormater.formatDate(periodeXXX.getStartDate(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(periodeXXX.getEndDate(), "dd MMM yyyy");
                    %>
                    <td height="49"> 
                        <div align="center"><font face="sans-serif" color="D4391A"><b><%=strAccountPeriod%> : <br> <%=openPeriodXXX%><br></b></font></div>
                    </td>
                </tr>
                <tr> 
                    <td >
                        <div class="hovermenu">
                            <ul>
                                <%if (menuIdx == 1) {%>
                                <la><a href="<%=approot%>/home.jsp?menu_idx=1">Home</a></la>                            
                                <%} else {%>
                                <li><a href="<%=approot%>/home.jsp?menu_idx=1">Home</a></li>
                                <%}%>                                
                                <%if (cashRecPriv || cashPPayPriv || cashPayPriv || fnCR || cashPPARriv || cashRecAdPriv || cashRPPriv || cashRPPriv || cashArPriv || cashArcPriv) {%>
                                <%if (menuIdx == 2) {%>
                                <la><a href="<%=approot%>/main/menucash.jsp?menu_idx=2"><%=strCT%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menucash.jsp?menu_idx=2"><%=strCT%></a></li>
                                <%}%>
                                <%}%>   
                                <%if (bankDepPriv || bankNonPriv || bankLinkPriv || bankPostPriv || bankArcPriv) {%>
                                <%if (menuIdx == 3) {%>
                                <la><a href="<%=approot%>/main/menubank.jsp?menu_idx=3"><%=strBT%></a></la>                                
                                <%} else {%>
                                <li> <a href="<%=approot%>/main/menubank.jsp?menu_idx=3"><%=strBT%></a></li>
                                <%}%>
                                <%}%>
                                
                                <%if (arAging || arList) {%>
                                <%if (menuIdx == 4) {%>
                                <la><a href="<%=approot%>/main/menuar.jsp?menu_idx=4"><%=strAR%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menuar.jsp?menu_idx=4"><%=strAR%></a></li>
                                <%}%>
                                <%}%>                                
                                <%if (payIGL || payILI || seleksiInvoice || postInvoice || invoicePayment || budgetReport || payAAN || apMemorial || postApMemorial || payPAL || bGOutstanding || arsipBG || budgetReportGA || budgetReportSummary) {%>
                                <%if (menuIdx == 5) {%>
                                <la><a href="<%=approot%>/main/menuap.jsp?menu_idx=5"><%=strAP%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menuap.jsp?menu_idx=5"><%=strAP%></a></li>
                                <%}%>
                                <%}%>                                
                                <%if (glPriv || glBackdatedPriv || glCopyPriv || postGlPriv || glArchivesPriv || akrualSetupPriv || akrualProsesPriv || akrualArchivesPriv || ((per13x.getOID() != 0) && (gl13Priv || postGl13Priv || gl13ArchivesPriv)) || adjustmentPostPriv || adjustmentArchivesPriv || costingPostPriv || costingArchivesPriv || returPostPriv || returArchivesPriv || repackPostPriv || repackArchivesPriv || gaPostPriv || gaArchivesPriv
                                || cashBackPostPriv || cashBackArchivesPriv ) {%>
                                <%if (menuIdx == 10) {%>
                                <la><a href="<%=approot%>/main/menujournal.jsp?menu_idx=10"><%=strJournal%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menujournal.jsp?menu_idx=10"><%=strJournal%></a></li>
                                <%}%>
                                <%}%>
                                
                                <%if(budgetPriv || budgetArchivePriv || budgetApprovalPriv || budgetAccLinkPriv){%>
                                <%if (menuIdx == 16) {%>
                                <la><a href="<%=approot%>/main/menubudget.jsp?menu_idx=16"><%=strBudget%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menubudget.jsp?menu_idx=16"><%=strBudget%></a></li>
                                <%}%>        
                                <%}%>  
                                
                                <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet || fnProfit) {%>
                                <%if (menuIdx == 11) {%>
                                <la><a href="<%=approot%>/main/menureport.jsp?menu_idx=11"><%=strFR%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menureport.jsp?menu_idx=11"><%=strFR%></a></li>
                                <%}%>
                                <%}%>                                
                                <%if (sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_NGO) { //jika pake aktivity %>
                                <%if (dreportPriv || approvalActPriv || appActivityPriv) {%>
                                <%if (menuIdx == 12) {%>
                                <la><a href="<%=approot%>/main/menuact.jsp?menu_idx=12"><%=strDR%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menuact.jsp?menu_idx=12"><%=strDR%></a></li>
                                <%}%>
                                <%}%>
                                <%}%>
                                
                                      
                                
                                <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt || mastSegment || mastVendor || mastCurrency) {%>
                                <%if (menuIdx == 17) {%>
                                <la><a href="<%=approot%>/main/menumaster.jsp?menu_idx=17"><%=strMD%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menumaster.jsp?menu_idx=17"><%=strMD%></a></li>
                                <%}%>
                                <%}%>                            
                                <%if (closePer) {%>
                                <%if (menuIdx == 14) {%>
                                <la><a href="<%=approot%>/main/menucloseperiod.jsp?menu_idx=14"><%=strCP%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menucloseperiod.jsp?menu_idx=14"><%=strCP%></a></li>
                                <%}%>
                                <%}%>
                                <%if (admin || adminExecute || adminJournalEditor || adminSalesEditor) {%>
                                <%if (menuIdx == 15) {%>
                                <la><a href="<%=approot%>/main/menuadmin.jsp?menu_idx=15"><%=strAdministrator%></a></la>                                
                                <%} else {%>
                                <li><a href="<%=approot%>/main/menuadmin.jsp?menu_idx=15"><%=strAdministrator%></a></li>
                                <%}%>
                                <%}%>
                                <li><a href="<%=approot%>/logout.jsp">Logout</a></li>
                            </ul>
                        </div>
                    </td>
                </tr>                
            </table>
        </td>        
    </tr>      
</table>
