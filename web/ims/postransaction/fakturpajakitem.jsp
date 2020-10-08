
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
    public Vector drawList(int iJSPCommand, JspFakturPajakDetail frmObject,
            FakturPajakDetail objEntity, Vector objectClass,
            long transferItemId, String approot, 
            int iErrCode2,  FakturPajak transfer, boolean isSave, long itemMasterId) {
        
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");
        
        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Name", "35%");
        jsplist.addHeader("Code", "10%");
        jsplist.addHeader("Category", "10%");
        jsplist.addHeader("Unit", "10%");
        if(iJSPCommand!=JSPCommand.POST){
            jsplist.addHeader("", "10%");
        }
        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

       //int vectVendMaster = DbStock.getStockItemCountByLocation(oidFromLocationId,DbStock.TYPE_NON_CONSIGMENT);

        //Vector vect_value = new Vector(1, 1);
        //Vector vect_key = new Vector(1, 1);

        /*if (vectVendMaster != null && vectVendMaster.size() > 0) {

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
        }*/

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
                if(iJSPCommand== JSPCommand.ADD){
                    objEntity.setItemMasterId(itemMasterId);
                }else if(iJSPCommand== JSPCommand.EDIT){
                    objEntity.setItemMasterId(transferItem.getItemMasterId());
                }
                
                ItemMaster colCombo2  = new ItemMaster();
                
			try{
				colCombo2 = DbItemMaster.fetchExc(objEntity.getItemMasterId());
                                
			}catch(Exception e) {
				System.out.println(e);
			}
                
                //double stockItems = DbStock.getItemTotalStock(oidToLocation, objEntity.getItemMasterId());
                //objEntity.setQty(stockItems);
                
                //if (vectVendMaster > 0){

                    String strVal = "<table border=\"0\" cellpading=\"0\" cellspacing=\"1\" width=\"100%\">";
                    
                    //strVal += "<tr><td colspan=\"3\"><div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspFakturPajakDetail.JSP_ITEM_MASTER_ID], null, "" + objEntity.getItemMasterId(), vect_value, vect_key, "onchange=\"javascript:parserMasterLoop()\"", "formElemen") + frmObject.getErrorMsg(frmObject.JSP_ITEM_MASTER_ID) + "</div></td></tr>";
                    strVal += "<tr><td colspan=\"4\"><input type=\"hidden\" name=\""+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getOID()+"\">"+"<input style=\"text-align:right\" type=\"text\" name=\"X_"+frmObject.colNames[frmObject.JSP_ITEM_MASTER_ID] +"\" value=\""+colCombo2.getName()+"\" class=\"readonly\" size=\"35\" readonly>" + "<a href=\"javascript:cmdAddItemMaster()\"height=\"20\" border=\"0\" style=\"padding:0px\"> &nbsp Search</a></td></tr>";
                    

                    strVal += "<tr><td></td><td></td><td></td></tr>";
                    strVal += "</table>";

                    rowx.add(strVal);
                
                

                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"20\" name=\"\" value=\"" + colCombo2.getCode() + "\" class=\"readOnly\" readOnly style=\"text-align:right\"> </div>");
                rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"20\" name=\"\" value=\"\" class=\"readOnly\" readOnly style=\"text-align:right\"> </div>");
                //rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspFakturPajakDetail.JSP_QTY] + "\" value=\"" + objEntity.getQty() + "\" class=\"formElemen\" style=\"text-align:right\" onBlur=\"javascript:calculateSubTotal()\" onClick=\"this.select()\" >" + "</div>");
                
                
                //rowx.add("<div align=\"right\">" + "<input type=\"text\" size=\"10\" name=\"" + frmObject.colNames[JspFakturPajakDetail.JSP_AMOUNT] + "\" value=\"" + objEntity.getAmount() + "\" class=\"readOnly\" style=\"text-align:right\" readOnly>" + "</div><input type=\"hidden\" name=\"temp_item_amount\" value=\"" + objEntity.getAmount() + "\">");
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
                //Stock stock = new Stock();
                //double stockItems = DbStock.getItemTotalStock(oidToLocation, transferItem.getItemMasterId());

                try {
                    uom = DbUom.fetchExc(itemMaster.getUomStockId());
                   // for(int j=0; j < stockItems.size();j++){
                    //    stock = (Stock) stockItems.get(j);
                     //   if(stock.getItemMasterId()==itemMaster.getOID()){
                      //      break;
                       // }
                   // }
                    
                } catch (Exception e) {
                }

                rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
                rowx.add(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                    //detail.setName(ig.getName() + " / " + itemMaster.getName() + " / " + itemMaster.getCode());
                    detail.setName(itemMaster.getName());
                    detail.setCode(itemMaster.getCode());
                    detail.setCategory(ig.getName());
               // }
                //rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(itemMaster.getCogs(), "#,###.##") + "</div>");
                detail.setPrice(transferItem.getPrice());
                rowx.add("<div align=\"left\">" + itemMaster.getCode() + "</div>");
                rowx.add("<div align=\"left\">" + ig.getName() + "</div>");
                //rowx.add("<div align=\"right\">" + stockItems + "</div>");
                //rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(transferItem.getQty(), "#,###.##") + "</div>");
                detail.setQty(transferItem.getQty());
                //rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(transferItem.getAmount(), "#,###.##") + "</div>");
                detail.setTotal(transferItem.getAmount());
                rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
                if(iJSPCommand!=JSPCommand.POST){
                    rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" size=\"20\" readonly name=\"item_"+transferItem.getOID()+ "\" value=\"1\" >" + "</div>");
                }
            }

            lstData.add(rowx);
            temp.add(detail);
        }

        rowx = new Vector();
       

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
            long oidFakturPajak = JSPRequestValue.requestLong(request, "hidden_transfer_id");
            long oidFakturDetail = JSPRequestValue.requestLong(request, "hidden_transfer_item_id");
            long oidLocationFrom = JSPRequestValue.requestLong(request, "hidden_locationIdFrom");
            String transferNumber =JSPRequestValue.requestString(request, JspFakturPajak.colNames[JspFakturPajak.JSP_TRANSFER_NUMBER]);
            long oidLocationTo =JSPRequestValue.requestLong(request, "hidden_locationIdTo");
            long itemMasterId = JSPRequestValue.requestLong(request, JspFakturPajakDetail.colNames[JspFakturPajakDetail.JSP_ITEM_MASTER_ID]);
            long oidLocationRequest =JSPRequestValue.requestLong(request, "JSP_TO_LOCATION_ID");
            
            boolean isEdit = false;
            boolean isRefresh = false;
            if (iJSPCommand == JSPCommand.EDIT) {
                isEdit = true;
            }
            if (iJSPCommand == JSPCommand.REFRESH) {
                iJSPCommand = JSPCommand.EDIT;
                isRefresh = true;
            }  

            
            boolean isNone = false;
            boolean isView = false;
            boolean isAdd = false;
            boolean isLoad = false;

            if (iJSPCommand == JSPCommand.ADD) {
                isAdd = true;
               // listStockCode = new Vector();
            }

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidFakturPajak = 0;
                isNone = true;
            }
            if (iJSPCommand == JSPCommand.LOAD) {
                
                isLoad = true;
            }
              
            /*variable declaration*/
            long oidTransfer=0;
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            RptFaktur rptKonstan = new RptFaktur();

           // CmdTransfer cmdTransfer = new CmdTransfer(request);
            CmdFakturPajak cmdFakturPajak = new CmdFakturPajak(request);
            
            JSPLine ctrLine = new JSPLine();

            //iErrCode = cmdTransfer.action(iJSPCommand, oidTransfer);
            iErrCode = cmdFakturPajak.action(iJSPCommand, oidFakturPajak);

            //JspTransfer jspTransfer = cmdTransfer.getForm();
            JspFakturPajak jspFaktur = cmdFakturPajak.getForm();
            //Transfer transfer = cmdTransfer.getTransfer();
            FakturPajak fakturPajak = cmdFakturPajak.getFakturPajak();
            
            //if(iJSPCommand==JSPCommand.LIST){
                //oidTransfer= DbTransfer.getOidByNumber(transferNumber);
            //}
            Vector vfakturItem = new Vector();//DbTransferItem.list(0,0, " transfer_id=" + oidTransfer, "");
            
            if (oidFakturPajak == 0) {
                oidFakturPajak = fakturPajak.getOID();
            }
            //if(transfer.getStatus().equals("") && transfer.getOID()!=0){
            //    transfer.setStatus("REQUEST");
            //    transfer.setApproval3(transfer.getUserId());
            //    transfer.setApproval3Date(transfer.getDate());
            //    transfer.setUserId(0);
            //    DbTransfer.updateExc(transfer);
            //}
            //if(transfer.getStatus().equals("REQUEST"))
            //{
             //   transfer.setUserId(0)   ;//status draft
             //   transfer.setApproval1(0);//status approved
            //    DbTransfer.updateExc(transfer);
            //}
            
            //msgString = cmdTransfer.getMessage();

           /* if (oidTransfer == 0) {
                oidTransfer = transfer.getOID();
                if(DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")){
                    transfer.setStatus("REQUEST");
                }else{
                    transfer.setStatus(I_Project.DOC_STATUS_APPROVED);
                }
                
            }else{
                try{
                   transfer = DbTransfer.fetchExc(oidTransfer);
                   
                    
                }catch(Exception e){
                    
                }
            }*/

            //whereClause = DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID] + "=" + oidFakturPajak;
            //orderClause = DbFakturPajakDetail.colNames[DbFakturPajakDetail.COL_FAKTUR_PAJAK_ID];

            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            //CmdTransferItem cmdFakturDetail = new CmdTransferItem(request);
            CmdFakturPajakDetail cmdFakturDetail = new CmdFakturPajakDetail(request);
            if (isRefresh == true) {
                iJSPCommand = JSPCommand.REFRESH;
            }
            //iErrCode2 = cmdFakturDetail.action(iJSPCommand, oidTransferItem, oidTransfer, listStockCode.size());
            
            //iErrCode2 = cmdFakturDetail.action(iJSPCommand, oidFakturDetail, oidFakturPajak);
            //if (isRefresh == true) {
            //    iJSPCommand = JSPCommand.EDIT;
            //}
            JspFakturPajakDetail jspFakturDetail = cmdFakturDetail.getForm();
            //JspFakturPajak jspFakturDetail = cmdFakturPajak.getForm();        
            
            
            FakturPajakDetail fakturDetail = cmdFakturDetail.getFakturItem();
            msgString2 = cmdFakturDetail.getMessage();
            
           

            //whereClause = DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ID] + "=" + oidFakturPajak;
            //orderClause = DbTransferItem.colNames[DbTransferItem.COL_TRANSFER_ITEM_ID];
            String msgSuccsess = "";
            Vector purchItems = DbFakturPajakDetail.list(0, 0, whereClause, orderClause);
            
            //if()
            
            
            
            
            
                if (iJSPCommand == JSPCommand.POST) {
                Vector temp = new Vector();
                Vector vItemFaktur= new Vector();
                if (vfakturItem != null && vfakturItem.size() > 0) {
                    for (int i = 0; i < vfakturItem.size(); i++) {
                        TransferItem ti = (TransferItem) vfakturItem.get(i);
                        int xxx = JSPRequestValue.requestInt(request, "item_" + ti.getOID());
                        
                        if (xxx == 1) {
                           // int dis = JSPRequestValue.requestInt(request, "discount_" + cus.getOID());
                            //cus.setPersonal_discount(dis);
                            FakturPajakDetail fakDetail = new FakturPajakDetail();
                            fakDetail.setFakturPajakId(oidFakturPajak);
                            fakDetail.setItemMasterId(ti.getItemMasterId());
                            ItemMaster im= new ItemMaster();
                            try{
                                im = DbItemMaster.fetchExc(ti.getItemMasterId());
                            }catch(Exception e){
                                
                            }
                            
                            fakDetail.setItemName(im.getName());
                            DbFakturPajakDetail.insertExc(fakDetail);
                            temp.add(fakDetail);
                            vItemFaktur.add(ti);
                           
                            //temp.add(ti);
                        }
                    }
                    if(vItemFaktur.size()>0 && vItemFaktur!=null){
                        vfakturItem = new Vector();
                        vfakturItem =  vItemFaktur;
                    }
                     session.putValue("DETAIL", temp);
                    //if (temp != null && temp.size() > 0) {
                    //    for(int bb=0;bb<temp.size();bb++){
                         //   TransferItem ti = (TransferItem) temp.get(bb);
                            //cus.setStatus("APPROVED");
                            //DbCustomer.update(cus);        
                        //    DbTransferItem.deleteExc(ti.getOID());
                            //DbTransferItem.insertExc(transferitem)
                      //  }
                    //}
                }
               // purchItems = DbTransferItem.list(0, 0, whereClause, orderClause);
            }
           
            
            
            
            if (iJSPCommand == JSPCommand.VIEW) {
                isView = true;
                iJSPCommand = JSPCommand.ADD;
            }

            Vector vendors = new Vector();

            Vector locations = DbLocation.list(0, 0, "", "name");

            long fromOid = 0;
            
            
            

            //Vector stockItems = DbStock.getStock(transfer.getFromLocationId(),DbStock.TYPE_NON_CONSIGMENT);
            //int stockItems = DbStock.getStockItemCountByLocation(transfer.getFromLocationId(), DbStock.TYPE_NON_CONSIGMENT);

            boolean isSave = false;

            if (iJSPCommand == JSPCommand.SAVE) {
                isSave = true;
            }

          

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidFakturDetail = 0;
                fakturDetail = new FakturPajakDetail();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD) {
                try {
                    fakturPajak = DbFakturPajak.fetchExc(oidFakturPajak);
                } catch (Exception e) {
                }
            }

           // double subTotal = DbTransferItem.getTotalTransferAmount(oidTransfer);

            Vector vLocations = DbLocation.list(0, 0, DbLocation.colNames[DbLocation.COL_LOCATION_ID] + " != " + fromOid, "name");

            Vector vErr = new Vector();

            //String whereSCode = DbStockCode.colNames[DbStockCode.COL_TRANSFER_ID] + "=" + faktu.getOID() + " AND " + DbStockCode.colNames[DbStockCode.COL_RECEIVE_ITEM_ID] + "=" + transferItem.getOID();

            //Vector vStockCode = DbStockCode.list(0, 0, whereSCode, null);

            boolean useStockCode = false;
            boolean optionalCode = false;

            try {

                long oidTmpTransferItem = 0;

                if (isNone || isAdd || isSave || isLoad) {
                    try {
                       // Stock stock = (Stock) stockItems.get(0);
                        ItemMaster im = new ItemMaster();
                        try {
                        //    im = DbItemMaster.fetchExc(stock.getItemMasterId());
                       //     oidTmpTransferItem = im.getOID();
                        } catch (Exception e) {}

                    } catch (Exception e) {
                    }
                } else {
                    oidTmpTransferItem = fakturDetail.getItemMasterId();
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
                window.open("<%=printroot%>.report.RptFakturPajakXls?idx=<%=System.currentTimeMillis()%>");
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
         
         
         
         function cmdToRecord(){
             document.frmtransfer.command.value="<%=JSPCommand.NONE%>";
             //document.frmtransfer.action="transferlistRequest.jsp";
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
         function cmdSearch(){
            document.frmtransfer.command.value="<%=JSPCommand.LIST%>";
            document.frmtransfer.action="fakturpajakitem.jsp";
            document.frmtransfer.submit();
        }
       
         
         
             function viewStockCode(){
                 document.frmtransfer.command.value="<%=JSPCommand.VIEW%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();            
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
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdDeleteDoc(){
                 document.frmtransfer.hidden_transfer_item_id.value="0";
                 document.frmtransfer.command.value="<%=JSPCommand.CONFIRM%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdCancelDoc(){
                 document.frmtransfer.hidden_transfer_item_id.value="0";
                 document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdSaveDoc(){
                 document.frmtransfer.command.value="<%=JSPCommand.POST%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="fakturpajakitem.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdAdd(){
                 document.frmtransfer.hidden_transfer_item_id.value="0";
                 document.frmtransfer.command.value="<%=JSPCommand.ADD%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdAsk(oidTransferItem){
                 document.frmtransfer.hidden_transfer_item_id.value=oidTransferItem;
                 document.frmtransfer.command.value="<%=JSPCommand.ASK%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
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
                 document.frmtransfer.action="transferitemRequest.jsp";
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
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdEdit(oidTransfer){
                 document.frmtransfer.hidden_transfer_item_id.value=oidTransfer;
                 document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdCancel(oidTransfer){
                 document.frmtransfer.hidden_transfer_item_id.value=oidTransfer;
                 document.frmtransfer.command.value="<%=JSPCommand.EDIT%>";
                 document.frmtransfer.prev_command.value="<%=prevJSPCommand%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdBack(){
                 document.frmtransfer.command.value="<%=JSPCommand.BACK%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdListFirst(){
                 document.frmtransfer.command.value="<%=JSPCommand.FIRST%>";
                 document.frmtransfer.prev_command.value="<%=JSPCommand.FIRST%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdListPrev(){
                 document.frmtransfer.command.value="<%=JSPCommand.PREV%>";
                 document.frmtransfer.prev_command.value="<%=JSPCommand.PREV%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdListNext(){
                 document.frmtransfer.command.value="<%=JSPCommand.NEXT%>";
                 document.frmtransfer.prev_command.value="<%=JSPCommand.NEXT%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
                 document.frmtransfer.submit();
             }
             
             function cmdListLast(){
                 document.frmtransfer.command.value="<%=JSPCommand.LAST%>";
                 document.frmtransfer.prev_command.value="<%=JSPCommand.LAST%>";
                 document.frmtransfer.action="transferitemRequest.jsp";
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
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspTransfer.colNames[JspTransfer.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_transfer_item_id" value="<%=oidFakturDetail%>">
                                                            <input type="hidden" name="hidden_transfer_id" value="<%=oidFakturPajak%>">
                                                            <input type="hidden" name="<%=JspFakturPajakDetail.colNames[JspFakturPajakDetail.JSP_FAKTUR_PAJAK_ID]%>" value="<%=oidFakturPajak%>">
                                                            <input type="hidden" name="<%=JspTransfer.colNames[JspTransfer.JSP_TYPE]%>" value="<%=DbTransfer.TYPE_NON_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM]%>" value="<%=DbTransfer.TYPE_NON_CONSIGMENT%>">
                                                                                   
                                                            
                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <script language="JavaScript">
                                                                  // parserMaster(); 
                                                                </script>
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1"> 
                                                                                        </font><font class="tit1"> <span class="lvl2">Faktur 
                                                                               Pajak </span></font></b></td>
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
                                                                                                        
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">Faktur Pajak</td>
                                                                                                        <td height="21" width="27%"> 
                                                                                                            <%
            String number = "";
            if (fakturPajak.getOID() == 0) {
                int ctr = DbFakturPajak.getNextCounter();
                number = DbFakturPajak.getNextNumber(ctr);
                //prOrder.setPoNumber(number);
                rptKonstan.setNumberFaktur(number);
            } else {
                number = fakturPajak.getNumber();
                //prOrder.setPoNumber(number);
                rptKonstan.setNumberFaktur(number);
            }
                                                                                                            %>
                                                                                                        <%=number%> </td>
                                                                                                        
                                                                                                    </tr>
                                                                                                    
                                                                                                    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%" valign="top">PKP</td>
                                                                                                        <td height="21" width="27%"> 
                                                                                                            <input type="text" name="<%=JspFakturPajak.colNames[JspFakturPajak.JSP_NAMA_PKP]%>" value="Bali petshop" cols="40" rows="3">
                                                                                                        </td>
                                                                                                       
                                                                                                    </tr>
                                                                                                    
                                                                                                    <%
           // rptKonstan.setNotes(transfer.getNote());
                                                                                                    %>
                                                                                                    
                                                                                                    
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
           // Vector x = "";//drawList(iJSPCommand, jspFakturDetail, fakturDetail, vfakturItem, oidFakturDetail, approot, iErrCode2, fakturPajak, isSave, itemMasterId);
            //String strString = (String) x.get(0);
            //Vector rptObj = (Vector) x.get(1);
                                                                                                            %>
                                                                                                            <%//=strString%> 
                                                                                                            <%// session.putValue("DETAIL", rptObj);%>
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
                                                                                                                        <%if ( iJSPCommand == JSPCommand.CONFIRM){%>
                                                                                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <%
    if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD ||
            (iJSPCommand == JSPCommand.EDIT && oidFakturDetail != 0) ||
            iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                    <%
                                                                                                                                ctrLine = new JSPLine();
                                                                                                                                ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                                ctrLine.initDefault();
                                                                                                                                ctrLine.setTableWidth("80%");
                                                                                                                                String scomDel = "javascript:cmdAsk('" + oidFakturDetail + "')";
                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidFakturDetail + "')";
                                                                                                                                String scancel = "javascript:cmdBack('" + oidFakturDetail + "')";
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

                                                                                                                                //if (stockItems <= 0) {
                                                                                                                                //    ctrLine.setSaveCaption("");
                                                                                                                               // }

                                                                                                                                if (iJSPCommand == JSPCommand.LOAD) {
                                                                                                                                    if (oidFakturDetail == 0) {
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
                                                                                                    
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="4"> 
                                                                                                                        <%if (fakturPajak.getOID() != 0 && purchItems != null && purchItems.size() > 0) {%>
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
    if (fakturPajak.getOID() != 0 && purchItems != null && purchItems.size() > 0) {
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" class="errfont"></td>
                                                                                                                </tr>
                                                                                                                <%}%>
                                                                                                                <%if (purchItems.size() >= 0) {
        //if (fakturPajak.getOID() != 0 && purchItems != null && purchItems.size() > 0) {
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    
                                                                                                                    <td width="149"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                                                                                    <% if(oidFakturPajak!=0){%>
                                                                                                                    <td width="97"> 
                                                                                                                        <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <%}%>
                                                                                                                    <td width="102" > 
                                                                                                                        <div align="left"></div>
                                                                                                                    </td>
                                                                                                                    
                                                                                                                    
                                                                                                                    <td width="97"> 
                                                                                                                        <div align="left"></div>
                                                                                                                    </td>
                                                                                                                    <td width="862"> 
                                                                                                                        <div align="left"></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%//}
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
                                                         
                                                            </script>
                                                            <script language="JavaScript">
                                                                <%if ((iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && fakturDetail.getOID() != 0) || iErrCode != 0)) {%>
                                                                
                                                         <%}
            if (fakturPajak.getOID() != 0 ) {%>
                    
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
