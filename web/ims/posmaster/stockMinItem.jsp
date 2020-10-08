
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- created By Ngurah Wirata
<%!
    public String drawList(int iJSPCommand, JspStockMin frmObject, StockMinItem objEntity, Vector objectClass, long stockMinId, long locationId) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("80%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablearialhdr");
        jsplist.setCellStyle("tablearialcell");
        jsplist.setCellStyle1("tablearialcell1");
        jsplist.setHeaderStyle("tablearialhdr");

        jsplist.addHeader("Location", "30%");
        jsplist.addHeader("Minimum Stock", "25%");
        jsplist.addHeader("Delivery Unit", "25%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

        Vector vloc = DbLocation.listAll();
        Vector loc_value = new Vector(1, 1);
        Vector loc_key = new Vector(1, 1);

        if (vloc != null && vloc.size() > 0) {
            for (int i = 0; i < vloc.size(); i++) {
                Location loc = (Location) vloc.get(i);
                //jika kosong dan urutan pertama
                if (locationId == 0 && i == 0) {
                    locationId = loc.getOID();
                }
                loc_key.add(loc.getName().trim());
                loc_value.add("" + loc.getOID());
            }
        }

        for (int i = 0; i < objectClass.size(); i++) {
            StockMinItem stockMin = (StockMinItem) objectClass.get(i);
            rowx = new Vector();
            if (stockMinId == stockMin.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                rowx.add("<div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspStockMin.JSP_LOCATION_ID], null, "" + objEntity.getLocationId(), loc_value, loc_key, "onchange=\"javascript:parserCurrency()\"", "fontarial") + frmObject.getErrorMsg(frmObject.JSP_LOCATION_ID) + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"35\" name=\"" + frmObject.colNames[JspStockMin.JSP_MIN_STOCK] + "\" value=\"" + stockMin.getMinStock() + "\" class=\"formElemen\">" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"35\" name=\"" + frmObject.colNames[JspStockMin.JSP_DELIVERY_UNIT] + "\" value=\"" + stockMin.getDeliveryUnit() + "\" class=\"formElemen\">" + "</div>");
            } else {
                Location loc = new Location();
                try {
                    loc = DbLocation.fetchExc(stockMin.getLocationId());
                } catch (Exception e) {}
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(stockMin.getOID()) + "')\">" + loc.getName() + "</a>");
                rowx.add(stockMin.getMinStock() + "");
                rowx.add(stockMin.getDeliveryUnit() + "");
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspStockMin.JSP_LOCATION_ID], null, "" + objEntity.getLocationId(), loc_value, loc_key, "onchange=\"javascript:parserCurrency()\"", "fontarial") + frmObject.getErrorMsg(frmObject.JSP_LOCATION_ID) + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"35\" name=\"" + frmObject.colNames[JspStockMin.JSP_MIN_STOCK] + "\" value=\"0\" class=\"formElemen\">" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"35\" name=\"" + frmObject.colNames[JspStockMin.JSP_DELIVERY_UNIT] + "\" value=\"0\" class=\"formElemen\">" + "</div>");
        }
        lstData.add(rowx);
        return jsplist.draw(index);
    }


