
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
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = false;
%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "startLog");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            long oidItemCategory = JSPRequestValue.requestLong(request, "JSP_ITEM_CATEGORY_ID");

            if (DbItemMaster.isItemUsed(oidItemMaster)) {
                privDelete = false;
            } else {
                privDelete = true;
            }

            if (iJSPCommand == JSPCommand.NONE) {
                if (oidItemMaster == 0) {
                    iJSPCommand = JSPCommand.ADD;
                } else {
                    iJSPCommand = JSPCommand.EDIT;
                }
            }

            /*variable declaration*/
            int recordToGet = 10;
            int recordToGetLog = 5;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";            

            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            JSPLine ctrLine = new JSPLine();            

            /*switch statement */
            ctrlItemMaster.setUserId(user.getOID());
            ctrlItemMaster.setUserName(user.getFullName());
            iErrCode = ctrlItemMaster.action(iJSPCommand, oidItemMaster);
            /* end switch*/
            JspItemMaster jspItemMaster = ctrlItemMaster.getForm();
            int vectSizeLog = DbLogOperation.getCount("owner_id=" + oidItemMaster);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlItemMaster.actionList(iJSPCommand, start, vectSizeLog, recordToGetLog);
            }
            Vector vLog = new Vector();

            /*count list All ItemMaster*/
            int vectSize = 0;

            ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setItemCategoryId(oidItemCategory);
                itemMaster.setCode(DbItemMaster.getNextCode(oidItemCategory));
            }
            
            msgString = ctrlItemMaster.getMessage();

            if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {
                msgString = "Data is saved";
            }

            if (oidItemMaster == 0) {
                oidItemMaster = itemMaster.getOID();
            }

            vLog = DbLogOperation.list(start, recordToGetLog, "owner_id=" + oidItemMaster, "date desc");
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {                
                if (oidItemMaster != 0) {
                    try {
                        itemMaster = DbItemMaster.fetchExc(oidItemMaster);
                    } catch (Exception ex) {}
                }
            }
            /* end switch list*/

            Vector categories = DbItemCategory.list(0, 0,"", DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID] + "," + DbItemCategory.colNames[DbItemCategory.COL_NAME]);

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
            
            function removeChar(number){                
                var ix;
                var result = "";
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
        
        function cmdAsk(oidItemMaster){
            document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
            document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="itemmaster.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdConfirmDelete(oidItemMaster){
            document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
            document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="itemmaster.jsp";
            document.frmitemmaster.submit();
        }
        function cmdSave(){
            document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="itemmaster.jsp";
            document.frmitemmaster.submit();
        }
        
        function cmdEdit(oidItemMaster){
            document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
            document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
            document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
            document.frmitemmaster.action="itemmaster.jsp";
            document.frmitemmaster.submit();
        }
        function cmdGetSku(){                
            document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
            document.frmitemmaster.prev_command.value="<%=JSPCommand.ADD%>";
            document.frmitemmaster.action="itemmaster.jsp";
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
                                                            <input type="hidden" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_KOMISI] %>" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="0">
                                                            <input type="hidden" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE_SALES]%>" value="0">
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
                                                                                                    </font><font class="tit1"><span class="lvl2">POS 
                                                                                                        </span>&raquo; <span class="lvl2">Item 
                                                                                            List </span></font></b></td>
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
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecords()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;Item Data</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%if (itemMaster.getOID() != 0) {%>
                                                                                            <%if(mstViewCogs){%>
                                                                                            <td class="tabin" nowrap>
                                                                                                <div align="center">      
                                                                                                    <%if(inventory_type == INVENTORY_NON_MULTY_CURRENCY){%>
                                                                                                    &nbsp;&nbsp;<a href="javascript:cmdToPrice()" class="tablink">Price List</a>&nbsp;&nbsp;                                                                                                    
                                                                                                    <%}else{%>
                                                                                                    &nbsp;&nbsp;<a href="javascript:cmdToPriceExc()" class="tablink">Price List</a>&nbsp;&nbsp;     
                                                                                                    <%}%>
                                                                                                </div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}%>
                                                                                            <%}%>
                                                                                            <%if (itemMaster.getOID() != 0) {%>
                                                                                            <td class="tabin" nowrap><div align="center">
                                                                                                    &nbsp;&nbsp;<a href="javascript:cmdToMinimumStock()" class="tablink">Minimum Stock</a>&nbsp;&nbsp;
                                                                                            </div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}%>                                                                                            
                                                                                            <%if (itemMaster.getOID() != 0) {
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
                                                                                <td height="8" valign="middle" colspan="3" > 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="5" valign="middle" colspan="5"></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="21" valign="middle" width="25%" class="fontarial">*)= required</td>
                                                                                            <td height="21" valign="middle" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" colspan="2" class="fontarial">&nbsp;&nbsp;<b><i>Product Data :</i></b></td>
                                                                                            <td height="21" >&nbsp;</td>
                                                                                            <td height="21" colspan="2">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Group</td>
                                                                                            <td colspan="2" class="fontarial">:
                                                                                                <select name="<%=jspItemMaster.colNames[JspItemMaster.JSP_TYPE_ITEM]%>" >
                                                                                                    <option value="<%=DbItemMaster.TYPE_ITEM_BELI_PUTUS%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_BELI_PUTUS) {%>selected<%}%> >Beli Putus</option>
                                                                                                    <option value="<%=DbItemMaster.TYPE_ITEM_KONSINYASI%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_KONSINYASI) {%>selected<%}%> >Konsinyasi</option>                                                                                                    
                                                                                                    <option value="<%=DbItemMaster.TYPE_ITEM_KOMISI%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_KOMISI) {%>selected<%}%> >Komisi</option>                                                                                                    
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Category</td>
                                                                                            <td colspan="3" nowrap class="fontarial">: 
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
                    if (itemMaster.getItemCategoryId() == 0) {
                        itemMaster.setItemCategoryId(ic.getOID());
                    }
                }
            }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_ITEM_CATEGORY_ID], null, sel_itemcategoryid, itemcategoryid_key, itemcategoryid_value, "onchange=\"javascript:cmdGetSku()\"", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_ITEM_CATEGORY_ID) %> </td>
                                                                                        </tr>
                                                                                        <%
            if (iJSPCommand == JSPCommand.ADD) {
                if (oidItemCategory == 0) {
                    itemMaster.setCode(DbItemMaster.getNextCode(itemMaster.getItemCategoryId()));
                }


            }

                                                                                        %>	
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;SKU</td>
                                                                                            <td class="fontarial">: 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_CODE] %>"  value="<%= itemMaster.getCode() %>" class="fontarial" size="20">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_CODE) %> </td>
                                                                                            <td colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Merk</td>
                                                                                            <td class="fontarial">: 
                                                                                                
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
                                                                                            </td>
                                                                                            <td class="tablearialcell1"> 
                                                                                                <div align="right">Item Name&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td colspan="2" class="fontarial">: <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NAME] %>"  value="<%= itemMaster.getName() %>" class="formElemen" size="40">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_NAME) %></td>
                                                                                        </tr>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Barcode</td>
                                                                                            <td class="fontarial">: 
                                                                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE] %>"  value="<%= itemMaster.getBarcode() %>" class="formElemen" size="20"></td>
                                                                                            <%if(mstViewCogs){%>
                                                                                            <td class="tablearialcell1">
                                                                                                <div align="right">C.O.G.S.&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="fontarial">: 
                                                                                                <input type="text" readonly class="readonly" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") %>" class="formElemen" size="20" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()"> 
                                                                                            </td>
                                                                                            <%}else{%>
                                                                                            <input type="hidden" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") %>"> 
                                                                                            <td ></td>
                                                                                            <td >
                                                                                                
                                                                                            </td>
                                                                                            <%}%>
                                                                                        </tr>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Barcode 2</td>
                                                                                            <td class="fontarial">: <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE_2] %>"  value="<%= itemMaster.getBarcode2() %>" class="formElemen" size="20">
                                                                                            </td>
                                                                                            <td class="tablearialcell1">
                                                                                                <div align="right">&nbsp;&nbsp;Default Vendor</div>
                                                                                            </td>
                                                                                            <td class="fontarial">: 
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
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Barcode 3</td>
                                                                                            <td class="fontarial">:  
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE_3] %>"  value="<%= itemMaster.getBarcode3() %>" class="formElemen" size="20">
                                                                                            </td>                                                                                            
                                                                                            <td class="tablearialcell1">
                                                                                                <div align="right">Active Date&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td colspan="2" class="fontarial">:
                                                                                                <input name="<%=jspItemMaster.colNames[jspItemMaster.JSP_ACTIVE_DATE]%>" value="<%=JSPFormater.formatDate((itemMaster.getActive_date() == null) ? new Date() : itemMaster.getActive_date(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_ACTIVE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr height="30"> 
                                                                                            <td colspan="5">&nbsp;</td>                                                                                            
                                                                                        </tr>    
                                                                                        <tr align="left"> 
                                                                                            <td colspan="5" class="fontarial">&nbsp;<b><i>Sales and Purchase Parameter :</i></b></td>                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" colspan="5"> 
                                                                                                <table width="700" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr height="24"> 
                                                                                                        <td width="100" class="tablearialcell1">&nbsp;&nbsp;For Sale </td>
                                                                                                        <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_SALE] %>"  value="1" <%if (itemMaster.getForSale() == 1) {%>checked<%}%>></td>
                                                                                                        <td width="5">&nbsp;</td>
                                                                                                        <td width="60" align="left" class="tablearialcell1">&nbsp;&nbsp;Need BOM</td>
                                                                                                        <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_BOM] %>"  value="1" <%if (itemMaster.getNeedBom() == 1) {%>checked<%}%> class="formElemen" ></td>
                                                                                                        <td width="60" class="tablearialcell1">&nbsp;&nbsp;Available</td>
                                                                                                        <td width="90" ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_ACTIVE] %>"  value="1" <%if (itemMaster.getIsActive() == 1) {%>checked<%}%> class="formElemen"></td>
                                                                                                        <td width="90" class="tablearialcell1">&nbsp;&nbsp;For Purchase</td>
                                                                                                        <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_BUY] %>"  value="1" <%if (itemMaster.getForBuy() == 1) {%>checked<%}%> class="formElemen" ></td>
                                                                                                    </tr>                                                                                                          
                                                                                                    <tr height="24">
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Include In BOM</td>
                                                                                                        <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_RECIPE_ITEM] %>"  value="1" <%if (itemMaster.getRecipeItem() == 1) {%>checked<%}%> class="formElemen" ></td>
                                                                                                        <td >&nbsp;&nbsp;</td>                                                                                                    
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Service</td>
                                                                                                        <td><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_SERVICE] %>"  value="<%=DbItemMaster.SERVICE%>" <%if (itemMaster.getIs_service() == DbItemMaster.SERVICE) {%>checked<%}%> class="formElemen"></td>
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;BKP</td>
                                                                                                        <td><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_BKP] %>"  value="<%=DbItemMaster.BKP%>" <%if (itemMaster.getIs_bkp() == DbItemMaster.BKP) {%>checked<%}%> class="formElemen"></td>                                                                                                    
                                                                                                        <td class="tablearialcell1">&nbsp;&nbsp;Use Expired Date</td>                                                                                                    
                                                                                                        <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_USE_EXPIRED_DATE] %>"  value="1" <%if (itemMaster.getUseExpiredDate() == 1) {%>checked<%}%> class="formElemen"></td>  
                                                                                                    </tr>                                                                                                                                                                                                                                                                                      
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                         <tr height="30"> 
                                                                                            <td colspan="5">&nbsp;</td>                                                                                            
                                                                                        </tr>    
                                                                                        <tr align="left"> 
                                                                                            <td colspan="5" class="fontarial">&nbsp;<b><i>Stockable :</i></b></td>                                                                                            
                                                                                        </tr>                                                                                        
                                                                                        <tr>
                                                                                            <td colspan="6">
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr height="24"> 
                                                                                                        <td width="30"><input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="1" <%if (itemMaster.getNeedRecipe() == 1) {%>checked<%}%>></td>
                                                                                                        <td width="13%" nowrap class="tablearialcell1">&nbsp;&nbsp;Non Stockable</td>
                                                                                                        <td width="2%"><input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="0" <%if (itemMaster.getNeedRecipe() == 0) {%>checked<%}%>></td>
                                                                                                        <td width="10%" class="tablearialcell1"> &nbsp;&nbsp;Stockable</td>
                                                                                                        <td>&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>                                                                                                                        
                                                                                            </td>
                                                                                        </tr>  
                                                                                        <tr height="30"> 
                                                                                            <td colspan="5">&nbsp;</td>                                                                                            
                                                                                        </tr>    
                                                                                        <tr align="left"> 
                                                                                            <td colspan="5" class="fontarial">&nbsp;<b><i>Auto Replenishment :</i></b></td>                                                                                            
                                                                                        </tr>                                                                                         
                                                                                        <tr>
                                                                                            <td colspan="5">
                                                                                                <table width="250" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr align="left" height="24"> 
                                                                                                        <td class="tablearialcell1" width="100">&nbsp;Auto Order</td>
                                                                                                        <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_AUTO_ORDER] %>"  value="1" <%if (itemMaster.getIsAutoOrder() == 1) {%>checked<%}%>></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <tr align="left" height="24"> 
                                                                                                        <td class="tablearialcell1">&nbsp;Delivery Unit&nbsp;</td>
                                                                                                        <td ><input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_DELIVERY_UNIT] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getDeliveryUnit(), "#,###.##") %>" class="formElemen" size="20" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                                                                        </td>                                                                                                       
                                                                                                    </tr>
                                                                                                    <tr align="left" height="24"> 
                                                                                                        <td class="tablearialcell1">&nbsp;Location Order &nbsp; </td>
                                                                                                        <td > 
                                                                                                            <select name="<%=JspItemMaster.colNames[JspItemMaster.JSP_LOCATION_ORDER]%>" class="fontarial">
                                                                                                                
                                                                                                                <%
            Vector locations = DbLocation.list(0, 0, "", "name");
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);


                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (itemMaster.getLocationOrder() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>                                                                                                        
                                                                                                    </tr>
                                                                                                </table>                                                                                                                        
                                                                                            </td>
                                                                                        </tr>  
                                                                                        <tr height="30"> 
                                                                                            <td colspan="5">&nbsp;</td>                                                                                            
                                                                                        </tr>    
                                                                                        <tr align="left"> 
                                                                                            <td colspan="5" class="fontarial">&nbsp;<b><i>Unit Conversion Table :</i></b></td>                                                                                            
                                                                                        </tr>                                                                                         
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Unit Purchase</td>
                                                                                            <td>: 
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
                                                                                            <td class="tablearialcell1"> 
                                                                                                <div align="right">1 Unit Purchase &nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td colspan="2">: 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY] %>"  value="<%= itemMaster.getUomPurchaseStockQty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY) %> Unit Stock</td> 
                                                                                        </tr>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Unit Stock</td>
                                                                                            <td >: 
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
                                                                                            <td class="tablearialcell1"> 
                                                                                                <div align="right">1 Unit Stock &nbsp;&nbsp; </div>
                                                                                            </td>
                                                                                            <td colspan="2">: 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES_QTY] %>"  value="<%= itemMaster.getUomStockSalesQty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES_QTY) %> Unit Sales</td>
                                                                                        </tr>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Unit Recipe</td>
                                                                                            <td >: 
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
                                                                                            <td class="tablearialcell1"> 
                                                                                                <div align="right">1 Unit Stock &nbsp;&nbsp; </div>
                                                                                            </td>
                                                                                            <td >: 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY] %>"  value="<%= itemMaster.getUomStockRecipeQty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY) %> Unit Recipe </td>
                                                                                        </tr>
                                                                                        <tr height="24"> 
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Unit Sales</td>
                                                                                            <td >: 
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
                                                                                            
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td colspan="5">&nbsp;</td>                                                                                           
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
            if (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST || iJSPCommand == JSPCommand.PREV || iJSPCommand == JSPCommand.FIRST) {
                iJSPCommand = JSPCommand.EDIT;
            }
                                                                                                %>
                                                                                            <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                                        </tr>                                                                                        
                                                                                        <tr> 
                                                                                            <td colspan="5">&nbsp;</td>                                                                                          
                                                                                        </tr>
                                                                                        <%if (itemMaster.getOID() != 0) {%>
                                                                                        <%
    Vector listVendorItem = DbVendorItem.list(0, 0, DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID] + "=" + itemMaster.getOID(), DbVendorItem.colNames[DbVendorItem.COL_UPDATE_DATE]);
                                                                                        %>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" height="30"> 
                                                                                <td height="8" valign="middle" colspan="3"> &nbsp;</td> 
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">                                                                                    
                                                                                    <table width="900" border="0" cellpadding="0" cellspacing="1">
                                                                                        <%if (vLog.size() > 0) {%>
                                                                                        <tr>
                                                                                            <td width="100" class="tablehdr"><font size="1">Date</font></td>
                                                                                            <td width="200" class="tablehdr"><font size="1">User</font></td>                                                                                     
                                                                                            <td  class="tablehdr"><font size="1">Description</font></td>
                                                                                        </tr>
                                                                                        <%
    for (int i = 0; i < vLog.size(); i++) {
        LogOperation log = (LogOperation) vLog.get(i);
                                                                                        %>
                                                                                        <tr>
                                                                                            <td align="center" class="tablecell"><font size="1"><%=JSPFormater.formatDate(log.getDate(), "dd MMM yyyy HH:mm:ss")%></font></td>
                                                                                            <td class="tablecell">&nbsp;<font size="1"><%=log.getUserName()%>&nbsp;</font></td>                                                                                     
                                                                                            <td class="tablecell">&nbsp;<font size="1"><%=log.getLogDesc()%>&nbsp;</font></td>
                                                                                        </tr>
                                                                                        <%
                }
            }
                                                                                        %>                                                                                                                                                                               
                                                                                    </table>
                                                                                </td>
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
