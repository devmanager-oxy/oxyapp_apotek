
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.postransaction.order.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell1");
        jsplist.setCellStyle1("tablecell");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Date", "8%");
        jsplist.addHeader("Order Location", "15%");
        jsplist.addHeader("Barcode", "10%");
        jsplist.addHeader("Item name", "35%");
        jsplist.addHeader("Qty Standar", "7%");
        jsplist.addHeader("Qty Stock", "7%");
        jsplist.addHeader("Delivery Unit", "7%");
        jsplist.addHeader("Qty order", "7%");
        jsplist.addHeader("Status", "7%");
        jsplist.addHeader("Doc Number", "7%");

        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();

        jsplist.reset();
        int index = -1;
        Vector temp = new Vector();

        for (int i = 0; i < objectClass.size(); i++) {
            Order odr = (Order) objectClass.get(i);
            Order order = new Order();
            try {
                order = DbOrder.fetchExc(odr.getOID());
            } catch (Exception ex) {

            }
            Vector rowx = new Vector();
            Location loc = new Location();
            ItemMaster im = new ItemMaster();
            RptOrder detail = new RptOrder();
            try {
                loc = DbLocation.fetchExc(order.getLocationId());
            } catch (Exception ex) {}

            try {
                im = DbItemMaster.fetchExc(order.getItemMasterId());
            } catch (Exception ex) {}

            rowx.add("<div align=\"center\">" + "" + (i + 1) + "</div>");
            rowx.add("" + JSPFormater.formatDate(order.getDate(), "dd MMM yyyy HH:mm:ss"));
            detail.setDate(order.getDate());
            rowx.add("" + loc.getName());
            detail.setLocation(loc.getName());            
            detail.setNumber(order.getNumber());
            rowx.add("" + im.getBarcode());
            detail.setBarcode(im.getBarcode());
            rowx.add("" + im.getName());
            detail.setName(im.getName());
            rowx.add("" + order.getQtyStandar());
            rowx.add("" + order.getQtyStock());
            rowx.add("" + im.getDeliveryUnit());
            rowx.add("" + order.getQtyOrder());
            rowx.add("" + order.getStatus());
            if (order.getTransferId() != 0) {
                Transfer tr = new Transfer();
                try {
                    tr = DbTransfer.fetchExc(order.getTransferId());
                    rowx.add("" + tr.getNumber());
                } catch (Exception ex) {

                }
            } else if (order.getPurchaseId() != 0) {
                Purchase pr = new Purchase();
                try {
                    pr = DbPurchase.fetchExc(order.getPurchaseId());
                    rowx.add("" + pr.getNumber());
                } catch (Exception ex) {}
            } else {
                rowx.add("-");
            }

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(order.getOID()));


        }

        return jsplist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }

            if (session.getValue("DETAIL") != null) {
                session.removeValue("DETAIL");
            }