%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "startS");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidStockMin = JSPRequestValue.requestLong(request, "hidden_stock_min_id");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");

            ItemMaster itemMaster = new ItemMaster();
            if (oidItemMaster != 0) {
                try {
                    itemMaster = DbItemMaster.fetchExc(oidItemMaster);
                } catch (Exception e) {}
            }

            long locationId = 0;
            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";


            CmdStockMin ctrlStockMin = new CmdStockMin(request);
            JSPLine ctrLine = new JSPLine();
            Vector listStockMin = new Vector(1, 1);

            /*switch statement */
            ctrlStockMin.setUserId(user.getOID());
            ctrlStockMin.setUserName(user.getFullName());
            iErrCode = ctrlStockMin.action(iJSPCommand, oidStockMin);
            /* end switch*/

            JspStockMin jspStockMin = ctrlStockMin.getForm();
            whereClause = " item_master_id=" + oidItemMaster;
            /*count list All Shift*/
            int vectSize = DbStockMin.getCount(whereClause);

            /*switch list Shift*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlStockMin.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            StockMinItem stockMin = ctrlStockMin.getStockMin();
            msgString = ctrlStockMin.getMessage();

            /* get record to display */
            if (oidItemMaster != 0) {
                whereClause = DbStockMin.colNames[DbStockMin.COL_ITEM_MASTER_ID] + "=" + oidItemMaster;
            }

            listStockMin = DbStockMin.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listStockMin.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listStockMin = DbStockMin.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=titleIS%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        
        function cmdAdd(){
            document.frmitemmaster.hidden_stock_min_id.value="0";
            document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="stockMinItem.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdToRecipe(){
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="recipe.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdAsk(oidStockMin){
            document.frmitemmaster.hidden_stock_min_id.value=oidStockMin;
            document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="stockMinItem.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdConfirmDelete(oidStockMin){
            document.frmitemmaster.hidden_stock_min_id.value=oidStockMin;
            document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="stockMinItem.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdSave(){
            document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="stockMinItem.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdEdit(oidStockMin){
            document.frmitemmaster.hidden_stock_min_id.value=oidStockMin;
            document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="stockMinItem.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdToEditor(){
            
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="itemmaster.jsp";
            document.frmitemmaster.submit();
        }
        function cmdToRecords(){
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="itemlist.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdVendorItem(){
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="vendoritem.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdToPrice(){
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="pricematerial.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdToPriceExc(){
            document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
            document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="pricematerialexchangerate.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdCancel(oidStockMin){
            document.frmitemmaster.hidden_stock_min_id.value=oidStockMin;
            document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="stockMinItem.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdBack(){
            document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
            document.frmitemmaster.action="stockMinItem.jsp";
            document.frmitemmaster.submit();
        }
     
        
        //-------------- script form image -------------------
        
        function cmdDelPict(oidStockMin){
            document.frmimage.hidden_stock_min_id.value=oidStockMin;
            document.frmimage.command.value="<%=JSPCommand.POST%>";
            document.frmimage.action="stockMinItem.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                                        <!-- #EndEditable -->
                                    </td>
                                    <td width="100%" valign="top"> 
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            
                                            <tr> 
                                                <td><!-- #BeginEditable "content" --> 
                                                    <form name="frmitemmaster" method ="post" action="">
                                                        <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                        <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                        <input type="hidden" name="hidden_stock_min_id" value="<%=oidStockMin%>">
                                                        <input type="hidden" name="startS" value="<%=start%>">
                                                        <input type="hidden" name="<%=JspStockMin.colNames[JspStockMin.JSP_CODE]%>" value="<%=itemMaster.getCode() %>">
                                                        <input type="hidden" name="<%=JspStockMin.colNames[JspStockMin.JSP_ITEM_MASTER_ID]%>" value="<%=itemMaster.getOID() %>">
                                                        <input type="hidden" name="<%=JspStockMin.colNames[JspStockMin.JSP_ITEM_NAME]%>" value="<%=itemMaster.getName() %>">
                                                        <input type="hidden" name="<%=JspStockMin.colNames[JspStockMin.JSP_BARCODE]%>" value="<%=itemMaster.getBarcode() %>">
                                                        <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                        
                                                        <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr>
                                                                <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="8"  colspan="3"> 
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="8" valign="middle" colspan="3"> 
                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                <tr valign="bottom"> 
                                                                                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                                            Maintenance </font><font class="tit1">&raquo; 
                                                                                                            </font><font class="tit1"><span class="lvl2">POS</span> 
                                                                                                            &raquo;</font> <span class="lvl2">Item 
                                                                                                    Minimum Stock </span></b></td>
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
                                                                                        <td height="5" valign="middle" colspan="3">
                                                                                        </td>
                                                                                    </tr>
                                                                                    
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="8"  colspan="3"> 
                                                                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                <tr> 
                                                                                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                    <td class="tabin" nowrap> 
                                                                                                        <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecords()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                                    </td>
                                                                                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                    <td class="tabin" nowrap> 
                                                                                                        <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToEditor()" class="tablink">Item Data</a>&nbsp;&nbsp;</div>
                                                                                                    </td>
                                                                                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                    <%if (itemMaster.getOID() != 0) {%>
                                                                                                    <%if(mstViewCogs){%>
                                                                                                    <td class="tabin" nowrap><div align="center">
                                                                                                            <%if(inventory_type == INVENTORY_NON_MULTY_CURRENCY){%>
                                                                                                            &nbsp;&nbsp;<a href="javascript:cmdToPrice()" class="tablink">Price List</a>&nbsp;&nbsp;                                                                                                    
                                                                                                            <%}else{%>
                                                                                                            &nbsp;&nbsp;<a href="javascript:cmdToPriceExc()" class="tablink">Price List</a>&nbsp;&nbsp;     
                                                                                                            <%}%>
                                                                                                    </div></td>
                                                                                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                    <%}%>
                                                                                                    <%}%>                                                                                                    
                                                                                                    <td class="tab" nowrap><div align="center">
                                                                                                            &nbsp;&nbsp;Minimum Stock &nbsp;&nbsp;
                                                                                                    </div></td>
                                                                                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                    <%if (oidItemMaster != 0) {
    if (itemMaster.getForSale() == 1 && itemMaster.getNeedBom() == 1) {
                                                                                            %>
                                                                                            <td class="tabin"> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecipe()" class="tablink">BOM</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%
                }
            }%>
                                                                                                    <%if (oidItemMaster != 0) {%>
                                                                                                    <%if(mstViewCogs){%>
                                                                                                    <td class="tabin" nowrap><div align="center">
                                                                                                            &nbsp;&nbsp;<a href="javascript:cmdVendorItem()" class="tablink">Vendor Item</a>&nbsp;&nbsp;
                                                                                                    </div></td>
                                                                                                    <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                    <%}%>
                                                                                                    <%}%>
                                                                                                    
                                                                                                    <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="15" valign="middle" colspan="3">
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td class="fontarial">&nbsp;<i><B>Minimum Stock :</B></i></td>                                                                                        
                                                                                    </tr>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="15" valign="middle" colspan="3">
                                                                                        </td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td colspan="2">
                                                                                            <table width="400" border="0" cellpadding="0" cellspacing="1">
                                                                                                <tr height="22">
                                                                                                    <td width="70" class="tablecell1">&nbsp;Item Name</td>                                                                                                    
                                                                                                    <td class="fontarial">:&nbsp;<%=itemMaster.getName()%> </td>
                                                                                                </tr>
                                                                                                <tr height="22">
                                                                                                    <td width="70" class="tablecell1">&nbsp;Code</td>                                                                                                    
                                                                                                    <td class="fontarial">:&nbsp;<%=itemMaster.getCode()%> </td>
                                                                                                </tr>
                                                                                                <tr height="22">
                                                                                                    <td width="70" class="tablecell1">&nbsp;Barcode</td>                                                                                                    
                                                                                                    <td class="fontarial">:&nbsp;<%=itemMaster.getBarcode()%> </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>  
                                                                                    <tr>
                                                                                        <td  height="10" width="20%">&nbsp;</td>
                                                                                        
                                                                                    </tr>
                                                                                    
                                                                                    
                                                                                    <%
            try {
                                                                                    %>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                        <%= drawList(iJSPCommand, jspStockMin, stockMin, listStockMin, oidStockMin, locationId)%> </td>
                                                                                    </tr>
                                                                                    <%
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
                                                                                                <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();

            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");

                                                                                                %>
                                                                                        <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                    </tr>
                                                                                    
                                                                                    <%
            if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                    %>
                                                                                    <tr align="left" valign="top">
                                                                                        <td height="5" valign="middle" colspan="3">&nbsp;</td>
                                                                                    </tr>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="22" valign="middle" ><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                        
                                                                                    </tr>
                                                                                    <%}%>
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                            <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                        </tr>
                                                                        <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                        <tr align="left" valign="top" > 
                                                                            <td colspan="3" class="command"> 
                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidStockMin + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidStockMin + "')";
    String scancel = "javascript:cmdEdit('" + oidStockMin + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");

    ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

    //ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
    ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
    ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
    ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


    ctrLine.setWidthAllJSPCommand("90");
    ctrLine.setErrorStyle("warning");
    ctrLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    ctrLine.setQuestionStyle("warning");
    ctrLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
    ctrLine.setInfoStyle("success");
    ctrLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

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
                                                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                        </tr>
                                                                        <%}%>
                                                                </table></td>
                                                            </tr>
                                                        </table>
                                                        
                                                    </form>
                                                    
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
                        </td>
                    </tr>
                    <tr> 
                        <td height="25"> 
                            <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable -->
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
<!-- #EndTemplate --></html>
