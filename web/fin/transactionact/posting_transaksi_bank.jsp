
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
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.general.Currency" %>
<%@ page import = "com.project.general.DbCurrency" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_B, AppMenu.M2_MN_BP, AppMenu.PRIV_ADD);

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

            String where = "";

            if (iCommand == JSPCommand.SEARCH || iCommand == JSPCommand.POST) {

                if (type_document == TYPE_BANK_DEPOSIT) {

                    where = "( " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " = 0 OR " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " IS NULL )";

                    if (journalNumber.length() > 0) {
                        where = where + " AND " + DbBankDeposit.colNames[DbBankDeposit.COL_JOURNAL_NUMBER] + " like '%" + journalNumber + "%' ";
                    }

                    if (periodeId != 0) {
                        Periode periode = new Periode();
                        try {
                            periode = DbPeriode.fetchExc(periodeId);
                        } catch (Exception e) {
                        }

                        where = where + " AND " + DbBankDeposit.colNames[DbBankDeposit.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "'";
                    }

                    try {
                        list = DbBankDeposit.list(0, 0, where, null);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                } else if (type_document == TYPE_BANK_PO_PAYMENT) {

                    where = "( " + DbBankpoPayment.colNames[DbBankpoPayment.COL_POSTED_STATUS] + " = 0 OR " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " IS NULL ) AND " + DbBankpoPayment.colNames[DbBankpoPayment.COL_TYPE] + "!=" + DbBankpoPayment.TYPE_PEMBELIAN_TUNAI;

                    if (journalNumber.length() > 0) {
                        where = where + " AND " + DbBankpoPayment.colNames[DbBankpoPayment.COL_JOURNAL_NUMBER] + " like '%" + journalNumber + "%' ";
                    }

                    if (periodeId != 0) {
                        Periode periode = new Periode();
                        try {
                            periode = DbPeriode.fetchExc(periodeId);
                        } catch (Exception e) {
                        }

                        where = where + " AND " + DbBankpoPayment.colNames[DbBankpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "'";
                    }
                    try {
                        list = DbBankpoPayment.list(0, 0, where, null);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                } else if (type_document == TYPE_BANK_NON_PO_PAYMENT) {

                    where = "( " + DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_POSTED_STATUS] + " = 0 OR " + DbBankDeposit.colNames[DbBankDeposit.COL_POSTED_STATUS] + " IS NULL )";

                    if (journalNumber.length() > 0) {
                        where = where + " AND " + DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_JOURNAL_NUMBER] + " like '%" + journalNumber + "%' ";
                    }

                    if (periodeId != 0) {
                        Periode periode = new Periode();
                        try {
                            periode = DbPeriode.fetchExc(periodeId);
                        } catch (Exception e) {
                        }

                        where = where + " AND " + DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_TRANS_DATE] + " between '" + JSPFormater.formatDate(periode.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(periode.getEndDate(), "yyyy-MM-dd") + "'";
                    }

                    try {
                        list = DbBanknonpoPayment.list(0, 0, where, DbBanknonpoPayment.colNames[DbBanknonpoPayment.COL_EFFECTIVE_DATE]);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
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

                    try {
                        list = DbBankDeposit.list(0, 0, where, null);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }

                } else if (type_document == TYPE_BANK_NON_PO_PAYMENT) {

                    if (list != null && list.size() > 0) {

                        for (int i = 0; i < list.size(); i++) {

                            BanknonpoPayment banknonpo = (BanknonpoPayment) list.get(i);

                            if (JSPRequestValue.requestInt(request, "check_" + banknonpo.getOID()) == 1) {
                                Vector depositDetail = DbBanknonpoPaymentDetail.list(0, 0, "" + DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_ID] + "=" + banknonpo.getOID(), null);
                                DbBanknonpoPayment.postJournal(banknonpo, depositDetail, user.getOID());
                            }
                        }
                    }

                    try {
                        list = DbBanknonpoPayment.list(0, 0, where, null);
                    } catch (Exception e) {
                        System.out.println("[exception] " + e.toString());
                    }
                }
            }

            String[] langCT = {"Journal Number", "Transaction Date", "Account", "Currency", "Memo", "Posting", "Code", "Summary", "Data not found", "Journal Number", "Period"}; // 0 - 12
            String[] langNav = {"Bank Transaction", "Post Jurnal", "Search for", "Bank Deposit", "Selection Invoice / Bank Payment (PO)", "Bank Payment (non PO)", "Please click on the search button to find your data", "Data not found", "process is completed"};

            if (lang == LANG_ID) {

                String[] langID = {"Nomor Jurnal", "Tanggal Transaksi", "Perkiraan", "Mata Uang", "Memo", "Posting", "Code", "Jumlah", "Transaksi Bank", "Post Jurnal", "Data tidak ditemukan", "Nomor Jurnal", "Periode"}; //0 - 12
                langCT = langID;

                String[] navID = {"Transaksi Bank", "Post Jurnal", "Pencarian", "Penerimaan Bank", "Pembayaran Bank (PO)", "Pembayaran Bank (non PO)", "Klik tombol search untuk mencari data", "Data tidak ditemukan", "Proses selesai"};
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
                if (type_document == TYPE_BANK_DEPOSIT) {
                    BankDeposit objBankDeposit = (BankDeposit) list.get(k);
                    out.println("document.frmposttransaksibank.check_" + objBankDeposit.getOID() + ".checked=val.checked;");
                } else if (type_document == TYPE_BANK_PO_PAYMENT) {
                    BankpoPayment objBankpoPayment = (BankpoPayment) list.get(k);
                    out.println("document.frmposttransaksibank.check_" + objBankpoPayment.getOID() + ".checked=val.checked;");
                } else if (type_document == TYPE_BANK_NON_PO_PAYMENT) {
                    BanknonpoPayment objBanknonpoPayment = (BanknonpoPayment) list.get(k);
                    out.println("document.frmposttransaksibank.check_" + objBanknonpoPayment.getOID() + ".checked=val.checked;");
                }
            }
%>
}

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
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                
                                                                                        <tr> 
                                                                                            <td colspan="4" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr height="10">
                                                                                                        <td width="100"></td>
                                                                                                        <td width="5"></td>
                                                                                                        <td width="250"></td>
                                                                                                        <td width="100"></td>
                                                                                                        <td width="5"></td>
                                                                                                        <td ></td>
                                                                                                    </tr>
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablecell1" style="padding:3px;"><%=langNav[2]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td class="fontarial">                                                                                                         
                                                                                                            <select name="TYPE_DOCUMENT" class="fontarial">                                                                                  
                                                                                                                <option value="<%=TYPE_BANK_DEPOSIT%>" <%if (type_document == TYPE_BANK_DEPOSIT) {%> selected <%}%>><%=langNav[3]%></option>                                                                                                                                                                                                                                                
                                                                                                                <option value="<%=TYPE_BANK_NON_PO_PAYMENT%>" <%if (type_document == TYPE_BANK_NON_PO_PAYMENT) {%> selected <%}%>><%=langNav[5]%></option>                                                                                 
                                                                                                            </select>
                                                                                                        </td>                                                                        
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
                                                                                                    </tr>  
                                                                                                    <tr height="23"> 
                                                                                                        <td class="tablecell1" style="padding:3px;"><%=langCT[0]%></td>
                                                                                                        <td class="fontarial">:</td>
                                                                                                        <td >                                                                                                         
                                                                                                            <input type="text" name="JOURNAL_NUMBER" value="<%= journalNumber %>" class="fontarial">
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>                                                                                                                                                          
                                                                                                </table>
                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>
                                                                                    <table width="80%" border="0" cellspacing="1" cellpadding="1" >                                                        
                                                                                        <tr > 
                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>
                                                                                    <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <%
            if (list != null && list.size() > 0) {
                                                                            %>                                                               
                                                                            <tr> 
                                                                                <td>
                                                                                    <%
                                                                                if (type_document == TYPE_BANK_DEPOSIT) {
                                                                                    %>
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                        <tr>
                                                                                            <td class="fontarial" colspan="8"><b><i><%=langNav[4] %> Belum Diposting</i></b></td>
                                                                                        </tr>    
                                                                                        <tr>
                                                                                            <td width="25" class="tablehdr">No</td>
                                                                                            <td width="50" class="tablehdr"><%=langCT[0]%></td>
                                                                                            <td width="50" class="tablehdr"><%=langCT[2]%></td>
                                                                                            <td width="120" class="tablehdr">Segment</td>
                                                                                            <td width="120" class="tablehdr"><%=langCT[1]%></td>
                                                                                            <td width="120" class="tablehdr"><%=langCT[7]%> IDR</td>
                                                                                            <td class="tablehdr"><%=langCT[4]%></td>
                                                                                            <td width="25" class="tablehdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>                                                        
                                                                                        <%
                                                                                        for (int i = 0; i < list.size(); i++) {

                                                                                            BankDeposit bankDeposit = (BankDeposit) list.get(i);

                                                                                            size++;
                                                                                            Coa coa = new Coa();

                                                                                            try {
                                                                                                coa = DbCoa.fetchExc(bankDeposit.getCoaId());
                                                                                            } catch (Exception e) {
                                                                                                System.out.println("[exception] " + e.toString());
                                                                                            }

                                                                                        %>                                                        
                                                                                        <tr>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="center"><%=(i + 1)%></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="center"><%=bankDeposit.getJournalNumber()%></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="left"><%=coa.getCode() + " - " + coa.getName()%></td> 
                                                                                            <td class="tablearialcell1" style="padding:3px;">
                                                                                                <div align="left"> 
                                                                                                    <%
                                                                                            String segment1 = "";
                                                                                            try {
                                                                                                if (bankDeposit.getSegment1Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment1Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment2Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment2Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment3Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment3Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment4Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment4Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment5Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment5Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment6Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment6Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment7Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment7Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment8Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment8Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment9Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment9Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment10Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment10Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment11Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment11Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment12Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment12Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment13Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment13Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment14Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment14Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bankDeposit.getSegment15Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bankDeposit.getSegment15Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                            } catch (Exception e) {
                                                                                            }

                                                                                            if (segment1.length() > 0) {
                                                                                                segment1 = segment1.substring(0, segment1.length() - 3);
                                                                                            }
                                                                                                    %>
                                                                                                <%=segment1%></div>
                                                                                            </td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="center"><%=JSPFormater.formatDate(bankDeposit.getTransDate(), "dd MMM yyyy")%></td>                                                            
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(bankDeposit.getAmount(), "#,###.##")%></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="left"><%=bankDeposit.getMemo()%></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="center"><input type="checkbox" name="check_<%=bankDeposit.getOID()%>" value="1"></td>
                                                                                        </tr>   
                                                                                        <%
                                                                                            Vector crd = new Vector();
                                                                                            crd = DbBankDepositDetail.list(0, 0, DbBankDepositDetail.colNames[DbBankDepositDetail.COL_BANK_DEPOSIT_ID] + " = " + bankDeposit.getOID(), null);
                                                                                            if (crd != null && crd.size() > 0) {
                                                                                        %>
                                                                                        <tr height="22">
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell1" colspan="6">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr height="20">
                                                                                                        <td class="tablearialcell" align="center" width="25%"><B>Segment</b></td>                                                                        
                                                                                                        <td class="tablearialcell" align="center" ><B>Perkiraan</b></td>
                                                                                                        <td class="tablearialcell" align="center" width="15%"><B>Jumlah</b></td>
                                                                                                        <td class="tablearialcell" align="center" width="30%"><B>Keterangan</b></td>
                                                                                                    </tr>  
                                                                                                    <%
                                                                                            for (int t = 0; t < crd.size(); t++) {
                                                                                                BankDepositDetail cd = (BankDepositDetail) crd.get(t);
                                                                                                Coa c = new Coa();
                                                                                                try {
                                                                                                    c = DbCoa.fetchExc(cd.getCoaId());
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                    %>
                                                                                                    <tr height="20">
                                                                                                        <td class="tablecell" >
                                                                                                            <div align="left"> 
                                                                                                                <%
                                                                                                        String segment = "";
                                                                                                        try {
                                                                                                            if (cd.getSegment1Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment1Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment2Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment2Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment3Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment3Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment4Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment4Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment5Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment5Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment6Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment6Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment7Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment7Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment8Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment8Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment9Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment9Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment10Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment10Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment11Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment11Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment12Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment12Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment13Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment13Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment14Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment14Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment15Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment15Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                        } catch (Exception e) {
                                                                                                        }

                                                                                                        if (segment.length() > 0) {
                                                                                                            segment = segment.substring(0, segment.length() - 3);
                                                                                                        }
                                                                                                                %>
                                                                                                            <%=segment%></div>
                                                                                                        </td>                                                                        
                                                                                                        <td class="tablearialcell" ><%=c.getCode()%> - <%=c.getName()%></td>                                                                        
                                                                                                        <td class="tablearialcell" ><div align="right"><%=JSPFormater.formatNumber(cd.getAmount(), "#,###.##")%>&nbsp;&nbsp;&nbsp;</div></td>                                                                        
                                                                                                        <td class="tablearialcell" >&nbsp;<%=cd.getMemo() %></td>                                                                        
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr>
                                                                                                        <td colspan="4" background="../images/line.gif"><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr>    
                                                                                        
                                                                                        
                                                                                        <%
                                                                                            }
                                                                                        }
                                                                                        %>
                                                                                    </table>                                                    
                                                                                    <%
                                                                                    } else if (type_document == TYPE_BANK_NON_PO_PAYMENT) {
                                                                                    %>
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                        <tr>
                                                                                            <td class="fontarial" colspan="8"><b><i><%=langNav[5] %> Belum Diposting</i></b></td>
                                                                                        </tr>    
                                                                                        <tr>
                                                                                            <td width="25" class="tablehdr">No</td>
                                                                                            <td width="50" class="tablehdr"><%=langCT[0]%></td>
                                                                                            <td width="50" class="tablehdr"><%=langCT[2]%></td>
                                                                                            <td width="120" class="tablehdr">Segment</td>
                                                                                            <td width="120" class="tablehdr"><%=langCT[1]%></td>
                                                                                            <td width="120" class="tablehdr"><%=langCT[7]%> IDR</td>
                                                                                            <td class="tablehdr"><%=langCT[4]%></td>
                                                                                            <td width="25" class="tablehdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr> 
                                                                                        <%
                                                                                        for (int i = 0; i < list.size(); i++) {

                                                                                            BanknonpoPayment bnonP = (BanknonpoPayment) list.get(i);

                                                                                            size++;
                                                                                            Coa coa = new Coa();

                                                                                            try {
                                                                                                coa = DbCoa.fetchExc(bnonP.getCoaId());
                                                                                            } catch (Exception e) {
                                                                                                System.out.println("[exception] " + e.toString());
                                                                                            }
                                                                                        %>                                                                                        
                                                                                        <tr>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="center"><%=(i + 1)%></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="center"><%=bnonP.getJournalNumber()%></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="left"><%=coa.getCode() + " - " + coa.getName()%></td> 
                                                                                            <td class="tablearialcell1" style="padding:3px;">
                                                                                                <div align="left"> 
                                                                                                    <%
                                                                                            String segment1 = "";
                                                                                            try {
                                                                                                if (bnonP.getSegment1Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment1Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment2Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment2Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment3Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment3Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment4Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment4Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment5Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment5Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment6Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment6Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment7Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment7Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment8Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment8Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment9Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment9Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment10Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment10Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment11Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment11Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment12Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment12Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment13Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment13Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment14Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment14Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                                if (bnonP.getSegment15Id() != 0) {
                                                                                                    SegmentDetail sd = DbSegmentDetail.fetchExc(bnonP.getSegment15Id());
                                                                                                    segment1 = segment1 + sd.getName() + " | ";
                                                                                                }
                                                                                            } catch (Exception e) {
                                                                                            }

                                                                                            if (segment1.length() > 0) {
                                                                                                segment1 = segment1.substring(0, segment1.length() - 3);
                                                                                            }
                                                                                                    %>
                                                                                                <%=segment1%></div>
                                                                                            </td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="center"><%=JSPFormater.formatDate(bnonP.getTransDate(), "dd MMM yyyy")%></td>                                                            
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="right"><%=JSPFormater.formatNumber(bnonP.getAmount(), "#,###.##")%></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="left"><%=bnonP.getMemo()%></td>
                                                                                            <td class="tablearialcell1" style="padding:3px;" align="center"><input type="checkbox" name="check_<%=bnonP.getOID()%>" value="1"></td>
                                                                                        </tr>   
                                                                                            <%
                                                                                            Vector crd = new Vector();
                                                                                            crd = DbBanknonpoPaymentDetail.list(0, 0, DbBanknonpoPaymentDetail.colNames[DbBanknonpoPaymentDetail.COL_BANKNONPO_PAYMENT_ID] + " = " + bnonP.getOID(), null);
                                                                                            if (crd != null && crd.size() > 0) {
                                                                                        %>
                                                                                        <tr height="22">
                                                                                            <td class="tablecell"></td>
                                                                                            <td class="tablecell1" colspan="6">
                                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                                    <tr height="20">
                                                                                                        <td class="tablearialcell" align="center" width="25%"><B>Segment</b></td>                                                                        
                                                                                                        <td class="tablearialcell" align="center" ><B>Perkiraan</b></td>
                                                                                                        <td class="tablearialcell" align="center" width="15%"><B>Jumlah</b></td>
                                                                                                        <td class="tablearialcell" align="center" width="30%"><B>Keterangan</b></td>
                                                                                                    </tr>  
                                                                                                    <%
                                                                                            for (int t = 0; t < crd.size(); t++) {
                                                                                                BanknonpoPaymentDetail cd = (BanknonpoPaymentDetail) crd.get(t);
                                                                                                Coa c = new Coa();
                                                                                                try {
                                                                                                    c = DbCoa.fetchExc(cd.getCoaId());
                                                                                                } catch (Exception e) {
                                                                                                }
                                                                                                    %>
                                                                                                    <tr height="20">
                                                                                                        <td class="tablecell" >
                                                                                                            <div align="left"> 
                                                                                                                <%
                                                                                                        String segment = "";
                                                                                                        try {
                                                                                                            if (cd.getSegment1Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment1Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment2Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment2Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment3Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment3Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment4Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment4Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment5Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment5Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment6Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment6Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment7Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment7Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment8Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment8Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment9Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment9Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment10Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment10Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment11Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment11Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment12Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment12Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment13Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment13Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment14Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment14Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                            if (cd.getSegment15Id() != 0) {
                                                                                                                SegmentDetail sd = DbSegmentDetail.fetchExc(cd.getSegment15Id());
                                                                                                                segment = segment + sd.getName() + " | ";
                                                                                                            }
                                                                                                        } catch (Exception e) {
                                                                                                        }

                                                                                                        if (segment.length() > 0) {
                                                                                                            segment = segment.substring(0, segment.length() - 3);
                                                                                                        }
                                                                                                                %>
                                                                                                            <%=segment%></div>
                                                                                                        </td>                                                                        
                                                                                                        <td class="tablearialcell" ><%=c.getCode()%> - <%=c.getName()%></td>                                                                        
                                                                                                        <td class="tablearialcell" ><div align="right"><%=JSPFormater.formatNumber(cd.getAmount(), "#,###.##")%>&nbsp;&nbsp;&nbsp;</div></td>                                                                        
                                                                                                        <td class="tablearialcell" >&nbsp;<%=cd.getMemo() %></td>                                                                        
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr>
                                                                                                        <td colspan="4" background="../images/line.gif"><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                            <td class="tablecell">&nbsp;</td>
                                                                                        </tr> 
                                                                                        <%
}

                                                                                        }
                                                                                        %>
                                                                                    </table>
                                                                                    
                                                                                    <%
                                                                                    }
                                                                                    %>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td height="20px;">&nbsp;</td>
                                                                            </tr>    
                                                                            <%if ((privUpdate || privAdd) && size > 0) {%>
                                                                            <tr>
                                                                                <td align="left"><a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a></td>                                     
                                                                            </tr>    
                                                                            <%}%>
                                                                            <tr>
                                                                                <td height="40px;">&nbsp;</td>
                                                                            </tr>    
                                                                            <% } else {%>
                                                                            <tr>
                                                                                <td >
                                                                                    <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                        <tr> 
                                                                                            <td class="fontarial">
                                                                                                <i>
                                                                                                    <%if (iCommand == JSPCommand.NONE) {%>
                                                                                                    <%=langNav[6]%> 
                                                                                                    <%} else {%>
                                                                                                    <%if (iCommand == JSPCommand.POST) {%>
                                                                                                    <%=langNav[8]%>
                                                                                                    <%} else {%>
                                                                                                    <%=langNav[7]%>
                                                                                                    <%}%>
                                                                                                    <%}%>
                                                                                                </i>
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

