
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.promotion.*" %>
<%@ page import = "com.project.ccs.postransaction.promotion.*" %>
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
    public Vector drawList(int iJSPCommand, JspPromotionItem frmObject,
            PromotionItem objEntity, Vector objectClass,
            long promotionItemId, String approot, 
            int iErrCode2, Promotion promotion, boolean isSave, boolean optionalCode, long itemMasterId) {
        
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("80%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Item Name", "35%");
        jsplist.addHeader("Item Code", "15%");
        jsplist.addHeader("Item Barcode", "15%");
        jsplist.addHeader("Discount (%)", "10%");
        jsplist.addHeader("Discount (val)", "10%");
        

        jsplist.setLinkRow(1);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

       //int vectVendMaster = DbStock.getStockItemCountByLocation(oidLocation,DbStock.TYPE_NON_CONSIGMENT);

       

        Vector temp = new Vector();
        //Vector units = DbUom.list(0, 0, "", "");
       // Vector uom_value = new Vector(1, 1);
       // Vector uom_key = new Vector(1, 1);

        
        boolean isEdit = false;
        for (int i = 0; i < objectClass.size(); i++) {

            PromotionItem promotionItem = (PromotionItem) objectClass.get(i);

            RptTranferL detail = new RptTranferL();

            rowx = new Vector();

            if (promotionItemId == promotionItem.getOID()) {
                index = i;
            }

            if ((iJSPCommand != JSPCommand.POST && index == i && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.VIEW || iJSPCommand == JSPCommand.ASK || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0))) )  {
                isEdit = true;
                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                //objEntity.setItemMasterId(itemMasterId);
                if(iJSPCommand== JSPCommand.ADD){
                    objEntity.setItemMasterId(itemMasterId);
                }else if(iJSPCommand== JSPCommand.EDIT){
                    objEntity.setItemMasterId(promotionItem.getItemMasterId());
                }
                //int stockItems =DbStock.getItemTotalStockCosting(oidLocation, objEntity.getItemMasterId());
                //if (vectVendMaster > 0) {

                    String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                    ItemMaster colCombo2  = new ItemMaster();
                
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                                
			}catch(Exception e) {
				System.out.println(e);
			}
                    //strVal += "<tr><td colspan=\"3\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspPromotionItem.JSP_ITEM_MASTER_ID], null, "" + objEntity.getItemMasterId(), vect_value, vect_key, "onchange=\"javascript:parserMasterLoop()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID) + "</div></td></tr>";
                    strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_NAME] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"35\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                    

                    strVal += "<tr><td></td><td></td><td></td></tr>";
                    strVal += "</table>";

                    rowx.add(strVal);
                
               // } else {
               //     rowx.add("<font color=\"red\">No item stock available for promotion</font>");
              //  }

                //rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"20\" name=\"" + frmObject.colNames[JspPromotionItem.JSP_PRICE] + "\" value=\"" + JSPFormater.formatNumber(objEntity.getPrice(), "#,###.##") + "\" class=\"formElemen\" style=\"text-align:right\">" + frmObject.getErrorMsg(frmObject.JSP_PRICE) + "</div>");
                //rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_NAME]+"\" value=\"" + promotionItem.getItemName() + "\" class=\"formElemen\" style=\"text-align:center\" onClick=\"this.select()\" >" + frmObject.getErrorMsg(frmObject.JSP_ITEM_CODE) + "</div>");
                rowx.add("<div align=\"left\">" + "<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_CODE]+"\" value=\""+colCombo2.getCode()+"\"</div>");
                rowx.add("<div align=\"left\">" + "<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_BARCODE]+"\" value=\""+colCombo2.getBarcode()+"\"</div>");
                
                //rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPromotionItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div><input type=\"hidden\" name=\"temp_item_amount\" value=\"" + objEntity.getAmount() + "\">");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_PERCENT]+"\" value=\""+objEntity.getDiscountPercent()+"\" </div>");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\""+frmObject.colNames[frmObject.JSP_DISCOUNT_VALUE]+"\" value=\""+objEntity.getDiscountValue()+"\" </div>");
                if(iJSPCommand==JSPCommand.SAVE){
                    iJSPCommand= JSPCommand.LIST;
                }
            } else {

                ItemMaster itemMaster = new ItemMaster();
                //ItemGroup ig = new ItemGroup();
                //ItemCategory ic = new ItemCategory();
                try {
                    itemMaster = DbItemMaster.fetchExc(promotionItem.getItemMasterId());
                    //ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                    //ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
                } catch (Exception e) {
                }

                //Uom uom = new Uom();
                //Stock stock = new Stock();
                //Vector stockItems = DbStock.getStock(oidLocation,DbStock.TYPE_NON_CONSIGMENT);
                //int stockItems =DbStock.getItemTotalStockCosting(oidLocation, promotionItem.getItemMasterId());
                try {
                   // uom = DbUom.fetchExc(itemMaster.getUomStockId());
                   // for(int j=0; j < stockItems.size();j++){
                    //    stock = (Stock) stockItems.get(j);
                     //   if(stock.getItemMasterId()==itemMaster.getOID()){
                      //      break;
                       // }
                   // }
                } catch (Exception e) {
                }

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                //if (((status != null && status.equals(I_Project.DOC_STATUS_DRAFT))&& DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES"))||DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                    rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(promotionItem.getOID()) + "')\">" + promotionItem.getItemName() + "</a>");
                    //detail.setName(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                //} else {
                //    rowx.add(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                //    detail.setName(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                //}
                //rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") + "</div>");
                //detail.setPrice(promotionItem.getAmount());
                rowx.add("<div align=\"left\">" + promotionItem.getItemCode()+ "</div>");
                rowx.add("<div align=\"left\">" + promotionItem.getItemBarcode()+ "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(promotionItem.getDiscountPercent(), "#,###.##") + "</div>");
                rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(promotionItem.getDiscountValue(), "#,###.##") + "</div>");
                //detail.setQty(promotionItem.getQty());
                //rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(promotionItem.getAmount(), "#,###.##") + "</div>");
                //detail.setTotal(promotionItem.getAmount());
                //rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
            }

            lstData.add(rowx);
            temp.add(detail);
        }

        rowx = new Vector();

        if (iJSPCommand != JSPCommand.POST && isEdit == false && (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD || (iJSPCommand == JSPCommand.SAVE && iErrCode2 != 0 && promotionItemId == 0))) {
        //masuk
            rowx.add("<div align=\"center\">" + (objectClass.size() + 1) + "</div>");
            objEntity.setItemMasterId(itemMasterId);
            //int stockItems = DbStock.getItemTotalStockCosting(oidLocation, itemMasterId);
            //objEntity.setQty(stockItems);
            //if (vectVendMaster > 0){

                String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                ItemMaster colCombo2  = new ItemMaster();
                
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                                
			}catch(Exception e){
				System.out.println(e);
			}
                
                //strVal += "<tr><td colspan=\"3\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspPromotionItem.JSP_ITEM_MASTER_ID], null, "" + objEntity.getItemMasterId(), vect_value, vect_key, "onchange=\"javascript:parserMaster()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID) + "</div></td></tr>";
                strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_NAME] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"35\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                

                strVal += "<tr><td></td><td></td><td></td></tr>";
                strVal += "</table>";

                rowx.add(strVal);

           // } else {

             //   rowx.add("<font color=\"red\">No stock item available for promotion</font>");

           // }

            //rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" readonly name=\"" + frmObject.colNames[JspPromotionItem.JSP_PRICE] + "\" value=\"" + JSPFormater.formatNumber(objEntity.getPrice(), "#,###.##") + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\">" + frmObject.getErrorMsg(frmObject.JSP_PRICE) + "</div>");
            //rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"stock_qty\" readonly value=\"" + ((objEntity.getQty() == 0) ? 0 : objEntity.getQty()) + "\" class=\"readOnly\" readOnly style=\"text-align:center\" onClick=\"this.select()\"\">" + frmObject.getErrorMsg(frmObject.JSP_QTY) + "</div>");
            
                //rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspPromotionItem.JSP_ITEM_CODE] + "\" value=\"\" class=\"formElemen\" style=\"text-align:right\"  onClick=\"this.select()\"  >" + "</div>");
                 rowx.add("<div align=\"left\">" + "<input type=\"text\" size=\"10\" class=\"readOnly\" name=\""+JspPromotionItem.colNames[JspPromotionItem.JSP_ITEM_CODE]+"\" value=\""+colCombo2.getCode()+"\"</div>");
                rowx.add("<div align=\"left\">" + "<input type=\"text\" size=\"10\" class=\"readOnly\" name=\""+JspPromotionItem.colNames[JspPromotionItem.JSP_ITEM_BARCODE]+"\" value=\""+colCombo2.getBarcode()+"\"</div>");
           
            //rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"20\" readonly name=\"" + frmObject.colNames[JspPromotionItem.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" onBlur=\"javascript:checkDiscountPercent()\" name=\""+JspPromotionItem.colNames[JspPromotionItem.JSP_DISCOUNT_PERCENT]+"\" value=\"\" </div>");
            rowx.add("<div align=\"center\">" + "<input type=\"text\" size=\"10\" onBlur=\"javascript:checkDiscountRp()\" name=\""+JspPromotionItem.colNames[JspPromotionItem.JSP_DISCOUNT_VALUE]+"\" value=\"\" </div>");
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
            
            if (session.getValue("REPORT_PROMOTION_ITEM") != null) {
                session.removeValue("REPORT_PROMOTION_ITEM");
            }

            if (session.getValue("REPORT_PROMOTION_HEADER") != null) {
                session.removeValue("REPORT_PROMOTION_HEADER");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidPromotion = JSPRequestValue.requestLong(request, "hidden_promotion_id");
            
            long oidPromotionItem = JSPRequestValue.requestLong(request, "hidden_promotion_item_id");
            int countStockCode = JSPRequestValue.requestInt(request, "hidden_count_stock_code");
            int idxStockCodeDel = JSPRequestValue.requestInt(request, "hidden_oid_stock_code_del");
            int stockDel = JSPRequestValue.requestInt(request, "hidden_del_stock");
            long oidLocation = JSPRequestValue.requestLong(request, "hidden_locationId");
            long itemMasterId = JSPRequestValue.requestLong(request, JspPromotionItem.colNames[JspPromotionItem.JSP_ITEM_MASTER_ID]);
            long oidLocationNew = JSPRequestValue.requestLong(request, "JSP_LOCATION_ID");
            Date date =  JSPFormater.formatDate(JSPRequestValue.requestString(request, "JSP_DATE"), "dd/MM/yyyy");
            //String tes = JSPRequestValue.requestString(request, "JSP_DATE");
            //if(tes==""){
              //  }
            boolean isEdit = false;
            boolean isRefresh = false;
            if (iJSPCommand == JSPCommand.EDIT) {
                isEdit = true;
            }
            
            
               

            if (iJSPCommand == JSPCommand.REFRESH) {
                //iJSPCommand = JSPCommand.EDIT;
                //isRefresh = true;
            }
            
            if (iJSPCommand == JSPCommand.GET) {
                //DbStockCode.deleteStockCodeByTransferItem(oidTransferItem);
                iJSPCommand = JSPCommand.VIEW;
            }

            
    

            

            boolean isNone = false;
            boolean isView = false;
            boolean isAdd = false;
            boolean isLoad = false;

            if (iJSPCommand == JSPCommand.ADD) {
                isAdd = true;
                
            }

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidPromotion = 0;
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

            //RptTranfer rptKonstan = new RptTranfer();

            CmdPromotion cmdPromotion = new CmdPromotion(request);
            JSPLine ctrLine = new JSPLine();

            iErrCode = cmdPromotion.action(iJSPCommand, oidPromotion);
            
            
            
            JspPromotion jspPromotion = cmdPromotion.getForm();
            Promotion promotion = cmdPromotion.getPromotion();
            //promotion.setDate(date);
            
            msgString = cmdPromotion.getMessage();

            if (oidPromotion == 0) {
                oidPromotion = promotion.getOID();
               
                
            }else{
                try{
                   promotion = DbPromotion.fetchExc(oidPromotion);
                   
                    
                }catch(Exception e){
                    
                }
            }

            whereClause = DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ID] + "=" + oidPromotion;
            orderClause = DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ITEM_ID];

            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            CmdPromotionItem cmdPromotionItem = new CmdPromotionItem(request);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.REFRESH;
            }
            iErrCode2 = cmdPromotionItem.action(iJSPCommand, oidPromotionItem, oidPromotion);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.EDIT;
            }
            JspPromotionItem jspCostingItem = cmdPromotionItem.getForm();
            PromotionItem promotionItem = cmdPromotionItem.getCostingItem();
            msgString2 = cmdPromotionItem.getMessage();

            

            whereClause = DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ID] + "=" + oidPromotion;
            orderClause = DbPromotionItem.colNames[DbPromotionItem.COL_PROMOTION_ITEM_ID];
            String msgSuccsess = "";
            Vector vPromoItem = DbPromotionItem.list(0, 0, whereClause, orderClause);

            if (iJSPCommand == JSPCommand.VIEW) {
                isView = true;
                iJSPCommand = JSPCommand.ADD;
            }

            Vector vendors = new Vector();

            Vector locations = DbLocation.list(0, 0, "", "name");

            long fromOid = 0;
            
            //if(oidLocationNew!=0){
            //    promotion.setLocationId(oidLocationNew);
            //}else{
            //    if (promotion.getLocationId() == 0 && locations != null && locations.size() > 0) {
            //        Location lxx = (Location) locations.get(0);
            //        fromOid = lxx.getOID();
            //        promotion.setLocationId(lxx.getOID());
            //    }
           // }
                
            
           //if (promotion.getLocationId() == 0 && locations != null && locations.size() > 0) {
            //    promotion.setLocationId(oidLocation);
            //}
            
           // if (promotion.getLocationId() != 0 && locations != null && locations.size() > 0) {
           //     fromOid = promotion.getLocationId();
            ///}
            
            

            //Vector stockItems = DbStock.getStock(promotion.getLocationId(),DbStock.TYPE_NON_CONSIGMENT);
           // if(promotion.getOID()==0){
           //     promotion.setStatus(I_Project.DOC_STATUS_DRAFT);
           // }
            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                isSave = true;
                iJSPCommand=JSPCommand.ADD;
                oidPromotionItem=0;
            }

            

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                //oidTransferItem = 0;
                oidPromotionItem=0;
                promotionItem = new PromotionItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD) {
                try {
                    promotion = DbPromotion.fetchExc(oidPromotion);
                } catch (Exception e) {
                }
            }

            double subTotal = 0;//DbPromotionItem.getTotalTransferAmount(oidPromotion);

            //Vector vLocations = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " != " + fromOid, "name");

            Vector vErr = new Vector();

            //String whereSCode = DbStockCode.colNames[DbStockCode.COL_TRANSFER_ID] + "=" + promotion.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_RECEIVE_ITEM_ID] + "=" + promotionItem.getOID();

            //Vector vStockCode = DbStockCode.list(0, 0, whereSCode, null);

            boolean useStockCode = false;
            boolean optionalCode = false;

            try {

                long oidTmpCostingItem = 0;

                if (isNone || isAdd || isSave || isLoad) {
                    try {
                        //Stock stock = (Stock) stockItems.get(0);
                        ItemMaster im = new ItemMaster();
                        try {
                            //im = DbItemMaster.fetchExc(stock.getItemMasterId());
                            oidTmpCostingItem = im.getOID();
                        } catch (Exception e) {}

                    } catch (Exception e) {
                    }
                } else {
                    oidTmpCostingItem = promotionItem.getItemMasterId();
                }

                ItemMaster itemMaster = DbItemMaster.fetchExc(oidTmpCostingItem);

                if (itemMaster.getApplyStockCode() == DbItemMaster.APPLY_STOCK_CODE || itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE){
                    useStockCode = true;
                }
                
                if(itemMaster.getApplyStockCode() == DbItemMaster.OPTIONAL_STOCK_CODE){
                    optionalCode = true;
                }

            }catch(Exception e) {}

            String strStockId = "";
            if(iJSPCommand==JSPCommand.POST){
                PromotionLocation promo = new PromotionLocation();
                Vector vloc = DbLocation.listAll();
                for(int i=0;i<vloc.size();i++){
                    Location loc = (Location) vloc.get(i);
                    long ij = JSPRequestValue.requestLong(request, "loc_"+loc.getOID());
                    DbPromotionLocation.deleteRecords(" promotion_id=" + oidPromotion + " and location_id="+ loc.getOID());
                    if(ij==1){
                        promo.setLocationId(loc.getOID());
                        promo.setLocationName(loc.getName());
                        promo.setPromotionId(oidPromotion);
                        
                        try{
                            
                            DbPromotionLocation.insertExc(promo);
                        }catch(Exception ex){
                            
                        }
                    }
                }
            }
            
            Vector vpar = new Vector();
            vpar.add("" + promotion.getPromoDesc());
            vpar.add("" + JSPFormater.formatDate(promotion.getStartDate(), "dd/MM/yyyy"));
            vpar.add("" + JSPFormater.formatDate(promotion.getEndDate(), "dd/MM/yyyy"));
            vpar.add("" + user.getFullName());
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
                window.open("<%=printroot%>.report.RptPromotionXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }  
   
  
        
   function cmdAddItemMaster(){      
            document.frmpromotion.command.value="<%=JSPCommand.ADD%>";
            window.open("<%=approot%>/postransaction/addItemPromotion.jsp", null, "height=400,width=600, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
            document.frmsalesproductdetail.command.value="<%=JSPCommand.SUBMIT%>";
            document.frmsalesproductdetail.submit();    
            
            
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
       
       



        
       
        
        
        
         
         
         function cmdVatEdit(){
             
             calculateAmount();
         }
         
         function cmdLocation(){
             <%if (promotion.getOID() != 0){%>
             if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all promotion item based on vendor item master. ')){
                 document.frmpromotion.hidden_promotion_id.value=0;
                 document.frmpromotion.hidden_promotion_item_id.value=0;
                 document.frmpromotion.command.value="<%=JSPCommand.LOAD%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             <%} else {%>
             document.frmpromotion.command.value="<%=JSPCommand.LOAD%>";
             document.frmpromotion.action="promotionitem.jsp";
             document.frmpromotion.submit();
             <%}%>
         }
         
         function cmdToRecord(){
             document.frmpromotion.command.value="<%=JSPCommand.NONE%>";
             document.frmpromotion.action="promotionlist.jsp";
             document.frmpromotion.submit();
         }
         
         
         
         function cmdDelStockCode(stockCodeId){
             
             if(confirm('Are sure you want delete this item ?')){
                 
                 document.frmpromotion.hidden_oid_stock_code_del.value=stockCodeId;
                 document.frmpromotion.hidden_del_stock.value=1;
                 document.frmpromotion.command.value="<%=JSPCommand.VIEW%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit(); 
             }
         
         }    
         
         
             
             function viewStockCode(){
                 document.frmpromotion.command.value="<%=JSPCommand.VIEW%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();            
             }
             
             function viewStockCodeEdit(oidTransfer,oidTransferItem){
                 
                 var cfrm = confirm('Are you sure want to change qty promotion, and you will lose stock code data(s) ?');
                 
                 if(cfrm==true){
                     document.frmpromotion.hidden_promotion_id.value=oidTransfer;
                     document.frmpromotion.hidden_promotion_item_id.value=oidTransferItem;
                     document.frmpromotion.hidden_del_stock.value=2;
                     document.frmpromotion.command.value="<%=JSPCommand.REFRESH%>";
                     document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                     document.frmpromotion.action="promotionitem.jsp";
                     document.frmpromotion.submit();            
                 }
                 
             }
             function checkDiscountPercent(){
                    
                    var disPercent = document.frmpromotion.<%=JspPromotionItem.colNames[JspPromotionItem.JSP_DISCOUNT_PERCENT]%>.value;
                    var disRp = document.frmpromotion.<%=JspPromotionItem.colNames[JspPromotionItem.JSP_DISCOUNT_VALUE]%>.value;
                    
                    if(disPercent>0){
                        document.frmpromotion.<%=JspPromotionItem.colNames[JspPromotionItem.JSP_DISCOUNT_VALUE]%>.value=0;
                        
                    }
                    
                    
            }
            
            function checkDiscountRp(){
                    
                    var disRp = document.frmpromotion.<%=JspPromotionItem.colNames[JspPromotionItem.JSP_DISCOUNT_VALUE]%>.value;
                    
                                        
                    if(disRp>0){
                        document.frmpromotion.<%=JspPromotionItem.colNames[JspPromotionItem.JSP_DISCOUNT_PERCENT]%>.value=0;
                        
                    }
                    
            }
             
             function calculateAmount(){}
             
             function cmdClosedReason(){}
             
             function cmdCloseDoc(){
                 document.frmpromotion.action="<%=approot%>/home.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdAskDoc(){
                 document.frmpromotion.hidden_promotion_item_id.value="0";
                 document.frmpromotion.command.value="<%=JSPCommand.SUBMIT%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdDeleteDoc(){
                 document.frmpromotion.hidden_promotion_item_id.value="0";
                 document.frmpromotion.command.value="<%=JSPCommand.CONFIRM%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdCancelDoc(){
                 document.frmpromotion.hidden_promotion_item_id.value="0";
                 document.frmpromotion.command.value="<%=JSPCommand.EDIT%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdSaveDoc(){
                 document.frmpromotion.command.value="<%=JSPCommand.POST%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdAdd(){
                 document.frmpromotion.hidden_promotion_item_id.value="0";
                 document.frmpromotion.command.value="<%=JSPCommand.ADD%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdAsk(oidTransferItem){
                 document.frmpromotion.hidden_promotion_item_id.value=oidTransferItem;
                 document.frmpromotion.command.value="<%=JSPCommand.ASK%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdAskMain(oidTransfer){
                 document.frmpromotion.hidden_promotion_id.value=oidTransfer;
                 document.frmpromotion.command.value="<%=JSPCommand.ASK%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotion.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdConfirmDelete(oidTransferItem){
                 document.frmpromotion.hidden_promotion_item_id.value=oidTransferItem;
                 document.frmpromotion.command.value="<%=JSPCommand.DELETE%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             function cmdSaveMain(){
                 document.frmpromotion.command.value="<%=JSPCommand.SAVE%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotion.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdSave(){
                 document.frmpromotion.command.value="<%=JSPCommand.SAVE%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdEdit(oidTransfer){
                 document.frmpromotion.hidden_promotion_item_id.value=oidTransfer;
                 document.frmpromotion.command.value="<%=JSPCommand.EDIT%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdCancel(oidTransfer){
                 document.frmpromotion.hidden_promotion_item_id.value=oidTransfer;
                 document.frmpromotion.command.value="<%=JSPCommand.EDIT%>";
                 document.frmpromotion.prev_command.value="<%=prevJSPCommand%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdBack(){
                 document.frmpromotion.command.value="<%=JSPCommand.BACK%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdSelectAll(){
                 document.frmpromotion.command.value="<%=JSPCommand.REFRESH%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdListFirst(){
                 document.frmpromotion.command.value="<%=JSPCommand.FIRST%>";
                 document.frmpromotion.prev_command.value="<%=JSPCommand.FIRST%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdListPrev(){
                 document.frmpromotion.command.value="<%=JSPCommand.PREV%>";
                 document.frmpromotion.prev_command.value="<%=JSPCommand.PREV%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdListNext(){
                 document.frmpromotion.command.value="<%=JSPCommand.NEXT%>";
                 document.frmpromotion.prev_command.value="<%=JSPCommand.NEXT%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
             }
             
             function cmdListLast(){
                 document.frmpromotion.command.value="<%=JSPCommand.LAST%>";
                 document.frmpromotion.prev_command.value="<%=JSPCommand.LAST%>";
                 document.frmpromotion.action="promotionitem.jsp";
                 document.frmpromotion.submit();
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
                                                        <form name="frmpromotion" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_promotion_id" value="<%=oidPromotion%>">
                                                            <input type="hidden" name="hidden_promotion_item_id" value="<%=oidPromotionItem%>">
                                                            <input type="hidden" name="<%=JspPromotionItem.colNames[JspPromotionItem.JSP_PROMOTION_ID]%>" value="<%=oidPromotion%>">
                                                            <input type="hidden" name="hidden_oid_stock_code_del" value="<%=0%>">
                                                            <input type="hidden" name="hidden_del_stock" value="<%=0%>">
                                                            
                                                            <input type="hidden" name="<%= JspPromotion.colNames[JspPromotion.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            
                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                 
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Promotion 
                                                                                        </font><font class="tit1">&raquo; <span class="lvl2">Promotion
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
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;Promotion 
                                                                                                Item &nbsp;&nbsp;</div>
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
                                                                                                                    <%if (promotion.getOID() == 0) {%>
                                                                                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                                                                                    <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(promotion.getUserId());
    } catch (Exception e) {
    }
                                                                                                                    %>
                                                                                                                    Prepared By : <%=us.getLoginId()%> 
                                                                                                                    <%}%>
                                                                                                            </i>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="26" width="12%">&nbsp;Start Date</td>
                                                                                                        <td height="26" width="27%">
                                                                                                            <input name="<%=JspPromotion.colNames[JspPromotion.JSP_START_DATE]%>" value="<%=JSPFormater.formatDate((promotion.getStartDate() == null) ? new Date() : promotion.getStartDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpromotion.<%=JspPromotion.colNames[JspPromotion.JSP_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                                                                                                        </td> 
                                                                                                        <td width="9%">End Date</td>
                                                                                                        <td colspan="2" class="comment" width="52%">
                                                                                                            <input name="<%=JspPromotion.colNames[JspPromotion.JSP_END_DATE]%>" value="<%=JSPFormater.formatDate((promotion.getEndDate() == null) ? new Date() : promotion.getEndDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmpromotion.<%=JspPromotion.colNames[JspPromotion.JSP_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                            <%
                                                                                                                //rptKonstan.setTanggal(promotion.getDate());
                                                                                                            %> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%" valign="top">&nbsp;Description</td>
                                                                                                        <td height="21" width="27%"> 
                                                                                                            <textarea name="<%=JspPromotion.colNames[JspPromotion.JSP_PROMO_DESC]%>" cols="40" rows="3"><%=promotion.getPromoDesc()%></textarea>
                                                                                                        </td>
                                                                                                        
                                                                                                    </tr>
                                                                                                    <%
           // rptKonstan.setNotes(promotion.getNote());
                                                                                                    %>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(iJSPCommand, jspCostingItem, promotionItem, vPromoItem, oidPromotionItem, approot, iErrCode2,promotion, isSave, optionalCode, itemMasterId);
            String strString = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
                                                                                                            %>
                                                                                                            <%=strString%> 
                                                                                                            <% session.putValue("DETAIL", rptObj);%>
                                                                                                            <% session.putValue("REPORT_PROMOTION_ITEM", vPromoItem);%>
                                                                                                            <% session.putValue("REPORT_PROMOTION_HEADER", vpar);%>
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
                                                                                                                        <%//if ((vPromoItem != null && vPromoItem.size() > 0)) {%>
                                                                                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <%
    if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD ||
            (iJSPCommand == JSPCommand.EDIT && oidPromotionItem != 0) ||
            iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                 <%
                                                                                                                                ctrLine = new JSPLine();
                                                                                                                                ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                                ctrLine.initDefault();
                                                                                                                                ctrLine.setTableWidth("80%");
                                                                                                                                String scomDel = "javascript:cmdAsk('" + oidPromotionItem + "')";
                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidPromotionItem + "')";
                                                                                                                                String scancel = "javascript:cmdBack('" + oidPromotionItem + "')";
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

                                                                                                                               // if (vPromoItem == null || vPromoItem.size() == 0){
                                                                                                                                 //   ctrLine.setSaveCaption("");
                                                                                                                                    //ctrLine.setCancelCaption("");
                                                                                                                               // }

                                                                                                                                if (iJSPCommand == JSPCommand.LOAD) {
                                                                                                                                    if (oidPromotionItem == 0) {
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
                                                                                                                                <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a>
                                                                                                                                                                                                                                                                        
                                                                                                                                                &nbsp;&nbsp;<a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                

</td>
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
                                                                                                                        <%//}%>
                                                                                                                    </td>
                                                                                                                    <td width="55%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (promotion.getOID() != 0) {%>
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
                                                                                                                        <%if (promotion.getOID() != 0 ) {%>
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="12%">&nbsp;</td>
                                                                                                                                <td width="14%">&nbsp;</td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            
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
    if (promotion.getOID() != 0) {
                                                                                                                %>
                                                                                                                <tr>
                                                                                                                    <td><b>Select Location</b></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td colspan="4">
                                                                                                                        <table border="0" width="100%">
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0">
                                                                                                                                        <%
                                                                                                                                            Vector vlocGol1 = DbLocation.list(0, 0," gol_price='gol_1'","");%>
                                                                                                                                            
                                                                                                                                         <tr>
                                                                                                                                            <td><b>GOL 1</b></td>
                                                                                                                                         </tr>   
                                                                                                                                        <%for(int a=0;a<vlocGol1.size();a++){%>
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                            Location locGol1 = (Location) vlocGol1.get(a);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                               <td width="200"><%=locGol1.getName()%></td>
                                                                                                                                               <%if(iJSPCommand==JSPCommand.REFRESH){%>
                                                                                                                                                <td><input type="checkbox" name="loc_<%=locGol1.getOID()%>"  value="1" checked ></td>  
                                                                                                                                               <%}else{%> 
                                                                                                                                                <td>
                                                                                                                                                   <input type="checkbox" name="loc_<%=locGol1.getOID()%>"  value="1" <%if (DbPromotionLocation.checkLocation(locGol1.getOID(), oidPromotion) == 1) {%>checked<%}%>>
                                                                                                                                                </td>
                                                                                                                                                <%}%>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                
                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0">
                                                                                                                                        <%
                                                                                                                                            Vector vlocGol2 = DbLocation.list(0, 0," gol_price='gol_2'","");%>
                                                                                                                                            
                                                                                                                                         <tr>
                                                                                                                                            <td><b>GOL 2</b></td>
                                                                                                                                         </tr>   
                                                                                                                                        <%for(int a=0;a<vlocGol2.size();a++){%>
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                            Location locGol2 = (Location) vlocGol2.get(a);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                               <td width="200"><%=locGol2.getName()%></td>
                                                                                                                                               <%if(iJSPCommand==JSPCommand.REFRESH){%>
                                                                                                                                                <td><input type="checkbox" name="loc_<%=locGol2.getOID()%>"  value="1" checked ></td>  
                                                                                                                                               <%}else{%> 
                                                                                                                                                <td>
                                                                                                                                                   <input type="checkbox" name="loc_<%=locGol2.getOID()%>"  value="1" <%if (DbPromotionLocation.checkLocation(locGol2.getOID(), oidPromotion) == 1) {%>checked<%}%>>
                                                                                                                                                </td>
                                                                                                                                                <%}%>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                
                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0">
                                                                                                                                        <%
                                                                                                                                            Vector vlocGol3 = DbLocation.list(0, 0," gol_price='gol_3'","");%>
                                                                                                                                            
                                                                                                                                         <tr>
                                                                                                                                            <td><b>GOL 3</b></td>
                                                                                                                                         </tr>   
                                                                                                                                        <%for(int a=0;a<vlocGol3.size();a++){%>
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                            Location locGol3 = (Location) vlocGol3.get(a);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                               <td width="200" ><%=locGol3.getName()%></td>
                                                                                                                                               <%if(iJSPCommand==JSPCommand.REFRESH){%>
                                                                                                                                                <td><input type="checkbox" name="loc_<%=locGol3.getOID()%>"  value="1" checked ></td>  
                                                                                                                                               <%}else{%> 
                                                                                                                                                <td>
                                                                                                                                                   <input type="checkbox" name="loc_<%=locGol3.getOID()%>"  value="1" <%if (DbPromotionLocation.checkLocation(locGol3.getOID(), oidPromotion) == 1) {%>checked<%}%>>
                                                                                                                                                </td>
                                                                                                                                                <%}%>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                
                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0">
                                                                                                                                        <%
                                                                                                                                            Vector vlocGol4 = DbLocation.list(0, 0," gol_price='gol_4'","");%>
                                                                                                                                            
                                                                                                                                         <tr>
                                                                                                                                            <td><b>GOL 4</b></td>
                                                                                                                                         </tr>   
                                                                                                                                        <%for(int a=0;a<vlocGol4.size();a++){%>
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                            Location locGol4 = (Location) vlocGol4.get(a);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                               <td width="200" ><%=locGol4.getName()%></td>
                                                                                                                                               <%if(iJSPCommand==JSPCommand.REFRESH){%>
                                                                                                                                                <td><input type="checkbox" name="loc_<%=locGol4.getOID()%>"  value="1" checked ></td>  
                                                                                                                                               <%}else{%> 
                                                                                                                                                <td>
                                                                                                                                                   <input type="checkbox" name="loc_<%=locGol4.getOID()%>"  value="1" <%if (DbPromotionLocation.checkLocation(locGol4.getOID(), oidPromotion) == 1) {%>checked<%}%>>
                                                                                                                                                </td>
                                                                                                                                                <%}%>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                
                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0">
                                                                                                                                        <%
                                                                                                                                            Vector vlocGol5 = DbLocation.list(0, 0," gol_price='gol_5'","");%>
                                                                                                                                            
                                                                                                                                         <tr>
                                                                                                                                            <td><b>GOL 5</b></td>
                                                                                                                                         </tr>   
                                                                                                                                        <%for(int a=0;a<vlocGol5.size();a++){%>
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                            Location locGol5 = (Location) vlocGol5.get(a);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                               <td width="200" ><%=locGol5.getName()%></td>
                                                                                                                                               <%if(iJSPCommand==JSPCommand.REFRESH){%>
                                                                                                                                                <td><input type="checkbox" name="loc_<%=locGol5.getOID()%>"  value="1" checked ></td>  
                                                                                                                                               <%}else{%> 
                                                                                                                                                <td>
                                                                                                                                                   <input type="checkbox" name="loc_<%=locGol5.getOID()%>"  value="1" <%if (DbPromotionLocation.checkLocation(locGol5.getOID(), oidPromotion) == 1) {%>checked<%}%>>
                                                                                                                                                </td>
                                                                                                                                                <%}%>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                
                                                                                                                                
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0">
                                                                                                                                        <%
                                                                                                                                            Vector vlocGol6 = DbLocation.list(0, 0," gol_price='gol_6'","");%>
                                                                                                                                            
                                                                                                                                         <tr>
                                                                                                                                            <td><b>GOL 6</b></td>
                                                                                                                                         </tr>   
                                                                                                                                        <%for(int a=0;a<vlocGol6.size();a++){%>
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                            Location locGol6 = (Location) vlocGol6.get(a);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                               <td width="200" ><%=locGol6.getName()%></td>
                                                                                                                                               <%if(iJSPCommand==JSPCommand.REFRESH){%>
                                                                                                                                                <td><input type="checkbox" name="loc_<%=locGol6.getOID()%>"  value="1" checked ></td>  
                                                                                                                                               <%}else{%> 
                                                                                                                                                <td>
                                                                                                                                                   <input type="checkbox" name="loc_<%=locGol6.getOID()%>"  value="1" <%if (DbPromotionLocation.checkLocation(locGol6.getOID(), oidPromotion) == 1) {%>checked<%}%>>
                                                                                                                                                </td>
                                                                                                                                                <%}%>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                
                                                                                                                                
                                                                                                                            </tr>
                                                                                                                             <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0">
                                                                                                                                        <%
                                                                                                                                            Vector vlocGol7 = DbLocation.list(0, 0," gol_price='gol_7'","");%>
                                                                                                                                            
                                                                                                                                         <tr>
                                                                                                                                            <td><b>GOL 7</b></td>
                                                                                                                                         </tr>   
                                                                                                                                        <%for(int a=0;a<vlocGol7.size();a++){%>
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                            Location locGol7 = (Location) vlocGol7.get(a);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                               <td width="200" ><%=locGol7.getName()%></td>
                                                                                                                                               <%if(iJSPCommand==JSPCommand.REFRESH){%>
                                                                                                                                                <td><input type="checkbox" name="loc_<%=locGol7.getOID()%>"  value="1" checked ></td>  
                                                                                                                                               <%}else{%> 
                                                                                                                                                <td>
                                                                                                                                                   <input type="checkbox" name="loc_<%=locGol7.getOID()%>"  value="1" <%if (DbPromotionLocation.checkLocation(locGol7.getOID(), oidPromotion) == 1) {%>checked<%}%>>
                                                                                                                                                </td>
                                                                                                                                                <%}%>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                
                                                                                                                                
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    
                                                                                                                </tr>    
                                                                                                                 <tr>
                                                                                                                                <td>
                                                                                                                                    <table border="0">
                                                                                                                                        <%
                                                                                                                                            Vector vlocGol8 = DbLocation.list(0, 0," gol_price='gol_8'","");%>
                                                                                                                                            
                                                                                                                                         <tr>
                                                                                                                                            <td><b>GOL 8</b></td>
                                                                                                                                         </tr>   
                                                                                                                                        <%for(int a=0;a<vlocGol8.size();a++){%>
                                                                                                                                        <tr>
                                                                                                                                            <%
                                                                                                                                            Location locGol8 = (Location) vlocGol8.get(a);
                                                                                                                                            
                                                                                                                                            %>
                                                                                                                                               <td width="200" ><%=locGol8.getName()%></td>
                                                                                                                                               <%if(iJSPCommand==JSPCommand.REFRESH){%>
                                                                                                                                                <td><input type="checkbox" name="loc_<%=locGol8.getOID()%>"  value="1" checked ></td>  
                                                                                                                                               <%}else{%> 
                                                                                                                                                <td>
                                                                                                                                                   <input type="checkbox" name="loc_<%=locGol8.getOID()%>"  value="1" <%if (DbPromotionLocation.checkLocation(locGol8.getOID(), oidPromotion) == 1) {%>checked<%}%>>
                                                                                                                                                </td>
                                                                                                                                                <%}%>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                        <%}%>
                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                                
                                                                                                                                
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                    
                                                                                                                </tr>  
                                                                                                                
                                                                                                                <tr>
                                                                                                                                
                                                                                                                                    <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdSelectAll()">Select All</a></td>
                                                                                                                                
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%if (vPromoItem != null) {
                                                                                                                    if (promotion.getOID() != 0) {
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <%//if ((!promotion.getStatus().equals(I_Project.DOC_STATUS_APPROVED) || iErrCode != 0) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES"))  {%>
                                                                                                                    <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                                                                                    <td width="102" > 
                                                                                                                        <div align="left"><a href="javascript:cmdAskDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/del2.gif',1)"><img src="../images/del.gif" name="del2111" height="22" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <%//}%>
                                                                                                                    
                                                                                                                    <td width="862"> 
                                                                                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}
} else {%>
                                                                                                                <%if (false) {%>
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" nowrap> 
                                                                                                                        <div align="left"><font color="#FF0000"><i>No stock item available for promotion </i></font></div>
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
                                                            
                                                            
                                                        </form>
                                                        <%
            //session.putValue("KONSTAN", rptKonstan);
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
