
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %> 
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.repack.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>  
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(int iJSPCommand, JspRepackItem frmObject, RepackItem objEntity, Vector objectClass, long costingItemId, long oidLocation,
            int iErrCode2, String status, Repack repack, long itemMasterId) {
        
        String showCogs = "NO";
        try{
            showCogs = DbSystemProperty.getValueByName("INV_SHOW_COGS");
        }catch(Exception e){}   
        

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablearialhdr");
        jsplist.setCellStyle("tablearialcell");
        jsplist.setCellStyle1("tablearialcell1");
        jsplist.setHeaderStyle("tablearialhdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Code/SKU", "10%");
        jsplist.addHeader("Barcode", "10%");
        jsplist.addHeader("Name", "");
        jsplist.addHeader("Type", "10%");
        jsplist.addHeader("% Output", "7%");
        jsplist.addHeader("Qty Stock", "7%");
        jsplist.addHeader("Qty Input/Output", "7%");
        if(showCogs.equals("YES")){
            jsplist.addHeader("Cogs", "9%");
            jsplist.addHeader("Total Cost", "10%");
        }
        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();

        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;
        Vector temp = new Vector();

        /* selected Type*/
        Vector type_value = new Vector(1, 1);
        Vector type_key = new Vector(1, 1);
        
        int cOutput = DbRepackItem.getCount("repack_id=" + repack.getOID() + " and type=1");
        type_value.add("" + 0);
        type_key.add("STOK KELUAR");
        if (cOutput < 1) {
            type_value.add("" + 1);
            type_key.add("STOK MASUK");
        }

        boolean isEdit = false;
        
        for (int i = 0; i < objectClass.size(); i++) {

            RepackItem repackItem = (RepackItem) objectClass.get(i);
            RptRepackL detail = new RptRepackL();

            rowx = new Vector();

            if (costingItemId == repackItem.getOID()) {
                index = i;
            }

            if ((iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.ASK || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0)))) {

                isEdit = true;
                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");

                if (iJSPCommand == JSPCommand.ADD) {
                    objEntity.setItemMasterId(itemMasterId);
                } else if (iJSPCommand == JSPCommand.EDIT) {
                    objEntity.setItemMasterId(repackItem.getItemMasterId());
                }

                ItemMaster colCombo2 = new ItemMaster();
                try {
                    colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                } catch (Exception e) {
                    System.out.println(e);
                }

                Uom uom = new Uom();
                try {
                    uom = DbUom.fetchExc(colCombo2.getUomStockId());
                } catch (Exception e) {
                }

                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"jsp_code_item\" value=\"" + colCombo2.getCode() + "\" onChange=\"javascript:cmdAddItemMaster2()\"> </div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"barcode\" readonly class=\"readonly\" value=\"" + colCombo2.getBarcode() + "\" style=\"text-align:center\"></div>");
                
                String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:right\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + " / " + uom.getUnit() + "\"  size=\"35\" onChange=\"javascript:cmdAddItemMaster()\" >" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                strVal += "<tr><td></td><td></td><td></td></tr>";
                strVal += "</table>";

                rowx.add(strVal);

                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspRepackItem.JSP_TYPE], null, "" + objEntity.getType(), type_value, type_key, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\"><input type=\"text\" size=\"9\" name=\"" + frmObject.colNames[JspRepackItem.JSP_PERCENT_COGS] + "\" value=\"100\" class=\"readonly\" readonly style=\"text-align:right\" onBlur=\"javascript:calculatePercent()\" onClick=\"this.select()\">%" + frmObject.getErrorMsg(JspRepackItem.JSP_PERCENT_COGS) + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"hidden\" size=\"10\" name=\"" + frmObject.colNames[JspRepackItem.JSP_COGS] + "\" value=\"" + objEntity.getCogs() + "\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspRepackItem.JSP_QTY_STOCK] + "\" value=\"" + objEntity.getQtyStock() + "\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + frmObject.getErrorMsg(JspRepackItem.JSP_QTY_STOCK) + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspRepackItem.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" onkeypress=\"cmdSaveOnEnter(event)\">" + frmObject.getErrorMsg(JspRepackItem.JSP_QTY) + "</div>");
                if(showCogs.equals("YES")){
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(objEntity.getCogs(), "#,###.#") + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(objEntity.getCogs() * objEntity.getQty(), "#,###.#") + "</div>");
                }

            } else {

                ItemMaster itemMaster = new ItemMaster();
                try {
                    itemMaster = DbItemMaster.fetchExc(repackItem.getItemMasterId());
                } catch (Exception e) {
                }

                Uom uom = new Uom();
                try {
                    uom = DbUom.fetchExc(itemMaster.getUomStockId());
                } catch (Exception e) {
                }

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                rowx.add("<div align=\"left\">" + itemMaster.getCode() + "</div>");
                detail.setCode(itemMaster.getCode());
                rowx.add("<div align=\"left\">" + itemMaster.getBarcode() + "</div>");
                detail.setBarcode(itemMaster.getBarcode());

                if (((status != null && status.equals(I_Project.DOC_STATUS_DRAFT)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                    rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(repackItem.getOID()) + "')\">" + itemMaster.getName() + " / " + uom.getUnit() + "</a>");
                    detail.setName(itemMaster.getName() + " / " + uom.getUnit());
                } else {
                    rowx.add(itemMaster.getName() + " / " + uom.getUnit());
                    detail.setName(itemMaster.getName() + " / " + uom.getUnit());
                }

                if (repackItem.getType() == 0) {
                    rowx.add("<div align=\"center\">" + "STOK KELUAR" + "</div>");
                    detail.setTipe("INPUT");
                } else {
                    rowx.add("<div align=\"center\">" + "STOK MASUK" + "</div>");
                    detail.setTipe("OUTPUT");
                }
                rowx.add("<div align=\"right\">" + ((repackItem.getType() == 0) ? "" : (JSPFormater.formatNumber(repackItem.getPercentCogs(), "#,###.##")) + "%") + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(repackItem.getQtyStock(), "#,###.##") + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(repackItem.getQty(), "#,###.##") + "</div>");
                detail.setQty(repackItem.getQty());
                detail.setPrice(repackItem.getCogs());
                if(showCogs.equals("YES")){
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(repackItem.getCogs(), "#,###.##") + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(repackItem.getCogs() * repackItem.getQty(), "#,###.##") + "</div>");
                }

            }

            lstData.add(rowx);
            temp.add(detail);
        }

        rowx = new Vector();

        if (iJSPCommand != JSPCommand.POST && isEdit == false && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && costingItemId == 0))) {
            //masuk
            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");
            objEntity.setItemMasterId(itemMasterId);
            double stockItems = DbStock.getItemTotalStock(oidLocation, objEntity.getItemMasterId());
            ItemMaster colCombo2 = new ItemMaster();

            try {
                colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());

            } catch (Exception e) {
                System.out.println(e);
            }

            Uom uom = new Uom();
            try {
                uom = DbUom.fetchExc(colCombo2.getUomStockId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" name=\"jsp_code_item\" value=\"" + colCombo2.getCode() + "\" onChange=\"javascript:cmdAddItemMaster2()\"> </div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" readonly class=\"readonly\" name=\"barcode\" value=\"" + colCombo2.getBarcode() + "\"></div>");

            String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
            strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\"" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getOID() + "\">" + "<input style=\"text-align:right\" type=\"text\" name=\"X_" + frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] + "\" value=\"" + colCombo2.getName() + " / " + uom.getUnit() + "\"  size=\"35\" onChange=\"javascript:cmdAddItemMaster()\" >" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
            strVal += "<tr><td></td><td></td><td></td></tr>";
            strVal += "</table>";

            rowx.add(strVal);

            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspRepackItem.JSP_TYPE], null, "" + objEntity.getType(), type_value, type_key, "formElemen", "") + frmObject.getErrorMsg(JspRepackItem.JSP_TYPE) + "</div>");
            rowx.add("<div align=\"center\"><input type=\"text\" size=\"9\" name=\"" + frmObject.colNames[JspRepackItem.JSP_PERCENT_COGS] + "\" value=\"100\" readonly class=\"readonly\" style=\"text-align:right\" onBlur=\"javascript:calculatePercent()\" onClick=\"this.select()\">%" + frmObject.getErrorMsg(JspRepackItem.JSP_PERCENT_COGS) + "</div>");
            if(showCogs.equals("YES")){
            rowx.add("<div align=\"center\">" + "<input type=\"hidden\" size=\"10\" name=\"" + frmObject.colNames[JspRepackItem.JSP_COGS] + "\" value=\"" + colCombo2.getCogs() + "\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspRepackItem.JSP_QTY_STOCK] + "\" value=\"" + stockItems + "\" readonly class=\"readonly\" style=\"text-align:center\" onClick=\"this.select()\" onBlur=\"javascript:calculateSubTotal()\">" + frmObject.getErrorMsg(JspRepackItem.JSP_QTY_STOCK) + "</div>");
            rowx.add("<div align=\"center\"><input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspRepackItem.JSP_QTY] + "\" value=\"\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" onkeypress=\"cmdSaveOnEnter(event)\">" + frmObject.getErrorMsg(JspRepackItem.JSP_QTY) + "</div>");
            }
            rowx.add("");
            rowx.add("");

        }

        lstData.add(rowx);

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        return v;
    }

    public void updateStockDateToApproveDate(Repack repack) {
        if (repack.getOID() != 0) {
            try {
                String sql = "update pos_stock set date='" + JSPFormater.formatDate(repack.getEffectiveDate(), "yyyy-MM-dd HH:mm:ss") + "' where repack_id=" + repack.getOID();
                CONHandler.execUpdate(sql);
            } catch (Exception e) {
                System.out.println(e.toString());
            }
        }
    }

    public static int getCountForMulty(long oid) {
        CONResultSet dbrs = null;
        int count = 0;
        try {
            String sql = "select distinct im.uom_stock_id from pos_repack_item ri " +
                    " inner join pos_item_master im on ri.item_master_id = im.item_master_id " +
                    " where ri.repack_id=" + oid + " group by im.uom_stock_id";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                count = count + 1;
            }

            rs.close();

        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }

        return count;
    }

