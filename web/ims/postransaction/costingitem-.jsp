
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(int iJSPCommand, JspCostingItem frmObject,
            CostingItem objEntity, Vector objectClass,
            long costingItemId, String approot, long oidLocation,
            int iErrCode2, String status, boolean useStockCode, Vector listStockCode, Costing costing, boolean isSave, boolean optionalCode, long itemMasterId) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("80%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablearialhdr");
        jsplist.setCellStyle("tablearialcell");
        jsplist.setCellStyle1("tablearialcell1");
        jsplist.setHeaderStyle("tablearialhdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Code - Name", "45%");
        jsplist.addHeader("Price", "10%");
        jsplist.addHeader("Qty Costing", "10%");
        jsplist.addHeader("Total", "10%");
        jsplist.addHeader("Unit", "10%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

        int vectVendMaster = 1;

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
        double total = 0;
        for (int i = 0; i < objectClass.size(); i++) {

            CostingItem costingItem = (CostingItem) objectClass.get(i);
            RptCostingL detail = new RptCostingL();
            rowx = new Vector();
            if (costingItemId == costingItem.getOID()) {
                index = i;
            }

            if ((iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.ASK || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0)))) {
                isEdit = true;
                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                objEntity.setItemMasterId(itemMasterId);
                if (iJSPCommand == JSPCommand.ADD) {
                    objEntity.setItemMasterId(itemMasterId);
                } else if (iJSPCommand == JSPCommand.EDIT) {
                    objEntity.setItemMasterId(costingItem.getItemMasterId());
                }

                ItemMaster colCombo2 = new ItemMaster();
                if (vectVendMaster > 0) {

                    String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                    try {
                        colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                    } catch (Exception e) {
                        System.out.println(e);
                    }
                    strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:right\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + "\" class=\"readonly\" size=\"35\" readonly>" + "&nbsp;<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\">Search</a></td></tr>";
                    if (useStockCode) {

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
                                } catch (Exception e) {
                                }

                                strVal += "<tr>" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + xxSt + "\" value=\"" + stockCD.getOID() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + xxSt + "\" value=\"" + objEntity.getItemMasterId() + "\">" +
                                        "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + xxSt + "\" value=\"" + costing.getOID() + "\">" +
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
                        for (int iyQty = 0; iyQty < objEntity.getQty(); iyQty++) {
                            sumQty++;
                        }

                        if (listStockCode.size() < sumQty && isSave) {
                            if (optionalCode == false) {
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
                    rowx.add("<font color=\"red\">No item stock available for costing</font>");
                }

                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"20\" name=\"" + frmObject.colNames[JspCostingItem.JSP_PRICE] + "\" value=\"" + JSPFormater.formatNumber(colCombo2.getCogs(), "#,###.##") + "\" class=\"formElemen\" style=\"text-align:right\">" + frmObject.getErrorMsg(frmObject.JSP_PRICE) + "</div>");
                if (useStockCode) {
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspCostingItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" onChange=\"javascript:viewStockCodeEdit('" + costing.getOID() + "','" + objEntity.getOID() + "')\">" + "</div>");
                } else {
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspCostingItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" >" + "</div>");
                }

                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspCostingItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div><input type=\"hidden\" name=\"temp_item_amount\" value=\"" + objEntity.getAmount() + "\">");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");

            } else {

                ItemMaster itemMaster = new ItemMaster();
                ItemGroup ig = new ItemGroup();
                try {
                    itemMaster = DbItemMaster.fetchExc(costingItem.getItemMasterId());
                    ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                } catch (Exception e) {
                }

                Uom uom = new Uom();
                try {
                    uom = DbUom.fetchExc(itemMaster.getUomStockId());
                } catch (Exception e) {
                }

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                if (((status != null && status.equals(I_Project.DOC_STATUS_DRAFT)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                    rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(costingItem.getOID()) + "')\">" + ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode() + "</a>");
                    detail.setName("" + itemMaster.getName());
                    detail.setBarcode("" + itemMaster.getCode());
                } else {
                    rowx.add(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                    detail.setBarcode("" + itemMaster.getCode());
                    detail.setName("" + itemMaster.getName());
                }
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(costingItem.getPrice(), "#,###.##") + "</div>");
                detail.setPrice(costingItem.getPrice());
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(costingItem.getQty(), "#,###.##") + "</div>");
                detail.setQty(costingItem.getQty());
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(costingItem.getAmount(), "#,###.##") + "</div>");
                detail.setTotal(costingItem.getAmount());
                rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
                total = total + costingItem.getAmount();

            }

            lstData.add(rowx);
            temp.add(detail);
        }

        rowx = new Vector();

        if (iJSPCommand != JSPCommand.POST && isEdit == false && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && costingItemId == 0))) {
            //masuk
            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");
            objEntity.setItemMasterId(itemMasterId);
            ItemMaster colCombo2 = new ItemMaster();
            if (vectVendMaster > 0) {

                String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";

                try {
                    colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());

                } catch (Exception e) {
                    System.out.println(e);
                }


                strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:right\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + "\" class=\"readonly\" size=\"35\" readonly>" + "&nbsp;<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\">Search</a></td></tr>";
                if (useStockCode) {

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
                            } catch (Exception e) {
                            }

                            strVal += "<tr>" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_STOCK_CODE_ID] + "_" + xxSt + "\" value=\"" + stockCD.getOID() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_ITEM_MASTER_ID] + "_" + xxSt + "\" value=\"" + objEntity.getItemMasterId() + "\">" +
                                    "<input type=\"hidden\" name=\"" + JspStockCode.colNames[JspStockCode.JSP_TRANSFER_ID] + "_" + xxSt + "\" value=\"" + costing.getOID() + "\">" +
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

                    for (int iyQty = 0; iyQty < objEntity.getQty(); iyQty++) {
                        sumQty++;
                    }

                    if (listStockCode.size() < sumQty && isSave) {
                        if (optionalCode == false) {
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
                rowx.add("<font color=\"red\">No stock item available for costing</font>");
            }

            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" readonly name=\"" + frmObject.colNames[JspCostingItem.JSP_PRICE] + "\" value=\"" + JSPFormater.formatNumber(colCombo2.getCogs(), "#,###.##") + "\" class=\"readonly\" readonly style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\">" + frmObject.getErrorMsg(frmObject.JSP_PRICE) + "</div>");
            
            if (useStockCode) {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspCostingItem.JSP_QTY] + "\" value=\"\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" onChange=\"javascript:viewStockCode()\" >" + "</div>");
            } else {
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspCostingItem.JSP_QTY] + "\" value=\"\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" >" + "</div>");
            }
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" readonly name=\"" + frmObject.colNames[JspCostingItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
        }

        lstData.add(rowx);
        Vector vx = new Vector();
        vx.add("");
        vx.add("");
        vx.add("");
        vx.add("Grand Total");
        vx.add("<div align=\"right\">" + JSPFormater.formatNumber(total, "#,###.##") + "</div>");

        vx.add("");
        lstData.add(vx);


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
            long oidCosting = JSPRequestValue.requestLong(request, "hidden_costing_id");
            long oidCostingItem = JSPRequestValue.requestLong(request, "hidden_costing_item_id");
            int countStockCode = JSPRequestValue.requestInt(request, "hidden_count_stock_code");
            int idxStockCodeDel = JSPRequestValue.requestInt(request, "hidden_oid_stock_code_del");
            int stockDel = JSPRequestValue.requestInt(request, "hidden_del_stock");
            long oidLocation = JSPRequestValue.requestLong(request, "hidden_locationId");
            long itemMasterId = JSPRequestValue.requestLong(request, JspCostingItem.colNames[JspCostingItem.JSP_ITEM_MASTER_ID]);
            long oidLocationNew = JSPRequestValue.requestLong(request, "JSP_LOCATION_ID");
            Date date = JSPFormater.formatDate(JSPRequestValue.requestString(request, "JSP_DATE"), "dd/MM/yyyy");

            boolean isEdit = false;
            boolean isRefresh = false;
            if (iJSPCommand == JSPCommand.EDIT) {
                isEdit = true;
            }

            RptCosting rptKonstan = new RptCosting();
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
                iJSPCommand = JSPCommand.VIEW;
            }

            if (stockDel == 2) {
                listStockCode = new Vector();
            }

            if (stockDel == 3) {                
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
            boolean isAdd = false;
            boolean isLoad = false;

            if (iJSPCommand == JSPCommand.ADD) {
                isAdd = true;
                listStockCode = new Vector();
            }

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidCosting = 0;
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
            CmdCosting cmdCosting = new CmdCosting(request);
            JSPLine ctrLine = new JSPLine();

            iErrCode = cmdCosting.action(iJSPCommand, oidCosting);
            JspCosting jspCosting = cmdCosting.getForm();
            Costing costing = cmdCosting.getCosting();
            msgString = cmdCosting.getMessage();

            if (oidCosting == 0) {
                oidCosting = costing.getOID();
                if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                    costing.setStatus(I_Project.DOC_STATUS_DRAFT);
                } else {
                    costing.setStatus(I_Project.DOC_STATUS_APPROVED);
                }

            } else {
                try {
                    costing = DbCosting.fetchExc(oidCosting);
                } catch (Exception e) {
                }
            }

            whereClause = DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID] + "=" + oidCosting;
            orderClause = DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID];

            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            CmdCostingItem cmdCostingItem = new CmdCostingItem(request);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.REFRESH;
            }
            iErrCode2 = cmdCostingItem.action(iJSPCommand, oidCostingItem, oidCosting, listStockCode.size());
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.EDIT;
            }
            JspCostingItem jspCostingItem = cmdCostingItem.getForm();
            CostingItem costingItem = cmdCostingItem.getCostingItem();
            msgString2 = cmdCostingItem.getMessage();

            if (costingItem.getOID() != 0 && isEdit) {

                listStockCode = new Vector();
                String whereSc = DbStockCode.colNames[DbStockCode.COL_TRANSFER_ITEM_ID] + " = " + costingItem.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_STATUS] + "=" + DbStockCode.STATUS_IN;
                listStockCode = DbStockCode.list(0, 0, whereSc, DbStockCode.colNames[DbStockCode.COL_CODE]);

            }

            whereClause = DbCostingItem.colNames[DbCostingItem.COL_COSTING_ID] + "=" + oidCosting;
            orderClause = DbCostingItem.colNames[DbCostingItem.COL_COSTING_ITEM_ID];
            String msgSuccsess = "";
            Vector purchItems = DbCostingItem.list(0, 0, whereClause, orderClause);

            if (iJSPCommand == JSPCommand.VIEW) {
                iJSPCommand = JSPCommand.ADD;
            }

            Vector locations = userLocations;
            if (oidLocationNew != 0) {
                costing.setLocationId(oidLocationNew);
            } else {
                if (costing.getLocationId() == 0 && locations != null && locations.size() > 0) {
                    Location lxx = (Location) locations.get(0);
                    costing.setLocationId(lxx.getOID());
                }
            }

            if (costing.getOID() == 0) {
                costing.setStatus(I_Project.DOC_STATUS_DRAFT);
            }
            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                isSave = true;
            }

            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) {

                if (listStockCode != null && listStockCode.size() > 0) {
                    for (int ixSc = 0; ixSc < listStockCode.size(); ixSc++) {

                        StockCode objSc = new StockCode();

                        objSc = (StockCode) listStockCode.get(ixSc);
                        StockCode objStockCodeFrom = new StockCode();
                        StockCode objStockCodeTo = new StockCode();

                        objStockCodeFrom = objSc;
                        objStockCodeTo = objSc;

                        //insert di costing from
                        objStockCodeFrom.setInOut(DbStockCode.STOCK_OUT);
                        objStockCodeFrom.setStatus(DbStockCode.STATUS_OUT);
                        objStockCodeFrom.setType(DbStockCode.TYPE_TRANSFER);
                        objStockCodeFrom.setReceiveId(0);
                        objStockCodeFrom.setReceiveItemId(0);
                        objStockCodeFrom.setReturId(0);
                        objStockCodeFrom.setReturItemId(0);
                        objStockCodeFrom.setQty(1);
                        objStockCodeFrom.setType_item(DbStockCode.TYPE_NON_CONSIGMENT);

                        try {
                            DbStockCode.insertExc(objStockCodeFrom);
                        } catch (Exception e) {
                        }

                        //insert di costing to
                        objStockCodeTo.setInOut(DbStockCode.STOCK_IN);
                        objStockCodeTo.setStatus(DbStockCode.STATUS_IN);
                        objStockCodeTo.setType(DbStockCode.TYPE_TRANSFER);
                        objStockCodeTo.setReceiveId(0);
                        objStockCodeTo.setReceiveItemId(0);
                        objStockCodeTo.setReturId(0);
                        objStockCodeTo.setReturItemId(0);
                        objStockCodeTo.setQty(1);
                        objStockCodeFrom.setType_item(DbStockCode.TYPE_NON_CONSIGMENT);

                        try {
                            DbStockCode.insertExc(objStockCodeTo);
                        } catch (Exception e) {
                        }
                    //}
                    }
                }

                if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                    if (iJSPCommand == JSPCommand.SAVE) {
                        iJSPCommand = JSPCommand.POST;
                        iErrCode = cmdCosting.action(iJSPCommand, oidCosting);
                    }
                }

                listStockCode = new Vector();
                iJSPCommand = JSPCommand.ADD;
                //oidTransferItem = 0;
                oidCostingItem = 0;
                costingItem = new CostingItem();
                msgSuccsess = "Data is saved";
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {                
                oidCostingItem = 0;
                costingItem = new CostingItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD) {
                try {
                    costing = DbCosting.fetchExc(oidCosting);
                } catch (Exception e) {
                }
            }

            boolean useStockCode = false;
            boolean optionalCode = false;

            try {
                long oidTmpCostingItem = 0;
                if (isNone || isAdd || isSave || isLoad) {
                    try {
                        Stock stock = new Stock();
                        ItemMaster im = new ItemMaster();
                        try {
                            im = DbItemMaster.fetchExc(stock.getItemMasterId());
                            oidTmpCostingItem = im.getOID();
                        } catch (Exception e) {
                        }

                    } catch (Exception e) {
                    }
                } else {
                    oidTmpCostingItem = costingItem.getItemMasterId();
                }
                ItemMaster itemMaster = DbItemMaster.fetchExc(oidTmpCostingItem);
                if (itemMaster.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE || itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE) {
                    useStockCode = true;
                }

                if (itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE) {
                    optionalCode = true;
                }
            } catch (Exception e) {
            }

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
            window.open("<%=printroot%>.report.RptCostingXLS?idx=<%=System.currentTimeMillis()%>");
            }
            
            function cmdAddItemMaster(){   
                
                var oidLoc = document.frmcosting.JSP_LOCATION_ID.value;
                window.open("<%=approot%>/postransaction/addItemCosting.jsp?location_id=" + oidLoc , null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                    
                    document.frmcosting.command.value="<%=JSPCommand.ADD%>";
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
                    
                    function calculateSubTotal(){
                        var price = document.frmcosting.<%=JspCostingItem.colNames[JspCostingItem.JSP_PRICE]%>.value;
                        var qty = document.frmcosting.<%=JspCostingItem.colNames[JspCostingItem.JSP_QTY]%>.value;
                        var stockQty =1//document.frmcosting.stock_qty.value;
                        
                        amount = removeChar(price);
                        amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                        
                        
                        qty = removeChar(qty);
                        qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                        document.frmcosting.<%=JspCostingItem.colNames[JspCostingItem.JSP_QTY]%>.value = qty;
                        
                        stockQty = removeChar(stockQty);
                        stockQty = cleanNumberFloat(stockQty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                        //document.frmcosting.stock_qty.value = stockQty;
                        
                        if(parseInt(qty)>parseInt(stockQty)){
                            alert("The quantity is more than stock qty!");
                            qty="0";
                            document.frmcosting.<%=JspCostingItem.colNames[JspCostingItem.JSP_QTY]%>.value = qty;
                        }
                        
                        var totalItemAmount = (parseFloat(amount) * parseFloat(qty));
                        document.frmcosting.<%=JspCostingItem.colNames[JspCostingItem.JSP_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                        
                        var subtot = 0;
                        subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                        
                        
         <%
            //add

         %>
             
             calculateAmount();
         }
         
         
         function cmdVatEdit(){
             
             calculateAmount();
         }
         
         function cmdLocation(){
             <%if (costing.getOID() != 0) {%>
             if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all costing item based on vendor item master. ')){
                 document.frmcosting.hidden_costing_id.value=0;
                 document.frmcosting.hidden_costing_item_id.value=0;
                 document.frmcosting.command.value="<%=JSPCommand.LOAD%>";
                 document.frmcosting.action="costingitem.jsp";
                 document.frmcosting.submit();
             }
             <%} else {%>
             document.frmcosting.command.value="<%=JSPCommand.LOAD%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
             <%}%>
         }
         
         function cmdToRecord(){
             document.frmcosting.command.value="<%=JSPCommand.NONE%>";
             document.frmcosting.action="costinglist.jsp";
             document.frmcosting.submit();
         }
         
         function cmdDelStockCode(stockCodeId){
             
             if(confirm('Are sure you want delete this item ?')){
                 
                 document.frmcosting.hidden_oid_stock_code_del.value=stockCodeId;
                 document.frmcosting.hidden_del_stock.value=1;
                 document.frmcosting.command.value="<%=JSPCommand.VIEW%>";
                 document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
                 document.frmcosting.action="costingitem.jsp";
                 document.frmcosting.submit(); 
             }
             
         }    
         
         
         
         function viewStockCode(){
             document.frmcosting.command.value="<%=JSPCommand.VIEW%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();            
         }
         
         function viewStockCodeEdit(oidTransfer,oidTransferItem){             
             var cfrm = confirm('Are you sure want to change qty costing, and you will lose stock code data(s) ?');             
             if(cfrm==true){
                 document.frmcosting.hidden_costing_id.value=oidTransfer;
                 document.frmcosting.hidden_costing_item_id.value=oidTransferItem;
                 document.frmcosting.hidden_del_stock.value=2;
                 document.frmcosting.command.value="<%=JSPCommand.REFRESH%>";
                 document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
                 document.frmcosting.action="costingitem.jsp";
                 document.frmcosting.submit();            
             }
         }
         
         function cmdCloseDoc(){
             document.frmcosting.action="<%=approot%>/home.jsp";
             document.frmcosting.submit();
         }
         
         function cmdAskDoc(){
             document.frmcosting.hidden_costing_item_id.value="0";
             document.frmcosting.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdDeleteDoc(){
             document.frmcosting.hidden_costing_item_id.value="0";
             document.frmcosting.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdCancelDoc(){
             document.frmcosting.hidden_costing_item_id.value="0";
             document.frmcosting.command.value="<%=JSPCommand.EDIT%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdSaveDoc(){
             document.frmcosting.command.value="<%=JSPCommand.POST%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdAdd(){
             document.frmcosting.hidden_costing_item_id.value="0";
             document.frmcosting.command.value="<%=JSPCommand.ADD%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdAsk(oidTransferItem){
             document.frmcosting.hidden_costing_item_id.value=oidTransferItem;
             document.frmcosting.command.value="<%=JSPCommand.ASK%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdAskMain(oidTransfer){
             document.frmcosting.hidden_costing_id.value=oidTransfer;
             document.frmcosting.command.value="<%=JSPCommand.ASK%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costing.jsp";
             document.frmcosting.submit();
         }
         
         function cmdConfirmDelete(oidTransferItem){
             document.frmcosting.hidden_costing_item_id.value=oidTransferItem;
             document.frmcosting.command.value="<%=JSPCommand.DELETE%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         function cmdSaveMain(){
             document.frmcosting.command.value="<%=JSPCommand.SAVE%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costing.jsp";
             document.frmcosting.submit();
         }
         
         function cmdSave(){
             document.frmcosting.command.value="<%=JSPCommand.SAVE%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdEdit(oidTransfer){
             document.frmcosting.hidden_costing_item_id.value=oidTransfer;
             document.frmcosting.command.value="<%=JSPCommand.EDIT%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdCancel(oidTransfer){
             document.frmcosting.hidden_costing_item_id.value=oidTransfer;
             document.frmcosting.command.value="<%=JSPCommand.EDIT%>";
             document.frmcosting.prev_command.value="<%=prevJSPCommand%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
         }
         
         function cmdBack(){
             document.frmcosting.command.value="<%=JSPCommand.BACK%>";
             document.frmcosting.action="costingitem.jsp";
             document.frmcosting.submit();
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
            <%@ include file="../main/hmenu.jsp"%>
        <!-- #EndEditable --> </td>
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
            <!-- #EndEditable --> </td>
            <td width="100%" valign="top"> 
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                        <td><!-- #BeginEditable "content" --> 
                            <form name="frmcosting" method ="post" action="">
                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                            <input type="hidden" name="start" value="0">
                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                            <input type="hidden" name="hidden_costing_id" value="<%=oidCosting%>">
                            <input type="hidden" name="hidden_costing_item_id" value="<%=oidCostingItem%>">
                            <input type="hidden" name="<%=JspCostingItem.colNames[JspCostingItem.JSP_COSTING_ID]%>" value="<%=oidCosting%>">
                            <input type="hidden" name="hidden_oid_stock_code_del" value="<%=0%>">
                            <input type="hidden" name="hidden_del_stock" value="<%=0%>">
                            <input type="hidden" name="hidden_count_stock_code" value="<%=listStockCode.size()%>">
                            <input type="hidden" name="hidden_locationId" value="<%=costing.getLocationId()%>">
                            <input type="hidden" name="<%= JspCosting.colNames[JspCosting.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">                                                            
                            <%if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                            <input type="hidden" name="<%=JspCosting.colNames[JspCosting.JSP_STATUS]%>" value="<%=costing.getStatus()%>">
                            <%}%>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr> 
                                    <td valign="top"> 
                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                            <tr valign="bottom"> 
                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Costing 
                                                        </font><font class="tit1">&raquo; <span class="lvl2">Costing
                                                Item </span></font></b></td>
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
                                                            <td class="tabin" nowrap class="fontarial"> 
                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                            </td>
                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                            <td class="tab" nowrap class="fontarial"> 
                                                                <div align="center">&nbsp;&nbsp;Costing Item &nbsp;&nbsp;</div>
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
                                                                <td colspan="4" height="10"></td>
                                                            </tr>
                                                            <tr align="left" height="22"> 
                                                                <td width="100" class="tablearialcell1">&nbsp;Location</td>
                                                                <td width="300">:&nbsp;
                                                                    <%if (((!costing.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !costing.getStatus().equals(I_Project.STATUS_POSTED)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>												
                                                                    <span class="comment"> 
                                                                        <select name="<%=JspCosting.colNames[JspCosting.JSP_LOCATION_ID]%>" class="fontarial" <%if (((!costing.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>onChange="javascript:cmdLocation()"<%}%>>
                                                                                <%

    if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location d = (Location) locations.get(i);
            if (costing.getLocationId() == d.getOID()) {
                rptKonstan.setLocation(d.getName());
            }
                                                                                %>
                                                                                <option value="<%=d.getOID()%>" <%if (costing.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName().toUpperCase()%></option>
                                                                            <%}
    }%>
                                                                        </select>
                                                                    </span>
                                                                    <%} else {

                try {
                    Location l = DbLocation.fetchExc(costing.getLocationId());
                    out.println(l.getCode() + " - " + l.getName());
                    rptKonstan.setLocation(l.getName());
                } catch (Exception e) {
                }

            }%>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                </td> 
                                                                <td width="9%" class="tablearialcell1">&nbsp;Date</td>
                                                                <td colspan="2" class="comment">:&nbsp;
                                                                    <input name="<%=JspCosting.colNames[JspCosting.JSP_DATE]%>" value="<%=JSPFormater.formatDate((costing.getDate() == null) ? new Date() : costing.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                    <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmcosting.<%=JspCosting.colNames[JspCosting.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                    <%
            rptKonstan.setTanggal(costing.getDate());
                                                                    %> 
                                                                </td>
                                                            </tr>
                                                            <tr align="left" height="21"> 
                                                                <td height="21" class="tablearialcell1">&nbsp;Number</td>
                                                                <td height="21" class="fontarial">:&nbsp; 
                                                                    <%
            String number = "";
            if (costing.getOID() == 0) {
                int ctr = DbCosting.getNextCounter();
                number = DbCosting.getNextNumber(ctr);
                rptKonstan.setNumber(number);
                costing.setNumber(number);
            } else {
                number = costing.getNumber();
                rptKonstan.setNumber(number);
            }
                                                                    %>
                                                                <%=number%> </td>
                                                                <td valign="top" class="tablearialcell1">&nbsp;Status</td>
                                                                <td colspan="2" class="comment" valign="top">:&nbsp; 
                                                                    <%
            if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                if (costing.getStatus() == null) {
                    costing.setStatus(I_Project.DOC_STATUS_DRAFT);
                }
            }
                                                                    %>
                                                                    <% if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                    <input type="text" class="readOnly" name="stt" value="<%=(costing.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((costing.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : costing.getStatus())%>" size="15" readOnly>
                                                                    <% } else {%>
                                                                    <input type="text" class="readOnly" name="stt" value="<%=I_Project.DOC_STATUS_APPROVED%>" size="15" readOnly>
                                                                    <%}%>    
                                                                </td>
                                                            </tr>
                                                            <tr align="left" height="26"> 
                                                                <td height="21" valign="top" class="tablearialcell1">&nbsp;Notes</td>
                                                                <td height="21" valign="top">&nbsp;  
                                                                    <textarea name="<%=JspCosting.colNames[JspCosting.JSP_NOTE]%>" cols="40" rows="2" class="fontarial"><%=costing.getNote()%></textarea>
                                                                </td>
                                                                <td class="tablearialcell1" valign="top">&nbsp;Cost Location</td>
                                                                <td valign="top">:&nbsp;
                                                                    <select name="<%=JspCosting.colNames[JspCosting.JSP_LOCATION_POST_ID]%>" class="fontarial">
                                                                        <option value="0" <%if (costing.getLocationPostId()==0) {%>selected<%}%>>select location</option>
                                                                        <%

            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    if (costing.getLocationPostId() == d.getOID()) {
                        rptKonstan.setCostLocation(d.getName());
                    }
                                                                        %>
                                                                        <option value="<%=d.getOID()%>" <%if (costing.getLocationPostId() == d.getOID()) {%>selected<%}%>><%=d.getName().toUpperCase() %></option>
                                                                        <%}
            }%>
                                                                    </select>
                                                                </td>
                                                            </tr>
                                                        </tr>
                                                        <%
            rptKonstan.setNotes(costing.getNote());
                                                        %>
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top">&nbsp;</td>
                                                        </tr>
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top"> 
                                                                &nbsp; 
                                                                <%
            Vector x = drawList(iJSPCommand, jspCostingItem, costingItem, purchItems, oidCostingItem, approot, costing.getLocationId(), iErrCode2, costing.getStatus(), useStockCode, listStockCode, costing, isSave, optionalCode, itemMasterId);
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
                                                                            <%if ((((costing.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) || iJSPCommand == JSPCommand.CONFIRM) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                                                                            <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                                <%
    if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD ||
            (iJSPCommand == JSPCommand.EDIT && oidCostingItem != 0) ||
            iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
                                                                                <tr> 
                                                                                    <td> 
                                                                                        <%
                                                                                    ctrLine = new JSPLine();
                                                                                    ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                    ctrLine.initDefault();
                                                                                    ctrLine.setTableWidth("80%");
                                                                                    String scomDel = "javascript:cmdAsk('" + oidCostingItem + "')";
                                                                                    String sconDelCom = "javascript:cmdConfirmDelete('" + oidCostingItem + "')";
                                                                                    String scancel = "javascript:cmdBack('" + oidCostingItem + "')";
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

                                                                                    if (iJSPCommand == JSPCommand.LOAD) {
                                                                                        if (oidCostingItem == 0) {
                                                                                            iJSPCommand = JSPCommand.ADD;
                                                                                        } else {
                                                                                            iJSPCommand = JSPCommand.EDIT;
                                                                                        }
                                                                                    }

                                                                                        %>
                                                                                    <%= ctrLine.drawImageOnly(iJSPCommand, err, msgString)%> </td>
                                                                                </tr>
                                                                                <%} else {%>
                                                                                <%if (iJSPCommand == JSPCommand.CONFIRM && iErrCode == 0) {%>
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
                                                                                
                                                                                <%if (msgSuccsess.length() > 0) {%>
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
                                                        <%if (costing.getOID() != 0) {%>
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
                                                                            <%if (costing.getOID() != 0) {%>
                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                <tr> 
                                                                                    <td width="12%">&nbsp;</td>
                                                                                    <td width="14%">&nbsp;</td>
                                                                                    <td width="74%">&nbsp;</td>
                                                                                </tr>
                                                                                <%if (((  !costing.getStatus().equals(I_Project.DOC_STATUS_APPROVED)  && !costing.getStatus().equals(I_Project.STATUS_POSTED) ) || iErrCode != 0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                                <tr> 
                                                                                    <td width="12%"><b>Set Status to</b> </td>
                                                                                    <td width="14%"> 
                                                                                        <select name="<%=JspCosting.colNames[JspCosting.JSP_STATUS]%>">
                                                                                            <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (costing.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                            <%if (posApprove1Priv) {%>
                                                                                            <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (costing.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
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
    if (costing.getOID() != 0) {
                                                                    %>
                                                                    <tr> 
                                                                        <td colspan="4" class="errfont"></td>
                                                                    </tr>
                                                                    <%}%>
                                                                    <%if (true) {
        if (costing.getOID() != 0) {
                                                                    %>
                                                                    <tr> 
                                                                        <td colspan="4">
                                                                            <table>
                                                                                <tr>
                                                                        <%//if (( ( !costing.getStatus().equals(I_Project.DOC_STATUS_APPROVED) &&  !costing.getStatus().equals(I_Project.STATUS_DOC_POSTED)) || iErrCode != 0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                                                                        if(true){%>

                                                                        <td width="150"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                                        <td width="100"> 
                                                                            <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                        </td>
                                                                        <td width="100" > 
                                                                            <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                                        </td>
                                                                        <%}%>
                                                                        
                                                                        <td width="100"> 
                                                                            <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                                        </td>                                                                        
                                                                        </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                    <%}
} else {%>
                                                                    <%
    }%>
                                                                    <%}%>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr align="left" > 
                                                            <td colspan="5" valign="top">&nbsp;</td>
                                                        </tr>                                                                                                    
                                                        <%if (costing.getOID() != 0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
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
        u = DbUser.fetch(costing.getUserId());
    } catch (Exception e) {
    }
                                                                                    %>
                                                                            <%=u.getLoginId()%></i></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell1"> 
                                                                            <div align="center"><i><%=JSPFormater.formatDate(costing.getDate(), "dd MMMM yy")%></i></div>
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
        u = DbUser.fetch(costing.getApproval1());
    } catch (Exception e) {
    }
                                                                                    %>
                                                                            <%=u.getLoginId()%></i></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell1"> 
                                                                            <div align="center"> <i> 
                                                                                    <%if (costing.getApproval1() != 0) {%>
                                                                                    <%=JSPFormater.formatDate(costing.getEffectiveDate(), "dd MMMM yy")%> 
                                                                                    <%}%>
                                                                            </i></div>
                                                                        </td>
                                                                    </tr>
                                                                    <tr> 
                                                                        <td width="33%" class="tablecell1"><i>Posted 
                                                                        by</i></td>
                                                                        <td width="34%" class="tablecell1"> 
                                                                            <div align="center"> <i> 
                                                                                    <%
    u = new User();
    try {
        u = DbUser.fetch(costing.getPostedById());
    } catch (Exception e) {
    }
                                                                                    %>
                                                                            <%=u.getLoginId()%></i></div>
                                                                        </td>
                                                                        <td width="33%" class="tablecell1"> 
                                                                            <div align="center"> <i> 
                                                                                    <%if (costing.getPostedById() != 0) {%>
                                                                                    <%=JSPFormater.formatDate(costing.getPostedDate(), "dd MMMM yy")%> 
                                                                                    <%}%>
                                                                            </i></div>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <%}%>                                                                                                   
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>                                                                           
                            </table>
                        </td>
                    </tr>
                </table>                
                <script language="JavaScript">
                    <%if (costing.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && costingItem.getOID() != 0) || iErrCode != 0)) {%>
                    
                                                         <%}
            if (costing.getOID() != 0 && !costing.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {%>
                    
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
