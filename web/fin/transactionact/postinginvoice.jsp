
<%-- 
    Document   : postinginvoice
    Created on : Oct 25, 2013, 11:56:32 PM
    Author     : Roy Andika
--%>

<%@ page language="java"%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_POST);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_POST, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_POST, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_SELEKSI_POST, AppMenu.PRIV_ADD);

%>
<!-- Jsp Block -->
<%@ include file="../calendar/calendarframe.jsp"%>

<%
            int TYPE_BANK_PO_PAYMENT = 1;
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");

            long type_document = TYPE_BANK_PO_PAYMENT;
            String journalNumber = JSPRequestValue.requestString(request, "JOURNAL_NUMBER");
            long periodeId = JSPRequestValue.requestLong(request, "PERIODE_ID");
            long vendorId = JSPRequestValue.requestLong(request, "vendor");
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            Date dateFrom = JSPFormater.formatDate(JSPRequestValue.requestString(request, "date_from"), "dd/MM/yyyy");
            Date dateTo = JSPFormater.formatDate(JSPRequestValue.requestString(request, "date_to"), "dd/MM/yyyy");

            int non = JSPRequestValue.requestInt(request, "type_non");
            int konsinyasi = JSPRequestValue.requestInt(request, "type_konsinyasi");
            int komisi = JSPRequestValue.requestInt(request, "type_komisi");

            String posting = "YES";
            try {
                posting = DbSystemProperty.getValueByName("POSTING_INVOICE");
            } catch (Exception e) {
            }

            Vector list = new Vector();
            if (iCommand == JSPCommand.NONE) {
                ignore = 1;
                non = 1;
                konsinyasi = 1;
                komisi = 1;
            }
            if (iCommand == JSPCommand.SEARCH || iCommand == JSPCommand.POST) {

                if (type_document == TYPE_BANK_PO_PAYMENT) {
                    try {
                        list = SessInvoice.getListPostingInvoice(periodeId, journalNumber, vendorId, ignore, dateFrom, dateTo,non,konsinyasi,komisi);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
            }


            if (iCommand == JSPCommand.POST) {
                if (type_document == TYPE_BANK_PO_PAYMENT) {
                    if (list != null && list.size() > 0) {
                        for (int i = 0; i < list.size(); i++) {
                            BankpoPayment bankpo = (BankpoPayment) list.get(i);
                            if (JSPRequestValue.requestInt(request, "check_" + bankpo.getOID()) == 1) {
                                if (posting.compareToIgnoreCase("NO") == 0) {
                                    DbBankpoPayment.postOnlyUpdateStatus(bankpo, user.getOID());
                                } else {
                                    DbBankpoPayment.postJournal(bankpo, user.getOID());
                                }
                            }
                        }
                    }
                    try {
                        list = SessInvoice.getListPostingInvoice(periodeId, journalNumber, vendorId, ignore, dateFrom, dateTo,non,konsinyasi,komisi);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
            }

            String[] langCT = {"Journal Number", "Transaction Date", "Account", "Currency", "Memo", "Posting", "Code", "Summary", "Data not found", "Journal Number", "Period"}; // 0 - 12
            String[] langNav = {"Acc. Payable", "Post Invoice", "Search for", "Bank Deposit", "Selection Invoice / Bank Payment (PO)", "Bank Payment (non PO)", "Please click on the search button to find your data", "Data not found", "process is completed", "Vendor", "Date Transaction", "Tax Status"};

            if (lang == LANG_ID) {

                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Perkiraan", "Mata Uang", "Memo", "Posting", "Code", "Jumlah", "Transaksi Bank", "Post Jurnal", "Data tidak ditemukan", "Nomor Jurnal", "Periode"}; //0 - 12
                langCT = langID;

                String[] navID = {"Hutang", "Post Invoice", "Pencarian", "Penerimaan Bank", "Pembayaran Bank (PO)", "Pembayaran Bank (non PO)", "Klik tombol search untuk mencari data", "Data tidak ditemukan", "Proses selesai", "Suplier", "Tanggal Transaksi", "Status Pajak"};
                langNav = navID;
            }

            int size = 0;
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            <%if (!priv && !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function setChecked(val) {
             <%
            for (int k = 0; k < list.size(); k++) {
                if (type_document == TYPE_BANK_PO_PAYMENT) {
                    BankpoPayment objBankpoPayment = (BankpoPayment) list.get(k);
                    out.println("document.frmposttransaksibank.check_" + objBankpoPayment.getOID() + ".checked=val.checked;");
                }
            }
            %>
            }
            
            function cmdSearch(){            
                document.frmposttransaksibank.command.value="<%=JSPCommand.SEARCH%>";
                document.frmposttransaksibank.prev_command.value="<%=prevCommand%>";
                document.frmposttransaksibank.action="postinginvoice.jsp";
                document.frmposttransaksibank.submit();
            }
            
            function cmdPost(){            	
                document.frmposttransaksibank.command.value="<%=JSPCommand.POST%>";
                document.frmposttransaksibank.prev_command.value="<%=prevCommand%>";
                document.frmposttransaksibank.action="postinginvoice.jsp";
                document.frmposttransaksibank.submit();
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
        <!--End Region JavaScript-->
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/savedoc2.gif','../images/post_journal2.gif')">
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
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%>
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
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmposttransaksibank" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">                                                            
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <!--DWLayoutTable-->
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" valign="top">                                                
                                                                                    <table border="0" cellspacing="1" cellpadding="1"> 
                                                                                        <tr height="5">                                                                                                                            
                                                                                            <td width="110"></td>
                                                                                            <td width="2"></td>
                                                                                            <td width="260"></td>    
                                                                                            <td width="100"></td>
                                                                                            <td width="2"></td>
                                                                                            <td width="200"></td>
                                                                                            <td width="10"></td>
                                                                                        </tr>
                                                                                        <tr>                                                        
                                                                                            <td colspan="2" height="10" class="fontarial"><b><i>Search Parameter :</i></b></td>
                                                                                        </tr>  
                                                                                        <tr height="24">                                                        
                                                                                            <td class="tablecell1" style="padding:3px;"><%=langCT[12]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >                                                                                                         
                                                                                                <select name="PERIODE_ID" class="fontarial">
                                                                                                    <option value="0" <%if (periodeId == 0) {%> selected <%}%> >- All periode -</option>
                                                                                                    <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC ");

            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=period.getOID()%>" <%if (periodeId == period.getOID()) {%> selected <%}%> ><%=period.getName().trim()%></option>
                                                                                                    <%
                }
            }
                                                                                                    %>
                                                                                                </select>  
                                                                                            </td>        
                                                                                            <td class="tablecell1" style="padding:3px;"><%=langNav[9]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <%
            Vector result = new Vector(1, 1);
            result = DbVendor.list(0, 0, "", DbVendor.colNames[DbVendor.COL_NAME]);

                                                                                                %>
                                                                                                <select name="vendor" class="fontarial">
                                                                                                    <%if (result != null && result.size() > 0) {%>
                                                                                                    <option value = "0" <%if (vendorId == 0) {%> selected <%}%> >- All Suplier -</option>
                                                                                                    <%
    for (int ix = 0; ix < result.size(); ix++) {
        Vendor vendor = (Vendor) result.get(ix);
                                                                                                    %>                                                                            
                                                                                                    <option value = "<%=vendor.getOID()%>" <%if (vendor.getOID() == vendorId) {%> selected <%}%> ><%=vendor.getName()%></option>
                                                                                                    <%}%>                                                                            
                                                                                                    <%}%>
                                                                                                </select>   
                                                                                            </td>
                                                                                            <td width="10">&nbsp;</td>
                                                                                        </tr>  
                                                                                        <tr height="24">                                                         
                                                                                            <td class="tablecell1" style="padding:3px;"><%=langCT[0]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >                                                                                                         
                                                                                                <input type="text" name="JOURNAL_NUMBER"  value="<%= journalNumber %>" class="fontarial">
                                                                                            </td>                     
                                                                                            <td class="tablecell1" style="padding:3px;"><%=langNav[10]%></td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td >
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <input name="date_from" value="<%=JSPFormater.formatDate((dateFrom == null) ? new Date() : dateFrom, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmposttransaksibank.date_from);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        </td> 
                                                                                                        <td>&nbsp;&nbsp;To&nbsp;&nbsp;</td>
                                                                                                        <td>
                                                                                                            <input name="date_to" value="<%=JSPFormater.formatDate((dateTo == null) ? new Date() : dateTo, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmposttransaksibank.date_to);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        </td> 
                                                                                                        <td>
                                                                                                        <input type="checkbox" name = "ignore" value = "1" <%if (ignore == 1) {%>checked<%}%>>
                                                                                                               </td> 
                                                                                                        <td class="fontarial" style="padding:3px;">Ignore</td> 
                                                                                                    </tr>    
                                                                                                </table> 
                                                                                            </td>
                                                                                            <td width="10">&nbsp;</td>
                                                                                        </tr>                                                                        
                                                                                        <tr> 
                                                                                            <td class="tablecell1" style="padding:3px;">Tipe</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td colspan="3" height="10" align="left">
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input type="checkbox" name = "type_non" value = "1" <%if (non == 1) {%>checked<%}%>></td> 
                                                                                                        <td class="fontarial">Beli Putus</td>
                                                                                                        <td>&nbsp;&nbsp;<input type="checkbox" name = "type_konsinyasi" value = "1" <%if (konsinyasi == 1) {%>checked<%}%>></td> 
                                                                                                        <td class="fontarial">&nbsp;Konsinyasi</td>
                                                                                                        <td>&nbsp;&nbsp;<input type="checkbox" name = "type_komisi" value = "1" <%if (komisi == 1) {%>checked<%}%>></td> 
                                                                                                        <td class="fontarial">&nbsp;Komisi</td>
                                                                                                    </tr>    
                                                                                                </table> 
                                                                                            </td>
                                                                                        </tr> 
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                                
                                                                            </tr>                                
                                                                            <tr>
                                                                                <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height="30">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            if (list != null && list.size() > 0) {
                                                                            %>  
                                                                            <tr> 
                                                                                <td>                                                   
                                                                                    <%
                                                                                if (type_document == TYPE_BANK_PO_PAYMENT) {
                                                                                    %>
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                        <tr>
                                                                                            <td width="3%"  class="tablehdr">No</td>
                                                                                            <td width="13%" class="tablehdr"><%=langCT[0]%></td>
                                                                                            <td width="10%" class="tablehdr"><%=langCT[1]%></td>
                                                                                            <td width="34%" class="tablehdr"><%=langCT[2]%></td>                                                            
                                                                                            <td width="35%" class="tablehdr"><%=langCT[4]%></td>
                                                                                            <td width="5%"  class="tablehdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>  
                                                                                        <%
                                                                                        for (int i = 0; i < list.size(); i++) {

                                                                                            BankpoPayment bp = (BankpoPayment) list.get(i);
                                                                                            size++;
                                                                                            Coa coa = new Coa();
                                                                                            try {
                                                                                                coa = DbCoa.fetchExc(bp.getCoaId());
                                                                                            } catch (Exception e) {
                                                                                                System.out.println("[exception] " + e.toString());
                                                                                            }

                                                                                            Currency cur = new Currency();

                                                                                            try {
                                                                                                cur = DbCurrency.fetchExc(bp.getCurrencyId());
                                                                                            } catch (Exception e) {
                                                                                                System.out.println("[exception] " + e.toString());
                                                                                            }

                                                                                            Vector vBPD = DbBankpoPaymentDetail.list(0, 0, DbBankpoPaymentDetail.colNames[DbBankpoPaymentDetail.COL_BANKPO_PAYMENT_ID] + " = " + bp.getOID(), null);
                                                                                        %>
                                                                                        <tr>
                                                                                            <td class="tablecell1" align="center"><%=i + 1%></td>
                                                                                            <td class="tablecell1" align="center"><%=bp.getJournalNumber()%></td>
                                                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></td>
                                                                                            <td class="tablecell1" align="left">&nbsp;<%=coa.getCode() + " - " + coa.getName()%></td>    
                                                                                            <td class="tablecell1" align="left">&nbsp;&nbsp;<%=bp.getMemo()%></td>                                                            
                                                                                            <td class="tablecell1" align="center"><input type="checkbox" name="check_<%=bp.getOID()%>" value="1"></td>                                                            
                                                                                        </tr>                                                       
                                                                                        <%
                                                                                            double totx = 0;
                                                                                            if (vBPD != null && vBPD.size() > 0) {
                                                                                        %>    
                                                                                        
                                                                                        <tr>
                                                                                            <td class="tablecell" align="center">&nbsp;</td>
                                                                                            <td class="tablecell1" colspan="4">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr>
                                                                                                        <td class="tablecell" align="center" width="30%"><B>Vendor</b></td>
                                                                                                        <td class="tablecell" align="center">&nbsp;</td>
                                                                                                        <td class="tablecell" align="center" width="15%"><B>Amount</b></td>
                                                                                                        <td class="tablecell" align="center" width="15%"><B>Deduction</b></td>
                                                                                                        <td class="tablecell" align="center" width="35%"><B>Keterangan</b></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                            double totAmount = 0;
                                                                                            double totDeduction = 0;
                                                                                            for (int ix = 0; ix < vBPD.size(); ix++) {

                                                                                                BankpoPaymentDetail bpd = (BankpoPaymentDetail) vBPD.get(ix);
                                                                                                String vendor = "";
                                                                                                if (bpd.getInvoiceId() != 0) {
                                                                                                    try {
                                                                                                        Receive rc = DbReceive.fetchExc(bpd.getInvoiceId());
                                                                                                        Vendor vnd = DbVendor.fetchExc(rc.getVendorId());
                                                                                                        vendor = vnd.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }
                                                                                                } else {
                                                                                                    try {
                                                                                                        ArapMemo apm = DbArapMemo.fetchExc(bpd.getArapMemoId());
                                                                                                        Vendor vnd = DbVendor.fetchExc(apm.getVendorId());
                                                                                                        vendor = vnd.getName();
                                                                                                    } catch (Exception e) {
                                                                                                    }
                                                                                                }

                                                                                                double amount = 0;
                                                                                                double deduction = 0;

                                                                                                if (bpd.getPaymentAmount() > 0) {
                                                                                                    amount = bpd.getPaymentAmount();
                                                                                                    totAmount = totAmount + amount;
                                                                                                } else {
                                                                                                    deduction = bpd.getPaymentAmount() * -1;
                                                                                                    totDeduction = totDeduction + deduction;
                                                                                                }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablecell" align="left">&nbsp;<%=vendor%></td>   
                                                                                                        <td class="tablecell" align="center"><%=cur.getCurrencyCode()%></td>                                                                                            
                                                                                                        <td class="tablecell" align="right"><%=JSPFormater.formatNumber(amount, "#,###.##")%>&nbsp;&nbsp;</td>
                                                                                                        <td class="tablecell" align="right"><%=JSPFormater.formatNumber(deduction, "#,###.##")%>&nbsp;&nbsp;</td>
                                                                                                        <td class="tablecell" align="left">&nbsp;&nbsp;<%=bpd.getMemo()%></td>   
                                                                                                    </tr>                                                                    
                                                                                                    <%
                                                                                            }
                                                                                            totx = totAmount - totDeduction;
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td class="tablecell" align="center" >&nbsp;</td>
                                                                                                        <td class="tablecell" align="right" ><B>TOTAL</B></td>
                                                                                                        <td class="tablecell" align="right" colspan="2"><%=JSPFormater.formatNumber(totx, "#,###.##")%>&nbsp;</td>                                                                        
                                                                                                        <td class="tablecell" align="right" >&nbsp;</td>
                                                                                                    </tr>                                                                      
                                                                                                </table>
                                                                                            </td>
                                                                                            <td class="tablecell" align="center">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td align="center" colspan="6" height="1"></td>                                                                        
                                                                                        </tr> 
                                                                                        <%
                                                                                            }
                                                                                        %>                                                        
                                                                                        <%
                                                                                        }
                                                                                        %>
                                                                                    </table>
                                                                                    <%
                                                                                } 
                                                                                    
                                                                                    %>
                                                                                </td>                                
                                                                            </tr>
                                                                            <tr>
                                                                                <td align="left">&nbsp;</td>                                     
                                                                            </tr> 
                                                                            <%if(privUpdate || privAdd){%>
                                                                            <tr>
                                                                                <td align="left"><a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a></td>                                     
                                                                            </tr>  
                                                                            <%}%>
                                                                            <% } else {%>
                                                                            <tr>
                                                                                <td >
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                        <tr> 
                                                                                            <td class="fontarial"><i>
                                                                                                    <%if (iCommand == JSPCommand.NONE) {%>
                                                                                                    <%=langNav[6]%> 
                                                                                                    <%} else {%>
                                                                                                    <%if (iCommand == JSPCommand.POST) {%>
                                                                                                    <%=langNav[8]%>
                                                                                                    <%} else {%>
                                                                                                    <%=langNav[7]%>
                                                                                                    <%}%>
                                                                                                <%}%></i>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>                                                                
                                                                            </tr>                                                                   
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                                    
                                                            </table>                
                                                        </form>                
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
                                <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
