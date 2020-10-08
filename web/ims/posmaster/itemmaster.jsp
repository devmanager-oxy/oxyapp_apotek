
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MATERIAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MATERIAL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MATERIAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MATERIAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MATERIAL, AppMenu.PRIV_DELETE);
%>
<%! 
public static long getOidGroup(long oid) {
        CONResultSet dbrs = null;
        long oidGroup = 0;
        try {
            String sql = "select item_group_id from pos_item_master where item_master_id = "+oid;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                oidGroup = rs.getLong("item_group_id");
            }

            rs.close();
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
        return oidGroup;

    }

%>
<!-- Jsp Block -->
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            long oidItemCategory = JSPRequestValue.requestLong(request, "JSP_ITEM_CATEGORY_ID");
            
            int showAll = JSPRequestValue.requestInt(request, "show_all");

            if (iJSPCommand == JSPCommand.NONE) {
                if (oidItemMaster == 0) {
                    iJSPCommand = JSPCommand.ADD;
                } else {
                    iJSPCommand = JSPCommand.EDIT;
                }
            }

            /*variable declaration*/
            int recordToGetLog = 5;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            JSPLine ctrLine = new JSPLine();

            /*switch statement */
            ctrlItemMaster.setUserId(user.getOID());
            ctrlItemMaster.setUserName(user.getFullName());
            iErrCode = ctrlItemMaster.action(iJSPCommand, oidItemMaster);
            JspItemMaster jspItemMaster = ctrlItemMaster.getForm();

            Vector vLog = new Vector();
            ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
            ItemGroup igg = new ItemGroup();
            ItemCategory icc = new ItemCategory();
            Vector categories = DbItemCategory.list(0, 0, "group_type<>" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS + " and group_type<>" + I_Ccs.TYPE_CATEGORY_CIVIL_WORK, DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID] + "," + DbItemCategory.colNames[DbItemCategory.COL_NAME]);
            try {
                icc = DbItemCategory.fetchExc(oidItemCategory);
                igg = DbItemGroup.fetchExc(icc.getItemGroupId());
            } catch (Exception ex) {

            }
            
            out.println("oid 1"+igg.getOID());
            out.println("oid 2"+itemMaster.getItemGroupId());
            
            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setItemCategoryId(oidItemCategory);
                if(igg.getOID() != getOidGroup(itemMaster.getOID())){
                    itemMaster.setCode(DbItemMaster.getNextCode(igg.getOID()));
                }
            }
            msgString = ctrlItemMaster.getMessage();
            if (iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {
                msgString = "Data is saved";
            }

            if (oidItemMaster == 0) {
                oidItemMaster = itemMaster.getOID();
            }

            vLog = DbLogOperation.list(0, recordToGetLog, "owner_id=" + oidItemMaster, "date desc");
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                if (oidItemMaster != 0) {
                    try {
                        itemMaster = DbItemMaster.fetchExc(oidItemMaster);
                    } catch (Exception ex) {
                    }
                }
            }
            /* end switch list*/


            Vector units = DbUom.list(0, 0, "", DbUom.colNames[DbUom.COL_UNIT]);

            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setForSale(1);
                itemMaster.setForBuy(1);
                itemMaster.setIsActive(1);
                itemMaster.setRecipeItem(1);
            }
            
            out.println(oidItemCategory);
            out.println("command "+iJSPCommand);
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
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdUnShowAll(){
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.show_all.value=0;
                document.frmitemmaster.action="itemmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdShowAll(){
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.show_all.value=1;
                document.frmitemmaster.action="itemmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function removeChar(number){                
                var ix;
                var result = "";
                for(ix=0; ix<number.length; ix++){
                    var xx = number.charAt(ix);                    
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
            
            function checkNumber2(){
                var st = document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_NEW_COGS]%>.value;		
                result = removeChar(st);
                result = cleanNumberFloat(result, sysDecSymbol, usrDigitGroup, usrDecSymbol);                
                document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_NEW_COGS]%>.value = formatFloat(result, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
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
            
            function cmdAdd(){
                document.frmitemmaster.hidden_item_master_id.value="0";
                document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmaster.jsp";
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
            
            function cmdBack(){
                document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
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
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="hidden_vendor_item_id" value="">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="show_all" value="0">
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
                                                                                            <td class="tabin" nowrap><div align="center">
                                                                                                    &nbsp;&nbsp;<a href="javascript:cmdToPrice()" class="tablink">Price List</a>&nbsp;&nbsp;
                                                                                            </div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}%>
                                                                                            
                                                                                            <%if (itemMaster.getOID() != 0) {
                if (false) {//itemMaster.getForBuy()==1){
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
                                                                                <td height="8" valign="middle" colspan="3" > 
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
                                                                                            <td height="21">&nbsp;&nbsp;Group</td>
                                                                                            <td height="21" colspan="2">
                                                                                                <select name="<%=jspItemMaster.colNames[JspItemMaster.JSP_TYPE_ITEM]%>" >
                                                                                                    <option value="<%=DbItemMaster.TYPE_ITEM_BELI_PUTUS%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_BELI_PUTUS) {%>selected<%}%> >Beli Putus</option>
                                                                                                    <option value="<%=DbItemMaster.TYPE_ITEM_KONSINYASI%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_KONSINYASI) {%>selected<%}%> >Konsinyasi</option>                                                                                                    
                                                                                                    <option value="<%=DbItemMaster.TYPE_ITEM_KOMISI%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_KOMISI) {%>selected<%}%> >Komisi</option>                                                                                                    
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <input type="hidden" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_ITEM_GROUP_ID]%>" value="<%=itemMaster.getItemGroupId()%>">
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Category</td>
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
                    itemMaster.setCode(DbItemMaster.getNextCode(igg.getOID()));
                }


            }

                                                                                        %>	
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;SKU</td>
                                                                                            <td height="21" width="20%"> 
                                                                                                <input class="ReadOnly" ReadOnly type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_CODE] %>"  value="<%= itemMaster.getCode() %>" class="formElemen" size="20">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_CODE) %> </td>
                                                                                            <td height="21" width="10%"> 
                                                                                                <div align="right">Item Name&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td height="21" colspan="2" width="62%"><input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NAME] %>"  value="<%= itemMaster.getName() %>" class="formElemen" size="40">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_NAME) %></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Merk</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                
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
                                                                                            <td height="21" width="10%">
                                                                                                <div align="right">C.O.G.S.&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td height="21" colspan="2" width="62%">
                                                                                                <% if (itemMaster.getOID() != 0) {%>
                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td><input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()"></td> 
                                                                                                        <td class="fontarial">&nbsp;<i>(by system)</i></td>
                                                                                                    </tr>    
                                                                                                </table>   
                                                                                                <%} else {%>
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") %>" size="20" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">   
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Barcode</td>
                                                                                            <td height="21"> 
                                                                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE] %>"  value="<%= itemMaster.getBarcode() %>" class="formElemen" size="20"></td>
                                                                                            <td height="21" width="10%">
                                                                                                <div align="right">New C.O.G.S.&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td height="21" colspan="2" width="62%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEW_COGS] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getNew_cogs(), "#,###.##") %>" class="formElemen" size="20" style="text-align:right" onBlur="javascript:checkNumber2()" onClick="this.select()"> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Barcode 2</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE_2] %>"  value="<%= itemMaster.getBarcode2() %>" class="formElemen" size="20">
                                                                                            </td>
                                                                                            <td height="21" width="10%">
                                                                                                <div align="right">Active Date&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td colspan="2" class="comment" width="52%">
                                                                                                <input name="<%=jspItemMaster.colNames[jspItemMaster.JSP_ACTIVE_DATE]%>" value="<%=JSPFormater.formatDate((itemMaster.getActive_date() == null) ? new Date() : itemMaster.getActive_date(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_ACTIVE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Barcode 3</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_BARCODE_3] %>"  value="<%= itemMaster.getBarcode3() %>" class="formElemen" size="20">
                                                                                            </td>
                                                                                            <td height="21" width="10%">
                                                                                                <div align="right">&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td colspan="2" class="comment" width="52%"></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%"></td>
                                                                                            <td height="21" width="16%"></td>
                                                                                            <td height="21" width="10%"></td>
                                                                                            <td height="21" colspan="2" width="62%"></td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;</td>
                                                                                            <td height="21" width="16%">&nbsp;</td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" colspan="2">&nbsp;&nbsp;<b><u>Sales and Purchase Parameter</u><u></u><i><u><br><br></u></i></b></td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" colspan="5"> 
                                                                                            <table width="700" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td width="100">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;For Sale </td>
                                                                                                    <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_SALE] %>"  value="1" <%if (itemMaster.getForSale() == 1) {%>checked<%}%>></td>
                                                                                                    <td width="5">&nbsp;</td>
                                                                                                    <td width="60" align="left">Is Komisi</td>
                                                                                                    <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_KOMISI] %>"  value="1" <%if (itemMaster.getIsKomisi() == 1) {%>checked<%}%>></td>
                                                                                                    <td width="60" >Is Available</td>
                                                                                                    <td  width="90" ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_ACTIVE] %>"  value="1" <%if (itemMaster.getIsActive() == 1) {%>checked<%}%> class="formElemen"></td>
                                                                                                    <td width="90" >For Purchase</td>
                                                                                                    <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_BUY] %>"  value="1" <%if (itemMaster.getForBuy() == 1) {%>checked<%}%> class="formElemen" ></td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td colspan="9">&nbsp;</td>
                                                                                                </tr>        
                                                                                                <tr>
                                                                                                    <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Include In BOM</td>
                                                                                                    <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_RECIPE_ITEM] %>"  value="1" <%if (itemMaster.getRecipeItem() == 1) {%>checked<%}%> class="formElemen" ></td>
                                                                                                    <td >&nbsp;&nbsp;</td>                                                                                                    
                                                                                                    <td>Is Service</td>
                                                                                                    <td><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_SERVICE] %>"  value="<%=DbItemMaster.SERVICE%>" <%if (itemMaster.getIs_service() == DbItemMaster.SERVICE) {%>checked<%}%> class="formElemen"></td>
                                                                                                    <td>Is BKP</td>
                                                                                                    <td><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_BKP] %>"  value="<%=DbItemMaster.BKP%>" <%if (itemMaster.getIs_bkp() == DbItemMaster.BKP) {%>checked<%}%> class="formElemen"></td>                                                                                                    
                                                                                                    <td >Use Expired Date</td>                                                                                                    
                                                                                                    <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_USE_EXPIRED_DATE] %>"  value="1" <%if (itemMaster.getUseExpiredDate() == 1) {%>checked<%}%> class="formElemen"></td>  
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td colspan="9">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr>                                                                                                    
                                                                                                    <td colspan="9" >
                                                                                                        <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                                            <tr>
                                                                                                                <td >
                                                                                                                    <table width="400" border="0" cellspacing="1" cellpadding="1">                                                                                                                        
                                                                                                                        <tr>
                                                                                                                            <td colspan="6" height="4"></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;<B><u>Stockable</u></B></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="6">
                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                    <tr> 
                                                                                                                                        <td width="30">&nbsp;&nbsp;<input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="1" <%if (itemMaster.getNeedRecipe() == 1) {%>checked<%}%>></td>
                                                                                                                                        <td width="13%" nowrap>Non Stockable</td>
                                                                                                                                        <td width="2%"><input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="0" <%if (itemMaster.getNeedRecipe() == 0) {%>checked<%}%>></td>
                                                                                                                                        <td width="10%">Stockable</td>
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
                                                                                                <tr> 
                                                                                                    <td colspan="9">&nbsp;</td>
                                                                                                </tr>                                                                                                                                                                                        
                                                                                                <tr>                                                                                                    
                                                                                                    <td colspan="9" >
                                                                                                        <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                                            <tr>
                                                                                                                <td >
                                                                                                                    <table width="400" border="0" cellspacing="1" cellpadding="1">                                                                                                                        
                                                                                                                        <tr>
                                                                                                                            <td colspan="6" height="4"></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;<B><u>Stock Code</u></B></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="6" height="4"></td>
                                                                                                                        </tr>
                                                                                                                        <tr>    
                                                                                                                            <td width="30">&nbsp;&nbsp;<input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.APPLY_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE) {%>checked<%}%>></td>
                                                                                                                            <td >Apply Stock Code</td>
                                                                                                                            <td width="15"><input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.OPTIONAL_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE) {%>checked<%}%>></td>
                                                                                                                            <td >Optional Stock Code</td>
                                                                                                                            <td width="15"><input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.NON_APPLY_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.NON_APPLY_STOCK_CODE) {%>checked<%}%>></td>
                                                                                                                            <td >Non Stock Code</td>                                                                                                                
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="6" height="4"></td>
                                                                                                                        </tr>
                                                                                                                    </table>
                                                                                                                </td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td colspan="9">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr>                                                                                                    
                                                                                                    <td colspan="9" >
                                                                                                        <table width="400" border="0" cellspacing="1" cellpadding="1">
                                                                                                            <tr>
                                                                                                                <td >
                                                                                                                    <table width="500" border="0" cellspacing="1" cellpadding="1">                                                                                                                        
                                                                                                                        <tr>
                                                                                                                            <td colspan="6" height="4"></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="6">&nbsp;&nbsp;&nbsp;&nbsp;<B><u>Stock Code Sales</u></B></td>
                                                                                                                        </tr>
                                                                                                                        <tr>
                                                                                                                            <td colspan="6">
                                                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                                    <tr> 
                                                                                                                                        <td width="30">&nbsp;&nbsp;<input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE_SALES]%>" value="<%=DbItemMaster.APPLY_STOCK_CODE_SALES%>" <%if (itemMaster.getApplyStockCodeSales() == DbItemMaster.APPLY_STOCK_CODE_SALES) {%>checked<%}%>></td>
                                                                                                                                        <td >Apply Stock Code Sales</td>
                                                                                                                                        <td width="15"> 
                                                                                                                                        <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE_SALES]%>" value="<%=DbItemMaster.OPTIONAL_STOCK_CODE_SALES%>" <%if (itemMaster.getApplyStockCodeSales() == DbItemMaster.OPTIONAL_STOCK_CODE_SALES) {%>checked<%}%>>
                                                                                                                                               </td>
                                                                                                                                        <td >Optional Stock Code Sales</td>
                                                                                                                                        <td width="2%"> 
                                                                                                                                        <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE_SALES]%>" value="<%=DbItemMaster.NON_APPLY_STOCK_CODE_SALES%>" <%if (itemMaster.getApplyStockCodeSales() == DbItemMaster.NON_APPLY_STOCK_CODE_SALES) {%>checked<%}%>>
                                                                                                                                               </td>
                                                                                                                                        <td >Non Stock Code Sales</td>
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
                                                                                                <tr> 
                                                                                                    <td colspan="9">&nbsp;</td>
                                                                                                </tr>                                                                                                
                                                                                            </table>
                                                                                        </td>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;</td>
                                                                                            <td height="21" width="16%">&nbsp;</td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Default 
                                                                                            Vendor</td>
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
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Is Auto Order</td>
                                                                                            <td ><input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_AUTO_ORDER] %>"  value="1" <%if (itemMaster.getIsAutoOrder() == 1) {%>checked<%}%>></td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Minimum 
                                                                                            Stock&nbsp; </td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_MIN_STOCK] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getMinStock(), "#,###.##") %>" class="formElemen" size="20" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                                                            </td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Delivery Unit 
                                                                                            &nbsp; </td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_DELIVERY_UNIT] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getDeliveryUnit(), "#,###.##") %>" class="formElemen" size="20" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                                                            </td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Location Order 
                                                                                            &nbsp; </td>
                                                                                            <td width="16%"> 
                                                                                                <select name="<%=JspItemMaster.colNames[JspItemMaster.JSP_LOCATION_ORDER]%>">
                                                                                                    <option value="0" <%if (itemMaster.getLocationOrder() == 0) {%>selected<%}%>>ALL</option>
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
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;</td>
                                                                                            <td height="21" width="16%">&nbsp;</td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" colspan="2">&nbsp;&nbsp;<b><u>Unit 
                                                                                                Conversion Table</u></b><br>
                                                                                                <br>
                                                                                            </td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                                                                            Purchase</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <% Vector uompurchaseid_value = new Vector(1, 1);
            Vector uompurchaseid_key = new Vector(1, 1);
            String sel_uompurchaseid = "" + itemMaster.getUomPurchaseId();

            uompurchaseid_key.add("0");
            uompurchaseid_value.add("- select -");

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
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY) %> Unit Stock</td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                                                                            Stock</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <% Vector uomstockid_value = new Vector(1, 1);
            Vector uomstockid_key = new Vector(1, 1);
            String sel_uomstockid = "" + itemMaster.getUomStockId();

            uomstockid_key.add("0");
            uomstockid_value.add("- select -");

            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomstockid_key.add("" + uo.getOID());
                    uomstockid_value.add("" + uo.getUnit());
                }
            }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_ID], null, sel_uomstockid, uomstockid_key, uomstockid_value, "", "fontarial") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_ID) %></td>
                                                                                            <td height="21" width="10%"> 
                                                                                                <div align="right">1 Unit Stock = 
                                                                                                &nbsp;&nbsp; </div>
                                                                                            </td>
                                                                                            <td height="21" colspan="2" width="62%"> 
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES_QTY] %>"  value="<%= itemMaster.getUomStockSalesQty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES_QTY) %> Unit Sales</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Unit 
                                                                                            Recipe</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <% Vector uomrecipeid_value = new Vector(1, 1);
            Vector uomrecipeid_key = new Vector(1, 1);
            String sel_uomrecipeid = "" + itemMaster.getUomRecipeId();
            uomrecipeid_key.add("0");
            uomrecipeid_value.add("- select -");

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
                                                                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY) %> Unit Recipe </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Unit Sales 1</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <% Vector uomsalesid_value = new Vector(1, 1);
            Vector uomsalesid_key = new Vector(1, 1);
            String sel_uomsalesid = "" + itemMaster.getUomSalesId();
            uomsalesid_key.add("0");
            uomsalesid_value.add("- select -");
            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomsalesid_key.add("" + uo.getOID());
                    uomsalesid_value.add("" + uo.getUnit());
                }
            }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES_ID], null, sel_uomsalesid, uomsalesid_key, uomsalesid_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_SALES_ID) %> </td>
                                                                                            <td height="21" width="10%"> <div align="right">1 Unit Stock = 
                                                                                            &nbsp;&nbsp; </div></td>
                                                                                            <td height="21" colspan="2" width="62%">
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES1_QTY] %>"  value="<%= itemMaster.getUomStockSales1Qty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                                * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES1_QTY) %> Unit Sales
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Unit Sales 2</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <% Vector uomsales2id_value = new Vector(1, 1);
            Vector uomsales2id_key = new Vector(1, 1);
            String sel_uomsales2id = "" + itemMaster.getUomSales2Id();
            uomsales2id_key.add("0");
            uomsales2id_value.add("- select -");
            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomsales2id_key.add("" + uo.getOID());
                    uomsales2id_value.add("" + uo.getUnit());
                }
            }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES2_ID], null, sel_uomsales2id, uomsales2id_key, uomsales2id_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_SALES2_ID) %> </td>
                                                                                            <td height="21" width="10%"> <div align="right">1 Unit Stock = 
                                                                                            &nbsp;&nbsp; </div></td>
                                                                                            <td height="21" colspan="2" width="62%">
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES2_QTY] %>"  value="<%= itemMaster.getUomStockSales2Qty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                                * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES2_QTY) %> Unit Sales
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Unit Sales 3</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <% Vector uomsales3id_value = new Vector(1, 1);
            Vector uomsales3id_key = new Vector(1, 1);
            String sel_uomsales3id = "" + itemMaster.getUomSales3Id();
            uomsales3id_key.add("0");
            uomsales3id_value.add("- select -");
            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomsales3id_key.add("" + uo.getOID());
                    uomsales3id_value.add("" + uo.getUnit());
                }
            }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES3_ID], null, sel_uomsales3id, uomsales3id_key, uomsales3id_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_SALES3_ID) %> </td>
                                                                                            <td height="21" width="10%"> <div align="right">1 Unit Stock = 
                                                                                            &nbsp;&nbsp; </div></td>
                                                                                            <td height="21" colspan="2" width="62%">
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES3_QTY] %>"  value="<%= itemMaster.getUomStockSales3Qty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                                * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES3_QTY) %> Unit Sales
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Unit Sales 4</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <% Vector uomsales4id_value = new Vector(1, 1);
            Vector uomsales4id_key = new Vector(1, 1);
            String sel_uomsales4id = "" + itemMaster.getUomSales4Id();
            uomsales4id_key.add("0");
            uomsales4id_value.add("- select -");
            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomsales4id_key.add("" + uo.getOID());
                    uomsales4id_value.add("" + uo.getUnit());
                }
            }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES4_ID], null, sel_uomsales4id, uomsales4id_key, uomsales4id_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_SALES4_ID) %> </td>
                                                                                            <td height="21" width="10%"> <div align="right">1 Unit Stock = 
                                                                                            &nbsp;&nbsp; </div></td>
                                                                                            <td height="21" colspan="2" width="62%">
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES4_QTY] %>"  value="<%= itemMaster.getUomStockSales4Qty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                                * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES4_QTY) %> Unit Sales
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;&nbsp;Unit Sales 5</td>
                                                                                            <td height="21" width="16%"> 
                                                                                                <% Vector uomsales5id_value = new Vector(1, 1);
            Vector uomsales5id_key = new Vector(1, 1);
            String sel_uomsales5id = "" + itemMaster.getUomSales5Id();
            uomsales5id_key.add("0");
            uomsales5id_value.add("- select -");
            if (units != null && units.size() > 0) {
                for (int i = 0; i < units.size(); i++) {
                    Uom uo = (Uom) units.get(i);
                    uomsales5id_key.add("" + uo.getOID());
                    uomsales5id_value.add("" + uo.getUnit());
                }
            }
                                                                                                %>
                                                                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_UOM_SALES5_ID], null, sel_uomsales5id, uomsales5id_key, uomsales5id_value, "", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_SALES5_ID) %> </td>
                                                                                            <td height="21" width="10%"> <div align="right">1 Unit Stock = 
                                                                                            &nbsp;&nbsp; </div></td>
                                                                                            <td height="21" colspan="2" width="62%">
                                                                                                <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES5_QTY] %>"  value="<%= itemMaster.getUomStockSales5Qty() %>" class="formElemen" size="5" style="text-align:right">
                                                                                                * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES5_QTY) %> Unit Sales
                                                                                            </td> 
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" width="12%">&nbsp;</td>
                                                                                            <td height="21" width="16%">&nbsp;</td>
                                                                                            <td height="21" width="10%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="62%">&nbsp;</td> 
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
                if (DbItemMaster.isItemUsed(oidItemMaster)) {
                    privDelete = false;
                } else {
                    privDelete = true;
                    jspLine.setConfirmDelJSPCommand(sconDelCom);
                    jspLine.setDeleteJSPCommand(scomDel);
                    jspLine.setEditJSPCommand(scancel);
                }

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
                                                                                            <td width="12%">&nbsp;</td>
                                                                                            <td width="16%">&nbsp;</td>
                                                                                            <td width="10%">&nbsp;</td>
                                                                                            <td width="62%">&nbsp;</td>
                                                                                        </tr>                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3">                                                                                    
                                                                                    <table width="800" >
                                                                                        <%if (vLog.size() > 0) {%>
                                                                                        <tr> 
                                                                                            <td class="fontarial" colspan="3"><i><u>History Item</u></i></td>
                                                                                        </tr>
                                                                                        <tr height="22">
                                                                                            <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i><b></td>
                                                                                            <td width="200" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>User</i><b></td>
                                                                                            <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i><b></td>
                                                                                        </tr> 
                                                                                        <%
    for (int i = 0; i < vLog.size(); i++) {
        LogOperation log = (LogOperation) vLog.get(i);
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="fontarial" valign="top" style=padding:3px;><%=JSPFormater.formatDate(log.getDate(), "dd MMM yyyy HH:mm:ss")%></td>
                                                                                            <td class="fontarial" valign="top" style=padding:3px;><%=log.getUserName()%></td>                                                                                     
                                                                                            <td class="fontarial" valign="top" style=padding:3px;><%=log.getLogDesc()%></td>
                                                                                        </tr>
                                                                                        <%
                }
            }
                                                                                        %>                                                                                                                                                                               
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td height="30">&nbsp;</td>
                                                                            </tr>
                                                                            <% if (itemMaster.getOID() != 0) {%>
                                                                            <tr> 
                                                                                <td class="fontarial"><i><u>History C.O.G.S</u></i></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td >
                                                                                    <table width="800" >
                                                                                        <tr>
                                                                                            <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i><b></td>                                                                                            
                                                                                            <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>User</i><b></td>
                                                                                            <td width="470" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i><b></td>
                                                                                        </tr>   
                                                                                        <%
     int max = 10;
     if (showAll == 1) {
         max = 0;
     }
     int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_COGS_MASTER + " and " + DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID] + " = " + itemMaster.getOID());
     Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_COGS_MASTER + " and " + DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID] + " = " + itemMaster.getOID(), DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
     if (historys != null && historys.size() > 0) {

         for (int r = 0; r < historys.size(); r++) {
             HistoryUser hu = (HistoryUser) historys.get(r);
             String name = "-";
             if (hu.getUserId() == 0) {
                 name = "System";
             } else {
                 try {
                     User ux = DbUser.fetch(hu.getUserId());
                     name = ux.getFullName();
                 } catch (Exception e) {
                 }
             }
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td class="fontarial"  valign ="top" style=padding:3px;><%=JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss")%></td>                                                                                            
                                                                                            <td class="fontarial" valign="top" style=padding:3px;><%=name%></td>
                                                                                            <td class="fontarial" valign="top" style=padding:3px;><i><%=hu.getDescription()%></i></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            }

                                                                                        } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" class="fontarial" style=padding:3px;><i>No history available</i></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                        </tr>
                                                                                        <%
     if (countx > max) {
         if (showAll == 0) {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdShowAll()"><i>Show All History (<%=countx%>) Data</i></a></td>
                                                                                        </tr>
                                                                                        <%
                                                                                            } else {
                                                                                        %>
                                                                                        <tr>
                                                                                            <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdUnShowAll()"><i>Show By Limit</i></a></td>
                                                                                        </tr>
                                                                                        <%
         }
     }%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                            
                                                            <script language="JavaScript">
                                                                <%if (iJSPCommand == JSPCommand.ADD) {
                if (oidItemCategory == 0) {%> 
                        cmdGetSku();
                        <%}
            }%>
                                                            </script>    
                                                        </form>
                                                        <span class="level2"><br>
                                                        </span><!-- #EndEditable -->
                                                    </td>
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
