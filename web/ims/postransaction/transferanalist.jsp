
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.postransaction.order.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(Vector objectClass, int ignore, long idLocFrom, long idlocTo) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell1");
        jsplist.setCellStyle1("tablecell");
        jsplist.setHeaderStyle("tablehdr");

        Location fromloc = new Location();
        Location toloc = new Location();
        try {
            fromloc = DbLocation.fetchExc(idLocFrom);
            toloc = DbLocation.fetchExc(idlocTo);
        } catch (Exception ex) {

        }

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("Date", "8%");
        jsplist.addHeader("Order Location", "15%");
        //jsplist.addHeader("Order Number","8%");
        jsplist.addHeader("Barcode", "10%");
        jsplist.addHeader("Item name", "35%");
        jsplist.addHeader("Standart Stock", "7%");
        jsplist.addHeader("Stock On Hand", "7%");
        jsplist.addHeader("Transfer Prev ", "7%");
        jsplist.addHeader("Delivery Unit", "7%");
        jsplist.addHeader("Qty order", "7%");
        jsplist.addHeader("Stock " + toloc.getName(), "7%");
        jsplist.addHeader("Qty Trans", "7%");
        jsplist.addHeader("Select", "5%");
        //jsplist.addHeader("Uom Sales Id","11%");

        //jsplist.setLinkRow(0);
        //jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();

        //jsplist.setLinkSufix("')");
        jsplist.reset();
        int index = -1;


        Vector tempig = new Vector();
        Vector temp = new Vector();




        int jum = 0;



        for (int i = 0; i < objectClass.size(); i++) {
            Order odr = (Order) objectClass.get(i);
            Order order = new Order();
            RptOrder detail = new RptOrder();
            ItemMaster im = new ItemMaster();
            try {
                order = DbOrder.fetchExc(odr.getOID());
                im = DbItemMaster.fetchExc(order.getItemMasterId());

            } catch (Exception ex) {

            }
            double stockDc = DbStock.getItemTotalStock(toloc.getOID(), order.getItemMasterId());
            if (ignore == 1) {

                if (stockDc > 0) {
                    jum = jum + 1;
                    Vector rowx = new Vector();
                    Location loc = new Location();


                    try {
                        loc = DbLocation.fetchExc(order.getLocationId());
                    } catch (Exception ex) {

                    }


                    rowx.add("<div align=\"center\">" + "" + jum + "</div>");
                    rowx.add("" + JSPFormater.formatDate(order.getDate(), "dd MMM yyyy HH:mm:ss"));
                    detail.setDate(order.getDate());
                    rowx.add("" + loc.getName());
                    detail.setLocation(loc.getName());
                    //rowx.add("" + order.getNumber());
                    detail.setNumber(order.getNumber());
                    rowx.add("" + im.getBarcode());
                    detail.setBarcode(im.getBarcode());
                    rowx.add("" + im.getName());
                    detail.setName(im.getName());
                    rowx.add("" + order.getQtyStandar());
                    rowx.add("" + order.getQtyStock());
                    rowx.add("" + DbStock.getTotalTransfer(order.getLocationId(), order.getItemMasterId()));

                    rowx.add("" + im.getDeliveryUnit());
                    rowx.add("" + order.getQtyOrder());
                    detail.setQty_order(order.getQtyOrder());
                    rowx.add("<div align=\"center\">" + "<input type=\"textbox\" size=\"5\" readonly name=\"stock_" + order.getOID() + "\" value=\"" + stockDc + "\" >" + "</div>");
                    rowx.add("<div align=\"center\">" + "<input type=\"textbox\" size=\"5\" name=\"qty_" + order.getOID() + "\" value=\"0\" onChange=javascript:calculateSubTotal('" + order.getOID() + "')>" + "</div>");
                    rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" size=\"20\" readonly name=\"item_" + order.getOID() + "\" value=\"1\" >" + "</div>");

                    lstData.add(rowx);
                    lstLinkData.add(String.valueOf(order.getOID()));
                    tempig.add(detail);
                }


            } else {

                Vector rowx = new Vector();
                Location loc = new Location();

                //RptOrder detail = new RptOrder();
                try {
                    loc = DbLocation.fetchExc(order.getLocationId());
                } catch (Exception ex) {

                }



                rowx.add("<div align=\"center\">" + "" + (i + 1) + "</div>");
                rowx.add("" + JSPFormater.formatDate(order.getDate(), "dd MMM yyyy HH:mm:ss"));
                detail.setDate(order.getDate());
                rowx.add("" + loc.getName());
                detail.setLocation(loc.getName());
                //rowx.add("" + order.getNumber());
                detail.setNumber(order.getNumber());
                rowx.add("" + im.getBarcode());
                detail.setBarcode(im.getBarcode());
                rowx.add("" + im.getName());
                detail.setName(im.getName());
                rowx.add("" + order.getQtyStandar());
                rowx.add("" + order.getQtyStock());
                rowx.add("" + DbStock.getTotalTransfer(order.getLocationId(), order.getItemMasterId()));
                rowx.add("" + im.getDeliveryUnit());
                rowx.add("" + order.getQtyOrder());
                detail.setQty_order(order.getQtyOrder());
                rowx.add("<div align=\"center\">" + "<input type=\"textbox\" size=\"5\" readonly name=\"stock_" + order.getOID() + "\" value=\"" + stockDc + "\" >" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"textbox\" size=\"5\" name=\"qty_" + order.getOID() + "\" value=\"0\" onChange=javascript:calculateSubTotal('" + order.getOID() + "')>" + "</div>");
                rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" size=\"20\" readonly name=\"item_" + order.getOID() + "\" value=\"1\" >" + "</div>");

                lstData.add(rowx);
                lstLinkData.add(String.valueOf(order.getOID()));
                temp.add(detail);

            }

        }
        //session.putValue("DETAIL", vdet);

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        if (ignore == 1) {
            v.add(tempig);
        } else {
            v.add(temp);
        }

        return v;
    //return jsplist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            Vector vCategory = DbItemGroup.list(0, 0, "", "" + DbItemGroup.colNames[DbItemGroup.COL_NAME]);

            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }

            if (session.getValue("DETAIL") != null) {
                session.removeValue("DETAIL");
            }


