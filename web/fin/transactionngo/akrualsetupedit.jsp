
<%-- 
    Document   : akrualsetupedit
    Created on : Mar 23, 2013, 1:34:18 PM
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

            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdAkrualSetup ctrlAkrualSetup = new CmdAkrualSetup(request);
            JSPLine ctrLine = new JSPLine();
            Vector listAkrualSetup = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlAkrualSetup.action(iJSPCommand, oidAkrualSetup);
            /* end switch*/
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

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listAkrualSetup.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listAkrualSetup = DbAkrualSetup.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langAT = {"Reg. Date", "Name", "Budget", "Period", "Debet Account", "Credit Account", "Last Update", "Created By", "Active", "Segment","Master setup is already in use, you only can change status"};

            String[] langNav = {"Recurring Journal", "Jurnal Setup", "Date"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal Reg.", "Nama", "Anggaran", "Periode", "Perkiraan Debet", "Perkiraan Credit", "Update Terakhir", "Dibuat Oleh", "Aktif", "Segmen","Master setup sudah digunakan, Anda hanya bisa mengganti status"};
                langAT = langID;

                String[] navID = {"Jurnal Berulang", "Setup Jurnal", "Tanggal"};
                langNav = navID;
            }
            Vector segments = DbSegment.list(0, 0, "", "");
            
            int count = DbAkrualProses.getCount(DbAkrualProses.colNames[DbAkrualProses.COL_AKRUAL_SETUP_ID] + " = " + akrualSet.getOID());
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
            
            function cmdSeacrhCoa(accid, accname){
                window.open("<%=approot%>/transaction/s_coa.jsp?formName=frmakrualsetup&accId="+accid+"&accName="+accname, null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
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
                
                 function checkNumber(){                
                    var st = document.frmakrualsetup.<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_ANGGARAN]%>.value;		                        
                    result = removeChar(st);                        
                    result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                    document.frmakrualsetup.<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_ANGGARAN]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
               } 
                
                
                function cmdAdd(){
                    document.frmakrualsetup.hidden_akrual_setup_id.value="0";
                    document.frmakrualsetup.command.value="<%=JSPCommand.ADD%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdAsk(oidAkrualSetup){
                    document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                    document.frmakrualsetup.command.value="<%=JSPCommand.ASK%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdConfirmDelete(oidAkrualSetup){
                    document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                    document.frmakrualsetup.command.value="<%=JSPCommand.DELETE%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdSave(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.SAVE%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdEdit(oidAkrualSetup){
                    <%if (privUpdate) {%>
                    document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                    document.frmakrualsetup.command.value="<%=JSPCommand.EDIT%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                    <%}%>
                }
                
                function cmdCancel(oidAkrualSetup){
                    document.frmakrualsetup.hidden_akrual_setup_id.value=oidAkrualSetup;
                    document.frmakrualsetup.command.value="<%=JSPCommand.EDIT%>";
                    document.frmakrualsetup.prev_command.value="<%=prevJSPCommand%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdBack(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.BACK%>";
                    document.frmakrualsetup.action="akrualsetup.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdListFirst(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.FIRST%>";
                    document.frmakrualsetup.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdListPrev(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.PREV%>";
                    document.frmakrualsetup.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdListNext(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.NEXT%>";
                    document.frmakrualsetup.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdListLast(){
                    document.frmakrualsetup.command.value="<%=JSPCommand.LAST%>";
                    document.frmakrualsetup.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmakrualsetup.action="akrualsetupedit.jsp";
                    document.frmakrualsetup.submit();
                }
                
                function cmdDelPict(oidAkrualSetup){
                    document.frmimage.hidden_akrual_setup_id.value=oidAkrualSetup;
                    document.frmimage.command.value="<%=JSPCommand.POST%>";
                    document.frmimage.action="akrualsetupedit.jsp";
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
                                                        <form name="frmakrualsetup" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_akrual_setup_id" value="<%=oidAkrualSetup%>">
                                                            <input type="hidden" name="<%=JspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_USER_ID]%>" value="<%=user.getOID()%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">
                                                                                    <div align="right"><%=langNav[2]%> : <%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%></div> 
                                                                                </td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>                                                                              
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <table width="400" border="0" cellpadding="0" cellspacing="1">
                                                                                        <tr>                                                                                                                                            
                                                                                            <td class="tablecell1" >                                                                                                            
                                                                                                <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1"> 
                                                                                                     <tr >                                                                                                        
                                                                                                        <td colspan="4" height="10"></td>
                                                                                                    </tr> 
                                                                                                    <tr >
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                        <td colspan="3" height="15"><b><i>Editor akrual setup</i></b></td>
                                                                                                    </tr> 
                                                                                                    <tr >
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                        <td width="140"><%=langAT[0]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <input type="text" name="reg" value="<%=JSPFormater.formatDate(akrualSet.getRegDate() == null ? new Date() : akrualSet.getRegDate(), "dd MMM yyyy") %>" size="30" class="readOnly">
                                                                                                        </td>
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                    </tr>                                                                                                                                                                                                                                                                                                 
                                                                                                    <%
                                                                                if (segments != null && segments.size() > 0) {
                                                                                    for (int i = 0; i < segments.size(); i++) {
                                                                                        Segment segment = (Segment) segments.get(i);
                                                                                        String wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + " = " + segment.getOID();
                                                                                        switch (i + 1) {
                                                                                            case 1:
                                                                                                if (user.getSegment1Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment1Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment1Id();
                                                                                                }
                                                                                                break;
                                                                                            case 2:
                                                                                                if (user.getSegment2Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment2Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment2Id();
                                                                                                }
                                                                                                break;
                                                                                            case 3:
                                                                                                if (user.getSegment3Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment3Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment3Id();
                                                                                                }
                                                                                                break;
                                                                                            case 4:
                                                                                                if (user.getSegment4Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment4Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment4Id();
                                                                                                }
                                                                                                break;
                                                                                            case 5:
                                                                                                if (user.getSegment5Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment5Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment4Id();
                                                                                                }
                                                                                                break;
                                                                                            case 6:
                                                                                                if (user.getSegment6Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment6Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment6Id();
                                                                                                }
                                                                                                break;
                                                                                            case 7:
                                                                                                if (user.getSegment7Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment7Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment7Id();
                                                                                                }
                                                                                                break;
                                                                                            case 8:
                                                                                                if (user.getSegment8Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment8Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment8Id();
                                                                                                }
                                                                                                break;
                                                                                            case 9:
                                                                                                if (user.getSegment9Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment9Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment9Id();
                                                                                                }
                                                                                                break;
                                                                                            case 10:
                                                                                                if (user.getSegment10Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment10Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment10Id();
                                                                                                }
                                                                                                break;
                                                                                            case 11:
                                                                                                if (user.getSegment11Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment11Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment11Id();
                                                                                                }
                                                                                                break;
                                                                                            case 12:
                                                                                                if (user.getSegment12Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment12Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment12Id();
                                                                                                }
                                                                                                break;
                                                                                            case 13:
                                                                                                if (user.getSegment13Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment13Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment13Id();
                                                                                                }
                                                                                                break;
                                                                                            case 14:
                                                                                                if (user.getSegment14Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment14Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment14Id();
                                                                                                }
                                                                                                break;
                                                                                            case 15:
                                                                                                if (user.getSegment15Id() != 0) {
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + user.getSegment15Id();
                                                                                                }
                                                                                                if(count > 0){
                                                                                                    wh = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_DETAIL_ID] + " = " + akrualSet.getSegment15Id();
                                                                                                }
                                                                                                break;
                                                                                        }
                                                                                        Vector sgDetails = DbSegmentDetail.list(0, 0, wh, DbSegmentDetail.colNames[DbSegmentDetail.COL_NAME]);
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><font face="arial"><%=segment.getName()%></font></td>
                                                                                                        <td >:</td>
                                                                                                        <td >
                                                                                                            <select name="JSP_SEGMENT<%=i + 1%>_ID">
                                                                                                                <%if (sgDetails != null && sgDetails.size() > 0) {
                                                                                                                for (int x = 0; x < sgDetails.size(); x++) {
                                                                                                                    SegmentDetail sd = (SegmentDetail) sgDetails.get(x);
                                                                                                                    String selected = "";
                                                                                                                    switch (i + 1) {
                                                                                                                        case 1:
                                                                                                                            if (akrualSet.getSegment1Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 2:
                                                                                                                            if (akrualSet.getSegment2Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 3:
                                                                                                                            if (akrualSet.getSegment3Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 4:
                                                                                                                            if (akrualSet.getSegment4Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 5:
                                                                                                                            if (akrualSet.getSegment5Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 6:
                                                                                                                            if (akrualSet.getSegment6Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 7:
                                                                                                                            if (akrualSet.getSegment7Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 8:
                                                                                                                            if (akrualSet.getSegment8Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 9:
                                                                                                                            if (akrualSet.getSegment9Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 10:
                                                                                                                            if (akrualSet.getSegment10Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 11:
                                                                                                                            if (akrualSet.getSegment11Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 12:
                                                                                                                            if (akrualSet.getSegment12Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 13:
                                                                                                                            if (akrualSet.getSegment13Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 14:
                                                                                                                            if (akrualSet.getSegment14Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                        case 15:
                                                                                                                            if (akrualSet.getSegment5Id() == sd.getOID()) {
                                                                                                                                selected = "selected";
                                                                                                                            }
                                                                                                                            break;
                                                                                                                    }
                                                                                                                %>
                                                                                                                <option value="<%=sd.getOID()%>" <%=selected%>><%=sd.getName()%></option>
                                                                                                                <%}
                                                                                                            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%}
                                                                                }%>                                             
                                                                                                    <tr >
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[1]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <input type="text" name="<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_NAMA]%>" value="<%=akrualSet.getNama()%>"  size="30" <%if(count > 0){%> readonly <%}%> <%if(count > 0){%> class="readOnly" <%}else{%> class="formElemen" <%}%> >
                                                                                                            <%= jspAkrualSetup.getErrorMsg(JspAkrualSetup.JSP_FIELD_NAMA) %>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr >
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[3]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <input type="text" name="<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_PEMBAGI]%>" value="<%=akrualSet.getPembagi()%>" size="5" style="text-align:right" <%if(count > 0){%> readonly <%}%> <%if(count > 0){%> class="readOnly" <%}else{%> class="formElemen" <%}%>>
                                                                                                            <%= jspAkrualSetup.getErrorMsg(JspAkrualSetup.JSP_FIELD_PEMBAGI) %>
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                     <%
                                                                                                     
    Coa objCoaD = new Coa();
    try {
        if (akrualSet.getDebetCoaId() != 0) {
            objCoaD = DbCoa.fetchExc(akrualSet.getDebetCoaId());
        }
    } catch (Exception e) {
        System.out.println(e.toString());
    }
                                                                                                        %>
                                                                                                    <tr >
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[4]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                             <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input type="hidden" name=<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_DEBET_COA_ID]%> value="<%=akrualSet.getDebetCoaId()%>" >
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <input size="30" type="text" name="akrual_debet" value="<%=objCoaD.getCode() + " - " + objCoaD.getName()%>" readonly class="readOnly">
                                                                                                                    </td>
                                                                                                                    <td>&nbsp;
                                                                                                                        <%if(count <= 0){%>
                                                                                                                        <a href="javascript:cmdSeacrhCoa('<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_DEBET_COA_ID]%>','akrual_debet')" >
                                                                                                                        <img src="../images/search-small.jpg" name="new211" border="0" style="padding:0px"></a>
                                                                                                                        <%= jspAkrualSetup.getErrorMsg(JspAkrualSetup.JSP_FIELD_DEBET_COA_ID) %>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                            </table>   
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                     <%
    Coa objCoaC = new Coa();
    try {
        if (akrualSet.getCreditCoaId() != 0) {
            objCoaC = DbCoa.fetchExc(akrualSet.getCreditCoaId());
        }
    } catch (Exception e) {
        System.out.println(e.toString());
    }
                                                                                                        %>
                                                                                                    <tr >
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[5]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                             <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <input type="hidden" name=<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_CREDIT_COA_ID]%> value="<%=akrualSet.getCreditCoaId()%>" >
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                        <input size="30" type="text" name="akrual_credit" value="<%=objCoaC.getCode() + " - " + objCoaC.getName()%>" readonly class="readOnly">
                                                                                                                    </td>
                                                                                                                    <td>&nbsp;
                                                                                                                        <%if(count <= 0){%>
                                                                                                                        <a href="javascript:cmdSeacrhCoa('<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_CREDIT_COA_ID]%>','akrual_credit')" >
                                                                                                                        <img src="../images/search-small.jpg" name="new212" border="0" style="padding:0px"></a>
                                                                                                                        <%= jspAkrualSetup.getErrorMsg(JspAkrualSetup.JSP_FIELD_CREDIT_COA_ID) %>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>    
                                                                                                            </table>    
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr >
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[2]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                             <input type="text" name="<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_ANGGARAN]%>" value="<%=JSPFormater.formatNumber(akrualSet.getAnggaran(), "#,###.##")%>" size="20" onBlur="javascript:checkNumber()" style="text-align:right" <%if(count > 0){%> readonly <%}%> <%if(count > 0){%> class="readOnly" <%}else{%> class="formElemen" <%}%>>
                                                                                                            <%= jspAkrualSetup.getErrorMsg(JspAkrualSetup.JSP_FIELD_ANGGARAN) %> 
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr >
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >Status</td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <input type="checkbox" name="<%=jspAkrualSetup.colNames[JspAkrualSetup.JSP_FIELD_STATUS]%>" value="1" class="formElemen"  <%=akrualSet.getStatus() == 1 ? "checked" : "" %> >
                                                                                                            &nbsp;Aktif
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr >
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[6]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <input type="text" name="last_up" value="<%=JSPFormater.formatDate(akrualSet.getLastUpdate() == null ? new Date() : akrualSet.getLastUpdate(), "dd MMM yyyy") %>" size="30" class="readOnly">
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <% 
                                                                                                    User u = new User();
                                                                                                    
    try {
       if(akrualSet.getUserId() == 0){           
            u = DbUser.fetch(user.getOID());
        }else{
            u = DbUser.fetch(akrualSet.getUserId());                                        
        }
    } catch (Exception e) {
    }
                                                                                                    %>
                                                                                                     <tr >
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td ><%=langAT[7]%></td>
                                                                                                        <td width="1">:</td>
                                                                                                        <td >
                                                                                                            <input type="text" name="last_u" value="<%=u.getFullName()%>" size="30" class="readOnly">
                                                                                                        </td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr> 
                                                                                                    <tr >
                                                                                                        <td colspan="4" height="15">&nbsp;</td>
                                                                                                    </tr> 
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>   
                                                                            
                                                                            <%
            } catch (Exception exc) {
            }%>
                                                                            <%if(count > 0){%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">
                                                                                    &nbsp;<i><%=langAT[10]%></i>
                                                                            </tr>
                                                                            <%}%>
                                                                            <%if (iJSPCommand == JSPCommand.SAVE && iErrCode <=  0) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">
                                                                                    &nbsp;<i>Data is saved</i>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">
                                                                                    &nbsp;<%if (privAdd) {%><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/ok2.gif',1)"><img src="../images/ok.gif" name="new2" border="0"></a><%}%></td>
                                                                            </tr>
                                                                            
                                                                            <%} else {%>
                                                                            <tr align="left" valign="top">
                                                                                <td height="7" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                    <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("40%");
    String scomDel = "javascript:cmdAsk('" + oidAkrualSetup + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidAkrualSetup + "')";
    String scancel = "javascript:cmdEdit('" + oidAkrualSetup + "')";
    ctrLine.setBackCaption("Back");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setSaveCaption("Save");
    ctrLine.setDeleteCaption("Delete");
    ctrLine.setConfirmDelCaption("Yes Delete");

    if (privDelete) {
        ctrLine.setConfirmDelJSPCommand(sconDelCom);
        ctrLine.setDeleteJSPCommand(scomDel);
        ctrLine.setEditJSPCommand(scancel);
    } else {
        ctrLine.setConfirmDelCaption("");
        ctrLine.setDeleteCaption("");
        ctrLine.setEditCaption("");
    }

    if (privAdd == false && privUpdate == false) {
        ctrLine.setSaveCaption("");
    }

    if (privAdd == false) {
        ctrLine.setAddCaption("");
    }
                                                                                    %>
                                                                                <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
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
