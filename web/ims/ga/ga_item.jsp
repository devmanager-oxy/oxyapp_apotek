
<%-- 
    Document   : ga_item
    Created on : May 21, 2015, 5:03:04 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.ga.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_PRINT);

            boolean privApproved = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA_APPROVED);
            boolean privViewApproved = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA_APPROVED, AppMenu.PRIV_VIEW);
%>


<%

            if (session.getValue("KONSTAN_GENERAL_AFFAIR") != null) {
                session.removeValue("KONSTAN_GENERAL_AFFAIR");
            }

            if (session.getValue("DETAIL_GENERAL_AFFAIR") != null) {
                session.removeValue("DETAIL_GENERAL_AFFAIR");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidGeneralAffair = JSPRequestValue.requestLong(request, "hidden_general_affair_id");
            long oidGeneralAffairDetail = JSPRequestValue.requestLong(request, "hidden_general_affair_item_id");
            String itemBarcode = JSPRequestValue.requestString(request, "item_barcode");
            String itemCode = JSPRequestValue.requestString(request, "item_code");
            long oidItem = JSPRequestValue.requestLong(request, "xxhidden_item_id");

            if (itemCode.equalsIgnoreCase("")) {
                itemCode = itemBarcode;
            }

            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";
            CmdGeneralAffair cmdGeneralAffair = new CmdGeneralAffair(request);
            cmdGeneralAffair.setUserId(user.getOID());
            JSPLine jspLine = new JSPLine();

            iErrCode = cmdGeneralAffair.action(iJSPCommand, oidGeneralAffair);
            JspGeneralAffair jspGeneralAffair = cmdGeneralAffair.getForm();
            GeneralAffair generalAffair = cmdGeneralAffair.getGeneralAffair();
            msgString = cmdGeneralAffair.getMessage();

            Vector locations = userLocations;
            if (iJSPCommand == JSPCommand.NONE) {
                generalAffair.setStatus(I_Project.DOC_STATUS_DRAFT);
                if (locations != null && locations.size() > 0) {
                    Location lxx = (Location) locations.get(0);
                    generalAffair.setLocationId(lxx.getOID());
                }
                iJSPCommand = JSPCommand.ADD;
            }

            if (oidGeneralAffair == 0) {
                oidGeneralAffair = generalAffair.getOID();
            }

            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            CmdGeneralAffairDetail cmdGeneralAffairDetail = new CmdGeneralAffairDetail(request);
            cmdGeneralAffairDetail.setOidGeneralAffair(generalAffair.getOID());
            cmdGeneralAffairDetail.setStatus(generalAffair.getStatus());
            iErrCode2 = cmdGeneralAffairDetail.action(iJSPCommand, oidGeneralAffairDetail);

            JspGeneralAffairDetail jspGeneralAffairDetail = cmdGeneralAffairDetail.getForm();
            GeneralAffairDetail generalAffairDetail = cmdGeneralAffairDetail.getGeneralAffairDetail();
            msgString2 = cmdGeneralAffairDetail.getMessage();

            whereClause = DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_GENERAL_AFFAIR_ID] + "=" + oidGeneralAffair;
            orderClause = DbGeneralAffairDetail.colNames[DbGeneralAffairDetail.COL_GENERAL_AFFAIR_DETAIL_ID];
            Vector generalAffairDetails = DbGeneralAffairDetail.list(0, 0, whereClause, orderClause);
            boolean saved = false;
            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) {
                iJSPCommand = JSPCommand.ADD;
                oidGeneralAffairDetail = 0;
                generalAffairDetail = new GeneralAffairDetail();
                saved = true;
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidGeneralAffairDetail = 0;
                generalAffairDetail = new GeneralAffairDetail();
            }

            Uom uomx = new Uom();
            ItemMaster itemMaster = new ItemMaster();
            if (iJSPCommand == JSPCommand.LOAD) {
                if (itemCode.length() > 0) {
                    Vector vlist = DbItemMaster.list(0, 1, " code like '%" + itemCode + "%'" + " or barcode like '%" + itemCode + "%'" + " or barcode_2 like '%" + itemCode + "%'" + " or barcode_3 like '%" + itemCode + "%'", "");
                    if (vlist != null && vlist.size() > 0) {
                        itemMaster = (ItemMaster) vlist.get(0);
                        uomx = DbUom.fetchExc(itemMaster.getUomStockId());
                        generalAffairDetail.setItemMasterId(itemMaster.getOID());
                        generalAffairDetail.setPrice(itemMaster.getCogs());
                        generalAffairDetail.setQty(1);
                        generalAffairDetail.setAmount(itemMaster.getCogs() * 1);
                    }
                }else{
                    try{
                        if(oidItem != 0){
                            itemMaster = DbItemMaster.fetchExc(oidItem);
                            uomx = DbUom.fetchExc(itemMaster.getUomStockId());
                            generalAffairDetail.setItemMasterId(itemMaster.getOID());
                            generalAffairDetail.setPrice(itemMaster.getCogs());
                            generalAffairDetail.setQty(1);
                            generalAffairDetail.setAmount(itemMaster.getCogs() * 1);
                        }    
                    }catch(Exception e){}        
                }
            }


            if (iErrCode == 0 && iErrCode2 == 0 && generalAffair.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && (iJSPCommand == JSPCommand.ASSIGN || saved)) {
                DbGeneralAffairDetail.proceedStock(generalAffair);
            }

            Vector vpar = new Vector();
            vpar.add("" + generalAffair.getNumber());
            vpar.add("" + generalAffair.getLocationId());
            vpar.add("" + generalAffair.getLocationPostId());
            vpar.add("" + JSPFormater.formatDate(generalAffair.getTransactionDate(), "dd/MM/yyyy"));
            vpar.add("" + generalAffair.getStatus());
            vpar.add("" + generalAffair.getNote());
            vpar.add("" + user.getFullName());


