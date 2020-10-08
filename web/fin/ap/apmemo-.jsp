
<%-- 
    Document   : apmemo
    Created on : Nov 7, 2012, 10:56:07 AM
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
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
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

<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidArap = JSPRequestValue.requestLong(request, "hidden_arap_id");
            String txtvendor = JSPRequestValue.requestString(request, "txt_vendor");
            long vendorId = JSPRequestValue.requestLong(request, "JSP_VENDOR_ID");
            String txtnumber = JSPRequestValue.requestString(request, "txt_number");
            long receiveId = JSPRequestValue.requestLong(request, "JSP_REF_ID");

            if (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD) {
                iJSPCommand = JSPCommand.ADD;
                oidArap = 0;
                txtvendor = "";
                vendorId = 0;
                txtnumber = "";
                receiveId = 0;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdArapMemo cmdArapMemo = new CmdArapMemo(request);
            JSPLine ctrLine = new JSPLine();
            iErrCode = cmdArapMemo.action(iJSPCommand, oidArap);
            
            JspArapMemo jspArapMemo = cmdArapMemo.getForm();
            ArapMemo arapMemo = cmdArapMemo.getArapMemo();
            msgString = cmdArapMemo.getMessage();
            
            if(arapMemo.getOID() != 0){
                oidArap = arapMemo.getOID();
            }

            String[] langAP = {"Date", "Vendor", "Number", "Period", "Date", "Vendor", "Invoice", "Amount", "Memo", "Amount", "Status", "Saved", "Delete Success", "Location"};
            String[] langNav = {"Account Payble", "AP Memo", "Record", "Editor", "Chose suplier first", "Delete data ?", "Number"};

            if (lang == LANG_ID) {
                String[] langID = {"Tanggal", "Vendor", "Number", "Periode", "Tanggal", "Suplier", "Faktur", "Jumlah", "Memo", "Jumlah", "Status", "Data Tersimpan", "Hapus data berhasil", "Lokasi"};
                langAP = langID;

                String[] navID = {"Hutang", "AP Memo", "Record", "Editor", "Pilih suplier terlebih dahulu", "Hapus data ?", "Nomor"};
                langNav = navID;
            }

            if (arapMemo.getVendorId() != 0) {
                try {
                    Vendor vnd = DbVendor.fetchExc(arapMemo.getVendorId());
                    vendorId = arapMemo.getVendorId();
                    txtvendor = vnd.getName();
                } catch (Exception e) {
                }
            }

            if (arapMemo.getRefId() != 0) {
                try {
                    Receive receive = DbReceive.fetchExc(arapMemo.getRefId());
                    txtnumber = receive.getNumber();
                    receiveId = arapMemo.getRefId();
                } catch (Exception e) {
                }
            }

            long currencyId = 0;
            try {
                currencyId = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
            } catch (Exception e) {
            }

            Vector accLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_OTHER_REVENUE + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");
            Vector accApLinks = DbAccLink.list(0, 0, "type='" + I_Project.ACC_LINK_GROUP_OTHER_REVENUE_AP + "' and (location_id=" + sysCompany.getSystemLocation() + " or location_id=0)", "");

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
            window.open("<%=approot%>/ap/srcvendor.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            }
            
            function cmdSearchFaktur(){ 
                if(document.frmarapmemo.JSP_VENDOR_ID.value == 0){
                    alert("<%=langNav[4]%>");
                    }else{    
                    window.open("<%=approot%>/ap/srcfaktur.jsp?txt_vendor_id=<%=vendorId%>", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");                        
                    }    
                }    
                
                function cmdToRecord(){
                    document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";            
                    document.frmarapmemo.action="apmemolist.jsp";
                    document.frmarapmemo.submit();
                }  
                
                function cmdDelete(){
                    var cfrm = confirm("<%=langNav[5]%>");                    
                        if( cfrm==true){                    
                            document.frmarapmemo.command.value="<%=JSPCommand.DELETE%>";            
                            document.frmarapmemo.action="apmemo.jsp";
                            document.frmarapmemo.submit();
                        }
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
                
                function cmdUpdateExchange(){                    
                    var famount = document.frmarapmemo.<%=JspArapMemo.colNames[JspArapMemo.JSP_AMOUNT]%>.value;                   
                    famount = cleanNumberFloat(famount, sysDecSymbol, usrDigitGroup, usrDecSymbol);  
                    
                    if(!isNaN(famount)){
                        document.frmarapmemo.<%=JspArapMemo.colNames[JspArapMemo.JSP_AMOUNT]%>.value= formatFloat(parseFloat(famount), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
                        
                    }            
                }
                
                function cmdSave(){
                    document.frmarapmemo.command.value="<%=JSPCommand.SAVE%>";
                    document.frmarapmemo.prev_command.value="<%=prevJSPCommand%>";
                    document.frmarapmemo.action="apmemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdResetAll(){
                    document.frmarapmemo.txt_vendor.value="";
                    document.frmarapmemo.JSP_VENDOR_ID.value="0";
                    document.frmarapmemo.txt_number.value="";
                    document.frmarapmemo.JSP_REF_ID.value="0";
                }
                
                function cmdReset(){                        
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
                    document.frmarapmemo.action="apmemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdBack(){
                    document.frmarapmemo.command.value="<%=JSPCommand.NONE%>";
                    document.frmarapmemo.action="adjusmentlist.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdListFirst(){
                    document.frmarapmemo.command.value="<%=JSPCommand.FIRST%>";
                    document.frmarapmemo.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmarapmemo.action="apmemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdListPrev(){
                    document.frmarapmemo.command.value="<%=JSPCommand.PREV%>";
                    document.frmarapmemo.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmarapmemo.action="apmemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdListNext(){
                    document.frmarapmemo.command.value="<%=JSPCommand.NEXT%>";
                    document.frmarapmemo.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmarapmemo.action="apmemo.jsp";
                    document.frmarapmemo.submit();
                }
                
                function cmdListLast(){
                    document.frmarapmemo.command.value="<%=JSPCommand.LAST%>";
                    document.frmarapmemo.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmarapmemo.action="apmemo.jsp";
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
                            <input type="hidden" name="<%=JspArapMemo.colNames[JspArapMemo.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                            <input type="hidden" name="hidden_arap_id" value="<%=oidArap%>">
                            <input type="hidden" name="<%=JspArapMemo.colNames[JspArapMemo.JSP_TYPE]%>" value="<%=DbArapMemo.TYPE_AP%>">
                            <input type="hidden" name="<%=JspArapMemo.colNames[JspArapMemo.JSP_CURRENCY_ID]%>" value="<%=currencyId%>">
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
                                                                                    <td colspan="6"> 
                                                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">                                                                                                                            
                                                                                            <tr > 
                                                                                                <td width="100%" nowrap>
                                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                        <tr > 
                                                                                                            <td class="tabin" nowrap> 
                                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink"><%=langNav[2]%></a>&nbsp;&nbsp;</div>
                                                                                                            </td>
                                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                            <td class="tab" nowrap> 
                                                                                                                <div align="center">&nbsp;&nbsp;<%=langNav[3]%>&nbsp;&nbsp;</div>
                                                                                                            </td>
                                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>                                                                                                                                
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td height="20">&nbsp;</td>
                                                                                </tr>    
                                                                                <tr>
                                                                                <td>
                                                                                    <table width="800" border="0" cellpadding="1" cellspacing="1">
                                                                                    <tr> 
                                                                                        <td width="10%"><%=langNav[6]%></td>
                                                                                        <td width="1%">:</td>
                                                                                        <td width="44%">
                                                                                            <%
            Vector periods = new Vector();
            Periode preClosedPeriod = new Periode();
            Periode openPeriod = new Periode();

            Vector vPreClosed = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE]);

            openPeriod = DbPeriode.getOpenPeriod();

            if (vPreClosed != null && vPreClosed.size() > 0) {
                for (int i = 0; i < vPreClosed.size(); i++) {
                    Periode prClosed = (Periode) vPreClosed.get(i);
                    if (i == 0) {
                        preClosedPeriod = prClosed;
                    }
                    periods.add(prClosed);
                }
            }

            if (openPeriod.getOID() != 0) {
                periods.add(openPeriod);
            }
            String strNumber = "";
            Periode open = new Periode();
            if (arapMemo.getPeriodeId() != 0) {
                try {
                    open = DbPeriode.fetchExc(arapMemo.getPeriodeId());
                } catch (Exception e) {
                }
            } else {
                if (preClosedPeriod.getOID() != 0) {
                    open = DbPeriode.getPreClosedPeriod();
                } else {
                    open = DbPeriode.getOpenPeriod();
                }
            }
            int counterJournal = DbSystemDocNumber.getNextCounterApMemo(open.getOID());
            strNumber = DbSystemDocNumber.getNextNumberApMemo(counterJournal, open.getOID());
            if (arapMemo.getOID() != 0 || oidArap != 0) {
                strNumber = arapMemo.getNumber();
            }
                                                                                            %>
                                                                                            <%=strNumber%>     
                                                                                        </td>
                                                                                        <td width="10%"><%=langAP[3]%></td>
                                                                                        <td width="1%">:</td>
                                                                                        <td width="44%">     
                                                                                            <select name="<%=JspArapMemo.colNames[JspArapMemo.JSP_PERIODE_ID]%>">
                                                                                                <%
            if (periods != null && periods.size() > 0) {
                for (int t = 0; t < periods.size(); t++) {
                    Periode objPeriod = (Periode) periods.get(t);

                                                                                                %>
                                                                                                <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == arapMemo.getPeriodeId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                <%}%><%}%>
                                                                                            </select>                                                                                            
                                                                                        </td>
                                                                                    </tr>
                                                                                    <%
            if (iJSPCommand == JSPCommand.NONE) {
                vendorId = 0;
                txtvendor = "-";
                receiveId = 0;
            }
                                                                                    %>
                                                                                    <tr> 
                                                                                        <td ><%=langAP[5]%></td>
                                                                                        <td >:</td>
                                                                                        <td >
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <input size="30" readonly type="text" name="txt_vendor" value="<%=txtvendor%>">
                                                                                                </td>
                                                                                                <td>
                                                                                                    <input type="hidden" name="JSP_VENDOR_ID" value="<%=vendorId%>">
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;<a href="javascript:cmdSearchVendor()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;<a href="javascript:cmdResetAll()" >Reset</a>
                                                                                                </td>
                                                                                                <td>
                                                                                                    &nbsp;<%=jspArapMemo.getErrorMsg(jspArapMemo.JSP_VENDOR_ID) %>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </table>
                                                                                        <td ><%=langAP[4]%></td>
                                                                                        <td >:</td>
                                                                                        <td >
                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <input name="<%=JspArapMemo.colNames[JspArapMemo.JSP_DATE]%>" value="<%=JSPFormater.formatDate((arapMemo.getDate() == null) ? new Date() : arapMemo.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                    </td>    
                                                                                                    <td>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmarapmemo.<%=JspArapMemo.colNames[JspArapMemo.JSP_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                    </td>
                                                                                                    <td valign="top">&nbsp;<%=jspArapMemo.getErrorMsg(jspArapMemo.JSP_DATE) %></td>
                                                                                                </tr>
                                                                                            </table> 
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td valign="top"><%=langAP[6]%></td>
                                                                                        <td valign="top">:</td>
                                                                                        <td valign="top">
                                                                                            <table border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <input size="30" readonly type="text" name="txt_number" value="<%=txtnumber%>" >
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <input type="hidden" name="JSP_REF_ID" value="<%=receiveId%>">
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;<a href="javascript:cmdSearchFaktur()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/search.jpg',1)"><img src="../images/search2.jpg" name="new211" height="17" border="0" style="padding:0px"></a>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        &nbsp;<a href="javascript:cmdReset()" >Reset</a>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                        <td valign="top"><%=langAP[13]%></td>
                                                                                        <td valign="top">:</td>
                                                                                        <td valign="top">
                                                                                            <%
            Vector vLocation = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);

            if (vLocation != null && vLocation.size() > 0) {
                                                                                            %>  
                                                                                            <select name="<%=JspArapMemo.colNames[JspArapMemo.JSP_LOCATION_ID]%>">
                                                                                                <%
                                                                                                for (int ix = 0; ix < vLocation.size(); ix++) {
                                                                                                    Location loc = (Location) vLocation.get(ix);
                                                                                                %>             
                                                                                                <option value="<%=loc.getOID()%>" <%if (arapMemo.getLocationId() == loc.getOID()) {%> selected <%}%> ><%=loc.getName()%></option>
                                                                                                <%}%> 
                                                                                            </select>
                                                                                            <%}%>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td valign="top">Other Revenue</td>
                                                                                        <td valign="top">:</td>
                                                                                        <td valign="top">
                                                                                            <select name="<%=JspArapMemo.colNames[JspArapMemo.JSP_COA_ID]%>">
                                                                                                <%if (accLinks != null && accLinks.size() > 0) {
                for (int i = 0; i < accLinks.size(); i++) {
                    AccLink accLink = (AccLink) accLinks.get(i);
                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(accLink.getCoaId());
                    } catch (Exception e) {
                    }

                    if (arapMemo.getCoaId() == 0 && i == 0) {
                        arapMemo.setCoaId(accLink.getCoaId());
                    }
                                                                                                %>
                                                                                                <option <%if (arapMemo.getCoaId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                <%=getAccountRecursif(coa.getLevel() * -1, coa, arapMemo.getCoaId(), isPostableOnly)%> 
                                                                                                <%}
} else {%>
                                                                                                <option><%=langNav[3]%></option>
                                                                                                <%}%>
                                                                                            </select>
                                                                                            <%= jspArapMemo.getErrorMsg(jspArapMemo.JSP_COA_ID) %>
                                                                                        </td>
                                                                                        <td valign="top">AP</td>
                                                                                        <td valign="top">:</td>
                                                                                        <td valign="top">
                                                                                            <select name="<%=JspArapMemo.colNames[JspArapMemo.JSP_COA_AP_ID]%>">
                                                                                                <%if (accLinks != null && accLinks.size() > 0) {
                for (int i = 0; i < accApLinks.size(); i++) {
                    AccLink accLink = (AccLink) accApLinks.get(i);
                    Coa coa = new Coa();
                    try {
                        coa = DbCoa.fetchExc(accLink.getCoaId());
                    } catch (Exception e) {
                    }

                    if (arapMemo.getCoaApId() == 0 && i == 0) {
                        arapMemo.setCoaApId(accLink.getCoaId());
                    }
                                                                                                %>
                                                                                                <option <%if (arapMemo.getCoaApId() == coa.getOID()) {%>selected<%}%> value="<%=coa.getOID()%>"><%=coa.getCode() + " - " + coa.getName()%></option>
                                                                                                <%=getAccountRecursif(coa.getLevel() * -1, coa, arapMemo.getCoaApId(), isPostableOnly)%> 
                                                                                                <%}
} else {%>
                                                                                                <option><%=langNav[3]%></option>
                                                                                                <%}%>
                                                                                            </select>
                                                                                            <%= jspArapMemo.getErrorMsg(jspArapMemo.JSP_COA_AP_ID) %>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td valign="top"><%=langAP[9]%></td>
                                                                                        <td valign="top">:</td>
                                                                                        <td valign="top">
                                                                                            <input type="text" name="<%=JspArapMemo.colNames[JspArapMemo.JSP_AMOUNT]%>" size="15" value="<%=JSPFormater.formatNumber(arapMemo.getAmount(), "#,###.##")%>" style="text-align:right" onChange="javascript:cmdUpdateExchange()">&nbsp;<%if (iJSPCommand != JSPCommand.REFRESH) {%><%=jspArapMemo.getErrorMsg(jspArapMemo.JSP_AMOUNT) %> <%}%>
                                                                                        </td>
                                                                                        <td valign="top"><%=langAP[10]%></td>
                                                                                        <td valign="top">:</td>
                                                                                        <td valign="top">
                                                                                            <%if (arapMemo.getStatus() != DbArapMemo.TYPE_STATUS_POSTED) {%>
                                                                                            <select name="<%=JspArapMemo.colNames[JspArapMemo.JSP_STATUS]%>">
                                                                                                <option value="<%=DbArapMemo.TYPE_STATUS_DRAFT%>" <%if (arapMemo.getStatus() == DbArapMemo.TYPE_STATUS_DRAFT) {%> selected <%}%> >DRAFT</option>
                                                                                                <option value="<%=DbArapMemo.TYPE_STATUS_APPROVED%>" <%if (arapMemo.getStatus() == DbArapMemo.TYPE_STATUS_APPROVED) {%> selected <%}%> >APPROVE</option>
                                                                                            </select>
                                                                                            <%} else {%>
                                                                                            <input type="hidden" name="<%=JspArapMemo.colNames[JspArapMemo.JSP_STATUS]%>" value="<%=DbArapMemo.TYPE_STATUS_POSTED%>">
                                                                                            POSTED
                                                                                            <%}%>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td valign="top"><%=langAP[8]%></td>
                                                                                        <td valign="top">:</td>
                                                                                        <td valign="top">
                                                                                            <textarea name="<%=JspArapMemo.colNames[JspArapMemo.JSP_MEMO]%>" cols="36" rows="3"><%=arapMemo.getMemo()%></textarea><%if (iJSPCommand != JSPCommand.REFRESH) {%><%=jspArapMemo.getErrorMsg(jspArapMemo.JSP_MEMO) %> <%}%>
                                                                                        </td>
                                                                                        <td valign="top"></td>
                                                                                        <td valign="top"></td>
                                                                                        <td valign="top"></td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                    <td valign="top" colspan="6">&nbsp;</td>
                                                                                </td>   
                                                                                <%if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0) {%>
                                                                                <tr> 
                                                                                    <td valign="top" colspan="6">
                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                            <tr> 
                                                                                                <td width="15"><img src="../images/success.gif" height="20"></td>
                                                                                                <td width="100" nowrap><%=langAP[12]%></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td> 
                                                                                </tr>    
                                                                                <%}%>                                                                                 
                                                                                <%if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {%>
                                                                                <tr> 
                                                                                    <td valign="top" colspan="6">
                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                            <tr> 
                                                                                                <td width="15"><img src="../images/success.gif" height="20"></td>
                                                                                                <td width="100" nowrap><%=langAP[11]%></td>
                                                                                            </tr>
                                                                                        </table>
                                                                                    </td> 
                                                                                </tr>    
                                                                                <%}%>                                                                                       
                                                                                <tr> 
                                                                                    <td valign="top" colspan="6">
                                                                                        <%if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0) {%>
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <a href="javascript:cmdToRecord()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" height="22" border="0"></a>
                                                                                                </td>                                                                                                
                                                                                            </tr>    
                                                                                        </table> 
                                                                                        <%} else {%>
                                                                                        <table border="0" cellpadding="0" cellspacing="0">
                                                                                            <%if (arapMemo.getStatus() != DbArapMemo.TYPE_STATUS_POSTED) {%>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <a href="javascript:cmdSave()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('savedoc21','','../images/save2.gif',1)"><img src="../images/save.gif" name="savedoc21" height="22" border="0"></a>
                                                                                                </td>
                                                                                                <td width="5"></td>
                                                                                                <%if (arapMemo.getOID() != 0) {%>
                                                                                                <td>
                                                                                                    <a href="javascript:cmdDelete()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del','','../images/delete2.gif',1)"><img src="../images/delete.gif" name="del" height="22" border="0"></a>
                                                                                                </td>
                                                                                                <%}%>
                                                                                            </tr>    
                                                                                            <%} else {%>
                                                                                            <tr>
                                                                                                <td colspan="3">
                                                                                                    <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                        <tr> 
                                                                                                            <td width="15"><img src="../images/success.gif" height="20"></td>
                                                                                                            <td width="100" nowrap>POSTED</td>
                                                                                                        </tr>
                                                                                                    </table>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td colspan="3" height="4"></td>
                                                                                            </tr>    
                                                                                            <tr>
                                                                                                <td colspan="3">
                                                                                                    <a href="javascript:cmdToRecord()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('back','','../images/back2.gif',1)"><img src="../images/back.gif" name="back" height="22" border="0"></a>
                                                                                                </td>                                                                                                
                                                                                            </tr>  
                                                                                            <%}%>
                                                                                        </table>     
                                                                                        <%}%>
                                                                                    </td>                                                                                                                                
                                                                                </tr>  
                                                                                <%if (arapMemo.getOID() > 0) {%>
                                                                                <tr>
                                                                                    <td colspan="6" height="20"></td>
                                                                                </tr>    
                                                                                <tr>
                                                                                    <td colspan="6">
                                                                                        <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                            <tr> 
                                                                                                <td width="33%" class="tablecell1"><b><u>Document 
                                                                                                History</u></b></td>
                                                                                                <td width="34%" class="tablecell1"> 
                                                                                                    <div align="center"><b><u>User</u></b></div>
                                                                                                </td>
                                                                                                <td width="33%" class="tablecell1"> 
                                                                                                    <div align="center"><b><u>Date</u></b></div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr> 
                                                                                                <td width="33%" class="tablecell1"><i>Prepared 
                                                                                                By</i></td>
                                                                                                <td width="34%" class="tablecell1"> 
                                                                                                    <div align="center"> <i> 
                                                                                                            <%
    User u = new User();
    try {
        u = DbUser.fetch(arapMemo.getApproval1());
    } catch (Exception e) {
    }
                                                                                                            %>
                                                                                                    <%=u.getLoginId()%></i></div>
                                                                                                </td>
                                                                                                <td width="33%" class="tablecell1"> 
                                                                                                    <%if (arapMemo.getDateApp1() != null) {%>
                                                                                                    <div align="center"><i><%=JSPFormater.formatDate(arapMemo.getDateApp1(), "dd MMMM yy")%></i></div>
                                                                                                    <%}%>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr> 
                                                                                                <td width="33%" class="tablecell1"><i>Approved by</i></td>
                                                                                                <td width="34%" class="tablecell1"> 
                                                                                                    <div align="center"> <i> 
                                                                                                            <%
    u = new User();
    try {
        u = DbUser.fetch(arapMemo.getApproval2());
    } catch (Exception e) {
    }
                                                                                                            %>
                                                                                                    <%=u.getLoginId()%></i></div>
                                                                                                </td>
                                                                                                <td width="33%" class="tablecell1"> 
                                                                                                    <div align="center"> <i> 
                                                                                                            <%if (arapMemo.getApproval2() != 0 && arapMemo.getDateApp2() != null) {%>
                                                                                                            <%=JSPFormater.formatDate(arapMemo.getDateApp2(), "dd MMMM yy")%> 
                                                                                                            <%}%>
                                                                                                    </i></div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <tr> 
                                                                                                <td width="33%" class="tablecell1"><i>Posted 
                                                                                                by</i> </td>
                                                                                                <td width="34%" class="tablecell1"> 
                                                                                                    <div align="center"><i> 
                                                                                                            <%
    u = new User();
    try {
        u = DbUser.fetch(arapMemo.getPostedById());
    } catch (Exception e) {
    }
                                                                                                            %>
                                                                                                    <%=u.getLoginId()%></i></div>
                                                                                                </td>
                                                                                                <td width="33%" class="tablecell1"> 
                                                                                                    <div align="center"><i> 
                                                                                                            <%if (arapMemo.getPostedById() != 0 && arapMemo.getPostedDate() != null) {%>
                                                                                                            <%=JSPFormater.formatDate(arapMemo.getPostedDate(), "dd MMMM yy")%> 
                                                                                                            <%}%>
                                                                                                    </i></div>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <%}%>
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
