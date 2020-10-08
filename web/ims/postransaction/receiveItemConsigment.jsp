
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.*" %>
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
    public Vector drawList(int iJSPCommand, JspReceiveItem frmObject,
            ReceiveItem objEntity, Vector objectClass,
            long receiveItemId, String approot, long oidVendor,
            int iErrCode2, String status, boolean isView, Vector vErr, boolean useStockCode, double qty, Vector vStockCode, boolean isSave, Receive receive, boolean isRefresh, int optStockCode, int use_expired_date, long itemMasterId) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "2%");
        jsplist.addHeader("Group - Name", "32%");
        jsplist.addHeader("Price", "10%");
        jsplist.addHeader("Qty", "5%");
        jsplist.addHeader("Discount", "10%");
        jsplist.addHeader("Total", "10%");
        jsplist.addHeader("Unit Purchase", "10%");
        jsplist.addHeader("Unit Stock", "10%");
        jsplist.addHeader("Expired Date", "11%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;
        String whereCls = "";
        String orderCls = "";

        whereCls = DbItemMaster.colNames[DbItemMaster.COL_FOR_BUY] + "=1";

        Vector vectVendMaster = DbItemMaster.list(0, 1, whereCls, DbItemMaster.colNames[DbItemMaster.COL_CODE]);

       // Vector vect_value = new Vector(1, 1);
       // Vector vect_key = new Vector(1, 1);

       /* if (vectVendMaster != null && vectVendMaster.size() > 0) {

            for (int i = 0; i < vectVendMaster.size(); i++) {

                ItemMaster im = (ItemMaster) vectVendMaster.get(i);
                ItemGroup ig = new ItemGroup();

                try {
                    ig = DbItemGroup.fetchExc(im.getItemGroupId());
                } catch (Exception e) {
                }

                ItemCategory ic = new ItemCategory();
                try {
                    ic = DbItemCategory.fetchExc(im.getItemCategoryId());
                } catch (Exception e) {
                }

                try {
                    //vect_key.add(ig.getName() + " - " + im.getName());
                   // vect_value.add("" + im.getOID());
                } catch (Exception e) {
                }

            }
        }*/

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
        boolean isEdit = false;
        

        for (int i = 0; i < objectClass.size(); i++) {

            ReceiveItem receiveItem = (ReceiveItem) objectClass.get(i);
            
            SessIncomingGoodsL igL = new SessIncomingGoodsL();
            rowx = new Vector();
            if (receiveItemId == receiveItem.getOID()) {
                index = i;
            }

            if (iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK || (iJSPCommand == JSPCommand.SAVE && (iErrCode2 != 0 || (vErr != null && vErr.size() > 0))))){
                isEdit = true;
                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                int cntStockCode = 0;
                Uom uomPurchase = new Uom()       ;
                Uom uomStock = new Uom();
                if (vectVendMaster != null && vectVendMaster.size() > 0) {

                    String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                    //strVal += "<tr><td colspan=\"4\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID], null, "" + objEntity.getItemMasterId(), vect_value, vect_key, "onchange=\"javascript:parserMasterLoop()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID) + "</div></td></tr>";
                    
                //strVal += "<tr><td colspan=\"4\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID], null, "" + objEntity.getItemMasterId(), vect_value, vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID) + "</div></td></tr>";
                
                    ItemMaster colCombo2  = new ItemMaster();
                        
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                                uomPurchase = DbUom.fetchExc(colCombo2.getUomPurchaseId());
                                uomStock = DbUom.fetchExc(colCombo2.getUomStockId());
			}catch(Exception e) {
				System.out.println(e);
			}
                    if(useStockCode){
                        strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"25\" readonly> </td></tr>";
                    }else{
                        strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"25\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                    }
                    if (useStockCode) {

                        int pg = 1;
                        int counter = 0;
                        double recItmQty = qty <= 0 ? 1 : qty;
                        strVal += "<tr><td colspan=\"4\" height=\"5\"></td></tr>";
                        strVal += "<tr><td width=\"10%\"></td><td width=\"15%\"><b><u>No</u></b></td><td width=\"70%\"><b><u>Serial Number</u></b></td><td></td></tr>";
                        
                        
                        for (double xx = 0; xx < recItmQty; xx++) {

                            cntStockCode++;
                            StockCode stockCode = new StockCode();
                            try {
                                stockCode = (StockCode) vStockCode.get(counter);
                            } catch (Exception e) {
                            }
                            
                            String msgErr ="";
                                                       
                            if(optStockCode == DbItemMaster.APPLY_STOCK_CODE){
                            if (isSave && stockCode.getCode().length() <= 0){
                                msgErr = "data required";
                            } else{
                       
                            for(int a=0; a<vStockCode.size();a++){
                                        if(counter!=a){
                                            StockCode code = (StockCode) vStockCode.get(a);
                                            if(stockCode.getCode().equalsIgnoreCase(code.getCode())){
                                                msgErr = "code already exist";
                                                break;
                                            }
                                        }
                            }
                            //if(DbStockCode.checkCode(stockCode.getCode())){
                            //        msgErr = "code already exist";
                            //}

                        }
                        }
                            
                            strVal += "<tr><td width=\"15\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + counter + "\" value=\"" + stockCode.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] + "_" + counter + "\" value=\"" + receive.getLocationId() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + counter + "\" value=\"" + objEntity.getItemMasterId() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + counter + "\" value=\"" + DbStockCode.STOCK_IN + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + counter + "\" value=\"" + DbStockCode.TYPE_INCOMING_GOODS + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RECEIVE_ID] + "_" + counter + "\" value=\"" + receive.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + counter + "\" value=\"" + 1 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RECEIVE_ITEM_ID] + "_" + counter + "\" value=\"" + objEntity.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                    "</td><td width=\"15\" align=\"center\">" + pg + "</td><td><input type=\"text\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + counter + "\" value=\"" + stockCode.getCode() + "\" size=\"30\" >&nbsp;*)&nbsp;<font color=\"#FF0000\">" + msgErr + "</font></td><td></td></tr>";

                            pg++;
                            counter++;

                        }


                    }

                                        
                    strVal += "<tr><td></td><td></td><td></td></tr>";
                    strVal += "</table>";

                    rowx.add(strVal);

                } else {
                    rowx.add("<font color=\"red\">No receive item available for vendor</font>");
                }

                if (true) {

                    rowx.add("<div align=\"right\">" + "<input type=\"hidden\" name=\"STOCK_CODE_COUNTER\" value=\"" + cntStockCode + "\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\"> *) " + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_AMOUNT)) + "</div>");
                    if(useStockCode){
                       rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onChange=\"javascript:viewStockCodeEdit('" + receive.getOID() + "','" + receiveItem.getOID() + "','" + objEntity.getQty() + "')\" onBlur=\"javascript:calculateSubTotal()\">" + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_QTY)) + "</div>"); 
                    }else{
                       rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_QTY)) + "</div>"); 
                    }
                     
                    
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] + "\" value=\"" + objEntity.getTotalDiscount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + "</div>");
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"17\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] + "\" value=\"" + objEntity.getTotalAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div><input type=\"hidden\" name=\"temp_item_amount\" value=\"" + objEntity.getTotalAmount() + "\">");
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_code\" value=\"" + uomPurchase.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_stock\" value=\"" + uomStock.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
                    if(use_expired_date==DbItemMaster.USE_EXPIRED_DATE){
                        rowx.add("<div align=\"center\"><input name=\"" + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + "\" value=\"" + JSPFormater.formatDate((objEntity.getExpiredDate() == null) ? new Date() : objEntity.getExpiredDate(), "dd/MM/yyyy") + "\" size=\"11\" readonly>" +
                            "<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmreceive." + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + ");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"" + approot + "/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");
                    }else{
                        rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"u\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
                    }
                        
                } else {

                    rowx.add("<div align=\"right\">" + "<input type=\"hidden\" name=\"STOCK_CODE_COUNTER\" value=\"" + cntStockCode + "\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_AMOUNT] + "\" value=\"" + receiveItem.getAmount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\"> *) " + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_AMOUNT)) + "</div>");
                    if(useStockCode){
                        rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_QTY] + "\" value=\"" + receiveItem.getQty() + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onChange=\"javascript:viewStockCodeEdit('" + receive.getOID() + "','" + receiveItem.getOID() + "','" + objEntity.getQty() + "')\" onBlur=\"javascript:calculateSubTotal()\">" + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_QTY)) + "</div>"); 
                    }else{
                        rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_QTY] + "\" value=\"" + receiveItem.getQty() + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_QTY)) + "</div>");
                    }
                        
                    
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] + "\" value=\"" + receiveItem.getTotalDiscount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + "</div>");
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"17\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] + "\" value=\"" + receiveItem.getTotalAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div><input type=\"hidden\" name=\"temp_item_amount\" value=\"" + receiveItem.getTotalAmount() + "\">");
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_code\" value=\"" + uomPurchase.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_stock\" value=\"" + uomStock.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
                    if(use_expired_date==DbItemMaster.USE_EXPIRED_DATE){
                        rowx.add("<div align=\"center\"><input name=\"" + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + "\" value=\"" + JSPFormater.formatDate((receiveItem.getExpiredDate() == null) ? new Date() : receiveItem.getExpiredDate(), "dd/MM/yyyy") + "\" size=\"11\" readonly>" +
                            "<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmreceive." + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + ");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"" + approot + "/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");
                    }else{
                        rowx.add("<div align=\"right\"></div>");
                    }
                        
                }


            } else {
                ItemMaster itemMaster = new ItemMaster();
                ItemGroup ig = new ItemGroup();
                ItemCategory ic = new ItemCategory();
                try {
                    itemMaster = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
                    ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                    ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                } catch (Exception e) {
                    
                }

                Uom uom = new Uom();
                Uom uomStock = new Uom();
                try {
                    uom = DbUom.fetchExc(receiveItem.getUomId());
                    uomStock = DbUom.fetchExc(itemMaster.getUomStockId());
                } catch (Exception e) {
                }

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                if ((status != null && status.equals(I_Project.DOC_STATUS_DRAFT) && receiveItem.getPurchaseItemId() == 0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                    rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(receiveItem.getOID()) + "')\">" + ig.getName() + " / " + itemMaster.getCode() + " - " + itemMaster.getName() + "</a>");
                    igL.setGroup(itemMaster.getCode() + " - " + itemMaster.getName());
                } else {
                    rowx.add(ig.getName() + " / " + itemMaster.getCode() + " - " + itemMaster.getName());
                    igL.setGroup(itemMaster.getCode() + " - " + itemMaster.getName());
                }
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getAmount(), "#,###.##") + "</div>");
                igL.setPrice(receiveItem.getAmount());
                rowx.add("<div align=\"center\">" + receiveItem.getQty() + "</div>");
                igL.setQty(receiveItem.getQty());
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getTotalDiscount(), "#,###.##") + "</div>");
                igL.setDiscount(receiveItem.getTotalDiscount());
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getTotalAmount(), "#,###.##") + "</div>");
                igL.setTotal(receiveItem.getTotalAmount());
                rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
                igL.setUnit(uom.getUnit());
                rowx.add("<div align=\"center\">" + uomStock.getUnit() + "</div>");
                igL.setUnitStock(uomStock.getUnit());
                rowx.add("<div align=\"center\">" + ((receiveItem.getExpiredDate() == null) ? "-" : JSPFormater.formatDate(receiveItem.getExpiredDate(), "dd/MM/yyyy")) + "</div>");
                igL.setExpiredDate(receiveItem.getExpiredDate());
            }

            lstData.add(rowx);
            temp.add(igL);
        }
        //baru
        rowx = new Vector();
        Uom uomPurchase = new Uom()       ;
        Uom uomStock = new Uom();
        if (((iJSPCommand != JSPCommand.POST && isEdit == false && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && receiveItemId == 0))) )){
            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");

            int cntStockCode = 0;
            objEntity.setItemMasterId(itemMasterId);
            if (vectVendMaster != null && vectVendMaster.size() > 0) {

                String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                //strVal += "<tr><td colspan=\"4\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID], null, "" + objEntity.getItemMasterId(), vect_value, vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID) + "</div></td></tr>";
                ItemMaster colCombo2  = new ItemMaster();
                
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                                uomPurchase = DbUom.fetchExc(colCombo2.getUomPurchaseId());
                                uomStock = DbUom.fetchExc(colCombo2.getUomStockId());
			}catch(Exception e) {
				System.out.println(e);
			}
                
                //String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                        strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"25\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                if (useStockCode) {

                    int pg = 1;
                    int counter = 0;
                    double recItmQty = qty <= 0 ? 1 : qty;
                    strVal += "<tr><td colspan=\"4\" height=\"5\"></td></tr>";
                    strVal += "<tr><td width=\"10%\"></td><td  width=\"15%\"><b><u>No</u></b></td><td width=\"70%\"><b><u>Serial Number</u></b></td><td></td></tr>";

                    for (double xx = 0; xx < recItmQty; xx++) {

                        cntStockCode++;
                        StockCode stockCode = new StockCode();
                        try {
                            stockCode = (StockCode) vStockCode.get(counter);
                        } catch (Exception e) {
                        }

                        String msgErr = "";
                        
                        if(optStockCode == DbItemMaster.APPLY_STOCK_CODE){
                            if (isSave && stockCode.getCode().length() <= 0){
                                msgErr = "data required";
                            } else{
                       
                            for(int a=0; a<vStockCode.size();a++){
                                        if(counter!=a){
                                            StockCode code = (StockCode) vStockCode.get(a);
                                            if(stockCode.getCode().equalsIgnoreCase(code.getCode())){
                                                msgErr = "code already exist";
                                                break;
                                            }
                                        }
                            }
                            if(DbStockCode.checkCode(stockCode.getCode())){
                                    msgErr = "code already exist";
                            }

                        }
                        }
                        strVal += "<tr><td width=\"15\">&nbsp;" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + counter + "\" value=\"" + stockCode.getOID() + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] + "_" + counter + "\" value=\"" + receive.getLocationId() + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + counter + "\" value=\"" + objEntity.getItemMasterId() + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + counter + "\" value=\"" + DbStockCode.STOCK_IN + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + counter + "\" value=\"" + DbStockCode.TYPE_INCOMING_GOODS + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RECEIVE_ID] + "_" + counter + "\" value=\"" + receive.getOID() + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + counter + "\" value=\"" + 1 + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RECEIVE_ITEM_ID] + "_" + counter + "\" value=\"" + objEntity.getOID() + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + counter + "\" value=\"" + 0 + "\">" +
                                "</td><td width=\"15\" align=\"center\">" + pg + "</td><td><input type=\"text\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + counter + "\" value=\"" + stockCode.getCode() + "\" size=\"30\" >&nbsp;*)&nbsp;<font color=\"#FF0000\">" + msgErr + "</font></td><td></td></tr>";

                        pg++;
                        counter++;
                    }

                }
                strVal += "<tr><td></td><td></td><td></td></tr>";
                strVal += "</table>";

                rowx.add(strVal);

            } else {
                rowx.add("<font color=\"red\">No receive item available for vendor</font>");
            }

            rowx.add("<div align=\"right\">" + "<input type=\"hidden\" name=\"STOCK_CODE_COUNTER\" value=\"" + cntStockCode + "\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\"> *) " + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_AMOUNT)) + "</div>");
            if(useStockCode){
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_QTY] + "\" value=\"" + ((objEntity.getQty() == 0) ? 0 : objEntity.getQty()) + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onChange=\"javascript:viewStockCode()\" onBlur=\"javascript:calculateSubTotal()\">" + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_QTY)) + "</div>");
            }else{
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_QTY] + "\" value=\"" + ((objEntity.getQty() == 0) ? 1 : objEntity.getQty()) + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_QTY)) + "</div>");
            }
                       
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] + "\" value=\"" + objEntity.getTotalDiscount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + "</div>");
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"17\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] + "\" value=\"" + objEntity.getTotalAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div>");
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_code\" value=\"" + uomPurchase.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_stock\" value=\"" + uomStock.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
            if(use_expired_date==DbItemMaster.USE_EXPIRED_DATE){
                rowx.add("<div align=\"center\"><input name=\"" + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + "\" value=\"" + JSPFormater.formatDate((objEntity.getExpiredDate() == null) ? new Date() : objEntity.getExpiredDate(), "dd/MM/yyyy") + "\" size=\"11\" readonly>" +
                    "<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmreceive." + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + ");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"" + approot + "/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");
            }else{
                rowx.add("<div align=\"right\"></div>");
            }
                
            
        }

        lstData.add(rowx);

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        return v;
    }