%>

<%

            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }

            if (session.getValue("DETAIL") != null) {
                session.removeValue("DETAIL");
            }

            RptRepack rptRepack = new RptRepack();
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidRepack = JSPRequestValue.requestLong(request, "hidden_repack_id");
            long oidRepackItem = JSPRequestValue.requestLong(request, "hidden_repack_item_id");           
            long itemMasterId = JSPRequestValue.requestLong(request, JspRepackItem.colNames[JspRepackItem.JSP_ITEM_MASTER_ID]);
            long oidLocationNew = JSPRequestValue.requestLong(request, "JSP_LOCATION_ID");
            String srcCode = JSPRequestValue.requestString(request, "jsp_code_item");
            
            
            boolean isRefresh = false;
            if (iJSPCommand == JSPCommand.REFRESH) {
                iJSPCommand = JSPCommand.EDIT;
                isRefresh = true;
            }

            if (iJSPCommand == JSPCommand.GET) {
                iJSPCommand = JSPCommand.VIEW;
            }


            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidRepack = 0;
            }

            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdRepack cmdRepack = new CmdRepack(request);
            JSPLine ctrLine = new JSPLine();

            iErrCode = cmdRepack.action(iJSPCommand, oidRepack);
            JspRepack jspRepack = cmdRepack.getForm();
            Repack repack = cmdRepack.getRepack();
            msgString = cmdRepack.getMessage();

            if (oidRepack == 0) {
                oidRepack = repack.getOID();
                if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                    repack.setStatus(I_Project.DOC_STATUS_DRAFT);
                } else {
                    repack.setStatus(I_Project.DOC_STATUS_APPROVED);
                }

            } else {
                try {
                    repack = DbRepack.fetchExc(oidRepack);
                } catch (Exception e) {
                }
            }

            whereClause = DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + "=" + oidRepack;
            orderClause = DbRepackItem.colNames[DbRepackItem.COL_REPACK_ITEM_ID];

            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            CmdRepackItem cmdRepackItem = new CmdRepackItem(request);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.REFRESH;
            }
            iErrCode2 = cmdRepackItem.action(iJSPCommand, oidRepackItem, oidRepack, 0);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.EDIT;
            }
            JspRepackItem jspRepackItem = cmdRepackItem.getForm();
            RepackItem repackItem = cmdRepackItem.getRepackItem();
            msgString2 = cmdRepackItem.getMessage();

            whereClause = DbRepackItem.colNames[DbRepackItem.COL_REPACK_ID] + "=" + oidRepack;
            orderClause = DbRepackItem.colNames[DbRepackItem.COL_TYPE];
            String msgSuccsess = "";
            Vector repackItems = DbRepackItem.list(0, 0, whereClause, orderClause);

            if (iJSPCommand == JSPCommand.VIEW) {
                iJSPCommand = JSPCommand.ADD;
            }

            Vector locations = userLocations;

            if (oidLocationNew != 0) {
                repack.setLocationId(oidLocationNew);
            } else {
                if (repack.getLocationId() == 0 && locations != null && locations.size() > 0) {
                    Location lxx = (Location) locations.get(0);
                    repack.setLocationId(lxx.getOID());
                }
            }

            int stockItems = 1;//DbStock.getStockItemCountByLocation(repack.getLocationId(), DbStock.TYPE_NON_CONSIGMENT);
            if (repack.getOID() == 0) {
                repack.setStatus(I_Project.DOC_STATUS_DRAFT);
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidRepackItem = 0;
                repackItem = new RepackItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD) {
                try {
                    repack = DbRepack.fetchExc(oidRepack);
                } catch (Exception e) {
                }
            }

            int vectSize = 0;
            if (iJSPCommand != JSPCommand.SAVE && iJSPCommand != JSPCommand.POST) {
                if (srcCode.length() > 0) {
                    vectSize = DbStock.getStockItemCount(repack.getLocationId(), DbStock.TYPE_NON_CONSIGMENT, 0, 0, "", srcCode);
                    if (vectSize == 1) {
                        Vector vlist = DbStock.getStockList(0, 1, repack.getLocationId(), DbStock.TYPE_NON_CONSIGMENT, 0, 0, "", srcCode);
                        Stock stock = (Stock) vlist.get(0);
                        itemMasterId = stock.getItemMasterId();
                    }
                }
            }

            //Eka D
            if (iJSPCommand == JSPCommand.POST && iErrCode == 0 && repack.getOID() != 0) {
                //update effectiveDate - tanggal approve
                try {
                    repack.setEffectiveDate(new Date());
                    long oidx = DbRepack.updateExc(repack);
                    if (oidx != 0) {
                        updateStockDateToApproveDate(repack);
                    }
                } catch (Exception e) {
                }
            }

            //untuk melakukan update cogs di item master
            if (iJSPCommand == JSPCommand.POST && iErrCode == 0 && repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                //melakukan update cogs - ED - lakukan di jsp - butuh diskusi
                DbRepackItem.updateItemOutputCogs(repack);
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
        <%if (!priv || !privView) {%>
        window.location="<%=approot%>/nopriv.jsp";
        <%}%>
        
        
        function cmdPrintXLS(){	 
            window.open("<%=printroot%>.report.RptRepackXLS?idx=<%=System.currentTimeMillis()%>");
            }
            
            function cmdSaveOnEnter(e){                
                if (typeof e == 'undefined' && window.event) { e = window.event; }                
                if (e.keyCode == 13)
                    {
                        cmdSave();
                    }
                }   
                
                function cmdGoToMulty(oid){
                    document.frmrepack.hidden_repack_item_id.value=oid;
                    document.frmrepack.command.value="<%=JSPCommand.LIST%>";
                    document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                    document.frmrepack.action="repackitemmulty.jsp";
                    document.frmrepack.submit();
                }     
                
                function cmdAddItemMaster(){                       
                    var oidLoc = document.frmrepack.hidden_locationIdFrom.value;
                    var itemName =document.frmrepack.X_JSP_ITEM_MASTER_ID.value;
                    document.frmrepack.jsp_code_item.value="";
                    
                    window.open("<%=approot%>/postransaction/addItemRepack.jsp?location_id=" + oidLoc + "&item_name=" + itemName , null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                        document.frmrepack.command.value="<%=JSPCommand.ADD%>";
                        document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
                        document.frmsalesproductdetail.submit();   
                        
                    }
                    function cmdAddItemMaster3(){                           
                        var oidLoc = document.frmrepack.hidden_locationIdFrom.value;
                        var itemCode =document.frmrepack.hidden_item_code.value;
                        window.open("<%=approot%>/postransaction/addItemRepack.jsp?location_id=" + oidLoc + "&item_code=" + itemCode , null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
                            document.frmrepack.command.value="<%=JSPCommand.ADD%>";
                            document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
                            document.frmsalesproductdetail.submit();   
                            
                        }
                        
                        function cmdAddItemMaster2(){ 
                            var oidLoc = document.frmrepack.hidden_locationIdFrom.value;
                            document.frmrepack.JSP_ITEM_MASTER_ID.value=0;
                            document.frmrepack.command.value="<%=JSPCommand.ADD%>";
                            document.frmrepack.submit();  
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
                        
                        function calculateSubTotal(){
                            
                            var qty = document.frmrepack.<%=JspRepackItem.colNames[JspRepackItem.JSP_QTY]%>.value;
                            var tipe = document.frmrepack.<%=JspRepackItem.colNames[JspRepackItem.JSP_TYPE]%>.value;
                            var stockQty =document.frmrepack.<%=JspRepackItem.colNames[JspRepackItem.JSP_QTY_STOCK]%>.value;
                            
                            qty = removeChar(qty);
                            qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                            document.frmrepack.<%=JspRepackItem.colNames[JspRepackItem.JSP_QTY]%>.value = qty;
                            
                            stockQty = removeChar(stockQty);
                            stockQty = cleanNumberFloat(stockQty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                            
                            if(parseFloat(qty)>parseFloat(stockQty) && parseFloat(tipe)==0 ){
                                alert("The quantity input is more than stock qty!");
                                qty="0";
                                document.frmrepack.<%=JspRepackItem.colNames[JspRepackItem.JSP_QTY]%>.value = qty;
                            }
                        }
                        
                        function cmdLocation(){                                
                            <%if (repack.getOID() != 0) {%>
                            if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all repack item based on vendor item master. ')){
                                document.frmrepack.hidden_repack_id.value=0;
                                document.frmrepack.hidden_repack_item_id.value=0;
                                document.frmrepack.command.value="<%=JSPCommand.LOAD%>";
                                document.frmrepack.action="repackitem.jsp";
                                document.frmrepack.submit();
                            }
                            <%} else {%>
                            document.frmrepack.command.value="<%=JSPCommand.LOAD%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                            <%}%>
                        }
                        
                        function cmdToRecord(){
                            document.frmrepack.command.value="<%=JSPCommand.NONE%>";
                            document.frmrepack.action="repacklist.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdCloseDoc(){
                            document.frmrepack.action="<%=approot%>/home.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdAskDoc(){
                            document.frmrepack.hidden_repack_item_id.value="0";
                            document.frmrepack.command.value="<%=JSPCommand.SUBMIT%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdDeleteDoc(){
                            document.frmrepack.hidden_repack_item_id.value="0";
                            document.frmrepack.command.value="<%=JSPCommand.CONFIRM%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdCancelDoc(){
                            document.frmrepack.hidden_repack_item_id.value="0";
                            document.frmrepack.command.value="<%=JSPCommand.EDIT%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdSaveDoc(){
                            document.frmrepack.command.value="<%=JSPCommand.POST%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdAdd(){
                            document.frmrepack.hidden_repack_item_id.value="0";
                            document.frmrepack.command.value="<%=JSPCommand.ADD%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdAsk(oidTransferItem){
                            document.frmrepack.hidden_repack_item_id.value=oidTransferItem;
                            document.frmrepack.command.value="<%=JSPCommand.ASK%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdConfirmDelete(oidTransferItem){
                            document.frmrepack.hidden_repack_item_id.value=oidTransferItem;
                            document.frmrepack.command.value="<%=JSPCommand.DELETE%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdSave(){
                            document.frmrepack.command.value="<%=JSPCommand.SAVE%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdEdit(oidRepack){
                            document.frmrepack.hidden_repack_item_id.value=oidRepack;
                            document.frmrepack.command.value="<%=JSPCommand.EDIT%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdCancel(oidRepack){
                            document.frmrepack.hidden_repack_item_id.value=oidRepack;
                            document.frmrepack.command.value="<%=JSPCommand.EDIT%>";
                            document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
                        }
                        
                        function cmdBack(){
                            document.frmrepack.command.value="<%=JSPCommand.BACK%>";
                            document.frmrepack.action="repackitem.jsp";
                            document.frmrepack.submit();
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
                    <form name="frmrepack" method ="post" action="">
                    <input type="hidden" name="command" value="<%=iJSPCommand%>">
                    <input type="hidden" name="start" value="0">
                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                    <input type="hidden" name="hidden_repack_id" value="<%=oidRepack%>">
                    <input type="hidden" name="hidden_repack_item_id" value="<%=oidRepackItem%>">
                    <input type="hidden" name="<%=JspRepackItem.colNames[JspRepackItem.JSP_REPACK_ID]%>" value="<%=oidRepack%>">
                    <input type="hidden" name="hidden_locationId" value="<%=repack.getLocationId()%>">
                    <input type="hidden" name="<%= jspRepack.colNames[jspRepack.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                    <input type="hidden" name="hidden_locationIdFrom" value="<%=repack.getLocationId() %>">
                    <input type="hidden" name="hidden_item_code" value="<%= srcCode %>">
                    <%if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                    <input type="hidden" name="<%=jspRepack.colNames[jspRepack.JSP_STATUS]%>" value="<%=repack.getStatus()%>">
                    <%}%>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                    <tr valign="bottom"> 
                                        
                                        <td width="60%" height="23"><b><font color="#990000" class="lvl1">Repack 
                                                </font><font class="tit1">&raquo; <span class="lvl2">Repack 
                                        Item - Single Output</span></font></b></td>
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
                                                <div align="center">&nbsp;&nbsp;Repack Item &nbsp;&nbsp;</div>
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
                                                        <%if (repack.getOID() == 0) {%>
                                                        Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                        <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(repack.getUserId());
    } catch (Exception e) {
    }
                                                        %>
                                                        Prepared By : <%=us.getLoginId()%> 
                                                        <%}%>
                                                </i>&nbsp;&nbsp;&nbsp;</div>
                                            </td>
                                        </tr>
                                        <tr align="left"> 
                                            <td height="26" width="12%">&nbsp;Location</td>
                                            <td height="26" width="27%">
                                                <%if ((!repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>												
                                                <span class="comment"> 
                                                    <select name="<%=jspRepack.colNames[jspRepack.JSP_LOCATION_ID]%>" <%if (((!repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>onChange="javascript:cmdLocation()"<%}%>>
                                                            <%

    if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location d = (Location) locations.get(i);
            if (repack.getLocationId() == d.getOID()) {
                rptRepack.setLocation(d.getName());
            }
                                                            %>
                                                            <option value="<%=d.getOID()%>" <%if (repack.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                        
                                                        <%}
    }%>
                                                    </select>
                                                </span>
                                                <%} else {
    Location l = new Location();
    try {
        l = DbLocation.fetchExc(repack.getLocationId());
        rptRepack.setLocation(l.getName());
    } catch (Exception e) {
    }%>
                                                
                                                <%=l.getName()%>
                                                <input type="hidden" name="<%=jspRepack.colNames[jspRepack.JSP_LOCATION_ID]%>" value="<%=l.getOID()%>">           
                                                <%}%>
                                                
                                            </td> 
                                            <td width="9%">Date</td>
                                            <td colspan="2" class="comment" width="52%">
                                                <input name="<%=jspRepack.colNames[jspRepack.JSP_DATE]%>" value="<%=JSPFormater.formatDate((repack.getDate() == null) ? new Date() : repack.getDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrepack.<%=jspRepack.colNames[jspRepack.JSP_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                <%
            rptRepack.setTanggal(repack.getDate());
                                                %> 
                                            </td>
                                        </tr>
                                        <tr align="left"> 
                                            <td height="21" width="12%">&nbsp;Number</td>
                                            <td height="21" width="27%"> 
                                                <%
            String number = "";
            if (repack.getOID() == 0) {
                int ctr = DbRepack.getNextCounter();
                number = DbRepack.getNextNumber(ctr);
                //prOrder.setPoNumber(number);
                //rptKonstan.setNumber(number);
                repack.setNumber(number);
                rptRepack.setNumber(number);
            } else {
                number = repack.getNumber();
                rptRepack.setNumber(number);
            }
                                                %>
                                            <%=number%> </td>
                                            <td width="9%" valign="top">Status</td>
                                            <td colspan="2" class="comment" width="52%" valign="top"> 
                                                <%
            if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                if (repack.getStatus() == null) {
                    repack.setStatus(I_Project.DOC_STATUS_DRAFT);
                }
            }
                                                %>
                                                <%if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                <input type="text" class="readOnly" name="stt" value="<%=(repack.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((repack.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : repack.getStatus())%>" size="15" readOnly>
                                                <%} else {%>
                                                <input type="text" class="readOnly" name="stt" value="<%=I_Project.DOC_STATUS_APPROVED%>" size="15" readOnly>
                                                <%}%>    
                                            </td>
                                            
                                        </tr>
                                        <tr align="left"> 
                                            <td height="21" width="12%" valign="top">&nbsp;Notes</td>
                                            <td height="21" width="27%"> 
                                                <textarea name="<%=jspRepack.colNames[jspRepack.JSP_NOTE]%>" cols="40" rows="3"><%=repack.getNote()%></textarea>
                                                <%
            rptRepack.setNotes(repack.getNote());
                                                %>
                                            </td>
                                            
                                        </tr>
                                        <%
            // rptKonstan.setNotes(repack.getNote());
%>
                                        <tr align="left" > 
                                            <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr align="left" > 
                                            <td colspan="5" valign="top"> 
                                                &nbsp; 
                                                <%
            Vector x = drawList(iJSPCommand, jspRepackItem, repackItem, repackItems, oidRepackItem, repack.getLocationId(), iErrCode2, repack.getStatus(), repack, itemMasterId);
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
                                                            <%if (((((stockItems > 0) && repack.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) || iJSPCommand == JSPCommand.CONFIRM) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) || DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                                                            <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                <%
    if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD ||
            (iJSPCommand == JSPCommand.EDIT && oidRepackItem != 0) ||
            iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
                                                                <tr> 
                                                                    <td> 
                                                                        <%
                                                                    ctrLine = new JSPLine();
                                                                    ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                    ctrLine.initDefault();
                                                                    ctrLine.setTableWidth("80%");
                                                                    String scomDel = "javascript:cmdAsk('" + oidRepackItem + "')";
                                                                    String sconDelCom = "javascript:cmdConfirmDelete('" + oidRepackItem + "')";
                                                                    String scancel = "javascript:cmdBack('" + oidRepackItem + "')";
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

                                                                    if (stockItems == 0) {
                                                                        ctrLine.setSaveCaption("");
                                                                    //ctrLine.setCancelCaption("");
                                                                    }

                                                                    if (iJSPCommand == JSPCommand.LOAD) {
                                                                        if (oidRepackItem == 0) {
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
                                        <%if (repack.getOID() != 0) {%>
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
                                                            <%if (repack.getOID() != 0 && !repack.getStatus().equals("CANCELED") && !repack.getStatus().equals("APPROVED") && !repack.getStatus().equals("POSTED")) {%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td width="12%">&nbsp;</td>
                                                                    <td width="14%">&nbsp;</td>
                                                                    <td width="74%">&nbsp;</td>
                                                                </tr>
                                                                <%if ((!repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode != 0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                <tr> 
                                                                    <td width="12%"><b>Set 
                                                                    Status to</b> </td>
                                                                    <td width="14%"> 
                                                                        <select name="<%=jspRepack.colNames[jspRepack.JSP_STATUS]%>">
                                                                            <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (repack.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                            <%if (posApprove1Priv) {%>
                                                                            <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                            <%}%>
                                                                        </select>
                                                                    </td>
                                                                    
                                                                    <td width="74%">&nbsp;&nbsp;</td>
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
    if (repack.getOID() != 0) {
                                                    %>
                                                    <tr> 
                                                        <td colspan="4" class="errfont"></td>
                                                    </tr>
                                                    <%}%>
                                                    <%if (stockItems >= 0) {
        if (repack.getOID() != 0) {
            session.putValue("KONSTAN", rptRepack);
                                                    %>
                                                    <tr> 
                                                        <%if (((!repack.getStatus().equals("CANCELED") && !repack.getStatus().equals("POSTED") && !repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED))) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                        <td width="149"><div onclick="this.style.visibility='hidden'"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></div></td>
                                                        <td width="102" > 
                                                            <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                        </td>
                                                        <%}%>
                                                        <%if (!repack.getStatus().equals("CANCELED")) {%>
                                                        <td width="97"> 
                                                            <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                        </td>
                                                        <%}%>
                                                        <td width="862"> 
                                                            <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                        </td>
                                                    </tr>
                                                    <%}
    }%>
                                                    <%}%>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr align="left" >
                                            <td colspan="5"  <%if (!jspRepack.getErrorMsg(jspRepack.JSP_APPROVAL_1).equals("")) {%>bgcolor="yellow"<%}%> height="24">&nbsp;&nbsp;<font color="#FF0000"><%=jspRepack.getErrorMsg(jspRepack.JSP_APPROVAL_1)%></font>
                                                <%
            if (repack.getOID() != 0 && (repack.getStatus().equals("DRAFT") || repack.getStatus().equals(""))) {
                if (getCountForMulty(repack.getOID()) == 1) {
                                                %><br>
                                                <table width="293" border="0" cellspacing="1" cellpadding="1">
                                                    <tr>
                                                        <td width="22"><a href="javascript:cmdGoToMulty('<%=repack.getOID()%>')"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2111','','../images/moveit.gif',1)"><img src="../images/moveit.gif" name="save2111" border="0" width="30"></a></td>
                                                        <td width="264">&nbsp;<a href="javascript:cmdGoToMulty('<%=repack.getOID()%>')">Transfer To Multy Output</a></td>
                                                    </tr>
                                                </table>
                                                <%}
            }%>
                                            </td>
                                        </tr>
                                        <tr align="left" > 
                                            <td colspan="5" valign="top">&nbsp;</td>
                                        </tr>
                                        <%

            Hashtable approver = new Hashtable();

            if (repack.getOID() != 0 && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                                                                        
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
                                                            u = DbUser.fetch(repack.getUserId());

                                                        } catch (Exception e) {
                                                        }

                                                        approver.put("PREPARE_BY", ((repack.getUserId() == 0) ? "         " : u.getLoginId()));
                                                                    %>
                                                            <%=u.getLoginId()%></i></div>
                                                        </td>
                                                        <td width="33%" class="tablecell1"> 
                                                            <div align="center"><i><%=JSPFormater.formatDate(repack.getDate(), "dd MMMM yy")%></i></div>
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
                                                            u = DbUser.fetch(repack.getApproval1());
                                                        } catch (Exception e) {
                                                        }

                                                        approver.put("APPROVED_BY", ((repack.getApproval1() == 0) ? "         " : u.getLoginId()));
                                                        session.putValue("APPROVER", approver);
                                                                    %>
                                                            <%=u.getLoginId()%></i></div>
                                                        </td>
                                                        <td width="33%" class="tablecell1"> 
                                                            <div align="center"> <i> 
                                                                    <%if (repack.getApproval1() != 0) {%>
                                                                    <%=(repack.getEffectiveDate() == null) ? "" : JSPFormater.formatDate(repack.getEffectiveDate(), "dd MMMM yy")%> 
                                                                    <%}%>
                                                            </i></div>
                                                        </td>
                                                    </tr>
                                                    <%if (repack.getStatus().equals("CANCELED")) {%>
                                                    <tr> 
                                                        <td width="33%" class="tablecell1"><i>Canceled</i></td>
                                                        <td width="34%" class="tablecell1"> 
                                                            <div align="center"><i>System</i></div>
                                                        </td>
                                                        <td width="33%" class="tablecell1"> 
                                                            <div align="center"></div>
                                                        </td>
                                                    </tr>
                                                    <%}%>
                                                </table>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <%if (vectSize > 1) {%>
                                        <script language="JavaScript">
                                            cmdAddItemMaster3();
                                        </script>
                                        <%}%>                                       
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
    </form>
    
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
<%
//pengecekan stock final
            if (iJSPCommand == JSPCommand.POST && iErrCode == 0 && repack.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                int stokTrans = DbRepackItem.getCount(" repack_id=" + repack.getOID());
                int stock = DbStock.getTotalStockByTransaksi(" repack_id=" + repack.getOID());
                if (stokTrans != stock) {
                    DbStock.delete(DbStock.colNames[DbStock.COL_REPACK_ID] + "=" + repack.getOID());
                    DbRepackItem.proceedStock(repack);//tambah stock
                }
            }


%>