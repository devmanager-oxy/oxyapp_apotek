
<%--
    Document   : budgetrequest
    Created on : Feb 29, 2016, 4:07:13 PM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.crm.project.*" %>
<%@ page import = "com.project.crm.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%@ include file="../calendar/calendarframe.jsp"%>
<%@ page import = "com.project.I_Project" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_REQUEST);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_REQUEST, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_REQUEST, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_REQUEST, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_BUDGET, AppMenu.M2_MENU_BUDGET_REQUEST, AppMenu.PRIV_DELETE);
%>
<%!
    public static String getAccountRecursif(int minus, Coa coa, long oid, boolean isPostableOnly) {
        int level = 0;
        String result = "";
        if (!coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
            Vector coas = DbCoa.list(0, 0, "acc_ref_id=" + coa.getOID(), "code");
            if (coas != null && coas.size() > 0) {
                for (int i = 0; i < coas.size(); i++) {
                    Coa coax = (Coa) coas.get(i);
                    String str = "";
                    if (!isPostableOnly) {
                        level = coax.getLevel() + minus;
                        switch (level) {
                            case 0:
                                break;
                            case 1:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 2:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 3:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 4:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                            case 5:
                                str = str + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                                break;
                        }
                    }

                    result = result + "<option value=\"" + coax.getOID() + "\"" + ((oid == coax.getOID()) ? "selected" : "") + ">" + str + coax.getCode() + " - " + coax.getName() + "</option>";

                    if (!coax.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                        result = result + getAccountRecursif(minus, coax, oid, isPostableOnly);
                    }
                }
            }
        }
        return result;
    }
%>

