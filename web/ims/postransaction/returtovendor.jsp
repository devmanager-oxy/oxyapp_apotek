
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(int iJSPCommand, JspReturItem frmObject, ReturItem objEntity, Vector objectClass, long returItemId, String status, long itemMasterId, long vendorId) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Barcode", "15%");
        jsplist.addHeader("Name", "40%");
        jsplist.addHeader("Qty", "10%");
        jsplist.addHeader("Price", "10%");
        jsplist.addHeader("Total", "20%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;
        String whereCls = "";
        String orderCls = "";

        /* selected ItemGroupId*/
        whereCls = DbItemMaster.colNames[DbItemMaster.COL_FOR_BUY] + "=1";        
        Vector vect_master = DbItemMaster.list(0, 1, whereCls, "");

        Vector vect_value = new Vector(1, 1);
        Vector vect_key = new Vector(1, 1);
        if (vect_master != null && vect_master.size() > 0) {
            for (int i = 0; i < vect_master.size(); i++) {
                ItemMaster ig = (ItemMaster) vect_master.get(i);
                vect_key.add("" + ig.getCode() + " - " + ig.getName());
                vect_value.add("" + ig.getOID());
            }
        }

        //vector untuk ambil data
        Vector temp = new Vector();

        /* selected ItemGroupId*/
        Vector units = DbUom.list(0, 0, "", "");
        Vector uom_value = new Vector(1, 1);
        Vector uom_key = new Vector(1, 1);
        if (units != null && units.size() > 0) {
            for (int i = 0; i < units.size(); i++) {
                Uom uom = (Uom) units.get(i);
                uom_key.add("" + uom.getUnit());
                uom_value.add("" + uom.getOID());
            }
        }

        for (int i = 0; i < objectClass.size(); i++) {
            ReturItem returItem = (ReturItem) objectClass.get(i);
            SessDirectReturL prL = new SessDirectReturL();

            rowx = new Vector();
            if (returItemId == returItem.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");                
                if (itemMasterId != 0) {
                    objEntity.setItemMasterId(itemMasterId);
                }
                ItemMaster colCombo2 = new ItemMaster();

                try {
                    colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());

                } catch (Exception e) {
                    System.out.println(e);
                }

                Vector vItem = new Vector();
                vItem = DbVendorItem.list(0, 0, "vendor_id=" + vendorId + " and item_master_id=" + objEntity.getItemMasterId(), "");
                VendorItem vendorItem = new VendorItem();
                if (vItem.size() > 0) {
                    vendorItem = (VendorItem) vItem.get(0);
                }

                rowx.add("<div align=\"left\">" + "<input type=\"text\" size=\"15\" name=\"jsp_code\" value=\"" + colCombo2.getBarcode() + "\" class=\"formElemen\" style=\"text-align:left\" onClick=\"this.select()\" onChange=\"javascript:cmdAddItemMaster2()\"></div>");
                rowx.add("<input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:left\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + "\" onChange=\"javascript:cmdAddItemMaster()\" size=\"35\" >&nbsp;" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\">Search</a>");
                rowx.add("<div align=\"right\"><input type=\"text\" size=\"17\" name=\"" + frmObject.colNames[frmObject.JSP_QTY] + "\" style=\"text-align:right\" value=\"" + returItem.getQty() + "\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\"></div>");
                rowx.add("<div align=\"right\"><input type=\"text\" size=\"17\" name=\"" + frmObject.colNames[frmObject.JSP_AMOUNT] + "\" style=\"text-align:right\"  value=\"" + vendorItem.getLastPrice() + "\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\" readOnly class=\"readOnly\"></div>");
                rowx.add("<div align=\"right\"><input type=\"text\" size=\"22\" name=\"" + frmObject.colNames[frmObject.JSP_TOTAL_AMOUNT] + "\" style=\"text-align:right\"  value=\"" + returItem.getTotalAmount() + "\" readOnly class=\"readOnly\"></div>" + "</div><input type=\"hidden\" name=\"temp_item_amount\" value=\"" + returItem.getTotalAmount() + "\">");
            } else {
                ItemMaster itemMaster = new ItemMaster();
                try {
                    itemMaster = DbItemMaster.fetchExc(returItem.getItemMasterId());
                } catch (Exception e) {
                }
                Uom uom = new Uom();
                try {
                    uom = DbUom.fetchExc(returItem.getUomId());
                } catch (Exception e) {
                }
                ItemGroup ig = new ItemGroup();
                ItemCategory ic = new ItemCategory();
                try {
                    ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                    ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                } catch (Exception e) {
                }                		
                if (status.equals(I_Project.DOC_STATUS_DRAFT)) {
                    rowx.add("<div align=\"center\">"+"<a href=\"javascript:cmdEdit('" + String.valueOf(returItem.getOID()) + "')\">" + (i + 1) + "</a>"+ "</div>");
                    prL.setGroup(itemMaster.getName());
                    prL.setBarcode(itemMaster.getBarcode());
                } else {
                    rowx.add("<div align=\"center\">" + (i + 1)+"</div>");
                    prL.setGroup(itemMaster.getName());
                    prL.setBarcode(itemMaster.getBarcode());

                }
                rowx.add("<div align=\"center\">" + itemMaster.getBarcode()+ "</div>");
                rowx.add(itemMaster.getName());
                rowx.add("" + returItem.getQty());                
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(returItem.getAmount(), "#,###.##") + "</div>");
                prL.setPrice(returItem.getAmount());
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(returItem.getTotalAmount(), "#,###.##") + "</div>");
                prL.setQty(returItem.getQty());
                prL.setTotal(returItem.getTotalAmount());                
                prL.setUnit(uom.getUnit());            
            }

            lstData.add(rowx);
            temp.add(prL);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");
            objEntity.setItemMasterId(itemMasterId);
            ItemMaster colCombo2 = new ItemMaster();

            try {
                colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());

            } catch (Exception e) {
                System.out.println(e);
            }

            Vector vItem = new Vector();
            vItem = DbVendorItem.list(0, 0, "vendor_id=" + vendorId + " and item_master_id=" + itemMasterId, "");
            VendorItem vendorItem = new VendorItem();
            if (vItem.size() > 0) {
                vendorItem = (VendorItem) vItem.get(0);
            }
            
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"15\" name=\"jsp_code\" value=\"" + colCombo2.getBarcode() + "\" class=\"formElemen\" style=\"text-align:left\" onClick=\"this.select()\" onChange=\"javascript:cmdAddItemMaster2()\"></div>");
            rowx.add("<input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:left\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + "\" onChange=\"javascript:cmdAddItemMaster()\" size=\"35\" >&nbsp;" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\">Search</a>");

            rowx.add("<div align=\"left\"><input type=\"text\" size=\"8\" name=\"" + frmObject.colNames[frmObject.JSP_QTY] + "\" style=\"text-align:right\" value=\"" + ((objEntity.getQty() == 0) ? 1 : objEntity.getQty()) + "\" onClick=\"this.select()\" onChange=\"javascript:calculateSubTotal()\"></div>");
            rowx.add("<div align=\"right\"><input type=\"text\" size=\"17\" name=\"" + frmObject.colNames[frmObject.JSP_AMOUNT] + "\" style=\"text-align:right\"  value=\"" + vendorItem.getLastPrice() + "\" onClick=\"this.select()\" onChange=\"javascript:calculateSubTotal()\" readOnly class=\"readOnly\"></div>");
            rowx.add("<div align=\"right\"><input type=\"text\" size=\"22\" name=\"" + frmObject.colNames[frmObject.JSP_TOTAL_AMOUNT] + "\" style=\"text-align:right\"  value=\"\" readOnly class=\"readOnly\"></div>");
        }

        lstData.add(rowx);
        
        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);

        return v;
    }
