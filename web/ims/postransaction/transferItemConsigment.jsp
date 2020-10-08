
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
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
    public Vector drawList(int iJSPCommand, JspTransferItem frmObject,
            TransferItem objEntity, Vector objectClass,
            long transferItemId, String approot, long oidFromLocationId,
            int iErrCode2, String status, boolean useStockCode, Vector listStockCode, Transfer transfer, boolean isSave, boolean optionalCode, long itemMasterId) {
        
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Code - Name", "35%");
        jsplist.addHeader("Price", "10%");
        jsplist.addHeader("Qty Stock", "7%");
        jsplist.addHeader("Qty Trans.", "10%");
        jsplist.addHeader("Total", "10%");
        jsplist.addHeader("Unit", "7%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

        Vector vectVendMaster = DbStock.getStock(oidFromLocationId,DbStock.TYPE_CONSIGMENT);

        Vector vect_value = new Vector(1, 1);
        Vector vect_key = new Vector(1, 1);

        if (vectVendMaster != null && vectVendMaster.size() > 0) {

            for (int i = 0; i < vectVendMaster.size(); i++) {

                Stock stock = (Stock) vectVendMaster.get(i);
                ItemMaster im = new ItemMaster();

                try {
                    im = DbItemMaster.fetchExc(stock.getItemMasterId());
                    ItemGroup ig = DbItemGroup.fetchExc(im.getItemGroupId());
                    vect_key.add(ig.getName() + " / " + im.getName() + " / " + im.getCode());
                    vect_value.add("" + stock.getItemMasterId());
                } catch (Exception e) {}
            }
        }

        Vector temp = new Vector();
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

            TransferItem transferItem = (TransferItem) objectClass.get(i);

            RptTranferL detail = new RptTranferL();

            rowx = new Vector();

            if (transferItemId == transferItem.getOID()) {
                index = i;
            }

            if ((iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.ASK || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0))) )  {
                isEdit = true;
                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                //objEntity.setItemMasterId(itemMasterId);
                if (vectVendMaster != null && vectVendMaster.size() > 0) {

                    String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                    ItemMaster colCombo2  = new ItemMaster();
                
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                                
			}catch(Exception e) {
				System.out.println(e);
			}
                    //strVal += "<tr><td colspan=\"3\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspTransferItem.JSP_ITEM_MASTER_ID], null, "" + objEntity.getItemMasterId(), vect_value, vect_key, "onchange=\"javascript:parserMasterLoop()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID) + "</div></td></tr>";
                    strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"35\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                    if (useStockCode) {

                        strVal += "<tr><td colspan=\"3\" height=\"10\"></td></tr>";

                        strVal += "<tr><td colspan=\"3\"><table width=\"300\" cellpadding=\"0\" cellspacing=\"1\" border=\"0\">" +
                                "<tr>" +
                                "<td width=\"15\" class = \"tablehdr\" align=\"center\">No</td>" +
                                "<td class = \"tablehdr\" align=\"center\">Stock Code</td>" +
                                "<td width = \"30\" class = \"tablehdr\" align=\"center\">Action</td>" +
                                "</tr>";

                        if (listStockCode != null && listStockCode.size() > 0){

                            int pg = 1;

                            for (int xxSt = 0; xxSt < listStockCode.size(); xxSt++){

                                String style = "";
                                if (xxSt % 2 == 0){
                                    style = "tablecell";
                                } else {
                                    style = "tablecell1";
                                }

                                StockCode stockCD = new StockCode();

                                try {
                                    stockCD = (StockCode) listStockCode.get(xxSt);
                                } catch (Exception e) {}

                                strVal += "<tr>" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + xxSt + "\" value=\"" + stockCD.getOID() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + xxSt + "\" value=\"" + objEntity.getItemMasterId() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + xxSt + "\" value=\"" + transfer.getOID() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + xxSt + "\" value=\"" + objEntity.getOID() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + xxSt + "\" value=\"" + stockCD.getCode() + "\">" +
                                        "<td width=\"15\" class =\"" + style + "\" align=\"center\">" + pg + "</td>" +
                                        "<td class =\"" + style + "\" align=\"left\">&nbsp;" + stockCD.getCode() + "</td>" +
                                        "<td class =\"" + style + "\" align=\"center\">" +
                                        "<a href=\"javascript:cmdDelStockCode('" + xxSt + "')\">Delete</a>" +
                                        "</td>" +
                                        "</tr>";
                                pg++;

                            }
                        }

                        int sumQty = 0;

                        for (int iyQty = 0; iyQty < objEntity.getQty(); iyQty++){
                            sumQty++;
                        }
                        
                        
                        if (listStockCode.size() < sumQty && isSave){
                            if(optionalCode == false){
                                strVal += "<tr>" +
                                    "<td colspan=\"3\">" +
                                    "<font color=\"FF0000\">Data stock code incomplete</font>" +
                                    "</td>" +
                                    "</tr>";
                            }
                        }

                        if (sumQty > listStockCode.size()){
                            strVal += "<tr>"+
                                    "<td colspan=\"3\">" +
                                    "<input type=\"hidden\" name=\"OID_STOCK_CODE\" value =\"\">" +
                                    "<a href=\"javascript:cmdAddStockCode()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('new21','','../images/add.gif',1)\"><img src=\"../images/add2.gif\" name=\"new21\" height=\"22\" border=\"0\" style=\"padding:0px\"></a>" +
                                    "</td>" +
                                    "</tr>";
                        }

                        strVal += "</table></td></tr>";

                    }

                    strVal += "<tr><td></td><td></td><td></td></tr>";
                    strVal += "</table>";

                    rowx.add(strVal);
                
                } else {
                    rowx.add("<font color=\"red\">No item stock available for transfer</font>");
                }

                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"20\" name=\"" + frmObject.colNames[JspTransferItem.JSP_PRICE] + "\" value=\"" + JSPFormater.formatNumber(objEntity.getPrice(), "#,###.##") + "\" class=\"formElemen\" style=\"text-align:right\">" + frmObject.getErrorMsg(frmObject.JSP_PRICE) + "</div>");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"stock_qty\" value=\"" + transferItem.getQty() + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + frmObject.getErrorMsg(frmObject.JSP_QTY) + "</div>");
                if(useStockCode){
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspTransferItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" onChange=\"javascript:viewStockCodeEdit('" + transfer.getOID() + "','" + objEntity.getOID() + "')\">" + "</div>");
                }else{
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspTransferItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" >" + "</div>");
                }
                
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspTransferItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div><input type=\"hidden\" name=\"temp_item_amount\" value=\"" + objEntity.getAmount() + "\">");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");

            } else {

                ItemMaster itemMaster = new ItemMaster();
                ItemGroup ig = new ItemGroup();
                ItemCategory ic = new ItemCategory();
                try {
                    itemMaster = DbItemMaster.fetchExc(transferItem.getItemMasterId());
                    ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                    ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                } catch (Exception e) {
                }

                Uom uom = new Uom();
                Stock stock = new Stock();
                Vector stockItems = DbStock.getStock(oidFromLocationId,DbStock.TYPE_CONSIGMENT);

                try {
                    uom = DbUom.fetchExc(itemMaster.getUomStockId());
                    for(int j=0; j < stockItems.size();j++){
                        stock = (Stock) stockItems.get(j);
                        if(stock.getItemMasterId()==itemMaster.getOID()){
                            break;
                        }
                    }
                } catch (Exception e) {
                }

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                if (((status != null && status.equals(I_Project.DOC_STATUS_DRAFT))&& DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES"))||DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                    rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(transferItem.getOID()) + "')\">" + ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode() + "</a>");
                    detail.setName(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                } else {
                    rowx.add(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                    detail.setName(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                }
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") + "</div>");
                detail.setPrice(transferItem.getAmount());
                rowx.add("<div align=\"center\">" + stock.getQty() + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(transferItem.getQty(), "#,###.##") + "</div>");
                detail.setQty(transferItem.getQty());
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(transferItem.getAmount(), "#,###.##") + "</div>");
                detail.setTotal(transferItem.getAmount());
                rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
            }

            lstData.add(rowx);
            temp.add(detail);
        }

        rowx = new Vector();

        if (iJSPCommand != JSPCommand.POST && isEdit == false && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && transferItemId == 0))) {
        //masuk
            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");
            objEntity.setItemMasterId(itemMasterId);
            if (vectVendMaster != null && vectVendMaster.size() > 0){

                String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                ItemMaster colCombo2  = new ItemMaster();
                
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                                
			}catch(Exception e) {
				System.out.println(e);
			}
                
                //strVal += "<tr><td colspan=\"3\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspTransferItem.JSP_ITEM_MASTER_ID], null, "" + objEntity.getItemMasterId(), vect_value, vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID) + "</div></td></tr>";
                strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"35\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                if (useStockCode){

                    strVal += "<tr><td colspan=\"3\" height=\"10\"></td></tr>";

                    strVal += "<tr><td colspan=\"3\"><table width=\"300\" cellpadding=\"0\" cellspacing=\"1\" border=\"0\">" +
                            "<tr>" +
                            "<td width=\"15\" class = \"tablehdr\" align=\"center\">No</td>" +
                            "<td class = \"tablehdr\" align=\"center\">Stock Code</td>" +
                            "<td width = \"30\" class = \"tablehdr\" align=\"center\">Action</td>" +
                            "</tr>";

                    if (listStockCode != null && listStockCode.size() > 0) {

                        int pg = 1;

                        for (int xxSt = 0; xxSt < listStockCode.size(); xxSt++) {

                            String style = "";
                            if (xxSt % 2 == 0) {
                                style = "tablecell";
                            } else {
                                style = "tablecell1";
                            }

                            StockCode stockCD = new StockCode();

                            try {
                                stockCD = (StockCode) listStockCode.get(xxSt);
                            } catch (Exception e) {}

                            strVal += "<tr>" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + xxSt + "\" value=\"" + stockCD.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + xxSt + "\" value=\"" + objEntity.getItemMasterId() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + xxSt + "\" value=\"" + transfer.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + xxSt + "\" value=\"" + objEntity.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + xxSt + "\" value=\"" + stockCD.getCode() + "\">" +
                                    "<td width=\"15\" class =\"" + style + "\" align=\"center\">" + pg + "</td>" +
                                    "<td class =\"" + style + "\" align=\"left\">&nbsp;" + stockCD.getCode() + "</td>" +
                                    "<td class =\"" + style + "\" align=\"center\">" +
                                    "<a href=\"javascript:cmdDelStockCode('" + xxSt + "')\">Delete</a>" +
                                    "</td>" +
                                    "</tr>";
                            pg++;
                        }
                    }

                    int sumQty = 0;

                    for (int iyQty = 0; iyQty < objEntity.getQty(); iyQty++){
                        sumQty++;
                    }

                    if (listStockCode.size() < sumQty && isSave){
                        if(optionalCode == false){
                            strVal += "<tr>" +
                                "<td colspan=\"3\">" +
                                "<font color=\"FF0000\">Data stock code incomplete</font>" +
                                "</td>" +
                                "</tr>";
                        }
                    }

                    if (sumQty > listStockCode.size()) {
                        strVal += "<tr>" +
                                "<td colspan=\"3\">" +
                                "<input type=\"hidden\" name=\"OID_STOCK_CODE\" value =\"\">" +
                                "<a href=\"javascript:cmdAddStockCode()\" onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('new21','','../images/add.gif',1)\"><img src=\"../images/add2.gif\" name=\"new21\" height=\"22\" border=\"0\" style=\"padding:0px\"></a>" +
                                "</td>" +
                                "</tr>";
                    }

                    strVal += "</table></td></tr>";

                }

                strVal += "<tr><td></td><td></td><td></td></tr>";
                strVal += "</table>";

                rowx.add(strVal);

            } else {

                rowx.add("<font color=\"red\">No stock item available for transfer</font>");

            }

            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" readonly name=\"" + frmObject.colNames[JspTransferItem.JSP_PRICE] + "\" value=\"" + JSPFormater.formatNumber(objEntity.getPrice(), "#,###.##") + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\">" + frmObject.getErrorMsg(frmObject.JSP_PRICE) + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"stock_qty\" readonly value=\"" + ((objEntity.getQty() == 0) ? 1 : objEntity.getQty()) + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + frmObject.getErrorMsg(frmObject.JSP_QTY) + "</div>");
            if(useStockCode){
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspTransferItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" onChange=\"javascript:viewStockCode()\" >" + "</div>");
            }else{
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspTransferItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" >" + "</div>");
            }
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" readonly name=\"" + frmObject.colNames[JspTransferItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
        }

        lstData.add(rowx);

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        return v;
    }
