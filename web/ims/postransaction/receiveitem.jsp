
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %> 
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %> 
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>  
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_DIRECT_INCOMING);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_DIRECT_INCOMING, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_DIRECT_INCOMING, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_DIRECT_INCOMING, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_DIRECT_INCOMING, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(int iJSPCommand, JspReceiveItem frmObject,
            ReceiveItem objEntity, Vector objectClass,
            long receiveItemId, String approot, long oidVendor,
            int iErrCode2, String status, boolean isView, Vector vErr, boolean useStockCode, double qty, Vector vStockCode, boolean isSave, Receive receive, boolean isRefresh, int optStockCode, int use_expired_date, long itemMasterId, boolean editIncoming) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "2%");
        jsplist.addHeader("Barcode", "9%");
        jsplist.addHeader("Name", "32%");
        jsplist.addHeader("Price", "10%");
        jsplist.addHeader("Qty", "5%");
        jsplist.addHeader("Discount", "7%");
        jsplist.addHeader("Total", "10%");
        jsplist.addHeader("Unit Purchase", "8%");
        jsplist.addHeader("Unit Stock", "8%");
        jsplist.addHeader("Expired Date", "6%");
        jsplist.addHeader("Is bonus", "3%");

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
        int cntVendMaster = DbItemMaster.getCount(whereCls);
        Vector temp = new Vector();

        boolean isEdit = false;


        for (int i = 0; i < objectClass.size(); i++) {

            ReceiveItem receiveItem = (ReceiveItem) objectClass.get(i);

            SessIncomingGoodsL igL = new SessIncomingGoodsL();
            rowx = new Vector();
            if (receiveItemId == receiveItem.getOID()) {
                index = i;
            }

            if (iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK || (iJSPCommand == JSPCommand.SAVE && (iErrCode2 != 0 || (vErr != null && vErr.size() > 0))))) {
                isEdit = true;
                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                int cntStockCode = 0;
                Uom uomPurchase = new Uom();
                Uom uomStock = new Uom();
                ItemMaster colCombo2 = new ItemMaster();

                if (cntVendMaster > 0) {

                    String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";

                    if (itemMasterId != 0) {
                        objEntity.setItemMasterId(itemMasterId);
                    }

                    try {
                        colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                        uomPurchase = DbUom.fetchExc(colCombo2.getUomPurchaseId());
                        uomStock = DbUom.fetchExc(colCombo2.getUomStockId());
                    } catch (Exception e) {
                        System.out.println(e);
                    }

                    rowx.add("<div align=\"left\">" + "<input type=\"text\" size=\"20\" name=\"jsp_code_item\" value=\"" + colCombo2.getBarcode() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:left\"> </div>");
                    strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:left\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + "\"  size=\"35\" onChange=\"javascript:cmdAddItemMaster()\" >" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";

                    strVal += "<tr><td></td><td></td><td></td></tr>";
                    strVal += "</table>";

                    rowx.add(strVal);

                } else {
                    rowx.add("<font color=\"red\">No receive item available for vendor</font>");
                }

                rowx.add("<div align=\"right\">" + "<input type=\"hidden\" name=\"STOCK_CODE_COUNTER\" value=\"" + cntStockCode + "\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\"> *) " + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_AMOUNT)) + "</div>");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\" onkeypress=\"cmdSaveOnEnter(event,'" + receiveItem.getOID() + "')\">" + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_QTY)) + "</div>");

                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] + "\" value=\"" + objEntity.getTotalDiscount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\" onkeypress=\"cmdSaveOnEnter(event,'" + receiveItem.getOID() + "')\">" + "</div>");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"17\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] + "\" value=\"" + objEntity.getTotalAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div><input type=\"hidden\" name=\"temp_item_amount\" value=\"" + objEntity.getTotalAmount() + "\">");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_code\" value=\"" + uomPurchase.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_stock\" value=\"" + uomStock.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
                if (use_expired_date == DbItemMaster.USE_EXPIRED_DATE) {
                    rowx.add("<div align=\"center\"><input name=\"" + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + "\" value=\"" + JSPFormater.formatDate((objEntity.getExpiredDate() == null) ? new Date() : objEntity.getExpiredDate(), "dd/MM/yyyy") + "\" size=\"11\" readonly>" +
                            "<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmreceive." + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + ");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"" + approot + "/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");
                } else {
                    rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"u\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
                }
                if (objEntity.getIsBonus() == 1) {
                    rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" name=\"bonus_" + objEntity.getItemMasterId() + "\" value=\"1\" checked >" + "</div>");
                } else {
                    rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" name=\"bonus_" + objEntity.getItemMasterId() + "\" value=\"1\" >" + "</div>");
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
                rowx.add("<div align=\"center\">" + itemMaster.getBarcode() + "</div>");
                if ((editIncoming) || (status != null && status.equals(I_Project.DOC_STATUS_DRAFT) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                    rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(receiveItem.getOID()) + "')\">" + itemMaster.getName() + "</a>");
                    igL.setGroup(itemMaster.getName());
                    igL.setBarcode(itemMaster.getBarcode());
                } else {
                    rowx.add(ig.getName() + " / " + itemMaster.getCode() + " - " + itemMaster.getName());
                    igL.setGroup(itemMaster.getName());
                    igL.setBarcode(itemMaster.getBarcode());
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
                if (receiveItem.getIsBonus() == 0) {
                    rowx.add("<div align=\"center\">" + "No" + "</div>");
                } else {
                    rowx.add("<div align=\"center\">" + "Yes" + "</div>");
                }

            }

            lstData.add(rowx);
            temp.add(igL);
        }
        //baru
        rowx = new Vector();
        Uom uomPurchase = new Uom();
        Uom uomStock = new Uom();
        if (((iJSPCommand != JSPCommand.POST && isEdit == false && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && receiveItemId == 0))))) {
            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");

            int cntStockCode = 0;
            objEntity.setItemMasterId(itemMasterId);
            ItemMaster colCombo2 = new ItemMaster();

            if (cntVendMaster > 0) {

                String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";

                try {
                    colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                    uomPurchase = DbUom.fetchExc(colCombo2.getUomPurchaseId());
                    uomStock = DbUom.fetchExc(colCombo2.getUomStockId());
                } catch (Exception e) {
                    System.out.println(e);
                }

                rowx.add("<div align=\"left\">" + "<input type=\"text\" size=\"20\" name=\"jsp_code_item\" value=\"" + colCombo2.getBarcode() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:left\"> </div>");
                strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:left\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + "\"  size=\"35\" onChange=\"javascript:cmdAddItemMaster()\" >" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";

                strVal += "<tr><td></td><td></td><td></td></tr>";
                strVal += "</table>";

                rowx.add(strVal);

            } else {
                rowx.add("<font color=\"red\">No receive item available for vendor</font>");
            }

            Vector vItem = new Vector();
            vItem = DbVendorItem.list(0, 0, "vendor_id=" + oidVendor + " and item_master_id=" + itemMasterId, "");
            VendorItem vendorItem = new VendorItem();
            if (vItem.size() > 0) {
                vendorItem = (VendorItem) vItem.get(0);
            }

            rowx.add("<div align=\"right\">" + "<input type=\"hidden\" name=\"STOCK_CODE_COUNTER\" value=\"" + cntStockCode + "\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_AMOUNT] + "\" readonly value=\"" + vendorItem.getLastPrice() + "\" class=\"readonly\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\"> " + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_AMOUNT)) + "</div>");
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"5\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_QTY] + "\" value=\"" + ((objEntity.getQty() == 0) ? 1 : objEntity.getQty()) + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\"  onkeypress=\"cmdSaveOnEnter(event,'0')\">" + ((isView == true) ? "" : frmObject.getErrorMsg(frmObject.JSP_QTY)) + "</div>");

            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"15\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT] + "\" value=\"" + objEntity.getTotalDiscount() + "\" class=\"formElemen\" style=\"text-align:right\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\"  onkeypress=\"cmdSaveOnEnter(event,'0')\">" + "</div>");
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"17\" name=\"" + frmObject.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT] + "\" value=\"" + objEntity.getTotalAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div>");
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_code\" value=\"" + uomPurchase.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
            rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"8\" name=\"unit_stock\" value=\"" + uomStock.getUnit() + "\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");
            if (use_expired_date == DbItemMaster.USE_EXPIRED_DATE) {
                rowx.add("<div align=\"center\"><input name=\"" + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + "\" value=\"" + JSPFormater.formatDate((objEntity.getExpiredDate() == null) ? new Date() : objEntity.getExpiredDate(), "dd/MM/yyyy") + "\" size=\"11\" readonly>" +
                        "<a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document.frmreceive." + JspReceiveItem.colNames[JspReceiveItem.JSP_EXPIRED_DATE] + ");return false;\"><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"" + approot + "/calendar/calbtn.gif\" height=\"19\" border=\"0\" alt=\"\"></a></div>");
            } else {
                rowx.add("<div align=\"right\"></div>");
            }
            rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" name=\"bonus_" + objEntity.getItemMasterId() + "\" value=\"1\" >" + "</div>");
        //

        }

        lstData.add(rowx);

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        return v;
    }

    public void updateStockDateToApproveDate(Receive receive) {
        if (receive.getOID() != 0) {
            try {
                String sql = "update pos_stock set date='" + JSPFormater.formatDate(receive.getApproval1Date(), "yyyy-MM-dd HH:mm:ss") + "' where incoming_id=" + receive.getOID();
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
        }
    }

    public static void proceedStock(Receive receive) {
        try {
            DbStock.delete(DbStock.colNames[DbStock.COL_INCOMING_ID] + "=" + receive.getOID());
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        Vector temp = DbReceiveItem.list(0, 0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + receive.getOID(), "");
        int stockType = Integer.parseInt(DbSystemProperty.getValueByName("STOCK_MANAGEMENT_TYPE"));
        if (temp != null && temp.size() > 0) {

            for (int i = 0; i < temp.size(); i++) {

                ReceiveItem ri = (ReceiveItem) temp.get(i);

                ItemMaster im = new ItemMaster();
                try {
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                } catch (Exception e) {
                }

                //jika bukan jasa (stockable) lakukan proses penambahan stock
                if (im.getNeedRecipe() == 0) {
                    insertReceiveGoods(receive, ri, im);

                }
            }

            for (int i = 0; i < temp.size(); i++) {

                ReceiveItem ri = (ReceiveItem) temp.get(i);

                ItemMaster im = new ItemMaster();
                try {
                    im = DbItemMaster.fetchExc(ri.getItemMasterId());
                } catch (Exception e) {
                }

                System.out.println("-- start calculate cogs --------");

                if (receive.getType() == DbReceive.TYPE_NON_CONSIGMENT) {
                    //average
                    if (stockType == 0) {
                        DbReceiveItem.updateItemAverageCost(ri, receive, im);
                    } //update dengan harga terakhir
                    else if (stockType == 1) {
                        DbReceiveItem.updateItemLastPriceCost(ri);
                    }
                } else if (receive.getType() == DbReceive.TYPE_CONSIGMENT) {
                    //average
                    if (stockType == 0) {
                        DbReceiveItem.updateItemAverageCostConsigment(ri);
                    } //update dengan harga terakhir
                    else if (stockType == 1) {
                        DbReceiveItem.updateItemLastPriceCostConsigment(ri);
                    }
                }
            }
        }

    }

    public static void insertReceiveGoods(Receive rec, ReceiveItem ri, ItemMaster im) {

        try {

            System.out.println("inserting stock ri ... " + ri.getOID());

            if (rec.getTypeAp() != DbReceive.TYPE_AP_REC_ADJ_BY_PRICE) {

                if (im.getNeedRecipe() == 0) {

                    Uom uom = DbUom.fetchExc(im.getUomStockId());

                    Stock stock = new Stock();
                    stock.setIncomingId(ri.getReceiveId());

                    stock.setInOut(DbStock.STOCK_IN);
                    stock.setItemBarcode(im.getBarcode());
                    stock.setItemCode(im.getCode());
                    stock.setItemMasterId(im.getOID());
                    stock.setItemName(im.getName());
                    stock.setLocationId(rec.getLocationId());
                    //stock.setDate(rec.getDate());
                    stock.setDate(rec.getApproval1Date());//stock mengikuti tanggal jam approve - ED
                    stock.setNoFaktur(rec.getDoNumber());
                    stock.setPrice(ri.getTotalAmount() / ri.getQty());

                    stock.setTotal(ri.getTotalAmount());

                    stock.setQty((ri.getQty() * im.getUomPurchaseStockQty()));
                    if (rec.getTypeAp() == DbReceive.TYPE_AP_REC_ADJ_BY_QTY) {
                        stock.setType(DbStock.TYPE_REC_ADJ);
                    } else {
                        stock.setType(DbStock.TYPE_INCOMING_GOODS);
                    }
                    stock.setUnitId(im.getUomStockId());
                    stock.setUnit(uom.getUnit());
                    stock.setUserId(rec.getUserId());
                    stock.setType_item(rec.getType());
                    stock.setReceive_item_id(ri.getOID());
                    stock.setStatus(rec.getStatus());

                    long oidx = DbStock.insertExc(stock);

                    if (oidx != 0) {
                        System.out.println("inserting new stock ... done success id " + oidx);
                    } else {
                        System.out.println("inserting new stock ... failed");
                    }

                //DbStock.checkRequestTransfer(ri.getItemMasterId() ,rec.getLocationId());
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }

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
            int opt_stock_code = JSPRequestValue.requestInt(request, "hidden_optional_stock_code");

            String invnumber = JSPRequestValue.requestString(request, "hidden_invnumber");
            String donumber = JSPRequestValue.requestString(request, "hidden_donumber");

            long itemMasterId = JSPRequestValue.requestLong(request, JspReceiveItem.colNames[JspReceiveItem.JSP_ITEM_MASTER_ID]);
            Date dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "JSP_DUE_DATE"), "dd/MM/yyyy");
            Date dates = JSPFormater.formatDate(JSPRequestValue.requestString(request, "JSP_DATE"), "dd/MM/yyyy");
            Date expDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "ITM_JSP_EXPIRED_DATE"), "dd/MM/yyyy");
            String srcCode = JSPRequestValue.requestString(request, "jsp_code_item");
            long vendorId = JSPRequestValue.requestLong(request, "JSP_VENDOR_ID");


            int useExpiredDate = 0;
            boolean isNone = false;
            boolean isAdd = false;

            if (iJSPCommand == JSPCommand.ADD) {
                isAdd = true;
            //oidReceive=0;
            }

            if (iJSPCommand == JSPCommand.NONE) {
                isNone = true;
                iJSPCommand = JSPCommand.ADD;
                oidReceive = 0;
            }


            boolean isRefresh = false;


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

            if (dueDate != null) {
                receive.setDueDate(dueDate);
            }
            if (dates != null) {
                receive.setDate(dates);
            }

            if (oidReceive == 0) {
                oidReceive = receive.getOID();
                if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                    receive.setStatus(I_Project.DOC_STATUS_DRAFT);
                } else {
                    receive.setStatus(I_Project.DOC_STATUS_APPROVED);
                }
            }

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];


            //============================== start processing items ===========================================    
            //=================================================================================================                 

            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            SessIncomingGoods ig = new SessIncomingGoods();

            CmdReceiveItem cmdReceiveItem = new CmdReceiveItem(request);

            int loop = JSPRequestValue.requestInt(request, "STOCK_CODE_COUNTER");

            boolean isStockEmpty = false;
            boolean isStockSame = false;

            //out.println("oidReceiveItem : "+oidReceiveItem);

            if (iErrCode == 0 && iJSPCommand != JSPCommand.POST) {
                iErrCode2 = cmdReceiveItem.action(iJSPCommand, oidReceiveItem, oidReceive, isStockEmpty, isStockSame);                
            }

            JspReceiveItem jspReceiveItem = cmdReceiveItem.getForm();
            ReceiveItem receiveItem = cmdReceiveItem.getReceiveItem();

            if (iJSPCommand == JSPCommand.SAVE) {
                if (expDate != null) {
                    receiveItem.setExpiredDate(expDate);
                }
                int xxx = JSPRequestValue.requestInt(request, "bonus_" + receiveItem.getItemMasterId());
                if (xxx == 1) {
                    receiveItem.setIsBonus(1);
                    DbReceiveItem.updateExc(receiveItem);
                }
            }
            msgString2 = cmdReceiveItem.getMessage();

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_ITEM_MASTER_ID];

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
            String whereSCode = "";
            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                isSave = true;
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

                if (isNone || isAdd) {
                    try {
                        ItemMaster tmpIM = (ItemMaster) vendorItems.get(0);
                        oidTmpReceiveItem = tmpIM.getOID();
                        if (itemMasterId != 0) {
                            oidTmpReceiveItem = itemMasterId;
                        }
                    } catch (Exception e) {
                    }
                } else {
                    oidTmpReceiveItem = receiveItem.getItemMasterId();
                }

                ItemMaster itemMaster = DbItemMaster.fetchExc(oidTmpReceiveItem);
                if (itemMaster.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE || itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE) {
                    useStockCode = true;
                    purchase_stock_qty = itemMaster.getUomPurchaseStockQty();
                }

                opt_stock_code = itemMaster.getApplyStockCode();
                useExpiredDate = itemMaster.getUseExpiredDate();
            } catch (Exception e) {
                System.out.println("[exception] " + e.toString());
            }


            double subTotal = 0;
            if (oidReceive != 0) {
                subTotal = DbReceiveItem.getTotalReceiveAmount(oidReceive);
            }

            if (iJSPCommand == JSPCommand.CONFIRM) {
                oidReceive = 0;
            }

            int vectSize = 0;

            if (iJSPCommand != JSPCommand.SAVE && iJSPCommand != JSPCommand.POST) {

                if (srcCode.length() > 0) {

                    vectSize = DbItemMaster.getCount("for_buy=1 and is_active=1 and ( code like '%" + srcCode + "%'" + " or barcode like '%" + srcCode + "%'" + " or barcode_2 like '%" + srcCode + "%'" + " or barcode_3 like '%" + srcCode + "%')");
                    if (vectSize == 1) {
                        Vector vlist = DbItemMaster.listByVendor(0, 1, " pos_vendor_item.vendor_id=" + vendorId + " and (for_buy=1 and is_active=1 and (code like '%" + srcCode + "%'" + " or barcode like '%" + srcCode + "%'" + " or barcode_2 like '%" + srcCode + "%'" + " or barcode_3 like '%" + srcCode + "%'))", "");
                        if (vlist.size() > 0) {
                            ItemMaster itemMaster = (ItemMaster) vlist.get(0);
                            itemMasterId = itemMaster.getOID();
                        }
                    }
                }
            }


            if (vendorId == 0) {
                vendorId = receive.getVendorId();
            }

            //selected vendor
            try {
                Vendor vx = DbVendor.fetchExc(vendorId);
                if (receive.getOID() == 0) {
                    if (vx.getIsPKP() == 1) {
                        receive.setIncluceTax(1);
                        receive.setTaxPercent(sysCompany.getGovernmentVat());
                    } else {
                        receive.setIncluceTax(0);
                        receive.setTaxPercent(0);
                    }
                }

                if (receive.getOID() == 0) {
                    Date dtx = new Date();
                    dtx.setDate(dtx.getDate() + vx.getDueDate());
                    receive.setDueDate(dtx);
                }
            } catch (Exception e) {
            }

            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) {
                iJSPCommand = JSPCommand.ADD;
                itemMasterId = 0;
                srcCode = "";
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
    <!-- #BeginEditable "javascript" --> 
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><%=titleIS%></title>
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        <!--
        function cmdPrintXLS(){	 
            window.open("<%=printroot%>.report.RptIncomingGoodsXLS?idx=<%=System.currentTimeMillis()%>");
            }
            function cmdPrintDoc(){                
                window.open("<%=printroot%>.report.RptIncomingGoodsPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSaveOnEnter(e, oid){
                    
                    if (typeof e == 'undefined' && window.event) { e = window.event; }
                    
                    if (e.keyCode == 13)
                        {
                            calculateSubTotal();
                            cmdSave(oid);
                        }
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
            document.frmreceive.action="receiveitem.jsp";
            document.frmreceive.submit();     
            
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
            document.frmreceive.action="receiveitem.jsp";
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
             
             document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="10";		
             
         }
         
         calculateAmount();
     }
     
     function cmdAddItemMaster(){  
         
         var itemName =document.frmreceive.X_itm_JSP_ITEM_MASTER_ID.value;
         var vendorId=document.frmreceive.JSP_VENDOR_ID.value; 
         document.frmreceive.jsp_code_item.value="";
         window.open("<%=approot%>/postransaction/addItemReceive.jsp?item_name=" + itemName + "&oidVendor=" + vendorId, null, "height=900,width=1100, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
             document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmsalesproductdetail.submit();                
         }
         
         
         function cmdAddItemMaster3(){            
             var itemCode =document.frmreceive.hidden_item_code.value;
             var vendorId=document.frmreceive.JSP_VENDOR_ID.value; 
             document.frmreceive.jsp_code_item.value=""; 
             window.open("<%=approot%>/postransaction/addItemReceive.jsp?item_code=" + itemCode + "&oidVendor=" + vendorId, null, "height=1000,width=1200, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                 document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
                 document.frmsalesproductdetail.submit();    
             }
             
             function cmdAddItemMaster2(){            
                 document.frmreceive.itm_JSP_ITEM_MASTER_ID.value=0;
                 document.frmreceive.command.value="<%=JSPCommand.ADD%>";
                 
                 document.frmreceive.submit(); 
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
                 document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="10";		         
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
                 document.frmreceive.action="receiveitem.jsp";
                 document.frmreceive.submit();
             }
             <%} else {%>
             document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
             //cmdVendorChange();
             <%}%>
         }
         
         function cmdToRecord(){
             document.frmreceive.command.value="<%=JSPCommand.NONE%>";
             document.frmreceive.action="receivelist.jsp";
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
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         
         function cmdDeleteDoc(){
             document.frmreceive.hidden_receive_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         
         function cmdCancelDoc(){
             document.frmreceive.hidden_receive_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         
         function cmdSaveDoc(){
             document.all.cmdline.style.display="none";	             
             document.frmreceive.command.value="<%=JSPCommand.POST%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAdd(){
             document.frmreceive.hidden_receive_item_id.value="0";
             document.frmreceive.command.value="<%=JSPCommand.ADD%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAsk(oidReceiveItem){
             document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
             document.frmreceive.command.value="<%=JSPCommand.ASK%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         
         function cmdAskMain(oidReceive){
             document.frmreceive.hidden_receive_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.ASK%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receive.jsp";
             document.frmreceive.submit();
         }
         
         function cmdConfirmDelete(oidReceiveItem){
             document.frmreceive.hidden_receive_item_id.value=oidReceiveItem;
             document.frmreceive.command.value="<%=JSPCommand.DELETE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         function cmdSaveMain(){
             document.frmreceive.command.value="<%=JSPCommand.SAVE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receive.jsp";
             document.frmreceive.submit();
         }
         
         function cmdSave(oidReceive){
             document.frmreceive.hidden_receive_item_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.SAVE%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();             
         }
         
         function cmdEdit(oidReceive){
             document.frmreceive.hidden_receive_item_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         
         function cmdCancel(oidReceive){
             document.frmreceive.hidden_receive_item_id.value=oidReceive;
             document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
             document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
             document.frmreceive.action="receiveitem.jsp";
             document.frmreceive.submit();
         }
         
         function cmdBack(){
             document.frmreceive.command.value="<%=JSPCommand.BACK%>";
             document.frmreceive.action="receiveitem.jsp";
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
                <%@ include file="../main/menu.jsp"%>
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
                    <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_TYPE]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                    <input type="hidden" name="<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TYPE]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                    <input type="hidden" name="<%=JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                    <input type="hidden" name="hidden_item_code" value="<%= srcCode %>">
                    <% if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                    <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
                    <% }%>
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
    } catch (Exception e) {
    }
                                                        %>
                                                        Prepared By : <%=us.getLoginId()%> 
                                                        <% ig.setUser(us.getLoginId());%>
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
                } catch (Exception e) {
                }
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
            if (receive.getPurchaseId() == 0 && (receive.getStatus().equalsIgnoreCase("DRAFT"))) {%>
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
                                                <% ig.setVendor(vnd.getName());
                                                    ig.setAddress(vnd.getAddress());
                                                %>
                                                <%}%>
                                            </td>
                                            <td height="20" width="9%">Receive 
                                            In</td>
                                            <%if (receive.getPurchaseId() == 0 && (receive.getStatus().equalsIgnoreCase("DRAFT"))) {%>
                                            <td height="20" colspan="2" width="42%" class="comment"> 
                                                <select name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>">
                                                    <%
    Vector locations;
    if (DbSystemProperty.getValueByName("ALL_RECEIVE_LOCATION").equalsIgnoreCase("YES")) {
        locations = userLocations;//DbLocation.list(0, 0, "", "code"); 
    } else {
        locations = DbLocation.list(0, 0, "type='Warehouse'", "code");
    }
    if (locations != null && locations.size() > 0) {
        if (locations != null && locations.size() > 0) {
            long lokId = 0;
            if (user.getSegment1Id() != 0) {
                SegmentDetail sd = DbSegmentDetail.fetchExc(user.getSegment1Id());
                lokId = sd.getLocationId();
            }
            if (!receive.getStatus().equalsIgnoreCase("DRAFT")) {
                lokId = receive.getLocationId();
            }
            if (lokId == 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    if (receive.getLocationId() == d.getOID()) {
                        ig.setReceiveIn(d.getName());
                    }
                                                    %>
                                                    <option value="<%=d.getOID()%>" <%if (receive.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                    <%}
                                                            } else {
                                                                Location loc = new Location();
                                                                try {
                                                                    loc = DbLocation.fetchExc(lokId);
                                                                    ig.setReceiveIn(loc.getName());
                                                                } catch (Exception ec) {

                                                                }
                                                    %>
                                                    <option onClick="javascript:cmdLocation()" value="<%=loc.getOID()%>" selected><%=loc.getName()%></option>
                                                    <%}
                                                        }%>
                                                    <% }%>
                                                </select>
                                            </td>
                                            <%} else {
    Location loc = new Location();
    try {
        loc = DbLocation.fetchExc(receive.getLocationId());
        ig.setReceiveIn(loc.getName());
    } catch (Exception ex) {

    }
                                            %>
                                            <td height="20" colspan="2" width="42%" class="comment"> 
                                                <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>" value="<%=loc.getOID() %>" size="45" readonly class="readonly">
                                                <input type="text" name="_" value="<%=loc.getName() %>" size="45" readonly class="readonly">
                                            </td>
                                            <%}%>
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
            if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                if (receive.getStatus() == null || receive.getStatus().length() == 0) {
                    receive.setStatus(I_Project.DOC_STATUS_DRAFT);
                }
            } else {
                receive.setStatus(I_Project.DOC_STATUS_APPROVED);
            }

                                                %>
                                                <%if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                <input type="text" class="readOnly" name="stt" value="<%=(receive.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((receive.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : receive.getStatus())%>" size="15" readOnly>
                                                <%} else {%>
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
            if (receive.getPurchaseId() == 0 && vendorId == 0) {
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
            Vector x = drawList(iJSPCommand, jspReceiveItem, receiveItem, purchItems, oidReceiveItem, approot, receive.getVendorId(), iErrCode2, receive.getStatus(), isView, vErr, useStockCode, (receiveItem.getQty() * purchase_stock_qty), new Vector(), isSave, receive, isRefresh, opt_stock_code, useExpiredDate, itemMasterId, privEditIncoming);
            String strList = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
                                                    %>
                                                    <%=strList%> 
                                                    <% session.putValue("PURCHASE_DETAIL", rptObj);%>
                                                </td>
                                            </tr>
                                            <%if (iJSPCommand == JSPCommand.ADD && itemMasterId != 0) {%>
                                            <script language="JavaScript">
                                                document.frmreceive.itm_JSP_QTY.focus();
                                            </script>
                                            <%}%>
                                            <%if (iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.ADD && itemMasterId == 0)) {%>
                                            <script language="JavaScript">
                                                document.frmreceive.jsp_code_item.focus();
                                            </script>
                                            <%}%>
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
                                                                        <td width="200" nowrap><font color = "#FFFFFF">Delete 
                                                                        success</font></td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <%}%>
                                                        <tr> 
                                                            <td width="38%" valign="middle"> 
                                                                <%


            if ((privEditIncoming) || (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
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

                                                                        if (!receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {
                                                                            ctrLine.setSaveCaption("");
                                                                            ctrLine.setDeleteCaption("");
                                                                            ctrLine.setAddCaption("");
                                                                        }

                                                                            %>
                                                                            <%= ctrLine.drawImageOnly(iJSPCommand, err, msgString)%> 
                                                                        </td>
                                                                    </tr>
                                                                    <%} else {
                                                                        if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {

                                                                    %>
                                                                    <tr> 
                                                                        <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                    </tr>
                                                                    <%}
                                                                                }%>
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
                                                                            <div align="right"><b>Sub 
                                                                            Total</b></div>
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
                                                                            <%
            receive.setDiscountTotal((subTotal * receive.getDiscountPercent()) / 100);
            ig.setDiscount2(receive.getDiscountTotal());%>
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
                                                                            <%
            receive.setTotalTax(((subTotal - receive.getDiscountTotal()) * receive.getTaxPercent()) / 100);
            ig.setVat2(receive.getTotalTax());%>
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
                                                                            <%//ig.setGrandTotal(receive.getTotalAmount() + receive.getTotalTax() - receive.getDiscountTotal());
            ig.setGrandTotal(subTotal - receive.getDiscountTotal() + receive.getTotalTax());
                                                                            %>
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
                                                                <%if (!receive.getStatus().equals("CANCELED") && (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0 && !receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES"))) {%>
                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                    <tr> 
                                                                        <td colspan="3">&nbsp;</td>
                                                                    </tr>
                                                                    <%if (!receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>
                                                                    <tr> 
                                                                        <td width="12%"><b>Set 
                                                                        Status to</b></td>
                                                                        <td width="14%"> 
                                                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" onChange="javascript:cmdClosedReason()">
                                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                <%if (privApproveIncoming) {%>
                                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                <%}%>
                                                                                <%if (privApproveIncoming && 1 == 2) {%>
                                                                                <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CHECKED%></option>
                                                                                <%}%>
                                                                                <%if (privApproveIncoming && 1 == 2) {%>
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
                                                            <td colspan="3">Are you 
                                                                sure to delete document 
                                                            ?</td>
                                                            <td width="862">&nbsp;</td>
                                                        </tr>
                                                        <tr> 
                                                            <td width="149"><a href="javascript:cmdDeleteDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('yes21111','','../images/yes2.gif',1)"><img src="../images/yes.gif" name="yes21111" height="21" border="0"></a></td>
                                                            <td width="102"><a href="javascript:cmdCancelDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel211111','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel211111" height="22" border="0"></a></td>
                                                            <td width="97">&nbsp;</td>
                                                            <td width="862">&nbsp;</td>
                                                        </tr>
                                                        <%} else if (!receive.getStatus().equals("CANCELED")) {
    if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0) {
                                                        %>
                                                        <tr> 
                                                            <td colspan="4" class="errfont"></td>
                                                        </tr>
                                                        <%}%>
                                                        <%if (vendorItems != null && vendorItems.size() > 0) {
        if (receive.getOID() != 0) {
                                                        %>
                                                        <tr id="cmdline"> 
                                                            <%if (privAdd || privUpdate) {
                                                                if ((!receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED) && purchItems != null && purchItems.size() > 0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES"))) {%>
                                                            <td width="149"> 
                                                                <div onclick=""><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></div>
                                                            </td>
                                                            
                                                            <%}
                                                            }%>
                                                            <%if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>
                                                            <td width="102" > 
                                                                <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                            </td>
                                                            <%}%>
                                                            <%if (purchItems.size() > 0) {%>
                                                            <td width="97"> 
                                                                <div align="left"><a href="javascript:cmdPrintDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close2111111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close2111111" border="0"></a></div>
                                                            </td>
                                                            <td width="97"> 
                                                                <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                            </td>
                                                            <%}%>
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
                                            <tr align="left" id="cmdline1"> 
                                        <td colspan="5" valign="top" <%if (jspReceive.getErrorMsg(jspReceive.JSP_APPROVAL_1).length() > 0) {%>bgcolor="yellow"<%}%>><font color="red"><%=jspReceive.getErrorMsg(jspReceive.JSP_APPROVAL_1)%></font></td>
                                        </tr>                                              <tr align="left" > 
                                            <td colspan="5" valign="top"><font color="#009900">&nbsp;</font></td>
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
                                                        <td width="33%" class="tablecell1"><i>Approved 
                                                        by</i></td>
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
                                                    <%if (receive.getStatus().equals("CANCELED")) {%>
                                                    <tr> 
                                                        <td width="33%" class="tablecell1"><i>Canceled 
                                                        by </i></td>
                                                        <td width="34%" class="tablecell1"> 
                                                            <div align="center"><i>System</i></div>
                                                        </td>
                                                        <td width="33%" class="tablecell1"> 
                                                            <div align="center"><i><%=(receive.getApproval3Date() == null) ? "-" : JSPFormater.formatDate(receive.getApproval3Date(), "dd MMMM yy")%> 
                                                            </i></div>
                                                        </td>
                                                    </tr>
                                                    <%}%>
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
        </td>
    </tr>
    </table> 
    <%if (vectSize > 1) {%> 
    <script language="JavaScript">
        cmdAddItemMaster3();
    </script>
    <%}%>
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
        document.all.cmdline.style.display=""; 	
        //document.all.cmdline1.style.display="none"; 	
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
<%
            session.putValue("PURCHASE_TITTLE", ig);

//pengecekan stock final
            if (iJSPCommand == JSPCommand.POST && iErrCode == 0 && receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                int stokTrans = DbReceiveItem.getCount(" receive_id=" + receive.getOID());
                int stock = DbStock.getTotalStockByTransaksi(" incoming_id=" + receive.getOID() + " and location_id=" + receive.getLocationId());
                if (stokTrans != stock) {
                    DbReceiveItem.proceedStock(receive);//tambah stock dan update cogs        
                //proses penambahan stock - ketika status approve
                //DbStock.delete(DbStock.colNames[DbStock.COL_INCOMING_ID]+"="+ receive.getOID());
                //DbReceiveItem.proceedStock(receive);//tambah stock dan update cogs        
                //updateStockDateToApproveDate(receive);//sesuaikan tanggal stock ke approve date
                }
            }


%>
