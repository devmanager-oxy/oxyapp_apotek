
<%@ page language = "java" %> 
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>   
<%@ page import = "com.project.util.jsp.*" %>  
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %> 
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>  
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>   
<%@ include file = "../main/checksl.jsp" %> 
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
            boolean masterPriv = true;
            boolean masterPrivView = true;
            boolean masterPrivUpdate = true;
%>
<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_COGS") != null) {
                session.removeValue("REPORT_COGS");
            }

            JSPLine jspLine = new JSPLine();
            int start = JSPRequestValue.requestInt(request, "start");
            
            String strdate1 = JSPRequestValue.requestString(request, "start_date");
            String strdate2 = JSPRequestValue.requestString(request, "end_date");
            Date startDate = (strdate1 == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date endDate = (strdate2 == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            
            String golPrice = JSPRequestValue.requestString(request, "src_vendor_id");
            int sortBy = JSPRequestValue.requestInt(request, "src_sort_by");
            String srcGroupCat = JSPRequestValue.requestString(request, "src_group_cat");
            
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            int sortType = JSPRequestValue.requestInt(request, "src_sort_type");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            String[] vendorIds = request.getParameterValues("src_vendor_id");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");            

            Vector vendors = DbVendor.list(0, 0, "", "name");
            Vector locations = userLocations;

//hanya untuk start   
            int vectSize = 0;
            CmdItemGroup ctrlItemGroup = new CmdItemGroup(request);
            Vector resultVens = new Vector();
            String message = "";

            if (iJSPCommand != JSPCommand.NONE) {
                if (vendorIds != null && vendorIds.length > 0) {

                    vectSize = vendorIds.length;
                    for (int i = 0; i < vendorIds.length; i++) {
                        String oids = (String) vendorIds[i];
                        long vid = Long.parseLong(oids);
                        try {
                            Vendor v = DbVendor.fetchExc(vid);
                            resultVens.add(v);
                        } catch (Exception e) {
                        }
                    }

                } else {
                    message = "please select one or some supplier in the list.";
                }
            }

%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Sales System</title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">             
            <%if (!masterPriv || !masterPrivView) {%> 
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptSalesByVendorXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmsales.action="rptsalesbyvendor.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsales.submit();
                }
                
                function cmdListFirst(){
                    document.frmsales.command.value="<%=JSPCommand.FIRST%>";
                    document.frmsales.action="rptsalesbyvendor.jsp";
                    document.frmsales.submit();
                }
                
                function cmdListPrev(){
                    document.frmsales.command.value="<%=JSPCommand.PREV%>";
                    document.frmsales.action="rptsalesbyvendor.jsp";
                    document.frmsales.submit();
                }
                
                function cmdListNext(){
                    document.frmsales.command.value="<%=JSPCommand.NEXT%>";
                    document.frmsales.action="rptsalesbyvendor.jsp";
                    document.frmsales.submit();
                }
                
                function cmdListLast(){
                    document.frmsales.command.value="<%=JSPCommand.LAST%>";
                    document.frmsales.action="rptsalesbyvendor.jsp";
                    document.frmsales.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
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
                                                                                        <td width="100%" valign="top"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td> 
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                            
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                                                                                                                                                                                        
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales 
                                                                                                                                        Report </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">Sales 
                                                                                                                                                by Supplier/Vendor<br>  
                                                                                                                                </span></font></b></td>
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
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                        <tr> 
                                                                                                                                            <td width="11%" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="11%" height="22">Sales 
                                                                                                                                            Between</td>
                                                                                                                                            <td colspan="3" height="22"> 
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr> 
                                                                                                                                                        <td > 
                                                                                                                                                            <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td> &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                                                                                                                        </td>
                                                                                                                                                        <td> 
                                                                                                                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="11%" height="22" valign="top">Supplier/Vendor<br>
                                                                                                                                                <i><font size="1" color="#006600">press 
                                                                                                                                                        CTRL button 
                                                                                                                                                        to have multiples 
                                                                                                                                                selection</font></i> 
                                                                                                                                            </td>
                                                                                                                                            <td colspan="2" height="22"> 
                                                                                                                                                <select multiple name="src_vendor_id" width="500">
                                                                                                                                                    <!--option value="0">ALL</option-->
                                                                      <%if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor v = (Vendor) vendors.get(i);
                                                                                                                                                                                                                                                                                                                                                                                                                                                 %>
                                                                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == vendorId) {%>selected<%}%>><%=v.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="11%" height="22">Sales 
                                                                                                                                            Location/Store</td>
                                                                                                                                            <td colspan="2" height="22"> 
                                                                                                                                                <select name="src_location_id" width="500">
                                                                                                                                                    <%if (locations.size() == totLocationxAll) {%>
                                                                                                                                                    <option value="0">ALL</option>
                                                                                                                                                    <%}%>
                                                                                                                                                    <%if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location loc = (Location) locations.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=loc.getOID()%>" <%if (loc.getOID() == locationId) {%>selected<%}%>><%=loc.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="11%" height="22" nowrap>Item 
                                                                                                                                                Group &amp; 
                                                                                                                                            Category</td>
                                                                                                                                            <td colspan="2" height="22"> 
                                                                                                                                                <%
            Vector tempGroup = DbItemGroup.list(0, 0, "", "name");
                                                                                                                                                %>
                                                                                                                                                <select name="src_group_cat">
                                                                                                                                                    <option value="0,0" <%if (srcGroupCat.equals("0,0")) {%>selected<%}%>>--All-- 
                                                                                                                                                            &amp; --All--</option>
                                                                                                                                                    <%if (tempGroup != null && tempGroup.size() > 0) {
                for (int i = 0; i < tempGroup.size(); i++) {
                    ItemGroup ig = (ItemGroup) tempGroup.get(i);
                    Vector cats = DbItemCategory.list(0, 0, "", "name");
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ig.getOID()%>,0" <%if (srcGroupCat.equals(ig.getOID() + ",0")) {%>selected<%}%>><%=ig.getName()%> 
                                                                                                                                                            &amp; ---All---</option>
                                                                                                                                                    <%
                                                                                                                                                        if (cats != null && cats.size() > 0) {
                                                                                                                                                            for (int x = 0; x < cats.size(); x++) {
                                                                                                                                                                ItemCategory ic = (ItemCategory) cats.get(x);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=ig.getOID()%>,<%=ic.getOID()%>" <%if (srcGroupCat.equals(ig.getOID() + "," + ic.getOID())) {%>selected<%}%>><%=ig.getName()%> 
                                                                                                                                                            &amp; <%=ic.getName()%></option>
                                                                                                                                                    <%
                        }
                    }
                }
            }
                                                                                                                                                    %>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="11%" height="22">Item 
                                                                                                                                                Ordered By 
                                                                                                                                            </td>
                                                                                                                                            <td width="28%" height="22"> 
                                                                                                                                                <select name="src_sort_by">
                                                                                                                                                    <option value="0" <%if (sortBy == 0) {%>selected<%}%>>Item 
                                                                                                                                                            Code</option>
                                                                                                                                                    <option value="1" <%if (sortBy == 1) {%>selected<%}%>>Item 
                                                                                                                                                            Name</option>
                                                                                                                                                    <option value="2" <%if (sortBy == 2) {%>selected<%}%>>Sales 
                                                                                                                                                            Qty</option>
                                                                                                                                                    <option value="3" <%if (sortBy == 3) {%>selected<%}%>>Sales 
                                                                                                                                                            Amount</option>
                                                                                                                                                </select>
                                                                                                                                                <select name="src_sort_type">
                                                                                                                                                    <option value="0" <%if (sortType == 0) {%>selected<%}%>>Asc</option>
                                                                                                                                                    <option value="1" <%if (sortType == 1) {%>selected<%}%>>Desc</option>
                                                                                                                                                </select>
                                                                                                                                            </td>
                                                                                                                                            <td width="61%" height="22">&nbsp; 
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td width="11%" height="33"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            <td width="28%" height="33"><font color="#FF0000"><%=message%></font></td>
                                                                                                                                            <td width="61%" height="33">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td colspan="7"><i></i></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
            Vector report = new Vector();
            if (iJSPCommand != JSPCommand.NONE) {

                if (resultVens != null && resultVens.size() > 0) {
                    for (int x = 0; x < resultVens.size(); x++) {
                        Vendor vend = (Vendor) resultVens.get(x);
                                                                                                                                        %>
                                                                                                                                        <tr valign="middle" > 
                                                                                                                                            <td colspan="7" height="10" nowrap> 
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="20" valign="middle" > 
                                                                                                                                            <td bgcolor="#BFD8AF" colspan="7" nowrap> 
                                                                                                                                                <div align="left"><b>&nbsp;<%=vend.getName().toUpperCase()%></b>&nbsp;-&nbsp;<font size="1"><%=vend.getAddress()%></font></div>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablehdr" width="6%" nowrap><font size="1">SKU</font></td>
                                                                                                                                            <td class="tablehdr" width="16%" nowrap ><font size="1">Item</font></td>
                                                                                                                                            <td class="tablehdr" width="11%" nowrap><font size="1">Sales 
                                                                                                                                            Qty</font></td>
                                                                                                                                            <td class="tablehdr" width="11%" nowrap><font size="1">Sales 
                                                                                                                                            Cogs</font></td>
                                                                                                                                            <td class="tablehdr" width="11%" nowrap><font size="1">Sales 
                                                                                                                                            Amount</font></td>
                                                                                                                                            <td class="tablehdr" width="8%" nowrap><font size="1">Profit</font></td>
                                                                                                                                            <td class="tablehdr" width="8%" nowrap><font size="1">Margin 
                                                                                                                                            %</font></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                                    Vector result = SessCogsBySection.getSalesBySupplierReport(startDate, endDate, srcGroupCat, vend.getOID(), locationId, sortBy, sortType);

                                                                                                                                                    Vector reportDetail = new Vector();
                                                                                                                                                    reportDetail.add(vend);
                                                                                                                                                    reportDetail.add(result);
                                                                                                                                                    report.add(reportDetail);

                                                                                                                                                    if (result != null && result.size() > 0) {

                                                                                                                                                        double subQty = 0;
                                                                                                                                                        double subCogs = 0;
                                                                                                                                                        double subAmount = 0;
                                                                                                                                                        double subProfit = 0;
                                                                                                                                                        double subMargin = 0;

                                                                                                                                                        double grandQty = 0;
                                                                                                                                                        double grandCogs = 0;
                                                                                                                                                        double grandAmount = 0;
                                                                                                                                                        double grandProfit = 0;
                                                                                                                                                        double grandMargin = 0;

                                                                                                                                                        for (int i = 0; i < result.size(); i++) {
                                                                                                                                                            Vector v = (Vector) result.get(i);
                                                                                                                                                            String sku = (String) v.get(1);
                                                                                                                                                            String itemName = (String) v.get(3);
                                                                                                                                                            double cogs = Double.parseDouble((String) v.get(4));
                                                                                                                                                            double qty = Double.parseDouble((String) v.get(5));
                                                                                                                                                            double sales = Double.parseDouble((String) v.get(6));
                                                                                                                                                            double hpp = Double.parseDouble((String) v.get(8));
                                                                                                                                                            double margin = (hpp > 0) ? ((sales - hpp) / hpp) * 100 : 0;

                                                                                                                                                            subQty = subQty + qty;
                                                                                                                                                            subCogs = subCogs + hpp;
                                                                                                                                                            subAmount = subAmount + sales;
                                                                                                                                                            subProfit = subProfit + (sales - hpp);
                                                                                                                                                            subMargin = subMargin + margin;

                                                                                                                                                            grandQty = grandQty + qty;
                                                                                                                                                            grandCogs = grandCogs + hpp;
                                                                                                                                                            grandAmount = grandAmount + sales;
                                                                                                                                                            grandProfit = grandProfit + (sales - hpp);
                                                                                                                                                            grandMargin = grandMargin + margin;

                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablecell" align="center" width="6%" nowrap><font size="1"><%=sku%></font></td>
                                                                                                                                            <td class="tablecell" align="left" width="16%" nowrap><font size="1"><%=itemName%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="11%" nowrap><font size="1"><%=JSPFormater.formatNumber(qty, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="11%" nowrap><font size="1"><%=JSPFormater.formatNumber(hpp, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="11%" nowrap><font size="1"><%=JSPFormater.formatNumber(sales, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber(sales - hpp, "#,###.##")%></font></td>
                                                                                                                                            <td class="tablecell" align="right" width="8%" nowrap><font size="1"><%=JSPFormater.formatNumber(margin, "#,###.##")%></font></td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        <tr height="20">                                                                                                                                             
                                                                                                                                            <td class="tablecell1" align="center" colspan="2" nowrap><b>Total</b></td>
                                                                                                                                            <td class="tablecell1" align="right" nowrap><font size="1"><b><%=JSPFormater.formatNumber(subQty, "#,###.##")%></b></font></td>
                                                                                                                                            <td class="tablecell1" align="right" nowrap><font size="1"><b><%=JSPFormater.formatNumber(subCogs, "#,###.##")%></b></font></td>
                                                                                                                                            <td class="tablecell1" align="right" nowrap><font size="1"><b><%=JSPFormater.formatNumber(subAmount, "#,###.##")%></b></font></td>
                                                                                                                                            <td class="tablecell1" align="right" nowrap><font size="1"><b><%=JSPFormater.formatNumber(subProfit, "#,###.##")%></b></font></td>
                                                                                                                                            <td class="tablecell1" align="right"  nowrap><font size="1"><b><%=JSPFormater.formatNumber(subMargin, "#,###.##")%></b></font></td>
                                                                                                                                        </tr>
                                                                                                                                        <%} else {%>
                                                                                                                                        <tr valign="middle" > 
                                                                                                                                            <td colspan="7" height="5" nowrap><font color="#FF0000">No 
                                                                                                                                            sales</font></td>
                                                                                                                                        </tr>
                                                                                                                                        <%}
                                                                                                                                                }
                                                                                                                                            }
                                                                                                                                        %>
                                                                <%}%>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top">  
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp; 
                                                                                                                                    
                                                                                                                                </td>     
                                                                                                                            </tr>
                                                                                                                            <%
            if (iJSPCommand != JSPCommand.NONE && resultVens != null && resultVens.size() > 0) {

                                                                                                                            %> 
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                </td>     
                                                                                                                            </tr>     
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <%
            session.putValue("REPORT_VENDOR", report);
            Vector reportParam = new Vector();
            reportParam.add(startDate);
            reportParam.add(endDate);
            reportParam.add(user.getLoginId());
            reportParam.add("" + locationId);
            reportParam.add("" + srcGroupCat);
            session.putValue("REPORT_PARAM", reportParam);														
                                                        %>
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
            <%@ include file="../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