%>

<%

            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }

            if (session.getValue("DETAIL") != null) {
                session.removeValue("DETAIL");
            }

            if (session.getValue("TRANSFER_TITTLE") != null) {
                session.removeValue("TRANSFER_TITTLE");
            }

            if (session.getValue("TRANSFER_DETAIL") != null) {
                session.removeValue("TRANSFER_DETAIL");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidTransfer = JSPRequestValue.requestLong(request, "hidden_transfer_id");
            long oidTransferItem = JSPRequestValue.requestLong(request, "hidden_transfer_item_id");
            int countStockCode = JSPRequestValue.requestInt(request, "hidden_count_stock_code");
            int idxStockCodeDel = JSPRequestValue.requestInt(request, "hidden_oid_stock_code_del");
            int stockDel = JSPRequestValue.requestInt(request, "hidden_del_stock");
            long oidLocationFrom = JSPRequestValue.requestLong(request, "hidden_locationIdFrom");
            long oidLocationTo =JSPRequestValue.requestLong(request, "hidden_locationIdTo");
            long itemMasterId = JSPRequestValue.requestLong(request, JspTransferItem.colNames[JspTransferItem.JSP_ITEM_MASTER_ID]);
            
            boolean isEdit = false;
            boolean isRefresh = false;
            if (iJSPCommand == JSPCommand.EDIT) {
                isEdit = true;
            }
            
            
            Vector listStockCode = new Vector();

            if (countStockCode > 0) {
                for (int dSc = 0; dSc < countStockCode; dSc++) {
                    StockCode tmpStockCode = new StockCode();
                    tmpStockCode.setOID(JSPRequestValue.requestLong(request, "" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + dSc));
                    tmpStockCode.setItemMasterId(JSPRequestValue.requestLong(request, "" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + dSc));
                    tmpStockCode.setTransferId(JSPRequestValue.requestLong(request, "" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + dSc));
                    tmpStockCode.setTransferItemId(JSPRequestValue.requestLong(request, "" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ITEM_ID] + "_" + dSc));
                    tmpStockCode.setCode(JSPRequestValue.requestString(request, "" + JspStockCode.colNames[JspStockCode.JSP_CODE] + "_" + dSc));
                    listStockCode.add(tmpStockCode);
                }
            }
            
            if (stockDel == 1) {

                for (int ixSc = 0; ixSc < listStockCode.size(); ixSc++) {

                    StockCode tStockCode = (StockCode) listStockCode.get(ixSc);

                    if (ixSc == idxStockCodeDel) {
                        listStockCode.remove(ixSc);
                        break;
                    }
                }
            }

            if (iJSPCommand == JSPCommand.REFRESH) {
                iJSPCommand = JSPCommand.EDIT;
                isRefresh = true;
            }
            
            if (iJSPCommand == JSPCommand.GET) {
                DbStockCode.deleteStockCodeByTransferItem(oidTransferItem);
                iJSPCommand = JSPCommand.VIEW;
            }

            if (stockDel == 2) {
                listStockCode = new Vector();
            }

            if (stockDel == 3) {
                DbStockCode.deleteStockCodeByTransferItem(oidTransferItem);
                listStockCode = new Vector();
            }

            String vStCode = JSPRequestValue.requestString(request, "OID_STOCK_CODE");

            if (vStCode.length() > 0) {

                StringTokenizer strTokenizerOutputDeliver = new StringTokenizer(vStCode, ",");

                while (strTokenizerOutputDeliver.hasMoreTokens()) {
                    StockCode stCode = new StockCode();
                    try {
                        long stockCodeId = Long.parseLong("" + strTokenizerOutputDeliver.nextToken());
                        stCode = DbStockCode.fetchExc(stockCodeId);
                    } catch (Exception e) {
                        System.out.println("[exception] fetching Stock Code " + e.toString());
                    }
                    stCode.setOID(0);
                    listStockCode.add(stCode);
                }
            }

            boolean isNone = false;
            boolean isView = false;
            boolean isAdd = false;
            boolean isLoad = false;

            if (iJSPCommand == JSPCommand.ADD) {
                isAdd = true;
                listStockCode = new Vector();
            }

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidTransfer = 0;
                isNone = true;
            }
            if (iJSPCommand == JSPCommand.LOAD) {
                
                isLoad = true;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            RptTranfer rptKonstan = new RptTranfer();

            CmdTransfer cmdTransfer = new CmdTransfer(request);
            JSPLine ctrLine = new JSPLine();

            iErrCode = cmdTransfer.action(iJSPCommand, oidTransfer);

            JspTransfer jspTransfer = cmdTransfer.getForm();
            Transfer transfer = cmdTransfer.getTransfer();
            //transfer.setFromLocationId(oidLocationFrom);
            
            msgString = cmdTransfer.getMessage();

            if (oidTransfer == 0) {
                oidTransfer = transfer.getOID();
                if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){
                    transfer.setStatus(I_Project.DOC_STATUS_DRAFT);
                }else{
                    transfer.setStatus(I_Project.DOC_STATUS_APPROVED);
                }
                
            }else{
                try{
                   transfer = DbTransfer.fetchExc(oidTransfer);
                   
                    
                }catch(Exception e){
                    
                }
            }

            whereClause = DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ID] + "=" + oidTransfer;
            orderClause = DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID];

            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            CmdTransferItem cmdTransferItem = new CmdTransferItem(request);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.REFRESH;
            }
            iErrCode2 = cmdTransferItem.action(iJSPCommand, oidTransferItem, oidTransfer, listStockCode.size());
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.EDIT;
            }
            JspTransferItem jspTransferItem = cmdTransferItem.getForm();
            TransferItem transferItem = cmdTransferItem.getTransferItem();
            msgString2 = cmdTransferItem.getMessage();

            if (transferItem.getOID() != 0 && isEdit) {

                listStockCode = new Vector();
                String whereSc = DbStockCode.colNames[DbStockCode.COL_TRANSFER_ITEM_ID] + " = " + transferItem.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_STATUS] + "=" + DbStockCode.STATUS_IN;
                listStockCode = DbStockCode.list(0, 0, whereSc, DbStockCode.colNames[DbStockCode.COL_CODE]);

            }

            whereClause = DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ID] + "=" + oidTransfer;
            orderClause = DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID];
            String msgSuccsess = "";
            Vector purchItems = DbTransferItem.list(0, 0, whereClause, orderClause);

            if (iJSPCommand == JSPCommand.VIEW) {
                isView = true;
                iJSPCommand = JSPCommand.ADD;
            }

            Vector vendors = new Vector();

            Vector locations = DbLocation.list(0, 0, "", "name");

            long fromOid = 0;
            
            
            if (transfer.getFromLocationId() == 0 && locations != null && locations.size() > 0) {
                transfer.setFromLocationId(oidLocationFrom);
            }
            if (transfer.getFromLocationId() == 0 && locations != null && locations.size() > 0) {
                Location lxx = (Location) locations.get(0);
                fromOid = lxx.getOID();
                transfer.setFromLocationId(lxx.getOID());
            }
            if (transfer.getFromLocationId() != 0 && locations != null && locations.size() > 0) {
                fromOid = transfer.getFromLocationId();
            }
            
            if(transfer.getToLocationId()==0 && locations != null && locations.size() > 0){
                transfer.setToLocationId(oidLocationTo);
            }
            
            

            Vector stockItems = DbStock.getStock(transfer.getFromLocationId(),DbStock.TYPE_CONSIGMENT);

            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                isSave = true;
            }

            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) {

                if (listStockCode != null && listStockCode.size() > 0) {

                    DbStockCode.deleteStockCodeByTransferItem(transferItem.getOID());

                    for (int ixSc = 0; ixSc < listStockCode.size(); ixSc++) {

                        StockCode objSc = new StockCode();

                        objSc = (StockCode) listStockCode.get(ixSc);

                        //if (objSc.getOID() == 0) { // jika stock masih kosong

                        StockCode objStockCodeFrom = new StockCode();
                        StockCode objStockCodeTo = new StockCode();

                        objStockCodeFrom = objSc;
                        objStockCodeTo = objSc;

                        //insert di transfer from
                        objStockCodeFrom.setInOut(DbStockCode.STOCK_OUT);
                        objStockCodeFrom.setLocationId(transfer.getFromLocationId());
                        objStockCodeFrom.setStatus(DbStockCode.STATUS_OUT);
                        objStockCodeFrom.setType(DbStockCode.TYPE_TRANSFER);
                        objStockCodeTo.setTransferId(transfer.getOID());
                        objStockCodeTo.setTransferItemId(transferItem.getOID());
                        objStockCodeFrom.setReceiveId(0);
                        objStockCodeFrom.setReceiveItemId(0);
                        objStockCodeFrom.setReturId(0);
                        objStockCodeFrom.setReturItemId(0);
                        objStockCodeFrom.setQty(1);
                        objStockCodeFrom.setType_item(DbStockCode.TYPE_CONSIGMENT);

                        try {
                            DbStockCode.insertExc(objStockCodeFrom);
                        } catch (Exception e) {
                        }

                        //insert di transfer to
                        objStockCodeTo.setInOut(DbStockCode.STOCK_IN);
                        objStockCodeTo.setLocationId(transfer.getToLocationId());
                        objStockCodeTo.setStatus(DbStockCode.STATUS_IN);
                        objStockCodeTo.setType(DbStockCode.TYPE_TRANSFER);
                        objStockCodeTo.setTransferId(transfer.getOID());
                        objStockCodeTo.setTransferItemId(transferItem.getOID());
                        objStockCodeTo.setReceiveId(0);
                        objStockCodeTo.setReceiveItemId(0);
                        objStockCodeTo.setReturId(0);
                        objStockCodeTo.setReturItemId(0);
                        objStockCodeTo.setQty(1);
                        objStockCodeFrom.setType_item(DbStockCode.TYPE_CONSIGMENT);
                        
                        try {
                            DbStockCode.insertExc(objStockCodeTo);
                        } catch (Exception e) {
                        }
                    //}
                    }
                }
                
               if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                   if(iJSPCommand==JSPCommand.SAVE){
                       iJSPCommand=JSPCommand.POST; 
                       iErrCode = cmdTransfer.action(iJSPCommand, oidTransfer);
                   }
               }
                
                listStockCode = new Vector();
                iJSPCommand = JSPCommand.ADD;
                oidTransferItem = 0;
                transferItem = new TransferItem();
                msgSuccsess = "Data is saved";
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidTransferItem = 0;
                transferItem = new TransferItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD) {
                try {
                    transfer = DbTransfer.fetchExc(oidTransfer);
                } catch (Exception e) {
                }
            }

            double subTotal = DbTransferItem.getTotalTransferAmount(oidTransfer);

            Vector vLocations = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " != " + fromOid, "name");

            Vector vErr = new Vector();

            String whereSCode = DbStockCode.colNames[DbStockCode.COL_TRANSFER_ID] + "=" + transfer.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_RECEIVE_ITEM_ID] + "=" + transferItem.getOID();

            Vector vStockCode = DbStockCode.list(0, 0, whereSCode, null);

            boolean useStockCode = false;
            boolean optionalCode = false;

            try {

                long oidTmpTransferItem = 0;

                if (isNone || isAdd || isSave || isLoad) {
                    try {
                        Stock stock = (Stock) stockItems.get(0);
                        ItemMaster im = new ItemMaster();
                        try {
                            im = DbItemMaster.fetchExc(stock.getItemMasterId());
                            oidTmpTransferItem = im.getOID();
                        } catch (Exception e) {}

                    } catch (Exception e) {
                    }
                } else {
                    oidTmpTransferItem = transferItem.getItemMasterId();
                }

                ItemMaster itemMaster = DbItemMaster.fetchExc(oidTmpTransferItem);

                if (itemMaster.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE || itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE){
                    useStockCode = true;
                }
                
                if(itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE){
                    optionalCode = true;
                }

            }catch(Exception e) {}

            String strStockId = "";

            if (listStockCode != null && listStockCode.size() > 0) {

                for (int uSc = 0; uSc < listStockCode.size(); uSc++) {

                    StockCode Codes = (StockCode) listStockCode.get(uSc);

                    if (strStockId.length() <= 0) {
                        strStockId = "" + Codes.getOID();
                    } else {
                        strStockId = strStockId + "," + Codes.getOID();
                    }
                }
            }
           
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RptTranferXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function checkTransfer(){
                    
                    var x = document.frmtransfer.<%=JspTransfer.colNames[JspTransfer.JSP_FROM_LOCATION_ID]%>.value;
                    var y = document.frmtransfer.<%=JspTransfer.colNames[JspTransfer.JSP_TO_LOCATION_ID]%>.value;
                    
                    if(x == y){
                        
       <%

            Vector vLocationx = DbLocation.list(0, 0, "", "name");
            if (vLocationx != null && vLocationx.size() > 0) {
                for (int i = 0; i < vLocationx.size(); i++) {

                    Location loc = (Location) vLocationx.get(i);

                    %>
                        var z = <%=loc.getOID()%>
                        if(z != x){
                            vLocations.add(loc);                                                    
                        }
                    <%
                }
            }
       %>
           alert('Can\'t transfer to the same target');
           
       }    
   }
   
   function cmdAddItemMaster(){   
        
            var oidLoc = document.frmtransfer.hidden_locationIdFrom.value;
            window.open("<%=approot%>/postransaction/addItemTransferConsigment.jsp?location_id=" + oidLoc , null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            
            document.frmtransfer.command.value="<%=JSPCommand.LOAD%>";
            document.frmtransfer.submit();    
        }
   
   function cmdPrintPdf(){
       window.open("<%=printroot%>.report.RptTransferOrderPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
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
       
       function parserMasterLoop(){
           
           var cfrm = confirm('Are you sure want to change group-name, and you will lose stock code datas ?');
           
           if(cfrm==true){
               
               var str = document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_ITEM_MASTER_ID]%>.value;
               
         <%if (stockItems != null && stockItems.size() > 0) {
                for (int i = 0; i < stockItems.size(); i++) {
                    Stock stock = (Stock) stockItems.get(i);

                    ItemMaster im = new ItemMaster();
                    try {
                        im = DbItemMaster.fetchExc(stock.getItemMasterId());
                    } catch (Exception ex) {
                    }

         %>
             if('<%=stock.getItemMasterId()%>'==str){
                 document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_PRICE]%>.value = <%=im.getCogs()%>;
                 document.frmtransfer.stock_qty.value = <%=stock.getQty()%>;
                 document.frmtransfer.unit_code.value="<%=stock.getUnit()%>";
             }
         <%}
            }%>
            
            calculateSubTotal();
            document.frmtransfer.command.value="<%=JSPCommand.GET%>";
            document.frmtransfer.action="transferItemConsigment.jsp";
            document.frmtransfer.submit();  
            
        }else{            
        document.frmtransfer.itm_JSP_ITEM_MASTER_ID.value="<%=transferItem.getItemMasterId()%>";
    }
}


function parserMaster(){
    var str = document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_ITEM_MASTER_ID]%>.value;
         <%if (stockItems != null && stockItems.size() > 0) {
                for (int i = 0; i < stockItems.size(); i++) {
                    Stock stock = (Stock) stockItems.get(i);

                    ItemMaster im = new ItemMaster();
                    try {
                        im = DbItemMaster.fetchExc(stock.getItemMasterId());
                    } catch (Exception ex) {
                    }

         %>
             if('<%=stock.getItemMasterId()%>'==str){
                 document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_PRICE]%>.value = <%=im.getCogs()%>;
                 document.frmtransfer.stock_qty.value = <%=stock.getQty()%>;
                 document.frmtransfer.unit_code.value="<%=stock.getUnit()%>";
             }
         <%}
            }%>
            calculateSubTotal();
            document.frmtransfer.command.value="<%=JSPCommand.VIEW%>";
            document.frmtransfer.action="transferItemConsigment.jsp";
            document.frmtransfer.submit();  
            
        }
        
        function parserMaster2(){
            var str = document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_ITEM_MASTER_ID]%>.value;
         <%if (stockItems != null && stockItems.size() > 0) {
                for (int i = 0; i < stockItems.size(); i++) {
                    Stock stock = (Stock) stockItems.get(i);

                    ItemMaster im = new ItemMaster();
                    try {
                        im = DbItemMaster.fetchExc(stock.getItemMasterId());
                    } catch (Exception ex) {
                    }

         %>
             if('<%=stock.getItemMasterId()%>'==str){
                 document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_PRICE]%>.value = <%=im.getCogs()%>;
                 document.frmtransfer.stock_qty.value = <%=stock.getQty()%>;
                 document.frmtransfer.unit_code.value="<%=stock.getUnit()%>";
             }
         <%}
            }%>
            calculateSubTotal();
        }
        
        
        function calculateSubTotal(){
            var price = document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_PRICE]%>.value;
            var qty = document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_QTY]%>.value;
            var stockQty =document.frmtransfer.stock_qty.value;
            
            amount = removeChar(price);
            amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            
            
            qty = removeChar(qty);
            qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_QTY]%>.value = qty;
            
            stockQty = removeChar(stockQty);
            stockQty = cleanNumberFloat(stockQty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmtransfer.stock_qty.value = stockQty;
            
            if(parseInt(qty)>parseInt(stockQty)){
                alert("The quantity is more than stock qty!");
                qty="0";
                document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_QTY]%>.value = qty;
            }
            
            var totalItemAmount = (parseFloat(amount) * parseFloat(qty));
            document.frmtransfer.<%=JspTransferItem.colNames[JspTransferItem.JSP_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
            
            var subtot = 0;
            subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
            
         <%
            //add
            if (oidTransferItem == 0) {%>
                    
                    <%} else {%>
                    
         <%}
         %>
             
             calculateAmount();
         }
         
         
         function cmdVatEdit(){
             
             calculateAmount();
         }
         
         function cmdLocation(){
             <%if (transfer.getOID() != 0 && purchItems != null && purchItems.size() > 0){%>
             if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all transfer item based on vendor item master. ')){
                 document.frmtransfer.hidden_transfer_id.value=0;
                 document.frmtransfer.hidden_transfer_item_id.value=0;
                 document.frmtransfer.command.value="<%=JSPCommand.LOAD%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             <%} else {%>
             document.frmtransfer.command.value="<%=JSPCommand.LOAD%>";
             document.frmtransfer.action="transferItemConsigment.jsp";
             document.frmtransfer.submit();
             <%}%>
         }
         
         function cmdToRecord(){
             document.frmtransfer.command.value="<%=JSPCommand.NONE%>";
             document.frmtransfer.action="transferlist.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdVendorChange(){
             var oid = document.frmtransfer.<%=JspTransfer.colNames[JspTransfer.JSP_FROM_LOCATION_ID]%>.value;
         <%
            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor v = (Vendor) vendors.get(i);
                         %>
                             if('<%=v.getOID()%>'==oid){
                                 document.frmtransfer.vnd_address.value="<%=v.getAddress()%>";
                             }
                         <%
                }
            }
         %>
             
         }
         
         function cmdDelStockCode(stockCodeId){
             
             if(confirm('Are sure you want delete this item ?')){
                 
                 document.frmtransfer.hidden_oid_stock_code_del.value=stockCodeId;
                 document.frmtransfer.hidden_del_stock.value=1;
                 document.frmtransfer.command.value="<%=JSPCommand.VIEW%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit(); 
             }
         
         }    
         
         function cmdAddStockCode(){            
             
             
             window.open("<%=approot%>/postransaction/addstockcode.jsp?locationId=<%=transfer.getFromLocationId()%>&maxStock=<%=transferItem.getQty()%>&stockReady=<%=listStockCode.size()%>&codes=<%=strStockId%>&transferId=<%=transfer.getOID()%>&type=<%=DbStockCode.TYPE_CONSIGMENT%>&itemMasterId=<%=transferItem.getItemMasterId()%>&transferItemId=<%=transferItem.getOID()%>", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
             }
             
             function viewStockCode(){
                 document.frmtransfer.command.value="<%=JSPCommand.VIEW%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();            
             }
             
             function viewStockCodeEdit(oidTransfer,oidTransferItem){
                 
                 var cfrm = confirm('Are you sure want to change qty transfer, and you will lose stock code data(s) ?');
                 
                 if(cfrm==true){
                     document.frmtransfer.hidden_transfer_id.value=oidTransfer;
                     document.frmtransfer.hidden_transfer_item_id.value=oidTransferItem;
                     document.frmtransfer.hidden_del_stock.value=2;
                     document.frmtransfer.command.value="<%=JSPCommand.REFRESH%>";
                     document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                     document.frmtransfer.action="transferItemConsigment.jsp";
                     document.frmtransfer.submit();            
                 }
                 
             }
             
             
             function calculateAmount(){}
             
             function cmdClosedReason(){}
             
             function cmdCloseDoc(){
                 document.frmtransfer.action="<%=approot%>/home.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdAskDoc(){
                 document.frmtransfer.hidden_transfer_item_id.value="0";
                 document.frmtransfer.command.value="<%=JSPCommand.SUBMIT%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdDeleteDoc(){
                 document.frmtransfer.hidden_transfer_item_id.value="0";
                 document.frmtransfer.command.value="<%=JSPCommand.CONFIRM%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdCancelDoc(){
                 document.frmtransfer.hidden_transfer_item_id.value="0";
                 document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdSaveDoc(){
                 document.frmtransfer.command.value="<%=JSPCommand.POST%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdAdd(){
                 document.frmtransfer.hidden_transfer_item_id.value="0";
                 document.frmtransfer.command.value="<%=JSPCommand.ADD%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdAsk(oidTransferItem){
                 document.frmtransfer.hidden_transfer_item_id.value=oidTransferItem;
                 document.frmtransfer.command.value="<%=JSPCommand.ASK%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdAskMain(oidTransfer){
                 document.frmtransfer.hidden_transfer_id.value=oidTransfer;
                 document.frmtransfer.command.value="<%=JSPCommand.ASK%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transfer.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdConfirmDelete(oidTransferItem){
                 document.frmtransfer.hidden_transfer_item_id.value=oidTransferItem;
                 document.frmtransfer.command.value="<%=JSPCommand.DELETE%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             function cmdSaveMain(){
                 document.frmtransfer.command.value="<%=JSPCommand.SAVE%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transfer.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdSave(){
                 document.frmtransfer.command.value="<%=JSPCommand.SAVE%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdEdit(oidTransfer){
                 document.frmtransfer.hidden_transfer_item_id.value=oidTransfer;
                 document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdCancel(oidTransfer){
                 document.frmtransfer.hidden_transfer_item_id.value=oidTransfer;
                 document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdBack(){
                 document.frmtransfer.command.value="<%=JSPCommand.BACK%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdListFirst(){
                 document.frmtransfer.command.value="<%=JSPCommand.FIRST%>";
                 document.frmtransfer.prev_command.value="<%=JSPCommand.FIRST%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdListPrev(){
                 document.frmtransfer.command.value="<%=JSPCommand.PREV%>";
                 document.frmtransfer.prev_command.value="<%=JSPCommand.PREV%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdListNext(){
                 document.frmtransfer.command.value="<%=JSPCommand.NEXT%>";
                 document.frmtransfer.prev_command.value="<%=JSPCommand.NEXT%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdListLast(){
                 document.frmtransfer.command.value="<%=JSPCommand.LAST%>";
                 document.frmtransfer.prev_command.value="<%=JSPCommand.LAST%>";
                 document.frmtransfer.action="transferItemConsigment.jsp";
                 document.frmtransfer.submit();
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
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenuconsigment.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menuconsigment.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmtransfer" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspTransfer.colNames[JspTransfer.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_transfer_item_id" value="<%=oidTransferItem%>">
                                                            <input type="hidden" name="hidden_transfer_id" value="<%=oidTransfer%>">
                                                            <input type="hidden" name="<%=JspTransferItem.colNames[JspTransferItem.JSP_TRANSFER_ID]%>" value="<%=oidTransfer%>">
                                                            <input type="hidden" name="hidden_oid_stock_code_del" value="<%=0%>">
                                                            <input type="hidden" name="hidden_del_stock" value="<%=0%>">
                                                            <input type="hidden" name="hidden_count_stock_code" value="<%=listStockCode.size()%>">
                                                            <input type="hidden" name="<%=JspTransfer.colNames[JspTransfer.JSP_TYPE]%>" value="<%=DbTransfer.TYPE_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspTransferItem.colNames[JspTransferItem.JSP_TYPE]%>" value="<%=DbTransferItem.TYPE_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM]%>" value="<%=DbTransfer.TYPE_CONSIGMENT%>">
                                                            <input type="hidden" name="hidden_locationIdFrom" value="<%=transfer.getFromLocationId()%>">
                                                            
                                                            <input type="hidden" name="hidden_locationIdTo" value="<%=transfer.getToLocationId()%>">
                                                            <%if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
                                                                <input type="hidden" name="<%=jspTransfer.colNames[jspTransfer.JSP_STATUS]%>" value="<%=transfer.getStatus()%>">
                                                            <%}%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                 <script language="JavaScript">
                                                                   parserMaster(); 
                                                                </script>
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Stock Managemenet 
                                                                                        </font><font class="tit1">&raquo; <span class="lvl2">Transfer 
                                                                                Stock </span></font></b></td>
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
                                                                                <td height="5"></td>
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
                                                                                                <div align="center">&nbsp;&nbsp;Transfer 
                                                                                                Stock &nbsp;&nbsp;</div>
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
                                                                                                        <td height="21" valign="middle" width="27%">&nbsp;</td>
                                                                                                        <td height="21" valign="middle" width="9%">&nbsp;</td>
                                                                                                        <td height="21" colspan="2" width="52%" class="comment" valign="top"> 
                                                                                                            <div align="right"><i>Date : 
                                                                                                                    <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                                                                                    <%if (transfer.getOID() == 0) {%>
                                                                                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                                                                                    <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(transfer.getUserId());
    } catch (Exception e) {
    }
                                                                                                                    %>
                                                                                                                    Prepared By : <%=us.getLoginId()%> 
                                                                                                                    <%}%>
                                                                                                            </i>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="26" width="12%">&nbsp;From</td>
                                                                                                        <td height="26" width="27%">
                                                                                                            <%if ((!transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES") ) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO") ) {%>												
                                                                                                            <span class="comment"> 
                                                                                                                <select name="<%=JspTransfer.colNames[JspTransfer.JSP_FROM_LOCATION_ID]%>" <%if (((!transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>onChange="javascript:cmdLocation()"<%}%>>
                                                                                                                        <%

    if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location d = (Location) locations.get(i);
            if (transfer.getFromLocationId() == d.getOID()) {
                rptKonstan.setFrom(d.getCode() + " - " + d.getName());
            }
                                                                                                                        %>
                                                                                                                        <option value="<%=d.getOID()%>" <%if (transfer.getFromLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                    <%}
    }%>
                                                                                                                </select>
                                                                                                            </span>
                                                                                                            <%} else {

                try {
                    Location l = DbLocation.fetchExc(transfer.getFromLocationId());
                    out.println(l.getCode() + " - " + l.getName());
                    rptKonstan.setFrom(l.getCode() + " - " + l.getName());
                } catch (Exception e) {
                }

            }%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                        </td>
                                                                                                        <td height="26" width="9%">Transfer 
                                                                                                        To</td>
                                                                                                        <td height="26" colspan="2" width="52%" class="comment"> 
                                                                                                            <%if ((!transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES") ) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO") ) {%>	
                                                                                                            <select name="<%=JspTransfer.colNames[JspTransfer.JSP_TO_LOCATION_ID]%>"<%if (((!transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO") ) {%>onChange="javascript:cmdLocation()"<%}%>>
                                                                                                                <%
    if (vLocations != null && vLocations.size() > 0) {
        for (int i = 0; i < vLocations.size(); i++) {
            Location d = (Location) vLocations.get(i);
            if (transfer.getToLocationId() == d.getOID()) {
                rptKonstan.setTo(d.getCode() + " - " + d.getName());
            }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (transfer.getToLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
    }%>
                                                                                                            </select>
                                                                                                            <%} else {
                try {
                    Location l = DbLocation.fetchExc(transfer.getToLocationId());
                    out.println(l.getCode() + " - " + l.getName());
                    rptKonstan.setTo(l.getCode() + " - " + l.getName());
                } catch (Exception e) {
                }
            }%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;Number</td>
                                                                                                        <td height="21" width="27%"> 
                                                                                                            <%
            String number = "";
            if (transfer.getOID() == 0) {
                int ctr = DbTransfer.getNextCounter();
                number = DbTransfer.getNextNumber(ctr);
                //prOrder.setPoNumber(number);
                rptKonstan.setNumber(number);
            } else {
                number = transfer.getNumber();
                //prOrder.setPoNumber(number);
                rptKonstan.setNumber(number);
            }
                                                                                                            %>
                                                                                                        <%=number%> </td>
                                                                                                        <td width="9%">Date</td>
                                                                                                        <td colspan="2" class="comment" width="52%">
                                                                                                            <input name="<%=JspTransfer.colNames[JspTransfer.JSP_DATE]%>" value="<%=JSPFormater.formatDate((transfer.getDate() == null) ? new Date() : transfer.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmtransfer.<%=JspTransfer.colNames[JspTransfer.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%
            rptKonstan.setTanggal(transfer.getDate());
                                                                                                            %> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%" valign="top">&nbsp;Notes</td>
                                                                                                        <td height="21" width="27%"> 
                                                                                                            <textarea name="<%=JspTransfer.colNames[JspTransfer.JSP_NOTE]%>" cols="40" rows="3"><%=transfer.getNote()%></textarea>
                                                                                                        </td>
                                                                                                        <td width="9%" valign="top">Status</td>
                                                                                                        <td colspan="2" class="comment" width="52%" valign="top"> 
                                                                                                            <%
            if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){                                                                                                
                if (transfer.getStatus() == null) {
                    transfer.setStatus(I_Project.DOC_STATUS_DRAFT);
                }
            }
                                                                                                            %>
                                                                                                            <% if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){ %>
                                                                                                                <input type="text" class="readOnly" name="stt" value="<%=(transfer.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((transfer.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : transfer.getStatus())%>" size="15" readOnly>
                                                                                                            <% }else{ %>
                                                                                                                <input type="text" class="readOnly" name="stt" value="<%=I_Project.DOC_STATUS_APPROVED%>" size="15" readOnly>
                                                                                                            <%}%>    
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
            rptKonstan.setNotes(transfer.getNote());
                                                                                                    %>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(iJSPCommand, jspTransferItem, transferItem, purchItems, oidTransferItem, approot, transfer.getFromLocationId(), iErrCode2, transfer.getStatus(), useStockCode, listStockCode, transfer, isSave, optionalCode, itemMasterId);
            String strString = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
                                                                                                            %>
                                                                                                            <%=strString%> 
                                                                                                            <% session.putValue("DETAIL", rptObj);%>
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
                                                                                                                <tr> 
                                                                                                                    <td width="45%" valign="middle"> 
                                                                                                                        <%if (((((stockItems != null && stockItems.size() > 0) && transfer.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) || iJSPCommand == JSPCommand.CONFIRM) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO") ) {%>
                                                                                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <%
    if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD ||
            (iJSPCommand == JSPCommand.EDIT && oidTransferItem != 0) ||
            iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                    <%
                                                                                                                                ctrLine = new JSPLine();
                                                                                                                                ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                                ctrLine.initDefault();
                                                                                                                                ctrLine.setTableWidth("80%");
                                                                                                                                String scomDel = "javascript:cmdAsk('" + oidTransferItem + "')";
                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidTransferItem + "')";
                                                                                                                                String scancel = "javascript:cmdBack('" + oidTransferItem + "')";
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
                                                                                                                                if ((iJSPCommand == JSPCommand.DELETE) || (iJSPCommand == JSPCommand.SAVE) && (iErrCode == 0) && (iErrCode2 == 0)) {
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

                                                                                                                                if (stockItems == null || stockItems.size() == 0) {
                                                                                                                                    ctrLine.setSaveCaption("");
                                                                                                                                }

                                                                                                                                if (iJSPCommand == JSPCommand.LOAD) {
                                                                                                                                    if (oidTransferItem == 0) {
                                                                                                                                        iJSPCommand = JSPCommand.ADD;
                                                                                                                                    } else {
                                                                                                                                        iJSPCommand = JSPCommand.EDIT;
                                                                                                                                    }
                                                                                                                                }

                                                                                                                                    %>
                                                                                                                                <%= ctrLine.drawImageOnly(iJSPCommand, err, msgString)%> </td>
                                                                                                                            </tr>
                                                                                                                            <%} else {%>
                                                                                                                            <%if(iJSPCommand == JSPCommand.CONFIRM && iErrCode == 0){%>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                                        <tr>
                                                                                                                                            <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                                                            <td width="100" nowrap ><font color="FFFFFF">Delete success</font></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <tr> 
                                                                                                                                <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            
                                                                                                                            <%if(msgSuccsess.length() > 0) {%>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0" cellpadding="5" cellspacing="0" class="success">
                                                                                                                                        <tr>
                                                                                                                                            <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                                                            <td width="100" nowrap ><font color="FFFFFF"><%=msgSuccsess%></font></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr> 
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="55%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (transfer.getOID() != 0 && purchItems != null && purchItems.size() > 0) {%>
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
                                                                                                                        <%if (transfer.getOID() != 0 && purchItems != null && purchItems.size() > 0) {%>
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="12%">&nbsp;</td>
                                                                                                                                <td width="14%">&nbsp;</td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%if ((!transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode != 0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%"><b>Set 
                                                                                                                                Status to</b> </td>
                                                                                                                                <td width="14%"> 
                                                                                                                                    <select name="<%=JspTransfer.colNames[JspTransfer.JSP_STATUS]%>">
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (transfer.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                                        <%if (posApprove1Priv) {%>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
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
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
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
                                                                                                                <%
} else {
    if (transfer.getOID() != 0 && purchItems != null && purchItems.size() > 0) {
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" class="errfont"></td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%if (stockItems != null && purchItems != null && purchItems.size() > 0) {
        if (transfer.getOID() != 0 && purchItems != null && purchItems.size() > 0) {
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <%if ((!transfer.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode != 0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES"))  {%>
                                                                                                                    <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                                                                                    <td width="102" > 
                                                                                                                        <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <td width="97"> 
                                                                                                                        <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <td width="862"> 
                                                                                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}
} else {%>
                                                                                                                <%if (false) {%>
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" nowrap> 
                                                                                                                        <div align="left"><font color="#FF0000"><i>No stock item available for transfer </i></font></div>
                                                                                                                    </td>
                                                                                                                    <td width="97"> 
                                                                                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close211112" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <td width="862"> 
                                                                                                                        <div align="left"></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}
    }%>
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
                                                                                                    <%if (transfer.getOID() != 0 && purchItems != null && purchItems.size() > 0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
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
        u = DbUser.fetch(transfer.getUserId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(transfer.getDate(), "dd MMMM yy")%></i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Approved 
                                                                                                                    by</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(transfer.getApproval1());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (transfer.getApproval1() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(transfer.getApproval1Date(), "dd MMMM yy")%> 
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
                                                         <%
            if (stockItems != null && stockItems.size() > 0) {
                if (((iErrCode2 == 0 && (transfer.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && transferItem.getOID() != 0) || iErrCode != 0))) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES") ) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")){%>
                        parserMaster2();
                                                         <%}
            }%>
                                                            </script>
                                                            <script language="JavaScript">
                                                                <%if (transfer.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && transferItem.getOID() != 0) || iErrCode != 0)) {%>
                                                                
                                                         <%}
            if (transfer.getOID() != 0 && !transfer.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {%>
                    
                    <%}%>
                                                            </script>
                                                            <%

                                                            %>
                                                        </form>
                                                        <%
            session.putValue("KONSTAN", rptKonstan);
                                                        %>
                                                        <span class="level2"><br>
                                                    </span><!-- #EndEditable --> </td>
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
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>
