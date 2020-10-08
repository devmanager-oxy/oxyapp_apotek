
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_CONFIGURATION, AppMenu.PRIV_DELETE);
%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCompany = JSPRequestValue.requestLong(request, "hidden_company_id");
            double maxReplace = JSPRequestValue.requestDouble(request, "max_replenishment");
            double maxTrans = JSPRequestValue.requestDouble(request, "max_transaction");            
            int useBkp = JSPRequestValue.requestInt(request, "use_bkp");
            double amountBkp = JSPRequestValue.requestDouble(request, "amount_bkp");
            String cmpName = JSPRequestValue.requestString(request, "cmp_name");
            String cmpAddress = JSPRequestValue.requestString(request, "cmp_address");            
            String cmpAddress2 = JSPRequestValue.requestString(request, "cmp_address2");
            String cmpContact = JSPRequestValue.requestString(request, "cmp_contact");            
            int multiCurrency = JSPRequestValue.requestInt(request, "multi_currency");
            int multiBank = JSPRequestValue.requestInt(request, "multi_bank");
            int typeBisnis = JSPRequestValue.requestInt(request, "tipe_bisnis");
            
            Company company = new Company();
            try {
                company = DbCompany.fetchExc(oidCompany);
            } catch (Exception e) {}

            if (iJSPCommand == JSPCommand.SUBMIT && maxTrans > 0 && maxReplace > 0) {
                company.setMaxPettycashTransaction(maxTrans);
                company.setMaxPettycashReplenis(maxReplace);
                company.setUseBkp(useBkp);
                company.setTaxAmount(amountBkp);
                company.setName(cmpName);
                company.setAddress(cmpAddress);
                company.setAddress2(cmpAddress2);
                company.setContact(cmpContact);
                company.setMultiCurrency(multiCurrency);
                company.setMultiBank(multiBank);
                company.setBusinessType(typeBisnis);
                
                try {
                    DbCompany.updateExc(company);
                } catch (Exception e) {}
            }

            /*** LANG ***/
            String[] langMD = {"Company Profile", "Serial Number", "Company Name", "Address", "Contact Person", //0-4
                "Financial Setup", "Current Fiscal Year", "End Fiscal Month", "Current Open Period", "Number Of Period in a Year", "Booking Currency", //5-10
                "System Location", "Max. Petty Cash Replenishment", "Max. Petty Cash Transaction", "Default Government Tax", "Department Level", //11-15
                "Document Prefix", "Cash Receive", "Petty Cash Payment", "Petty Cash Replenishment", "Bank Deposit", //16-20
                "Bank Payment with PO", "Bank Payment Non PO", "Purchase Order", "General Ledger","Use BKP","Tax BKP","Multi Currency","Multi Bank","Businnes Type"}; //21-29

            String[] langNav = {"Masterdata", "Company Profile"};

            if (lang == LANG_ID) {
                String[] langID = {"Profil Perusahaan", "Nomor Seri", "Nama Perusahaan", "Alamat", "Kontak",
                    "Setup Keuangan", "Tahun Pajak Berjalan", "Bulan Pajak Terakhir", "Periode yang Berjalan", "Jumlah Periode dalam Setahun", "Mata Uang Pembukuan",
                    "Lokasi Sistem", "Maks. Kas Kecil Replenishment", "Maks. Transaksi Kas Kecil", "Standar Pajak Pemerintah", "Level Departemen",
                    "Kode Awal Dokumen", "Penerimaan Tunai", "Pelunasan Kas Kecil", "Pengisian Kembali Kas Kecil", "Setoran Bank",
                    "Pelunasan Bank (PO)", "Pelunasan Bank (Non PO)", "Order Pembelian", "General Ledger","Menggunakan BKP","Besar BKP","Beragam Mata Uang","Beragam Bank","Tipe Bisnis"
                };
                langMD = langID;

                String[] navID = {"Data Induk", "Profil Perusahaan"};
                langNav = navID;
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
            
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function removeChar(number){
                
                var ix;
                var result = "";
                for(ix=0; ix<number.length; ix++){
                    var xx = number.charAt(ix);
                    
                    if(!isNaN(xx)){
                        result = result + xx;
                    }else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }                
                return result;
            }
            
            function checkNumber(){
                var st = document.frmcompany.max_replenishment.value;		                
                var result = removeChar(st);                
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                document.frmcompany.max_replenishment.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function checkNumber2(){
                var st1 = document.frmcompany.max_replenishment.value;		
                var result1 = removeChar(st1);
                result1 = cleanNumberFloat(result1, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                var st = document.frmcompany.max_transaction.value;	
                var result = removeChar(st);
                
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                
                if(parseFloat(result)>parseFloat(result1)){
                    alert('Transaction amount over the replenishment amount');
                    document.frmcompany.max_transaction.value = formatFloat(result1, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 		
                    document.frmcompany.max_transaction.select();
                }else{	
                    document.frmcompany.max_transaction.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
                }
            }
            
            function checkNumber3(){
                var st1 = document.frmcompany.amount_bkp.value;		
                var result1 = removeChar(st1);
                result1 = cleanNumberFloat(result1, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                var st = document.frmcompany.amount_bkp.value;	
                var result = removeChar(st);                
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);                              
                document.frmcompany.amount_bkp.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function cmdAdd(){
                document.frmcompany.hidden_company_id.value="0";
                document.frmcompany.command.value="<%=JSPCommand.ADD%>";
                document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
            }
            
            function cmdAsk(oidCompany){
                document.frmcompany.hidden_company_id.value=oidCompany;
                document.frmcompany.command.value="<%=JSPCommand.ASK%>";
                document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
            }
            
            function cmdConfirmDelete(oidCompany){
                document.frmcompany.hidden_company_id.value=oidCompany;
                document.frmcompany.command.value="<%=JSPCommand.DELETE%>";
                document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
            }
            function cmdSave(){
                document.frmcompany.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmcompany.action="company_view.jsp";
                document.frmcompany.submit();
            }
            
            function cmdEdit(oidCompany){
                <%if(privUpdate){%>
                document.frmcompany.hidden_company_id.value=oidCompany;
                document.frmcompany.command.value="<%=JSPCommand.EDIT%>";
                document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
                <%}%>
            }
            
            function cmdCancel(oidCompany){
                document.frmcompany.hidden_company_id.value=oidCompany;
                document.frmcompany.command.value="<%=JSPCommand.EDIT%>";
                document.frmcompany.prev_command.value="<%=prevJSPCommand%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
            }
            
            function cmdBack(){
                document.frmcompany.command.value="<%=JSPCommand.BACK%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
            }
            
            function cmdListFirst(){
                document.frmcompany.command.value="<%=JSPCommand.FIRST%>";
                document.frmcompany.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
            }
            
            function cmdListPrev(){
                document.frmcompany.command.value="<%=JSPCommand.PREV%>";
                document.frmcompany.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
            }
            
            function cmdListNext(){
                document.frmcompany.command.value="<%=JSPCommand.NEXT%>";
                document.frmcompany.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
            }
            
            function cmdListLast(){
                document.frmcompany.command.value="<%=JSPCommand.LAST%>";
                document.frmcompany.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcompany.action="company.jsp";
                document.frmcompany.submit();
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
        <script language="JavaScript">
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/save2.gif')">
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
                                                        <form name="frmcompany" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="hidden_company_id" value="<%=oidCompany%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3">&nbsp;</td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="top" colspan="3"> 
                                                                        <table width="95%" border="0" cellspacing="1" cellpadding="0">
                                                                            <tr align="left"> 
                                                                            <td height="17" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="17" colspan="4"><font color="#990000">&nbsp;<b><%=langMD[0]%></b></font></td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                            <td height="8" valign="top" width="1%"></td>
                                                                            <td height="8" width="21%"></td>
                                                                            <td height="8" width="22%"> 
                                                                            <td height="8" width="19%"> 
                                                                            <td height="8" width="37%"></td> 
                                                                            </tr>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                            <td height="17" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="17" width="21%"><b>&nbsp;<%=langMD[1]%></b></td>
                                                                            <td height="17" width="22%"> <%= (company.getSerialNumber().length() < 1) ? "-" : company.getSerialNumber() %> 
                                                                            <td height="17" width="19%">&nbsp; 
                                                                            <td height="17" width="37%">&nbsp;</td> 
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                            <td height="17" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="17" width="21%"><b>&nbsp;<%=langMD[2]%></b></td>
                                                                            <td height="17" colspan="3"> 
                                                                            <input type="text" name="cmp_name" value = "<%= company.getName() %>"></td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                            <td height="17" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="17" width="21%"><b>&nbsp;<%=langMD[3]%></b></td>
                                                                            <td height="17" colspan="3"> 
                                                                            <input type="text" name="cmp_address" value = "<%= company.getAddress()%>"> 
                                                                            </td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                            <td height="17" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="17" width="21%"><b></b></td>
                                                                            <td height="17" colspan="3"> 
                                                                            <input type="text" name="cmp_address2" value = "<%= company.getAddress2() %>"> 
                                                                            <tr align="left"> 
                                                                            <td height="17" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="17" width="21%"><b>&nbsp;<%=langMD[4]%></b></td>
                                                                            <td height="17" colspan="3"> 
                                                                            <input type="text" name="cmp_contact" value = "<%= company.getContact() %> "> 
                                                                            <tr align="left"> 
                                                                            <td height="17" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="17" width="21%">&nbsp;</td>
                                                                            <td height="17" width="22%">&nbsp; 
                                                                            <td height="17" width="19%">&nbsp; 
                                                                            <td height="17" width="37%">&nbsp; 
                                                                            <tr align="left"> 
                                                                            <td height="17" valign="top" width="1%">&nbsp;</td>
                                                                            <td height="17" width="21%"><font color="#990000">&nbsp;<b><%=langMD[5]%></b></font></td>
                                                                            <td height="17" width="22%">&nbsp;</td>
                                                                            <td width="19%" class="command" height="17"><b><font color="#990000"><%=langMD[16]%></font></b></td>
                                                                            <td height="17" width="37%">&nbsp;</td>
                                                                            <tr align="left"> 
                                                                            <td height="8" valign="top" width="1%"></td>
                                                                            <td height="8" width="21%"></td>
                                                                            <td height="8" width="22%"> 
                                                                            <td width="19%" class="command" height="8"></td>
                                                                            <td height="8" width="37%"> 
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="17">&nbsp; 
                                                                                </td>
                                                                                <td height="17" width="21%"><b>&nbsp;<%=langMD[6]%></b></td>
                                                                                <td width="22%" class="command" height="17"> 
                                                                                <%=company.getFiscalYear()%> </td>
                                                                                <td height="17" width="19%"><b>&nbsp;<%=langMD[17]%></b></td>
                                                                                <td width="37%" class="command" height="17"> 
                                                                                <%=company.getCashReceiveCode()%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="17">&nbsp;</td>
                                                                                <td height="17" width="21%"><b>&nbsp;<%=langMD[7]%></b></td>
                                                                                <td width="22%" class="command" height="17"> 
                                                                                <%=I_Project.longMonths[company.getEndFiscalMonth()]%> </td>
                                                                                <td height="17" width="19%"><b>&nbsp;<%=langMD[18]%></b></td>
                                                                                <td width="37%" class="command" height="17"> 
                                                                                <%=company.getPettycashPaymentCode()%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="17">&nbsp;</td>
                                                                                <td height="17" width="21%"><b>&nbsp;<%=langMD[8]%></b></td>
                                                                                <td width="22%" class="command" height="17"> 
                                                                                <%=I_Project.longMonths[company.getEntryStartMonth()]%> </td>
                                                                                <td height="17" width="19%"><b>&nbsp;<%=langMD[19]%></b></td>
                                                                                <td width="37%" class="command" height="17"> 
                                                                                <%=company.getPettycashReplaceCode()%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="17">&nbsp;</td>
                                                                                <td height="17" width="21%"><b>&nbsp;<%=langMD[9]%></b></td>
                                                                                <td width="22%" class="command" height="17"> 
                                                                                <%=company.getNumberOfPeriod()%> </td>
                                                                                <td height="17" width="19%"><b>&nbsp;<%=langMD[20]%></b></td>
                                                                                <td width="37%" class="command" height="17"> 
                                                                                <%=company.getBankDepositCode()%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="17">&nbsp;</td>
                                                                                <td height="17" width="21%"><b>&nbsp;<%=langMD[10]%></b></td>
                                                                                <td width="22%" class="command" height="17"> 
                                                                                    <%
            Currency c = new Currency();
            try {
                c = DbCurrency.fetchExc(company.getBookingCurrencyId());
            } catch (Exception e) {
            }
                                                                                    %>
                                                                                <%=c.getCurrencyCode()%> </td>
                                                                                <td height="17" width="19%"><b>&nbsp;<%=langMD[21]%></b></td>
                                                                                <td width="37%" class="command" height="17"> 
                                                                                <%=company.getBankPaymentPoCode()%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="17">&nbsp;</td>
                                                                                <td height="17" width="21%"><b>&nbsp;<%=langMD[11]%></b></td>
                                                                                <td width="22%" class="command" height="17"> 
                                                                                    <%
            Location l = new Location();
            try {
                l = DbLocation.fetchExc(company.getSystemLocation());
            } catch (Exception e) {
            }
                                                                                    %>
                                                                                <%=l.getCode() + " - " + l.getName()%></td>
                                                                                <td height="17" width="19%"><b>&nbsp;<%=langMD[22]%></b></td>
                                                                                <td width="37%" class="command" height="17"> 
                                                                                <%= (company.getBankPaymentNonpoCode())%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="17">&nbsp;</td>
                                                                                <td height="17" width="21%"><b>&nbsp;<%=langMD[12]%></b></td>
                                                                                <td width="22%" class="command" height="17"> 
                                                                                    <input type="text" name="max_replenishment" value="<%= JSPFormater.formatNumber(company.getMaxPettycashReplenis(), "#,###.##") %>" onClick="this.select()" style="text-align:right" onBlur="javascript:checkNumber()">
                                                                                </td>
                                                                                <td height="17" width="19%"><b>&nbsp;<%=langMD[23]%></b></td>
                                                                                <td width="37%" class="command" height="17"> 
                                                                                <%= (company.getPurchaseOrderCode())%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="17">&nbsp;</td>
                                                                                <td height="17" width="21%"><b>&nbsp;<%=langMD[13]%></b></td>
                                                                                <td width="22%" class="command" height="17"> 
                                                                                    <input type="text" name="max_transaction" value="<%= JSPFormater.formatNumber(company.getMaxPettycashTransaction(), "#,###.##") %>" onClick="this.select()" style="text-align:right" onBlur="javascript:checkNumber2()">
                                                                                </td>
                                                                                <td height="17" width="19%"><b>&nbsp;<%=langMD[24]%></b></td>
                                                                                <td width="37%" class="command" height="17"> 
                                                                                <%= (company.getGeneralLedgerCode())%> </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="14"></td>
                                                                                <td height="14">&nbsp;<b><%=langMD[14]%></b></td>
                                                                                <td height="14"><%=JSPFormater.formatNumber(company.getGovernmentVat(), "#,###.#")%> %</td>
                                                                                <td height="14">&nbsp;<b><%=langMD[15]%></b></td>
                                                                                <td height="14"> <%if (company.getDepartmentLevel() == -1) {%>
                                                                                    TOTAL CORPORATE
                                                                                    <%} else {%>
                                                                                    <%=DbDepartment.strLevel[company.getDepartmentLevel()]%>
                                                                                <%}%></td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="14"></td>
                                                                                <td height="14">&nbsp;<b><%=langMD[25]%></b></td>
                                                                                <td height="14">
                                                                                    <select name="use_bkp">
                                                                                        <option value = <%=DbCompany.NOT_USE_BKP%> <%if(company.getUseBkp() == DbCompany.NOT_USE_BKP){%> selected <%}%>>Not Use BKP</option>
                                                                                        <option value = <%=DbCompany.USE_BKP%> <%if(company.getUseBkp() == DbCompany.USE_BKP){%> selected <%}%>>Use BKP</option>
                                                                                    </select>    
                                                                                </td>
                                                                                <td height="14">&nbsp;<b><%=langMD[26]%></b></td>
                                                                                <td height="14">
                                                                                    <input type="text" name="amount_bkp" value="<%=JSPFormater.formatNumber(company.getTaxAmount(), "#,###.##") %>" onClick="this.select()" style="text-align:right" onBlur="javascript:checkNumber3()">&nbsp;%
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="14"></td>
                                                                                <td height="14">&nbsp;<b><%=langMD[27]%></b></td>
                                                                                <td height="14">
                                                                                    <select name="multi_currency">
                                                                                        <option value = <%=DbCompany.NON_MULTI_CURRENCY%> <%if(company.getMultiCurrency() == DbCompany.NON_MULTI_CURRENCY){%> selected <%}%>>Non Multi Currency</option>
                                                                                        <option value = <%=DbCompany.MULTI_CURRENCY%> <%if(company.getMultiCurrency() == DbCompany.MULTI_CURRENCY){%> selected <%}%>>Multi Currency</option>
                                                                                    </select>    
                                                                                </td>
                                                                                <td height="14">&nbsp;<b><%=langMD[28]%></b></td>
                                                                                <td height="14">
                                                                                    <select name="multi_bank">
                                                                                        <option value = <%=DbCompany.NON_MULTI_BANK%> <%if(company.getMultiBank() == DbCompany.NON_MULTI_BANK){%> selected <%}%>>Non Multi Bank</option>
                                                                                        <option value = <%=DbCompany.MULTI_BANK%> <%if(company.getMultiBank() == DbCompany.MULTI_BANK){%> selected <%}%>>Multi Bank</option>
                                                                                    </select>    
                                                                                </td>
                                                                            </tr>    
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="14"></td>
                                                                                <td height="14">&nbsp;<b><%=langMD[29]%></b></td>
                                                                                <td height="14">
                                                                                    <select name="tipe_bisnis">
                                                                                        <option value = <%=I_Project.BUSINESS_TYPE_COMMON%> <%if(company.getBusinessType() == I_Project.BUSINESS_TYPE_COMMON){%> selected <%}%>>Type Common</option>
                                                                                        <option value = <%=I_Project.BUSINESS_TYPE_RETAIL%> <%if(company.getBusinessType() == I_Project.BUSINESS_TYPE_RETAIL){%> selected <%}%>>Type Retail</option>
                                                                                        <option value = <%=I_Project.BUSINESS_TYPE_NGO%> <%if(company.getBusinessType() == I_Project.BUSINESS_TYPE_NGO){%> selected <%}%>>Type NGO</option>
                                                                                    </select>    
                                                                                </td>
                                                                                <td height="14">&nbsp;</td>
                                                                                <td height="14">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="14"></td>
                                                                                <td height="14" colspan="4"></td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td width="1%" class="command" valign="top" height="8"></td>
                                                                                <td height="8" colspan="4"> 
                                                                                    <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td background="../images/line.gif" height="5"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            
                                                                            
                                                                            <tr> 
                                                                                <td width="1%" height="17">&nbsp;</td>
                                                                                <td colspan="2" height="17"> 
                                                                                    <table width="99%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="6%"><%if (privUpdate || privAdd) {%><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/save2.gif',1)"><img src="../images/save.gif" name="new2"  border="0"></a><%}%></td>
                                                                                            <td width="94%">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                                <td width="19%" height="17">&nbsp;</td>
                                                                                <td width="37%" height="17">&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td width="1%" height="17">&nbsp;</td>
                                                                                <td width="21%" height="17">&nbsp;</td>
                                                                                <td width="22%" height="17">&nbsp;</td>
                                                                                <td width="19%" height="17">&nbsp;</td>
                                                                                <td width="37%" height="17">&nbsp;</td>
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
