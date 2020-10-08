
<%  
    menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
    Periode per13x = DbPeriode.getOpenPeriod13();
    boolean rptOnlyBTDC = true;

    String strAccountPeriod = "Account Period";String strCT = "Cash Transaction";String strBT = "Bank Transaction";String strAR = "Account Receivable";
    String strAP = "Account Payable";String strDP = "Deposit/Titipan";String strBYMHD = "BYMHD";String strMs = "Membership";
    String strPO = "Purchase Order";String strJournal = "Journal";String strFR = "Financial Report";
    String strDR = "Aktivity";String strDS = "Data Synchronization";    
    String strMD = "Master Data";String strCP = "Close Period";String strAdministrator = "Administrator";
    int valxx = JSPRequestValue.requestInt(request, "valxx");
    String strCPNewPeriod = "Open New Period";
    if (lang == LANG_ID) {
        strAccountPeriod = "Periode Perkiraan";strCT = "Transaksi Tunai";strAR = "Piutang";strAP = "Hutang";strDP = "Deposit/Titipan";strBYMHD = "BYMHD";
        strMs = "Keanggotaan";strPO = "Purchase Order";strJournal = "Jurnal";strFR = "Laporan Keuangan";strDR = "Kegiatan";strDS = "Sinkronisasi Data";
        strMD = "Data Induk";strCP = "Tutup Periode";strAdministrator = "Administrator";strBT = "Transaksi Bank";strCPNewPeriod = "Buka Periode Baru";
    }
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td><img src="<%=approot%>/images/logo-finance2.jpg" width="216" height="32" /></td>
                </tr>
                <tr> 
                    <td><img src="<%=approot%>/images/spacer.gif" width="1" height="5"></td>
                </tr>
                <tr> 
                    <td style="padding-left:10px"> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <%
            Periode periodeXXX = DbPeriode.getOpenPeriod();
            String openPeriodXXX = JSPFormater.formatDate(periodeXXX.getStartDate(), "dd MMM yyyy") + " - " + JSPFormater.formatDate(periodeXXX.getEndDate(), "dd MMM yyyy");
                                %>
                                <td height="49"> 
                                    <div align="center"><%=strAccountPeriod%> : <br> <%=openPeriodXXX%><br>
                                    </div>
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="4"></td>
                            </tr>
                            <tr> 
                                <td class="menu0"><a href="<%=approot%>/home.jsp?valxx=1">Home</a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%if (cashRecPriv || cashRecAdPriv || cashPPayPriv || cashPayPriv || cashPPARriv || cashPRPriv || cashRPPriv || cashArPriv || cashArcPriv || fnCR || COp ) {%>
                            <tr> 
                                <td <%if(valxx==2){%> class="menux" <%}else{%> class="menu0" <%}%> ><a href="<%=approot%>/main/menucash.jsp?valxx=2"><%=strCT%></a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>                            
                            <%if (bankDepPriv || bankPOPriv || bankNonPriv || bankCpPriv || bankPostPriv || bankArcPriv || bankLinkPriv) {%>
                            <tr> 
                                <td <%if(valxx==3){%> class="menux" <%}else{%> class="menu0" <%}%>> <a href="<%=approot%>/main/menubank.jsp?valxx=3"><%=strBT%></a></td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>                           
                            <%if (arAging || arList) {%>
                            <tr > 
                                <td <%if(valxx==4){%> class="menux" <%}else{%> class="menu0" <%}%>><a href="<%=approot%>/main/menuar.jsp?valxx=4"><%=strAR%></a></td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if ((payIGL || payILI || payAAN || payPAL)){%>
                            <tr> 
                                <td <%if(valxx==5){%> class="menux" <%}else{%> class="menu0" <%}%>> <a href="<%=approot%>/main/menuap.jsp?valxx=5"><%=strAP%></a> </td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if ((depoList || newDepo || returDepo || sadloDepo || depoArchives )) {%>
                            <tr> 
                                <td class="menu0" > <a href="javascript:cmdChangeMenu('16')"><%=strDP%></a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (bymhdList || newBymhd || returBymhd || sadloBymhd || bymhdArchives) {%>
                            <tr> 
                                <td class="menu0" > <a href="javascript:cmdChangeMenu('18')"><%=strBYMHD%></a></td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            
                            <%if (anggotaKop || newPinjam || angsurPinjam || newPinjamBank || angsurPinjamBank || daftarBank || akunPinjaman) {%>
                            <tr> 
                                <td class="menu0" > <a href="javascript:cmdChangeMenu('17')"><%=strMs%></a> 
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%
            if (1 == 2) {
                if ((purchaseOrdPriv || purchaseVndPriv || purchaseLinkPriv || purchaseArcPriv)) {%>
                            <tr> 
                                <td class="menu0" onClick="javascript:cmdChangeMenu('3')"> <a href="javascript:cmdChangeMenu('3')"><%=strPO%></a> 
                                </td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}
            }%>
                            <%if(glPriv || postGlPriv || glBackdatedPriv || postGlBackdatedPriv || (per13x.getOID() != 0 && (gl13Priv || postGl13Priv))){%>
                            <tr> 
                                <td <%if(valxx==10){%> class="menux" <%}else{%> class="menu0" <%}%> ><a href="<%=approot%>/main/menujournal.jsp?valxx=10"><%=strJournal%></a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>                            
                            <%if (1 == 2){%>
                            <tr > 
                                <td class="menu0"> <a href="javascript:cmdChangeMenu('10')">Payroll</a> 
                                </td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (fnSTR || fn || fnGl || fnNeraca || fnGlDet) {%>
                            <tr> 
                                <td <%if(valxx==11){%> class="menux" <%}else{%> class="menu0" <%}%> > <a href="<%=approot%>/main/menureport.jsp?valxx=11"><%=strFR%></a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%
            if (applyActivity) { //jika pake aktivity

                if (dreportPriv || approvalActPriv || appActivityPriv) {%>
                            <tr id="drpt1"> 
                                <td <%if(valxx==12){%> class="menux" <%}else{%> class="menu0" <%}%>> <a href="<%=approot%>/main/menuact.jsp?valxx=12"><%=strDR%></a></td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}

            }//end non activity %>
                            <%if (datasyncPriv){%>
                            <tr> 
                                <td <%if(valxx==13){%> class="menux" <%}else{%> class="menu0" <%}%> > <a href="<%=approot%>/main/menusync.jsp?valxx=13"><%=strDS%></a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>                            
                            <%if (mastSysConf || mastAcc || mastWp || mastComp || mastGen || mastBgt) {%>	
                            <tr> 
                                <td <%if(valxx==17){%> class="menux" <%}else{%> class="menu0" <%}%> > <a href="<%=approot%>/main/menumaster.jsp?valxx=17"><%=strMD%></a></td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>                            
                            <%if (closePer){%>
                            <tr> 
                                <td <%if(valxx==14){%> class="menux" <%}else{%> class="menu0" <%}%> > <a href="<%=approot%>/main/menucloseperiod.jsp?valxx=14"><%=strCP%></a></td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <%if (admin){%>
                            <tr > 
                                <td <%if(valxx==15){%> class="menux" <%}else{%> class="menu0" <%}%>> <a href="<%=approot%>/main/menuadmin.jsp?valxx=15"><%=strAdministrator%></a> 
                                </td>
                            </tr>                            
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
                            </tr>
                            <%}%>
                            <tr> 
                                <td class="menu0"><a href="<%=approot%>/logout.jsp">Logout</a></td>
                            </tr>
                            <tr> 
                                <td ><img src="<%=approot%>/images/spacer.gif" width="1" height="2"></td>
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
