
<%-- 
    Document   : posting_transaksi_bank
    Created on : May 18, 2011, 3:26:37 PM
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
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP, AppMenu.PRIV_DELETE);
            boolean privDepsView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BD, AppMenu.PRIV_VIEW);
            boolean privPoView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPO, AppMenu.PRIV_VIEW);
            boolean privNonPoView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BPN, AppMenu.PRIV_VIEW);
%>
<!-- Jsp Block -->
<%@ include file="../calendar/calendarframe.jsp"%>

<%
            int TYPE_BANK_DEPOSIT = 0;
            int TYPE_BANK_PO_PAYMENT = 1;
            int TYPE_BANK_NON_PO_PAYMENT = 2;

            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");

            long type_document = JSPRequestValue.requestInt(request, "TYPE_DOCUMENT");
            String journalNumber = JSPRequestValue.requestString(request, "JOURNAL_NUMBER");
            long periodeId = JSPRequestValue.requestLong(request, "PERIODE_ID");

            Vector list = new Vector();

            if (iCommand == JSPCommand.SEARCH){

                if (type_document == TYPE_BANK_DEPOSIT){

                    String where = "( " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " = 0 OR " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " IS NULL )";

                    if (journalNumber.length() > 0) {
                        where = where + " AND " + DbBankDeposit.colNames[DbBankDeposit.COL_JOURNAL_NUMBER] + " like '%" + journalNumber + "%' ";
                    }

                    if (periodeId != 0) {
                        Periode periode = new Periode();
                        try {
                            periode = DbPeriode.fetchExc(periodeId);
                        } catch (Exception e) {}

                        where = where + " AND " + DbBankDeposit.colNames[DbBankDeposit.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "'";
                    }

                    try {
                        list = DbBankDeposit.list(0, 0, where, null);
                    } catch (Exception e) { System.out.println("[exception] " + e.toString());}

                } else if (type_document == TYPE_BANK_PO_PAYMENT){

                    String where = "( " + DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS] + " = 0 OR " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " IS NULL ) AND " + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + "!=" + DbBankpoPayment.TYPE_PEMBELIAN_TUNAI;
                    
                    if (journalNumber.length() > 0) {
                        where = where + " AND " + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + journalNumber + "%' ";
                    }

                    if (periodeId != 0) {
                        Periode periode = new Periode();
                        try {
                            periode = DbPeriode.fetchExc(periodeId);
                        } catch (Exception e) {}

                        where = where + " AND " + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "'";
                    }

                    try {
                        list = DbBankpoPayment.list(0, 0, where, null);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                } else if (type_document == TYPE_BANK_NON_PO_PAYMENT){

                    String where = "( " + DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_POSTED_STATUS] + " = 0 OR " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " IS NULL )";
                    
                    if (journalNumber.length() > 0) {
                        where = where + " AND " + DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_JOURNAL_NUMBER] + " like '%" + journalNumber + "%' ";
                    }

                    if (periodeId != 0) {
                        Periode periode = new Periode();
                        try {
                            periode = DbPeriode.fetchExc(periodeId);
                        } catch (Exception e) {}

                        where = where + " AND " + DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "'";
                    }

                    try {
                        list = DbBanknonpoPayment.list(0, 0, where, DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_EFFECTIVE_DATE]);
                    } catch (Exception e) { System.out.println("[exception] " + e.toString()); }
                }
            }


            if (iCommand == JSPCommand.POST) {

                if (type_document == TYPE_BANK_DEPOSIT) {

                    if (list != null && list.size() > 0) {

                        for (int i = 0; i < list.size(); i++) {

                            BankDeposit bankDeposit = (BankDeposit) list.get(i);

                            if (JSPRequestValue.requestInt(request, "check_" + bankDeposit.getOID()) == 1) {

                                Vector depositDetail = DbBankDepositDetail.list(0, 0, "" + DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID] + "=" + bankDeposit.getOID(), null);
                                DbBankDeposit.postJournal(bankDeposit, depositDetail, user.getOID());
                            }
                        }
                    }

                    String where = "( " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " = 0 OR " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " IS NULL )";

                    try {
                        list = DbBankDeposit.list(0, 0, where, null);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                } else if (type_document == TYPE_BANK_PO_PAYMENT){

                    if (list != null && list.size() > 0) {

                        for (int i = 0; i < list.size(); i++) {

                            BankpoPayment bankpo = (BankpoPayment) list.get(i);

                            if (JSPRequestValue.requestInt(request, "check_" + bankpo.getOID()) == 1) {

                                DbBankpoPayment.postJournal(bankpo, user.getOID());

                            }
                        }
                    }

                    String where = "( " + DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS] + " = 0 OR " + DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS] + " IS NULL ) AND " + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + "!=" + DbBankpoPayment.TYPE_PEMBELIAN_TUNAI;
                    System.out.println("[sql] " + where);
                    try {
                        list = DbBankpoPayment.list(0, 0, where, null);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                } else if (type_document == TYPE_BANK_NON_PO_PAYMENT){

                    if (list != null && list.size() > 0) {

                        for (int i = 0; i < list.size(); i++) {

                            BanknonpoPayment banknonpo = (BanknonpoPayment) list.get(i);

                            if (JSPRequestValue.requestInt(request, "check_" + banknonpo.getOID()) == 1) {
                                Vector depositDetail = DbBanknonpoPaymentDetail.list(0, 0, "" + DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_ID] + "=" + banknonpo.getOID(), null);
                                DbBanknonpoPayment.postJournal(banknonpo, depositDetail, user.getOID());
                            }
                        }
                    }

                    String where = "( " + DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_POSTED_STATUS] + " = 0 OR " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " IS NULL )";

                    try {
                        list = DbBanknonpoPayment.list(0, 0, where, DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_EFFECTIVE_DATE]);
                    } catch (Exception e) { System.out.println("[exception] " + e.toString());}
                }
            }

            String[] langCT = {"Journal Number", "Transaction Date", "Receipt to Account", "Currency", "Memo", "Posting", "Code", "Summary", "Data not found", "Journal Number", "Period"}; // 0 - 12

            String[] langNav = {"Bank Transaction", "Post Jurnal", "Search for", "Bank Deposit", "Payment Selection", "Direct Bank Payment"};

            if (lang == LANG_ID) {

                String[] langID = {"Nomor Jurnal", "Tgl. Transaksi", "Perkiraan Penerimaan", "Mata Uang", "Memo", "Posting", "Code", "Jumlah", "Transaksi Bank", "Post Jurnal", "Data tidak ditemukan", "Nomor Jurnal", "Periode"}; //0 - 12
                langCT = langID;

                String[] navID = {"Transaksi Bank", "Post Jurnal", "Pencarian", "Setoran Bank", "Pilih/Seleksi Invoice", "Pembelian Langsung"};
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
        
        function cmdSearch(){            
            document.frmposttransaksibank.command.value="<%=JSPCommand.SEARCH%>";
            document.frmposttransaksibank.prev_command.value="<%=prevCommand%>";
            document.frmposttransaksibank.action="posting_transaksi_bank.jsp";
            document.frmposttransaksibank.submit();
        }
        
        function cmdPost(){            	
            document.frmposttransaksibank.command.value="<%=JSPCommand.POST%>";
            document.frmposttransaksibank.prev_command.value="<%=prevCommand%>";
            document.frmposttransaksibank.action="posting_transaksi_bank.jsp";
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
            String navigator = "&nbsp;&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
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
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                
                                                        <tr> 
                                                            <td colspan="4" valign="top"> 
                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                    <tr> 
                                                                        <td width="13%">&nbsp;</td>
                                                                        <td width="26%">&nbsp;</td>
                                                                        <td width="10%">&nbsp;</td>
                                                                        <td width="51%">&nbsp;</td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td width="13%"><%=langNav[2]%></td>
                                                                        <td width="26%">                                                                                                         
                                                                            <select name="TYPE_DOCUMENT">
                                                                                <%//if (privDepsView) {%>    
                                                                                <option value="<%=TYPE_BANK_DEPOSIT%>" <%if (type_document == TYPE_BANK_DEPOSIT) {%> selected <%}%>><%=langNav[3]%></option>                                                                                
                                                                                <%//}%>
                                                                                <%//if (privPoView) {%>
                                                                                <option value="<%=TYPE_BANK_PO_PAYMENT%>" <%if (type_document == TYPE_BANK_PO_PAYMENT) {%> selected <%}%>><%=langNav[4]%></option>
                                                                                <%//}%>    
                                                                                <%//if (privNonPoView) {%>
                                                                                <option value="<%=TYPE_BANK_NON_PO_PAYMENT%>" <%if (type_document == TYPE_BANK_NON_PO_PAYMENT) {%> selected <%}%>><%=langNav[5]%></option> 
                                                                                <%//}%>    
                                                                            </select>
                                                                        </td>
                                                                        <td width="10%" align="right"><%=langCT[12]%>&nbsp;</td>
                                                                        <td width="51%">
                                                                            <select name="PERIODE_ID" class="formElemen">
                                                                                <option value="0" <%if (periodeId == 0) {%> selected <%}%> >All periode..</option>
                                                                                <%
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " DESC ");

            Vector p_value = new Vector(1, 1);
            Vector p_key = new Vector(1, 1);
            String sel_p = "" + periodeId;

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
                                                                    </tr>  
                                                                    <tr> 
                                                                        <td width="13%"><%=langCT[0]%></td>
                                                                        <td width="26%">                                                                                                         
                                                                            <input type="text" name="JOURNAL_NUMBER"  value="<%= journalNumber %>">
                                                                        </td>
                                                                        <td width="10%">&nbsp;</td>
                                                                        <td width="51%">&nbsp;</td>
                                                                    </tr>  
                                                                    <tr> 
                                                                        <td colspan="4" height="30px"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                    </tr>  
                                                                    <tr> 
                                                                        <td colspan="4" height="15px">&nbsp;</td>
                                                                    </tr>  
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <%
            if (list != null && list.size() > 0) {
                                            %>                                                               
                                            <tr> 
                                                <td>
                                                    <%
                                                if (type_document == TYPE_BANK_DEPOSIT){
                                                    %>
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                        <tr>
                                                            <td width="10%" rowspan="2" class="tablehdr"><%=langCT[0]%></td>
                                                            <td width="10%" rowspan="2" class="tablehdr"><%=langCT[1]%></td>
                                                            <td width="26%" rowspan="2" class="tablehdr"><%=langCT[2]%></td>
                                                            <td colspan="2" class="tablehdr"><%=langCT[3]%></td>
                                                            <td width="35%" rowspan="2" class="tablehdr"><%=langCT[4]%></td>
                                                            <td width="4%" rowspan="2" class="tablehdr"></td>
                                                        </tr>
                                                        <tr>
                                                            <td width="5%" class="tablehdr"><%=langCT[6]%></td>
                                                            <td width="10%" class="tablehdr"><%=langCT[7]%></td>
                                                        </tr>
                                                        <%
                                                        for (int i = 0; i < list.size(); i++) {

                                                            BankDeposit bankDeposit = (BankDeposit) list.get(i);
                                                            
                                                            if (DbApprovalDoc.isPostingReady(bankDeposit.getOID()) || true){
                                                                size++;
                                                            Coa coa = new Coa();

                                                            try {
                                                                coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                                                            } catch (Exception e) { System.out.println("[exception] " + e.toString());}

                                                            Currency cur = new Currency();

                                                            try {
                                                                cur = DbCurrency.fetchExc(bankDeposit.getCurrencyId());
                                                            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }

                                                        %>
                                                        <%if (i % 2 != 0) {%>
                                                        <tr>
                                                            <td class="tablecell" align="center"><%=bankDeposit.getJournalNumber()%></td>
                                                            <td class="tablecell" align="center"><%=JSPFormater.formatDate(bankDeposit.getTransDate(), "dd/MM/yyyy")%></td>
                                                            <td class="tablecell" align="left"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                            <td class="tablecell" align="center"><%=cur.getCurrencyCode()%></td>                                                                                            
                                                            <td class="tablecell" align="center"><%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%></td>
                                                            <td class="tablecell" align="left"><%=bankDeposit.getMemo()%></td>
                                                            <td class="tablecell" align="center"><input type="checkbox" name="check_<%=bankDeposit.getOID()%>" value="1"></td>
                                                        </tr>                                                        
                                                        <%
} else {
                                                        %>
                                                        <tr>
                                                            <td class="tablecell1" align="center"><%=bankDeposit.getJournalNumber()%></td>
                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatDate(bankDeposit.getTransDate(), "dd/MM/yyyy")%></td>
                                                            <td class="tablecell1" align="left"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                            <td class="tablecell1" align="center"><%=cur.getCurrencyCode()%></td>                                                                                            
                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%></td>
                                                            <td class="tablecell1" align="left"><%=bankDeposit.getMemo()%></td>
                                                            <td class="tablecell1" align="center"><input type="checkbox" name="check_<%=bankDeposit.getOID()%>" value="1"></td>
                                                        </tr>
                                                        <%
                                                            } 
                                                        %>
                                                        <%
                                                        }
                                                        } 
                                                        %>
                                                    </table>
                                                    <%
                                                    } else if (type_document == TYPE_BANK_PO_PAYMENT) {
                                                    %>
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                        <tr>
                                                            <td width="10%" rowspan="2" class="tablehdr"><%=langCT[0]%></td>
                                                            <td width="10%" rowspan="2" class="tablehdr"><%=langCT[1]%></td>
                                                            <td width="25%" rowspan="2" class="tablehdr"><%=langCT[2]%></td>
                                                            <td colspan="2" class="tablehdr"><%=langCT[3]%></td>
                                                            <td width="35%" rowspan="2" class="tablehdr"><%=langCT[4]%></td>
                                                            <td width="5%" rowspan="2" class="tablehdr"><%=langCT[5]%></td>
                                                        </tr>
                                                        <tr>
                                                            <td width="5%" class="tablehdr"><%=langCT[6]%></td>
                                                            <td width="10%" class="tablehdr"><%=langCT[7]%></td>
                                                        </tr>
                                                        <%
                                                        for (int i = 0; i < list.size(); i++) {

                                                            BankpoPayment bp = (BankpoPayment) list.get(i);
                                                            size++;
                                                            Coa coa = new Coa();
                                                            try {
                                                                coa = DbCoa.fetchExc(bp.getCoaId());
                                                            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }

                                                            Currency cur = new Currency();

                                                            try {
                                                                cur = DbCurrency.fetchExc(bp.getCurrencyId());
                                                            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }
                                                        %>
                                                        <%if (i % 2 != 0) {%>
                                                        <tr>
                                                            <td class="tablecell" align="center"><%=bp.getJournalNumber()%></td>
                                                            <td class="tablecell" align="center"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></td>
                                                            <td class="tablecell" align="left"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                            <td class="tablecell" align="center"><%=cur.getCurrencyCode()%></td>                                                                                            
                                                            <td class="tablecell" align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%>&nbsp;&nbsp;</td>
                                                            <td class="tablecell" align="left">&nbsp;&nbsp;<%=bp.getMemo()%></td>
                                                            <td class="tablecell" align="center"><input type="checkbox" name="check_<%=bp.getOID()%>" value="1"></td>
                                                        </tr>
                                                        <%
} else {
                                                        %>
                                                        <tr>
                                                            <td class="tablecell1" align="center"><%=bp.getJournalNumber()%></td>
                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatDate(bp.getTransDate(), "dd/MM/yyyy")%></td>
                                                            <td class="tablecell1" align="left"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                            <td class="tablecell1" align="center"><%=cur.getCurrencyCode()%></td>                                                                                            
                                                            <td class="tablecell1" align="right"><%=JSPFormater.formatNumber(bp.getAmount(), "#,###.##")%>&nbsp;&nbsp;</td>
                                                            <td class="tablecell1" align="left">&nbsp;&nbsp;<%=bp.getMemo()%></td>
                                                            <td class="tablecell1" align="center"><input type="checkbox" name="check_<%=bp.getOID()%>" value="1"></td>
                                                        </tr>
                                                        <%
                                                            } 
                                                        %>
                                                        <% } %>
                                                    </table>
                                                    <%
                                                    } else if (type_document == TYPE_BANK_NON_PO_PAYMENT){
                                                    %>
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                        <tr>
                                                            <td width="10%" rowspan="2" class="tablehdr"><%=langCT[0]%></td>
                                                            <td width="10%" rowspan="2" class="tablehdr"><%=langCT[1]%></td>
                                                            <td width="25%" rowspan="2" class="tablehdr"><%=langCT[2]%></td>
                                                            <td colspan="2" class="tablehdr"><%=langCT[3]%></td>
                                                            <td width="35%" rowspan="2" class="tablehdr"><%=langCT[4]%></td>
                                                            <td width="5%" rowspan="2" class="tablehdr"><%=langCT[5]%></td>
                                                        </tr>
                                                        <tr>
                                                            <td width="5%" class="tablehdr"><%=langCT[6]%></td>
                                                            <td width="15%" class="tablehdr"><%=langCT[7]%></td>
                                                        </tr>
                                                        <%
                                                        for (int i = 0; i < list.size(); i++) {

                                                            BanknonpoPayment bnonP = (BanknonpoPayment) list.get(i);
                                                            if (DbApprovalDoc.isPostingReady(bnonP.getOID()) || true){
                                                                size++;
                                                            Coa coa = new Coa();

                                                            try {
                                                                coa = DbCoa.fetchExc(bnonP.getCoaId());
                                                            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }

                                                            String IDR = "";

                                                            try {
                                                                IDR = DbSystemProperty.getValueByName("CURRENCY_CODE_IDR");
                                                            } catch (Exception e) { System.out.println("[exception] " + e.toString()); }

                                                        %>
                                                        <%if (i % 2 != 0) {%>
                                                        <tr>
                                                            <td class="tablecell" align="center"><%=bnonP.getJournalNumber()%></td>
                                                            <td class="tablecell" align="center"><%=JSPFormater.formatDate(bnonP.getTransDate(), "dd/MM/yyyy")%></td>
                                                            <td class="tablecell" align="left"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                            <td class="tablecell" align="center"><%=IDR%></td>                                                                                            
                                                            <td class="tablecell" align="center"><%=JSPFormater.formatNumber(bnonP.getAmount(), "#,###.##")%></td>
                                                            <td class="tablecell" align="left"><%=bnonP.getMemo()%></td>
                                                            <td class="tablecell" align="center"><input type="checkbox" name="check_<%=bnonP.getOID()%>" value="1"></td>
                                                        </tr>
                                                        <%
} else {
                                                        %>
                                                        <tr>
                                                            <td class="tablecell1" align="center"><%=bnonP.getJournalNumber()%></td>
                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatDate(bnonP.getTransDate(), "dd/MM/yyyy")%></td>
                                                            <td class="tablecell1" align="left"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                            <td class="tablecell1" align="center"><%=IDR%></td>                                                                                            
                                                            <td class="tablecell1" align="center"><%=JSPFormater.formatNumber(bnonP.getAmount(), "#,###.##")%></td>
                                                            <td class="tablecell1" align="left"><%=bnonP.getMemo()%></td>
                                                            <td class="tablecell1" align="center"><input type="checkbox" name="check_<%=bnonP.getOID()%>" value="1"></td>
                                                        </tr>
                                                        <%
                                                            } 
                                                        %>
                                                        <% } %> 
                                                        
                                                        <% } %>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                        <%
                                                    }
                                        %>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20px;">&nbsp;</td>
                                </tr>    
                                <%if ((privUpdate || privAdd ) && size > 0 ) {%>
                                <tr>
                                    <td align="left"><a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a></td>                                     
                                </tr>    
                                <%}%>
                                <tr>
                                    <td height="40px;">&nbsp;</td>
                                </tr>    
                                <% } else {%>
                                <% if (iCommand != JSPCommand.NONE) {%>
                                <tr>
                                    <td height="40px;"><%=langCT[10]%></td>
                                </tr> 
                                <%}%>
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

