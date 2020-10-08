
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
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_GL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAkrualSetup = JSPRequestValue.requestLong(request, "hidden_akrual_setup_id");
            long periodId = JSPRequestValue.requestLong(request, "period");
            Date transactionDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "transaction_date"), "dd/MM/yyyy");

            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbAkrualSetup.colNames[DbAkrualSetup.COL_STATUS] + " = " + DbAkrualSetup.STATUS_AKRUAL_AKTIF;
            String orderClause = "";

            CmdAkrualSetup ctrlAkrualSetup = new CmdAkrualSetup(request);
            JSPLine ctrLine = new JSPLine();
            Vector listAkrualSetup = new Vector(1, 1);

            JspAkrualSetup jspAkrualSetup = ctrlAkrualSetup.getForm();

            /*count list All AkrualSetup*/
            int vectSize = DbAkrualSetup.getCount(whereClause);

            /*switch list AkrualSetup*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlAkrualSetup.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            AkrualSetup akrualSet = ctrlAkrualSetup.getAkrualSetup();
            msgString = ctrlAkrualSetup.getMessage();

            /* get record to display */
            listAkrualSetup = DbAkrualSetup.list(start, recordToGet, whereClause, orderClause);
            String msg = "";

            if (listAkrualSetup != null && listAkrualSetup.size() > 0 && iJSPCommand == JSPCommand.SUBMIT) {

                String wherex = "'" + JSPFormater.formatDate(transactionDate, "yyyy-MM-dd") + "' between start_date and end_date " +
                        " and " + DbPeriode.colNames[DbPeriode.COL_PERIODE_ID] + " = " + periodId;
                Vector vx = DbPeriode.list(0, 0, wherex, "");

                if (vx == null || vx.size() == 0) {
                    msg = "Out of period";
                } else {

                    for (int i = 0; i < listAkrualSetup.size(); i++) {

                        AkrualSetup as = (AkrualSetup) listAkrualSetup.get(i);

                        int chk = JSPRequestValue.requestInt(request, "chk_" + as.getOID());
                        double amn = JSPRequestValue.requestDouble(request, "amount_" + as.getOID());
                        Vector v = DbAkrualProses.list(0, 0, "periode_id=" + periodId + " and akrual_setup_id=" + as.getOID(), "");

                        if ((v == null || v.size() <= 0) && chk == 1) {
                            try {
                                AkrualProses ap = new AkrualProses();
                                ap.setPeriodeId(periodId);
                                ap.setRegDate(transactionDate);
                                ap.setJumlah(amn);
                                ap.setAkrualSetupId(as.getOID());
                                ap.setUserId(user.getOID());
                                ap.setDebetCoaId(as.getDebetCoaId());
                                ap.setCreditCoaId(as.getCreditCoaId());

                                ap.setSegment1Id(as.getSegment1Id());
                                ap.setSegment2Id(as.getSegment2Id());
                                ap.setSegment3Id(as.getSegment3Id());
                                ap.setSegment4Id(as.getSegment4Id());
                                ap.setSegment5Id(as.getSegment5Id());
                                ap.setSegment6Id(as.getSegment6Id());
                                ap.setSegment7Id(as.getSegment7Id());
                                ap.setSegment8Id(as.getSegment8Id());
                                ap.setSegment9Id(as.getSegment9Id());
                                ap.setSegment10Id(as.getSegment10Id());
                                ap.setSegment11Id(as.getSegment11Id());
                                ap.setSegment12Id(as.getSegment12Id());
                                ap.setSegment13Id(as.getSegment13Id());
                                ap.setSegment14Id(as.getSegment14Id());
                                ap.setSegment15Id(as.getSegment15Id());

                                long oid = DbAkrualProses.insertExc(ap);

                                if (oid != 0) {
                                    DbAkrualProses.postJournal(ap, periodId);
                                }
                                int countPeriode = DbAkrualProses.getCount(DbAkrualProses.colNames[DbAkrualProses.COL_AKRUAL_SETUP_ID] + " = " + as.getOID());
                                if (as.getPembagi() <= countPeriode) {
                                    as.setStatus(DbAkrualSetup.STATUS_AKRUAL_NOT_AKTIF);
                                    try {
                                        DbAkrualSetup.updateExc(as);
                                    } catch (Exception e) {
                                    }
                                }
                            } catch (Exception e) {
                            }
                        }
                    }
                }
            }

            /*** LANG ***/
            String[] langAT = {"Range Date", "Period", //0-1
                "Name", "Budget", "Period", "Accrual Amount", "Debet Account", "Credit Account", "Accrual Status", "Process", //2-9
                "Accrual Process Finished", "Go to Archives", "Date Transaction", "Input Parameter", "Segment","All documents in this period have been processed"}; //10-15

            String[] langNav = {"Recurring Journal", "Process"};

            if (lang == LANG_ID) {
                String[] langID = {"Batas Tanggal", "Periode",
                    "Nama", "Anggaran", "Periode", "Jumlah Akrual", "Perkiraan Debet", "Perkiraan Credit", "Status Akrual", "Proses",
                    "Proses Akrual Selesai", "Lihat Arsip", "Tanggal Transaksi", "Parameter Input", "Segmen","Semua dokumen di periode ini sudah di proses"
                };
                langAT = langID;

                String[] navID = {"Jurnal Berulang", "Proses"};
                langNav = navID;
            }
            
            boolean isProses = false;
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdChange(){
                document.frmakrualsetup.command.value="<%=JSPCommand.NONE%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
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
            
            function checkNumber(oid){
                <%
                for(int d = 0; d < listAkrualSetup.size() ; d++){
                    AkrualSetup akS = (AkrualSetup) listAkrualSetup.get(d);                    
                %>    
                if(oid == '<%=akS.getOID()%>'){    
                    var st = document.frmakrualsetup.amount_<%=akS.getOID()%>.value;		                        
                    result = removeChar(st);                        
                    result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    document.frmakrualsetup.amount_<%=akS.getOID()%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
               } 
                <%}%>
                
            }
            
            function cmdSubmit(){
                document.frmakrualsetup.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdAdd(){
                document.frmakrualsetup.hidden_akrual_setup_id.value="0";
                document.frmakrualsetup.command.value="<%=JSPCommand.ADD%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdAsk(oidAkrualSetup){
                document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualsetup.command.value="<%=JSPCommand.ASK%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdConfirmDelete(oidAkrualSetup){
                document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualsetup.command.value="<%=JSPCommand.DELETE%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdSave(){
                document.frmakrualsetup.command.value="<%=JSPCommand.SAVE%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdEdit(oidAkrualSetup){
                document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualsetup.command.value="<%=JSPCommand.EDIT%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdCancel(oidAkrualSetup){
                document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmakrualsetup.command.value="<%=JSPCommand.EDIT%>";
                document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdBack(){
                document.frmakrualsetup.command.value="<%=JSPCommand.BACK%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdListFirst(){
                document.frmakrualsetup.command.value="<%=JSPCommand.FIRST%>";
                document.frmakrualsetup.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdListPrev(){
                document.frmakrualsetup.command.value="<%=JSPCommand.PREV%>";
                document.frmakrualsetup.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdListNext(){
                document.frmakrualsetup.command.value="<%=JSPCommand.NEXT%>";
                document.frmakrualsetup.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            function cmdListLast(){
                document.frmakrualsetup.command.value="<%=JSPCommand.LAST%>";
                document.frmakrualsetup.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmakrualsetup.action="akrualproses.jsp";
                document.frmakrualsetup.submit();
            }
            
            //-------------- script form image -------------------            
            function cmdDelPict(oidAkrualSetup){
                document.frmimage.hidden_akrual_setup_id.value=oidAkrualSetup;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="akrualproses.jsp";
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
            
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
            <%@ include file="../calendar/calendarframe.jsp"%>
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
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" --><%
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
                                                        <form name="frmakrualsetup" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_akrual_setup_id" value="<%=oidAkrualSetup%>">
                                                            <input type="hidden" name="<%=JspAkrualProses.colNames[JspAkrualProses.JSP_FIELD_USER_ID]%>" value="<%=user.getOID()%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="<%=JspAkrualProses.colNames[JspAkrualProses.JSP_FIELD_PERIODE_ID]%>" value="<%=periodeXXX.getOID()%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr>
                                                                                <td>
                                                                                    <table border="0" cellpadding="1" cellspacing="1" width="330">                                                                                                                                        
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" >                                                                                                            
                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">                                                                                                    
                                                                                                    <tr height="7">
                                                                                                        <td width="5"></td>
                                                                                                        <td width="30%"></td>
                                                                                                        <td ></td>
                                                                                                        <td width="5"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td colspan="3"> <b><i><%=langAT[13]%></i></b><td>                                                                                                      
                                                                                                    </tr>
                                                                                                    <%
            Vector vPeriode = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + " = '" + I_Project.STATUS_PERIOD_OPEN + "'", DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc");
            long periodxId = 0;
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[1]%></td>
                                                                                                        <td >: 
                                                                                                            <select name="period" onchange="javascript:cmdChange()">
                                                                                                                <%
            if (vPeriode != null && vPeriode.size() > 0) {
                for (int i = 0; i < vPeriode.size(); i++) {
                    Periode p = (Periode) vPeriode.get(i);
                    if (i == 0) {
                        if (periodId == 0) {
                            periodxId = p.getOID();
                        } else {
                            periodxId = periodId;
                        }
                    }
                                                                                                                %>
                                                                                                                <option value="<%=p.getOID()%>" <%if (periodId == p.getOID()) {%> selected<%}%>><%=p.getName()%></option>
                                                                                                                <%}
            }%>    
                                                                                                            </select>    
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%
            Periode px = new Periode();
            try {
                px = DbPeriode.fetchExc(periodxId);
            } catch (Exception e) {
            }
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[0]%></td>
                                                                                                        <td >: <%=JSPFormater.formatDate(px.getStartDate(), "dd MMM yyyy")%> - <%=JSPFormater.formatDate(px.getEndDate(), "dd MMM yyyy")%></td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[12]%></td>
                                                                                                        <td >: <input name="transaction_date" value="<%=JSPFormater.formatDate((transactionDate == null) ? new Date() : transactionDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmakrualsetup.transaction_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> &nbsp <font size="1" color="FF0000"><%=msg%></font></td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr height="10">
                                                                                                        <td colspan="4"></td>                                                                                                        
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>&nbsp;</td>
                                                                            </tr>    
                                                                            <%if (listAkrualSetup != null && listAkrualSetup.size() > 0) {%>
                                                                            <tr>
                                                                                <td>
                                                                                    <table width="1050" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td width="4%" class="tablehdr">No</td>
                                                                                            <td class="tablehdr"><%=langAT[2]%></td>
                                                                                            <td width="8%" class="tablehdr"><%=langAT[14]%></td>
                                                                                            <td width="9%" class="tablehdr"><%=langAT[3]%></td>
                                                                                            <td width="5%" class="tablehdr"><%=langAT[4]%></td>
                                                                                            <td width="13%" class="tablehdr"><%=langAT[5]%></td>
                                                                                            <td width="16%" class="tablehdr"><%=langAT[6]%></td>
                                                                                            <td width="16%" class="tablehdr"><%=langAT[7]%></td>
                                                                                            <td width="8%" class="tablehdr"><%=langAT[8]%></td>
                                                                                            <td width="5%" class="tablehdr"><%=langAT[9]%></td>
                                                                                        </tr>
                                                                                        <%if (listAkrualSetup != null && listAkrualSetup.size() > 0) {
        for (int i = 0; i < listAkrualSetup.size(); i++) {
            AkrualSetup as = (AkrualSetup) listAkrualSetup.get(i);

            Coa c = new Coa();
            try {
                c = DbCoa.fetchExc(as.getDebetCoaId());
            } catch (Exception e) {
            }
            Coa c1 = new Coa();
            try {
                c1 = DbCoa.fetchExc(as.getCreditCoaId());
            } catch (Exception e) {
            }

            int count = DbAkrualProses.getCount(DbAkrualProses.colNames[DbAkrualProses.COL_PERIODE_ID] + " = " + px.getOID() + " and " + DbAkrualProses.colNames[DbAkrualProses.COL_AKRUAL_SETUP_ID] + " = " + as.getOID());
            int countPeriode = DbAkrualProses.getCount(DbAkrualProses.colNames[DbAkrualProses.COL_AKRUAL_SETUP_ID] + " = " + as.getOID());

            boolean isAvailable = false;
            if (as.getPembagi() > countPeriode) {
                isAvailable = true;
            }

            if (i % 2 == 0) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td class="tablecell1" align="center"><%=i + 1%></td>
                                                                                            <td class="tablecell1"><%=as.getNama()%></td>
                                                                                            <td class="tablecell1">
                                                                                                <div align="left"> 
                                                                                                    <%
                                                                                                String segment = "";
                                                                                                try {
                                                                                                    if (as.getSegment1Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment1Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment2Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment2Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment3Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment3Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment4Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment4Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment5Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment5Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment6Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment6Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment7Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment7Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment8Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment8Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment9Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment9Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment10Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment10Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment11Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment11Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment12Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment12Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment13Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment13Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment14Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment14Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment15Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment15Id());
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
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(as.getAnggaran(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="center"><%=as.getPembagi()%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="center"> 
                                                                                                    <input type="text" <%if(count > 0){%> readonly class ="readOnly" <%}%> name="amount_<%=as.getOID()%>" value="<%=JSPFormater.formatNumber((as.getAnggaran() / as.getPembagi()), "#,###.##")%>" onBlur="javascript:checkNumber('<%=as.getOID()%>')" style="text-align:right">
                                                                                                </div>
                                                                                            </td>
                                                                                            <td class="tablecell1"><%=c.getCode() + "-" + c.getName()%></td>
                                                                                            <td class="tablecell1"><%=c1.getCode() + "-" + c1.getName()%></td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="center"><%=(count > 0) ? "Sudah" : "-"%></div>
                                                                                            </td>
                                                                                            <td class="tablecell1"> 
                                                                                                <div align="center"> 
                                                                                                    <%if (count == 0 && isAvailable) {%>
                                                                                                    <%isProses = true;%>
                                                                                                    <input type="checkbox" name="chk_<%=as.getOID()%>" value="1" checked>
                                                                                                    <%} else {%>
                                                                                                    - 
                                                                                                    <%}%>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%} else {%>
                                                                                        <tr> 
                                                                                            <td class="tablecell" align="center"><%=i + 1%></td>
                                                                                            <td class="tablecell"><%=as.getNama()%></td>
                                                                                            <td class="tablecell">
                                                                                                <div align="left"> 
                                                                                                    <%

                                                                                                String segment = "";
                                                                                                try {
                                                                                                    if (as.getSegment1Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment1Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment2Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment2Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment3Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment3Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment4Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment4Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment5Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment5Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment6Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment6Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment7Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment7Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment8Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment8Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment9Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment9Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment10Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment10Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment11Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment11Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment12Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment12Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment13Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment13Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment14Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment14Id());
                                                                                                        segment = segment + sd.getName() + " | ";
                                                                                                    }
                                                                                                    if (as.getSegment15Id() != 0) {
                                                                                                        SegmentDetail sd = DbSegmentDetail.fetchExc(as.getSegment15Id());
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
                                                                                            <td class="tablecell"> 
                                                                                                <div align="right"><%=JSPFormater.formatNumber(as.getAnggaran(), "#,###.##")%></div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="center"><%=as.getPembagi()%></div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="center"> 
                                                                                                    <input type="text" <%if(count > 0){%> readonly class ="readOnly" <%}%> name="amount_<%=as.getOID()%>" value="<%=JSPFormater.formatNumber((as.getAnggaran() / as.getPembagi()), "#,###.##")%>" onBlur="javascript:checkNumber('<%=as.getOID()%>')" style="text-align:right">
                                                                                                </div>
                                                                                            </td>
                                                                                            <td class="tablecell"><%=c.getCode() + "-" + c.getName()%></td>
                                                                                            <td class="tablecell"><%=c1.getCode() + "-" + c1.getName()%></td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="center"><%=(count > 0) ? "Sudah" : "-"%></div>
                                                                                            </td>
                                                                                            <td class="tablecell"> 
                                                                                                <div align="center"> 
                                                                                                    <%if (count == 0 && isAvailable) {%> 
                                                                                                    <%isProses = true;%>                                                                                                   
                                                                                                    <input type="checkbox" name="chk_<%=as.getOID()%>" value="1" checked>
                                                                                                    <%} else {%>
                                                                                                    - 
                                                                                                    <%}%>
                                                                                                </div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}
        }
    }%><%if(isProses == false){%>
                                                                                        <tr> 
                                                                                            <td colspan="10" height="10"></td>                                                                                          
                                                                                        </tr>        
                                                                                        <tr> 
                                                                                            <td colspan="10"><i><%=langAT[15]%></i></td>                                                                                          
                                                                                        </tr>
                                                                                        <%}else{%>
                                                                                        <tr> 
                                                                                            <td colspan="10">&nbsp;</td>                                                                                          
                                                                                        </tr>        
                                                                                        <tr> 
                                                                                            <td colspan="9"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="3%">
                                                                                                            <%if (privAdd || privUpdate) {%>
                                                                                                            <a href="javascript:cmdSubmit()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/save2.gif',1)"><img src="../images/save.gif" name="new21" width="55" height="22" border="0"></a>
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <td width="97%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%} else {%>
                                                                            <tr>
                                                                                <td>&nbsp;<font color="#0000FF"><%=langAT[10]%></font>, <a href="#"><%=langAT[11]%></a></td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                        
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command">&nbsp; </td>
                                                                </tr>
                                                            </table>
                                                        </form>
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