%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=titleIS%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        <!--
        
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        function cmdAddItemMaster(){              
            window.open("<%=approot%>/ga/addga.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                document.frmgeneralaffair.command.value="<%=JSPCommand.LOAD%>";
            }
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.ReportGaXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdSaveOnEnter(e){
                    if (typeof e == 'undefined' && window.event) { e = window.event; }
                    if (e.keyCode == 13)
                        {
                            document.frmgeneralaffair.item_code.focus();  
                            cmdCalc();
                            cmdSave();
                        }
                    }
                    
                    function cmdAdd(){
                        document.frmgeneralaffair.hidden_general_affair_item_id.value="0";
                        document.frmgeneralaffair.command.value="<%=JSPCommand.ADD%>";
                        document.frmgeneralaffair.prev_command.value="<%=prevJSPCommand%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
                    }
                    
                    function cmdAddNewDoc(){
                        document.frmgeneralaffair.hidden_general_affair_id.value="0";
                        document.frmgeneralaffair.hidden_general_affair_item_id.value="0";
                        document.frmgeneralaffair.command.value="<%=JSPCommand.ADD%>";
                        document.frmgeneralaffair.prev_command.value="<%=prevJSPCommand%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
                    }
                    
                    function cmdAsk(oidGaDetail){
                        document.frmgeneralaffair.hidden_general_affair_item_id.value=oidGaDetail;
                        document.frmgeneralaffair.command.value="<%=JSPCommand.ASK%>";
                        document.frmgeneralaffair.prev_command.value="<%=prevJSPCommand%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
                    }
                    
                    function cmdConfirmDelete(oidGaDetail){
                        document.frmgeneralaffair.hidden_general_affair_item_id.value=oidGaDetail;
                        document.frmgeneralaffair.command.value="<%=JSPCommand.DELETE%>";
                        document.frmgeneralaffair.prev_command.value="<%=prevJSPCommand%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
                    }
                    
                    function cmdLoadItem(oidGaDetail){ 
                        document.frmgeneralaffair.hidden_general_affair_item_id.value=oidGaDetail;
                        document.frmgeneralaffair.command.value="<%=JSPCommand.LOAD%>";
                        document.frmgeneralaffair.<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_QTY]%>.focus();  
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();  
                    }
                    
                    var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
                    var usrDigitGroup = "<%=sUserDigitGroup%>";
                    var usrDecSymbol = "<%=sUserDecimalSymbol%>";
                    
                    function cmdCalc(){ 
                        var price = document.frmgeneralaffair.<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_PRICE]%>.value;
                        price = cleanNumberFloat(price, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        
                        var qty = document.frmgeneralaffair.<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_QTY]%>.value;    
                        qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        
                        document.frmgeneralaffair.<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_PRICE]%>.value=formatFloat(price, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);   
                        document.frmgeneralaffair.<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_QTY]%>.value=formatFloat(qty, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);   
                        document.frmgeneralaffair.<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_AMOUNT]%>.value=formatFloat((qty * price), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);   
                        
                    }
                    
                    function cmdSave(){
                        document.frmgeneralaffair.command.value="<%=JSPCommand.SAVE%>";
                        document.frmgeneralaffair.prev_command.value="<%=prevJSPCommand%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
                    }
                    
                    function cmdSaveDoc(){
                        document.frmgeneralaffair.command.value="<%=JSPCommand.ASSIGN%>";
                        document.frmgeneralaffair.prev_command.value="<%=prevJSPCommand%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
                    }
                    
                    function cmdEdit(oidGaDetail){
                        document.frmgeneralaffair.hidden_general_affair_item_id.value=oidGaDetail;
                        document.frmgeneralaffair.command.value="<%=JSPCommand.EDIT%>";
                        document.frmgeneralaffair.prev_command.value="<%=prevJSPCommand%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
                    }
                    
                    function cmdCancel(oidTransfer){
                        document.frmgeneralaffair.hidden_general_affair_item_id.value=oidTransfer;
                        document.frmgeneralaffair.command.value="<%=JSPCommand.EDIT%>";
                        document.frmgeneralaffair.prev_command.value="<%=prevJSPCommand%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
                    }
                    
                    function cmdBack(){
                        document.frmgeneralaffair.command.value="<%=JSPCommand.BACK%>";
                        document.frmgeneralaffair.action="ga_item.jsp";
                        document.frmgeneralaffair.submit();
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
            <%@ include file="../main/hmenu.jsp"%>
    <!-- #EndEditable --> </td>
</tr>
<tr> 
<td valign="top"> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
<!--DWLayoutTable-->
<tr> 
<td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
    <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
<!-- #EndEditable --> </td>
<td width="100%" valign="top"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td><!-- #BeginEditable "content" --> 
<form name="frmgeneralaffair" method ="post" action="">
<input type="hidden" name="command" value="<%=iJSPCommand%>">
<input type="hidden" name="start" value="0">
<input type="hidden" name="menu_idx" value="<%=menuIdx%>">
<input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
<input type="hidden" name="hidden_general_affair_id" value="<%=oidGeneralAffair%>">
<input type="hidden" name="hidden_general_affair_item_id" value="<%=oidGeneralAffairDetail%>">                            
<input type="hidden" name="<%= JspGeneralAffair.colNames[JspGeneralAffair.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>"> 
<input type="hidden" name="xxhidden_item_id" value="<%=0%>">                            
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> 
    <td valign="top"> 
        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
            <tr valign="bottom"> 
                <td width="60%" height="23"><b><font color="#990000" class="lvl1">General Affair 
                        </font><font class="tit1">&raquo; <span class="lvl2">General Affair
                Detail </span></font></b></td>
                <td width="40%" height="23"> 
                    <%@ include file = "../main/userpreview.jsp" %>
                </td>
            </tr>
            <tr > 
                <td colspan="2" height="3" background="<%=approot%>/images/line1.gif" ></td>
            </tr>
        </table>
    </td>
</tr>
<tr> 
    <td >&nbsp</td> 
</tr>                                                                    
<tr> 
    <td class="container"> 
        <table width="100%" border="0" cellpadding="0" cellspacing="1">
            <tr>
                <td colspan="2"></td>
                <td coslpan="4" class="fontarial"><i>*) entry required</i></td>
            </tr>    
            <tr align="left" height="20"> 
                <td width="80" class="tablearialcell">&nbsp;&nbsp;Number</td>
                <td width="1" class="fontarial">:</td>
                <td width="300" class="fontarial">
                    <%
            String number = "";
            if (generalAffair.getOID() == 0) {
                int ctr = DbGeneralAffair.getNextCounter();
                number = DbGeneralAffair.getNextNumber(ctr);
                generalAffair.setNumber(number);
            } else {
                number = generalAffair.getNumber();
            }
                    %>
                <b><i><%=number%></i></b> </td>
                <td width="80" class="tablearialcell">&nbsp;&nbsp;Date</td>
                <td width="1" class="fontarial">:</td>
                <td class="comment">
                    <input name="<%=jspGeneralAffair.colNames[JspGeneralAffair.JSP_TRANSACTION_DATE]%>" value="<%=JSPFormater.formatDate((generalAffair.getTransactionDate() == null) ? new Date() : generalAffair.getTransactionDate(), "dd/MM/yyyy")%>" size="11" readonly>
                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmgeneralaffair.<%=JspGeneralAffair.colNames[JspGeneralAffair.JSP_TRANSACTION_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a>                                                                                     
                </td>
            </tr>                                                                            
            <tr align="left" height="20"> 
                <td  class="tablearialcell">&nbsp;&nbsp;Location</td>
                <td class="fontarial">:</td>
                <td >
                    <%if (!generalAffair.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !generalAffair.getStatus().equals(I_Project.STATUS_POSTED)) {%>												
                    <span class="comment"> 
                        <select name="<%=jspGeneralAffair.colNames[JspGeneralAffair.JSP_LOCATION_ID]%>" class="fontarial" onChange="javascript:cmdLocation()">
                            <%

    if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location d = (Location) locations.get(i);
                            %>
                            <option value="<%=d.getOID()%>" <%if (generalAffair.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                            <%}
    }%>
                        </select>
                    </span>
                    <%} else {%>
                    <input type="hidden" name="<%=jspGeneralAffair.colNames[JspGeneralAffair.JSP_LOCATION_ID]%>" value="<%=generalAffair.getLocationId()%>">
                    <%

                try {
                    Location l = DbLocation.fetchExc(generalAffair.getLocationId());
                    out.println(l.getCode() + " - " + l.getName());
                } catch (Exception e) {
                }

            }%>
                    * <%=jspGeneralAffair.getErrorMsg(JspGeneralAffair.JSP_LOCATION_ID)%>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
                </td> 
                <td valign="top" class="tablearialcell">&nbsp;&nbsp;Status</td>
                <td width="1" class="fontarial">:</td>
                <td class="comment" valign="top"><input type="text" name="txtStatus" value="<%=generalAffair.getStatus()%>" class="readOnly" readonly>
                    
                </td>
            </tr>
            <tr align="left"> 
                <td valign="top" >
                    <table width="100%" height="20" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="tablearialcell">&nbsp;&nbsp;Notes</td>                                                                                            
                        </tr>
                    </table>
                </td>
                <td width="1" class="fontarial" valign="top">:</td>
                <td valign="top">
                    <textarea name="<%=jspGeneralAffair.colNames[JspGeneralAffair.JSP_NOTE]%>" cols="30" rows="2" class="fontarial"><%=generalAffair.getNote()%></textarea> * <%=jspGeneralAffair.getErrorMsg(JspGeneralAffair.JSP_NOTE)%>                                                                                  
                </td>
                <td valign="top">
                    <table width="100%" height="20" border="0" cellpadding="0" cellspacing="0">
                        <tr><td class="tablearialcell">&nbsp;&nbsp;Cost Location</td></tr>
                    </table>    
                </td>
                <td width="1" class="fontarial" valign="top">:</td>
                <td valign="top">
                    <select name="<%=jspGeneralAffair.colNames[JspGeneralAffair.JSP_LOCATION_POST_ID]%>" class="fontarial">
                        <option value="0" <%if (generalAffair.getLocationPostId() == 0) {%>selected<%}%>>- Select Location-</option>
                        <%

            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                        %>
                        <option value="<%=d.getOID()%>" <%if (generalAffair.getLocationPostId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                        <%}
            }%>
                    </select>
                    * <%=jspGeneralAffair.getErrorMsg(JspGeneralAffair.JSP_LOCATION_POST_ID)%> 
                </td>
            </tr>
        </table>
    </td>