%>
<%

            if (session.getValue("PURCHASE_TITTLE") != null) {
                session.removeValue("PURCHASE_TITTLE");
            }

            if (session.getValue("PURCHASE_DETAIL") != null) {
                session.removeValue("PURCHASE_DETAIL");
            }

            
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
            long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");
            long oidCodeDelete = JSPRequestValue.requestLong(request, "hidden_code_delete");
            int opt_stock_code =JSPRequestValue.requestInt(request, "hidden_optional_stock_code");
            long itemMasterId = JSPRequestValue.requestLong(request, JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]);
            
            int useExpiredDate = 0;
            boolean isNone = false;
            boolean isAdd = false;

            if (iJSPCommand == JSPCommand.ADD) {
                isAdd = true;
                //oidReceive=0;
            }

            if (iJSPCommand == JSPCommand.NONE) {
                isNone = true;
                //iJSPCommand = JSPCommand.ADD;
                oidReceive = 0;
            }
            

            boolean isRefresh = false;

            if (iJSPCommand == JSPCommand.REFRESH) { //  Jika terjadi Edit
                if (oidCodeDelete != 0) {  //meghapus stock code
                    DbStockCode.deleteAllItem(oidCodeDelete);
                }

                isRefresh = true;
            }

            if (iJSPCommand == JSPCommand.GET){
                DbStockCode.deleteStockCode(oidReceiveItem);
                iJSPCommand = JSPCommand.VIEW;
            }

            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdReceive cmdReceive = new CmdReceive(request);
            JSPLine ctrLine = new JSPLine();

            JspReceive jspReceive = cmdReceive.getForm();
            iErrCode = cmdReceive.action(iJSPCommand, oidReceive);

            Receive receive = cmdReceive.getReceive();
            msgString = cmdReceive.getMessage();

            if (oidReceive == 0) {
                oidReceive = receive.getOID();
                if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){
                    receive.setStatus(I_Project.DOC_STATUS_DRAFT);
                }else{
                    receive.setStatus(I_Project.DOC_STATUS_APPROVED);
                }
            }

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];