//--------------- search ------------------------------------------------------
            long srcGroupId = JSPRequestValue.requestLong(request, "src_group");
            long srcCategoryId = JSPRequestValue.requestLong(request, "src_category");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcBarCode = JSPRequestValue.requestString(request, "src_barcode");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            int all = JSPRequestValue.requestInt(request, "all");
            int allcat = JSPRequestValue.requestInt(request, "all_cat");
            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            long srcToLocationId = JSPRequestValue.requestLong(request, "src_to_location_id");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
//-----------------------------------------------------------------------------

            /*variable declaration*/
            int recordToGet = 0;
            String whereClause = "type<>" + I_Ccs.TYPE_CATEGORY_FINISH_GOODS + " and type<>" + I_Ccs.TYPE_CATEGORY_CIVIL_WORK;
            String orderClause = "im.item_category_id";//DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+","+DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID]+","+
            //DbItemMaster.colNames[DbItemMaster.COL_CODE]+","+DbItemMaster.colNames[DbItemMaster.COL_NAME];

            String whereGrp = "";
            String whereCat = "";
            if (all != 1) {
                if (vCategory != null && vCategory.size() > 0) {
                    for (int i = 0; i < vCategory.size(); i++) {
                        ItemGroup ic = (ItemGroup) vCategory.get(i);
                        int ok = JSPRequestValue.requestInt(request, "grp" + ic.getOID());
                        if (ok == 1) {
                            if (whereGrp != null && whereGrp.length() > 0) {
                                whereGrp = whereGrp + ",";
                            }
                            whereGrp = whereGrp + ic.getOID();
                        }
                    }
                }

                if (whereGrp.length() > 0) {
                    whereClause = whereClause + " and im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + " in(" + whereGrp + ") ";
                }

            }

            Vector vSubCategory = new Vector();
            if (whereGrp.length() > 0) {
                vSubCategory = DbItemCategory.list(0, 0, " item_group_id in (" + whereGrp + ")", DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID]);
            } else {
            //vSubCategory = DbItemCategory.list(0, 0, "" ,DbItemCategory.colNames[DbItemCategory.COL_ITEM_GROUP_ID]);
            }

            if (allcat != 1) {
                if (vSubCategory != null && vSubCategory.size() > 0) {
                    for (int i = 0; i < vSubCategory.size(); i++) {
                        ItemCategory ic = (ItemCategory) vSubCategory.get(i);
                        int ok = JSPRequestValue.requestInt(request, "cat" + ic.getOID());
                        if (ok == 1) {
                            if (whereCat != null && whereCat.length() > 0) {
                                whereCat = whereCat + ",";
                            }
                            whereCat = whereCat + ic.getOID();
                        }
                    }
                    if (whereCat.length() > 0) {
                        whereClause = whereClause + " and im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + " in(" + whereCat + ") ";
                    }

                }
            }

            if (srcCode != null && srcCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%'";
            }
            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName + "%'";
            }
            if (srcBarCode != null && srcBarCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "(" + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + srcBarCode + "%' or " + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcBarCode + "%' or " + "im." + DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcBarCode + "%')";
            }
            if (srcVendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " vi.vendor_id=" + srcVendorId;
            }

            if (srcLocationId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " ao.location_id=" + srcLocationId;
            }

            if (srcToLocationId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " (im.location_order=" + srcToLocationId + " or im.location_order=0) ";
            }

            if (whereClause.length() > 0) {
                whereClause = whereClause + " and ";
            }
            whereClause = whereClause + " ao.status='DRAFT'";