</tr> 
<tr>
    <td height="10"></td> 
</tr>  
<tr>
<td class="container"> 
<table width="1050" border="0" cellpadding="0" cellspacing="1">
<tr height="23">
    <td class="tablearialhdr" width="25">No</td>
    <td class="tablearialhdr" width="130">Sku</td>
    <td class="tablearialhdr" width="110">Barcode</td>
    <td class="tablearialhdr">Name</td>
    <td class="tablearialhdr" width="70">Unit</td>
    <td class="tablearialhdr" width="80">Qty</td>
    <td class="tablearialhdr" width="100">Price</td>
    <td class="tablearialhdr" width="120">Total</td>
</tr>   
<%
            int nomor = 1;
            double totQty = 0;
            double totAmount = 0;
            boolean edit = false;
            Vector tmp = new Vector();

            for (int i = 0; i < generalAffairDetails.size(); i++) {
                GeneralAffairDetail objItem = (GeneralAffairDetail) generalAffairDetails.get(i);

                String style = "";

                if (i % 2 == 0) {
                    style = "tablearialcell";
                } else {
                    style = "tablearialcell1";
                }

                ItemMaster im = new ItemMaster();
                Uom uom = new Uom();
                try {
                    im = DbItemMaster.fetchExc(objItem.getItemMasterId());
                    uom = DbUom.fetchExc(im.getUomStockId());
                } catch (Exception e) {
                    System.out.println(e);
                }

                if ((iJSPCommand != JSPCommand.POST && oidGeneralAffairDetail == objItem.getOID() && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.LOAD || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.ASK || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0)))) {
                    edit = true;
                    if (iJSPCommand == JSPCommand.LOAD) {
                        try {
                            im = DbItemMaster.fetchExc(itemMaster.getOID());
                            uom = DbUom.fetchExc(im.getUomStockId());
                        } catch (Exception e) {
                            System.out.println(e);
                        }
                    }
%>
<input type="hidden" name="<%=jspGeneralAffairDetail.colNames[jspGeneralAffairDetail.JSP_ITEM_MASTER_ID]%>" value="<%=im.getOID()%>">
<tr height="23">
    <td bgcolor="#E0FCC2" align="center"><%=(nomor)%></td>
    <td bgcolor="#E0FCC2" align="center"><input type="text" size="10" name="item_code" value="<%=im.getCode()%>" class="fontarial" style="padding:2px;" onChange="javascript:cmdLoadItem('<%=objItem.getOID()%>')"></td>
    <td bgcolor="#E0FCC2" align="center"><input type="text" size="13" name="item_barcode" value="<%=im.getBarcode()%>" class="fontarial" style="padding:2px;" onChange="javascript:cmdLoadItem('<%=objItem.getOID()%>')"></td>
    <td bgcolor="#E0FCC2" align="left" class="fontarial" style="padding:2px;" ><%=im.getName()%></td>
    <td bgcolor="#E0FCC2" align="left" class="fontarial" style="padding:2px;" ><%=uom.getUnit()%></td>                                                                                
    <td bgcolor="#E0FCC2" align="center"><input type="text" name="<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_QTY]%>" value="<%=JSPFormater.formatNumber(objItem.getQty(), "###,###.##")%>" size="6" class="fontarial" style="text-align:right;padding:2px;" onBlur="javascript:calculateSubTotal()" onkeypress="cmdSaveOnEnter(event)" >*<%=jspGeneralAffairDetail.getErrorMsg(jspGeneralAffairDetail.JSP_QTY)%></td>
    <td bgcolor="#E0FCC2" align="center"><input type="text" name="<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_PRICE]%>" value="<%=JSPFormater.formatNumber(im.getCogs(), "###,###.##")%>" size="15" class="readOnly" style="text-align:right;padding:2px;" readonly></td>
    <td bgcolor="#E0FCC2" align="center"><input type="text" name="<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber((objItem.getQty() * im.getCogs()), "###,###.##")%>" readonly size="18" class="readOnly" style="text-align:right;padding:2px;"></td>    
</tr> 
<%} else {%>
<tr height="23">
    <td class="<%=style%>" align="center"><%=(i + 1)%></td>
    <%if (generalAffair.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_APPROVED) || generalAffair.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_POSTED)) {%>
    <td class="<%=style%>" style="padding:3px;"><%=im.getCode()%></td>                                                                                
    <%} else {%>
    <td class="<%=style%>" style="padding:3px;"><a href="javascript:cmdEdit('<%=String.valueOf(objItem.getOID())%>')"><%=im.getCode()%></a></td>
    <%}%>
    <td class="<%=style%>" style="padding:3px;"><%=im.getBarcode()%></td>
    <td class="<%=style%>" style="padding:3px;"><%=im.getName()%></td>
    <td class="<%=style%>" style="padding:3px;"><%=uom.getUnit()%></td>
    <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(objItem.getQty(), "###,###.##")%></td>
    <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(objItem.getPrice(), "###,###.##")%></td>
    <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber((objItem.getQty() * objItem.getPrice()), "###,###.##")%></td>