<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long oidBudgetRequest = JSPRequestValue.requestLong(request, "hidden_budget_request_id");
            long oidBudgetRequestDetail = JSPRequestValue.requestLong(request, "hidden_budget_request_detail_id");
            long uniqKeyId = JSPRequestValue.requestLong(request, "hidden_uniq_key_id");
            int recIdx = JSPRequestValue.requestInt(request, "select_idx");
            int showAll = JSPRequestValue.requestInt(request, "show_all");

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                recIdx = -1;
            }

            String msgString = "";
            int iErrCode = JSPMessage.NONE;


            CmdBudgetRequest ctrlBudgetRequest = new CmdBudgetRequest(request);
            ctrlBudgetRequest.setUserId(user.getOID());
            ctrlBudgetRequest.setUniqKeyId(uniqKeyId);
            JSPLine ctrLine = new JSPLine();

            int iErrCodeRec = ctrlBudgetRequest.action(iJSPCommand, oidBudgetRequest);
            JspBudgetRequest jspBudgetRequest = ctrlBudgetRequest.getForm();

            BudgetRequest budgetRequest = ctrlBudgetRequest.getBudgetRequest();
            String msgStringRec = ctrlBudgetRequest.getMessage();
            if (oidBudgetRequest == 0) {
                oidBudgetRequest = budgetRequest.getOID();
            }

            // Budget Request Detail
            Vector listBudgetRequestDetail = new Vector(1, 1);
            CmdBudgetRequestDetail ctrlBudgetRequestDetail = new CmdBudgetRequestDetail(request);
            ctrlBudgetRequestDetail.setBudgetRequestId(budgetRequest.getOID());
            ctrlBudgetRequestDetail.setUserId(user.getOID());
            iErrCode = ctrlBudgetRequestDetail.action(iJSPCommand, oidBudgetRequestDetail);
            JspBudgetRequestDetail jspBudgetRequestDetail = ctrlBudgetRequestDetail.getForm();
            BudgetRequestDetail budgetRequestDetail = ctrlBudgetRequestDetail.getBudgetRequestDetail();
            msgString = ctrlBudgetRequestDetail.getMessage();

            if (iJSPCommand == JSPCommand.REFRESH && recIdx == -1) {
                iJSPCommand = JSPCommand.ADD;
            }

            if (budgetRequest.getOID() != 0) {
                listBudgetRequestDetail = DbBudgetRequestDetail.list(0, 0, DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID] + " = " + budgetRequest.getOID(), DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_DATE]);
            }

            if (iJSPCommand == JSPCommand.SAVE && iErrCodeRec == 0 && iErrCode == 0) {
                budgetRequestDetail = new BudgetRequestDetail();
            }

            /*** LANG ***/
            String[] langBudget = {"Number", "Date Transaction", "Location", "Department", "Period"};
            String[] langBudgetItem = {"Number", "Account Name", "Description", "Request", "Used", "Total Used", "Budget YTD", "Balance"};
            String[] langNav = {"Budget", "Budget Request"};
            String[] langApp = {"Document Status", "Squence", "Position/Level", "Tanggal", "Approval Date", "Status", "Notes", "Action"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor", "Tanggal Transaksi", "Lokasi", "Department", "Periode"};
                langBudget = langID;
                String[] langBudgetItemID = {"No.", "Nama Akun", "Keterangan", "Diajukan Sekarang", "Sudah Terpakai", "Total Terpakai", "Budget YTD", "Selisih"};
                langBudgetItem = langBudgetItemID;
                String[] navID = {"Anggaran", "Pengajuan Anggaran"};
                langNav = navID;
                String[] langAppID = {"Status Dokumen", "Urutan", "Posisi/Level", "Oleh", "Tanggal", "Status", "Catatan", "Tindakan"};
                langApp = langAppID;
            }

            Vector segment1s = DbSegmentUser.userSegments(user.getOID(), 0);
            Vector departments = DbDepartment.list(0, 0, "", DbDepartment.colNames[DbDepartment.COL_NAME]);
            Vector budgetCoas = DbAccLink.getLinkCoas(I_Project.ACC_LINK_ACCOUNT_BUDGET_EXPENSE, 0);
            long selectedSegment1Id = 0;


            boolean checkItem = false;
            if (budgetCheckedPriv && (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_APPROVED)) {
                checkItem=true;
            }


            if (iJSPCommand == JSPCommand.SAVE && (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_CHECKED)) {
                
                Vector bDetail = DbBudgetRequestDetail.list(0, 0, DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID] + "=" + oidBudgetRequest, "");
                if (bDetail != null && bDetail.size() > 0) {
                    for (int ix = 0; ix < bDetail.size(); ix++) {
                        BudgetRequestDetail bd = (BudgetRequestDetail) bDetail.get(ix);
                        int budDetail = JSPRequestValue.requestInt(request, "check_" + bd.getOID());
                        System.out.println("check_" + bd.getOID());
                        if (budDetail==1){
                            DbBudgetRequestDetail.updateCheckedDetail(bd.getOID());
                        }
                    }
                }
            }
            if (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_CHECKED){
                listBudgetRequestDetail = DbBudgetRequestDetail.list(0, 0, DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_BUDGET_REQUEST_ID] + " = " + budgetRequest.getOID() + " and " + DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_STATUS] + "='1'", DbBudgetRequestDetail.colNames[DbBudgetRequestDetail.COL_DATE]);
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>

            function cmdUnShowAll(){
                document.frmbudgetrequest.command.value="<%=JSPCommand.LIST%>";
                document.frmbudgetrequest.show_all.value=0;
                document.frmbudgetrequest.action="budgetrequest.jsp";
                document.frmbudgetrequest.submit();
            }

            function cmdShowAll(){
                document.frmbudgetrequest.command.value="<%=JSPCommand.LIST%>";
                document.frmbudgetrequest.show_all.value=1;
                document.frmbudgetrequest.action="budgetrequest.jsp";
                document.frmbudgetrequest.submit();
            }

            function cmdAskDoc(oidBudgetRequestDetail){
                document.frmbudgetrequest.hidden_budget_request_detail_id.value=oidBudgetRequestDetail;
                document.frmbudgetrequest.command.value="<%=JSPCommand.ASK%>";
                document.frmbudgetrequest.action="budgetrequest.jsp";
                document.frmbudgetrequest.submit();
            }

            function cmdDeleteDoc(oidBudgetRequestDetail){
                document.frmbudgetrequest.hidden_budget_request_detail_id.value=oidBudgetRequestDetail;
                document.frmbudgetrequest.command.value="<%=JSPCommand.DELETE%>";
                document.frmbudgetrequest.action="budgetrequest.jsp";
                document.frmbudgetrequest.submit();
            }

            function cmdPrint(){
                window.open("<%=printroot%>.report.RptRequestBudgetPDF?reqBudId=<%=budgetRequest.getOID()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }


            function cmdRefresh(){
                document.frmbudgetrequest.command.value="<%=JSPCommand.REFRESH%>";
                document.frmbudgetrequest.action="budgetrequest.jsp";
                document.frmbudgetrequest.submit();
            }

            function cmdReload(oidBudgetRequestDetail){
                document.frmbudgetrequest.hidden_budget_request_detail_id.value=oidBudgetRequestDetail;
                document.frmbudgetrequest.command.value="<%=JSPCommand.LOAD%>";
                document.frmbudgetrequest.action="budgetrequest.jsp";
                document.frmbudgetrequest.submit();
            }


            function cmdEdit(oidBudgetRequestDetail){
                document.frmbudgetrequest.select_idx.value=oidBudgetRequestDetail;
                document.frmbudgetrequest.hidden_budget_request_detail_id.value=oidBudgetRequestDetail;
                document.frmbudgetrequest.command.value="<%=JSPCommand.EDIT%>";
                document.frmbudgetrequest.action="budgetrequest.jsp";
                document.frmbudgetrequest.submit();
            }

            function cmdBack(){
                document.frmbudgetrequest.hidden_budget_request_detail_id.value=0;
                document.frmbudgetrequest.command.value="<%=JSPCommand.BACK%>";
                document.frmbudgetrequest.action="budgetrequest.jsp";
                document.frmbudgetrequest.submit();
            }

            var sysDecSymbol = "<%=sSystemDecimalSymbol%>"; var usrDigitGroup = "<%=sUserDigitGroup%>"; var usrDecSymbol = "<%=sUserDecimalSymbol%>";

            function removeChar(number){
                var ix; var result = "";
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


        function cmdSave(){
            document.frmbudgetrequest.command.value="<%=JSPCommand.SAVE%>";
            document.frmbudgetrequest.action="budgetrequest.jsp";
            document.frmbudgetrequest.submit();
        }

        function cmdRequest(){

            var favailable = document.frmbudgetrequest.available.value;
            favailable = cleanNumberFloat(favailable, sysDecSymbol, usrDigitGroup, usrDecSymbol);

            var fused = document.frmbudgetrequest.budget_used.value;
            fused = cleanNumberFloat(fused, sysDecSymbol, usrDigitGroup, usrDecSymbol);

            var famount = document.frmbudgetrequest.<%=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_REQUEST]%>.value;
            famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);

            var fbudget = document.frmbudgetrequest.budget_mtd.value;
            fbudget = cleanNumberFloat(fbudget, sysDecSymbol, usrDigitGroup, usrDecSymbol);

            var persen = 0;
            if(parseFloat(famount) > parseFloat(favailable)){
                alert("Request melebihi budget yang tersedia. Klik OK untuk melanjutkan");
                if(parseFloat(fbudget)!= 0){
                    persen = parseFloat(favailable)/parseFloat(fbudget)*100;
                }
                document.frmbudgetrequest.persen_request.value= formatFloat(parseFloat(persen), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                //document.frmbudgetrequest.<%--=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_REQUEST]--%>.value= formatFloat(parseFloat(favailable), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);

                var selisih = parseFloat(fbudget) - parseFloat(favailable) - parseFloat(fused);
                var persenSelisih = 0;
                if(parseFloat(fbudget)!= 0){
                    persenSelisih = parseFloat(selisih)/parseFloat(fbudget)*100;
                }
                document.frmbudgetrequest.persen_selisih.value= formatFloat(parseFloat(persenSelisih), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                document.frmbudgetrequest.selisih.value= formatFloat(parseFloat(selisih), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);

            }else{

            if(parseFloat(fbudget)!= 0){
                persen = parseFloat(famount)/parseFloat(fbudget)*100;
            }
            document.frmbudgetrequest.persen_request.value= formatFloat(parseFloat(persen), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            document.frmbudgetrequest.<%=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_REQUEST]%>.value= formatFloat(parseFloat(famount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);

            var selisih = parseFloat(fbudget) - parseFloat(famount) - parseFloat(fused);
            var persenSelisih = 0;
            if(parseFloat(fbudget)!= 0){
                persenSelisih = parseFloat(selisih)/parseFloat(fbudget)*100;
            }
            document.frmbudgetrequest.persen_selisih.value= formatFloat(parseFloat(persenSelisih), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            document.frmbudgetrequest.selisih.value= formatFloat(parseFloat(selisih), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
        }
    }

    function MM_swapImgRestore() { //v3.0
        var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
    }
    function MM_preloadImages() { //v3.0
        var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
    }

    function MM_findObj(n, d) { //v4.01
        var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
        if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
        for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
        if(!x && d.getElementById) x=d.getElementById(n); return x;
    }

    function MM_swapImage() { //v3.0
        var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
        if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
    }
    //-->
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                            <tr>
                                                                <td valign="top">
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                                                                        <tr>
                                                                            <td valign="top">
                                                                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                                                                    <!--DWLayoutTable-->
                                                                                    <tr>
                                                                                        <td>
                                                                                            <form id="form1" name="frmbudgetrequest" method="post" action="">
                                                                                                <input type="hidden" name="command">
                                                                                                <input type="hidden" name="hidden_budget_request_detail_id" value="<%=oidBudgetRequestDetail%>">
                                                                                                <input type="hidden" name="hidden_budget_request_id" value="<%=oidBudgetRequest%>">
                                                                                                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                <input type="hidden" name="select_idx" value="<%=recIdx%>">
                                                                                                <input type="hidden" name="show_all" value="0">
                                                                                                <input type="hidden" name="hidden_uniq_key_id" value="<%=uniqKeyId%>">
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr>
                                                                                                        <td class="container">
                                                                                                            <table>
                                                                                                                <tr>
                                                                                                                    <td width="100" class="tablecell1" style="padding:3px;"><%=langBudget[0]%></td>
                                                                                                                    <td width="2" class="fontarial">:</td>
                                                                                                                    <%
            Vector periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            String strNumber = "";
            Periode open = new Periode();
            if (budgetRequest.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(budgetRequest.getPeriodeId());
                } catch (Exception e) {
                }
            } else {
                if (periods != null && periods.size() > 0) {
                    open = (Periode) periods.get(0);
                }
            }
            int counterJournal = DbSystemDocNumber.getNextCounterSynch(open.getOID(), DbSystemDocCode.TYPE_DOCUMENT_BUDGET);
            strNumber = DbSystemDocNumber.getNextNumber(counterJournal, open.getOID(), DbSystemDocCode.TYPE_DOCUMENT_BUDGET);
            if (budgetRequest.getOID() != 0 || oidBudgetRequest != 0) {
                strNumber = budgetRequest.getJournalNumber();
            }


                                                                                                                    %>

                                                                                                                    <input type="hidden" name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_JOURNAL_NUMBER]%>">
                                                                                                                    <input type="hidden" name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_JOURNAL_COUNTER]%>">
                                                                                                                    <input type="hidden" name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_JOURNAL_PREFIX]%>">
                                                                                                                    <td width="350"><%=strNumber%></td>
                                                                                                                    <td width="100" class="tablecell1" style="padding:3px;">
                                                                                                                        <%if (periods.size() > 1) {%>
                                                                                                                        <%=langBudget[4]%>
                                                                                                                        <%} else {%>
                                                                                                                        &nbsp;
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="2" class="fontarial">:</td>
                                                                                                                    <td>
                                                                                                                        <%if (open.getStatus().equals("Closed") || budgetRequest.getOID() != 0) {%>
                                                                                                                        <%=open.getName()%>
                                                                                                                        <input type="hidden" name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                                                                        <%} else {%>
                                                                                                                        <%if (periods.size() > 1) {%>
                                                                                                                        <select name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_PERIODE_ID]%>">
                                                                                                                            <%
    if (periods != null && periods.size() > 0) {
        for (int t = 0; t < periods.size(); t++) {
            Periode objPeriod = (Periode) periods.get(t);

                                                                                                                            %>
                                                                                                                            <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == budgetRequest.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                            <%}%><%}%>
                                                                                                                        </select>
                                                                                                                        <%} else {%>
                                                                                                                        <input type="hidden" name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_PERIODE_ID]%>" value="<%=open.getOID()%>">
                                                                                                                        <%}
            }%>

                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" style="padding:3px;"><%=langBudget[1]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td>
                                                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <input name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_TRANS_DATE] %>" value="<%=JSPFormater.formatDate((budgetRequest.getTransDate() == null) ? new Date() : budgetRequest.getTransDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmbudgetrequest.<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_TRANS_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                                                </td>
                                                                                                                                <td valign="top">&nbsp;<%=jspBudgetRequest.getErrorMsg(jspBudgetRequest.JSP_TRANS_DATE) %></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" style="padding:3px;"><%=langBudget[2]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td class="fontarial">
                                                                                                                        <%if (budgetRequest.getOID() != 0) {%>
                                                                                                                        <input type="hidden" name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_SEGMENT1_ID]%>" value="<%=budgetRequest.getSegment1Id()%>">
                                                                                                                        <%
    SegmentDetail sd = new SegmentDetail();
    try {
        sd = DbSegmentDetail.fetchExc(budgetRequest.getSegment1Id());
    } catch (Exception e) {
    }
                                                                                                                        %>
                                                                                                                        <%=sd.getName()%>
                                                                                                                        <%} else {%>
                                                                                                                        <select name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_SEGMENT1_ID]%>" onChange="javascript:cmdRefresh()">
                                                                                                                            <%
    if (segment1s != null && segment1s.size() > 0) {
        for (int i = 0; i < segment1s.size(); i++) {
            SegmentDetail sd = (SegmentDetail) segment1s.get(i);
            if (i == 0) {
                selectedSegment1Id = sd.getOID();
            }

                                                                                                                            %>
                                                                                                                            <option value="<%=sd.getOID()%>" <%if (budgetRequest.getSegment1Id() == sd.getOID()) {%>selected<%}%>><%=sd.getName()%></option>
                                                                                                                            <%}

                                                                                                                            } else {%>
                                                                                                                            <option value="<%=0%>" <%if (budgetRequest.getSegment1Id() == 0) {%>selected<%}%>>-</option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" style="padding:3px;"><%=langBudget[3]%></td>
                                                                                                                    <td class="fontarial">:</td>
                                                                                                                    <td>
                                                                                                                        <select name="<%=jspBudgetRequest.colNames[jspBudgetRequest.JSP_DEPARTMENT_ID]%>">
                                                                                                                            <%
            if (departments != null && departments.size() > 0) {
                for (int i = 0; i < departments.size(); i++) {
                    Department dept = (Department) departments.get(i);

                                                                                                                            %>
                                                                                                                            <option value="<%=dept.getOID()%>" <%if (budgetRequest.getDepartmentId() == dept.getOID()) {%>selected<%}%>><%=dept.getName()%></option>
                                                                                                                            <%}

                                                                                                                            } else {%>
                                                                                                                            <option value="<%=0%>" <%if (budgetRequest.getDepartmentId() == 0) {%>selected<%}%>>-</option>
                                                                                                                            <%}%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="container">
                                                                                                            <table cellpadding="0" cellspacing="1" border="0">
                                                                                                                <tr height="24">
                                                                                                                    <td class="tablearialhdr" width="25"><%=langBudgetItem[0]%></td>
                                                                                                                    <td class="tablearialhdr" width="200"><%=langBudgetItem[1]%></td>
                                                                                                                    <td class="tablearialhdr" width="150"><%=langBudgetItem[2]%></td>
                                                                                                                    <td class="tablearialhdr" width="100"><%=langBudgetItem[3]%></td>
                                                                                                                    <td class="tablearialhdr" width="30">%</td>
                                                                                                                    <td class="tablearialhdr" width="100"><%=langBudgetItem[4]%></td>
                                                                                                                    <td class="tablearialhdr" width="30">%</td>

                                                                                                                    <td class="tablearialhdr" width="100"><%=langBudgetItem[6]%></td>
                                                                                                                    <td class="tablearialhdr" width="30">%</td>
                                                                                                                    <td class="tablearialhdr" width="100"><%=langBudgetItem[7]%></td>
                                                                                                                    <td class="tablearialhdr" width="30">%</td>
                                                                                                                    <%if (checkItem){%><td class="tablearialhdr"><input type="checkbox" name="checkAll"></td><%}%>
                                                                                                                </tr>
                                                                                                                <%
            int no = 1;
            if (listBudgetRequestDetail != null && listBudgetRequestDetail.size() > 0) {
                for (int i = 0; i < listBudgetRequestDetail.size(); i++) {

                    BudgetRequestDetail brd = (BudgetRequestDetail) listBudgetRequestDetail.get(i);

                    String cssName = "tablecell";
                    if (i % 2 != 0) {
                        cssName = "tablecell1";
                    }

                    if (((iJSPCommand == JSPCommand.REFRESH || iJSPCommand == JSPCommand.LOAD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) || (iJSPCommand == JSPCommand.SUBMIT && iErrCode != 0)) && oidBudgetRequestDetail == brd.getOID()) {

                        if (brd.getCoaId() != budgetRequestDetail.getCoaId()) {
                            budgetRequestDetail.setRequest(0);
                        } else {
                            budgetRequestDetail.setRequest(brd.getRequest());
                        }

                        double budgetYTD = 0;
                        double budgetUsed = 0;
                        double persenBudgetUsed = 0;
                        try {
                            //budgetUsed = DbBudgetRequestDetail.getBudgetUsed(brd.getOID(), budgetRequest.getTransDate(), budgetRequest.getSegment1Id(), budgetRequestDetail.getCoaId());
                            budgetUsed = DbBudgetRequestDetail.getTerpakai(brd.getCoaId(), budgetRequest.getPeriodeId(), budgetRequest.getSegment1Id(), budgetRequest.getOID(), brd.getDate());
                            //budgetUsed = budgetUsed + brd.getRequest();
                        } catch (Exception e) {
                        }

                        try {
                            budgetYTD = DbCoaBudget.getBudgetYTD(budgetRequest.getTransDate().getYear() + 1900, budgetRequestDetail.getCoaId(), budgetRequest.getSegment1Id());
                        } catch (Exception e) {
                            System.out.println("[exception] " + e.toString());
                        }

                        double selisih = budgetYTD - budgetRequestDetail.getRequest() - budgetUsed;
                        double persenSelisih = 0;
                        if (budgetYTD != 0) {
                            persenSelisih = selisih / budgetYTD * 100;
                        }

                        double persenRequest = 0;
                        if (budgetYTD != 0) {
                            persenRequest = budgetRequestDetail.getRequest() / budgetYTD * 100;
                        }

                        if (budgetYTD != 0) {
                            persenBudgetUsed = budgetUsed / budgetYTD * 100;
                        }
                        double available = budgetYTD - budgetUsed;

                                                                                                                %>
                                                                                                                <input type="hidden" name="<%=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_BUDGET_REQUEST_DETAIL_ID]%>" value="<%=brd.getOID()%>" >
                                                                                                                <input type="hidden" name="<%=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_BUDGET_REQUEST_ID]%>" value="<%=brd.getBudgetRequestId()%>" >
                                                                                                                <input type="hidden" name="available" value="<%=JSPFormater.formatNumber(available, "#,###.##")%>" >
                                                                                                                <tr height="24">
                                                                                                                    <td class="<%=cssName%>" align="center"><%=no%>.</td>
                                                                                                                    <td class="<%=cssName%>">
                                                                                                                        <select name="<%=JspBudgetRequestDetail.colNames[JspBudgetRequestDetail.JSP_COA_ID]%>" onChange="javascript:cmdReload('<%=brd.getOID()%>')">
                                                                                                                            <%if (budgetCoas != null && budgetCoas.size() > 0) {
                                                                                                                                for (int x = 0; x < budgetCoas.size(); x++) {
                                                                                                                                    Coa coax = (Coa) budgetCoas.get(x);
                                                                                                                                    String str = "";
                                                                                                                            %>
                                                                                                                            <option value="<%=coax.getOID()%>" <%if (budgetRequestDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coax.getLevel() * -1, coax, budgetRequestDetail.getCoaId(), isPostableOnly)%>
                                                                                                                            <%}
                                                                                                                            }%>
                                                                                                                        </select>
                                                                                                                        <%= jspBudgetRequestDetail.getErrorMsg(JspBudgetRequestDetail.JSP_COA_ID)%>
                                                                                                                    </td>
                                                                                                                    <td class="<%=cssName%>">
                                                                                                                        <table>
                                                                                                                            <tr>
                                                                                                                                <td><input type="text" name="<%=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_MEMO]%>" size="22" value="<%=budgetRequestDetail.getMemo()%>" ></td>
                                                                                                                                <td class="fontarial">*)</td>
                                                                                                                                <td><%= jspBudgetRequestDetail.getErrorMsg(jspBudgetRequestDetail.JSP_MEMO) %></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;">
                                                                                                                        <input type="text" name="<%=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_REQUEST]%>" size="15" value="<%=JSPFormater.formatNumber(budgetRequestDetail.getRequest(), "#,###.##")%>" style="text-align:right;padding-right:3px;" onChange="javascript:cmdRequest()">
                                                                                                                        <%= jspBudgetRequestDetail.getErrorMsg(jspBudgetRequestDetail.JSP_REQUEST) %>
                                                                                                                    </td>
                                                                                                                    <td class="<%=cssName%>" align="center"><input type="text" name="persen_request" class="readOnly" readonly value="<%=JSPFormater.formatNumber(persenRequest, "#,###.##")%>" size="3" style="text-align:right;padding-right:3px;"></td>
                                                                                                                    <td class="<%=cssName%>"><input type="text" name="budget_used" class="readOnly" readonly value="<%=JSPFormater.formatNumber(budgetUsed, "#,###.##")%>" size="13" style="text-align:right;padding-right:3px;"></td>
                                                                                                                    <td class="<%=cssName%>"><input type="text" name="persen_budget_used" class="readOnly" readonly value="<%=JSPFormater.formatNumber(persenBudgetUsed, "#,###.##")%>" size="3" style="text-align:right;padding-right:3px;"></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;"><input type="text" name="budget_mtd" class="readOnly" readonly value="<%=JSPFormater.formatNumber(budgetYTD, "###,###.##")%>" size="13" style="text-align:right;"></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(100, "###,###.##")%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;"><input type="text" name="selisih" class="readOnly" readonly value="<%=JSPFormater.formatNumber(selisih, "###,###.##")%>" size="13" style="text-align:right;"></td>
                                                                                                                    <td class="<%=cssName%>"><input type="text" name="persen_selisih" class="readOnly" readonly value="<%=JSPFormater.formatNumber(persenSelisih, "#,###.##")%>" size="3" style="text-align:right;padding-right:3px;"></td>

                                                                                                                </tr>
                                                                                                                <%
                                                                                                                        } else {
                                                                                                                            Coa c = new Coa();
                                                                                                                            try {
                                                                                                                                if (brd.getCoaId() != 0) {
                                                                                                                                    c = DbCoa.fetchExc(brd.getCoaId());
                                                                                                                                }
                                                                                                                            } catch (Exception e) {
                                                                                                                            }


                                                                                                                            double budgetYTD = 0;
                                                                                                                            double budgetUsed = 0;
                                                                                                                            double persenBudgetUsed = 0;
                                                                                                                            try {
                                                                                                                                //budgetUsed = DbBudgetRequestDetail.getBudgetUsed(brd.getOID(), budgetRequest.getTransDate(), budgetRequest.getSegment1Id(), brd.getCoaId());
                                                                                                                                budgetUsed = DbBudgetRequestDetail.getTerpakai(brd.getCoaId(), budgetRequest.getPeriodeId(), budgetRequest.getSegment1Id(), budgetRequest.getOID(), brd.getDate());
                                                                                                                                //budgetUsed = budgetUsed + brd.getRequest();
                                                                                                                            } catch (Exception e) {
                                                                                                                            }

                                                                                                                            try {
                                                                                                                                budgetYTD = DbCoaBudget.getBudgetYTD(budgetRequest.getTransDate().getYear() + 1900, brd.getCoaId(), budgetRequest.getSegment1Id());
                                                                                                                            } catch (Exception e) {
                                                                                                                                System.out.println("[exception] " + e.toString());
                                                                                                                            }

                                                                                                                            double selisih = budgetYTD - brd.getRequest() - budgetUsed;
                                                                                                                            double persenSelisih = 0;
                                                                                                                            if (budgetYTD != 0) {
                                                                                                                                persenSelisih = selisih / budgetYTD * 100;
                                                                                                                            }

                                                                                                                            double persenRequest = 0;
                                                                                                                            if (budgetYTD != 0) {
                                                                                                                                persenRequest = brd.getRequest() / budgetYTD * 100;
                                                                                                                            }

                                                                                                                            if (budgetYTD != 0) {
                                                                                                                                persenBudgetUsed = budgetUsed / budgetYTD * 100;
                                                                                                                            }


                                                                                                                            String fontColor="";
                                                                                                                            if (brd.getRequest()>budgetYTD){
                                                                                                                                fontColor="color: #CC0000;font-weight: bold; font-style: italic;";
                                                                                                                            }
                                                                                                                %>
                                                                                                                <tr height="24">
                                                                                                                    <td class="<%=cssName%>" align="center"><%=no%>.</td>
                                                                                                                    <td class="<%=cssName%>" align="left" style="padding:3px;<%=fontColor%>">
                                                                                                                        <%if(budgetRequest.getStatus()==DbBudgetRequest.DOC_STATUS_DRAFT || checkItem){%><a href="javascript:cmdEdit('<%=brd.getOID()%>')"><%}%>
                                                                                                                        <%=c.getCode()%> - <%=c.getName()%>
                                                                                                                        <%if(budgetRequest.getStatus()==DbBudgetRequest.DOC_STATUS_DRAFT || checkItem){%></a><%}%>
                                                                                                                        <%

                                                                                                                        %>
                                                                                                                    </td>
                                                                                                                    <td class="<%=cssName%>" align="left" style="padding:3px; <%=fontColor%>"><%=brd.getMemo()%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><%=JSPFormater.formatNumber(brd.getRequest(), "#,###.##")%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><%=JSPFormater.formatNumber(persenRequest, "#,###.##")%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><%=JSPFormater.formatNumber(budgetUsed, "#,###.##")%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><%=JSPFormater.formatNumber(persenBudgetUsed, "#,###.##")%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><%=JSPFormater.formatNumber(budgetYTD, "###,###.##")%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><%=JSPFormater.formatNumber(100.00, "###,###.##")%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><%=JSPFormater.formatNumber(selisih, "###,###.##")%></td>
                                                                                                                    <td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><%=JSPFormater.formatNumber(persenSelisih, "###,###.##")%></td>
                                                                                                                    <%if (checkItem){%><td class="<%=cssName%>" align="right" style="padding:3px;<%=fontColor%>"><input type="checkbox" value="1" name="check_<%=brd.getOID()%>"></td><%}%>
                                                                                                                </tr>
                                                                                                                <%
                    }
                    no++;
                }
            }


            if ((budgetRequestDetail.getOID() == 0 && budgetRequest.getStatus()==DbBudgetRequest.DOC_STATUS_DRAFT)|| checkItem) {
                long selectCoaId = budgetRequestDetail.getCoaId();


                                                                                                                %>
                                                                                                                <tr height="24">
                                                                                                                    <td class="tablearialcell" align="center"><%=no%>.</td>
                                                                                                                    <td class="tablearialcell">
                                                                                                                        <select name="<%=JspBudgetRequestDetail.colNames[JspBudgetRequestDetail.JSP_COA_ID]%>" onChange="javascript:cmdRefresh()">
                                                                                                                            <%if (budgetCoas != null && budgetCoas.size() > 0) {
                                                                                                                for (int x = 0; x < budgetCoas.size(); x++) {
                                                                                                                    Coa coax = (Coa) budgetCoas.get(x);
                                                                                                                    if (x == 0 && budgetRequestDetail.getCoaId() == 0) {
                                                                                                                        selectCoaId = coax.getOID();
                                                                                                                    }
                                                                                                                    String str = "";
                                                                                                                            %>
                                                                                                                            <option value="<%=coax.getOID()%>" <%if (budgetRequestDetail.getCoaId() == coax.getOID()) {%>selected<%}%>><%=str + coax.getCode() + " - " + coax.getName()%></option>
                                                                                                                            <%=getAccountRecursif(coax.getLevel() * -1, coax, budgetRequestDetail.getCoaId(), isPostableOnly)%>
                                                                                                                            <%}
                                                                                                            }%>
                                                                                                                        </select>
                                                                                                                    <%= jspBudgetRequestDetail.getErrorMsg(JspBudgetRequestDetail.JSP_COA_ID)%> </td>
                                                                                                                    <td class="tablearialcell">
                                                                                                                        <table>
                                                                                                                            <tr>
                                                                                                                                <td><input type="text" name="<%=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_MEMO]%>" size="22" value="<%=budgetRequestDetail.getMemo()%>" ></td>
                                                                                                                                <td class="fontarial">*)</td>
                                                                                                                                <td><%= jspBudgetRequestDetail.getErrorMsg(jspBudgetRequestDetail.JSP_MEMO) %></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    <td class="tablearialcell">
                                                                                                                        <input type="text" name="<%=jspBudgetRequestDetail.colNames[jspBudgetRequestDetail.JSP_REQUEST]%>" size="15" value="<%=JSPFormater.formatNumber(budgetRequestDetail.getRequest(), "#,###.##")%>" style="text-align:right;padding-right:3px;" onChange="javascript:cmdRequest()">
                                                                                                                        <%= jspBudgetRequestDetail.getErrorMsg(jspBudgetRequestDetail.JSP_REQUEST) %>
                                                                                                                    </td>
                                                                                                                    <%
                                                                                                            double budgetYTD = 0;
                                                                                                            try {
                                                                                                                if (budgetRequest.getSegment1Id() == 0) {
                                                                                                                    budgetYTD = DbCoaBudget.getBudgetYTD(new Date().getYear() + 1900, selectCoaId, selectedSegment1Id);

                                                                                                                } else {
                                                                                                                    budgetYTD = DbCoaBudget.getBudgetYTD(budgetRequest.getTransDate().getYear() + 1900, budgetRequestDetail.getCoaId(), budgetRequest.getSegment1Id());

                                                                                                                }
                                                                                                            } catch (Exception e) {
                                                                                                                System.out.println("[exception] " + e.toString());
                                                                                                            }

                                                                                                            double persenRequest = 0;
                                                                                                            if (budgetYTD != 0) {
                                                                                                                persenRequest = budgetRequestDetail.getRequest() / budgetYTD * 100;
                                                                                                            }

                                                                                                            double budgetUsed = 0;
                                                                                                            try {
                                                                                                                //budgetUsed = DbBudgetRequestDetail.getBudgetUsed(0, budgetRequest.getTransDate(), budgetRequest.getSegment1Id(), selectCoaId);
                                                                                                                budgetUsed = DbBudgetRequestDetail.getTerpakai(budgetRequestDetail.getCoaId(), budgetRequest.getPeriodeId(), budgetRequest.getSegment1Id(), budgetRequest.getOID(), new Date());
                                                                                                                //budgetUsed = budgetUsed + budgetRequestDetail.getRequest();
                                                                                                            } catch (Exception e) {
                                                                                                            }
                                                                                                            double persenBudgetUsed = 0;
                                                                                                            if (budgetYTD != 0) {
                                                                                                                persenBudgetUsed = budgetUsed / budgetYTD * 100;
                                                                                                            }

                                                                                                            double selisih = budgetYTD - budgetRequestDetail.getRequest() - budgetUsed;
                                                                                                            double persenSelisih = 0;
                                                                                                            if (budgetYTD != 0) {
                                                                                                                persenSelisih = selisih / budgetYTD * 100;
                                                                                                            }
                                                                                                            double available = budgetYTD - budgetUsed;
                                                                                                                    %>
                                                                                                                    <input type="hidden" name="available" value="<%=JSPFormater.formatNumber(available, "#,###.##")%>" >
                                                                                                                    <td class="tablearialcell" align="center"><input type="text" name="persen_request" class="readOnly" readonly value="<%=JSPFormater.formatNumber(persenRequest, "#,###.##")%>" size="3" style="text-align:right;padding-right:3px;"></td>
                                                                                                                    <td class="tablearialcell"><input type="text" name="budget_used" class="readOnly" readonly value="<%=JSPFormater.formatNumber(budgetUsed, "#,###.##")%>" size="13" style="text-align:right;padding-right:3px;"></td>
                                                                                                                    <td class="tablearialcell"><input type="text" name="persen_budget_used" class="readOnly" readonly value="<%=JSPFormater.formatNumber(persenBudgetUsed, "#,###.##")%>" size="3" style="text-align:right;padding-right:3px;"></td>
                                                                                                                    <td class="tablearialcell" align="right" style="padding:3px;"><input type="text" name="budget_mtd" class="readOnly" readonly value="<%=JSPFormater.formatNumber(budgetYTD, "###,###.##")%>" size="13" style="text-align:right;"></td>
                                                                                                                    <td class="tablearialcell" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(100.00, "###,###.##")%></td>
                                                                                                                    <td class="tablearialcell" align="right" style="padding:3px;"><input type="text" name="selisih" class="readOnly" readonly value="<%=JSPFormater.formatNumber(selisih, "###,###.##")%>" size="13" style="text-align:right;"></td>
                                                                                                                    <td class="tablearialcell"><input type="text" name="persen_selisih" class="readOnly" readonly value="<%=JSPFormater.formatNumber(persenSelisih, "#,###.##")%>" size="3" style="text-align:right;padding-right:3px;"></td>

                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr>
                                                                                                                    <td colspan="11">
                                                                                                                        &nbsp;
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%if (iJSPCommand == JSPCommand.ASK) {%>
                                                                                                                <tr>
                                                                                                                    <td colspan="11">Are you sure to delete document ?</td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="11">
                                                                                                                        <table>
                                                                                                                            <tr>
                                                                                                                                <td width="100"><a href="javascript:cmdDeleteDoc('<%=String.valueOf(budgetRequestDetail.getOID())%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('yes21111','','../images/yes2.gif',1)"><img src="../images/yes.gif" name="yes21111" height="21" border="0"></a></td>
                                                                                                                                <td width="100"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel211111','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel211111" height="22" border="0"></a></td>

                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="11">
                                                                                                                        &nbsp;
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%if (budgetRequest.getOID() != 0){%>
                                                                                                                <%if (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_DRAFT || budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_APPROVED || budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_CANCEL) {%>
                                                                                                                <tr>
                                                                                                                    <td colspan="11" height="30">
                                                                                                                        <table>
                                                                                                                            <tr>
                                                                                                                                <td class="fontarial" width="100">Status Dokumen</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td>
                                                                                                                                    <select name="<%=jspBudgetRequest.colNames[JspBudgetRequest.JSP_STATUS]%>">
                                                                                                                                        <%if (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_DRAFT || budgetRequest.getStatus()==DbBudgetRequest.DOC_STATUS_CANCEL) {%>
                                                                                                                                        <option value="<%=DbBudgetRequest.DOC_STATUS_DRAFT%>" <%if (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_DRAFT) {%>selected<%}%>><%=DbBudgetRequest.strStatusDocument[DbBudgetRequest.DOC_STATUS_DRAFT]%></option>
                                                                                                                                        <%}%>
                                                                                                                                        <%if (budgetApprovePriv && (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_DRAFT || budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_APPROVED)) {%>
                                                                                                                                        <option value="<%=DbBudgetRequest.DOC_STATUS_APPROVED%>" <%if (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_APPROVED) {%>selected<%}%>><%=DbBudgetRequest.strStatusDocument[DbBudgetRequest.DOC_STATUS_APPROVED]%></option>
                                                                                                                                        <%}%>
                                                                                                                                        <%if (budgetCheckedPriv && (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_APPROVED || budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_CHECKED )) {%>
                                                                                                                                        <option value="<%=DbBudgetRequest.DOC_STATUS_CHECKED%>" <%if (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_CHECKED) {%>selected<%}%>><%=DbBudgetRequest.strStatusDocument[DbBudgetRequest.DOC_STATUS_CHECKED]%></option>
                                                                                                                                        <%}%>
                                                                                                                                        <option value="<%=DbBudgetRequest.DOC_STATUS_CANCEL%>" <%if (budgetRequest.getStatus() == DbBudgetRequest.DOC_STATUS_CANCEL) {%>selected<%}%>><%=DbBudgetRequest.strStatusDocument[DbBudgetRequest.DOC_STATUS_CANCEL]%></option>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="11" height="30">
                                                                                                                        &nbsp;
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}else{%>
                                                                                                                <tr>
                                                                                                                    <td colspan="11" height="30">
                                                                                                                        <table>
                                                                                                                            <tr>
                                                                                                                                <td class="fontarial" width="100">Status Dokumen</td>
                                                                                                                                <td class="fontarial">:</td>
                                                                                                                                <td class="fontarial"><b><i>
                                                                                                                                    <input type="hidden" name="<%=jspBudgetRequest.colNames[JspBudgetRequest.JSP_STATUS]%>" value="<%=budgetRequest.getStatus()%>">
                                                                                                                                    <%=DbBudgetRequest.strStatusDocument[budgetRequest.getStatus()]%>
                                                                                                                                    </i></b>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="11" height="30">
                                                                                                                        &nbsp;
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                                <tr>
                                                                                                                    <td colspan="11">
                                                                                                                        <table border="0">
                                                                                                                            <tr>
                                                                                                                                <%if(budgetRequest.getStatus()==DbBudgetRequest.DOC_STATUS_DRAFT || budgetRequest.getStatus()==DbBudgetRequest.DOC_STATUS_CANCEL || (budgetCheckedPriv && budgetRequest.getStatus()==DbBudgetRequest.DOC_STATUS_APPROVED)){%>
                                                                                                                                <td width="150"><a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/savenew2.gif',1)"><img src="../images/savenew.gif" name="savedoc21" height="22" border="0" width="116"></a></td>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <%}%>
                                                                                                                                <td width="80"><a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" height="22" border="0" ></a></td>
                                                                                                                                <%if (budgetRequestDetail.getOID() != 0) {%>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td width="80"><div align="left"><a href="javascript:cmdAskDoc('<%=String.valueOf(budgetRequestDetail.getOID())%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div></td>
                                                                                                                                <%}%>
                                                                                                                                <%if (budgetRequest.getOID() != 0){%>
                                                                                                                                <td>&nbsp;</td>
                                                                                                                                <td width="80"><a href="javascript:cmdPrint()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/print2.gif',1)"><img src="../images/print.gif" name="back" height="22" border="0" ></a></td>
                                                                                                                                <%}%>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="11" height="30">
                                                                                                                        &nbsp;
                                                                                                                    </td>
                                                                                                                </tr>

                                                                                                                <%
            if (budgetRequest.getOID() != 0) {
                String name = "-";
                String date = "";
                try {
                    User u = DbUser.fetch(budgetRequest.getUserId());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    name = e.getName();
                } catch (Exception e) {
                }
                try {
                    date = JSPFormater.formatDate(budgetRequest.getDate(), "dd MMM yyyy");
                } catch (Exception e) {
                }


                String postedName = "";
                String postedDate = "";
                try {
                    User u = DbUser.fetch(budgetRequest.getApproval1Id());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    postedName = e.getName();
                } catch (Exception e) {
                }
                try {
                    if (budgetRequest.getApproval1Date() != null) {
                        postedDate = JSPFormater.formatDate(budgetRequest.getApproval1Date(), "dd MMM yyyy");
                    }
                } catch (Exception e) {
                    postedDate = "";
                }

                //================================================ checked by ===========
                String checkedName = "";
                String checkedDate = "";
                try {
                    User u = DbUser.fetch(budgetRequest.getApproval2Id());
                    Employee e = DbEmployee.fetchExc(u.getEmployeeId());
                    checkedName = e.getName();
                } catch (Exception e) {
                }
                try {
                    if (budgetRequest.getApproval2Date() != null) {
                        checkedDate = JSPFormater.formatDate(budgetRequest.getApproval2Date(), "dd MMM yyyy");
                    }
                } catch (Exception e) {
                    checkedDate = "";
                }

                                                                                                                %>
                                                                                                                <tr align="left" valign="top">
                                                                                                                    <td valign="middle" colspan="11">
                                                                                                                        <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="20" class="fontarial"><b><i><%=langApp[0]%></i></b> </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td width="100" height="20" bgcolor="#F3F3F3" class="fontarial"><b><font size="1"><%=langApp[5]%></font></b></td>
                                                                                                                                <td height="20" bgcolor="#F3F3F3" class="fontarial"><b><font size="1"><%=langApp[3]%></font></b></td>
                                                                                                                                <td width="100" height="20" bgcolor="#F3F3F3" class="fontarial" nowrap><b><font size="1"><%=langApp[4]%></font></b></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="20" class="fontarial" ><font size="1">Diajukan Oleh</font></td>
                                                                                                                                <td height="20"  class="fontarial" ><font size="1"><%=name%></font></td>
                                                                                                                                <td height="20"  class="fontarial" nowrap><font size="1"><%=date%></font></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="20" class="fontarial"><font size="1">Diketahui</font></td>
                                                                                                                                <td height="20" class="fontarial"><font size="1"><%=postedName%></font></td>
                                                                                                                                <td height="20" class="fontarial" nowrap><font size="1"><%=postedDate%></font></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td height="20" class="fontarial"><font size="1">Diperiksa</font></td>
                                                                                                                                <td height="20" class="fontarial"><font size="1"><%=checkedName%></font></td>
                                                                                                                                <td height="20" class="fontarial" nowrap><font size="1"><%=checkedDate%></font></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <tr>
                                                                                                                    <td colspan="11" height="40">
                                                                                                                        &nbsp;
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="11">
                                                                                                                        <table width="800" >
                                                                                                                            <tr>
                                                                                                                                <td class="fontarial"><i><b>History Data</b></i></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i><b></td>
                                                                                                                                <td width="470" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i><b></td>
                                                                                                                                <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>By</i><b></td>
                                                                                                                            </tr>
                                                                                                                            <%
            int max = 10;
            if (showAll == 1) {
                max = 0;
            }
            int countx = DbHistoryBudget.getCount(DbHistoryBudget.colNames[DbHistoryBudget.COL_REF_ID] + " = " + budgetRequest.getOID());

            Vector historys = DbHistoryBudget.list(0, max, DbHistoryBudget.colNames[DbHistoryBudget.COL_REF_ID] + " = " + budgetRequest.getOID(), DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
            if (historys != null && historys.size() > 0) {

                for (int r = 0; r < historys.size(); r++) {
                    HistoryBudget hu = (HistoryBudget) historys.get(r);

                    Employee e = new Employee();
                    try {
                        e = DbEmployee.fetchExc(hu.getEmployeeId());
                    } catch (Exception ex) {
                    }
                    String name = "-";
                    if (e.getName() != null && e.getName().length() > 0) {
                        name = e.getName();
                    }

                    String desc = hu.getDescription();

                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td class="fontarial" style=padding:3px;><%=JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss ")%></td>
                                                                                                                                <td class="fontarial" style=padding:3px;><i><%=desc%></i></td>
                                                                                                                                <td class="fontarial" style=padding:3px;><%=name%></td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                }

                                                                                                                            } else {
                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" class="fontarial" style=padding:3px;><i>No history available</i></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                                                            </tr>
                                                                                                                            <%
            if (countx > max) {
                if (showAll == 0) {
                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdShowAll()"><i>Show All History (<%=countx%>) Data</i></a></td>
                                                                                                                            </tr>
                                                                                                                            <%
                                                                                                                                } else {
                                                                                                                            %>
                                                                                                                            <tr>
                                                                                                                                <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdUnShowAll()"><i>Show By Limit</i></a></td>
                                                                                                                            </tr>
                                                                                                                            <%
                }
            }%>
                                                                                                                        </table>

                                                                                                                    </td>
                                                                                                                </tr>

                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </form>
                                                                                        </td>

                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    <!-- #EndEditable --> </td>
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
                            <td height="25"> <!-- #BeginEditable "footer" -->
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
 