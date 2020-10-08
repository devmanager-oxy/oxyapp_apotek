
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%//@ page import = "com.project.payroll.*" %>
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
            int start = JSPRequestValue.requestInt(request, "startLog");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            long oidItemCategory =JSPRequestValue.requestLong(request, "JSP_ITEM_CATEGORY_ID");
            
            if (iJSPCommand == JSPCommand.NONE) {
                if (oidItemMaster == 0) {
                    iJSPCommand = JSPCommand.ADD;
                } else {
                    iJSPCommand = JSPCommand.EDIT;
                }
            }

            /*variable declaration*/
            int recordToGet = 10;
            int recordToGetLog=5;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            
            /*Vector vv = new Vector();
            vv= DbItemMaster.list(0, 0, "", "");
            for(int i=0;i<vv.size();i++){
                ItemMaster im = (ItemMaster)vv.get(i);
                im.setCounterSku(Integer.parseInt((im.getCode().substring(5, 8))));
                DbItemMaster.updateExc(im);
            }*/
            
            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            JSPLine ctrLine = new JSPLine();
            Vector listItemMaster = new Vector(1, 1);
            
            /*switch statement */
            ctrlItemMaster.setUserId(user.getOID());
            ctrlItemMaster.setUserName(user.getFullName());
            iErrCode = ctrlItemMaster.action(iJSPCommand, oidItemMaster);
            /* end switch*/
            JspItemMaster jspItemMaster = ctrlItemMaster.getForm();
            int vectSizeLog = DbLogOperation.getCount("owner_id="+ oidItemMaster);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlItemMaster.actionList(iJSPCommand, start, vectSizeLog, recordToGetLog);
            }
            Vector vLog = new Vector();
            
            
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
            
                    
            
            vLog= DbLogOperation.list(start, recordToGetLog, "owner_id="+ oidItemMaster, "date desc");
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
                if(oidItemMaster!=0){
                    try{
                        itemMaster= DbItemMaster.fetchExc(oidItemMaster);
                    }catch(Exception ex){
                        
                    }
                }
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

            Vector categories = DbItemCategory.list(0, 0, "group_type<>" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS + " and group_type<>" + I_Ccs.TYPE_CATEGORY_CIVIL_WORK, DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID] + "," + DbItemCategory.colNames[DbItemCategory.COL_NAME]);
            if(iJSPCommand== JSPCommand.ADD){
                if(oidItemCategory==0){
                    ItemCategory ic = (ItemCategory)categories.get(0);
                    oidItemCategory=ic.getOID();
                }
                itemMaster.setItemCategoryId(oidItemCategory);
                
                
                itemMaster.setCode(DbItemMaster.getNextCode(oidItemCategory));
            }
            
            Vector units = DbUom.list(0, 0, "", "");

            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setForSale(1);
                itemMaster.setForBuy(1);
                itemMaster.setIsActive(1);
                itemMaster.setRecipeItem(1);
            }
            
            if(iErrCode > 0 && iJSPCommand==JSPCommand.SAVE){
                itemMaster.setCounterSku(DbItemMaster.getNextCounter(itemMaster.getItemCategoryId()));
                itemMaster.setUomPurchaseId(itemMaster.getUomStockId());
                itemMaster.setUomRecipeId(itemMaster.getUomStockId());
                itemMaster.setUomSalesId(itemMaster.getUomStockId());
                itemMaster.setUomStockRecipeQty(1);
                itemMaster.setUomStockSalesQty(1);
                itemMaster.setUomPurchaseStockQty(1);
                
                ItemCategory icat = new ItemCategory();
                try{
                                        icat = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                                        itemMaster.setItemGroupId(icat.getItemGroupId());
                }catch(Exception e){}
                try{
                    //itemMaster.setSellingPrice(selingPrice);
                    if(itemMaster.getOID()!=0){
                        DbItemMaster.updateExc(itemMaster);
                                             
                        iErrCode=0;
                        
                                         
                    }else{
                        long oiditem = DbItemMaster.insertExc(itemMaster);
                        DbItemMaster.insertOperationLog(oiditem, user.getOID(), user.getLoginId(), itemMaster);
                        iErrCode=0;
                        
                        PriceType pt = new PriceType();
                        pt.setQtyFrom(1);
                        pt.setQtyTo(10000);
                        pt.setItemMasterId(itemMaster.getOID());
                        //pt.setGol1(selingPrice);
                        pt.setChangeDate(new Date());
                        long oidprice = DbPriceType.insertExc(pt);
                        DbPriceType.insertOperationLog(oidprice, user.getOID(), user.getLoginId(), pt);

                        VendorItem vi = new VendorItem();
                        vi.setItemMasterId(itemMaster.getOID());
                        vi.setLastPrice(itemMaster.getCogs());
                        vi.setVendorId(0);
                        DbVendorItem.insertExc(vi);
                    }
                        
                                        
                   
                    
                    
                }catch(Exception ex){
                    
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
            <!--
            var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
            var usrDigitGroup = "<%=sUserDigitGroup%>";
            var usrDecSymbol = "<%=sUserDecimalSymbol%>";
            
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
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
             
            function cmdToProduct(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToRecords(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemlist.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToPrice(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="pricematerial.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToMinimumStock(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
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
            function cmdVendorItem(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
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
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdAsk(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdConfirmDelete(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            function cmdSave(){
                var uom = document.frmitemmaster.<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_ID]%>.value;
                document.frmitemmaster.<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_ID]%>.value=uom;
                document.frmitemmaster.<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_RECIPE_ID]%>.value=uom;
                document.frmitemmaster.<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES_ID]%>.value=uom;
                document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdEdit(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdCancel(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdBack(){
                document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListFirst(){
                document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListPrev(){
                document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListNext(){
                document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListLast(){
                document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
                document.frmitemmaster.submit();
            }
            function cmdGetSku(){
                
                document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.ADD%>";
                document.frmitemmaster.action="itemmastersimple.jsp";
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
                                                            <input type="hidden" name="startLog" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="hidden_vendor_item_id" value="">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_ACTIVE_DATE]%>" value="<%=JSPFormater.formatDate((itemMaster.getActive_date() == null) ? new Date() : itemMaster.getActive_date(), "dd/MM/yyyy")%>" >
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_FOR_SALE]%>" value="1">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_FOR_BUY]%>" value="1">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE_SALES]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_IS_ACTIVE]%>" value="1">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_IS_BKP]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_IS_KOMISI]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_IS_SERVICE]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_LOCATION_ORDER]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_MIN_STOCK]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_RECIPE_ITEM]%>" value="1">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_ID]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY]%>" value="1">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_RECIPE_ID]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES_ID]%>" value="0">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY]%>" value="1">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES_QTY]%>" value="1">
                                                                <input type="hidden" name="<%=JspItemMaster.colNames[JspItemMaster.JSP_USE_EXPIRED_DATE]%>" value="0">
                                                               
                                                                
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                        <tr valign="bottom"> 
                                                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Data Master 
                                                                                                    </font><font class="tit1">&raquo; 
                                                                                                    </font><font class="tit1"><span class="lvl2">Data Barang
                                                                                             </span></font></b></td>
                                                                                            <td width="40%" height="23"> 
                                                                                                <%@ include file = "../main/userpreview.jsp" %>
                                                                                                <%@ include file="../calendar/calendarframe.jsp"%>
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
                                                                                        <tr> 
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecords()" class="tablink">Arsip</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;Data Barang</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                                                                                  
                                                                                            
                                                                                            <%if (itemMaster.getOID() != 0) {
                if (false) {//itemMaster.getForBuy()==1){%>
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
                                                                                            <%if (oidItemMaster != 0) {%>
                                                                                            <td class="tabin" nowrap><div align="center">
                                                                                                &nbsp;&nbsp;<a href="javascript:cmdVendorItem()" class="tablink">Vendor Item</a>&nbsp;&nbsp;
                                                                                            </div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}%>
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
                                                                                            <td height="21" colspan="2">&nbsp;&nbsp;<u><b>Product 
                                                                                            Data</b></u> </td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Kategory</td>
                                                                                            <td height="21" colspan="2" nowrap> 
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
                                                                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_ITEM_CATEGORY_ID], null, sel_itemcategoryid, itemcategoryid_key, itemcategoryid_value, "onchange=\"javascript:cmdGetSku()\"", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_ITEM_CATEGORY_ID) %> </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;SKU</td>
                                                                                            <td height="21" width="20%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_CODE] %>"  value="<%= itemMaster.getCode() %>" class="formElemen" size="20">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_CODE) %> </td>
                                                                                            
                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Barcode</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE] %>"  value="<%= itemMaster.getBarcode() %>" class="formElemen" size="20">
                                                                                            </td>
                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Nama Barang</td>
                                                                                            <td height="21" width="62%"><input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NAME] %>"  value="<%= itemMaster.getName() %>" class="formElemen" size="40">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_NAME) %></td>
                                                                                          
                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Harga Beli</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS] %>"  value="<%= itemMaster.getCogs() %>" class="formElemen" size="20">
                                                                                            </td>
                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Merk</td>
                                                                                            <td height="21"> 
                                                                                                <%
            Vector listMerk = DbMerk.list(0, 0, "", "name");
                                                                                                %>
                                                                                                <select name="<%=jspItemMaster.colNames[JspItemMaster.JSP_MERK_ID] %>">
                                                                                                    
                                                                                                    <%if (listMerk != null && listMerk.size() > 0) {
                for (int i = 0; i < listMerk.size(); i++) {
                    Merk v = (Merk) listMerk.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == itemMaster.getMerk_id()) {%>selected<%}%>><%=v.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                            
                                                                                        </tr>
                                                                                                                                                                        
                                                                                        
                                                                                        
                                                                                        
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Supplier</td>
                                                                                            <td height="21" colspan="4"> 
                                                                                                <%
            Vector listVnd = DbVendor.list(0, 0, "", "name");
                                                                                                %>
                                                                                                <select name="<%=jspItemMaster.colNames[JspItemMaster.JSP_DEFAULT_VENDOR_ID] %>">
                                                                                                    <option value="0">-</option>
                                                                                                    <%if (listVnd != null && listVnd.size() > 0) {
                for (int i = 0; i < listVnd.size(); i++) {
                    Vendor v = (Vendor) listVnd.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == itemMaster.getDefaultVendorId()) {%>selected<%}%>><%=v.getCode() + "-" + v.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                                <div align="right"></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        
                                                                                       
                                                                                       
                                                                                        
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
                                                                                           
                                                                                            
                                                                                        </tr>
                                                                                        
                                                                                        
                                                                                        
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
            if(iJSPCommand==JSPCommand.NEXT || iJSPCommand==JSPCommand.LAST || iJSPCommand==JSPCommand.PREV || iJSPCommand==JSPCommand.FIRST){
                iJSPCommand=JSPCommand.EDIT;
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
                                                                            <%if(vLog.size()>0){%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">
                                                                                    
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                                                                        <tr>
                                                                                        <td width="20%" class="tablehdr">Date</td>
                                                                                        <td width="20%" class="tablehdr">User</td>                                                                                     
                                                                                        <td width="60%" class="tablehdr">Description</td>
                                                                                        </tr>
                                                                                        <% if(vLog.size()>0){
                                                                                                for(int i=0;i<vLog.size();i++){
                                                                                                    LogOperation log = (LogOperation) vLog.get(i);
                                                                                        %>
                                                                                            <tr>
                                                                                            <td width="20%" class="tablecell"><%=JSPFormater.formatDate(log.getDate(), "dd/MM/yyyy hh:mm:ss")%></td>
                                                                                            <td width="20%" class="tablecell"><%=log.getUserName()%></td>                                                                                     
                                                                                            <td width="60%" class="tablecell"><%=log.getLogDesc()%></td>
                                                                                            </tr>
                                                                                        <% 
                                                                                            }}
                                                                                        %> 
                                                                                        

                                             <tr align="left" valign="top"> 
                                          <td height="8" align="left" colspan="3" class="command"> 
                                            <span class="command"> 
                                            <% 
								   int cmd = 0;
									   if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )|| 
										(iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST))
											cmd =iJSPCommand; 
								   else{
									  if(iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE)
										cmd = JSPCommand.FIRST;
									  else 
									  	cmd =prevJSPCommand; 
								   } 
							    %>
                                            <% ctrLine.setLocationImg(approot+"/images/ctr_line");
							   	ctrLine.initDefault();
								
								ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\""+approot+"/images/first.gif\" alt=\"First\">");
								   ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\""+approot+"/images/prev.gif\" alt=\"Prev\">");
								   ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\""+approot+"/images/next.gif\" alt=\"Next\">");
								   ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\""+approot+"/images/last.gif\" alt=\"Last\">");
								   
								   ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','"+approot+"/images/first2.gif',1)");
								   ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','"+approot+"/images/prev2.gif',1)");
								   ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','"+approot+"/images/next2.gif',1)");
								   ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','"+approot+"/images/last2.gif',1)");
								 %>
                                            <%=ctrLine.drawImageListLimit(cmd,vectSizeLog,start,recordToGetLog)%> </span> </td>
                                        </tr>

                                                                                    </table>
                                                                                    
                                                                                    
                                                                                    
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
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