</tr> 
<%}%>
<%

                nomor++;

                totQty = totQty + objItem.getQty();
                totAmount = totAmount + (objItem.getQty() * objItem.getPrice());

                Vector tmpPrint = new Vector();
                tmpPrint.add("" + im.getCode());
                tmpPrint.add("" + im.getBarcode());
                tmpPrint.add("" + im.getName());
                tmpPrint.add("" + uom.getUnit());
                tmpPrint.add(JSPFormater.formatNumber(objItem.getQty(), "###.##"));
                tmpPrint.add(JSPFormater.formatNumber(objItem.getPrice(), "###.##"));
                tmpPrint.add(JSPFormater.formatNumber((objItem.getQty() * objItem.getPrice()), "###.##"));
                tmp.add(tmpPrint);
            }


            boolean add = false;
            if (iJSPCommand != JSPCommand.POST && edit == false && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && oidGeneralAffairDetail == 0))) {
                add = true;
%>
<input type="hidden" name="<%=jspGeneralAffairDetail.colNames[jspGeneralAffairDetail.JSP_ITEM_MASTER_ID]%>" value="<%=itemMaster.getOID()%>">
<tr height="23">
    <td bgcolor="#E0FCC2" align="center"><%=(nomor)%></td>
    <td bgcolor="#E0FCC2" align="center">
        <table border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td><input type="text" size="10" name="item_code" value="<%=itemMaster.getCode()%>" class="fontarial" style="padding:2px;" onChange="javascript:cmdLoadItem('0')"></td>
                <td>&nbsp;<a href="javascript:cmdAddItemMaster()" height="10" border="0" style="padding:0px">Search</a></td>
            </tr>
        </table>
    </td>
    <td bgcolor="#E0FCC2" align="center"><input type="text" size="13" name="item_barcode" value="<%=itemMaster.getBarcode()%>" class="fontarial" style="padding:2px;" onChange="javascript:cmdLoadItem('0')"></td>
    <td bgcolor="#E0FCC2" align="left" class="fontarial" style="padding:2px;" ><%=itemMaster.getName()%></td>
    <td bgcolor="#E0FCC2" align="left" class="fontarial" style="padding:2px;" ><%=uomx.getUnit()%></td>                                                                                
    <td bgcolor="#E0FCC2" align="center"><input type="text" name="<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_QTY]%>" value="" size="6" class="fontarial" style="text-align:right;padding:2px;" onBlur="javascript:calculateSubTotal()" onkeypress="cmdSaveOnEnter(event)" >*<%=jspGeneralAffairDetail.getErrorMsg(jspGeneralAffairDetail.JSP_QTY)%> </td>
    <td bgcolor="#E0FCC2" align="center"><input type="text" name="<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_PRICE]%>" value="<%=JSPFormater.formatNumber(generalAffairDetail.getPrice(), "###,###.##")%>" size="15" class="readOnly" style="text-align:right;padding:2px;" readonly></td>
    <td bgcolor="#E0FCC2" align="center"><input type="text" name="<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_AMOUNT]%>" value="<%=JSPFormater.formatNumber((generalAffairDetail.getPrice() * generalAffairDetail.getQty()), "###,###.##")%>" readonly size="18" class="readOnly" style="text-align:right;padding:2px;"></td>
</tr> 
<%}%>                                                                            
<tr height="23">
    <td colspan="5" align="center" bgcolor="#cccccc" class="fontarial"><b>Total</b></td>
    <td bgcolor="#cccccc" align="right" style="padding:3px;" class="fontarial"><b><%=JSPFormater.formatNumber(totQty, "###,###.##")%></b></td>
    <td bgcolor="#cccccc">&nbsp;</td>
    <td bgcolor="#cccccc" align="right" style="padding:3px;" class="fontarial"><b><%=JSPFormater.formatNumber(totAmount, "###,###.##")%></b></td>