%>	
<%
                             
           
            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;
            
            SessIncomingGoods ig = new SessIncomingGoods();

            CmdReceiveItem cmdReceiveItem = new CmdReceiveItem(request);

            int loop = JSPRequestValue.requestInt(request, "STOCK_CODE_COUNTER");

            boolean isStockEmpty = false;
            boolean isStockSame = false;
           
            if(opt_stock_code == DbItemMaster.APPLY_STOCK_CODE){
               
                if (loop > 0){

                    for (int y = 0; y < loop; y++) {

                        String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + y);
                        if (stCode.length() <= 0) {
                            isStockEmpty = true;
                            break;
                        }
                    }
                }
            }
            Vector vstockCode = new Vector();
            if(opt_stock_code == DbItemMaster.APPLY_STOCK_CODE){
               
                if (loop > 0){

                    for (int y = 0; y < loop; y++) {

                        String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + y);
                        vstockCode.add(y, stCode);
                    }
                }
            }
            
            if(opt_stock_code == DbItemMaster.APPLY_STOCK_CODE){
               
                if (loop > 0){

                    for (int y = 0; y < loop; y++) {

                        String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + y);
                        if(oidReceiveItem==0){
                            if (DbStockCode.checkCode(stCode)) {
                               isStockSame = true;
                               break;
                            }
                        }
                        for(int x=0 ; x< vstockCode.size();x++){
                            if(y!=x){
                                if(vstockCode.get(x).equals(stCode)){
                                    isStockSame = true;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            
            iErrCode2 = cmdReceiveItem.action(iJSPCommand, oidReceiveItem, oidReceive, isStockEmpty, isStockSame);
            JspReceiveItem jspReceiveItem = cmdReceiveItem.getForm();
            ReceiveItem receiveItem = cmdReceiveItem.getReceiveItem();
            
            msgString2 = cmdReceiveItem.getMessage();

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
            Vector purchItems = DbReceiveItem.list(0, 0, whereClause, orderClause);

            Vector vendors = DbVendor.list(0, 0, "", "name");

            boolean isView = false;

            if (iJSPCommand == JSPCommand.VIEW) {
                isView = true;
                iJSPCommand = JSPCommand.ADD;
            }

            if (iJSPCommand == JSPCommand.REFRESH) {
                isView = true;
            }

            if (receive.getVendorId() == 0) {
                if (vendors != null && vendors.size() > 0) {
                    Vendor vx = (Vendor) vendors.get(0);
                    receive.setVendorId(vx.getOID());
                }
            }

            String whereCls = DbItemMaster.colNames[DbItemMaster.COL_FOR_BUY] + "=1";

            Vector vendorItems = DbItemMaster.list(0, 1, whereCls, DbItemMaster.colNames[DbItemMaster.COL_CODE]);
            
            String msgSuccsess = "";

            Vector vErr = new Vector();

            String whereSCode = DbStockCode.colNames[DbStockCode.COL_RECEIVE_ID] + "=" + receive.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_TYPE] + "=" + DbStockCode.TYPE_INCOMING_GOODS;
            Vector vStockCode = DbStockCode.list(0, 0, whereSCode, null);

            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                isSave = true;
            }

            if ((iErrCode != 0 || iErrCode2 != 0) && iJSPCommand == JSPCommand.SAVE) {

                int loopStockCode = JSPRequestValue.requestInt(request, "STOCK_CODE_COUNTER");

                if (loopStockCode > 0) {

                    vStockCode = new Vector();

                    for (int ySc = 0; ySc < loopStockCode; ySc++) {

                        String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + ySc);
                        StockCode sCode = new StockCode();

                        sCode.setOID(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + ySc));
                        sCode.setLocationId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] ));
                        sCode.setItemMasterId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + ySc));
                        sCode.setInOut(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + ySc));
                        sCode.setType(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + ySc));
                        sCode.setReturId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + ySc));
                        sCode.setTransferId(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + ySc));
                        sCode.setQty(JSPRequestValue.requestDouble(request, JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + ySc));
                        sCode.setStatus(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + ySc));
                        sCode.setTransferItemId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + ySc));
                        sCode.setReturItemId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + ySc));
                        sCode.setCode(JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + ySc));
                        sCode.setReceiveItemId(receiveItem.getOID());
                        sCode.setReceiveId(receive.getOID());
                        sCode.setType_item(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM] ));
                        
                        vStockCode.add(sCode);
                        if(opt_stock_code==DbItemMaster.APPLY_STOCK_CODE){
                            if (stCode == null || stCode.length() <= 0) {
                                vErr.add("" + ySc);
                            }
                        }
                        
                    }
                }
            }

            if ((iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) || iJSPCommand == JSPCommand.VIEW) {

                if ((iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE)) {

                    int loopStockCode = JSPRequestValue.requestInt(request, "STOCK_CODE_COUNTER");

                    if (loopStockCode > 0) {

                        vStockCode = new Vector();

                        for (int ySc = 0; ySc < loopStockCode; ySc++) {

                            String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + ySc);
                            StockCode sCode = new StockCode();

                            sCode.setOID(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + ySc));
                            sCode.setLocationId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] ));
                            sCode.setItemMasterId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + ySc));
                            sCode.setInOut(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + ySc));
                            sCode.setType(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + ySc));
                            sCode.setReturId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + ySc));
                            sCode.setTransferId(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + ySc));
                            sCode.setQty(JSPRequestValue.requestDouble(request, JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + ySc));
                            sCode.setStatus(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + ySc));
                            sCode.setTransferItemId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + ySc));
                            sCode.setReturItemId(JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + ySc));
                            sCode.setCode(JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + ySc));
                            sCode.setReceiveItemId(receiveItem.getOID());
                            sCode.setReceiveId(receive.getOID());
                            sCode.setType_item(JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM] ));
                            
                            vStockCode.add(sCode);
                            if(opt_stock_code==DbItemMaster.APPLY_STOCK_CODE){
                                if (stCode == null || stCode.length() <= 0){
                                    vErr.add("" + ySc);
                                }
                            }
                            

                        }

                        if (vErr == null || vErr.size() <= 0) {

                            for (int xStockCode = 0; xStockCode < loopStockCode; xStockCode++) {

                                long stockCodeId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + xStockCode);
                                long locationId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_LOCATION_ID] );
                                itemMasterId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + xStockCode);
                                int inOut = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_IN_OUT] + "_" + xStockCode);
                                int type = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE] + "_" + xStockCode);
                                long retId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ID] + "_" + xStockCode);
                                long transId = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + xStockCode);
                                double quantity = JSPRequestValue.requestDouble(request, JspStockCode.colNames[JspStockCode.JSP_QTY] + "_" + xStockCode);
                                int status = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_STATUS] + "_" + xStockCode);
                                long tranItmId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + xStockCode);
                                long returItmId = JSPRequestValue.requestLong(request, JspStockCode.colNames[JspStockCode.JSP_RETUR_ITEM_ID] + "_" + xStockCode);
                                int type_item = JSPRequestValue.requestInt(request, JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM]);
                                String stCode = JSPRequestValue.requestString(request, JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + xStockCode);

                                StockCode objStockCode = new StockCode();
                                objStockCode.setOID(stockCodeId);
                                objStockCode.setLocationId(locationId);
                                objStockCode.setItemMasterId(itemMasterId);
                                objStockCode.setInOut(inOut);
                                objStockCode.setType(type);
                                objStockCode.setReceiveId(receive.getOID());
                                objStockCode.setReturId(retId);
                                objStockCode.setTransferId(transId);
                                objStockCode.setQty(quantity);
                                objStockCode.setStatus(status);
                                objStockCode.setReceiveItemId(receiveItem.getOID());
                                objStockCode.setTransferItemId(tranItmId);
                                objStockCode.setReturItemId(returItmId);
                                objStockCode.setCode(stCode);
                                objStockCode.setType_item(type_item);
                                
                                if (stCode != null && stCode.length() > 0) {
                                    if (stockCodeId == 0) {
                                        DbStockCode.insertExc(objStockCode);
                                    } else {
                                        DbStockCode.updateExc(objStockCode);
                                    }
                                }
                            }
                        }
                    }
                }
                
                if(iJSPCommand==JSPCommand.SAVE){
                    if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){
                        iJSPCommand = JSPCommand.POST;
                        iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
                        iJSPCommand =  JSPCommand.SAVE;
                    }
                }   
                
                //iJSPCommand = JSPCommand.ADD;
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
                msgSuccsess = "Data is saved";
            }

            if (iJSPCommand == JSPCommand.REFRESH) {
                iJSPCommand = JSPCommand.EDIT;
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD) {

                try {
                    receive = DbReceive.fetchExc(oidReceive);
                } catch (Exception e) {
                    
                }
            }

            boolean useStockCode = false;
            
            
            double purchase_stock_qty = 0;
            try {

                long oidTmpReceiveItem = 0;

                if (isNone || isAdd ){
                    try {
                        ItemMaster tmpIM = (ItemMaster) vendorItems.get(0);
                        oidTmpReceiveItem = tmpIM.getOID();
                        if(itemMasterId!=0){
                            oidTmpReceiveItem = itemMasterId;
                        }
                    } catch (Exception e) {
                    }
                } else {
                    oidTmpReceiveItem = receiveItem.getItemMasterId();
                    //if(oidTmpReceiveItem==0){
                     //   oidTmpReceiveItem = itemMasterId;
                   // }
                }
                
                ItemMaster itemMaster = DbItemMaster.fetchExc(oidTmpReceiveItem);
                if (itemMaster.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE || itemMaster.getApplyStockCode()== DbItemMaster.OPTIONAL_STOCK_CODE) {
                    useStockCode = true;
                    purchase_stock_qty= itemMaster.getUomPurchaseStockQty();
                }
                
                opt_stock_code= itemMaster.getApplyStockCode();
                useExpiredDate = itemMaster.getUseExpiredDate();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }

            double subTotal = DbReceiveItem.getTotalReceiveAmount(oidReceive);
            
            
            if(iJSPCommand== JSPCommand.CONFIRM ){
                oidReceive=0;
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
            
            function cmdPrintDoc(){                
                window.open("<%=printroot%>.report.RptIncomingGoodsPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                <%if (!posPReqPriv) {%>
                window.location="<%=approot%>/nopriv.jsp";
                <%}%>
                
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
                        }
                        else{
                            if(xx==',' || xx=='.'){
                                result = result + xx;
                            }
                        }
                    }
                    
                    return result;
                }
                
                function parserMaster(oidReceive){
                    
                    var str = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>.value;
                   
                    
         <%if (vendorItems != null && vendorItems.size() > 0) {

                for (int i = 0; i < vendorItems.size(); i++) {

                    ItemMaster im = (ItemMaster) vendorItems.get(i);
                    Uom uom = new Uom();
                    Uom uomStock = new Uom();
                    try {
                        uom = DbUom.fetchExc(im.getUomPurchaseId());
                        uomStock = DbUom.fetchExc(im.getUomStockId());
                    } catch (Exception e) {
                    }
         %>
             if('<%=im.getOID()%>'==str){                 
                 document.frmreceive.unit_code.value="<%=uom.getUnit()%>";
                 document.frmreceive.unit_stock.value="<%=uomStock.getUnit()%>";
             }
         <%}
            }%>
            
            calculateSubTotal();
            document.frmreceive.hidden_receive_item_id.value=oidReceive;
            document.frmreceive.command.value="<%=JSPCommand.VIEW%>";
            document.frmreceive.action="receiveItemConsigment.jsp";
            document.frmreceive.submit();     
            
        }
        
        function parserMasterLoop(){
            
            var cfrm = confirm('Are you sure want to change group-name, and you will lose serial number datas ?');
            
            if(cfrm==true){
                
                var str = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>.value;
              
         <%if (vendorItems != null && vendorItems.size() > 0) {

                for (int i = 0; i < vendorItems.size(); i++) {

                    ItemMaster im = (ItemMaster) vendorItems.get(i);
                    Uom uom = new Uom();
                    Uom uomStock = new Uom();
                    try {
                        uom = DbUom.fetchExc(im.getUomPurchaseId());
                        uomStock = DbUom.fetchExc(im.getUomStockId());
                    } catch (Exception e) {
                    }
         %>
             if('<%=im.getOID()%>'==str){                 
                 document.frmreceive.unit_code.value="<%=uom.getUnit()%>";
                 document.frmreceive.unit_stock.value="<%=uomStock.getUnit()%>";
             }
         <%}
            }%>
            
            calculateSubTotal();            
            document.frmreceive.command.value="<%=JSPCommand.GET%>";            
            document.frmreceive.action="receiveItemConsigment.jsp";
            document.frmreceive.submit();  
            
        }else{            
        document.frmreceive.itm_JSP_ITEM_MASTER_ID.value="<%=receiveItem.getItemMasterId()%>";
    }
}


