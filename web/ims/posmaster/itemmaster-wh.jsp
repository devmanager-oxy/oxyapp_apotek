
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
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            long oidItemCategory = JSPRequestValue.requestLong(request, "JSP_ITEM_CATEGORY_ID");
            long oidItemClass = JSPRequestValue.requestLong(request, JspItemMaster.colNames[JspItemMaster.JSP_ITEM_CLASS_ID]);
            
            int showAll = JSPRequestValue.requestInt(request, "show_all");

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
            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setItemCategoryId(oidItemCategory);
				itemMaster.setItemClassId(oidItemClass); 				
                itemMaster.setCode(DbItemMaster.getNextCode(oidItemCategory));
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

            Vector categories = DbItemCategory.list(0, 0, "group_type<>" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS + " and group_type<>" + I_Ccs.TYPE_CATEGORY_CIVIL_WORK, DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID] + "," + DbItemCategory.colNames[DbItemCategory.COL_NAME]);
            Vector units = DbUom.list(0, 0, "", DbUom.colNames[DbUom.COL_UNIT]);

            if (iJSPCommand == JSPCommand.ADD) {  
                itemMaster.setForSale(1); 
                itemMaster.setForBuy(1); 
                itemMaster.setIsActive(1);
                itemMaster.setRecipeItem(0);  
            }
            
            //out.println(jspItemMaster.getErrors());
            
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
            
            function cmdUnShowAll(){
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.show_all.value=0;
                document.frmitemmaster.action="itemmaster.jsp";
                document.frmitemmaster.submit();
            }
			
			function cmdGetShortName(obj){  
				var str = obj.value;
				str = removeCharX(str);
				document.frmitemmaster.<%=JspItemMaster.colNames[JspItemMaster.JSP_NAME]%>.value=str;
				if(str.length>25){
					str = str.substring(0,25);
				}				
				document.frmitemmaster.<%=JspItemMaster.colNames[JspItemMaster.JSP_SHORT_NAME]%>.value=str;
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
            
            function removeCharX(str){                
                var ix;
                var result = "";
                for(ix=0; ix<str.length; ix++){
                    var xx = str.charAt(ix);                    
                    if(xx!='>' && xx!='<' && xx!=','){
                        result = result + xx;
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
			
			function cmdToBarcode(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itembarcode.jsp";
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
															<input type="hidden" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_ITEM_MASTER_ID]%>" value="<%=oidItemMaster%>">
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
                                            <span class="lvl2">Item Masterdata 
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
                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecords()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tab" nowrap> 
                                            <div align="center">&nbsp;&nbsp;Item 
                                              Data</div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <%if (itemMaster.getOID() != 0) {%>
                                          <td class="tabin" nowrap> 
                                            <div align="center"> &nbsp;&nbsp;<a href="javascript:cmdToBarcode()" class="tablink">Barcodes</a>&nbsp;&nbsp; 
                                            </div>
                                          </td>
                                          <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                          <td class="tabin" nowrap> 
                                            <div align="center"> &nbsp;&nbsp;<a href="javascript:cmdToPrice()" class="tablink">Price 
                                              List</a>&nbsp;&nbsp; </div>
                                          </td>
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
                                          <td class="tabin" nowrap> 
                                            <div align="center"> &nbsp;&nbsp;<a href="javascript:cmdVendorItem()" class="tablink">Vendor 
                                              Item</a>&nbsp;&nbsp; </div>
                                          </td>
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
                                          <td height="21" valign="middle" width="9%">&nbsp;</td>
                                          <td height="21" valign="middle" width="18%">*)= 
                                            required</td>
                                          <td height="21" valign="middle" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="63%" class="comment" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" colspan="2">&nbsp;&nbsp;<u><b>Detail 
                                            Data</b></u> </td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="63%">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Group</td>
                                          <td height="21" width="18%"> 
                                            <select name="<%=jspItemMaster.colNames[JspItemMaster.JSP_TYPE_ITEM]%>" >
                                              <option value="<%=DbItemMaster.TYPE_ITEM_BELI_PUTUS%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_BELI_PUTUS) {%>selected<%}%> >Retail/Regular</option>
                                              <option value="<%=DbItemMaster.TYPE_ITEM_KONSINYASI%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_KONSINYASI) {%>selected<%}%> >Consignment</option>
                                              <option value="<%=DbItemMaster.TYPE_ITEM_KOMISI%>" <%if (itemMaster.getTypeItem() == DbItemMaster.TYPE_ITEM_KOMISI) {%>selected<%}%> >Commission</option>
                                            </select>
                                          </td>
                                          <td height="21" width="10%" nowrap> 
                                            <div align="right">Category/Sub. Cat/Class&nbsp;&nbsp;</div>
                                          </td>
                                          <td height="21" colspan="2" width="63%" nowrap> 
                                            <% 
											Vector itemclassid_value = new Vector(1, 1);
											Vector itemclassid_key = new Vector(1, 1);
											String sel_itemclassid = "" + itemMaster.getItemClassId();
											//itemclassidkey.add("0");
											//itemclassid_value.add("Select ..");
											
											Vector iclass = DbItemClass.list(0,0, "", "item_group_id, item_category_id, name");
													
											if (iclass != null && iclass.size() > 0) {
												for (int i = 0; i < iclass.size(); i++) {
													ItemClass ic = (ItemClass) iclass.get(i);
								
													ItemGroup ig = new ItemGroup();
													try {
														ig = DbItemGroup.fetchExc(ic.getItemGroupId());
													} catch (Exception e) {
													}
													
													ItemCategory ict = new ItemCategory();
													try {
														ict = DbItemCategory.fetchExc(ic.getItemCategoryId());
													} catch (Exception e) {
													}
								
													itemclassid_key.add("" + ic.getOID());
													itemclassid_value.add("" + ig.getName() + " / " + ict.getName()+" / "+ic.getName());
													
													if (itemMaster.getItemClassId() == 0) {
														itemMaster.setItemClassId(ic.getOID());
														itemMaster.setItemGroupId(ic.getItemGroupId());
													}
													else if(ic.getOID()==oidItemClass){
														itemMaster.setItemGroupId(ic.getItemGroupId());
													}
												}
											}
											
											//---- cat & sub cat only
											/*Vector itemcategoryid_value = new Vector(1, 1);
											Vector itemcategoryid_key = new Vector(1, 1);
											String sel_itemcategoryid = "" + itemMaster.getItemCategoryId();
											itemcategoryid_key.add("0");
											itemcategoryid_value.add("Select ..");
													
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
											}*/
                                                                                                %>
                                            <%= JSPCombo.draw(jspItemMaster.colNames[JspItemMaster.JSP_ITEM_CLASS_ID], null, sel_itemclassid, itemclassid_key, itemclassid_value, "onchange=\"javascript:cmdGetSku()\"", "formElemen") %> * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_ITEM_CLASS_ID) %> </td>
                                        </tr>
                                        <%
            if (iJSPCommand == JSPCommand.ADD) {
                //if (oidItemClass == 0) {
                    itemMaster.setCode(DbItemMaster.getNextCode(itemMaster.getItemGroupId()));
                //}
				//else{
				//	itemMaster.setCode(DbItemMaster.getNextCode(itemMaster.getItemGroupId()));
				//}
            }

                                                                                        %>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;SKU/Code</td>
                                          <td height="21" width="18%" nowrap> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_CODE] %>"  value="<%= itemMaster.getCode() %>" class="formElemen" size="20">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_CODE) %> </td>
                                          <td height="21" width="10%"> 
                                            <div align="right"> Name&nbsp;&nbsp;</div>
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NAME] %>"  value="<%= itemMaster.getName() %>" class="formElemen" size="40" onChange="javascript:cmdGetShortName(this)">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_NAME) %></td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Merk/Brand</td>
                                          <td height="21" width="18%"> 
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
                                            <div align="right">Short Name&nbsp;&nbsp;</div>
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_SHORT_NAME] %>"  value="<%= (itemMaster.getShortName()==null) ? "" : itemMaster.getShortName() %>" class="formElemen" size="40"  onChange="javascript:cmdGetShortName(this)" maxlength="25">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_SHORT_NAME) %> </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Trans. 
                                            Status </td>
                                          <td height="21" width="18%"> 
                                            <select name="<%=jspItemMaster.colNames[JspItemMaster.JSP_TRANS_STATUS] %>">
                                              <%
											  for(int i=0; i<DbItemMaster.strTranStatus.length; i++){%>
                                              <option value="<%=i%>" <%if(i==itemMaster.getTransactionStatus()){%>selected<%}%>><%=DbItemMaster.strTranStatus[i]%></option>
                                              <%}%>
                                            </select>
                                          </td>
                                          <td height="21" width="10%"> 
                                            <div align="right">Active Date&nbsp;&nbsp;</div>
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input name="<%=jspItemMaster.colNames[jspItemMaster.JSP_ACTIVE_DATE]%>" value="<%=JSPFormater.formatDate((itemMaster.getActive_date() == null) ? new Date() : itemMaster.getActive_date(), "dd/MM/yyyy")%>" size="11" readonly>
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmitemmaster.<%=jspItemMaster.colNames[jspItemMaster.JSP_ACTIVE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                          </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Unit 
                                            Stock</td>
                                          <td height="21" width="18%"> 
                                            <% Vector uomstockid_value = new Vector(1, 1);
            Vector uomstockid_key = new Vector(1, 1);
            String sel_uomstockid = "" + itemMaster.getUomStockId();

            uomstockid_key.add("0");
            uomstockid_value.add("");

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
                                            <div align="right">&nbsp;&nbsp;Default 
                                              Vendor&nbsp;&nbsp;</div>
                                          </td>
                                          <td height="21" colspan="2" width="63%" nowrap> 
                                            <%
            Vector listVnd = DbVendor.list(0, 0, "", "name");
                                                                                                %>
                                            <select name="<%=jspItemMaster.colNames[JspItemMaster.JSP_DEFAULT_VENDOR_ID] %>">
                                              <option value="0"></option>
                                              <%if (listVnd != null && listVnd.size() > 0) {
                for (int i = 0; i < listVnd.size(); i++) {
                    Vendor v = (Vendor) listVnd.get(i);
                                                                                                    %>
                                              <option value="<%=v.getOID()%>" <%if (v.getOID() == itemMaster.getDefaultVendorId()) {%>selected<%}%>><%=v.getCode() + "-" + v.getName()%></option>
                                              <%}
            }%>
                                            </select>
                                            <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_DEFAULT_VENDOR_ID) %> </td>
                                        </tr>
                                        <%if(!SYSTEM_INVENTORY_METHOD.equals("FIFO")){%>
                                        <tr align="left"> 
                                          <td height="21" width="9%" valign="top">&nbsp;&nbsp;COGS/Unit 
                                            Cost&nbsp;&nbsp;</td>
                                          <td height="21" width="18%" valign="top"> 
                                            <% 
											Vector costcenters = DbLocation.list(0,0, "type like 'Cost Center%'", "type");
											if (itemMaster.getOID() != 0) {%>
                                            <table border="0" cellpadding="0" cellspacing="1" width="240">
                                              <tr bgcolor="#CCCCCC"> 
                                                <td width="124" height="19"> 
                                                  <div align="center"><font size="1"><i>COGS</i></font></div>
                                                </td>
                                                <td class="fontarial" width="116" height="19"> 
                                                  <div align="center"><font size="1"><i>Cost 
                                                    Center</i></font></div>
                                                </td>
                                              </tr>
                                              <%if(costcenters!=null && costcenters.size()>0){
											  for(int x=0; x<costcenters.size(); x++){
											  		Location loc = (Location)costcenters.get(x);
											  %>
                                              <tr bgcolor="#CCCCCC"> 
                                                <td width="124"> 
                                                  <%if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_1)){%>
                                                  <input type="text" name="xcogs"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_2)){%>
                                                  <input type="text" name="xcogs2"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs2(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_3)){%>
                                                  <input type="text" name="xcogs3"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs3(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_4)){%>
                                                  <input type="text" name="xcogs4"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs4(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_5)){%>
                                                  <input type="text" name="xcogs5"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs5(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_6)){%>
                                                  <input type="text" name="xcogs6"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs6(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_7)){%>
                                                  <input type="text" name="xcogs7"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs7(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_8)){%>
                                                  <input type="text" name="xcogs8"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs8(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_9)){%>
                                                  <input type="text" name="xcogs9"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs9(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_10)){%>
                                                  <input type="text" name="xcogs10"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs10(), "#,###.##") %>" class="readOnly" size="20" readonly style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}%>
                                                </td>
                                                <td class="fontarial" width="116">&nbsp;<i><%=loc.getName()%></i></td>
                                              </tr>
                                              <%}}%>
                                            </table>
                                            <%}else{%>
                                            <table border="0" cellpadding="0" cellspacing="1" width="240">
                                              <tr bgcolor="#CCCCCC"> 
                                                <td width="124" height="19"> 
                                                  <div align="center"><i>COGS</i></div>
                                                </td>
                                                <td class="fontarial" width="116" height="19"> 
                                                  <div align="center"><i>Cost 
                                                    Center</i></div>
                                                </td>
                                              </tr>
                                              <%if(costcenters!=null && costcenters.size()>0){
											  for(int x=0; x<costcenters.size(); x++){
											  		Location loc = (Location)costcenters.get(x);
											  %>
                                              <tr bgcolor="#CCCCCC"> 
                                                <td width="124"> 
                                                  <%if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_1)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") %>" style="text-align:right" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_2)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS2] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs2(), "#,###.##") %>" style="text-align:right" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_3)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS3] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs3(), "#,###.##") %>" style="text-align:right" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_4)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS4] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs4(), "#,###.##") %>" style="text-align:right" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_5)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS5] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs5(), "#,###.##") %>" style="text-align:right" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_6)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS6] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs6(), "#,###.##") %>" style="text-align:right" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_7)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS7] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs7(), "#,###.##") %>" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_8)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS8] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs8(), "#,###.##") %>" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_9)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS9] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs9(), "#,###.##") %>" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}else if(loc.getType().equals(DbLocation.TYPE_COST_CENTER_10)){%>
                                                  <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_COGS10] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getCogs10(), "#,###.##") %>" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                                  <%}%>
                                                </td>
                                                <td class="fontarial" width="116">&nbsp;<i><%=loc.getName()%></i></td>
                                              </tr>
                                              <%}}%>
                                            </table>
                                            <%}%>
                                          </td>
                                          <td height="21" width="10%" valign="top"> 
                                            <div align="right"></div>
                                          </td>
                                          <td colspan="2" class="comment" width="63%">&nbsp; 
                                          </td>
                                        </tr>
                                        <%}//end not FIFO%>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;</td>
                                          <td height="21" width="18%">&nbsp;</td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="63%">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" colspan="2">&nbsp;&nbsp;<b><u>Sales 
                                            and Purchase Parameter</u><u></u><i><u><br>
                                            <br>
                                            </u></i></b></td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="63%">&nbsp;</td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="242" colspan="5"> 
                                            <table width="700" border="0" cellspacing="0" cellpadding="0" height="246">
                                              <tr> 
                                                <td width="104">&nbsp;&nbsp;Active 
                                                  Item</td>
                                                <td width="90" > 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_ACTIVE] %>"  value="1" <%if (itemMaster.getIsActive() == 1) {%>checked<%}%> class="formElemen" disabled="true">
                                                </td>
                                                <td width="6">&nbsp;</td>
                                                <td width="76" align="left" nowrap>Sales 
                                                  Item </td>
                                                <td width="76" > 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_SALE] %>"  value="1" <%if (itemMaster.getForSale() == 1) {%>checked<%}%> disabled="true">
                                                </td>
                                                <td width="90" >Purchase Item</td>
                                                <td  width="69" > 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_FOR_BUY] %>"  value="1" <%if (itemMaster.getForBuy() == 1) {%>checked<%}%> class="formElemen" disabled="true">
                                                </td>
                                                <td width="93" >Recipe Item</td>
                                                <td width="96" >
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="1" <%if(itemMaster.getNeedRecipe()==1){%>checked<%}%>>
                                                </td>
                                              </tr>
                                              <tr> 
                                                <td colspan="9">&nbsp;</td>
                                              </tr>
                                              <tr> 
                                                <td width="104" >&nbsp;&nbsp;Include 
                                                  In BOM</td>
                                                <td width="90" > 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_RECIPE_ITEM] %>"  value="1" <%if (itemMaster.getRecipeItem() == 1) {%>checked<%}%> class="formElemen" >
                                                </td>
                                                <td width="6" >&nbsp;&nbsp;</td>
                                                <td width="76">Is a Service</td>
                                                <td width="76"> 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_SERVICE] %>"  value="<%=DbItemMaster.SERVICE%>" <%if (itemMaster.getIs_service() == DbItemMaster.SERVICE) {%>checked<%}%> class="formElemen">
                                                </td>
                                                <td width="90">Is BKP</td>
                                                <td width="69"> 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_BKP] %>"  value="<%=DbItemMaster.BKP%>" <%if (itemMaster.getIs_bkp() == DbItemMaster.BKP) {%>checked<%}%> class="formElemen">
                                                </td>
                                                <td width="93" >Use Expired Date</td>
                                                <td width="96" > 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_USE_EXPIRED_DATE] %>"  value="1" <%if (itemMaster.getUseExpiredDate() == 1) {%>checked<%}%> class="formElemen">
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
                                                        <table width="400" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td colspan="6" height="4"></td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="6" height="22">&nbsp;<B><u>Stock 
                                                              Type </u></B></td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="6"> 
                                                              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr valign="middle"> 
                                                                  <td width="24" height="27"> 
                                                                    <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="1" <%if (itemMaster.getNeedRecipe() == 1) {%>checked<%}%>>
                                                                  </td>
                                                                  <td width="126" nowrap height="27">Non 
                                                                    Stockable</td>
                                                                  <td width="23" height="27"> 
                                                                    <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_NEED_RECIPE]%>" value="0" <%if (itemMaster.getNeedRecipe() == 0) {%>checked<%}%>>
                                                                  </td>
                                                                  <td width="110" height="27">Stockable</td>
                                                                  <td width="117" height="27">&nbsp;</td>
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
                                                  <table width="516" border="0" cellspacing="1" cellpadding="1">
                                                    <tr> 
                                                      <td > 
                                                        <table width="451" border="0" cellspacing="0" cellpadding="0">
                                                          <tr> 
                                                            <td colspan="6" height="4"></td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="6" height="22">&nbsp;<B><u>Stock 
                                                              Code/Serial Number</u></B></td>
                                                          </tr>
                                                          <tr> 
                                                            <td colspan="6" height="4"></td>
                                                          </tr>
                                                          <tr valign="middle"> 
                                                            <td width="30" height="25"> 
                                                              <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.APPLY_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE) {%>checked<%}%>>
                                                            </td>
                                                            <td height="25" >Apply 
                                                              Stock Code</td>
                                                            <td width="15" height="25"> 
                                                              <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.OPTIONAL_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE) {%>checked<%}%>>
                                                            </td>
                                                            <td height="25" >Optional 
                                                              Stock Code</td>
                                                            <td width="15" height="25"> 
                                                              <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE]%>" value="<%=DbItemMaster.NON_APPLY_STOCK_CODE%>" <%if (itemMaster.getApplyStockCode() == DbItemMaster.NON_APPLY_STOCK_CODE) {%>checked<%}%>>
                                                            </td>
                                                            <td height="25" >Non 
                                                              Stock Code</td>
                                                          </tr>
                                                          <tr valign="middle"> 
                                                            <td colspan="6" height="4"></td>
                                                          </tr>
                                                          <tr valign="middle"> 
                                                            <td height="27"> 
                                                              <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE_SALES]%>" value="<%=DbItemMaster.APPLY_STOCK_CODE_SALES%>" <%if (itemMaster.getApplyStockCodeSales() == DbItemMaster.APPLY_STOCK_CODE_SALES) {%>checked<%}%>>
                                                            </td>
                                                            <td height="27">Apply 
                                                              Stock Code Sales</td>
                                                            <td height="27"> 
                                                              <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE_SALES]%>" value="<%=DbItemMaster.OPTIONAL_STOCK_CODE_SALES%>" <%if (itemMaster.getApplyStockCodeSales() == DbItemMaster.OPTIONAL_STOCK_CODE_SALES) {%>checked<%}%>>
                                                            </td>
                                                            <td height="27" nowrap>Optional 
                                                              Stock Code Sales</td>
                                                            <td height="27"> 
                                                              <input type="radio" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_APPLY_STOCK_CODE_SALES]%>" value="<%=DbItemMaster.NON_APPLY_STOCK_CODE_SALES%>" <%if (itemMaster.getApplyStockCodeSales() == DbItemMaster.NON_APPLY_STOCK_CODE_SALES) {%>checked<%}%>>
                                                            </td>
                                                            <td height="27" nowrap>Non 
                                                              Stock Code Sales</td>
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
                                          <td height="21" colspan="5"> 
                                            <p><b>&nbsp;&nbsp;<u></u><u>Autoreplenishment</u></b><br>
                                              &nbsp; </p>
                                          </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp; Auto 
                                            Order</td>
                                          <td width="18%" valign="middle" > 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                              <tr> 
                                                <td width="8%"> 
                                                  <input type="checkbox" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_IS_AUTO_ORDER] %>"  value="1" <%if (itemMaster.getIsAutoOrder() == 1) {%>checked<%}%>>
                                                </td>
                                                <td width="92%">Activated</td>
                                              </tr>
                                            </table>
                                          </td>
                                          <td height="21" width="10%"> 
                                            <div align="right">&nbsp;&nbsp;Delivery 
                                              Unit&nbsp; </div>
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_DELIVERY_UNIT] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getDeliveryUnit(), "#,###.##") %>" class="formElemen" size="20" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()"><%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_DELIVERY_UNIT) %>
                                          </td>
                                        </tr>
                                        <!--tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Minimum 
                                            Stock&nbsp; </td>
                                          <td height="21" width="18%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_MIN_STOCK] %>"  value="<%= JSPFormater.formatNumber(itemMaster.getMinStock(), "#,###.##") %>" class="formElemen" size="20" style="text-align:right" onBlur="javascript:checkNumber1()" onClick="this.select()">
                                            ?? </td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="63%">&nbsp;</td>
                                        </tr-->
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Location 
                                            Order &nbsp; </td>
                                          <td width="18%"> 
                                            <select name="<%=JspItemMaster.colNames[JspItemMaster.JSP_LOCATION_ORDER]%>">
                                              <option value="0" <%if (itemMaster.getLocationOrder() ==0) {%>selected<%}%>>ALL</option>
                                              <%
            Vector locations = DbLocation.list(0, 0, "type='Store' or type='warehouse'", "name");
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
                                          <td height="21" colspan="2" width="63%">&nbsp;</td>
                                        </tr>
                                        <!--tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Unit 
                                            Purchase</td>
                                          <td height="21" width="18%"> 
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
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY] %>"  value="<%= itemMaster.getUomPurchaseStockQty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_PURCHASE_STOCK_QTY) %> Unit Stock</td>
                                        </tr-->
                                        <!--tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Unit 
                                            Recipe</td>
                                          <td height="21" width="18%"> 
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
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY] %>"  value="<%= itemMaster.getUomStockRecipeQty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_RECIPE_QTY) %> Unit Recipe </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Unit 
                                            Sales 1</td>
                                          <td height="21" width="18%"> 
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
                                          <td height="21" width="10%"> 
                                            <div align="right">1 Unit Stock = 
                                              &nbsp;&nbsp; </div>
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES1_QTY] %>"  value="<%= itemMaster.getUomStockSales1Qty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES1_QTY) %> Unit Sales </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Unit 
                                            Sales 2</td>
                                          <td height="21" width="18%"> 
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
                                          <td height="21" width="10%"> 
                                            <div align="right">1 Unit Stock = 
                                              &nbsp;&nbsp; </div>
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES2_QTY] %>"  value="<%= itemMaster.getUomStockSales2Qty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES2_QTY) %> Unit Sales </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Unit 
                                            Sales 3</td>
                                          <td height="21" width="18%"> 
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
                                          <td height="21" width="10%"> 
                                            <div align="right">1 Unit Stock = 
                                              &nbsp;&nbsp; </div>
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES3_QTY] %>"  value="<%= itemMaster.getUomStockSales3Qty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES3_QTY) %> Unit Sales </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Unit 
                                            Sales 4</td>
                                          <td height="21" width="18%"> 
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
                                          <td height="21" width="10%"> 
                                            <div align="right">1 Unit Stock = 
                                              &nbsp;&nbsp; </div>
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES4_QTY] %>"  value="<%= itemMaster.getUomStockSales4Qty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES4_QTY) %> Unit Sales </td>
                                        </tr>
                                        <tr align="left"> 
                                          <td height="21" width="9%">&nbsp;&nbsp;Unit 
                                            Sales 5</td>
                                          <td height="21" width="18%"> 
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
                                          <td height="21" width="10%"> 
                                            <div align="right">1 Unit Stock = 
                                              &nbsp;&nbsp; </div> 
                                          </td>
                                          <td height="21" colspan="2" width="63%"> 
                                            <input type="text" name="<%=jspItemMaster.colNames[JspItemMaster.JSP_UOM_STOCK_SALES5_QTY] %>"  value="<%= itemMaster.getUomStockSales5Qty() %>" class="formElemen" size="5" style="text-align:right">
                                            * <%= jspItemMaster.getErrorMsg(JspItemMaster.JSP_UOM_STOCK_SALES5_QTY) %> Unit Sales </td>
                                        </tr-->
                                        <tr align="left">  
                                          <td height="21" width="9%">&nbsp;</td>
                                          <td height="21" width="18%">&nbsp;</td>
                                          <td height="21" width="10%">&nbsp;</td>
                                          <td height="21" colspan="2" width="63%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                          <td colspan="5" class="command" valign="top"> 
                                            <%
            jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
            jspLine.setTableWidth("100%");
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
                                            <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> <a name="goerror"></a></td>
                                        </tr>
                                        <tr> 
                                          <td width="9%">&nbsp;</td>
                                          <td width="18%">&nbsp;</td>
                                          <td width="10%">&nbsp;</td>
                                          <td width="63%">&nbsp;</td>
                                        </tr>
                                      </table>
                                    </td>
                                  </tr>
                                  <tr align="left" valign="top"> 
                                    <td height="8" valign="middle" colspan="3"> 
                                      <table width="100%" >
                                        <%if (vLog.size() > 0) {%>
                                        <tr> 
                                          <td class="fontarial" colspan="3"><i><u>History 
                                            Item</u></i></td>
                                        </tr>
                                        <tr height="22"> 
                                          <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i></b></td>
                                          <td width="200" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>User</i></b></td>
                                          <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i></b></td>
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
                                      <table width="100%" >
                                        <tr> 
                                          <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i></b></td>
                                          <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>User</i></b></td>
                                          <td width="470" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i></b></td>
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
             }else{
                 try{
                    User ux = DbUser.fetch(hu.getUserId());
                    name = ux.getFullName();
                 }catch(Exception e){}        
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
                                          <td colspan="3" class="fontarial" style=padding:3px;><i>No 
                                            history available</i></td>
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
                                          <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdShowAll()"><i>Show 
                                            All History (<%=countx%>) Data</i></a></td>
                                        </tr>
                                        <%
                                                                                            } else {
                                                                                        %>
                                        <tr> 
                                          <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdUnShowAll()"><i>Show 
                                            By Limit</i></a></td>
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
                                                        </form>
                                                        <span class="level2"><br>														
                                                        </span>
														<script language="JavaScript">
														<%if(iErrCode!=0){%>
															window.location.href = '#goerror';
														<%}%>
														</script>
														<!-- #EndEditable -->
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
