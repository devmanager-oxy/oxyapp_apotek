
<%-- 
    Document   : cash_receive 
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
<%@ page import = "com.project.fms.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_CASH, AppMenu.M2_MN_CP, AppMenu.PRIV_DELETE);       
%>

<%!
    public String getSubstring1(String s) {
        if (s.length() > 60) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 55) + "...</font></a>";
        }
        return s;
    }

    public String getSubstring(String s) {
        if (s.length() > 105) {
            s = "<a href=\"#\" title=\"" + s + "\"><font color=\"black\">" + s.substring(0, 100) + "...</font></a>";
        }
        return s;
    }
%>

<%@ include file="../calendar/calendarframe.jsp"%>

<%
            /*** LANG ***/
            String[] langCT = {"Search for", "Journal Number", "Period", "Input Date", "to", "Transaction Date", "Ignore", //0-6
                "Cash Receipt", "Journal Number", "Receipt to Account", "Receipt from", "Amount IDR", "Transaction Date", "Memo", //7-13
                "Petty Cash Payment", "Journal Number", "Payment from Account", "Amount IDR", "Transaction Date", "Memo", "Activity", //14-20
                "Petty Cash Replenishment", "Journal Number", "Replenishment for Account", "From Account", "Amount IDR", "Transaction Date", "Memo", //21-27
                "Please click on the search button to find your data", "List is empty", "Post Status","Process" //28-30
            };

            String[] langNav = {"Petty Cash", "Cash Payment", "Date", "Cash Receipt", "Payment Petty Cash", "Replenishment Petty Cash","SEARCHING"};

            if (lang == LANG_ID) {
                String[] langID = {"Pencarian", "Nomor Jurnal", "Periode", "Tanggal Dibuat", "sampai", "Tanggal Transaksi", "Abaikan", //0-6
                    "Penerimaan Tunai", "Nomor Jurnal", "Perkiraan Penerimaan", "Diterima dari", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //7-13
                    "Pelunasan Kas Tunai", "Nomor Jurnal", "Pelunasan dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", "Kegiatan", //14-20
                    "Pengisian Kembali Kas Kecil", "Nomor Jurnal", "Pengisian Kembali untuk Perkiraan", "Dari Perkiraan", "Jumlah IDR", "Tanggal Transaksi", "Catatan", //21-27
                    "Silahkan tekan tombol search untuk memulai pencarian data", "Tidak ada data", "Post Status","Proses" //28-30
                };
                langCT = langID;

                String[] navID = {"Kas Kecil", "Pembayaran Tunai", "Tanggal", "Penerimaan Tunai", "Pelunasan Kas Tunai", "Pengisian Kembali Kas Kecil","PENCARIAN"};
                langNav = navID;
            }

            session.removeValue("CASH_PAYMENT");
            
            int iCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCashArchive = JSPRequestValue.requestLong(request, "hidden_casharchive");

            Date startDate = new Date();
            Date endDate = new Date();
            Date transDate = new Date();

            if(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]).length() > 0) {
                startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]), "dd/MM/yyyy");
            }

            if(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]).length() > 0) {
                endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]), "dd/MM/yyyy");
            }

            if(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]).length() > 0) {
                transDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]), "dd/MM/yyyy");
            }

            int recordToGet = 15;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "journal_number";

            CmdCashArchive cmdCashArchive = new CmdCashArchive(request);
            JSPLine jspLine = new JSPLine();
            Vector listCashArchive = new Vector(1, 1);
            CashArchive cashArchive = new CashArchive();
            JspCashArchive jspCashArchive = new JspCashArchive(request, cashArchive);

            int ignoreInputDate = JSPRequestValue.requestInt(request, jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_INPUT_DATE]);
            int ignoreTransDate = JSPRequestValue.requestInt(request, jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_TRANSACTION_DATE]);

            if (iCommand == JSPCommand.NONE || iCommand == JSPCommand.BACK){
                ignoreTransDate = 1;
                ignoreInputDate = 1;
            }

            iErrCode = cmdCashArchive.action(iCommand, oidCashArchive);

            jspCashArchive.requestEntityObject(cashArchive);

            cashArchive = jspCashArchive.getEntityObject();
            cashArchive.setStartDate(startDate);
            cashArchive.setEndDate(endDate);
            cashArchive.setTransactionDate(transDate);
            cashArchive.setSearchFor("paymentpettycash");

            msgString = cmdCashArchive.getMessage();

            if (cashArchive.getIgnoreTransactionDate() == 0) {
                whereClause = "trans_date = '" + JSPFormater.formatDate(cashArchive.getTransactionDate(), "yyyy-MM-dd") + "'";
            }

            if (!cashArchive.getJournalNumber().equals("")){
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "journal_number like '%" + cashArchive.getJournalNumber() + "%'";
            }

            if(cashArchive.getPeriodeId() != 0){
                
                Periode periode = new Periode();
                
                try {
                    periode = DbPeriode.fetchExc(cashArchive.getPeriodeId());
                } catch (Exception e) {
                    System.out.println("[exception] "+e.toString());
                }
                
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                
                whereClause = whereClause + "trans_date between '" + periode.getStartDate() + "' and '" + periode.getEndDate() + "'";
                
            }
            
            if (cashArchive.getIgnoreInputDate() == 0){
                
                if (whereClause != "") {
                    whereClause = whereClause + " and ";
                }
                
                whereClause = whereClause + "trans_date between '" + JSPFormater.formatDate(cashArchive.getStartDate(), "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(cashArchive.getEndDate(), "yyyy-MM-dd") + "'";
            }

            int vectSize = 0;         
       
                
            if(whereClause != null && whereClause.length() > 0){
                
                whereClause = whereClause + " AND "+DbPettycashPayment.colNames[DbPettycashPayment.COL_STATUS]+"="+DbPettycashPayment.STATUS_TYPE_POSTED;
                
            }else{
                
                whereClause = DbPettycashPayment.colNames[DbPettycashPayment.COL_STATUS]+"="+DbPettycashPayment.STATUS_TYPE_POSTED;
                
            }    
            
            vectSize = DbPettycashPayment.getCount(whereClause);
            

            if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) ||
                    (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                start = cmdCashArchive.actionList(iCommand, start, vectSize, recordToGet);
            }

            listCashArchive = DbPettycashPayment.list(start, recordToGet, whereClause, orderClause);
            
            session.putValue("CASH_PAYMENT", listCashArchive);
            
            double tot = 0;
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" -->
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script type="text/javascript">    
            hs.graphicsDir = '../highslide/graphics/';
            hs.outlineType = 'rounded-white';
            hs.outlineWhileAnimating = true;
        </script>
        <script type="text/javascript">
            hs.graphicsDir = '../highslide/graphics/';        
            
            hs.captionId = 'the-caption';
            
            hs.outlineType = 'rounded-white';
        </script>        
        <!--Begin Region JavaScript-->
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdResetStart(){
                document.frmcasharchive.start.value="0";	
            }
            
            function cmdSearch(){
                document.frmcasharchive.start.value="0";	
                document.frmcasharchive.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmcasharchive.prev_command.value="<%=prevCommand%>";
                document.frmcasharchive.action="cash_receive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdEditReceipt(oidReceive){
                document.frmcasharchive.hidden_casharchive.value=oidReceive;
                document.frmcasharchive.action="cash_receive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdEditPayment(oidPayment){
                document.frmcasharchive.hidden_casharchive.value=oidPayment;
                document.frmcasharchive.action="pettycashpaymentdetailprint.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdEditReplenishment(oidReplenishment){
                document.frmcasharchive.hidden_casharchive.value=oidReplenishment;
                document.frmcasharchive.action="pettycashreplenishmentconfirmprint.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListFirst(){
                document.frmcasharchive.command.value="<%=JSPCommand.FIRST%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmcasharchive.action="cash_receive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListPrev(){
                document.frmcasharchive.command.value="<%=JSPCommand.PREV%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcasharchive.action="cash_receive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListNext(){
                document.frmcasharchive.command.value="<%=JSPCommand.NEXT%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcasharchive.action="cash_receive.jsp";
                document.frmcasharchive.submit();
            }
            
            function cmdListLast(){
                document.frmcasharchive.command.value="<%=JSPCommand.LAST%>";
                document.frmcasharchive.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcasharchive.action="cash_receive.jsp";
                document.frmcasharchive.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                                            <!-- #BeginEditable "menu" --><%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "&nbsp;&nbsp;<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcasharchive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevCommand%>">
                                                            <input type="hidden" name="hidden_casharchive" value="<%=oidCashArchive%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <!--DWLayoutTable-->
                                                                            <tr align="left" valign="top"> 
                                                                                <td width="100%" height="127" valign="top"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td height="23"><b><u><%=langNav[6]%></u></b></td>
                                                                                            <td colspan="3" valign="top"> 
                                                                                                <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></div>
                                                                                            </td>
                                                                                        </tr>
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
                                                                                                        <td width="13%">
                                                                                                            <%=langCT[1]%>
                                                                                                        </td>
                                                                                                        <td width="26%"> 
                                                                                                           <input type="text" name="<%=jspCashArchive.colNames[jspCashArchive.JSP_JOURNAL_NUMBER] %>"  value="<%= cashArchive.getJournalNumber() %>">
                                                                                                        </td>
                                                                                                        <td width="10%"><%=langCT[3]%></td>
                                                                                                        <td width="51%">
                                                                                                            <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getStartDate() == null ? new Date() : cashArchive.getStartDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> <%=langCT[4]%> 
                                                                                                            <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getEndDate() == null ? new Date() : cashArchive.getEndDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>                                                                                                        
                                                                                                            <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_INPUT_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (ignoreInputDate == 1) {%>checked<%}%>>
                                                                                                            <%=langCT[6]%> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="13%"><%=langCT[2]%></td>
                                                                                                        <td width="26%"> 
                                                                                                            <select name="<%=jspCashArchive.colNames[JspCashArchive.JSP_PERIODE_ID]%>" class="formElemen">
                                                                                                                <option value="0" <%if(cashArchive.getPeriodeId() == 0){%> selected <%}%> >All period..</option>
                                                                                                            <%
                                                                                                            
                                                                                                            
            Vector p = new Vector(1, 1);
            p = DbPeriode.list(0, 0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE]+" DESC ");                                                                                                
            
            Vector p_value = new Vector(1, 1);
            Vector p_key = new Vector(1, 1);
            String sel_p = "" + cashArchive.getPeriodeId();
            if (p != null && p.size() > 0) {
                for (int i = 0; i < p.size(); i++) {
                    Periode period = (Periode) p.get(i);
                    %>
                        <option value="<%=period.getOID()%>" <%if(cashArchive.getPeriodeId() == period.getOID()){%> selected <%}%> ><%=period.getName().trim()%></option>
                    <%
                }
            }
                                                                                                            %>
                                                                                                        </select>
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                             
                                                                                                        </td>
                                                                                                        <td width="10%"><%=langCT[5]%></td>
                                                                                                        <td width="51%"> 
                                                                                                        <input name="<%=JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((cashArchive.getTransactionDate() == null ? new Date() : cashArchive.getTransactionDate()), "dd/MM/yyyy")%>" size="11" readOnly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcasharchive.<%=JspCashArchive.colNames[JspCashArchive.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>
                                                                                                        
                                                                                                        <input name="<%=jspCashArchive.colNames[jspCashArchive.JSP_IGNORE_TRANSACTION_DATE] %>" type="checkBox" class="formElemen"  value="1" <%if (ignoreTransDate == 1) {%>checked<%}%>>
                                                                                                               <%=langCT[6]%> </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="1">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4"> <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
            if (listCashArchive != null && listCashArchive.size() > 0) {
                if (!cashArchive.getSearchFor().equals("")) {
                    
                    if (cashArchive.getSearchFor().equals("cashreceive") && cashRecPriv){
                                                                            %>
                                                                            <tr> 
                                                                                <td><font size="3"><b><font size="2"><span class="level1"><%=langCT[7]%></span></font></b></font></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="3"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="6%" class="tablehdr"><%=langCT[8]%></td>
                                                                                            <td height="26" width="13%" class="tablehdr"><%=langCT[9]%></td>
                                                                                            <td width="9%" class="tablehdr"><%=langCT[10]%></td>
                                                                                            <td width="9%" class="tablehdr"><%=langCT[11]%></td>
                                                                                            <td width="20%" class="tablehdr"><%=langCT[12]%></td>
                                                                                            <td width="34%" class="tablehdr"><%=langCT[13]%></td>
                                                                                            <td width="9%" class="tablehdr"><%=langCT[30]%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                            for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                                
                                                                                                CashReceive bd = (CashReceive) listCashArchive.get(i);

                                                                                                Coa coa = new Coa();
                                                                                                try {
                                                                                                    coa = DbCoa.fetchExc(bd.getCoaId());
                                                                                                } catch (Exception e) {
                                                                                                }

                                                                                                Employee em = new Employee();
                                                                                                try {
                                                                                                    em = DbEmployee.fetchExc(bd.getReceiveFromId());
                                                                                                } catch (Exception e) {}
                                                                                                
                                                                                                if (i % 2 != 0) {													
%>
                                                                                        <tr> 
                                                                                            <td class="tablecell" width="6%"><a href="javascript:cmdEditReceipt('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                                                                            <td class="tablecell" width="13%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell" width="9%"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                                                                            <td class="tablecell" width="9%"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell" width="20%"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                                                                            </td>
                                                                                            <td class="tablecell" width="34%"><%=getSubstring(bd.getMemo())%></td>
                                                                                            <td class="tablecell" width="9%"> 
                                                                                                <div align="center"><%=I_Fms.statusPosting[lang][bd.getPostedStatus()]%></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
%>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" width="6%"><a href="javascript:cmdEditReceipt('<%=bd.getOID()%>')"><%=bd.getJournalNumber()%></a></td>
                                                                                            <td class="tablecell1" width="13%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell1" width="9%"><%=em.getEmpNum() + " - " + em.getName()%></td>
                                                                                            <td class="tablecell1" width="9%"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(bd.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="20%"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(bd.getTransDate())%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="34%"><%=getSubstring(bd.getMemo())%></td>
                                                                                            <td class="tablecell1" width="9%"> 
                                                                                                <div align="center"><%=I_Fms.statusPosting[lang][bd.getPostedStatus()]%></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                        int cmd = 0;
                                                                                        if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                            cmd = iCommand;
                                                                                        } else {
                                                                                            if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                                cmd = JSPCommand.FIRST;
                                                                                            } else {
                                                                                                cmd = prevCommand;
                                                                                            }
                                                                                        }
                                                                                        jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                        jspLine.initDefault();

                                                                                        jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                        jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                        jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                        jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                        jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                        jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                        jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                        jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%
                                                                                    } else if (cashArchive.getSearchFor().equals("paymentpettycash") && cashPayPriv){
                                                                            %>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="3"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="8%" class="tablehdr"><%=langCT[15]%></td>
                                                                                            <td height="26" width="16%" class="tablehdr"><%=langCT[16]%></td>
                                                                                            <td width="17%" class="tablehdr"><%=langCT[17]%></td>
                                                                                            <td width="12%" class="tablehdr"><%=langCT[18]%></td>
                                                                                            <td width="29%" class="tablehdr"><%=langCT[19]%></td>                                                                                            
                                                                                            <td width="8%" class="tablehdr"><%=langCT[30]%></td>
                                                                                            <td width="8%" class="tablehdr"><%=langCT[31]%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                            
                                                                                            for (int i = 0; i < listCashArchive.size(); i++) {
                                                                                                
                                                                                                PettycashPayment pp = (PettycashPayment) listCashArchive.get(i);

                                                                                                Coa coa = new Coa();
                                                                                                try {
                                                                                                    coa = DbCoa.fetchExc(pp.getCoaId());
                                                                                                } catch (Exception e) {
                                                                                                    System.out.println("[exception] "+e.toString());
                                                                                                }
                                                                                                
                                                                                                tot = tot + pp.getAmount();
                                                                                                
                                                                                                if (i % 2 != 0) {
%>
                                                                                        <tr> 
                                                                                            <td class="tablecell" width="8%"><%=pp.getJournalNumber()%></td>
                                                                                            <td class="tablecell" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell" width="17%"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell" width="12%"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(pp.getTransDate())%></div>
                                                                                            </td>
                                                                                            <td class="tablecell" width="29%"><%=getSubstring(pp.getMemo())%></td>
                                                                                            <td class="tablecell" width="8%"> 
                                                                                                <div align="center"><%=I_Fms.statusPosting[lang][pp.getPostedStatus()]%></div>                                                                                                
                                                                                            </td>
                                                                                            <td class="tablecell" width="8%" align=center>
                                                                                                <div align="center"><a href="<%=approot%>/transaction/cash_receive_detail.jsp?menu_idx=1&hidden_pettycash_payment_id=<%=pp.getOID()%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ok','','../images/ok2.gif',1)"><img src="../images/ok.gif" name="ok" width="49" height="22" border="0"></a></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
%>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" width="8%"><%=pp.getJournalNumber()%></td>
                                                                                            <td class="tablecell1" width="16%"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell1" width="17%"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(pp.getAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="12%"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(pp.getTransDate())%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="29%"><%=getSubstring(pp.getMemo())%></td>
                                                                                            <td class="tablecell1" width="8%"> 
                                                                                                <div align="center"><%=I_Fms.statusPosting[lang][pp.getPostedStatus()]%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1" width="8%"> 
                                                                                                <div align="center"><a href="<%=approot%>/transaction/cash_receive_detail.jsp?menu_idx=1&hidden_pettycash_payment_id=<%=pp.getOID()%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ok','','../images/ok2.gif',1)"><img src="../images/ok.gif" name="ok" width="49" height="22" border="0"></a></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
                                                                                                }
                                                                                            }
                                                                                        %>  
                                                                                        <tr> 
                                                                                            <td colspan="2" align="center" bgcolor="#FF9900">T O T A L</td>
                                                                                            <td bgcolor="#FF9900"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(tot, "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td colspan ="4" bgcolor="#FF9900">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%    
                                                                                        }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                        int cmd = 0;
                                                                                        if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                            cmd = iCommand;
                                                                                        } else {
                                                                                            if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                                cmd = JSPCommand.FIRST;
                                                                                            } else {
                                                                                                cmd = prevCommand;
                                                                                            }
                                                                                        }
                                                                                        jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                        jspLine.initDefault();

                                                                                        jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                        jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                        jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                        jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                        jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                        jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                        jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                        jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%if (listCashArchive != null && listCashArchive.size() > 0){%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="100%">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="100%">
                                                                                    <%
    out.print("<a href=\"../freport/cashpayment_priview.jsp\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('prt','','../images/printdoc2.gif',1)\" onclick=\"return hs.htmlExpand(this,{objectType: 'ajax'})\"><img src=\"../images/printdoc.gif\" name=\"prt\" height=\"22\" border=\"0\"></a></div>");
                                                                                                %>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%
                                                                                    }else if (cashArchive.getSearchFor().equals("paymentreplenishmentcash")) {
                                                                            %>
                                                                            <tr> 
                                                                                <td><font size="3"><b><font size="2"><span class="level1"><%=langCT[21]%></span></font></b></font></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="3"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="7%" class="tablehdr"><%=langCT[22]%></td>
                                                                                            <td height="26" width="20%" class="tablehdr"><%=langCT[23]%></td>
                                                                                            <td width="20%" class="tablehdr"><%=langCT[24]%></td>
                                                                                            <td width="13%" class="tablehdr"><%=langCT[25]%></td>
                                                                                            <td width="7%" class="tablehdr"><%=langCT[26]%></td>
                                                                                            <td width="33%" class="tablehdr"><%=langCT[27]%></td>
                                                                                            <td width="27%" class="tablehdr"><%=langCT[27]%></td>
                                                                                            <td width="5%" class="tablehdr"><%=langCT[31]%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                        if (listCashArchive != null && listCashArchive.size() > 0) {
                                                                                            
                                                                                            for (int i = 0; i < listCashArchive.size(); i++){
                                                                                                
                                                                                                PettycashReplenishment pr = (PettycashReplenishment) listCashArchive.get(i);

                                                                                                Coa coa = new Coa();
                                                                                                try {
                                                                                                    coa = DbCoa.fetchExc(pr.getReplaceCoaId());
                                                                                                } catch (Exception e) {
                                                                                                }

                                                                                                Coa coax = new Coa();
                                                                                                try {
                                                                                                    coax = DbCoa.fetchExc(pr.getReplaceFromCoaId());
                                                                                                } catch (Exception e) {
                                                                                                    System.out.println("[exception] "+e.toString());
                                                                                                }

                                                                                                if (i % 2 != 0){													
%>
                                                                                        <tr> 
                                                                                            <td class="tablecell"><a href="javascript:cmdEditReplenishment('<%=pr.getOID()%>')"><%=pr.getJournalNumber()%></a></td>
                                                                                            <td class="tablecell"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell"><%=coax.getCode() + " - " + coax.getName()%></td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(pr.getReplaceAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(pr.getTransDate(), "dd-MMM-yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell"><%=getSubstring1(pr.getMemo())%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                } else {
%>
                                                                                        <tr> 
                                                                                            <td class="tablecell1"><a href="javascript:cmdEditReplenishment('<%=pr.getOID()%>')"><%=pr.getJournalNumber()%></a></td>
                                                                                            <td class="tablecell1"><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                            <td class="tablecell1"><%=coax.getCode() + " - " + coax.getName()%></td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(pr.getReplaceAmount(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="center"><%=JSPFormater.formatDate(pr.getTransDate(), "dd-MMM-yyyy")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1"><%=getSubstring1(pr.getMemo())%></td>
                                                                                        </tr>
                                                                                        <%
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        %>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" align="left" colspan="7" class="command" width="99%"> 
                                                                                    <span class="command"> 
                                                                                        <%
                                                                                        int cmd = 0;
                                                                                        if ((iCommand == JSPCommand.FIRST || iCommand == JSPCommand.PREV) || (iCommand == JSPCommand.NEXT || iCommand == JSPCommand.LAST)) {
                                                                                            cmd = iCommand;
                                                                                        } else {
                                                                                            if (iCommand == JSPCommand.NONE || prevCommand == JSPCommand.NONE) {
                                                                                                cmd = JSPCommand.FIRST;
                                                                                            } else {
                                                                                                cmd = prevCommand;
                                                                                            }
                                                                                        }
                                                                                        jspLine.setLocationImg(approot + "/images/ctr_line");
                                                                                        jspLine.initDefault();

                                                                                        jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
                                                                                        jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
                                                                                        jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
                                                                                        jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

                                                                                        jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
                                                                                        jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
                                                                                        jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
                                                                                        jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                        %>
                                                                                <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%
                                                                                    }
                                                                                }
                                                                            } else {
                                                                            %>
                                                                            <tr> 
                                                                                <td class="boxed1"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="8" class="tablehdr" height="21">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" colspan="8" height="25"> 
                                                                                                <%if (iCommand == JSPCommand.NONE) {%>
                                                                                                <%=langCT[28]%> 
                                                                                                <%} else {%>
                                                                                                <%=langCT[29]%> 
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%
            }
                                                                            %>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="1%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                <%if (iCommand == JSPCommand.NONE) {%>
                                                                //cmdSearch();	
                                                                <%}%>
                                                            </script>
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
                                <!-- #BeginEditable "footer" --><%@ include file="../main/footer.jsp"%><!-- #EndEditable -->
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