function parserMaster(){
    
    var str = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>.value;
    
         <%if (vendorItems != null && vendorItems.size() > 0) {

                for (int i = 0; i < vendorItems.size(); i++) {

                    ItemMaster im = (ItemMaster) vendorItems.get(i);
                    Uom uom = new Uom();
                    Uom uomStock = new Uom();
                    try {
                        uom = DbUom.fetchExc(im.getUomPurchaseId());
                        uomStock = DbUom.fetchExc(im.getUomStockId());
                    } catch (Exception e) {
                    }
         %>
             if('<%=im.getOID()%>'==str){                 
                 document.frmreceive.unit_code.value="<%=uom.getUnit()%>";
                 document.frmreceive.unit_stock.value="<%=uomStock.getUnit()%>";
             }
         <%}
            }%>
            
            calculateSubTotal();            
            document.frmreceive.command.value="<%=JSPCommand.VIEW%>";
            document.frmreceive.action="receiveItemConsigment.jsp";
            document.frmreceive.submit();     
            
        }
        
        
        function parserMaster2(){
            
            var str = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]%>.value;
            
         <%if (vendorItems != null && vendorItems.size() > 0) {

                for (int i = 0; i < vendorItems.size(); i++) {

                    ItemMaster im = (ItemMaster) vendorItems.get(i);
                    Uom uom = new Uom();
                    Uom uomStock = new Uom();
                    try {
                        uom = DbUom.fetchExc(im.getUomPurchaseId());
                        uomStock = DbUom.fetchExc(im.getUomStockId());
                    } catch (Exception e) {
                    }
         %>
             if('<%=im.getOID()%>'==str){                 
                 document.frmreceive.unit_code.value="<%=uom.getUnit()%>";
                 document.frmreceive.unit_stock.value="<%=uomStock.getUnit()%>";
             }
         <%}
            }%>
            
            calculateSubTotal();
            
        }
        
        function viewStockCode(){
            
            document.frmreceive.command.value="<%=JSPCommand.VIEW%>";
            document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
            document.frmreceive.action="receiveItemConsigment.jsp";
            document.frmreceive.submit();            
        }
        
        function viewStockCodeEdit(oidReceive,oidReceiveItem,qty){
            var qty_new = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value;
           
            if(qty > qty_new){
                
                var cfrm = confirm('Are you sure want to change qty, and you will lose serial number datas ?');
                
                if(cfrm==true){
                    
                    document.frmreceive.hidden_receive_id.value=oidReceive;
                    document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
                    document.frmreceive.command.value="<%=JSPCommand.REFRESH%>";
                    document.frmreceive.hidden_code_delete.value=oidReceive;
                    document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                    document.frmreceive.action="receiveItemConsigment.jsp";
                    document.frmreceive.submit();   
                }else{
                document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value=qty;
            }
            
        }else{
        document.frmreceive.hidden_receive_id.value=oidReceive;
        document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
        document.frmreceive.command.value="<%=JSPCommand.REFRESH%>";
        document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
        document.frmreceive.action="receiveItemConsigment.jsp";
        document.frmreceive.submit();            
    }
}

