
<%-- 
    Document   : postingsetorankasir
    Created on : Mar 31, 2015, 4:20:25 PM
    Author     : Roy
--%>


<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %> 
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
<%@ page import = "com.project.fms.printing.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.posmaster.Shift" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_SETORAN_KASIR, AppMenu.PRIV_PRINT);
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
            Date tanggal = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date tanggalEnd = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, JspSetoranKasir.colNames[JspSetoranKasir.JSP_LOCATION_ID]);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int ignore = JSPRequestValue.requestInt(request, "ignore");
            long oidDesa = JSPRequestValue.requestLong(request, "hidden_desa_id");

            long oidSelisihSetoran = 0;
            try {
                oidSelisihSetoran = Long.parseLong(DbSystemProperty.getValueByName("OID_COA_SELISIH_KASIR"));
            } catch (Exception e) {
            }

            long oidOffice = 0;
            try {
                oidOffice = Long.parseLong(DbSystemProperty.getValueByName("OID_SEGMENT_OFFICE"));
            } catch (Exception e) {
            }

            Coa credit = new Coa();
            try {
                credit = DbCoa.fetchExc(oidSelisihSetoran);
            } catch (Exception e) {
            }

            if (iJSPCommand == JSPCommand.NONE) {
                ignore = 1;
            }

            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbSetoranKasir.colNames[DbSetoranKasir.COL_POSTED_STATUS] + " = 0";

            if (ignore == 0) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbSetoranKasir.colNames[DbSetoranKasir.COL_TRANSACTION_DATE] + " between '" + JSPFormater.formatDate(tanggal, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(tanggalEnd, "yyyy-MM-dd") + " 23:59:59' ";
            }

            if (locationId != 0) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }

                whereClause = whereClause + DbSetoranKasir.colNames[DbSetoranKasir.COL_LOCATION_ID] + " = " + locationId;
            }

            String orderClause = DbSetoranKasir.colNames[DbSetoranKasir.COL_DATE];
            CmdSetoranKasir ctrlSetoranKasir = new CmdSetoranKasir(request);
            JSPLine ctrLine = new JSPLine();
            Vector listSetoranKasir = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlSetoranKasir.action(iJSPCommand, oidDesa);
            /* end switch*/

            /*count list All Kecamatan*/
            int vectSize = DbSetoranKasir.getCount(whereClause);


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlSetoranKasir.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listSetoranKasir = DbSetoranKasir.list(start, recordToGet, whereClause, orderClause);

            if (iJSPCommand == JSPCommand.POST) {

                if (listSetoranKasir != null && listSetoranKasir.size() > 0) {

                    long oidRp = 0;
                    try {
                        oidRp = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                    } catch (Exception e) {
                    }

                    ExchangeRate er = DbExchangeRate.getStandardRate();
                    for (int i = 0; i < listSetoranKasir.size(); i++) {
                        SetoranKasir sk = (SetoranKasir) listSetoranKasir.get(i);
                        int ck = JSPRequestValue.requestInt(request, "check" + sk.getOID());
                        if (ck == 1) {
                            Periode p = new Periode();
                            try {
                                p = DbPeriode.getPeriodByTransDate(sk.getTransDate());
                            } catch (Exception e) {
                            }
                            if (p.getOID() != 0 && p.getStatus().compareToIgnoreCase(I_Project.STATUS_PERIOD_CLOSED) != 0) {
                                long segmentPendapatan = 0;
                                try {
                                    Vector sd = DbSegmentDetail.list(0, 1, DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + " = " + sk.getLocationId(), null);
                                    if (sd != null && sd.size() > 0) {
                                        SegmentDetail s = (SegmentDetail) sd.get(0);
                                        segmentPendapatan = s.getOID();
                                    }
                                } catch (Exception e) {
                                }

                                if (sk.getCoaId() != 0 && credit.getOID() != 0) {

                                    double totSelisih = DbSetoranKasirDetail.getTotalSelisih(sk.getOID());

                                    if (totSelisih > 0) {

                                        long oid = DbGl.postJournalMain(oidRp, new Date(), sk.getJournalCounter(), sk.getJournalNumber(), sk.getJournalPrefix(),
                                                I_Project.JOURNAL_TYPE_SELISIH_KASIR,
                                                "Pendapatan Selisih Setoran Kasir", user.getOID(),
                                                "", 0, "", sk.getTransDate(), p.getOID());


                                        if (oid != 0) {

                                            
                                            if(totSelisih > 0){
                                            
                                                DbGl.postJournalDetail(er.getValueIdr(), sk.getCoaId(), 0, totSelisih,
                                                    totSelisih, sysCompany.getBookingCurrencyId(), oid, "Pendapatan Selisih Setoran Kasir", 0,
                                                    segmentPendapatan, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);

                                                DbGl.postJournalDetail(er.getValueIdr(), credit.getOID(), totSelisih, 0,
                                                    totSelisih, sysCompany.getBookingCurrencyId(), oid, "Pendapatan Selisih Setoran Kasir", 0,
                                                    segmentPendapatan, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }else{
                                                DbGl.postJournalDetail(er.getValueIdr(), sk.getCoaId(), totSelisih*-1, 0,
                                                    totSelisih, sysCompany.getBookingCurrencyId(), oid, "Pendapatan Selisih Setoran Kasir", 0,
                                                    segmentPendapatan, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);

                                                DbGl.postJournalDetail(er.getValueIdr(), credit.getOID(), 0, totSelisih*-1,
                                                    totSelisih, sysCompany.getBookingCurrencyId(), oid, "Pendapatan Selisih Setoran Kasir", 0,
                                                    segmentPendapatan, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0,
                                                    0, 0, 0, 0);
                                            }

                                            sk.setPostedStatus(1);
                                            sk.setPostedById(user.getOID());
                                            try {
                                                DbSetoranKasir.updateExc(sk);
                                            } catch (Exception e) {
                                            }
                                        }

                                    } else {
                                        sk.setPostedStatus(1);
                                        sk.setPostedById(user.getOID());
                                        try {
                                            DbSetoranKasir.updateExc(sk);
                                        } catch (Exception e) {
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                listSetoranKasir = DbSetoranKasir.list(start, recordToGet, whereClause, orderClause);

            }

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/

            String[] langCT = {"Journal Number", "Period", "Akun", "Date Transaction", "Description"};

            String[] langNav = {"Cash Transaction", "Post Setoran"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor Jurnal", "Periode", "Akun Perkiraan", "Tanggal Transaksi", "Catatan"};
                langCT = langID;

                String[] navID = {"Transaksi Kas", "Posting Setoran"};
                langNav = navID;
            }
%>
<html>
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
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
            
            function setChecked(val){
                 <%
            for (int k = 0; k < listSetoranKasir.size(); k++) {
                SetoranKasir pp = (SetoranKasir) listSetoranKasir.get(k);
                %>
                    document.setorankasir.check<%=pp.getOID()%>.checked=val.checked;
                   <%
            }%>
            
        }
        
        
        function cmdEdit(oidSetoran){                
            document.setorankasir.hidden_setoran_kasir_id.value=oidSetoran;
            document.setorankasir.command.value="<%=JSPCommand.LOAD%>";
            document.setorankasir.prev_command.value="<%=prevJSPCommand%>";
            document.setorankasir.action="postingsetorankasir.jsp";
            document.setorankasir.submit();                
        }
        
        function cmdSearch(){
            document.setorankasir.command.value="<%=JSPCommand.SEARCH%>";
            document.setorankasir.action="postingsetorankasir.jsp?menu_idx=<%=menuIdx%>";
            document.setorankasir.submit();
        }
        
        function cmdPost(){
            document.setorankasir.command.value="<%=JSPCommand.POST%>";
            document.setorankasir.action="postingsetorankasir.jsp?menu_idx=<%=menuIdx%>";
            document.setorankasir.submit();
        }
        
        function cmdListFirst(){
            document.setorankasir.command.value="<%=JSPCommand.FIRST%>";
            document.setorankasir.prev_command.value="<%=JSPCommand.FIRST%>";
            document.setorankasir.action="setorankasir_arsip.jsp";
            document.setorankasir.submit();
        }
        
        function cmdListPrev(){
            document.setorankasir.command.value="<%=JSPCommand.PREV%>";
            document.setorankasir.prev_command.value="<%=JSPCommand.PREV%>";
            document.setorankasir.action="setorankasir_arsip.jsp";
            document.setorankasir.submit();
        }
        
        function cmdListNext(){
            document.setorankasir.command.value="<%=JSPCommand.NEXT%>";
            document.setorankasir.prev_command.value="<%=JSPCommand.NEXT%>";
            document.setorankasir.action="setorankasir_arsip.jsp";
            document.setorankasir.submit();
        }
        
        function cmdListLast(){
            document.setorankasir.command.value="<%=JSPCommand.LAST%>";
            document.setorankasir.prev_command.value="<%=JSPCommand.LAST%>";
            document.setorankasir.action="setorankasir_arsip.jsp";
            document.setorankasir.submit();
        }
        
        //-------------- script form image -------------------
        
        function cmdDelPict(oidBankpopaymentDetail){
            document.frmimage.hidden_bankpopayment_detail_id.value=oidBankpopaymentDetail;
            document.frmimage.command.value="<%=JSPCommand.POST%>";
            document.frmimage.action="bankpayment.jsp";
            document.frmimage.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/savedoc2.gif','../images/close2.gif','../images/post_journal2.gif','../images/print2.gif')">
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
                                                        <form name="setorankasir" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                                        
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_setoran_kasir_id" value="<%=0%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <%try {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="4" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td colspan="4" height="10">
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="80" height="14" nowrap></td>
                                                                                            <td width="2" height="14" nowrap></td>
                                                                                            <td colspan="2" height="14"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td colspan="4" class="fontarial"><b><i>Parameter pencarian :</i></b></td>
                                                                                        </tr>
                                                                                        <tr height="23"> 
                                                                                            <td class="tablecell1" nowrap>&nbsp;&nbsp;Date</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td colspan="2" > 
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((tanggal == null) ? new Date() : tanggal, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.setorankasir.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                        </td>
                                                                                                        <td>&nbsp;&nbsp;to&nbsp;&nbsp;</td>
                                                                                                        <td>
                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((tanggalEnd == null) ? new Date() : tanggalEnd, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.setorankasir.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                        <input type="checkbox" name="ignore" value="1" <%if (ignore == 1) {%> checked<%}%> >
                                                                                                               </td>
                                                                                                        <td class="fontarial">&nbsp;ignore</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="23">
                                                                                            <td class="tablecell1">&nbsp;&nbsp;Location</td>
                                                                                            <td class="fontarial">:</td>
                                                                                            <td colspan="2">
                                                                                                <%
    Vector vLoc = userLocations;
                                                                                                %>          
                                                                                                <select name="<%=JspSetoranKasir.colNames[JspSetoranKasir.JSP_LOCATION_ID] %>" class="fontarial" onChange="javascript:cmdchange()">                                                                                                                                                           
                                                                                                    <option value="0" <%if (0 == locationId) {%>selected<%}%>>- All Location -</option>
                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
        for (int i = 0; i < vLoc.size(); i++) {
            Location us = (Location) vLoc.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                    <%}
    }%>
                                                                                                </select>           
                                                                                            </td>
                                                                                        </tr>  
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="1" valign="middle" colspan="4" > 
                                                                                                <table width="500" border="0" cellspacing="0" cellpadding="0">                                                                                                                
                                                                                                    <tr> 
                                                                                                        <td height="2" background="../images/line.gif" ><img src="../images/line.gif"></td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="4"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>                                                                  </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" height="25">&nbsp;</td>    
                                                                            </tr>
                                                                            <tr> 
                                                                                <td colspan="4" >
                                                                                    <table width="100%">
                                                                                        <tr>
                                                                                            <td width="25" class="tablehdr">No</td>
                                                                                            <td width="150" class="tablehdr">Location</td>
                                                                                            <td width="80" class="tablehdr">Number</td>
                                                                                            <td width="80" class="tablehdr">Date</td>
                                                                                            <td width="120" class="tablehdr">user</td>
                                                                                            <td width="150" class="tablehdr">Acc. Debet</td>
                                                                                            <td width="150" class="tablehdr">Acc. Credit</td>
                                                                                            <td class="tablehdr">Description</td>
                                                                                            <td width="70" class="tablehdr">Total Selisih</td>
                                                                                            <td width="10" class="tablehdr"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></td>
                                                                                        </tr>
                                                                                        <%
    if (listSetoranKasir != null && listSetoranKasir.size() > 0) {

        String style = "";
        for (int i = 0; i < listSetoranKasir.size(); i++) {
            SetoranKasir sk = (SetoranKasir) listSetoranKasir.get(i);
            String strLocation = "";
            String strUser = "";
            try {
                Location l = DbLocation.fetchExc(sk.getLocationId());
                strLocation = l.getName();
            } catch (Exception e) {
            }

            try {
                User u = DbUser.fetch(sk.getOperatorId());
                strUser = u.getFullName();
            } catch (Exception e) {
            }

            String status = "-";
            if (sk.getPostedStatus() == 1) {
                status = "P O S T E D";
            }

            if (i % 2 == 0) {
                style = "tablearialcell";
            } else {
                style = "tablearialcell1";
            }

            double totSelisih = DbSetoranKasirDetail.getTotalSelisih(sk.getOID());

            Coa debet = new Coa();
            try {
                debet = DbCoa.fetchExc(sk.getCoaId());
            } catch (Exception e) {
            }
                                                                                        %>
                                                                                        <tr height="22">
                                                                                            <td class="<%=style%>" align="center"><%=(start + i + 1)%></td>
                                                                                            <td class="<%=style%>"><%=strLocation%></td>
                                                                                            <td class="<%=style%>" align="center"><%=sk.getJournalNumber()%></td>
                                                                                            <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(sk.getTransDate(), "dd-MMM-yyyy") %></td>
                                                                                            <td class="<%=style%>"><%=strUser%></td>
                                                                                            <td class="<%=style%>"><%=debet.getCode()%>-<%=debet.getName()%></td>
                                                                                            <td class="<%=style%>"><%=credit.getCode()%>-<%=credit.getName()%></td>
                                                                                            <td class="<%=style%>"><%=sk.getMemo()%></td>
                                                                                            <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(totSelisih, "###,###.##") %></td>
                                                                                            <td class="<%=style%>" align="center"><input type="checkbox" name="check<%=sk.getOID()%>" value="1"></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }%>
                                                                                        <tr align="left" valign="top" height="30">  
                                                                                            <td height="7" align="left" colspan="3" class="command">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top" height="30">  
                                                                                            
                                                                                            <td height="7" align="left" colspan="3" class="command">
                                                                                                <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        
                                                                                        <%}
                                                                                        %>
                                                                                        
                                                                                        <tr align="left" valign="top" height="30">  
                                                                                            <td height="7" align="left" colspan="3" class="command"> 
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>    
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr> 
                                                            </table>
                                                            <%} catch (Exception e) {
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

