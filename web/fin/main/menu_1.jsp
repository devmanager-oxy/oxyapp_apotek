
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
            }
            
            int heightMenu = 26;
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
<tr> 
<td style="border-right:1px solid #A3B78E" bgcolor="FFFFFF" valign="top"> 
    <table width="190" border="0" cellspacing="0" cellpadding="0" >  
    <tr> 
        <td><img src="<%=approot%>/images/spacer.gif" width="1" height="5"></td>
    </tr>
    <tr> 
        <td style="padding-left:10px"> 
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
                                <la>Home</la>                            
                            <%}else{%>
                                <li><a href="<%=approot%>/home.jsp?menu_idx=1">Home</a></li>
                            <%}%>
                            
                            <%if (cashRecPriv || cashPPayPriv || cashPayPriv || fnCR || cashPPARriv || cashRecAdPriv || cashRPPriv || cashRPPriv || cashArPriv || cashArcPriv) {%>
                                <%if (menuIdx == 2) {%>
                                    <la><%=strCT%></la>                                
                                <%}else{%>
                                    <li><a href="<%=approot%>/main/menucash.jsp?menu_idx=2"><%=strCT%></a></li>
                                <%}%>
                            <%}%>
                            
                            <%if (bankDepPriv || bankNonPriv || bankLinkPriv || bankPostPriv || bankArcPriv) {%>
                            <%if (menuIdx == 3) {%>
                                    <la><%=strBT%></la>                                
                                <%}else{%>
                                    <li><a href="<%=approot%>/main/menubank.jsp?menu_idx=3"><%=strBT%></a></li>
                                <%}%>
                            <%}%>
                            
                            <%if (arAging || arList) {%>
                            <%if (menuIdx == 4) {%>
                                    <la><%=strAR%></la>                                
                                <%}else{%>
                                    <li><a href="<%=approot%>/main/menuar.jsp?menu_idx=4"><%=strAR%></a></li>
                                <%}%>
                            <%}%>
                            
                            <%if (payIGL || payILI || seleksiInvoice || postInvoice || invoicePayment || budgetReport || payAAN || apMemorial || postApMemorial || payPAL) {%>
                            <%if (menuIdx == 5) {%>
                                    <la><%=strAP%></la>                                
                                <%}else{%>
                                    <li><a href="<%=approot%>/main/menuap.jsp?menu_idx=5"><%=strAP%></a></li>
                                <%}%>
                            <%}%>
                        </ul>
                        </div>
                    </td>
                </tr>
                
                <tr> 
                <td <%if (menuIdx == 1) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>">
                    <div class="menux">
                        <a href="<%=approot%>/home.jsp?menu_idx=1">Home</a>
                    </div>
                </td>
                </tr>                            
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%if (cashRecPriv || cashPPayPriv || cashPayPriv || fnCR || cashPPARriv || cashRecAdPriv || cashRPPriv || cashRPPriv || cashArPriv || cashArcPriv) {%>
                <tr> 
                <td <%if (menuIdx == 2) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"><a href="<%=approot%>/main/menucash.jsp?menu_idx=2"><%=strCT%></a></td>
                </tr>
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>                            
                <%if (bankDepPriv || bankNonPriv || bankLinkPriv || bankPostPriv || bankArcPriv) {%>
                <tr> 
                <td <%if (menuIdx == 3) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"> <a href="<%=approot%>/main/menubank.jsp?menu_idx=3"><%=strBT%></a></td>
                </tr>                            
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>                           
                <%if (arAging || arList) {%>
                <tr > 
                <td <%if (menuIdx == 4) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"><a href="<%=approot%>/main/menuar.jsp?menu_idx=4"><%=strAR%></a></td>
                </tr>                            
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>
                <%if (payIGL || payILI || seleksiInvoice || postInvoice || invoicePayment || budgetReport || payAAN || apMemorial || postApMemorial || payPAL) {%>
                <tr> 
                <td <%if (menuIdx == 5) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"> <a href="<%=approot%>/main/menuap.jsp?menu_idx=5"><%=strAP%></a> </td>
                </tr>                            
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>
                <%if (glPriv || glBackdatedPriv || glCopyPriv || postGlPriv || glArchivesPriv || akrualSetupPriv || akrualProsesPriv || akrualArchivesPriv || ((per13x.getOID() != 0) && (gl13Priv || postGl13Priv || gl13ArchivesPriv)) || adjustmentPostPriv || adjustmentArchivesPriv || costingPostPriv || costingArchivesPriv || returPostPriv || returArchivesPriv) {%>
                <tr> 
                <td <%if (menuIdx == 10) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"><a href="<%=approot%>/main/menujournal.jsp?menu_idx=10"><%=strJournal%></a></td>
                </tr>
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>                                                        
                <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet || fnProfit) {%>
                <tr> 
                <td <%if (menuIdx == 11) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"> <a href="<%=approot%>/main/menureport.jsp?menu_idx=11"><%=strFR%></a></td>
                </tr>
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>
                <%
            if (sysCompany.getBusinessType() == com.project.I_Project.BUSINESS_TYPE_NGO) { //jika pake aktivity

                if (dreportPriv || approvalActPriv || appActivityPriv) {%>
                <tr id="drpt1"> 
                <td <%if (menuIdx == 12) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"> <a href="<%=approot%>/main/menuact.jsp?menu_idx=12"><%=strDR%></a></td>
                </tr>                            
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}

            }//end non activity %>                                                   
                <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                <tr> 
                <td <%if (menuIdx == 17) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"> <a href="<%=approot%>/main/menumaster.jsp?menu_idx=17"><%=strMD%></a></td>
                </tr>                            
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>                            
                <%if (closePer) {%>
                <tr> 
                <td <%if (menuIdx == 14) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"> <a href="<%=approot%>/main/menucloseperiod.jsp?menu_idx=14"><%=strCP%></a></td>
                </tr>                            
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>
                
                <%if (admin) {%>
                <tr > 
                    <td <%if (menuIdx == 15) {%> class="menux" <%} else {%> class="menu0" <%}%> height="<%=heightMenu%>"> <a href="<%=approot%>/main/menuadmin.jsp?menu_idx=15"><%=strAdministrator%></a> </td>
                </tr>                            
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <%}%>
                <tr> 
                    <td class="menu0" height="<%=heightMenu%>"><a href="<%=approot%>/logout.jsp" >Logout</a></td>
                </tr>
                <tr> 
                    <td bgcolor="#DDDDDD" height="2"></td>
                </tr>
                <tr> 
                    <td bgcolor="#FFFFFF" height="1"></td>
                </tr>
                <tr> 
                    <td>&nbsp;</td>
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
</td>
</tr>
</table>