function calculateSubTotal(){   
    
    var amount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value;
    var qty = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value;
    var discount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value;
    
    amount = removeChar(amount);
    amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
    document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
    
    qty = removeChar(qty);
    qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
    document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value = qty;
    
    discount = removeChar(discount);
    discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
    document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value = formatFloat(''+discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
    
    var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) - parseFloat(discount);
    document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
    
    var subtot = document.frmreceive.sub_tot.value;
    subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
    
         <%

            if (oidReceiveItem == 0) {%>
                    document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                    <%} else {%>
                    var tempAmount = document.frmreceive.temp_item_amount.value;
                    document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
         <%}
         %>
             
             calculateAmount();
         }
         
         function cmdVatEdit(){
             var vat = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>.value;
             if(parseInt(vat)==0){
                 document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="0.0";				
             }else{
             document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
         }
         
         calculateAmount();
     }
     
     function cmdAddItemMaster(){            
             
             
            window.open("<%=approot%>/postransaction/addItemReceive.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmsalesproductdetail.submit();    
        }
     
     function calculateAmount(){
         
         var vat = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>.value;
         var taxPercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value;
         taxPercent = removeChar(taxPercent);
         taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         var discPercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>.value;	
         discPercent = removeChar(discPercent);
         discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         var subTotal = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value;
         subTotal = removeChar(subTotal);
         subTotal = cleanNumberFloat(subTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         var totalDiscount = 0;
         if(parseFloat(discPercent)>0){
             totalDiscount = parseFloat(discPercent)/100 * parseFloat(subTotal);
         }
         
         var totalTax = 0;
         
         if(parseInt(vat)==0){
             document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="0.0";		
             totalTax = 0;
         }else{
         document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
         totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
     }
     
     var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;
     
     document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
     document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
     document.frmreceive.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
     
 }
 
 function cmdClosedReason(){
     var st = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>.value;
     if(st=='CLOSED'){
         document.all.closingreason.style.display="";
     }
     else{
         document.all.closingreason.style.display="none";		
     }
 }
 
 function cmdVendor(){
     <%if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0) {%>
     if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all receive item based on vendor item master. ')){
         document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
         document.frmreceive.action="receiveItemConsigment.jsp";
         document.frmreceive.submit();
     }
     <%} else {%>
     document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
     document.frmreceive.action="receiveItemConsigment.jsp";
     document.frmreceive.submit();
     //cmdVendorChange();
     <%}%>
 }
 
 function cmdToRecord(){
     document.frmreceive.command.value="<%=JSPCommand.NONE%>";
     document.frmreceive.action="receivelistConsigment.jsp";
     document.frmreceive.submit();
 }
 
 function cmdVendorChange(){
     var oid = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>.value;
         <%
            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor v = (Vendor) vendors.get(i);
                         %>
                             if('<%=v.getOID()%>'==oid){
                                 document.frmreceive.vnd_address.value="<%=v.getAddress()%>";
                             }
                         <%
                }
            }
         %>
             
         }
         
         
         function cmdCloseDoc(){
             document.frmreceive.action="<%=approot%>/home.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAskDoc(){
             document.frmreceive.hidden_receive_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdDeleteDoc(){
             document.frmreceive.hidden_receive_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdCancelDoc(){
             document.frmreceive.hidden_receive_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdSaveDoc(){
             document.frmreceive.command.value="<%=JSPCommand.POST%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAdd(){
             document.frmreceive.hidden_receive_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.ADD%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAsk(oidReceiveItem){
             document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
             document.frmreceive.command.value="<%=JSPCommand.ASK%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAskMain(oidReceive){
             document.frmreceive.hidden_receive_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.ASK%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdConfirmDelete(oidReceiveItem){
             document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
             document.frmreceive.command.value="<%=JSPCommand.DELETE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         function cmdSaveMain(){
             document.frmreceive.command.value="<%=JSPCommand.SAVE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdSave(oidReceive){
             document.frmreceive.hidden_receive_item_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.SAVE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
             //cmdSaveDoc();
         }
         
         function cmdEdit(oidReceive){
             document.frmreceive.hidden_receive_item_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdCancel(oidReceive){
             document.frmreceive.hidden_receive_item_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdBack(){
             document.frmreceive.command.value="<%=JSPCommand.BACK%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdListFirst(){
             document.frmreceive.command.value="<%=JSPCommand.FIRST%>";
             document.frmreceive.prev_command.value="<%=JSPCommand.FIRST%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdListPrev(){
             document.frmreceive.command.value="<%=JSPCommand.PREV%>";
             document.frmreceive.prev_command.value="<%=JSPCommand.PREV%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdListNext(){
             document.frmreceive.command.value="<%=JSPCommand.NEXT%>";
             document.frmreceive.prev_command.value="<%=JSPCommand.NEXT%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
         }
         
         function cmdListLast(){
             document.frmreceive.command.value="<%=JSPCommand.LAST%>";
             document.frmreceive.prev_command.value="<%=JSPCommand.LAST%>";
             document.frmreceive.action="receiveItemConsigment.jsp";
             document.frmreceive.submit();
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
                            <td height="96"> 
                                <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenuconsigment.jsp"%>
                                <!-- #EndEditable -->
                            </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                  <%@ include file="../main/menuconsigment.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmreceive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_receive_item_id" value="<%=oidReceiveItem%>">
                                                            <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                                                            <input type="hidden" name="<%=JspReceiveItem.colNames[JspReceiveItem.JSP_RECEIVE_ID]%>" value="<%=oidReceive%>">                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="hidden_code_delete" value="<%=0%>">
                                                            <input type="hidden" name="hidden_optional_stock_code" value="<%=opt_stock_code%>">
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_TYPE]%>" value="<%=DbReceive.TYPE_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TYPE]%>" value="<%=DbReceive.TYPE_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM]%>" value="<%=DbReceive.TYPE_CONSIGMENT%>">
                                                            
                                                            <% if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
                                                                <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
                                                            <% } %>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <script language="JavaScript">
                                                                   parserMaster(); 
                                                                </script>
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Incoming Goods 
                                                                                        </font><font class="tit1">&raquo;<span class="lvl2">
                                                                                                <%if (receive.getPurchaseId() == 0) {%>
                                                                                                Direct Incoming
                                                                                                <%} else {%>
                                                                                                PO Base
                                                                                                <%}%>
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
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td height="8"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;Incoming 
                                                                                                Goods &nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                                                                        
                                                <td height="21" valign="middle" width="37%">&nbsp;</td>
                                                                                                        
                                                <td height="21" valign="middle" width="9%">&nbsp;</td>
                                                                                                        
                                                <td height="21" colspan="2" width="42%" class="comment" valign="top"> 
                                                  <div align="right"><i>Date : 
                                                                                                                    <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                                                                                    <%if (receive.getOID() == 0) {%>
                                                                                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                                                                                    <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(receive.getUserId());
    } catch (Exception e) {}
                                                                                                                    %>
                                                                                                                    Prepared By : <%=us.getLoginId()%> 
                                                                                                                    <%}%>
                                                                                                            </i>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
            Purchase purchase = new Purchase();
            if (receive.getPurchaseId() != 0) {
                ig.setOidGoods(receive.getPurchaseId());
                try {
                    purchase = DbPurchase.fetchExc(receive.getPurchaseId());
                } catch (Exception e) {}
                                                                                                    %>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;PO 
                                                                                                        Number</td>
                                                                                                        
                                                <td height="20" width="37%"> 
                                                  <input type="text" name="textfield" value="<%=purchase.getNumber()%>" class="readOnly" readOnly>
                                                                                                            <%ig.setPoNumber(purchase.getNumber());%>
                                                                                                        </td>
                                                                                                        
                                                <td height="20" width="9%">&nbsp;</td>
                                                                                                        
                                                <td height="20" colspan="2" width="42%" class="comment">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;PO 
                                                                                                        Date </td>
                                                                                                        
                                                <td height="20" width="37%"> 
                                                  <input type="text" name="textfield2" value="<%=JSPFormater.formatDate(purchase.getPurchDate(), "dd/MM/yyyy")%>" class="readOnly" readonly>
                                                                                                            <%ig.setPoDate(purchase.getPurchDate());%>
                                                                                                        </td>
                                                                                                        
                                                <td height="20" width="9%">&nbsp;</td>
                                                                                                        
                                                <td height="20" colspan="2" width="42%" class="comment">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" width="12%">&nbsp;</td>
                                                                                                        
                                                <td height="5" width="37%">*) 
                                                  data required</td>
                                                                                                        <td height="5" colspan="2"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="4"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;Vendor</td>
                                                                                                        
                                                <td height="20" width="37%"> 
                                                  <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PURCHASE_ID]%>" value="<%=purchase.getOID()%>">
                                                                                                            <%
            Vendor vnd = new Vendor();
            if (receive.getPurchaseId() == 0){%>
                                                                                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>" onChange="javascript:cmdVendor()">
                                                                                                                <%
                                                                                                                if (vendors != null && vendors.size() > 0) {
                                                                                                                    for (int i = 0; i < vendors.size(); i++) {
                                                                                                                        Vendor d = (Vendor) vendors.get(i);
                                                                                                                        if (receive.getVendorId() == d.getOID()) {
                                                                                                                            ig.setVendor(d.getName() + " - " + d.getCode());
                                                                                                                            ig.setAddress(d.getAddress());
                                                                                                                        }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (receive.getVendorId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
                                                                                                                }%>
                                                                                                            </select>
                                                                                                            <%} else {
                                                                                                                try {
                                                                                                                    vnd = DbVendor.fetchExc(receive.getVendorId());
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            %>
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>" value="<%=receive.getVendorId()%>">
                                                                                                            <input type="text" name="v_name" value="<%=vnd.getName() + " - " + vnd.getCode()%>" size="45" readonly class="readonly">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        
                                                <td height="20" width="9%">Receive 
                                                  In</td>
                                                                                                        
                                                <td height="20" colspan="2" width="42%" class="comment"> 
                                                  <select name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>">
                                                                                                                <%
            Vector locations = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_TYPE] + "='" + DbLocation.TYPE_WAREHOUSE + "'", "code");
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    if (receive.getLocationId() == d.getOID()) {
                        ig.setReceiveIn(d.getCode() + " - " + d.getName());
                    }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (receive.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%" valign="top">&nbsp;&nbsp;Address</td>
                                                                                                        
                                                <td height="20" width="37%"> 
                                                  <textarea name="vnd_address" rows="2" cols="45" readOnly class="readOnly"><%=vnd.getAddress()%></textarea>
                                                                                                        </td>
                                                                                                        
                                                <td width="9%" height="20">Doc 
                                                  Number</td>
                                                                                                        
                                                <td colspan="2" class="comment" width="42%" height="20"> 
                                                  <%
            String number = "";
            if (receive.getOID() == 0) {
                int ctr = DbReceive.getNextCounter();
                number = DbReceive.getNextNumber(ctr);
                ig.setDocNumber(number);
            } else {
                number = receive.getNumber();
                ig.setDocNumber(number);
            }
                                                                                                            %>
                                                  <%=number%></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;DO 
                                                                                                        Number</td>
                                                                                                        
                                                <td height="21" width="37%"> 
                                                  <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_DO_NUMBER]%>" value="<%=receive.getDoNumber()%>">
                                                                                                            <%=jspReceive.getErrorMsg(JspReceive.JSP_DO_NUMBER)%> 
                                                                                                            <%ig.setDoNumber(receive.getDoNumber());%>
                                                                                                        </td>
                                                                                                        
                                                <td width="9%">Currency</td>
                                                                                                        
                                                <td colspan="2" class="comment" width="42%"> 
                                                  <%
            if (receive.getPurchaseId() == 0) {

                Vector currs = DbCurrency.list(0, 0, "", "");
                Vector exchange_value = new Vector(1, 1);
                Vector exchange_key = new Vector(1, 1);
                String sel_exchange = "" + receive.getCurrencyId();
                if (currs != null && currs.size() > 0) {
                    for (int i = 0; i < currs.size(); i++) {
                        Currency d = (Currency) currs.get(i);
                        exchange_key.add("" + d.getOID());
                        exchange_value.add(d.getCurrencyCode());
                    }
                }
                                                                                                            %>
                                                  <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_CURRENCY_ID], null, sel_exchange, exchange_key, exchange_value, "onchange=\"javascript:checkRate()\"", "formElemen") %> 
                                                  <%} else {
                                                                                                                Currency curr = new Currency();
                                                                                                                try {
                                                                                                                    curr = DbCurrency.fetchExc(receive.getCurrencyId());
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            %>
                                                  <b><%=curr.getCurrencyCode()%></b> 
                                                  <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_CURRENCY_ID]%>" value="<%=receive.getCurrencyId()%>">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Invoice 
                                                                                                        Number </td>
                                                                                                        
                                                <td height="21" width="37%"> 
                                                  <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_INVOICE_NUMBER]%>" value="<%=receive.getInvoiceNumber()%>">
                                                                                                            <%=jspReceive.getErrorMsg(JspReceive.JSP_INVOICE_NUMBER)%> 
                                                                                                            <%ig.setInvoiceNumber(receive.getInvoiceNumber());%>
                                                                                                        </td>
                                                                                                        
                                                <td width="9%">Status</td>
                                                                                                        
                                                <td colspan="2" class="comment" width="42%"> 
                                                  <%
            if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){
                if (receive.getStatus() == null || receive.getStatus().length() == 0) {
                    receive.setStatus(I_Project.DOC_STATUS_DRAFT);
                }
            }else{
                receive.setStatus(I_Project.DOC_STATUS_APPROVED);                                                                                                
            }
                                                                                                            
                                                                                                            %>
                                                  <%if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){%>
                                                  <input type="text" class="readOnly" name="stt" value="<%=(receive.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((receive.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : receive.getStatus())%>" size="15" readOnly>
                                                                                                            <%}else{%>
                                                                                                                <input type="text" class="readOnly" name="stt" value="<%=I_Project.DOC_STATUS_APPROVED%>" size="15" readOnly>
                                                                                                             <%}%>   
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                                                                        
                                                <td height="21" width="37%"> 
                                                  <input name="<%=JspReceive.colNames[JspReceive.JSP_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDate() == null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%ig.setDate(receive.getDate());%>
                                                                                                        </td>
                                                                                                        
                                                <td width="9%">Applay VAT</td>
                                                                                                        
                                                <td colspan="2" class="comment" width="42%"> 
                                                  <%
            if (receive.getPurchaseId() == 0) {
                Vector include_value = new Vector(1, 1);
                Vector include_key = new Vector(1, 1);
                String sel_include = "" + receive.getIncluceTax();
                ig.setApplayVat(receive.getIncluceTax());
                include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_NO]);
                include_key.add("" + DbReceive.INCLUDE_TAX_NO);
                include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_YES]);
                include_key.add("" + DbReceive.INCLUDE_TAX_YES);
                                                                                                            %>
                                                  <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX], null, sel_include, include_key, include_value, "onChange=\"javascript:cmdVatEdit()\"", "formElemen") %> 
                                                  <%} else {%>
                                                  <b><%=DbReceive.strIncludeTax[receive.getIncluceTax()]%> 
                                                  </b> 
                                                  <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>" value="<%=receive.getIncluceTax()%>">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Payment 
                                                                                                        Type </td>
                                                                                                        
                                                <td height="21" width="37%"> 
                                                  <%
            Vector payment_value = new Vector(1, 1);
            Vector payment_key = new Vector(1, 1);
            String sel_payment = "" + receive.getPaymentType();
            ig.setPaymentType("" + receive.getPaymentType());
            payment_key.add(I_Project.PAYMENT_TYPE_CASH);
            payment_value.add(I_Project.PAYMENT_TYPE_CASH);
            payment_key.add(I_Project.PAYMENT_TYPE_CREDIT);
            payment_value.add(I_Project.PAYMENT_TYPE_CREDIT);
                                                                                                            %>
                                                  <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_PAYMENT_TYPE], null, sel_payment, payment_key, payment_value, "", "formElemen") %> 
                                                </td>
                                                                                                        
                                                <td width="9%">Term Of Payment</td>
                                                                                                        
                                                <td width="42%" colspan="2" class="comment"> 
                                                  <input name="<%=JspReceive.colNames[JspReceive.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDueDate() == null) ? new Date() : receive.getDueDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DUE_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%ig.setTermOfPayment(receive.getDueDate());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                    <td height="5" colspan="5"></td>
                                                                                                    <tr align="left"> 
                                                                                                    <td height="21" width="12%" valign="top">&nbsp;&nbsp;Notes</td>
                                                                                                    <td height="21" colspan="4"> 
                                                                                                        <textarea name="<%=JspReceive.colNames[JspReceive.JSP_NOTE]%>" cols="55" rows="2"><%=receive.getNote()%></textarea>
                                                                                                        <%ig.setNotes(receive.getNote());%>
                                                                                                    </td>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(iJSPCommand, jspReceiveItem, receiveItem, purchItems, oidReceiveItem, approot, receive.getVendorId(), iErrCode2, receive.getStatus(), isView, vErr, useStockCode, (receiveItem.getQty() * purchase_stock_qty ) , vStockCode, isSave, receive, isRefresh, opt_stock_code, useExpiredDate, itemMasterId);
            String strList = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
                                                                                                            %>
                                                                                                            <%=strList%> 
                                                                                                            <% session.putValue("PURCHASE_DETAIL", rptObj);%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr>
                                                                                                                <%if (iJSPCommand == JSPCommand.CONFIRM) {%>
                                                                                                                <tr>
                                                                                                                    <td>
                                                                                                                        <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                            <tr>
                                                                                                                                <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                                                <td width="200" nowrap><font color = "#FFFFFF">Delete success</font></td>
                                                                                                                            </tr>
                                                                                                                        </table>                                                                                                                                    
                                                                                                                    </td>
                                                                                                                </tr> 
                                                                                                                <%}%>
                                                                                                                <tr> 
                                                                                                                    <td width="38%" valign="middle"> 
                                                                                                                        <%
                                              
            
            if ((receive.getPurchaseId() == 0 && receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO") ) {%>
                                                                                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <%
                                                                                                                                        if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.LOAD ||
                                                                                                                                                (iJSPCommand == JSPCommand.EDIT && oidReceiveItem != 0) ||
                                                                                                                                                iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                    <%
                                                                                                                                ctrLine = new JSPLine();
                                                                                                                                ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                                ctrLine.initDefault();
                                                                                                                                ctrLine.setTableWidth("80%");
                                                                                                                                String scomDel = "javascript:cmdAsk('" + oidReceiveItem + "')";
                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidReceiveItem + "')";
                                                                                                                                String scancel = "javascript:cmdBack('" + oidReceiveItem + "')";
                                                                                                                                String ssave = "javascript:cmdSave('" + oidReceiveItem + "')";
                                                                                                                                ctrLine.setBackCaption("Back to List");
                                                                                                                                ctrLine.setJSPCommandStyle("buttonlink");
                                                                                                                                ctrLine.setDeleteCaption("Delete");

                                                                                                                                ctrLine.setOnMouseOut("MM_swapImgRestore()");
                                                                                                                                ctrLine.setOnMouseOverSave("MM_swapImage('save_item','','" + approot + "/images/save2.gif',1)");
                                                                                                                                ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save_item\" height=\"22\" border=\"0\">");

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

                                                                                                                                ctrLine.setSaveJSPCommand(ssave);

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

                                                                                                                                int err = 0;
                                                                                                                                if ((iJSPCommand == JSPCommand.DELETE) || (iJSPCommand == JSPCommand.SAVE) && (iErrCode == 0 && iErrCode2 == 0)) {
                                                                                                                                    ctrLine.setAddCaption("");
                                                                                                                                    ctrLine.setCancelCaption("");
                                                                                                                                    ctrLine.setBackCaption("");
                                                                                                                                    msgString = "Data is Saved";
                                                                                                                                    err = 0;
                                                                                                                                } else {
                                                                                                                                    msgString = "Data incomplete";
                                                                                                                                    if (iErrCode != 0) {
                                                                                                                                        err = iErrCode;
                                                                                                                                    } else if (iErrCode2 != 0) {
                                                                                                                                        err = iErrCode2;
                                                                                                                                    }
                                                                                                                                }

                                                                                                                                if (vendorItems == null || vendorItems.size() == 0) {
                                                                                                                                    ctrLine.setSaveCaption("");
                                                                                                                                }

                                                                                                                                if (iJSPCommand == JSPCommand.LOAD) {
                                                                                                                                    if (oidReceiveItem == 0) {
                                                                                                                                        iJSPCommand = JSPCommand.ADD;
                                                                                                                                    } else {
                                                                                                                                        iJSPCommand = JSPCommand.EDIT;
                                                                                                                                    }
                                                                                                                                }

                                                                                                                                    %>
                                                                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, err, msgString)%> </td>
                                                                                                                            </tr>
                                                                                                                            <%} else {%>
                                                                                                                            <tr> 
                                                                                                                                <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <%if (msgSuccsess.length() > 0) {%>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                                        <tr>
                                                                                                                                            <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                                                            <td width="200" nowrap><%=msgSuccsess%></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr> 
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="55%"> 
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
                                                                                                                                        <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(subTotal, "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setSubTotal(subTotal);%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="60%"> 
                                                                                                                                    <div align="right"><b>Discount</b></div>
                                                                                                                                </td>
                                                                                                                                <td width="17%"> 
                                                                                                                                    <div align="center"> 
                                                                                                                                    <input name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=receive.getDiscountPercent()%>" size="5" style="text-align:center" onBlur="javascript:calculateAmount()" onClick="this.select()" <%if (receive.getPurchaseId() != 0) {%>readonly class="readonly"<%}%>>
                                                                                                                                           % </div>
                                                                                                                                    <%ig.setDiscount1(receive.getDiscountPercent());%>
                                                                                                                                </td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setDiscount2(receive.getDiscountTotal());%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="60%"> 
                                                                                                                                    <div align="right"><b>VAT</b></div>
                                                                                                                                </td>
                                                                                                                                <td width="17%"> 
                                                                                                                                    <div align="center"> 
                                                                                                                                        <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>" size="5" value="<%=receive.getTaxPercent()%>" readOnly class="readOnly" style="text-align:center">
                                                                                                                                    % </div>
                                                                                                                                    <%ig.setVat1(receive.getTaxPercent());%>
                                                                                                                                </td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(receive.getTotalTax(), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setVat2(receive.getTotalTax());%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="60%"> 
                                                                                                                                    <div align="right"><b>Grand 
                                                                                                                                    Total</b></div>
                                                                                                                                </td>
                                                                                                                                <td width="17%">&nbsp;</td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(receive.getTotalAmount() + receive.getTotalTax() + receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setGrandTotal(receive.getTotalAmount() + receive.getTotalTax() - receive.getDiscountTotal());%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="60%">&nbsp;</td>
                                                                                                                                <td width="17%">&nbsp;</td>
                                                                                                                                <td width="23%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>                                                                                                                  
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="4"> 
                                                                                                                        <%if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0 && !receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%if (!receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%"><b>Set Status to</b></td>
                                                                                                                                <td width="14%"> 
                                                                                                                                    <select name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                                        <%if (posApprove1Priv) {%>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                                        <%}%>
                                                                                                                                        <%if (posApprove2Priv && 1 == 2) {%>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CHECKED%></option>
                                                                                                                                        <%}%>
                                                                                                                                        <%if (posApprove4Priv && 1 == 2) {%>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_CLOSE%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CLOSE%></option>
                                                                                                                                        <%}%>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="closingreason">
                                                                                                                            <tr> 
                                                                                                                                <td >&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%


                                                                                                                %>
                                                                                                                
                                                                                                                <%if (iJSPCommand == JSPCommand.SUBMIT) {%>
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
                                                                                                                <%} else {
    if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0) {
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" class="errfont"></td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%if (vendorItems != null && vendorItems.size() > 0) {
        if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0) {
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <%if (!receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){%>
                                                                                                                    <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                                                                                    <td width="102" > 
                                                                                                                        <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <% if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
                                                                                                                        <td width="102" > 
                                                                                                                        <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                                                                                         </td>
                                                                                                                        <%}%>
                                                                                                                    <td width="97"> 
                                                                                                                        <div align="left"><a href="javascript:cmdPrintDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <td width="862"> 
                                                                                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}
} else {%>
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" nowrap> 
                                                                                                                        <div align="left"><font color="#FF0000"><i>No 
                                                                                                                        receive item for vendor</i></font></div>
                                                                                                                    </td>
                                                                                                                    <td width="97"> 
                                                                                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close211112" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <td width="862"> 
                                                                                                                        <div align="left"></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}%>
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
                                                                                                    <%if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
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
                                                                                                                    <td width="33%" class="tablecell1"><i>Prepared 
                                                                                                                    By</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    User u = new User();
    try {
        u = DbUser.fetch(receive.getUserId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(receive.getDate(), "dd MMMM yy")%></i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Approved by</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(receive.getApproval1());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (receive.getApproval1() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(receive.getApproval1Date(), "dd MMMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Checked 
                                                                                                                    by</i> </td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(receive.getApproval2());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                                <%if (receive.getApproval2() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(receive.getApproval2Date(), "dd MMMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
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
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <script language="JavaScript">
                                                                calculateAmount();
                                                                cmdVendorChange();
                                                                parserMaster2();
                                                         <%if (iErrCode2 == 0 && (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && receiveItem.getOID() != 0) || iErrCode != 0))) {
                if (vendorItems != null && vendorItems.size() > 0) {
                                                         %>
                                                             parserMaster2();
                                                         <%}
            }%>
                                                            </script>
                                                            <script language="JavaScript">
                                                                <%if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && receiveItem.getOID() != 0) || iErrCode != 0)) {%>
                                                                <%}%>
                                                            </script>
                                                            
                                                            <%
            session.putValue("PURCHASE_TITTLE", ig);
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