%>
<%
            if (session.getValue("RETUR_TITTLE") != null) {
                session.removeValue("RETUR_TITTLE");
            }

            if (session.getValue("RETUR_DETAIL") != null) {
                session.removeValue("RETUR_DETAIL");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidRetur = JSPRequestValue.requestLong(request, "hidden_retur_id");
            long itemMasterId = JSPRequestValue.requestLong(request, "X_" + JspReturItem.colNames[JspReturItem.JSP_ITEM_MASTER_ID]);
            String srcCode = JSPRequestValue.requestString(request, "jsp_code");
            long vendorId = JSPRequestValue.requestLong(request, "JSP_VENDOR_ID");

            SessDirectRetur pr = new SessDirectRetur();

            Vendor ven = new Vendor();
            if (vendorId != 0){
                try {
                    ven = DbVendor.fetchExc(vendorId);
                    pr.setAddress(ven.getAddress());
                    pr.setVendor(ven.getName());
                } catch (Exception e) {}
            }

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidRetur = 0;
            }
            
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdDirectRetur cmdDirectRetur = new CmdDirectRetur(request);
            JSPLine ctrLine = new JSPLine();
            iErrCode = cmdDirectRetur.action(iJSPCommand, oidRetur);
            JspDirectRetur jspDirectRetur = cmdDirectRetur.getForm();
            Retur retur = cmdDirectRetur.getRetur();
            msgString = cmdDirectRetur.getMessage();

            if(oidRetur == 0){
                oidRetur = retur.getOID();
                retur.setStatus(I_Project.DOC_STATUS_DRAFT);
            }

            if (vendorId != 0) {
                try {
                    ven = DbVendor.fetchExc(vendorId);

                } catch (Exception e) {}
            } else if (vendorId == 0) {
                try {
                    vendorId = retur.getVendorId();
                    ven = DbVendor.fetchExc(vendorId);
                } catch (Exception ex) {}
            }

            long lokFrom = 0;
            if (user.getSegment1Id() != 0) {
                try {
                    SegmentDetail sd = DbSegmentDetail.fetchExc(user.getSegment1Id());
                    lokFrom = sd.getLocationId();
                } catch (Exception ex) {
                }
            }

            pr.setAddress(ven.getAddress());
            pr.setVendor(ven.getName());
%>