//out.println("whereClause : "+whereClause);


            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            Vector listOrder = new Vector(1, 1);

            /*switch statement */
//iErrCode = ctrlItemMaster.action(iJSPCommand , oidItemMaster);
/* end switch*/
            JspItemMaster jspItemMaster = ctrlItemMaster.getForm();

            /*count list All ItemMaster*/
            int vectSize = 0;
            if (srcVendorId != 0) {
            // vectSize = DbItemMaster.getCountBySupplier(whereClause);
            } else {
            //vectSize = DbItemMaster.getCount(whereClause);
            }


            ItemMaster itemMaster = ctrlItemMaster.getItemMaster();
//msgString =  ctrlItemMaster.getMessage();

            if (oidItemMaster == 0) {
                oidItemMaster = itemMaster.getOID();
            }

            /*if((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV )||
            (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)){
            start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
            } */
            /* end switch list*/

            /* get record to display */

            RptOrder rptodr = new RptOrder();

            long oidTransfer = 0;
            boolean transferok = false;

            if (iJSPCommand == JSPCommand.GET) {
                Vector vItem = new Vector();
                if (srcVendorId != 0) {
                    DbOrder.getStockListByVendor(srcBarCode, srcCode, srcName, srcGroupId, srcCategoryId, srcLocationId, srcToLocationId, srcVendorId);
                } else {
                    DbOrder.checkItemOrder(srcBarCode, srcCode, srcName, srcGroupId, srcCategoryId, srcLocationId, srcToLocationId);
                }

                if (vItem.size() > 0 && vItem != null) {
                    Stock st = new Stock();
                    for (int i = 0; i < vItem.size(); i++) {
                        st = (Stock) vItem.get(i);
                        DbOrder.checkRequestTransfer(st.getItemMasterId(), st.getLocationId());
                    }

                }
                if (srcVendorId != 0) {
                    listOrder = DbOrder.listByVendor(start, recordToGet, whereClause, orderClause);
                } else {
                    listOrder = DbOrder.list(start, recordToGet, whereClause, orderClause);
                }




            }

            session.putValue("DETAIL", whereClause);
            session.putValue("KONSTAN", srcVendorId);

            if (iJSPCommand == JSPCommand.SEARCH) {
                if (srcVendorId != 0) {
                    listOrder = DbOrder.listByVendor(start, recordToGet, whereClause, orderClause);
                } else {
                    listOrder = DbOrder.list(start, recordToGet, whereClause, orderClause);
                }

            }
            Transfer tr = new Transfer();

            if (iJSPCommand == JSPCommand.SAVE) {

                if (srcVendorId != 0) {
                    listOrder = DbOrder.listByVendor(start, recordToGet, whereClause, orderClause);
                } else {
                    listOrder = DbOrder.list(start, recordToGet, whereClause, orderClause);
                }


                Vector temp = new Vector();
                if (listOrder != null && listOrder.size() > 0) {
                    for (int i = 0; i < listOrder.size(); i++) {
                        Order ti = (Order) listOrder.get(i);
                        int xxx = JSPRequestValue.requestInt(request, "item_" + ti.getOID());
                        double yy = JSPRequestValue.requestInt(request, "qty_" + ti.getOID());

                        if (xxx == 1) {
                            if (yy > 0) {

                                ti.setQtyProces(yy);
                                temp.add(ti);
                            }

                        }
                    }

                }


                //create transfer
                if (temp.size() > 0) {

                    Location locOrder = new Location();

                    Order od = (Order) temp.get(0);//hanya untk mengetahui lokasi id nya

                    try {
                        locOrder = DbLocation.fetchExc(od.getLocationId());
                    } catch (Exception ex) {

                    }

                    int ctr = DbTransfer.getNextCounter(locOrder.getLocationIdRequest());
                    tr.setFromLocationId(locOrder.getLocationIdRequest());
                    tr.setToLocationId(locOrder.getOID());
                    tr.setCounter(ctr);
                    tr.setPrefixNumber(DbTransfer.getNumberPrefix(locOrder.getLocationIdRequest()));
                    tr.setNumber(DbTransfer.getNextNumber(ctr, locOrder.getLocationIdRequest()));
                    tr.setDate(new Date());
                    tr.setStatus("DRAFT");
                    tr.setUserId(user.getOID());

                    oidTransfer = DbTransfer.insertExc(tr);
                    if (tr.getUserId() == 0) {
                        tr.setUserId(user.getOID());
                        DbTransfer.updateExc(tr);
                    }
                    for (int i = 0; i < temp.size(); i++) {
                        Order odr = (Order) temp.get(i);
                        Order oder = new Order();
                        ItemMaster im = new ItemMaster();
                        try {
                            im = DbItemMaster.fetchExc(odr.getItemMasterId());
                        } catch (Exception ex) {

                        }

                        TransferItem transferItem = new TransferItem();
                        transferItem.setItemBarcode(im.getBarcode());
                        transferItem.setItemMasterId(im.getOID());
                        transferItem.setAmount(im.getCogs());
                        transferItem.setPrice(im.getCogs());
                        transferItem.setQty(odr.getQtyProces());
                        transferItem.setTransferId(oidTransfer);
                        transferItem.setType(DbTransferItem.TYPE_NON_CONSIGMENT);
                        transferItem.setQtyStock(DbStock.getItemTotalStock(tr.getFromLocationId(), im.getOID()));

                        long transferItemId = DbTransferItem.insertExc(transferItem);

                        DbStock.insertTransferGoods(tr, transferItem);
                        try {
                            oder = DbOrder.fetchExc(odr.getOID());
                        } catch (Exception ex) {

                        }
                        oder.setStatus("APPROVED");
                        oder.setTransferId(tr.getOID());
                        oder.setTransferItemId(transferItemId);
                        oder.setDate_proces(tr.getDate());
                        DbOrder.updateExc(oder);///update status

                        if ((oder.getQtyStandar() - (oder.getQtyStock() + oder.getQtyProces())) >= im.getDeliveryUnit()) {
                            DbOrder.checkRequestTransfer(oder.getItemMasterId(), oder.getLocationId());
                            DbOrder.checkRequestTransfer(oder.getItemMasterId(), tr.getFromLocationId());
                        }
                    }
                    transferok = true;
                }
            }            
            Vector vloc = userLocations;

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        
        <script language="JavaScript">
            
            
            function cmdPrintXLS(){	 
                
                window.open("<%=printroot%>.report.RptPrintOrderXLS?idx=<%=System.currentTimeMillis()%>");
                } 
                
                
                function calculateSubTotal(oidOrder){
                    <%if (listOrder.size() > 0) {%>
                    <%for (int i = 0; i < listOrder.size(); i++) {%>
                    <%Order im = (Order) listOrder.get(i);%>
                    if(oidOrder==<%=im.getOID()%>){
                        var qty = document.frmorder.qty_<%=im.getOID()%>.value;
                        var stockQty =document.frmorder.stock_<%=im.getOID()%>.value;
                        
                        document.frmorder.qty_<%=im.getOID()%>.value = qty;
                        
                        if(parseInt(qty)>parseInt(stockQty)){
                            alert("The qty trans is more than stock qty!");
                            qty="0";
                            document.frmorder.qty_<%=im.getOID()%>.value = qty;
                        }
                        
                        
                        
                        
                    }    
                    <%}%>
                    
                    <%}%>    
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                function cmdSearch(){
                    //document.frmitemmaster.hidden_item_master_id.value="0";
                    document.frmorder.command.value="<%=JSPCommand.SEARCH%>";
                    document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                    document.frmorder.action="transferanalist.jsp";
                    document.frmorder.submit();
                }
                function setCheckedCat(val){
                 <%
            for (int k = 0; k < vCategory.size(); k++) {
                ItemGroup ic = (ItemGroup) vCategory.get(k);
                %>
                    document.frmorder.grp<%=ic.getOID()%>.checked=val.checked;
                    
                    <%}%>
                }
                function setCheckedSubCat(val){
                 <%
            for (int k = 0; k < vSubCategory.size(); k++) {
                ItemCategory ic = (ItemCategory) vSubCategory.get(k);
                %>
                    document.frmorder.cat<%=ic.getOID()%>.checked=val.checked;
                    
                    <%}%>
                }                
                
                function cmdCheckOrder(){
                    if(confirm('Pastikan parameter sudah benar')){
                        //document.frmitemmaster.hidden_item_master_id.value="0";
                        document.frmorder.command.value="<%=JSPCommand.GET%>";
                        document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                        document.frmorder.action="transferanalist.jsp";
                        document.frmorder.submit();
                    }else{
                    
                }
                
                
                
            }
            
            function cmdReloadGroup(){
                document.frmorder.command.value="<%=JSPCommand.NONE%>";
                document.frmorder.action="transferanalist.jsp";
                document.frmorder.submit();
            }   
            
            function cmdAsk(oidItemMaster){
                document.frmorder.hidden_item_master_id.value=oidItemMaster;
                document.frmorder.command.value="<%=JSPCommand.ASK%>";
                document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                document.frmorder.action="itemlist.jsp";
                document.frmorder.submit();
            }
            
            
            function cmdSave(){
                document.frmorder.command.value="<%=JSPCommand.SAVE%>";
                document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                document.frmorder.action="transferanalist.jsp";
                document.frmorder.submit();
            }
            
            function cmdTransfer(oidTransfer){
                
                document.frmorder.hidden_transfer_id.value=oidTransfer;
                document.frmorder.command.value="<%=JSPCommand.EDIT%>";
                document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                document.frmorder.action="transferitem.jsp";
                document.frmorder.submit();
            }
            
            function cmdCancel(oidItemMaster){
                document.frmorder.hidden_item_master_id.value=oidItemMaster;
                document.frmorder.command.value="<%=JSPCommand.EDIT%>";
                document.frmorder.prev_command.value="<%=prevJSPCommand%>";
                document.frmorder.action="itemlist.jsp";
                document.frmorder.submit();
            }
            
            function cmdBack(){
                document.frmorder.command.value="<%=JSPCommand.BACK%>";
                document.frmorder.action="itemmaster.jsp";
                document.frmorder.submit();
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
            
        </script>
        
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
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
                                                        <form name="frmorder" method ="post" action="">
                                                        <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                        <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                        <input type="hidden" name="start" value="<%=start%>">
                                                        <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                        <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                        <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                        <input type="hidden" name="hidden_transfer_id" value="<%=oidTransfer%>">
                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                            <tr> 
                                                                <td class="container" valign="top"> 
                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                        <tr> 
                                                                            <td> 
                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                    <tr valign="bottom"> 
                                                                                        <td width="60%" height="23"><b><font color="#990000" class="lvl1">Stock Management 
                                                                                                </font><font class="tit1">&raquo; 
                                                                                                </font><font class="tit1"><span class="lvl2">Transfer Analisis
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
                                                                            <td class="page"> 
                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="8"  colspan="3"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr align="left" valign="top"> 
                                                                                                    <td height="8" valign="middle" colspan="3"> 
                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                        <tr> 
                                                                                                            <td width="5%">&nbsp;</td>
                                                                                                            <td width="11%">&nbsp;</td>
                                                                                                            <td width="6%">&nbsp;</td>
                                                                                                            <td width="14%">&nbsp;</td>
                                                                                                            <td width="6%">&nbsp;</td>
                                                                                                            <td width="15%">&nbsp;</td>
                                                                                                            <td width="42%">&nbsp;</td>
                                                                                                        </tr>
                                                                                                        <tr> 
                                                                                                            <td colspan="7" nowrap><b><u>Search 
                                                                                                            Option</u></b></td>
                                                                                                        </tr>
                                                                                                        <tr> 
                                                                                                            <td width="5%">&nbsp;</td>
                                                                                                            <td width="11%">&nbsp;</td>
                                                                                                            <td width="6%">&nbsp;</td>
                                                                                                            <td width="14%">&nbsp;</td>
                                                                                                            <td width="6%">&nbsp;</td>
                                                                                                            <td width="15%">&nbsp;</td>
                                                                                                            <td width="42%">&nbsp;</td>
                                                                                                        </tr>
                                                                                                        
                                                                                                        <tr height="24"> 
                                                                                                            <td class="tablearialcell1" valign="top">Category</td>
                                                                                                            
                                                                                                            <td colspan="6" >                                                                                                                                                             
                                                                                                                <%
            if (vCategory != null && vCategory.size() > 0) {
                                                                                                                %>
                                                                                                                <table width="800" border="0" cellpadding="0" cellspacing="0">
                                                                                                                    <%
                                                                                                                    int x = 0;
                                                                                                                    boolean ok = true;
                                                                                                                    while (ok) {

                                                                                                                        for (int t = 0; t < 5; t++) {
                                                                                                                            ItemGroup ic = new ItemGroup();
                                                                                                                            try {
                                                                                                                                ic = (ItemGroup) vCategory.get(x);
                                                                                                                            } catch (Exception e) {
                                                                                                                                ok = false;
                                                                                                                                ic = new ItemGroup();
                                                                                                                                break;
                                                                                                                            }
                                                                                                                            int o = JSPRequestValue.requestInt(request, "grp" + ic.getOID());
                                                                                                                            if (t == 0) {
                                                                                                                    %>
                                                                                                                    <tr>
                                                                                                                        <%}%>
                                                                                                                        <td width="8"><input type="checkbox" onchange="javascript:cmdReloadGroup()" name="grp<%=ic.getOID()%>" value="1" <%if (o == 1) {%> checked<%}%> ></td>
                                                                                                                        <td class="fontarial"><%=ic.getName()%></td>                                                                                                                                                                    
                                                                                                                        <%if (t == 4) {
                                                                                                                        %>
                                                                                                                    </tr>
                                                                                                                    <%}%>
                                                                                                                    <%
                                                                                                                            x++;
                                                                                                                        }
                                                                                                                    }%>
                                                                                                                    <tr>
                                                                                                                        <td><input type="checkbox" onchange="javascript:cmdReloadGroup()" name="all" value="1" <%if (all == 1) {%> checked <%}%>   onClick="setCheckedCat(this)"></td>
                                                                                                                        <td class="fontarial">ALL CATEGORY</td>
                                                                                                                    </tr>   
                                                                                                                </table>
                                                                                                                <%}%>                                                                                                                                                       
                                                                                                            </td>                                                                                                                                                       
                                                                                                        </tr> 
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                        <tr height="24"> 
                                                                                                            <td class="tablearialcell1" valign="top">Sub Category</td>
                                                                                                            
                                                                                                            <td colspan="6" >                                                                                                                                                             
                                                                                                                <%
            if (vSubCategory != null && vSubCategory.size() > 0) {
                                                                                                                %>
                                                                                                                <table width="800" border="0" cellpadding="0" cellspacing="0">
                                                                                                                    <%
                                                                                                                    int x = 0;
                                                                                                                    boolean ok = true;
                                                                                                                    while (ok) {

                                                                                                                        for (int t = 0; t < 5; t++) {
                                                                                                                            ItemCategory ic = new ItemCategory();
                                                                                                                            try {
                                                                                                                                ic = (ItemCategory) vSubCategory.get(x);
                                                                                                                            } catch (Exception e) {
                                                                                                                                ok = false;
                                                                                                                                ic = new ItemCategory();
                                                                                                                                break;
                                                                                                                            }
                                                                                                                            int o = JSPRequestValue.requestInt(request, "cat" + ic.getOID());
                                                                                                                            if (t == 0) {
                                                                                                                    %>
                                                                                                                    <tr>
                                                                                                                        <%}%>
                                                                                                                        <td width="5"><input type="checkbox" name="cat<%=ic.getOID()%>" value="1" <%if (o == 1) {%> checked<%}%> ></td>
                                                                                                                        <td class="fontarial"><%=ic.getName()%></td>                                                                                                                                                                    
                                                                                                                        <%if (t == 4) {
                                                                                                                        %>
                                                                                                                    </tr>
                                                                                                                    <%}%>
                                                                                                                    <%
                                                                                                                            x++;
                                                                                                                        }
                                                                                                                    }%>
                                                                                                                    <tr>
                                                                                                                        <td><input type="checkbox" name="all_cat" value="1" <%if (allcat == 1) {%> checked <%}%>   onClick="setCheckedSubCat(this)"></td>
                                                                                                                        <td class="fontarial">ALL SUB CATEGORY</td>
                                                                                                                    </tr>   
                                                                                                                </table>
                                                                                                                <%}%>                                                                                                                                                       
                                                                                                            </td>                                                                                                                                                       
                                                                                                        </tr> 
                                                                                                        
                                                                                                        
                                                                                                        <tr> 
                                                                                                        <td width="6%">SKU</td>
                                                                                                        <td width="14%"> 
                                                                                                            <input type="text" name="src_code" size="15" value="<%=srcCode%>" onchange="javascript:cmdSearch()">
                                                                                                        </td>
                                                                                                        
                                                                                                        <td width="6%">Name</td>
                                                                                                        <td width="14%"> 
                                                                                                            <input type="text" name="src_name" size="15" value="<%=srcName%>" onchange="javascript:cmdSearch()">
                                                                                                        </td>
                                                                                                        <td width="6%">From Location</td>
                                                                                                        <td width="15%">
                                                                                                            
                                                                                                            <select name="src_location_id">
                                                                                                                
                                                                                                                <%

            

            if (vloc != null && vloc.size() > 0) {
                for (int i = 0; i < vloc.size(); i++) {
                    Location loc = (Location) vloc.get(i);

                                                                                                                %>
                                                                                                                <option value="<%=loc.getOID()%>" <%if (srcLocationId == loc.getOID()) {%>selected<%}%>><%=loc.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>  
                                                                                                    </td>
                                                                                                    <td width="42%">&nbsp;</td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    
                                                                                                    <td width="5%">Vendor</td>
                                                                                                    <td width="11%">
                                                                                                        <select name="src_vendor_id">
                                                                                                            <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>>- 
                                                                                                                    All -</option>
                                                                                                            <%

            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor d = (Vendor) vendors.get(i);

                                                                                                            %>
                                                                                                            <option value="<%=d.getOID()%>" <%if (srcVendorId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                            <%}
            }%>
                                                                                                        </select>
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                        
                                                                                                    </td>
                                                                                                    <td width="6%">Barcode</td>
                                                                                                    <td width="15%">
                                                                                                        <input type="text" name="src_barcode" size="15" value="<%=srcBarCode%>" onchange="javascript:cmdSearch()">
                                                                                                    </td>
                                                                                                    
                                                                                                    <td width="6%">To Location</td>
                                                                                                    <td width="15%">
                                                                                                        
                                                                                                        <select name="src_to_location_id">
                                                                                                            
                                                                                                            <%

            Vector vloc2 = DbLocation.list(0, 0, "type='Warehouse'", "name");

            if (vloc2 != null && vloc2.size() > 0) {
                for (int i = 0; i < vloc2.size(); i++) {
                    Location loc = (Location) vloc2.get(i);

                                                                                                            %>
                                                                                                            <option value="<%=loc.getOID()%>" <%if (srcToLocationId == loc.getOID()) {%>selected<%}%>><%=loc.getName()%></option>
                                                                                                            <%}
            }%>
                                                                                                        </select>
                                                                                                    </td>  
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td width="5%"></td>
                                                                                                    <td width="11%">
                                                                                                    </td>
                                                                                                    <td width="6%"></td>
                                                                                                    <td width="15%">
                                                                                                        
                                                                                                    </td>
                                                                                                    <td width="6%">Stock DC</td>
                                                                                                    <td width="14%"><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>
                                                                                                    
                                                                                                    
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td width="14%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                                                                </tr>    
                                                                                                <tr> 
                                                                                                    <td colspan="7" background="../images/line1.gif"><img src="../images/line1.gif" width="47" height="3"></td>
                                                                                                </tr>
                                                                                                <tr> 
                                                                                                    <td colspan="7">&nbsp;</td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                    </tr>
                                                                                    <%
            try {
                if (listOrder.size() > 0 && iJSPCommand == JSPCommand.SEARCH) {
                                                                                    %>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                            <%
                                                                                                Vector x = drawList(listOrder, srcIgnore, srcLocationId, srcToLocationId);
                                                                                                String strString = (String) x.get(0);
                                                                                                Vector rptObj = (Vector) x.get(1);


                                                                                            %>
                                                                                            
                                                                                        <%=strString%> </td>
                                                                                        <% session.putValue("DETAIL", rptObj);%>
                                                                                    </tr>
                                                                                    <%  } else if (iJSPCommand == JSPCommand.SEARCH) {%>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                        <h3>BELUM ADA ORDER, STOCK MASIH TERCUKUPI</h3>
                                                                                    </tr>                
                                                                                    <%}
            } catch (Exception exc) {
            }%>
                                                                                    
                                                                                    <%
            try {
                if (listOrder.size() > 0 && iJSPCommand == JSPCommand.GET) {
                                                                                    %>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                            <%
                                                                                                Vector x = drawList(listOrder, srcIgnore, srcLocationId, srcToLocationId);
                                                                                                String strString = (String) x.get(0);
                                                                                                Vector rptObj = (Vector) x.get(1);


                                                                                            %>
                                                                                            
                                                                                        <%=strString%> </td>
                                                                                        <% session.putValue("DETAIL", rptObj);%>
                                                                                    </tr>
                                                                                    <%  } else if (iJSPCommand == JSPCommand.GET) {%>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                        <h3>BELUM ADA ORDER, STOCK MASIH TERCUKUPI</h3>
                                                                                    </tr>                
                                                                                    <%}
            } catch (Exception exc) {
            }%>     
                                                                                
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="8" align="left" colspan="3" class="command"> 
                                                                                            <span class="command"> 
                                                                                                <%
            int cmd = 0;
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                cmd = iJSPCommand;
            } else {
                if (iJSPCommand == JSPCommand.NONE || prevJSPCommand == JSPCommand.NONE) {
                    cmd = JSPCommand.FIRST;
                } else {
                    cmd = prevJSPCommand;
                }
            }
                                                                                                %>
                                                                                                <% jspLine.setLocationImg(approot + "/images/ctr_line");
            jspLine.initDefault();
            jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                %>
                                                                                        <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                    </tr>
                                                                                    <tr align="left" valign="top"> 
                                                                                        <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                    </tr>
                                                                                    
                                                                                    
                                                                                </table>
                                                                            </td>
                                                                        </tr>
                                                                        <%if (iJSPCommand == JSPCommand.SAVE && transferok) {%>
                                                                        <script language="JavaScript">
                                                                            cmdTransfer('<%=oidTransfer%>')
                                                                        </script>
                                                                        <%} else if (iJSPCommand == JSPCommand.SAVE) {%>
                                                                        
                                                                        <tr><td bgcolor="yellow">Doc Transfer gagal dibuat</td></tr>
                                                                        <%}%>
                                                                        <%if (listOrder.size() > 0) {%>
                                                                        <tr> 
                                                                            <td>
                                                                                <table>
                                                                                    <tr>
                                                                                        <td>
                                                                                            <%
    boolean isAllowed = false;
    if (srcToLocationId != 0 && userLocations != null && userLocations.size() > 0) {
        for (int x = 0; x < userLocations.size(); x++) {
            Location loc = (Location) userLocations.get(x);
            if (loc.getOID() == srcToLocationId) {
                isAllowed = true;
                break;
            }
        }
    }

    if (isAllowed) {
                                                                                            %>                                                            
                                                                                            <a href="javascript:cmdSave()">Create Transfer</a>
                                                                                            <%} else {%>
                                                                                            <font color="red">No priviledge to create transfer doc.</font>
                                                                                        <%}%>                                                        </td>
                                                                                        <td>
                                                                                            &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                                                            
                                                                                            
                                                                                        </td>
                                                                                        <td>
                                                                                            <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                        </td>
                                                                                        
                                                                                    </tr>    
                                                                                </table>
                                                                                
                                                                            </td>
                                                                        </tr>
                                                                        <%}%> 
                                                                        <tr><td></td></tr>
                                                                        <tr>
                                                                            <td><div align="right" ><a href="javascript:cmdCheckOrder()">Check Order</a></div></td>
                                                                        </tr>
                                                                        <tr align="left" valign="top"> 
                                                                            <td height="8" valign="middle" colspan="3">&nbsp;</td>
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
        
        
        
    </body>
<!-- #EndTemplate --></html>
