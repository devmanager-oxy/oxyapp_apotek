
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
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_RECEIVING_ADJUSMENT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_RECEIVING_ADJUSMENT, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_RECEIVING_ADJUSMENT, AppMenu.PRIV_PRINT);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_RECEIVING_ADJUSMENT, AppMenu.PRIV_ADD);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_RECEIVING_ADJUSMENT, AppMenu.PRIV_UPDATE);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_RECEIVING_ADJUSMENT, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(Vector objectClass) {

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
        jsplist.addHeader("Value", "10%");
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
        Vector temp = new Vector();
        for (int i = 0; i < objectClass.size(); i++) {

            ReceiveItem receiveItem = (ReceiveItem) objectClass.get(i);

            SessIncomingGoodsL igL = new SessIncomingGoodsL();
            rowx = new Vector();

            ItemMaster itemMaster = new ItemMaster();
            ItemGroup ig = new ItemGroup();
            try {
                itemMaster = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
                ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
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

            rowx.add(ig.getName() + " / " + itemMaster.getCode() + " - " + itemMaster.getName());
            igL.setGroup(itemMaster.getName());
            igL.setBarcode(itemMaster.getBarcode());


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
            lstData.add(rowx);
            temp.add(igL);
        }

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        return v;
    }

    public static void proceedStock(Receive receive) {
        try {
            DbStock.delete(DbStock.colNames[DbStock.COL_INCOMING_ID] + "=" + receive.getOID());
        } catch (Exception e) {
            System.out.println(e.toString());
        }

        Vector temp = DbReceiveItem.list(0, 0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + receive.getOID(), "");
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
        }

    }

    public static void insertReceiveGoods(Receive rec, ReceiveItem ri, ItemMaster im) {
        try {

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
            if (session.getValue("TIPE_ADJUSMENT") != null) {
                session.removeValue("TIPE_ADJUSMENT");
            }

            if (session.getValue("REF_ID") != null) {
                session.removeValue("REF_ID");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
            long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");
            String tipeadj = "";
            String refId = "";
            Date dueDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "JSP_DUE_DATE"), "dd/MM/yyyy");
            Date dates = JSPFormater.formatDate(JSPRequestValue.requestString(request, "JSP_DATE"), "dd/MM/yyyy");
            Date expDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "ITM_JSP_EXPIRED_DATE"), "dd/MM/yyyy");
            long vendorId = JSPRequestValue.requestLong(request, "JSP_VENDOR_ID");

            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdReceiveAdjusment cmdReceive = new CmdReceiveAdjusment(request);
            cmdReceive.setDueDate(new Date());
            iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
            Receive receive = cmdReceive.getReceive();

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

%>	
<%
            int iErrCode2 = JSPMessage.NONE;
            SessIncomingGoods ig = new SessIncomingGoods();
            CmdReceiveItem cmdReceiveItem = new CmdReceiveItem(request);
            if (iErrCode == 0) {
                iErrCode2 = cmdReceiveItem.action(iJSPCommand, oidReceiveItem, oidReceive, false, false);
            }

            JspReceiveItem jspReceiveItem = cmdReceiveItem.getForm();
            ReceiveItem receiveItem = cmdReceiveItem.getReceiveItem();
            if (expDate != null) {
                receiveItem.setExpiredDate(expDate);
            }

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
            Vector purchItems = DbReceiveItem.list(0, 0, whereClause, orderClause);
            if ((iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE)) {

                if (iJSPCommand == JSPCommand.SAVE) {
                    if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {
                        iJSPCommand = JSPCommand.POST;
                        iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
                        iJSPCommand = JSPCommand.SAVE;
                    }
                }

                iJSPCommand = JSPCommand.ADD;
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
            }

            double subTotal = DbReceiveItem.getTotalReceiveAmount(oidReceive);

            if (iJSPCommand == JSPCommand.CONFIRM) {
                oidReceive = 0;
            }

            if (vendorId == 0) {
                vendorId = receive.getVendorId();
            }
            Vendor ven = new Vendor();
            if (vendorId != 0 && receive.getStatus() == "DRAFT") {
                try {
                    ven = DbVendor.fetchExc(vendorId);
                    receive.setIncluceTax(ven.getIsPKP());
                } catch (Exception ex) {
                }
            }

