
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long itemMasterId) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("Code", "9%");
        jsplist.addHeader("Barcode", "11%");
        jsplist.addHeader("Name", "22%");
        jsplist.addHeader("Group", "20%");
        jsplist.addHeader("Category", "20%");
        jsplist.addHeader("Unit Stock", "8%");
        jsplist.addHeader("Selling Price", "10%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        jsplist.setLinkPrefix("javascript:cmdEdit('");
        jsplist.setLinkSufix("')");
        jsplist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            ItemMaster itemMaster = (ItemMaster) objectClass.get(i);
            Vector rowx = new Vector();
            if (itemMasterId == itemMaster.getOID()) {
                index = i;
            }

            rowx.add("<div align=\"center\">" + itemMaster.getCode() + "</div>");

            rowx.add("<div align=\"center\">" + itemMaster.getBarcode() + "</div>");

            rowx.add(itemMaster.getName());

            ItemGroup ig = new ItemGroup();
            try {
                ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + ig.getName() + "</div>");

            ItemCategory ic = new ItemCategory();
            try {
                ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + ic.getName() + "</div>");

            Uom uo = new Uom();
            try {
                uo = DbUom.fetchExc(itemMaster.getUomStockId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + uo.getUnit() + "</div>");

            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(itemMaster.getSellingPrice(), "#,###.##") + "</div>");

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(itemMaster.getOID()));
        }

        return jsplist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");

            if (iJSPCommand == JSPCommand.NONE) {
                if (oidItemMaster == 0) {
                    iJSPCommand = JSPCommand.ADD;
                } else {
                    iJSPCommand = JSPCommand.EDIT;
                }
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            Vector listItemMaster = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlItemMaster.action(iJSPCommand, oidItemMaster);
            /* end switch*/
            JspItemMaster jspItemMaster = ctrlItemMaster.getForm();

            /*count list All ItemMaster*/
            int vectSize = DbItemMaster.getCount(whereClause);

            ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
            msgString = ctrlItemMaster.getMessage();
            
            if(iJSPCommand == JSPCommand.SAVE && iErrCode == 0){
                msgString = "Data is saved";
            }

            if (oidItemMaster == 0) {
                oidItemMaster = itemMaster.getOID();
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listItemMaster.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);
            }

            Vector categories = DbItemCategory.list(0, 0, "group_type=" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS + " or group_type=" + I_Ccs.TYPE_CATEGORY_CIVIL_WORK, DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID] + "," + DbItemCategory.colNames[DbItemCategory.COL_NAME]);

            Vector units = DbUom.list(0, 0, "", "");

            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setForSale(1);
                itemMaster.setForBuy(1);
                itemMaster.setIsActive(1);
                itemMaster.setRecipeItem(1);
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
            function cmdToPrice(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="pricematerialproduct.jsp";
                document.frmitemmaster.submit();
            }
            
            function removeChar(number){
                
                var ix;
                var result = "";
                for(ix=0; ix<number.length; ix++){
                    var xx = number.charAt(ix);
                    //alert(xx);
                    if(!isNaN(xx)){
                        result = result + xx;
                    }
                    else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }
                
                return result;
            }
            
            function checkNumber(){
                var st = document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_SELLING_PRICE]%>.value;		
                
                result = removeChar(st);
                
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                
                document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_SELLING_PRICE]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function checkNumber1(){
                var st = document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_COGS]%>.value;		
                
                result = removeChar(st);
                
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                
                document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_COGS]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
            }
            
            function cmdToVendor(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendorproduct.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToProduct(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToRecords(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="productlist.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToRecipe(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="recipe.jsp";
                document.frmitemmaster.submit();
            }
            
            
            function cmdAddVendor(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdEditVendor(oid){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.hidden_vendor_item_id.value=oid;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            
            function cmdAdd(){
                document.frmitemmaster.hidden_item_master_id.value="0";
                document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdAsk(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdConfirmDelete(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            function cmdSave(){
                document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdEdit(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdCancel(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdBack(){
                document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListFirst(){
                document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListPrev(){
                document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListNext(){
                document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListLast(){
                document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmitemmaster.action="productmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            //-------------- script control line -------------------
            //-->
        </script>
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="hidden_vendor_item_id" value="">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                        <tr valign="bottom"> 
                                                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                                    Maintenance </font><font class="tit1">&raquo; 
                                                                                                    </font><font class="tit1"><span class="lvl2">Product 
                                                                                            List </span></font></b></td>
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
                                                                                <td height="5"  colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecords()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;Item 
                                                                                                Data</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%if (itemMaster.getOID() != 0) {%>
                                                                                            <td class="tabin" nowrap><div align="center">
                                                                                                &nbsp;&nbsp;<a href="javascript:cmdToPrice()" class="tablink">Price List</a>&nbsp;&nbsp;
                                                                                            </div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}%>
                                                                                            <%if (itemMaster.getOID() != 0) {
                if (itemMaster.getForBuy() == 1) {
                                                                                            %>
                                                                                            <td class="tabin"> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToVendor()" class="tablink">Vendor</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}
    if (itemMaster.getForSale() == 1 && itemMaster.getNeedRecipe() == 1) {
                                                                                            %>
                                                                                            <td class="tabin"> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecipe()" class="tablink">BOM</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <%
                }
            }%>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="5" valign="middle" colspan="5"></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="21" valign="middle" width="16%">*)= 
                                                                                            required</td>
                                                                                            <td height="21" valign="middle" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%" nowrap>&nbsp;&nbsp;<u><b>Product 
                                                                                        Data</b></u> </td>
                                                                                        <td height="21" width="16%">&nbsp;</td>
                                                                                        <td height="21" width="10%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="62%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Category</td>
                                                                                        <td height="21" colspan="4" nowrap> 
                                                                                            <% Vector itemcategoryid_value = new Vector(1, 1);
            Vector itemcategoryid_key = new Vector(1, 1);
            String sel_itemcategoryid = "" + itemMaster.getItemCategoryId();
            if (categories != null && categories.size() > 0) {
                for (int i = 0; i < categories.size(); i++) {
                    ItemCategory ic = (ItemCategory) categories.get(i);

                    ItemGroup ig = new ItemGroup();
                    try {
                        ig = DbItemGroup.fetchExc(ic.getItemGroupId());
                    } catch (Exception e) {
                    }

                    itemcategoryid_key.add("" + ic.getOID());
                    itemcategoryid_value.add("" + ig.getName() + " - " + ic.getName());
                }
            }
                                                                                            %>
                                                                                        <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_ITEM_CATEGORY_ID], null, sel_itemcategoryid, itemcategoryid_key, itemcategoryid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_ITEM_CATEGORY_ID) %> </td>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Code</td>
                                                                                        <td height="21" width="20%" nowrap> 
                                                                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_CODE] %>"  value="<%= itemMaster.getCode() %>" class="formElemen" size="10" maxlength="5">
                                                                                        * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_CODE) %> </td>
                                                                                        <td height="21" width="10%"> 
                                                                                            
                                                                                            <div align="right">Item Name</div>
                                                                                        </td>
                                                                                        <td height="21" colspan="2" width="62%">
                                                                                        <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NAME] %>"  value="<%= itemMaster.getName() %>" class="formElemen" size="40">
                                                                                        *<%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_NAME) %>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Barcode</td>
                                                                                        <td height="21" width="16%"> 
                                                                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE] %>"  value="<%= itemMaster.getBarcode() %>" class="formElemen" size="20">
                                                                                        </td>
                                                                                        <td height="21" width="10%" nowrap>                                                                                             
                                                                                            <div align="right">C.O.G.S&nbsp;&nbsp;</div>
                                                                                        </td>                                                                                        
                                                                                        <td height="21" colspan="2" width="62%">
                                                                                        <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") %>" class="formElemen" size="20" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%"></td>                                                                                        
                                                                                        <td height="21" width="10%">                                                                                             
                                                                                            <div align="right">.&nbsp;&nbsp;</div>
                                                                                        </td>                                                                                        
                                                                                        <td height="21" colspan="2" width="62%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;</td>
                                                                                        <td height="21" width="16%">&nbsp;</td>
                                                                                        <td height="21" width="10%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="62%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" colspan="2" nowrap>&nbsp;&nbsp;<b><u>Sales and Purchase Parameter</u><u></u><i><u><br>
                                                                                                        <br>
                                                                                        </u></i></b></td>
                                                                                        <td height="21" width="10%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="62%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" colspan="5"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td width="12%">&nbsp;&nbsp;For Sale </td>
                                                                                                    <td width="9%"> 
                                                                                                        <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_SALE] %>"  value="1" <%if (itemMaster.getForSale() == 1) {%>checked<%}%>>
                                                                                                    </td>
                                                                                                    <td colspan="4"> 
                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                            <tr> 
                                                                                                                <td width="1%">
                                                                                                                    <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="1" <%if (itemMaster.getNeedRecipe() == 1) {%>checked<%}%>>
                                                                                                                </td>
                                                                                                                <td width="13%" nowrap>Non Stockable</td>
                                                                                                                <td width="2%"> 
                                                                                                                    <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="0" <%if (itemMaster.getNeedRecipe() == 0) {%>checked<%}%>>
                                                                                                                </td>
                                                                                                                <td width="10%">Stockable</td>
                                                                                                                <td>&nbsp;</td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td colspan="6">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td width="12%">&nbsp;&nbsp;Is Available</td>
                                                                                                    <td width="9%"> 
                                                                                                        <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_ACTIVE] %>"  value="1" <%if (itemMaster.getIsActive() == 1) {%>checked<%}%> class="formElemen">
                                                                                                    </td>
                                                                                                    <td colspan="6">
                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                            <tr>
                                                                                                                <td width="1%">
                                                                                                                    <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.APPLY_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE) {%>checked<%}%>>
                                                                                                                </td>
                                                                                                                <td width="13%">Apply Stock Code</td>
                                                                                                                <td width="2%"> 
                                                                                                                    <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.OPTIONAL_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE) {%>checked<%}%>>
                                                                                                                </td>
                                                                                                                <td width="15%">Optional Stock Code</td>
                                                                                                                <td width="2%"> 
                                                                                                                    <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.NON_APPLY_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.NON_APPLY_STOCK_CODE) {%>checked<%}%>>
                                                                                                                </td>
                                                                                                                <td width="15%">Non Stock Code</td>
                                                                                                                <td>&nbsp</td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td colspan="6">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td width="12%">&nbsp;&nbsp;For Purchase</td>
                                                                                                    <td width="9%"><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_BUY] %>"  value="1" <%if (itemMaster.getForBuy() == 1) {%>checked<%}%> class="formElemen" ></td>
                                                                                                    <td width="9%">&nbsp;&nbsp;Include In BOM</td>
                                                                                                    <td width="6%"><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_RECIPE_ITEM] %>"  value="1" <%if (itemMaster.getRecipeItem() == 1) {%>checked<%}%> class="formElemen" ></td>
                                                                                                    <td colspan="2">
                                                                                                        <table border = "0">
                                                                                                            <tr>
                                                                                                                <td>Is Service</td>
                                                                                                                <td><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_SERVICE] %>"  value="<%=DbItemMaster.SERVICE%>" <%if (itemMaster.getIs_service() == DbItemMaster.SERVICE) {%>checked<%}%> class="formElemen"></td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;</td>
                                                                                        <td height="21" width="16%">&nbsp;</td>
                                                                                        <td height="21" width="10%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="62%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" colspan="2">&nbsp;&nbsp;<b><u>Unit 
                                                                                            Conversion Table</u></b><br>
                                                                                            <br>
                                                                                        </td>
                                                                                        <td height="21" width="10%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="62%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                                                                        Purchase</td>
                                                                                        <td height="21" width="16%"> 
                                                                                            <% Vector uompurchaseid_value = new Vector(1, 1);
            Vector uompurchaseid_key = new Vector(1, 1);
            String sel_uompurchaseid = "" + itemMaster.getUomPurchaseId();

            uompurchaseid_key.add("0");
            uompurchaseid_value.add(" ");

            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uompurchaseid_key.add("" + uo.getOID());
                    uompurchaseid_value.add("" + uo.getUnit());
                }
            }
                                                                                            %>
                                                                                        <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_ID], null, sel_uompurchaseid, uompurchaseid_key, uompurchaseid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_PURCHASE_ID) %> </td>
                                                                                        <td height="21" width="10%"> 
                                                                                            <div align="right">1 Unit Purchase 
                                                                                            = &nbsp;&nbsp;</div>
                                                                                        </td>
                                                                                        <td height="21" colspan="2" width="62%"> 
                                                                                        <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY] %>"  value="<%= itemMaster.getUomPurchaseStockQty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                        * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY) %> Unit Stock 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                                                                        Stock</td>
                                                                                        <td height="21" width="16%"> 
                                                                                            <% Vector uomstockid_value = new Vector(1, 1);
            Vector uomstockid_key = new Vector(1, 1);
            String sel_uomstockid = "" + itemMaster.getUomStockId();

            uomstockid_key.add("0");
            uomstockid_value.add(" ");

            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomstockid_key.add("" + uo.getOID());
                    uomstockid_value.add("" + uo.getUnit());
                }
            }
                                                                                            %>
                                                                                        <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_ID], null, sel_uomstockid, uomstockid_key, uomstockid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_ID) %></td>
                                                                                        <td height="21" width="10%"> 
                                                                                            <div align="right">1 Unit Stock = 
                                                                                            &nbsp;&nbsp; </div>
                                                                                        </td>
                                                                                        <td height="21" colspan="2" width="62%"> 
                                                                                        <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES_QTY] %>"  value="<%= itemMaster.getUomStockSalesQty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                        * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES_QTY) %> Unit Sales 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                                                                        Recipe</td>
                                                                                        <td height="21" width="16%"> 
                                                                                            <% Vector uomrecipeid_value = new Vector(1, 1);
            Vector uomrecipeid_key = new Vector(1, 1);
            String sel_uomrecipeid = "" + itemMaster.getUomRecipeId();
            uomrecipeid_key.add("0");
            uomrecipeid_value.add("");

            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomrecipeid_key.add("" + uo.getOID());
                    uomrecipeid_value.add("" + uo.getUnit());
                }
            }

                                                                                            %>
                                                                                        <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_RECIPE_ID], null, sel_uomrecipeid, uomrecipeid_key, uomrecipeid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_RECIPE_ID) %> </td>
                                                                                        <td height="21" width="10%"> 
                                                                                            <div align="right">1 Unit Stock = 
                                                                                            &nbsp;&nbsp; </div>
                                                                                        </td>
                                                                                        <td height="21" colspan="2" width="62%"> 
                                                                                        <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY] %>"  value="<%= itemMaster.getUomStockRecipeQty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                        * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY) %> Unit Recipe 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                                                                        Sales</td>
                                                                                        <td height="21" width="16%"> 
                                                                                            <% Vector uomsalesid_value = new Vector(1, 1);
            Vector uomsalesid_key = new Vector(1, 1);
            String sel_uomsalesid = "" + itemMaster.getUomSalesId();
            uomsalesid_key.add("0");
            uomsalesid_value.add("");
            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomsalesid_key.add("" + uo.getOID());
                    uomsalesid_value.add("" + uo.getUnit());
                }
            }
                                                                                            %>
                                                                                        <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES_ID], null, sel_uomsalesid, uomsalesid_key, uomsalesid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_SALES_ID) %> </td>
                                                                                        <td height="21" width="10%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="62%">&nbsp; 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;</td>
                                                                                        <td height="21" width="16%">&nbsp;</td>
                                                                                        <td height="21" width="10%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="62%">&nbsp; 
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" class="command" valign="top"> 
                                                                                                <%
            jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
            jspLine.setTableWidth("80%");
            String scomDel = "javascript:cmdAsk('" + oidItemMaster + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidItemMaster + "')";
            String scancel = "javascript:cmdEdit('" + oidItemMaster + "')";
            jspLine.setBackCaption("");
            jspLine.setJSPCommandStyle("buttonlink");
            jspLine.setDeleteCaption("Delete");
            jspLine.setSaveCaption("Save");
            jspLine.setAddCaption("Add");

            jspLine.setOnMouseOut("MM_swapImgRestore()");
            jspLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
            jspLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

            //jspLine.setOnMouseAddNew("MM_swapImage('new','','"+approot+"/images/new2.gif',1)");
            jspLine.setAddNewImage("<img src=\"" + approot + "/images/new.gif\" name=\"new\" height=\"22\" border=\"0\">");

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

            if (privAdd == false && privUpdate == false) {
                jspLine.setSaveCaption("");
            }

            if (privAdd == false) {
                jspLine.setAddCaption("");
            }
                                                                                                %>
                                                                                            <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="12%">&nbsp;</td>
                                                                                            <td width="16%">&nbsp;</td>
                                                                                            <td width="10%">&nbsp;</td>
                                                                                            <td width="62%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (itemMaster.getOID() != 0) {%>
                                                                                        <%
    Vector listVendorItem = DbVendorItem.list(0, 0, DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID] + "=" + itemMaster.getOID(), DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE]);
                                                                                        %>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
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