</tr>
<tr>
    <td colspan="8">&nbsp;</td>
</tr>
<%if (!generalAffair.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !generalAffair.getStatus().equals(I_Project.STATUS_POSTED)) {%>												
<tr align="left" valign="top" > 
    <td colspan="8" class="command"> 
        <table border="0">
            <tr>
                <%if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && (iErrCode != 0 || iErrCode2 != 0)) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                <td width="50">
                    <%
    jspLine.setLocationImg(approot + "/images/ctr_line");
    jspLine.initDefault();
    jspLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidGeneralAffairDetail + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidGeneralAffairDetail + "')";
    String scancel = "javascript:cmdEdit('" + oidGeneralAffairDetail + "')";
    jspLine.setBackCaption("Back to List");
    jspLine.setJSPCommandStyle("buttonlink");

    jspLine.setOnMouseOut("MM_swapImgRestore()");
    jspLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    jspLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

    //jspLine.setOnMouseOut("MM_swapImgRestore()");
    jspLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
    jspLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

    jspLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
    jspLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

    jspLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
    jspLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


    jspLine.setWidthAllJSPCommand("90");
    jspLine.setErrorStyle("warning");
    jspLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    jspLine.setQuestionStyle("warning");
    jspLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    jspLine.setInfoStyle("success");
    jspLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

    if (privDelete) {
        jspLine.setConfirmDelJSPCommand(sconDelCom);
        jspLine.setDeleteJSPCommand(scomDel);
        jspLine.setEditJSPCommand(scancel);
    } else {
        jspLine.setConfirmDelCaption("");
        jspLine.setDeleteCaption("");
        jspLine.setEditCaption("");
    }

    jspLine.setBackCaption("");

    if (privAdd == false && privUpdate == false) {
        jspLine.setSaveCaption("");
    }

    if (add == false && edit == false) {
        jspLine.setSaveCaption("");
        jspLine.setDeleteCaption("");
    }

    if (privAdd == false) {
        jspLine.setAddCaption("");
    }

    if (iJSPCommand == JSPCommand.LOAD) {
        if (oidGeneralAffairDetail == 0) {
            iJSPCommand = JSPCommand.ADD;
        } else {
            iJSPCommand = JSPCommand.EDIT;
        }
    }

                    %>
                    <%= jspLine.drawImageOnly(iJSPCommand, iErrCode2, msgString2)%> 
                </td>
                <%}%>
                <%if (add == false && edit == false && privAdd) {%>
                <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                <%}%>
            </tr>
        </table>
    </td>  
