
<%-- 
    Document   : apmemopost
    Created on : Nov 14, 2012, 3:26:34 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.fms.ar.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidArap = JSPRequestValue.requestLong(request, "hidden_arap_id");
            long vendorId = JSPRequestValue.requestLong(request, "JSP_VENDOR_ID");
            String txtvendor = JSPRequestValue.requestString(request, "txt_vendor");
            String txtNumber = JSPRequestValue.requestString(request, "txt_number");
            String dateStart = JSPRequestValue.requestString(request, "date_start");
            String dateEnd = JSPRequestValue.requestString(request, "date_end");
            int ignore = JSPRequestValue.requestInt(request, "ignore");

            if (iJSPCommand == JSPCommand.NONE) {
                vendorId = 0;
                txtvendor = "";
                ignore = 1;
                txtNumber = "";
            }

            Date dtStart = new Date();
            Date dtEnd = new Date();

            if (ignore == 0) {
                dtStart = JSPFormater.formatDate(dateStart, "dd/MM/yyyy");
                dtEnd = JSPFormater.formatDate(dateEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 0;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String orderClause = "";

            CmdReceiveMemo cmdReceiveMemo = new CmdReceiveMemo(request);
            JSPLine ctrLine = new JSPLine();
            iErrCode = cmdReceiveMemo.action(iJSPCommand, oidArap,0);
            JspReceiveMemo jspReceiveMemo = cmdReceiveMemo.getForm();

            Vector listAp = new Vector();

            String where = "";

            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.POST) {

                where = where + DbReceive.colNames[DbReceive.COL_TYPE_AP] + " = " + DbReceive.TYPE_AP_YES+" and "+DbReceive.colNames[DbReceive.COL_STATUS]+" = '"+I_Project.STATUS_APPROVED+"' ";

                if (txtNumber.length() > 0) {
                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    where = where + DbReceive.colNames[DbReceive.COL_NUMBER] + " like '%" + txtNumber + "%'";
                }

                if (vendorId > 0) {
                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    where = where + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + " = " + vendorId;
                }

                if (ignore == 0) {
                    if (where.length() > 0) {
                        where = where + " and ";
                    }
                    where = where + DbReceive.colNames[DbReceive.COL_DATE] + " between '" + JSPFormater.formatDate(dtStart, "yyyy-MM-dd") + "' and '" + JSPFormater.formatDate(dtEnd, "yyyy-MM-dd") + "'";
                }
                orderClause = DbReceive.colNames[DbReceive.COL_NUMBER];
            }

            int vectSize = 0;

            if (iJSPCommand != JSPCommand.NONE) {
                vectSize = DbReceive.getCount(where);
            }

            Receive receive = cmdReceiveMemo.getReceiveMemo();
            msgString = cmdReceiveMemo.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {

                start = cmdReceiveMemo.actionList(iJSPCommand, start, vectSize, recordToGet);

            }
            /* end switch list*/

            /* get record to display */
            listAp = new Vector();
            if (iJSPCommand != JSPCommand.NONE) {
                listAp = DbReceive.list(start, recordToGet, where, orderClause);
            }

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/

            if (listAp.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listAp = DbReceive.list(start, recordToGet, where, orderClause);
            }
            
            if(iJSPCommand == JSPCommand.POST){                
                for(int i = 0; i < listAp.size(); i++){                    
                    Receive objMemo = (Receive) listAp.get(i);
                    int cx = JSPRequestValue.requestInt(request, "chk"+objMemo.getOID());
                    if(cx==1){
                        DbReceive.postJournalAPMemo(objMemo,user.getOID());
                    }
                }
                listAp = DbReceive.list(start, recordToGet, where, orderClause);
            }

            String[] langAP = {"Date", "Vendor", "Number", "Period", "Date", "Vendor", "Invoice", "Amount", "Memo", "Amount", "Number", "Date", "Vendor", "Status", "Click search button to searching the data", "Data not found",
                                "Location","Coa","Coa AP"}; //16 - 18
            String[] langNav = {"Account Payble", "Post Journal", "Record", "Editor"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal", "Vendor", "Number", "Periode", "Tanggal", "Suplier", "Faktur", "Jumlah", "Memo", "Jumlah", "Number", "Date", "Vendor", "Status", "Klik tombol search untuk mencari data", "Data tidak ditemukan",
                                "Lokasi","Perkiraan","Coa AP"}; // 16 - 18
                langAP = langID;

                String[] navID = {"Hutang", "Post Jurnal", "Record", "Editor"};
                langNav = navID;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=systemTitle%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        
        var sysDecSymbol = "<%=sSystemDecimalSymbol%>"; var usrDigitGroup = "<%=sUserDigitGroup%>"; var usrDecSymbol = "<%=sUserDecimalSymbol%>";
        function cmdSearchVendor(){
            window.open("<%=approot%>/ap/srcv.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdSearchFaktur(){ 
                if(document.frmarapmemo.JSP_VENDOR_ID.value == 0){
                    alert("Suplier/Vendor harus diisi");
                }else{    
                window.open("<%=approot%>/ap/srcfaktur.jsp?JSP_VENDOR_ID=<%=vendorId%>", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");                        
                }    
            }   
            
            function setChecked(val){
                <%
                for (int k = 0; k < listAp.size(); k++) {
                    Receive xarapMemo = (Receive) listAp.get(k);
                %>    
                    document.frmarapmemo.chk<%=xarapMemo.getOID()%>.checked=val.checked;
                <%
                }
                %>
            }         
            
            
            function cmdPostJournal(){
                document.frmarapmemo.command.value="<%=JSPCommand.POST%>";            
                document.frmarapmemo.action="apmemopost.jsp";
                document.frmarapmemo.submit();
            }    
            
            function cmdSearch(){ 
                document.frmarapmemo.command.value="<%=JSPCommand.SEARCH%>";            
                document.frmarapmemo.action="apmemopost.jsp";
                document.frmarapmemo.submit();
            }   
            
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
        
        function cmdToRecord(){
            document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";            
            document.frmarapmemo.action="apmemo.jsp";
            document.frmarapmemo.submit();
        }    
        
        function cmdSave(){
            document.frmarapmemo.command.value="<%=JSPCommand.SAVE%>";
            document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
            document.frmarapmemo.action="apmemopost.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdResetAll(){
            document.frmarapmemo.txt_vendor.value="";
            document.frmarapmemo.JSP_VENDOR_ID.value="0";
            document.frmarapmemo.txt_number.value="";
            document.frmarapmemo.JSP_REF_ID.value="0";
        }
        
        function cmdEdit(oidArap){
            document.frmarapmemo.hidden_arap_id.value=oidArap;
            document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
            document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
            document.frmarapmemo.action="apmemo.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdCancel(oidArap){
            document.frmarapmemo.hidden_arap_id.value=oidArap;
            document.frmarapmemo.command.value="<%=JSPCommand.EDIT%>";
            document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
            document.frmarapmemo.action="apmemopost.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdBack(){
            document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";
            document.frmarapmemo.action="adjusmentpost.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdListFirst(){
            document.frmarapmemo.command.value="<%=JSPCommand.FIRST%>";
            document.frmarapmemo.prev_command.value="<%=JSPCommand.FIRST%>";
            document.frmarapmemo.action="apmemopost.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdListPrev(){
            document.frmarapmemo.command.value="<%=JSPCommand.PREV%>";
            document.frmarapmemo.prev_command.value="<%=JSPCommand.PREV%>";
            document.frmarapmemo.action="apmemopost.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdListNext(){
            document.frmarapmemo.command.value="<%=JSPCommand.NEXT%>";
            document.frmarapmemo.prev_command.value="<%=JSPCommand.NEXT%>";
            document.frmarapmemo.action="apmemopost.jsp";
            document.frmarapmemo.submit();
        }
        
        function cmdListLast(){
            document.frmarapmemo.command.value="<%=JSPCommand.LAST%>";
            document.frmarapmemo.prev_command.value="<%=JSPCommand.LAST%>";
            document.frmarapmemo.action="apmemopost.jsp";
            document.frmarapmemo.submit();
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
        
        function MM_swapImage() { //v3.0
            var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
            if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
        }
        
        function MM_findObj(n, d) { //v4.01
            var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
                d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
            if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
            for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
            if(!x && d.getElementById) x=d.getElementById(n); return x;
        }
        //-->
    </script>
    
    <!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
<tr> 
<td valign="top"> 
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
    <tr> 
        <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file = "../main/hmenu.jsp" %>
        <!-- #EndEditable --> </td>
    </tr>
    <tr> 
        <td valign="top"> 
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <!--DWLayoutTable-->
            <tr> 
            <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp" %>
                  <%@ include file="../calendar/calendarframe.jsp"%>
            <!-- #EndEditable --> </td>
            <td width="100%" valign="top"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">&nbsp;" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                        <!-- #EndEditable --></td>
                    </tr>
                    <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                    </tr-->
                    <tr> 
                        <td><!-- #BeginEditable "content" --> 
                            <form name="frmarapmemo" method ="post" action="">
                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                            <input type="hidden" name="start" value="0">
                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                            <input type="hidden" name="hidden_arap_id" value="<%=oidArap%>">
                            <input type="hidden" name="<%=JspReceiveMemo.colNames[JspReceiveMemo.JSP_TYPE]%>" value="<%=DbReceive.TYPE_AP_YES%>">                              
                            <input type="hidden" name="JSP_REF_ID" value="0">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr align="left" valign="top"> 
                                    <td height="8"  colspan="3" class="container"> 
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr align="left" valign="top"> 
                                                <td height="22" valign="middle" colspan="3"> 
                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                        <tr> 
                                                            <td>&nbsp;</td>
                                                        </tr>
                                                        <tr> 
                                                            <td> 
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr> 
                                                                        <td width="100%" > 
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                               
                                                                                <tr>
                                                                                    <td height="10">&nbsp;</td>
                                                                                </tr>                                                                                
                                                                                <tr>
                                                                                <td>
                                                                                    <table width="760" border="0" cellpadding="0" cellspacing="2">
                                                                                    <tr> 
                                                                                        <td width="15%" class="tablecell1">&nbsp;&nbsp;Number</td>
                                                                                        <td width="1%">:</td>
                                                                                        <td width="35%">
                                                                                            <input name="txt_number" value="<%=txtNumber%>" size="25">
                                                                                        </td>
                                                                                        <td width="10%" class="tablecell1">&nbsp;&nbsp;<%=langAP[4]%></td>
                                                                                        <td width="1%">:</td>
                                                                                        <td width="48%">                                                                                                                                    
                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <input name="date_start" value="<%=JSPFormater.formatDate((dtStart == null) ? new Date() : dtStart, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                    </td>
                                                                                                    <td>        
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.date_start);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                    </td> 
                                                                                                    <td>
                                                                                                        &nbsp;To&nbsp;
                                                                                                    </td> 
                                                                                                    <td>
                                                                                                        <input name="date_end" value="<%=JSPFormater.formatDate((dtEnd == null) ? new Date() : dtEnd, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                    </td>
                                                                                                    <td>    
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.date_end);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                    </td> 
                                                                                                    <td><input type="checkbox" name="ignore" checked value="1" <%if (ignore == 1) {%>checked<%}%>></td>
                                                                                                    <td>&nbsp;Ignore</td>
                                                                                                </tr>
                                                                                            </table> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td class="tablecell1">&nbsp;&nbsp;<%=langAP[5]%></td>
                                                                                        <td >:</td>
                                                                                        <td >
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <input size="25" readonly type="text" name="txt_vendor" value="<%=txtvendor%>">
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input type="hidden" name="JSP_VENDOR_ID" value="<%=vendorId%>">
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;<a href="javascript:cmdSearchVendor()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" border="0" height="17" style="padding:0px"></a>
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;<a href="javascript:cmdResetAll()">Reset</a>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <td ></td><td ></td><td></td>
                                                                                    </tr>     
                                                                                    <tr> 
                                                                                    <td valign="top" colspan="6">&nbsp;</td>
                                                                                </td>    
                                                                                <tr> 
                                                                                    <td valign="top" colspan="6"><a href="javascript:cmdSearch()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search" border="0"></a></td>
                                                                                </tr>
                                                                                <tr> 
                                                                                    <td valign="top" colspan="6">&nbsp;</td>
                                                                                </tr> 
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <%if (iJSPCommand == JSPCommand.NONE) {%>
                                                                    <tr>
                                                                        <td colspan = "6" height="22" valign="middle" class="page">
                                                                            <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                <tr> 
                                                                                    <td class="tablecell1" ><%=langAP[14]%></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>                                                                                  
                                                                    </tr>    
                                                                    <%}%>
                                                                    <%if (iJSPCommand == JSPCommand.SEARCH && listAp.size() <= 0) {%>
                                                                    <tr> 
                                                                        <td >&nbsp;</td>
                                                                    </tr>    
                                                                    <tr> 
                                                                        <td height="22" valign="middle" class="page">
                                                                            <table width="100%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                <tr> 
                                                                                    <td class="tablecell1" ><%=langAP[15]%></td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>    
                                                                    <%}%>
                                                                    <tr>
                                                                        <td>
                                                                            <table width="95%" border="0" cellpadding="0" cellspacing="1">                                                                                               
                                                                                <%
            int number = start + 1;
            if (listAp != null && listAp.size() > 0) {
                                                                                %>
                                                                                <tr>
                                                                                    <td colspan="4">&nbsp;</td>
                                                                                </tr> 
                                                                                <tr>
                                                                                    <td class="tablehdr" width="3%"><font size="1">No.</font></td>
                                                                                    <td class="tablehdr" width="10%"><font size="1"><%=langAP[10]%></font></td>
                                                                                    <td class="tablehdr" width="10%"><font size="1"><%=langAP[11]%></font></td>
                                                                                    <td class="tablehdr" width="16%"><font size="1"><%=langAP[16]%></font></td>
                                                                                    <td class="tablehdr" width="20%"><font size="1"><%=langAP[12]%></font></td>
                                                                                    <td class="tablehdr" width="13%"><font size="1"><%=langAP[17]%></font></td>                                                                                    
                                                                                    <td class="tablehdr" width="10%"><font size="1"><%=langAP[7]%></font></td>
                                                                                    <td class="tablehdr" width="5%"><font size="1"><input type="checkbox" name="chkbox" onClick="setChecked(this)"></font></td>
                                                                                </tr> 
                                                                                <%
                                                                                    for (int i = 0; i < listAp.size(); i++) {
                                                                                        Receive objMemo = (Receive) listAp.get(i);
                                                                                        Vendor vnd = new Vendor();
                                                                                        try {
                                                                                            vnd = DbVendor.fetchExc(objMemo.getVendorId());
                                                                                        } catch (Exception e) {
                                                                                        }
                                                                                        
                                                                                        Location loc = new Location();
                                                                                        try{
                                                                                            loc = DbLocation.fetchExc(objMemo.getLocationId());
                                                                                        }catch(Exception e){}
                                                                                        
                                                                                        Coa coa = new Coa();
                                                                                        Coa coaAp = new Coa();
                                                                                        
                                                                                        try{
                                                                                            coa = DbCoa.fetchExc(objMemo.getCoaId());
                                                                                        }catch(Exception e){}
                                                                                        
                                                                                        double amount = DbReceiveItem.getTotalAmount(objMemo.getOID());
                                                                                %>
                                                                                <tr>
                                                                                    <td class="tablecell" align="center"><font size="1"><%=number%></font></td>
                                                                                    <td class="tablecell" align="center"><font size="1"><%=objMemo.getNumber()%></font></td>
                                                                                    <td class="tablecell" align="center"><font size="1"><%=JSPFormater.formatDate(objMemo.getDate(), "yyyy-MM-dd")%></font></td>                                                                                    
                                                                                    <td class="tablecell" ><font size="1"><%=loc.getName()%></font></td>
                                                                                    <td class="tablecell" ><font size="1"><%=vnd.getName()%></font></td>
                                                                                    <td class="tablecell" ><font size="1"><%=coa.getCode()%>-<%=coa.getName()%></font></td>                                                                                    
                                                                                    <td class="tablecell" align="right"><font size="1"><%=JSPFormater.formatNumber(amount * -1, "#,###")%>&nbsp;</font></td>
                                                                                    <td class="tablecell" align="center">
                                                                                        <input type="checkbox" name="chk<%=objMemo.getOID()%>" value="1">
                                                                                    </td>
                                                                                </tr> 
                                                                                <%
                                                                                        number++;
                                                                                    }%>
                                                                                    
                                                                                <tr align="left" valign="top"> 
                                                                                    <td height="8" align="left" colspan="6" class="command">&nbsp; 
                                                                                    </td>
                                                                                </tr>    
                                                                                <tr align="left" valign="top"> 
                                                                                    <td height="8" align="left" colspan="6" class="command">
                                                                                        <a href="javascript:cmdPostJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a>                                                                                        
                                                                                    </td>
                                                                                </tr>     
                                                                                <%}%>
                                                                                <tr align="left" valign="top"> 
                                                                                    <td height="8" align="left" colspan="6" class="command"> 
                                                                                    </td>
                                                                                </tr> 
                                                                            </table> 
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr align="left" valign="top"> 
                                    <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
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
            <%@ include file = "../main/footer.jsp" %>
    <!-- #EndEditable --> </td>
</tr>
</table>
</body>
<!-- #EndTemplate --></html>