<%
            long oidReturItem = JSPRequestValue.requestLong(request, "hidden_retur_item_id");

            CmdReturItem cmdReturItem = new CmdReturItem(request);
            int iErrCode2 = cmdReturItem.action(iJSPCommand, oidReturItem, oidRetur);
            JspReturItem jspReturItem = cmdReturItem.getForm();
            ReturItem returItem = cmdReturItem.getReturItem();
            String msgString2 = cmdReturItem.getMessage();
            Vector locations = userLocations;
            whereClause = DbReturItem.colNames[DbReturItem.COL_RETUR_ID] + "=" + oidRetur;
            orderClause = DbReturItem.colNames[DbReturItem.COL_RETUR_ITEM_ID];
            Vector vReturItem = DbReturItem.list(0, 0, whereClause, orderClause);

            String where = DbItemMaster.colNames[DbItemMaster.COL_FOR_BUY] + "=1";

            Vector itemForBuy = DbItemMaster.list(0, 1, where, DbItemMaster.colNames[DbItemMaster.COL_CODE]);
            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (retur.getVendorId() == 0){
                if (vendors != null && vendors.size() > 0) {
                    Vendor vx = (Vendor) vendors.get(0);
                    if(ven.getOID()==0){
                       
                           ven=vx;
                       
                    }
                    retur.setVendorId(vx.getOID());
                }
            }

            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) {
                iJSPCommand = JSPCommand.ADD;
                oidReturItem = 0;
                srcCode = "";
                itemMasterId = 0;
                returItem = new ReturItem();
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidReturItem = 0;
                returItem = new ReturItem();
            }

            if (retur.getStatus() == null) {
                retur.setStatus(I_Project.DOC_STATUS_DRAFT);
            }
            
            double subTotal = DbReturItem.getTotalReturAmount(oidRetur);
            int vectSize = 0;
            if (iJSPCommand != JSPCommand.SAVE && iJSPCommand != JSPCommand.POST) {
                if (srcCode.length() > 0) {
                    vectSize = DbItemMaster.getCount(" barcode like '%" + srcCode + "%'");
                    if (vectSize == 1) {
                        Vector vlist = DbItemMaster.list(0, 1, " code like '%" + srcCode + "%' || barcode like '%" + srcCode + "%'", "");
                        ItemMaster itemMaster = (ItemMaster) vlist.get(0);
                        itemMasterId = itemMaster.getOID();
                    }
                }
            }
            
             if(retur.getOID() !=0){
                if (retur.getStatus() == null || retur.getStatus().equalsIgnoreCase("")) {
                    retur.setStatus(I_Project.DOC_STATUS_DRAFT);
                }
                if(retur.getTotalAmount()!=subTotal){
                    retur.setTotalAmount(subTotal);
                    
                }
                if(retur.getTotalTax()>0){
                        retur.setIncluceTax(1);
                        retur.setTotalTax((sysCompany.getGovernmentVat()/100) * subTotal);

                    }
                try{
                    DbRetur.updateExc(retur);
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
            function cmdPrintPdf(){                
                window.open("<%=printroot%>.report.RptDirectReturPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                function cmdPrintXls(){                
                window.open("<%=printroot%>.report.RptDirectReturXls?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
                var usrDigitGroup = "<%=sUserDigitGroup%>";
                var usrDecSymbol = "<%=sUserDecimalSymbol%>";
                <%if (!posPReqPriv) {%>
                window.location="<%=approot%>/nopriv.jsp";
                <%}%>
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
                
                function cmdClosedReason(){
                    var st = document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_STATUS]%>.value;
                    if(st=='CLOSED'){
                        document.all.closingreason.style.display="";
                    }
                    else{
                        document.all.closingreason.style.display="none";		
                    }
                }
                
                function cmdToRecord(){
                    document.frmretur.command.value="<%=JSPCommand.NONE%>";
                    document.frmretur.action="returtovendorlist.jsp";
                    document.frmretur.submit();
                }
                
                function cmdVatEdit(){
                    
                    <% if (ven.getIsPKP() == 1){%>
                    document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
                    
                    
                    <%} else {%>
                    
                    document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TAX_PERCENT]%>.value="0.0";				
                    
                    
                    <%}%>
                    calculateAmount();
                }
                
                function cmdChangeItem(){
                    var oid = document.frmretur.<%=jspReturItem.colNames[JspReturItem.JSP_ITEM_MASTER_ID]%>.value;                    
         <%
            if (itemForBuy != null && itemForBuy.size() > 0) {
                for (int i = 0; i < itemForBuy.size(); i++) {
                    ItemMaster im = (ItemMaster) itemForBuy.get(i);
         %>
             if(oid=='<%=im.getOID()%>'){                 
                 
                                 <%
                     try {
                         Uom purUom = DbUom.fetchExc(im.getUomPurchaseId());
                         ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                         ItemCategory ic = DbItemCategory.fetchExc(im.getItemCategoryId());
                                     %>
                                         
                                         document.frmretur.uom.value="<%=purUom.getUnit()%>";	
                                         document.frmretur.group.value="<%=ig.getName()%>";	
                                         document.frmretur.category.value="<%=ic.getName()%>";	
                                         <%
                     } catch (Exception e) {
                         System.out.println(e);
                     }
                                 %>
                                 }	
         <%}
            }%>
        }
        
        function cmdCloseDoc(){
            document.frmretur.action="<%=approot%>/home.jsp";
            document.frmretur.submit();
        }
        
        function cmdAskDoc(){
            document.frmretur.hidden_retur_item_id.value="0";
            document.frmretur.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmretur.prev_command.value="<%=prevJSPCommand%>";
            document.frmretur.action="returtovendor.jsp";
            document.frmretur.submit();
        }
        
        function cmdDeleteDoc(){
            document.frmretur.hidden_retur_item_id.value="0";
            document.frmretur.command.value="<%=JSPCommand.CONFIRM%>";
            document.frmretur.prev_command.value="<%=prevJSPCommand%>";
            document.frmretur.action="returtovendor.jsp";
            document.frmretur.submit();
        }
        
        function cmdCancelDoc(){
            document.frmretur.hidden_retur_item_id.value="0";
            document.frmretur.command.value="<%=JSPCommand.EDIT%>";
            document.frmretur.prev_command.value="<%=prevJSPCommand%>";
            document.frmretur.action="returtovendor.jsp";
            document.frmretur.submit();
        }
        
        function cmdAdd(){
            document.frmretur.hidden_retur_item_id.value="0";
            document.frmretur.command.value="<%=JSPCommand.ADD%>";
            document.frmretur.prev_command.value="<%=prevJSPCommand%>";
            document.frmretur.action="returtovendor.jsp";
            document.frmretur.submit();
        }
        
        function cmdAsk(oidPurchaseRequestItem){            
            document.frmretur.hidden_retur_item_id.value=oidPurchaseRequestItem;
            document.frmretur.command.value="<%=JSPCommand.ASK%>";            
            document.frmretur.prev_command.value="<%=prevJSPCommand%>";
            document.frmretur.action="returtovendor.jsp";
            document.frmretur.submit();            
        }
        
        function cmdAskMain(oidPurchaseRequestItem){
            document.frmretur.hidden_retur_item_id.value=oidPurchaseRequestItem;
            document.frmretur.command.value="<%=JSPCommand.ASK%>";
            document.frmretur.prev_command.value="<%=prevJSPCommand%>";
            document.frmretur.action="returtovendor.jsp";
            document.frmretur.submit();
        }
        
        function calculateSubTotal(){            
            var amount = document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>.value;
            var qty = document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_QTY]%>.value;
            amount = removeChar(amount);
            amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	            
            qty = removeChar(qty);
            qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_QTY]%>.value = qty;
            
            var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) 
            document.frmretur.<%=JspReturItem.colNames[JspReturItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
            
            var subtot = document.frmretur.sub_tot.value;
            subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
         <%
            //add
            if (oidReturItem == 0) {%>
                    document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                    <%} else {%>
                    var tempAmount = document.frmretur.temp_item_amount.value;
                    document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
         <%}
         %>
             
             
             calculateAmount();
         }
         function calculateAmount(){
             var taxPercent = document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TAX_PERCENT]%>.value;
             taxPercent = removeChar(taxPercent);
             taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
             
             var discPercent = document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_DISCOUNT_PERCENT]%>.value;	
             discPercent = removeChar(discPercent);
             discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
             
             var subTotal = document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TOTAL_AMOUNT]%>.value;
             subTotal = removeChar(subTotal);
             subTotal = cleanNumberFloat(subTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
             
             var totalDiscount = 0;
             if(parseFloat(discPercent)>0){
                 totalDiscount = parseFloat(discPercent)/100 * parseFloat(subTotal);
             }
             
             var totalTax = 0;
             
             if(parseInt(taxPercent)==0){
                 document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TAX_PERCENT]%>.value="0.0";		
                 document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TOTAL_TAX]%>.value="0.00";		
                 totalTax = 0;
             }else{
             document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
             totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
             
         }
         
         var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;
         document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TOTAL_TAX]%>.value = totalTax;
         document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_DISCOUNT_TOTAL]%>.value = totalDiscount;
         document.frmretur.grand_total.value = grandTotal
         
         
         document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TOTAL_TAX]%>.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
         document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
         document.frmretur.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	 
         
     }
     
     function cmdConfirmDelete(oidPurchaseRequestItem){
         document.frmretur.hidden_retur_item_id.value=oidPurchaseRequestItem;
         document.frmretur.command.value="<%=JSPCommand.DELETE%>";
         document.frmretur.prev_command.value="<%=prevJSPCommand%>";
         document.frmretur.action="returtovendor.jsp";
         document.frmretur.submit();
     }
     
     function cmdSaveDoc(){
         document.frmretur.command.value="<%=JSPCommand.POST%>";
         document.frmretur.prev_command.value="<%=prevJSPCommand%>";
         document.frmretur.action="returtovendor.jsp";
         document.frmretur.submit();
     }
     
     function cmdSave(){
         document.frmretur.command.value="<%=JSPCommand.SAVE%>";
         document.frmretur.prev_command.value="<%=prevJSPCommand%>";
         document.frmretur.action="returtovendor.jsp";
         document.frmretur.submit();
     }
     
     function cmdSaveMain(){
         document.frmretur.command.value="<%=JSPCommand.SAVE%>";
         document.frmretur.prev_command.value="<%=prevJSPCommand%>";
         document.frmretur.action="returtovendor.jsp";
         document.frmretur.submit();
     }
     
     function cmdEdit(oidPurchaseRequestItem){
         document.frmretur.hidden_retur_item_id.value=oidPurchaseRequestItem;
         document.frmretur.command.value="<%=JSPCommand.EDIT%>";
         document.frmretur.prev_command.value="<%=prevJSPCommand%>";
         document.frmretur.action="returtovendor.jsp";
         document.frmretur.submit();
     }
     
     function cmdCancel(oidPurchaseRequestItem){
         document.frmretur.hidden_retur_item_id.value=oidPurchaseRequestItem;
         document.frmretur.command.value="<%=JSPCommand.CANCEL%>";
         document.frmretur.prev_command.value="<%=prevJSPCommand%>";
         document.frmretur.action="returtovendor.jsp";
         document.frmretur.submit();
     }
     function cmdVendor(){
          <% if (ven.getIsPKP() == 1) {%>
                    document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
                    
                    
                    <%} else {%>
                    
                    document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_TAX_PERCENT]%>.value="0.0";				
                    
                    
                    <%}%>
                    calculateAmount();
         document.frmretur.command.value="<%=JSPCommand.NONE%>";
         document.frmretur.prev_command.value="<%=prevJSPCommand%>";
         document.frmretur.action="returtovendor.jsp";
         document.frmretur.submit();
     } 
     
     function cmdAddItemMaster(){  
         
         var itemName =document.frmretur.X_itm_JSP_ITEM_MASTER_ID.value;
         document.frmretur.jsp_code.value="";
         var vendorId=document.frmretur.JSP_VENDOR_ID.value;
         window.open("<%=approot%>/postransaction/addItemRetur.jsp?item_name=" + itemName + "&oidVendor=" + vendorId, null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
         }
         function cmdAddItemMaster3(){            
             var itemCode =document.frmretur.hidden_item_code.value;
             document.frmretur.jsp_code_item.value=""; 
             var vendorId=document.frmretur.JSP_VENDOR_ID.value;
             window.open("<%=approot%>/postransaction/addItemRetur.jsp?item_code=" + itemCode + "&oidVendor=" + vendorId, null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                 
             }
             
             function cmdAddItemMaster2(){            
                 document.frmretur.X_itm_JSP_ITEM_MASTER_ID.value=0;
                 document.frmretur.submit(); 
             }       
             
             
             function cmdBack(){
                 document.frmretur.command.value="<%=JSPCommand.BACK%>";
                 document.frmretur.action="returtovendor.jsp";
                 document.frmretur.submit();
             }
             
             function cmdListFirst(){
                 document.frmretur.command.value="<%=JSPCommand.FIRST%>";
                 document.frmretur.prev_command.value="<%=JSPCommand.FIRST%>";
                 document.frmretur.action="returtovendor.jsp";
                 document.frmretur.submit();
             }
             
             function cmdListPrev(){
                 document.frmretur.command.value="<%=JSPCommand.PREV%>";
                 document.frmretur.prev_command.value="<%=JSPCommand.PREV%>";
                 document.frmretur.action="returtovendor.jsp";
                 document.frmretur.submit();
             }
             
             function cmdListNext(){
                 document.frmretur.command.value="<%=JSPCommand.NEXT%>";
                 document.frmretur.prev_command.value="<%=JSPCommand.NEXT%>";
                 document.frmretur.action="returtovendor.jsp";
                 document.frmretur.submit();
             }
             
             function cmdListLast(){
                 document.frmretur.command.value="<%=JSPCommand.LAST%>";
                 document.frmretur.prev_command.value="<%=JSPCommand.LAST%>";
                 document.frmretur.action="returtovendor.jsp";
                 document.frmretur.submit();
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
                                                        <form name="frmretur" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspDirectRetur.colNames[JspDirectRetur.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="<%=JspReturItem.colNames[JspReturItem.JSP_RETUR_ID]%>" value="<%=oidRetur%>">
                                                            <input type="hidden" name="hidden_retur_id" value="<%=oidRetur%>">
                                                            <input type="hidden" name="hidden_retur_item_id" value="<%=oidReturItem%>">
                                                            <input type="hidden" name="hidden_item_code" value="<%= srcCode %>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <%try {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top" > 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                                                                        </font><font class="tit1">&raquo; <span class="lvl2">Direct
                                                                                Retur</span></font></b></td>
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
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="5" valign="middle" colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;Direct 
                                                                                                Retur &nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="10%">&nbsp;</td>
                                                                                            <td height="21" valign="middle" width="33%">&nbsp;</td>
                                                                                            <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="45%" class="comment" valign="top"> 
                                                                                                <div align="right">Date : <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                                                                    <%if (retur.getOID() == 0) {%>
                                                                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                                                                    <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(retur.getUserId());
    } catch (Exception e) {
    }
                                                                                                    %>
                                                                                                    Prepared By : <%=us.getLoginId()%> 
                                                                                                    <%}%>
                                                                                                &nbsp;&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="26" valign="middle" width="10%">&nbsp;&nbsp;Location</td>
                                                                                            <td height="26" width="27%">
                                                                                                <%if ((lokFrom == 0 || retur.getUserId() == user.getOID() || retur.getUserId() == 0) && (!retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED))) {%>												
                                                                                                <span class="comment"> 
                                                                                                    <select name="<%=jspDirectRetur.colNames[jspDirectRetur.JSP_LOCATION_ID]%>">
                                                                                                            <%

                                                            if (locations != null && locations.size() > 0) {
                                                                long lokId = 0;
                                                                
                                                                if (lokId == 0) {
                                                                    for (int i = 0; i < locations.size(); i++) {
                                                                        Location d = (Location) locations.get(i);
                                                                        if (retur.getLocationId() == d.getOID()) {
                                                                            pr.setDeliverTo(d.getName());
                                                                        }
                                                                                                                                                                    %>
                                                                                                            
                                                                        <option value="<%=d.getOID()%>" <%if (retur.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                        <%}
                                                                                                                    } else {
                                                                                                                        Location loc = new Location();
                                                                                                                        try {
                                                                                                                            loc = DbLocation.fetchExc(lokId);
                                                                                                                            pr.setDeliverTo(loc.getName());
                                                                                                                        } catch (Exception ec) {

                                                                                                                        }
                                                                                                        %>
                                                                                                        
                                                                                                        <option value="<%=loc.getOID()%>" selected><%=loc.getName()%></option>
                                                                                                        
                                                                                                        <%}%>
                                                                                                        <% }%>
                                                                                                    </select>
                                                                                                </span>
                                                                                                <%} else {

        try {
            Location l = DbLocation.fetchExc(retur.getLocationId());
            out.println(l.getCode() + " - " + l.getName()); 
        %>
            <input type="hidden" name="<%=jspDirectRetur.colNames[jspDirectRetur.JSP_LOCATION_ID]%>" value="<%=retur.getLocationId()%>" >
        <%
            pr.setDeliverTo(l.getName());
        } catch (Exception e) {
        }

    }%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                            </td> 
                                                                                            <td height="26" width="12%">Number</td>
                                                                                            <td height="26" colspan="2" width="45%" class="comment"> 
                                                                                                <%
    String number = "";
    if (retur.getOID() == 0) {
        int ctr = DbRetur.getNextCounter();
        number = DbRetur.getNextNumber(ctr);
        pr.setReturNumber(number);
    } else {
        number = retur.getNumber();
        pr.setReturNumber(number);
    }
                                                                                                %>
                                                                                            <%=number%></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="10%">&nbsp;&nbsp;Date</td>
                                                                                            <td height="21" valign="middle" width="33%"> 
                                                                                                <input name="<%=JspDirectRetur.colNames[JspDirectRetur.JSP_DATE]%>" value="<%=JSPFormater.formatDate((retur.getDate() == null) ? new Date() : retur.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmretur.<%=JspDirectRetur.colNames[JspDirectRetur.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                <%pr.setDate(retur.getDate());%>
                                                                                            </td>
                                                                                            <td width="12%">Document &nbsp;Status</td>
                                                                                            <td width="45%" colspan="2" class="comment">                                                                                                 
                                                                                                <%if (retur.getOID() == 0){%>
                                                                                                <input type="hidden" name="<%=JspDirectRetur.colNames[JspDirectRetur.JSP_STATUS]%>" value="<%=(retur.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((retur.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : retur.getStatus())%>">                                                                                                
                                                                                                <%
                                                                                                }
    if (retur.getStatus() == null) {        
        retur.setStatus(I_Project.DOC_STATUS_DRAFT);
    }
                                                                                                %>
                                                                                                <input type="text" class="readOnly" name="sst" value="<%=(retur.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((retur.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : retur.getStatus())%>" size="15" readOnly>                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="10%">&nbsp;&nbsp;Vendor</td>
                                                                                            <td height="21" colspan="2" width="88%" valign="top"> 
                                                                                                <%
    Vector temp = DbVendor.list(0, 0, "", "name");

                                                                                                %>
                                                                                                <select name="<%=jspDirectRetur.colNames[jspDirectRetur.JSP_VENDOR_ID] %>" onChange="javascript:cmdVendor()" >
                                                                                                    <%if (temp != null && temp.size() > 0) {
        for (int i = 0; i < temp.size(); i++) {
            Vendor v = (Vendor) temp.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == retur.getVendorId()) {%>selected<%}%>><%=v.getName()%></option>
                                                                                                    <%}
    }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="10%">&nbsp;&nbsp;Notes</td>
                                                                                        <td height="21" valign="top" colspan="4"> 
                                                                                            <textarea name="<%=JspDirectRetur.colNames[JspDirectRetur.JSP_NOTE]%>" cols="50" rows="2"><%=retur.getNote()%></textarea>
                                                                                            <%pr.setNotes(retur.getNote());%>
                                                                                        </td>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top" height="5"></td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top"> 
                                                                                                <%try {
        
%>
                                                                                                &nbsp; 
                                                                                                <%
    Vector x = drawList(iJSPCommand, jspReturItem, returItem, vReturItem, oidReturItem, retur.getStatus(), itemMasterId, retur.getVendorId());
    String strList = (String) x.get(0);
    Vector objRpt = (Vector) x.get(1);
                                                                                                %>
                                                                                                <%=strList%> 
                                                                                                <%
    session.putValue("RETUR_DETAIL", objRpt);
                                                                                                %>
                                                                                                <%} catch (Exception ex) {
        out.println("ex d : " + ex.toString());
    }%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%if (iJSPCommand == JSPCommand.ADD && itemMasterId != 0) {%>
                                                                                        <script language="JavaScript">
                                                                                            document.frmretur.itm_JSP_QTY.focus();
                                                                                        </script>
                                                                                        <%}%>
                                                                                        
                                                                                        <%if (iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.ADD && itemMasterId == 0)) {%>
                                                                                        <script language="JavaScript">
                                                                                            document.frmretur.jsp_code.focus();
                                                                                        </script>
                                                                                        <%}%>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if ((!retur.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) && (iJSPCommand == JSPCommand.ADD || ((iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK) && oidReturItem != 0) || iErrCode2 != 0)) {%>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top"> 
                                                                                                <%
    ctrLine = new JSPLine();
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidReturItem + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidReturItem + "')";
    String scancel = "javascript:cmdBack('" + oidReturItem + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("Delete");

    ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverSave("MM_swapImage('save_item','','" + approot + "/images/save2.gif',1)");
    ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save_item\" height=\"22\" border=\"0\">");

    //ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverBack("MM_swapImage('back_item','','" + approot + "/images/cancel2.gif',1)");
    ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back_item\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverDelete("MM_swapImage('delete_item','','" + approot + "/images/delete2.gif',1)");
    ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete_item\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverEdit("MM_swapImage('edit_item','','" + approot + "/images/cancel2.gif',1)");
    ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit_item\" height=\"22\" border=\"0\">");


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

    if (iErrCode2 != 0) {
        iErrCode = iErrCode2;
        if (msgString.length() == 0) {
            msgString = msgString2;
        }
    }
                                                                                                %>
                                                                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <%
    if (retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT) &&
            ((iJSPCommand == JSPCommand.BACK || (iJSPCommand == JSPCommand.EDIT && oidReturItem == 0) ||
            iJSPCommand == JSPCommand.POST || iJSPCommand == JSPCommand.SAVE ||
            iJSPCommand == JSPCommand.DELETE) && (iErrCode2 == 0)) || (iJSPCommand == JSPCommand.CONFIRM && iErrCode2 == 0)) {

                                                                                        %>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top">&nbsp;</td>
                                                                                            <td width="62%"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="62%"> 
                                                                                                            <div align="right"><b>Sub Total</b></div>
                                                                                                        </td>
                                                                                                        <td width="15%"> 
                                                                                                            <input type="hidden" name="sub_tot" value="<%=subTotal%>">
                                                                                                        </td>
                                                                                                        <td width="23%"> 
                                                                                                            <div align="right"> 
                                                                                                                <input type="text" name="<%=jspDirectRetur.colNames[jspDirectRetur.JSP_TOTAL_AMOUNT]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(subTotal, "#,###.##")%>" style="text-align:right">
                                                                                                                <%pr.setSubTotal(subTotal);%>
                                                                                                            </div>                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="62%"> 
                                                                                                            <div align="right"><b>Discount</b></div>
                                                                                                        </td>
                                                                                                        <td width="15%"> 
                                                                                                            <div align="left"> 
                                                                                                                <input name="<%=JspDirectRetur.colNames[JspDirectRetur.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=retur.getDiscountPercent()%>" size="2" style="text-align:center" onBlur="javascript:calculateAmount()" onClick="this.select()">
                                                                                                            % </div>                                                                                                            
                                                                                                        </td>
                                                                                                        <td width="23%"> 
                                                                                                            <div align="right"> 
                                                                                                                <input type="text" name="<%=jspDirectRetur.colNames[jspDirectRetur.JSP_DISCOUNT_TOTAL]%>" value="<%=JSPFormater.formatNumber(retur.getDiscountTotal(), "#,###.##")%>" style="text-align:right" onClick="this.select()" onBlur="javascript:calculateAmount()">
                                                                                                                 <%
                                                                                                                    if(retur.getDiscountTotal()!=0){
                                                                                                                        pr.setDiscount1(1);
                                                                                                                        pr.setDiscount2(retur.getDiscountTotal());
                                                                                                                                
                                                                                                                    }
                                                                                                                 %>
                                                                                                                 
                                                                                                            </div>                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="62%"> 
                                                                                                            <div align="right"><b>VAT</b></div>
                                                                                                        </td>
                                                                                                        <td width="15%"> 
                                                                                                            <div align="left"> 
                                                                                                                <input type="text" name="<%=jspDirectRetur.colNames[jspDirectRetur.JSP_TAX_PERCENT]%>" size="2" class="readonly" readonly value="<%=retur.getTaxPercent()%>" style="text-align:right">
                                                                                                            % </div>
                                                                                                            <%pr.setVat1(retur.getTaxPercent());%>
                                                                                                        </td>
                                                                                                        <td width="23%"> 
                                                                                                            <div align="right"> 
                                                                                                                <input type="text" name="<%=jspDirectRetur.colNames[jspDirectRetur.JSP_TOTAL_TAX]%>" value="<%=JSPFormater.formatNumber(retur.getTotalTax(), "#,###.##")%>" style="text-align:right" onClick="this.select()" >
                                                                                                            </div>
                                                                                                            <%pr.setVat2(retur.getTotalTax());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="62%"> 
                                                                                                            <div align="right"><b>Grand Total</b></div>
                                                                                                        </td>
                                                                                                        <td width="15%">&nbsp;</td>
                                                                                                        <td width="23%"> 
                                                                                                            <div align="right"> 
                                                                                                                <input type="text" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(retur.getTotalAmount() + retur.getTotalTax() - retur.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                                                            </div>
                                                                                                            <%pr.setGrandTotal(retur.getTotalAmount() + retur.getTotalTax() - retur.getDiscountTotal());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="62%">&nbsp;</td>
                                                                                                        <td width="15%">&nbsp;</td>
                                                                                                        <td width="23%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>                                                                                            
                                                                                        </tr>                                                                                        
                                                                                        <%if (retur.getOID() != 0){%>                                                                                        
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="4"> 
                                                                                                            <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr > 
                                                                                                                    <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="12%">&nbsp;</td>
                                                                                                                    <td width="14%">&nbsp;</td>
                                                                                                                    <td width="74%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <%if ((!retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode != 0)) {%>
                                                                                                                <%if(retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>
                                                                                                                <tr> 
                                                                                                                    <td width="12%"><b>Set Status to</b> </td>
                                                                                                                    <td width="14%"> 
                                                                                                                        <select name="<%=JspDirectRetur.colNames[JspDirectRetur.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                                                                                            <%if (retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT) || retur.getStatus().length() == 0) {%>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                            <%}%>
                                                                                                                            <%if (posApprove1Priv) {%>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                            <%}%>                                                                                                                            
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="74%">&nbsp; </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="12%">&nbsp;</td>
                                                                                                                    <td width="14%">&nbsp;</td>
                                                                                                                    <td width="74%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                            </table>
                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (iJSPCommand == JSPCommand.SUBMIT){%>
                                                                                                    <tr> 
                                                                                                        <td colspan="3">Are you sure to delete document ?</td>
                                                                                                        <td width="862">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="149"><a href="javascript:cmdDeleteDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('yes21111','','../images/yes2.gif',1)"><img src="../images/yes.gif" name="yes21111" height="21" border="0"></a></td>
                                                                                                        <td width="102"><a href="javascript:cmdCancelDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel211111','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel211111" height="22" border="0"></a></td>
                                                                                                        <td width="97">&nbsp;</td>
                                                                                                        <td width="862">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" class="errfont"><%=msgString%></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <%if (!retur.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode != 0) {%>                                                                                                        
                                                                                                        <%if(retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT)){%>
                                                                                                        <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                                                                        <td width="102" > 
                                                                                                            <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                                                                        </td>
                                                                                                        <%}%>
                                                                                                        <%}%>
                                                                                                        <td width="97"> 
                                                                                                            <div align="left"><a href="javascript:cmdPrintPdf()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                                        </td>
                                                                                                        <td width="97"> 
                                                                                                            <div align="left"><a href="javascript:cmdPrintXls()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                                        </td>
                                                                                                        <td width="862"> 
                                                                                                            <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top"> 
                                                                                                <table width="80%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr > 
                                                                                                        <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="12%">&nbsp;</td>
                                                                                                        <td width="14%">&nbsp;</td>
                                                                                                        <td width="74%">&nbsp;</td>
                                                                                                    </tr>                                                                                                  
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%if (retur.getOID() != 0) {%>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top"> 
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
                                                                                                        <td width="33%" class="tablecell1">Prepared 
                                                                                                        By</td>
                                                                                                        <td width="34%" class="tablecell1"> 
                                                                                                            <div align="center"> 
                                                                                                                <%
    User u = new User();
    try {
        u = DbUser.fetch(retur.getUserId());
    } catch (Exception e) {
    }
                                                                                                                %>
                                                                                                            <%=u.getLoginId()%></div>
                                                                                                        </td>
                                                                                                        <td width="33%" class="tablecell1"> 
                                                                                                            <div align="center"><%=JSPFormater.formatDate(retur.getDate(), "dd MMMM yy")%></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="33%" class="tablecell1">Approved by</td>
                                                                                                        <td width="34%" class="tablecell1"> 
                                                                                                            <div align="center"> 
                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(retur.getApproval1());
    } catch (Exception e) {
    }
                                                                                                                %>
                                                                                                            <%=u.getLoginId()%></div>
                                                                                                        </td>
                                                                                                        <td width="33%" class="tablecell1"> 
                                                                                                            <div align="center"> 
                                                                                                                <%if (retur.getApproval1() != 0) {%>
                                                                                                                <%=JSPFormater.formatDate(retur.getApproval1Date(), "dd MMMM yy")%> 
                                                                                                                <%}%>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                   
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="5" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>                                                                            
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                <%if (retur.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && returItem.getOID() != 0) || iErrCode != 0)) {%>                                                                
                                                                cmdChangeItem();																		
                                                         <%}
    if (retur.getOID() != 0 && !retur.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {%>
            cmdClosedReason();
            <%}%>
                                                            </script>
                                                            
                                                            <%} catch (Exception e) {
                out.println(e.toString());
            }%>
                                                            
                                                            <%
            //session laporan
            session.putValue("RETUR_TITTLE", pr);
                                                            %>
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
                        <%if (vectSize > 1) {%>
                        <script language="JavaScript">
                            cmdAddItemMaster3();
                        </script>
                        <%}%>
                        <%if(retur.getOID()==0){%>
                        <script language="JavaScript">
                            
                            cmdVatEdit();
                            calculateSubTotal();
                        </script>
                        <%}else{%>
                        <script language="JavaScript">
                            calculateSubTotal();
                        </script>
                        <%}%>
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