</tr>
<tr>
    <td colspan="8">&nbsp;</td>
</tr>
<%}%>
<%
            if (generalAffairDetails != null && generalAffairDetails.size() > 0 && generalAffair.getOID() != 0) {
                session.putValue("DETAIL_GENERAL_AFFAIR", tmp);
                session.putValue("KONSTAN_GENERAL_AFFAIR", vpar);
%>
<tr > 
    <td colspan="8" height="3" background="<%=approot%>/images/line1.gif" ></td>
</tr>
<tr>
    <td colspan="8">&nbsp;</td>
</tr>
<%}%>
<%if (generalAffairDetails != null && generalAffairDetails.size() > 0 && generalAffair.getOID() != 0) {%>
<%if (generalAffair.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_APPROVED) || generalAffair.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_POSTED)) {%>
<input type="hidden" name="<%=jspGeneralAffair.colNames[jspGeneralAffair.JSP_STATUS]%>" value="<%=generalAffair.getStatus()%>" >
<%} else {%>
<tr>
<td colspan="8">
<table width="500">
<tr>
<tr> 
<td width="80" class="fontarial"><b>Set Status to :</b></td>
<td > 
<select name="<%=jspGeneralAffair.colNames[jspGeneralAffair.JSP_STATUS]%>" class="fontarial">
<option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (generalAffair.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><i><%=I_Project.DOC_STATUS_DRAFT%></i></option>
<%if (privApproved || privViewApproved) {%>
<option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (generalAffair.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><i><%=I_Project.DOC_STATUS_APPROVED%></i></option>                                                                                                        
<%}%>
</select>
</td>                                                                                                
</tr>
</tr>    
</table>
</td>
</tr>
<%}%>
<%} else {%>
<input type="hidden" name="<%=jspGeneralAffair.colNames[jspGeneralAffair.JSP_STATUS]%>" value="<%=generalAffair.getStatus()%>" >
<%}%>
<%if (generalAffairDetails != null && generalAffairDetails.size() > 0 && generalAffair.getOID() != 0) {%>
<tr>
    <td colspan="8">&nbsp;</td>
</tr>
<tr>
    <td colspan="8">
        <table>
            <tr>
                <%if (!generalAffair.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_APPROVED) && !generalAffair.getStatus().equalsIgnoreCase(I_Project.STATUS_POSTED)) {%>												
                <td><div onclick="this.style.visibility='hidden'"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></div></td>
                <td width="10"></td>
                <%}%>
                <td ><a href="javascript:cmdAddNewDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new123','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new123" border="0"></a></td>
                <td width="10"></td>
                <%if (privPrint) {%>
                <td ><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="close211111" border="0"></a></td>
                <%}%>
            </tr>
        </table>
    </td>
</tr>
<%}%>
<tr>
    <td colspan="8">&nbsp;</td>