//pengecekan stock final
//if(iJSPCommand==JSPCommand.POST && iErrCode == 0 && receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){                            
//        proceedStock(receive);//tambah stock dan update cogs                        
//}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            <%if (!priv && !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RpRectAdjustmenXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdToRecord(){
                    document.frmreceive.command.value="<%=JSPCommand.NONE%>";
                    document.frmreceive.action="recadjlist.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdCancelDoc(){
                    document.frmreceive.hidden_receive_item_id.value="0";
                    document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
                    document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                    document.frmreceive.action="recadjusmentitem.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdSaveDoc(){             
                    document.frmreceive.command.value="<%=JSPCommand.POST%>";
                    document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                    document.frmreceive.action="recadjusmentitem.jsp";
                    document.frmreceive.submit();
                }
                
                
                function cmdCancel(oidReceive){
                    document.frmreceive.hidden_receive_item_id.value=oidReceive;
                    document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
                    document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                    document.frmreceive.action="recadjusmentitem.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdBack(){
                    document.frmreceive.command.value="<%=JSPCommand.BACK%>";
                    document.frmreceive.action="recadjusmentitem.jsp";
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
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_TYPE]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TYPE]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">
                                                            <input type="hidden" name="<%=JspStockCode.colNames[JspStockCode.JSP_TYPE_ITEM]%>" value="<%=DbReceive.TYPE_NON_CONSIGMENT%>">                                                            
                                                            <% if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
                                                            <% }%>
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Incoming Goods 
                                                                                        </font><font class="tit1">&raquo;<span class="lvl2">
                                                                                                Incoming Adjusment
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
                                                                                                Adjusment &nbsp;&nbsp;</div>
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
                                                                                                    <%
            User us = new User();
            try {
                us = DbUser.fetch(receive.getUserId());
            } catch (Exception e) {
            }
                                                                                                    %>                                                                                                    
                                                                                                    <% ig.setUser(us.getLoginId());%>                                                                                                    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" valign="middle" width="12%">&nbsp;</td>                                                                                                        
                                                                                                        <td height="21" valign="middle" width="37%">&nbsp;</td>                                                                                                        
                                                                                                        <td height="21" valign="middle" width="9%">&nbsp;</td>                                                                                                        
                                                                                                        <td height="21" colspan="2" width="42%" class="comment" valign="top"></td>
                                                                                                    </tr>
                                                                                                    <%    Purchase purchase = new Purchase();
            if (receive.getPurchaseId() != 0) {
                ig.setOidGoods(receive.getPurchaseId());
                try {
                    purchase = DbPurchase.fetchExc(receive.getPurchaseId());
                } catch (Exception e) {
                }
                                                                                                    %>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;PO Number</td>
                                                                                                        <td height="20" width="37%"> 
                                                                                                            <input type="text" name="textfield" value="<%=purchase.getNumber()%>" class="readOnly" readOnly>
                                                                                                            <%ig.setPoNumber(purchase.getNumber());%>
                                                                                                        </td>                                                                                                        
                                                                                                        <td height="20" width="9%">&nbsp;</td>                                                                                                        
                                                                                                        <td height="20" colspan="2" width="42%" class="comment">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;PO Date </td>
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
                                                                                                        <td height="5" colspan="4"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" width="12%">&nbsp;&nbsp;Vendor</td>                                                                                                        
                                                                                                        <td height="20" width="37%"> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PURCHASE_ID]%>" value="<%=purchase.getOID()%>">
                                                                                                            <%    Vendor vnd = new Vendor();
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
                                                                                                            
                                                                                                        </td>                                                                                                        
                                                                                                        <td height="20" width="9%">Receive In</td>
                                                                                                        <%
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
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Ref ID </td>
                                                                                                        <%
            Receive rex = new Receive();






            try {
                rex = DbReceive.fetchExc(receive.getReferenceId());
                refId = rex.getNumber();
            } catch (Exception ex) {
            }
                                                                                                        %>
                                                                                                        <td height="21" width="37%"> 
                                                                                                            <input type="text" readonly class="readonly" name="d" value="<%=rex.getNumber()%>">
                                                                                                        </td>
                                                                                                        <td width="9%">Adj Type</td>
                                                                                                        <td colspan="2" class="comment" width="42%"> 
                                                                                                            <input type="hidden" class="readOnly" name="JSP_TYPE_AP" value="<%=receive.getTypeAp()%>" size="15" readOnly>
                                                                                                            <%if (receive.getTypeAp() == DbReceive.TYPE_AP_REC_ADJ_BY_PRICE) {
                tipeadj = "Value";
                                                                                                            %>
                                                                                                            <input type="text" class="readOnly" name="stts" value="Value" size="15" readOnly>
                                                                                                            <%} else {
    tipeadj = "Quantity";
                                                                                                            %>
                                                                                                            <input type="text" class="readOnly" name="stts" value="Quantity" size="15" readOnly>
                                                                                                            <%}%>   
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Inc. Adj Number </td>
                                                                                                        <td height="21" width="37%"> 
                                                                                                            <input type="text" readonly class="readonly" name="<%=JspReceive.colNames[JspReceive.JSP_NUMBER]%>" value="<%=receive.getNumber()%>">
                                                                                                            <%ig.setDocNumber(receive.getNumber());%>
                                                                                                        </td>                                                                                                        
                                                                                                        <td width="9%">Status</td>                                                                                                        
                                                                                                        <td colspan="2" class="comment" width="42%"> 
                                                                                                            <%


            if (DbSystemProperty.getValueByName(
                    "APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {
                if (receive.getStatus() == null || receive.getStatus().length() == 0) {
                    receive.setStatus(I_Project.DOC_STATUS_DRAFT);
                }
            } else {
                receive.setStatus(I_Project.DOC_STATUS_APPROVED);
            }

                                                                                                            %>
                                                                                                            <%if (DbSystemProperty.getValueByName(
                    "APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>
                                                                                                            <input type="text" class="readOnly" name="stt" value="<%=(receive.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((receive.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : receive.getStatus())%>" size="15" readOnly>
                                                                                                            <%} else {%>
                                                                                                            <input type="text" class="readOnly" name="stt" value="<%=I_Project.DOC_STATUS_APPROVED%>" size="15" readOnly>
                                                                                                            <%}%>   
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Date</td>
                                                                                                        <td height="21" width="37%"> 
                                                                                                            <input name="<%=JspReceive.colNames[JspReceive.JSP_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDate() == null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%>" size="11" readonly class="readOnly">
                                                                                                            
                                                                                                            <%ig.setDate(receive.getDate());%>
                                                                                                        </td>                                                                                                        
                                                                                                        <td width="9%">Applay VAT</td>                                                                                                        
                                                                                                        <td colspan="2" class="comment" width="42%"> 
                                                                                                            <b><%=DbReceive.strIncludeTax[receive.getIncluceTax()]%></b> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>" value="<%=receive.getIncluceTax()%>">
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;Payment Type </td>
                                                                                                        <td height="21" width="37%"> 
                                                                                                            <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_PAYMENT_TYPE]%>" value="<%=receive.getPaymentType()%>" readonly class="readOnly">
                                                                                                            <%
            ig.setPaymentType(
                    "" + receive.getPaymentType());
                                                                                                            %>                                                                                                            
                                                                                                        </td>                                                                                                        
                                                                                                        <td width="9%">Term Of Payment</td>                                                                                                        
                                                                                                        <td width="42%" colspan="2" class="comment"> 
                                                                                                            <input name="<%=JspReceive.colNames[JspReceive.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDueDate() == null) ? new Date() : receive.getDueDate(), "dd/MM/yyyy")%>" size="11" readonly class="readOnly">                                                                                                             
                                                                                                            <%ig.setTermOfPayment(receive.getDueDate());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                    <td height="5" colspan="5"></td>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%" valign="top">&nbsp;&nbsp;Notes</td>
                                                                                                        <td height="21" colspan="4"> 
                                                                                                            <textarea name="<%=JspReceive.colNames[JspReceive.JSP_NOTE]%>" cols="40" rows="3"><%=receive.getNote()%></textarea>
                                                                                                            <%ig.setNotes(receive.getNote());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(purchItems);
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
                                                                                                                <tr> 
                                                                                                                    <td width="38%" valign="middle"></td>
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
                                                                                                                                        <input name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=receive.getDiscountPercent()%>" size="5" style="text-align:center" class="readOnly" readonly >
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
                                                                                                                                        <input type="text" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(subTotal + receive.getTotalTax() - receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setGrandTotal(subTotal + receive.getTotalTax() - receive.getDiscountTotal());%>
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
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                    </tr>                                                                                                    
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
                                                                                                                            <%if (!receive.getStatus().equals("CANCELED") && !receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%"><b>Set Status to</b></td>
                                                                                                                                <td width="14%"> 
                                                                                                                                    <select name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>">
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>                                                                                                                                        
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td colspan="3">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                        </table>                                                                                                                        
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr> 
                                                                                                                <tr>
                                                                                                                    <td colspan="2">&nbsp;</td>
                                                                                                                </tr>    
                                                                                                                <tr> 
                                                                                                                    <td colspan="2">
                                                                                                                        <table border="0">
                                                                                                                            <%if ((privAdd || privUpdate) && !receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED) && !receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED) && DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("YES")) {%>                                                                                                                    
                                                                                                                            <td width="150"><div onclick="this.style.visibility='hidden'"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></div></td>                                                                                                                                                                                                                                   
                                                                                                                            <%}%>
                                                                                                                            <%if (privPrint) {%>
                                                                                                                            <td width="97"> 
                                                                                                                                <div align="left"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="close211111" border="0"></a></div>
                                                                                                                            </td>   
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
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
                                                                                                                <%if (receive.getStatus().equals("CANCELED")) {%>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Canceled</i> </td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                        System</i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                                <%=(receive.getApproval3Date() == null) ? "" : JSPFormater.formatDate(receive.getApproval3Date(), "dd MMMM yy")%>                                                                                                                                 
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
                                                            <%
            session.putValue("PURCHASE_TITTLE", ig);
            session.putValue(
                    "TIPE_ADJUSMENT", tipeadj);
            session.putValue(
                    "REF_ID", refId);
                                                            %>
                                                        </form>                                                       
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
<%//pengecekan stock final






            if (iJSPCommand == JSPCommand.POST && iErrCode == 0 && receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {
                int stokTrans = DbReceiveItem.getCount(" receive_id=" + receive.getOID());
                int stock = DbStock.getTotalStockByTransaksi(" incoming_id=" + receive.getOID() + " and location_id=" + receive.getLocationId());
                if (stokTrans != stock) {
                    DbReceiveItem.proceedStock(receive);//tambah stock dan update cogs        
                }
            }
%>