//--------------- search ------------------------------------------------------
            long srcGroupId = JSPRequestValue.requestLong(request, "src_group");
            long srcCategoryId = JSPRequestValue.requestLong(request, "src_category");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcBarCode = JSPRequestValue.requestString(request, "src_barcode");
            String srcName = JSPRequestValue.requestString(request, "src_name");

            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
            srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            Vector locations = userLocations;
            int recordToGet = 0;
            String whereClause = "type<>" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS + " and type<>" + I_Ccs.TYPE_CATEGORY_CIVIL_WORK;
            String orderClause = "ao.date";

            if (srcGroupId != 0) {
                whereClause = "im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + "=" + srcGroupId;
            }
            if (srcCategoryId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + "=" + srcCategoryId;
            }
            if (srcCode != null && srcCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%'";
            }
            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName + "%'";
            }
            if (srcBarCode != null && srcBarCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "(" + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + srcBarCode + "%' or " + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcBarCode + "%' or " + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcBarCode + "%')";
            }
            if (srcVendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " vi.vendor_id=" + srcVendorId;
            }

            if (srcLocationId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " ao.location_id=" + srcLocationId;
            }

            if (srcStatus != null && srcStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    if (srcStatus.equalsIgnoreCase("APPROVED")) {
                        whereClause = whereClause + " and (ao." + DbOrder.colNames[DbOrder.COL_STATUS] + "='" + srcStatus + "' and (ao.transfer_id!=0 or ao.purchase_id!=0))";
                    } else if (srcStatus.equalsIgnoreCase("DRAFT")) {
                        whereClause = whereClause + " and ao." + DbOrder.colNames[DbOrder.COL_STATUS] + "='" + srcStatus + "'";
                    }

                } else {
                    if (srcStatus.equalsIgnoreCase("APPROVED")) {
                        whereClause = " (ao." + DbOrder.colNames[DbOrder.COL_STATUS] + "='" + srcStatus + "' and (ao.transfer_id!=0 or ao.purchase_id!=0))";
                    } else if (srcStatus.equalsIgnoreCase("DRAFT")) {
                        whereClause = " ao." + DbOrder.colNames[DbOrder.COL_STATUS] + "='" + srcStatus + "'";
                    }


                }
            } else {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (ao.status='DRAFT' or ao.transfer_id !=0 or ao.purchase_id !=0)";
                } else {
                    whereClause = " (ao.status='DRAFT' or ao.transfer_id !=0 or ao.purchase_id !=0)";
                }

            }

            if (whereClause.length() > 0) {
                whereClause = whereClause + " and (to_days(ao." + DbOrder.colNames[DbOrder.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                        " and to_days(ao." + DbOrder.colNames[DbOrder.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
            } else {
                whereClause = "(ao.to_days(ao." + DbOrder.colNames[DbOrder.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                        " and to_days(ao." + DbOrder.colNames[DbOrder.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
            }

            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            Vector listOrder = new Vector(1, 1);
            
            JspItemMaster jspItemMaster = ctrlItemMaster.getForm();
            int vectSize = 0;
            ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
            if (oidItemMaster == 0) {
                oidItemMaster = itemMaster.getOID();
            }

            RptOrder rptodr = new RptOrder();
            long oidTransfer = 0;
            boolean transferok = false;

            session.putValue("DETAIL", whereClause);
            session.putValue("KONSTAN", ""+srcVendorId);

            if (iJSPCommand == JSPCommand.SEARCH) {
                if (srcVendorId != 0) {
                    listOrder = DbOrder.listByVendor(start, recordToGet, whereClause, orderClause);
                } else {
                    listOrder = DbOrder.list(start, recordToGet, whereClause, orderClause);
                }
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        
        <script language="JavaScript">
            
            
            function cmdPrintXLS(){
                window.open("<%=printroot%>.report.RptPrintOrderXLS?idx=<%=System.currentTimeMillis()%>");
                }    
                
                function cmdSearch(){                    
                    document.frmorder.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                    document.frmorder.action="reportorder.jsp";
                    document.frmorder.submit();
                }
                
                function cmdCheckOrder(){
                    if(confirm('Pastikan parameter sudah benar')){
                        //document.frmitemmaster.hidden_item_master_id.value="0";
                        document.frmorder.command.value="<%=JSPCommand.GET%>";
                        document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                        document.frmorder.action="reportorder.jsp";
                        document.frmorder.submit();
                    }else{
                    
                }
                
                
                
            }
            
            
            function cmdAsk(oidItemMaster){
                document.frmorder.hidden_item_master_id.value=oidItemMaster;
                document.frmorder.command.value="<%=JSPCommand.ASK%>";
                document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                document.frmorder.action="itemlist.jsp";
                document.frmorder.submit();
            }
            
            
            function cmdSave(){
                document.frmorder.command.value="<%=JSPCommand.SAVE%>";
                document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                document.frmorder.action="reportorder.jsp";
                document.frmorder.submit();
            }
            
            function cmdTransfer(oidTransfer){
                
                document.frmorder.hidden_transfer_id.value=oidTransfer;
                document.frmorder.command.value="<%=JSPCommand.EDIT%>";
                document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                document.frmorder.action="transferitem.jsp";
                document.frmorder.submit();
            }
            
            function cmdCancel(oidItemMaster){
                document.frmorder.hidden_item_master_id.value=oidItemMaster;
                document.frmorder.command.value="<%=JSPCommand.EDIT%>";
                document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                document.frmorder.action="itemlist.jsp";
                document.frmorder.submit();
            }
            
            function cmdBack(){
                document.frmorder.command.value="<%=JSPCommand.BACK%>";
                document.frmorder.action="itemmaster.jsp";
                document.frmorder.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmorder" method ="post" action="">
                                                        <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                        <input type="hidden" name="start" value="<%=start%>">
                                                        <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                        <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                        <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                        <input type="hidden" name="hidden_transfer_id" value="<%=oidTransfer%>">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr> 
                                                                <td class="container" valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr> 
                                                                            <td> 
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                    <tr valign="bottom"> 
                                                                                        <td width="60%" height="23"><b><font color="#990000" class="lvl1">Report
                                                                                                </font><font class="tit1">&raquo; 
                                                                                                </font><font class="tit1"><span class="lvl2">Order
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
                                                                        
                                                                        
                                                                        <tr> 
                                                                            <td class="page"> 
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="8"  colspan="3"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                            <tr align="left" valign="top"> 
                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="5%">&nbsp;</td>
                                                                                                        <td width="11%">&nbsp;</td>
                                                                                                        <td width="6%">&nbsp;</td>
                                                                                                        <td width="14%">&nbsp;</td>
                                                                                                        <td width="6%">&nbsp;</td>
                                                                                                        <td width="15%">&nbsp;</td>
                                                                                                        <td width="42%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="7" nowrap><b><u>Search 
                                                                                                        Option</u></b></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="5%">&nbsp;</td>
                                                                                                        <td width="11%">&nbsp;</td>
                                                                                                        <td width="6%">&nbsp;</td>
                                                                                                        <td width="14%">&nbsp;</td>
                                                                                                        <td width="6%">&nbsp;</td>
                                                                                                        <td width="15%">&nbsp;</td>
                                                                                                        <td width="42%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                    <td width="5%">Group</td>
                                                                                                    <td width="11%"> 
                                                                                                        <%
            Vector groupsx = DbItemGroup.list(0, 0, "", "name");
                                                                                                        %>
                                                                                                        <select name="src_group">
                                                                                                            <option value="0" <%if (srcGroupId == 0) {%>selected<%}%>>All 
                                                                                                                    ..</option>
                                                                                                            <%if (groupsx != null && groupsx.size() > 0) {
                for (int i = 0; i < groupsx.size(); i++) {
                    ItemGroup ig = (ItemGroup) groupsx.get(i);
                                                                                                            %>
                                                                                                            <option value="<%=ig.getOID()%>" <%if (srcGroupId == ig.getOID()) {%>selected<%}%>><%=ig.getName()%></option>
                                                                                                            <%}
            }%>
                                                                                                        </select>
                                                                                                    </td>
                                                                                                    <td width="6%">SKU</td>
                                                                                                    <td width="14%"> 
                                                                                                        <input type="text" name="src_code" size="15" value="<%=srcCode%>" onchange="javascript:cmdSearch()">
                                                                                                    </td>
                                                                                                    <td width="6%">From Location</td>
                                                                                                    <td width="15%">
                                                                                                        <select name="src_location_id">
                                                                                                            <%
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);

                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                        </select>
                                                                                                    </td>  
                                                                                                </td>
                                                                                                <td width="42%">&nbsp;</td>
                                                                                            </tr>
                                                                                            <tr> 
                                                                                            <td width="5%">Category</td>
                                                                                            <td width="11%"> 
                                                                                                <%
            Vector categoryx = DbItemCategory.list(0, 0, "", "name");
                                                                                                %>
                                                                                                <select name="src_category">
                                                                                                    <option value="0" <%if (srcCategoryId == 0) {%>selected<%}%>>All 
                                                                                                            ..</option>
                                                                                                    <%if (categoryx != null && categoryx.size() > 0) {
                for (int i = 0; i < categoryx.size(); i++) {
                    ItemCategory ic = (ItemCategory) categoryx.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=ic.getOID()%>" <%if (srcCategoryId == ic.getOID()) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                            </td>
                                                                                            <td width="6%">Name</td>
                                                                                            <td width="14%"> 
                                                                                                <input type="text" name="src_name" size="15" value="<%=srcName%>" onchange="javascript:cmdSearch()">
                                                                                            </td>
                                                                                            <td width="10%">Date</td>
                                                                                            <td width="90%"> 
                                                                                                <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmorder.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                                                                <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmorder.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                
                                                                                            </td>
                                                                                            
                                                                                            
                                                                                        </td>  
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td width="5%">Vendor</td>
                                                                                        <td width="11%">
                                                                                            <select name="src_vendor_id">
                                                                                                <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>>- 
                                                                                                        All -</option>
                                                                                                <%

            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor d = (Vendor) vendors.get(i);

                                                                                                %>
                                                                                                <option value="<%=d.getOID()%>" <%if (srcVendorId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                <%}
            }%>
                                                                                            </select>
                                                                                            
                                                                                            
                                                                                            
                                                                                            
                                                                                        </td>
                                                                                        <td width="6%">Barcode</td>
                                                                                        <td width="15%">
                                                                                            <input type="text" name="src_barcode" size="15" value="<%=srcBarCode%>" onchange="javascript:cmdSearch()">
                                                                                        </td>
                                                                                        
                                                                                        <td width="10%">Document Status</td>
                                                                                        <td width="90%"> 
                                                                                            <select name="src_status">
                                                                                                <option value="" >- All -</option>
                                                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                
                                                                                            </select>
                                                                                        </td>
                                                                                        
                                                                                        
                                                                                        
                                                                                        
                                                                                        
                                                                                        
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="14%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td> 
                                                                                    </tr>
                                                                                    
                                                                                    <tr> 
                                                                                        <td colspan="7" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                                                    </tr>
                                                                                    <tr> 
                                                                                        <td colspan="7">&nbsp;</td>
                                                                                    </tr>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <%
            try {
                if (listOrder.size() > 0 && iJSPCommand == JSPCommand.SEARCH) {
                                                                        %>
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                            <%= drawList(listOrder)%> </td>
                                                                        </tr>
                                                                        <%  } else if (iJSPCommand == JSPCommand.SEARCH) {%>
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                            <h3>BELUM ADA ORDER, STOCK MASIH TERCUKUPI</h3>
                                                                        </tr>                
                                                                        <%}
            } catch (Exception exc) {
            }%>
                                                                        
                                                                        <%
            try {
                if (listOrder.size() > 0 && iJSPCommand == JSPCommand.GET) {
                                                                        %>
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                            <%= drawList(listOrder)%> </td>
                                                                        </tr>
                                                                        <%  } else if (iJSPCommand == JSPCommand.GET) {%>
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                            <h3>BELUM ADA ORDER, STOCK MASIH TERCUKUPI</h3>
                                                                        </tr>                
                                                                        <%}
            } catch (Exception exc) {
            }%>     
                                                                    
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="8" align="left" colspan="3" class="command"> 
                                                                                <span class="command"> 
                                                                                    <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevJSPCommand;
                }
            }
                                                                                    %>
                                                                                    <% jspLine.setLocationImg(approot + "/images/ctr_line");
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
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                        </tr>
                                                                        
                                                                        
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <%if (iJSPCommand == JSPCommand.SAVE && transferok) {%>
                                                            <script language="JavaScript">
                                                                cmdTransfer('<%=oidTransfer%>')
                                                            </script>
                                                            <%} else if (iJSPCommand == JSPCommand.SAVE) {%>
                                                            
                                                            <tr><td bgcolor="yellow">Doc Transfer gagal dibuat</td></tr>
                                                            <%}%>
                                                            
                                                            <tr><td></td></tr>
                                                            
                                                            <tr align="left" valign="top"> 
                                                                <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr> 
                                                    <td>&nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                
                                <span class="level2"><br>
                                </span><!-- #EndEditable -->
                            </td>
                        </tr>
                        
                        <tr> 
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        
        <tr> 
            <td height="25"> 
                <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
                <!-- #EndEditable -->
            </td>
        </tr>
        
        
        
        
    </body>
<!-- #EndTemplate --></html>
