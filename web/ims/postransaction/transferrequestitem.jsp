
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.ccs.posmaster.*" %> 
<%@ page import = "com.project.fms.master.*" %> 
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.system.*" %> 
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "java.io.IOException" %>
<%@ page import = "java.net.MalformedURLException" %>
<%@ page import = "java.net.URL" %>
<%@ page import = "java.net.URLConnection" %>
<%@ include file = "../main/javainit.jsp" %> 
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_TRANSFER, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
 public static double getStockByStatus(long locationId, long oidItemMaster, String status) {
        double result = 0;
        String sql = "";
        CONResultSet crs = null;
        try {
            sql = "select sum(qty * in_out) from pos_stock where status='" + status +
                    "' and location_id=" + locationId + " and item_master_id=" + oidItemMaster;
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet(); 
                while (rs.next()) {
                    result = rs.getDouble(1);
                }
            } catch (Exception ex) {

            }
        } catch (Exception ex) {

        }
        return result;
    }


    public Vector drawList(int iJSPCommand, JspTransferRequestItem frmObject,
            TransferRequestItem objEntity, Vector objectClass,
            long transferItemId, int iErrCode2, String status, TransferRequest transferRequest, long itemMasterId, QrUserSession appuser,
            String srccode, boolean editTrans) {

        Location locFrom = new Location();
        try{
            locFrom = DbLocation.fetchExc(transferRequest.getFromLocationId());
        }catch(Exception e){}
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");
        jsplist.addHeader("No", "5%");
        jsplist.addHeader("SKU", "10%");
        jsplist.addHeader("Barcode", "10%");
        jsplist.addHeader("Name", "");
        jsplist.addHeader("Category", "20%");
        jsplist.addHeader("Stock "+locFrom.getName(), "10%");
        jsplist.addHeader("Qty", "10%");
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
        
        
        for (int i = 0; i < objectClass.size(); i++) {

            TransferRequestItem transferRequestItem = (TransferRequestItem) objectClass.get(i);
            RptTranferL detail = new RptTranferL();
            rowx = new Vector();

            if (transferItemId == transferRequestItem.getOID()) {
                index = i;
            }

            if ((iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.ASK || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0)))) {
                isEdit = true;
                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                if (iJSPCommand == JSPCommand.ADD) {
                    objEntity.setItemMasterId(itemMasterId);
                } else if (iJSPCommand == JSPCommand.EDIT) {
                    objEntity.setItemMasterId(transferRequestItem.getItemMasterId());
                }

                ItemMaster colCombo2 = new ItemMaster();
                try {
                    colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                } catch (Exception e) {
                    System.out.println(e);
                }

                rowx.add("<div align=\"center\">" + (colCombo2.getCode()) + "</div>");

                if (vectVendMaster > 0) {
                    if (!srccode.equalsIgnoreCase("")) {
                        if (srccode.equals(colCombo2.getBarcode2())) {
                            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"JSP_ITEM_BARCODE\" value=\"" + colCombo2.getBarcode2() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:right\"> </div>");
                        } else if (srccode.equals(colCombo2.getBarcode3())) {
                            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"JSP_ITEM_BARCODE\" value=\"" + colCombo2.getBarcode3() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:right\"> </div>");
                        } else {
                            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"JSP_ITEM_BARCODE\" value=\"" + colCombo2.getBarcode() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:right\"> </div>");
                        }
                    } else {
                        rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"JSP_ITEM_BARCODE\" value=\"" + colCombo2.getBarcode() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:right\"> </div>");
                    }

                    String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                    strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:left\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + "\"  size=\"35\" onChange=\"javascript:cmdAddItemMaster()\" >" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                    strVal += "<tr><td></td><td></td><td></td></tr>";
                    strVal += "</table>";

                    rowx.add(strVal);

                } else {
                    rowx.add("");
                    rowx.add("<font color=\"red\">No stock available for transferRequest</font>");

                }

                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:right\"> </div>");

                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(getStockByStatus(transferRequest.getFromLocationId(), objEntity.getItemMasterId(), "APPROVED"), "#,###.##") + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspTransferRequestItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\"  onkeypress=\"cmdSaveOnEnter(event)\">" + "</div>");

                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"unit_code\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:center\">" + "</div>");

            } else {

                ItemMaster itemMaster = new ItemMaster();
                ItemGroup ig = new ItemGroup();
                ItemCategory ic = new ItemCategory();
                try {
                    itemMaster = DbItemMaster.fetchExc(transferRequestItem.getItemMasterId());
                    ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                    ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                } catch (Exception e) {
                }

                Uom uom = new Uom();
                try {
                    uom = DbUom.fetchExc(itemMaster.getUomStockId());
                } catch (Exception e) {
                }

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                rowx.add("<div align=\"left\">" + itemMaster.getCode() + "</div>");
                rowx.add("<div align=\"left\">" + transferRequestItem.getItemBarcode() + "</div>");

                if ((appuser.getUserOID() == transferRequest.getUserId() || (editTrans && status.equals(I_Project.DOC_STATUS_DRAFT))) && ((status != null && status.equals(I_Project.DOC_STATUS_DRAFT)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {

                    rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(transferRequestItem.getOID()) + "')\">" + itemMaster.getName() + "</a>");
                    detail.setName(itemMaster.getName());
                    detail.setCode(itemMaster.getCode());
                    detail.setBarcode(transferRequestItem.getItemBarcode());
                    detail.setCategory(ig.getName());
                } else {
                    rowx.add(itemMaster.getName());
                    detail.setName(itemMaster.getName());
                    detail.setBarcode(transferRequestItem.getItemBarcode());
                    detail.setCode(itemMaster.getCode());
                    detail.setCategory(ig.getName());
                }
                detail.setPrice(0);

                rowx.add("<div align=\"left\">" + ig.getName() + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(getStockByStatus(transferRequest.getFromLocationId(), transferRequestItem.getItemMasterId(), "APPROVED"), "#,###.##") + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(transferRequestItem.getQty(), "#,###.##") + "</div>");
                detail.setQty(transferRequestItem.getQty());
                rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
            }

            lstData.add(rowx);
            temp.add(detail);
        }

        rowx = new Vector();

        if (transferRequest.getFromLocationId() != 0 && transferRequest.getToLocationId() != 0 && iJSPCommand != JSPCommand.POST && isEdit == false && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && transferItemId == 0))) {
            //masuk
            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");
            objEntity.setItemMasterId(itemMasterId);
            ItemMaster colCombo2 = new ItemMaster();

            try {
                colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());

            } catch (Exception e) {
                System.out.println(e);
            }

            rowx.add("<div align=\"center\">" + (colCombo2.getCode()) + "</div>");

            if (vectVendMaster > 0) {

                String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                if (!srccode.equalsIgnoreCase("")) {
                    if (srccode.equals(colCombo2.getBarcode2())) {
                        rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"JSP_ITEM_BARCODE\" value=\"" + colCombo2.getBarcode2() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:left\"> </div>");
                    } else if (srccode.equals(colCombo2.getBarcode3())) {
                        rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"JSP_ITEM_BARCODE\" value=\"" + colCombo2.getBarcode3() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:left\"> </div>");
                    } else {
                        rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"JSP_ITEM_BARCODE\" value=\"" + colCombo2.getBarcode() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:left\"> </div>");
                    }
                } else {
                    rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"JSP_ITEM_BARCODE\" value=\"" + colCombo2.getBarcode() + "\" onChange=\"javascript:cmdAddItemMaster2()\" style=\"text-align:left\"> </div>");
                }
                strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:left\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + "\" onChange=\"javascript:cmdAddItemMaster()\" size=\"35\" >" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";

                strVal += "<tr><td></td><td></td><td></td></tr>";
                strVal += "</table>";

                rowx.add(strVal);

            } else {
                rowx.add("");
                rowx.add("<font color=\"red\">No stock item available for transferRequest</font>");

            }


            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:right\"> </div>");
            rowx.add("<div align=\"center\">" + getStockByStatus(transferRequest.getFromLocationId(), objEntity.getItemMasterId(), "APPROVED")+" </div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspTransferRequestItem.JSP_QTY] + "\" value=\"\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onChange=\"javascript:calculateSubTotal()\" onClick=\"this.select()\"  onkeypress=\"cmdSaveOnEnter(event)\">" + "</div>");
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
            long oidTransfer = JSPRequestValue.requestLong(request, "hidden_transfer_request_id");
            long oidTransferItem = JSPRequestValue.requestLong(request, "hidden_transfer_request_item_id");

            long oidLocationFrom = JSPRequestValue.requestLong(request, "hidden_locationIdFrom");
            long oidLocationTo = JSPRequestValue.requestLong(request, "hidden_locationIdTo");
            long itemMasterId = JSPRequestValue.requestLong(request, JspTransferRequestItem.colNames[JspTransferRequestItem.JSP_ITEM_MASTER_ID]);
            String srcCode = JSPRequestValue.requestString(request, "JSP_ITEM_BARCODE");
            int showAll = JSPRequestValue.requestInt(request, "showAll");

            boolean ediTransfer = privEditTransfer;            
            boolean isRefresh = false;
            
            long lokFrom = 0;
            if (user.getSegment1Id() != 0) {
                try {
                    SegmentDetail sd = DbSegmentDetail.fetchExc(user.getSegment1Id());
                    lokFrom = sd.getLocationId();
                } catch (Exception ex) {
                }
            }

            if (iJSPCommand == JSPCommand.REFRESH) {
                iJSPCommand = JSPCommand.EDIT;
                isRefresh = true;
            }

            if (iJSPCommand == JSPCommand.GET) {
                iJSPCommand = JSPCommand.VIEW;
            }

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidTransfer = 0;                
            }            

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            RptTranfer rptKonstan = new RptTranfer();

            CmdTransferRequest CmdTransferRequest = new CmdTransferRequest(request);
            JSPLine ctrLine = new JSPLine();

            CmdTransferRequest.setUserId(appSessUser.getUserOID());
            iErrCode = CmdTransferRequest.action(iJSPCommand, oidTransfer);

            JspTransferRequest jspTransferRequest = CmdTransferRequest.getForm();
            TransferRequest transferRequest = CmdTransferRequest.getTransfer();
            if (transferRequest.getStatus().equals("") && transferRequest.getOID() != 0) {
                transferRequest.setStatus(I_Project.DOC_STATUS_DRAFT);
                DbTransferRequest.updateExc(transferRequest);
            }


            msgString = CmdTransferRequest.getMessage();

            if (oidTransfer == 0) {
                oidTransfer = transferRequest.getOID();
                if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                    transferRequest.setStatus(I_Project.DOC_STATUS_DRAFT);
                } else {
                    transferRequest.setStatus(I_Project.DOC_STATUS_APPROVED);
                }
            } else {
                try {
                    //transferRequest = DbTransferRequest.fetchExc(oidTransfer);
                } catch (Exception e) {}
            }

            //whereClause = DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ID] + "=" + oidTransfer;
            //orderClause = DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ITEM_ID];

            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            CmdTransferRequestItem cmdTransferRequestItem = new CmdTransferRequestItem(request);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.REFRESH;
            }

            cmdTransferRequestItem.setUserId(appSessUser.getUserOID());
            iErrCode2 = cmdTransferRequestItem.action(iJSPCommand, oidTransferItem, oidTransfer);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.EDIT;
            }
            JspTransferRequestItem jspTransferRequestItem = cmdTransferRequestItem.getForm();
            TransferRequestItem transferRequestItem = cmdTransferRequestItem.getTransferItem();
            msgString2 = cmdTransferRequestItem.getMessage();

            whereClause = DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ID] + "=" + oidTransfer;
            orderClause = DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ITEM_ID];
            String msgSuccsess = "";
            Vector transferItems = DbTransferRequestItem.list(0, 0, whereClause, orderClause);

            if (iJSPCommand == JSPCommand.VIEW) {                
                iJSPCommand = JSPCommand.ADD;
            }

            Vector vendors = new Vector();
            
            Vector locationsFrom = userLocations;
            Vector locations = userLocations;
            
            long fromOid = 0;
            
            if (transferRequest.getFromLocationId() == 0 && locations != null && locations.size() > 0) {
                transferRequest.setFromLocationId(oidLocationFrom);
            }
            if (transferRequest.getFromLocationId() == 0 && locations != null && locations.size() > 0) {
                Location lxx = (Location) locations.get(0);
                fromOid = lxx.getOID();
                transferRequest.setFromLocationId(lxx.getOID());
            }
            if (transferRequest.getFromLocationId() != 0 && locations != null && locations.size() > 0) {
                fromOid = transferRequest.getFromLocationId();
            }
            
            if(transferRequest.getToLocationId()==0 && locations != null && locations.size() > 0){
                transferRequest.setToLocationId(oidLocationTo);
            }
            

            if (iJSPCommand == JSPCommand.SAVE) {
                srcCode = "";
            }

            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) {

                if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                    if (iJSPCommand == JSPCommand.SAVE) {
                        iJSPCommand = JSPCommand.POST;
                        iErrCode = CmdTransferRequest.action(iJSPCommand, oidTransfer);
                    }
                }

                iJSPCommand = JSPCommand.ADD;
                oidTransferItem = 0;
                itemMasterId = 0;
                transferRequestItem = new TransferRequestItem();
                msgSuccsess = "Data is saved";
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidTransferItem = 0;
                transferRequestItem = new TransferRequestItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0)) {
                try {
                    transferRequest = DbTransferRequest.fetchExc(oidTransfer);
                } catch (Exception e) {
                }
            }

            Vector vItem = new Vector();
            
            if (iJSPCommand != JSPCommand.SAVE && iJSPCommand != JSPCommand.POST) {
                if (srcCode.length() > 0) {
                    vItem = DbItemMaster.list(0, 0, "barcode ='" + srcCode + "' or barcode_2 ='" + srcCode + "' or barcode_3 ='" + srcCode + "' or code='" + srcCode + "'", "");            
                    if (vItem != null && vItem.size() == 1) {
                        ItemMaster im = (ItemMaster) vItem.get(0);
                        itemMasterId = im.getOID();
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
                
                function cmdSaveOnEnter(e){       
                    if (typeof e == 'undefined' && window.event) { e = window.event; }
                    
                    if (e.keyCode == 13){
                        cmdSave();					              
                    } 
                }
                
                
                function cmdAddItemMaster(){   
                    var oidLoc = document.frmtransfer.hidden_locationIdFrom.value;
                    var oidLocTo = document.frmtransfer.hidden_locationIdTo.value;
                    var itemName =document.frmtransfer.X_JSP_ITEM_MASTER_ID.value;       
                    document.frmtransfer.JSP_ITEM_BARCODE.value="";
                    
                    window.open("<%=approot%>/postransaction/addItemTrfReq.jsp?location_id=" + oidLoc + "&location_to_id="+oidLocTo+"&item_name=" + itemName+"&transfer_id=<%=oidTransfer%>" , null, "height=600,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                        document.frmtransfer.command.value="<%=JSPCommand.ADD%>";
                        document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
                        document.frmsalesproductdetail.submit();   
                        
                    }
                    
                    function cmdAddItemMaster3(){
                        var oidLoc = document.frmtransfer.hidden_locationIdFrom.value;
                        var itemCode =document.frmtransfer.hidden_item_code.value;
                        window.open("<%=approot%>/postransaction/addItemTrfReq.jsp?location_id=" + oidLoc + "&item_code=" + itemCode , null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                            document.frmtransfer.command.value="<%=JSPCommand.ADD%>";
                            document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
                            document.frmsalesproductdetail.submit();   
                            
                        }
                        
                        function cmdAddItemMaster2(){ 
                            var itemCode =document.frmtransfer.JSP_ITEM_BARCODE.value;
                            
                            var oidLoc = document.frmtransfer.hidden_locationIdFrom.value;
                            
                            //alert(itemName);
                            document.frmtransfer.JSP_ITEM_MASTER_ID.value=0;
                            document.frmtransfer.command.value="<%=JSPCommand.ADD%>";
                            
                            document.frmtransfer.submit();  
                            
                            
                        }
                        
                        
                        
                        function cmdPrintPdf(){
                            window.open("<%=printroot%>.report.RptTransferOrderPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                            }
                            
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
                            
                            
                            
                            function cmdAddNewDoc(){
                                document.frmtransfer.hidden_transfer_request_item_id.value="0";
                                document.frmtransfer.hidden_transfer_request_id.value="0";
                                document.frmtransfer.hidden_locationIdFrom.value="0";
                                document.frmtransfer.JSP_TO_LOCATION_ID.value="0";                            
                                document.frmtransfer.command.value="<%=JSPCommand.RESET%>";
                                document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                                document.frmtransfer.action="transferrequestitem.jsp";
                                document.frmtransfer.submit();
                            }
                            
                            function calculateSubTotal(){
                                var qty = document.frmtransfer.<%=JspTransferRequestItem.colNames[JspTransferRequestItem.JSP_QTY]%>.value;
                                
                                qty = removeChar(qty);
                                qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                                document.frmtransfer.<%=JspTransferRequestItem.colNames[JspTransferRequestItem.JSP_QTY]%>.value = qty;
                                
                                var totalItemAmount = (parseFloat(amount) * parseFloat(qty));
                                
                                var subtot = 0;
                                subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                                
                                
         <%
            //add
            if (oidTransferItem == 0) {%>
                    
                    <%} else {%>
                    
         <%}
         %>
             
             calculateAmount();
             //alert(qty);
         }
         
         
         function cmdVatEdit(){
             
             calculateAmount();
         }
         
         function cmdLocation(){             
             <%if (transferRequest.getOID() != 0 && transferItems != null && transferItems.size() > 0) {%>
             if(confirm('Warning !!\nChange the location could effect to deletion of some or all transfer request item ')){
                 document.frmtransfer.command.value="<%=JSPCommand.LOAD%>";
                 document.frmtransfer.action="transferrequestitem.jsp";
                 document.frmtransfer.submit();
             }
             <%} else {%>
             document.frmtransfer.command.value="<%=JSPCommand.LOAD%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
             <%}%>
         }
         
         function cmdToRecord(){
             document.frmtransfer.command.value="<%=JSPCommand.NONE%>";
             document.frmtransfer.action="transferrequestlist.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdVendorChange(){
             var oid = document.frmtransfer.<%=JspTransferRequest.colNames[JspTransferRequest.JSP_FROM_LOCATION_ID]%>.value;
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
         
         function calculateAmount(){}
         
         function cmdClosedReason(){}
         
         function cmdCloseDoc(){
             document.frmtransfer.action="<%=approot%>/home.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdAskDoc(){
             document.frmtransfer.hidden_transfer_request_item_id.value="0";
             document.frmtransfer.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdDeleteDoc(){
             document.frmtransfer.hidden_transfer_request_item_id.value="0";
             document.frmtransfer.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdCancelDoc(){
             document.frmtransfer.hidden_transfer_request_item_id.value="0";
             document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdSaveDoc(){
             document.frmtransfer.command.value="<%=JSPCommand.POST%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdAdd(){             
             document.frmtransfer.hidden_transfer_request_item_id.value="0";
             document.frmtransfer.command.value="<%=JSPCommand.ADD%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdAsk(oidTransferItem){
             document.frmtransfer.hidden_transfer_request_item_id.value=oidTransferItem;
             document.frmtransfer.command.value="<%=JSPCommand.ASK%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdAskMain(oidTransfer){
             document.frmtransfer.hidden_transfer_request_id.value=oidTransfer;
             document.frmtransfer.command.value="<%=JSPCommand.ASK%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferRequest.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdConfirmDelete(oidTransferItem){
             document.frmtransfer.hidden_transfer_request_item_id.value=oidTransferItem;
             document.frmtransfer.command.value="<%=JSPCommand.DELETE%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         function cmdSaveMain(){
             document.frmtransfer.command.value="<%=JSPCommand.SAVE%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferRequest.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdSave(){
             document.frmtransfer.command.value="<%=JSPCommand.SAVE%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdEdit(oidTransfer){
             document.frmtransfer.hidden_transfer_request_item_id.value=oidTransfer;
             document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdEditTransfer(oid){
             document.frmtransfer.hidden_transfer_id.value=oid;
             document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.action="transferitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdBack(){
             document.frmtransfer.command.value="<%=JSPCommand.BACK%>";
             document.frmtransfer.action="transferrequestitem.jsp";
             document.frmtransfer.submit();
         }
         
         function cmdShowAll(){
             document.frmtransfer.command.value="<%=JSPCommand.REFRESH%>";
             document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
             document.frmtransfer.showAll.value="1";
             document.frmtransfer.action="transferrequestitem.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif','../images/newdoc2.gif','../images/printxls2.gif','../images/deletedoc2.gif')">
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
                                                        <form name="frmtransfer" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="showAll" value="<%= showAll %>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspTransferRequest.colNames[JspTransferRequest.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_transfer_request_item_id" value="<%=oidTransferItem%>">
                                                            <input type="hidden" name="hidden_transfer_request_id" value="<%=oidTransfer%>">
                                                            <input type="hidden" name="transfer_id" value="0">
                                                            <input type="hidden" name="hidden_transfer_id" value="0">
                                                            <input type="hidden" name="<%=JspTransferRequestItem.colNames[JspTransferRequestItem.JSP_TRANSFER_REQUEST_ID]%>" value="<%=oidTransfer%>">
                                                            <input type="hidden" name="hidden_locationIdFrom" value="<%=transferRequest.getFromLocationId()%>">
                                                            <input type="hidden" name="hidden_locationIdTo" value="<%=transferRequest.getToLocationId()%>">
                                                            <input type="hidden" name="hidden_item_code" value="<%= srcCode %>">
                                                            <%if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                                                            <input type="hidden" name="<%=jspTransferRequest.colNames[jspTransferRequest.JSP_STATUS]%>" value="<%=transferRequest.getStatus()%>">
                                                            <%}%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Stock 
                                                                                        Managemenet </font><font class="tit1">&raquo; 
                                                                                <span class="lvl2">Transfer Request</span></font></b></td>
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
                                                                                                <div align="center">&nbsp;&nbsp;Transfer Request 
                                                                                                &nbsp;&nbsp;</div>
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
                                                                                                        <td height="21" valign="middle" width="7%">&nbsp;</td>
                                                                                                        <td height="21" valign="middle" width="32%">&nbsp;</td>
                                                                                                        <td height="21" valign="middle" width="9%">&nbsp;</td>
                                                                                                        <td height="21" colspan="2" width="52%" class="comment" valign="top"> 
                                                                                                            <div align="right">&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="26" width="7%">&nbsp;Request From</td>
                                                                                                        <td height="26" width="32%">                                                                                                            
                                                                                                            <%if (oidTransfer == 0) {%>
                                                                                                            <select name="<%=JspTransferRequest.colNames[JspTransferRequest.JSP_FROM_LOCATION_ID]%>" onChange="javascript:cmdLocation()" >
                                                                                                                <option value="0">- None -</option>
                                                                                                                <%

    if (locations != null && locations.size() > 0) {
        long lokId = 0;
        if (user.getSegment1Id() != 0) {
            SegmentDetail sd = DbSegmentDetail.fetchExc(user.getSegment1Id());
            lokId = sd.getLocationId();
        }
        if (lokId == 0) {
            for (int i = 0; i < locations.size(); i++) {
                Location d = (Location) locations.get(i);
                if (transferRequest.getFromLocationId() == d.getOID()) {
                    rptKonstan.setFrom(d.getName());
                }
                //if (d.getType().equals("Store") || d.getType().equals("Warehouse")) {
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (transferRequest.getFromLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%//}
                                                                                                                            }
                                                                                                                        } else {
                                                                                                                            Location loc = new Location();
                                                                                                                            try {
                                                                                                                                loc = DbLocation.fetchExc(lokId);
                                                                                                                                rptKonstan.setFrom(loc.getName());
                                                                                                                            } catch (Exception ec) {

                                                                                                                            }
                                                                                                                %>
                                                                                                                <option onClick="javascript:cmdLocation()" value="<%=loc.getOID()%>" selected><%=loc.getName()%></option>
                                                                                                                <%}%>
                                                                                                                <%}%>
                                                                                                            </select> 
                                                                                                            <%} else {
    try {
        Location l = DbLocation.fetchExc(transferRequest.getFromLocationId());
        out.println(l.getName());
        rptKonstan.setFrom(l.getName());
    } catch (Exception e) {
    }%>
                                                                                                            <input type="hidden" name="<%=JspTransferRequest.colNames[JspTransferRequest.JSP_FROM_LOCATION_ID]%>" value="<%=transferRequest.getFromLocationId()%>" >
                                                                                                            <%}%>
                                                                                                            <%=(iJSPCommand == JSPCommand.SAVE) ? jspTransferRequest.getErrorMsg(jspTransferRequest.JSP_FROM_LOCATION_ID) : ""%>
                                                                                                        </td>
                                                                                                        <td height="26" width="9%">Request To</td>
                                                                                                        <td height="26" colspan="2" width="52%" class="comment"> 
                                                                                                            <%if ((lokFrom == 0 || transferRequest.getUserId() == user.getOID() || transferRequest.getUserId() == 0) && (!transferRequest.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                                                                                                            <select name="<%=JspTransferRequest.colNames[JspTransferRequest.JSP_TO_LOCATION_ID]%>" onChange="javascript:cmdLocation()">
                                                                                                                <%if (oidTransfer == 0) {%>
                                                                                                                <option value="0">- None -</option>
                                                                                                                <%}%>
                                                                                                                <%
    //transferRequest bisa ke semua lokasi
    locations = DbLocation.list(0, 0, " (type='Warehouse' or type='Store') and "+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" != "+transferRequest.getFromLocationId(), "name");

    if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location d = (Location) locations.get(i);
            if (transferRequest.getToLocationId() == d.getOID()) {
                rptKonstan.setTo(d.getName());
            }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (transferRequest.getToLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
    }%>
                                                                                                            </select>
                                                                                                            <%} else {
    try {
        Location l = DbLocation.fetchExc(transferRequest.getToLocationId());
        out.println(l.getName());
        rptKonstan.setTo(l.getName());
    } catch (Exception e) {
    }%>
                                                                                                            <input type="hidden" name="<%=JspTransferRequest.colNames[JspTransferRequest.JSP_TO_LOCATION_ID]%>" value="<%=transferRequest.getToLocationId()%>">
                                                                                                            <% }%>
                                                                                                        <%=(iJSPCommand == JSPCommand.SAVE) ? jspTransferRequest.getErrorMsg(jspTransferRequest.JSP_TO_LOCATION_ID) : ""%> </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="7%">&nbsp;Number</td>
                                                                                                        <td height="21" width="32%"> 
                                                                                                            <%
            String number = "";
            if (transferRequest.getOID() == 0) {
                int ctr = DbTransferRequest.getNextCounter(transferRequest.getFromLocationId());
                number = DbTransferRequest.getNextNumber(ctr, transferRequest.getFromLocationId());
                rptKonstan.setNumber(number);
            } else {
                number = transferRequest.getNumber();
                rptKonstan.setNumber(number);
            }
                                                                                                            %>
                                                                                                            <input type="text" name="textfield" size="15" value="<%=number%>" class="readonly" readonly>
                                                                                                        </td>
                                                                                                        <td width="9%">Date</td>
                                                                                                        <td colspan="2" class="comment" width="52%"> 
                                                                                                            <input name="<%=JspTransferRequest.colNames[JspTransferRequest.JSP_DATE]%>" value="<%=JSPFormater.formatDate((transferRequest.getDate() == null) ? new Date() : transferRequest.getDate(), "dd/MM/yyyy")%>" size="15" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmtransfer.<%=JspTransferRequest.colNames[JspTransferRequest.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%
            rptKonstan.setTanggal(transferRequest.getDate());
                                                                                                            %>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="7%">&nbsp;Notes</td>
                                                                                                        <td height="21" width="32%"> 
                                                                                                            <input type="text" name="<%=JspTransferRequest.colNames[JspTransferRequest.JSP_NOTE]%>" size="40" value="<%=transferRequest.getNote()%>">
                                                                                                        </td>
                                                                                                        <td width="9%">Status</td>
                                                                                                        <td colspan="2" class="comment" width="52%"> 
                                                                                                            <%
            if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                if (transferRequest.getStatus() == null) {
                    transferRequest.setStatus(I_Project.DOC_STATUS_DRAFT);
                }
            }
                                                                                                            %>
                                                                                                            <% if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                                                            <input type="text" class="readOnly" name="stt" value="<%=(transferRequest.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((transferRequest.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : transferRequest.getStatus())%>" size="15" readOnly>
                                                                                                            <% } else {%>
                                                                                                            <input type="text" class="readOnly" name="stt" value="<%=I_Project.DOC_STATUS_APPROVED%>" size="15" readOnly>
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
            if (transferRequest.getGenId() != 0) {
                Transfer t = new Transfer();
                try {
                    t = DbTransfer.fetchExc(transferRequest.getGenId());
                } catch (Exception e) {
                }

                                                                                                    %>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="7%">&nbsp;TRF. Number</td>
                                                                                                        <td height="21" width="32%"><a href="javascript:cmdEditTransfer('<%=transferRequest.getGenId()%>')" ><%=t.getNumber()%></a></td> 
                                                                                                    </tr>    
                                                                                                    <%}%>    
                                                                                                    <%
            rptKonstan.setNotes(transferRequest.getNote());
                                                                                                    %>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(iJSPCommand, jspTransferRequestItem, transferRequestItem, transferItems, oidTransferItem, iErrCode2, transferRequest.getStatus(), transferRequest, itemMasterId, appSessUser, srcCode, ediTransfer);
            String strString = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
                                                                                                            %>
                                                                                                            <%=strString%> 
                                                                                                            <% session.putValue("DETAIL", rptObj);%>
                                                                                                            <%if (iJSPCommand == JSPCommand.ADD && itemMasterId != 0) {%>
                                                                                                            <script language="JavaScript">
                                                                                                                document.frmtransfer.JSP_QTY.focus();
                                                                                                            </script>
                                                                                                            <%}%>
                                                                                                            <%if (iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.ADD && itemMasterId == 0)) {%>
                                                                                                            <script language="JavaScript">
                                                                                                                document.frmtransfer.JSP_ITEM_BARCODE.focus();
                                                                                                            </script>
                                                                                                            <%}%>
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
                                                                                                                        <%if (((appSessUser.getUserOID() == transferRequest.getUserId() || (privEditTransfer && transferRequest.getStatus().equalsIgnoreCase(I_Project.DOC_STATUS_DRAFT))) || transferRequest.getOID() == 0 || transferRequest.getUserId() == 0) && (((transferRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) || iJSPCommand == JSPCommand.CONFIRM) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                                                                                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <%
                                                                                                                            if(!(transferRequest.getFromLocationId() == 0 || transferRequest.getToLocationId() == 0)){
    if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.EDIT && oidTransferItem != 0) || iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
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
                                                                                                                            <tr> 
                                                                                                                                <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/new2.gif',1)"><img src="../images/new.gif" name="new211" width="71" height="22" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>                       
                                                                                                                            <%}else{%>   
                                                                                                                            <font color="#FF0000"><i>Please select location request from and request to</i></font>
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="55%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (transferRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && transferRequest.getOID() != 0 && transferItems != null && transferItems.size() > 0) {%>
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
                                                                                                                        <%if (transferRequest.getOID() != 0 && transferItems != null && transferItems.size() > 0) {%>
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="12%">&nbsp;</td>
                                                                                                                                <td width="14%">&nbsp;</td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%if ((transferRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT) || iErrCode != 0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%" nowrap><b>Set 
                                                                                                                                Status to</b>&nbsp;&nbsp;</td>
                                                                                                                                <td width="14%"> 
                                                                                                                                    <select name="<%=JspTransferRequest.colNames[JspTransferRequest.JSP_STATUS]%>">
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (transferRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                                        <%if (posApprove1Priv) {%>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (transferRequest.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                                        <%}%>
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_CANCELED%>" <%if (transferRequest.getStatus().equals(I_Project.DOC_STATUS_CANCELED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_CANCELED%></option>
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
                                                                                                                <%} else if (oidTransfer != 0) {%>
                                                                                                                <tr> 
                                                                                                                    <%if (transferItems != null && transferItems.size() > 0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                                                                    <%if (transferRequest.getStatus().equalsIgnoreCase("DRAFT")) {%>
                                                                                                                    <td width="149" nowrap> 
                                                                                                                        <div onclick="this.style.visibility='hidden'"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a>&nbsp;&nbsp;</div>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <%}%>
                                                                                                                    <%if (transferItems.size() > 0) {%>
                                                                                                                    <td width="150" nowrap> 
                                                                                                                        <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="close211111" border="0"></a>&nbsp;&nbsp;</div>
                                                                                                                    </td>
                                                                                                                    <td width="150" nowrap> 
                                                                                                                        <div align="left"><a href="javascript:cmdAddNewDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/newdoc2.gif',1)"><img src="../images/newdoc.gif" name="new21" height="22" border="0"></a>&nbsp;&nbsp;</div>
                                                                                                                    </td>
                                                                                                                    <%}%>                                                                                                                    
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
                                                                                                    <%if (transferRequest.getOID() != 0 && transferItems != null && transferItems.size() > 0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
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
                                                                                                                    by</td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    User u = new User();
    try {
        u = DbUser.fetch(transferRequest.getUserId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(transferRequest.getCreateDate(), "dd MMMM yy HH:mm")%></i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1">Approved/Cancelled 
                                                                                                                    by</td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(transferRequest.getApproval1());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (transferRequest.getApproval1() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(transferRequest.getApproval1Date(), "dd MMMM yy HH:mm")%>
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>            
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td>&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td colspan="5">
                                                                                                            
                                                                                                            <table width="700px" cellpadding="0" cellspacing="0">
                                                                                                                <tr>
                                                                                                                    <td colspan="2"><b><i><u>Update History</u></i></b></td>
                                                                                                                </tr>
                                                                                                                <tr height="1">
                                                                                                                    <td colspan="3" bgcolor="#000000"></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" align="center"><b>Date</b></td>
                                                                                                                    <td class="tablecell1" align="center"><b>Username</b></td>
                                                                                                                    <td class="tablecell1" align="center"><b>Operation</b></td>
                                                                                                                </tr>
                                                                                                                <tr height="1">
                                                                                                                    <td colspan="3" bgcolor="#000000"></td>
                                                                                                                </tr>
                                                                                                                <%
    Vector vHistory = new Vector();
    try {
        if (showAll == 0) {
            vHistory = DbDocumentHistory.list(0, 3, DbDocumentHistory.colNames[DbDocumentHistory.COL_REF_ID] + "=" + transferRequest.getOID() + " and " + DbDocumentHistory.colNames[DbDocumentHistory.COL_TYPE] + "=" + DbDocumentHistory.TYPE_DOC_TRANSFER, DbDocumentHistory.colNames[DbDocumentHistory.COL_DATE] + " desc");
        } else {
            vHistory = DbDocumentHistory.list(0, 0, DbDocumentHistory.colNames[DbDocumentHistory.COL_REF_ID] + "=" + transferRequest.getOID() + " and " + DbDocumentHistory.colNames[DbDocumentHistory.COL_TYPE] + "=" + DbDocumentHistory.TYPE_DOC_TRANSFER, DbDocumentHistory.colNames[DbDocumentHistory.COL_DATE] + " desc");
        }
    } catch (Exception e) {
        System.out.println(e.toString());
    }

    if (vHistory != null && vHistory.size() > 0) {
        for (int i = 0; i < vHistory.size(); i++) {
            DocumentHistory history = (DocumentHistory) vHistory.get(i);
            User userlogs = DbUser.fetch(history.getUserId());
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td class="tablecell1" nowrap><%= JSPFormater.formatDate(history.getDate(), "dd MMMM yy HH:mm:ss") %> &nbsp;&nbsp;&nbsp;</td>
                                                                                                                    <td class="tablecell1" nowrap><%= userlogs.getLoginId() %> &nbsp;&nbsp;&nbsp;</td>
                                                                                                                    <td class="tablecell1"><%= history.getDescription() %></td>
                                                                                                                </tr>
                                                                                                                <tr height="2">
                                                                                                                    <td colspan="3" bgcolor="#ffffff"></td>
                                                                                                                </tr>
                                                                                                                <%
        }
    }
                                                                                                                %>
                                                                                                                <% if (showAll == 0) {%>
                                                                                                                <tr>
                                                                                                                    <td class="" colspan="3"><a href="javascript:cmdShowAll()">Show all</a></td>
                                                                                                                </tr>
                                                                                                                <% } %>
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
                                                                                                                       
                                                            <script language="JavaScript">
                                                                <%if (transferRequest.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && transferRequestItem.getOID() != 0) || iErrCode != 0)) {%>
                                                                
                                                         <%}
            if (transferRequest.getOID() != 0 && !transferRequest.getStatus().equals(I_Project.DOC_STATUS_CLOSE)) {%>
                    
                    <%}%>
                                                            </script>
                                                            <%

                                                            %>
                                                        </form>
                                                        <%
            session.putValue("KONSTAN", rptKonstan);
            session.putValue("NAMA_USER", user.getFullName());
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