</tr>
<%if ((generalAffair.getOID() != 0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
<tr align="left" > 
    <td colspan="8" valign="top"> 
        <table width="32%" border="0" cellspacing="1" cellpadding="1">
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
        u = DbUser.fetch(generalAffair.getUserId());
    } catch (Exception e) {
    }
                            %>
                    <%=u.getLoginId()%></i></div>
                </td>
                <td width="33%" class="tablecell1"> 
                    <div align="center"><i><%=JSPFormater.formatDate(generalAffair.getTransactionDate(), "dd MMMM yy")%></i></div>
                </td>
            </tr>
            <tr> 
                <td width="33%" class="tablecell1"><i>Approved 
                by</i></td>
                <td width="34%" class="tablecell1"> 
                    <div align="center"> <i> 
                            <%
    u = new User();
    try {
        u = DbUser.fetch(generalAffair.getApproval1());
    } catch (Exception e) {
    }
                            %>
                    <%=u.getLoginId()%></i></div>
                </td>
                <td width="33%" class="tablecell1"> 
                    <div align="center"> <i> 
                            <%if (generalAffair.getApproval1() != 0) {%>
                            <%=JSPFormater.formatDate(generalAffair.getApproval1Date(), "dd MMMM yy")%> 
                            <%}%>
                    </i></div>
                </td>
            </tr>
            <tr> 
                <td width="33%" class="tablecell1"><i>Posted 
                by</i></td>
                <td width="34%" class="tablecell1"> 
                    <div align="center"> <i> 
                            <%
    u = new User();
    try {
        u = DbUser.fetch(generalAffair.getPostedById());
    } catch (Exception e) {
    }
                            %>
                    <%=u.getLoginId()%></i></div>
                </td>
                <td width="33%" class="tablecell1"> 
                    <div align="center"> <i> 
                            <%if (generalAffair.getPostedDate() != null) {%>
                            <%=JSPFormater.formatDate(generalAffair.getPostedDate(), "dd MMMM yy")%> 
                            <%}%>
                    </i></div>
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
<script language="JavaScript">
    <%if (saved) {%>
    document.frmgeneralaffair.item_code.focus();  
    <%}%>
    <%if (itemMaster.getOID() != 0) {%>
    document.frmgeneralaffair.<%=jspGeneralAffairDetail.colNames[JspGeneralAffairDetail.JSP_QTY]%>.focus();  
    <%}%>
    </script>
</form>                
</td>
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
