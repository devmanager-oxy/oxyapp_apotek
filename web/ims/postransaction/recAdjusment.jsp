
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
%>            
<!-- Jsp Block -->
<%!
    public Vector drawList(Vector objectClass) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablearialhdr");
        jsplist.setCellStyle("tablearialcell");
        jsplist.setCellStyle1("tablearialcell1");
        jsplist.setHeaderStyle("tablearialhdr");

        jsplist.addHeader("No", "15");
        jsplist.addHeader("Barcode", "100");
        jsplist.addHeader("Item Name", "");
        jsplist.addHeader("Price", "70");
        jsplist.addHeader("Value Ajustment", "70");
        jsplist.addHeader("Qty", "5%");
        jsplist.addHeader("Qty Ajustment", "70");
        jsplist.addHeader("Discount", "7%");
        jsplist.addHeader("Total", "10%");
        jsplist.addHeader("Unit<BR> (Purchase)", "8%");
        jsplist.addHeader("Unit<BR> (Stock)", "8%");
        jsplist.addHeader("Select", "8%");

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
            try {
                itemMaster = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
            } catch (Exception e) {
            }

            Uom uom = new Uom();
            Uom uomStock = new Uom();
            try {
                uom = DbUom.fetchExc(itemMaster.getUomPurchaseId());
                uomStock = DbUom.fetchExc(itemMaster.getUomStockId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
            rowx.add("<div align=\"left\">&nbsp;" + itemMaster.getBarcode() + "</div>");
            rowx.add("&nbsp;"+itemMaster.getName());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getAmount(), "#,###.##") + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"textbox\" class=\"fontarial\" size=\"5\" name=\"amount_" + receiveItem.getOID() + "\" >" + "</div>");
            igL.setPrice(receiveItem.getAmount());
            rowx.add("<div align=\"center\">" + receiveItem.getQty() + "</div>");
            rowx.add("<div align=\"center\">" + "<input type=\"textbox\" class=\"fontarial\" size=\"5\" name=\"qty_" + receiveItem.getOID() + "\" value=\"\" >" + "</div>");
            igL.setQty(receiveItem.getQty());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getTotalDiscount(), "#,###.##") + "</div>");
            igL.setDiscount(receiveItem.getTotalDiscount());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getTotalAmount(), "#,###.##") + "</div>");
            igL.setTotal(receiveItem.getTotalAmount());
            rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
            igL.setUnit(uom.getUnit());
            rowx.add("<div align=\"center\">" + uomStock.getUnit() + "</div>");
            igL.setUnitStock(uomStock.getUnit());
            rowx.add("<div align=\"center\">" + "<input type=\"checkbox\" size=\"20\" readonly name=\"item_" + receiveItem.getOID() + "\" value=\"1\" >" + "</div>");
            lstData.add(rowx);
        }
        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        return v;
    }
%>
<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
            long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");
            int typeAdj = JSPRequestValue.requestInt(request, "type_adj");
            long vendorId = JSPRequestValue.requestLong(request, "JSP_VENDOR_ID");
            Receive receive = new Receive();
            if (oidReceive != 0) {
                try {
                    receive = DbReceive.fetchExc(oidReceive);
                } catch (Exception ex) {
                }
            }
            String whereClause = "";
            String orderClause = "";
            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
%>	
<%

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
            Vector purchItems = DbReceiveItem.list(0, 0, whereClause, orderClause);
            double subTotal = DbReceiveItem.getTotalReceiveAmount(oidReceive);

            long oidRec = 0;
            if (iJSPCommand == JSPCommand.POST) {
                Vector vv = new Vector();
                double totAmount = 0;
                for (int i = 0; i < purchItems.size(); i++) {
                    ReceiveItem ri = new ReceiveItem();
                    ri = (ReceiveItem) purchItems.get(i);
                    long yy = JSPRequestValue.requestLong(request, "item_" + ri.getOID());
                    double qty = JSPRequestValue.requestDouble(request, "qty_" + ri.getOID());
                    double amount = JSPRequestValue.requestDouble(request, "amount_" + ri.getOID());

                    if (yy == 1) {
                        ReceiveItem r = new ReceiveItem();
                        if (typeAdj == DbReceive.TYPE_AP_REC_ADJ_BY_PRICE) {//price
                            r.setAmount(amount);
                            r.setQty(ri.getQty());
                        } else if (typeAdj == DbReceive.TYPE_AP_REC_ADJ_BY_QTY) {//qty
                            r.setAmount(ri.getAmount());
                            r.setQty(qty);

                        }
                        ItemMaster im = new ItemMaster();
                        try {
                            im = DbItemMaster.fetchExc(ri.getItemMasterId());
                        } catch (Exception ex) {

                        }
                        r.setUomId(im.getUomPurchaseId());
                        r.setItemMasterId(ri.getItemMasterId());
                        r.setTotalAmount(r.getQty() * r.getAmount());
                        totAmount = totAmount + (r.getQty() * r.getAmount());
                        vv.add(r);
                    }
                }
                if (vv.size() > 0) {

                    int counter = 0;
                    Receive rec = new Receive();

                    rec.setLocationId(receive.getLocationId());
                    counter = DbReceive.getNextCounterRecAdj() + 1;
                    rec.setNumber(DbReceive.getNextNumberRecAdj(counter));
                    rec.setCounter(counter);
                    rec.setDate(new Date());
                    rec.setDueDate(new Date());
                    rec.setPrefixNumber(DbReceive.getNumberPrefixRecAdjusment());
                    rec.setStatus("DRAFT");
                    rec.setUserId(user.getOID());
                    rec.setVendorId(receive.getVendorId());
                    rec.setTypeAp(typeAdj);
                    rec.setPaymentType(receive.getPaymentType());
                    rec.setDate(new Date());
                    rec.setIncluceTax(receive.getIncluceTax());
                    rec.setReferenceId(receive.getOID());
                    rec.setTaxPercent(receive.getTaxPercent());
                    double totTax = 0;
                    if (receive.getTotalTax() != 0) {
                        totTax = totAmount / 100 * 10;
                    }
                    rec.setTotalTax(totTax);
                    rec.setTotalAmount(totAmount);
                    try {
                        oidRec = DbReceive.insertExc(rec);
                    } catch (Exception ex) {
                    }

                    if (oidRec != 0) {
                        for (int i = 0; i < vv.size(); i++) {
                            ReceiveItem rii = new ReceiveItem();
                            rii = (ReceiveItem) vv.get(i);
                            rii.setReceiveId(oidRec);
                            try {
                                DbReceiveItem.insertExc(rii);
                            } catch (Exception ex) {
                            }
                        }
                    }
                }
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv && !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdReceive(oidReceive){
                document.frmreceive.hidden_receive_id.value=oidReceive;
                document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
                document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                document.frmreceive.action="recadjusmentitem.jsp";
                document.frmreceive.submit();
            }
            
            function cmdSaveDoc(){            
                document.frmreceive.command.value="<%=JSPCommand.POST%>";
                document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                document.frmreceive.action="recAdjusment.jsp";
                document.frmreceive.submit();
            }
            
            function cmdAdd(){
                document.frmreceive.hidden_receive_item_id.value="0";
                document.frmreceive.command.value="<%=JSPCommand.ADD%>";
                document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                document.frmreceive.action="recAdjusment.jsp";
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
                                                            <% if (DbSystemProperty.getValueByName("APPLY_DOC_APPROVAL").equalsIgnoreCase("NO")) {%>
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" value="<%=I_Project.DOC_STATUS_APPROVED%>">
                                                            <% }%>
                                                            <% if (oidRec != 0) {%>
                                                            <script language="JavaScript">
                                                                cmdReceive('<%=oidRec%>')
                                                            </script>            
                                                            <%}%>  
                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                        
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b>
                                                                                        <font color="#990000" class="lvl1">Incoming Goods 
                                                                                        </font><font class="tit1">&raquo;<span class="lvl2">
                                                                                                Incoming Adjusment
                                                                                        </span></font>
                                                                                </b></td>
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
                                                                    <td valign="top" height="20"></td>
                                                                </tr>    
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left"> 
                                                                                <td height="20" width="12%">&nbsp;&nbsp;Vendor</td>
                                                                                <td height="20" width="37%">
                                                                                    <%
            Vendor vnd = new Vendor();
                                                                                    %>
                                                                                    
                                                                                    
                                                                                    <%
            try {
                vnd = DbVendor.fetchExc(receive.getVendorId());
            } catch (Exception e) {
            }
                                                                                    %>
                                                                                    <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>" value="<%=receive.getVendorId()%>">
                                                                                    <input type="text" name="v_name" value="<%=vnd.getName() + " - " + vnd.getCode()%>" size="45" readonly class="readonly">
                                                                                </td>                                                        
                                                                                <td height="20" width="9%">Receive In</td>
                                                                                <%
            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(receive.getLocationId());
            } catch (Exception ex) {
            }
                                                                                %>
                                                                                <td height="20" colspan="2" width="42%" class="comment"> 
                                                                                    <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>" value="<%=loc.getOID() %>" size="45" readonly class="readonly">
                                                                                    <input type="text" name="_" value="<%=loc.getName() %>" size="45" readonly class="readonly">
                                                                                </td>                                                                                                                
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                                <td height="21" width="12%">&nbsp;&nbsp;Incoming Number </td>
                                                                                <td height="21" width="37%"> 
                                                                                    <input type="text" readonly class="readonly" name="<%=JspReceive.colNames[JspReceive.JSP_INVOICE_NUMBER]%>" value="<%=receive.getNumber()%>">
                                                                                </td>
                                                                                <td width="9%">PO Number</td>                                                        
                                                                                <td colspan="2" class="comment" width="42%"> 
                                                                                    <%
            Purchase pur = new Purchase();
            try {
                pur = DbPurchase.fetchExc(receive.getPurchaseId());
            } catch (Exception ex) {

            }


                                                                                    %>
                                                                                    <%if (!pur.getNumber().equalsIgnoreCase("")) {%>
                                                                                    <input type="text" class="readOnly" name="stt" value="<%=pur.getNumber() %>" size="15" readOnly>
                                                                                    <%} else {%>
                                                                                    <input type="text" class="readOnly" name="stt" value="" size="15" readOnly>
                                                                                    <%}%>   
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                                <td height="21" width="12%">&nbsp;&nbsp;Date</td>                                                        
                                                                                <td height="21" width="37%"> <%=JSPFormater.formatDate(receive.getDate(), "yyyy-MM-dd HH:mm:ss")%> </td>
                                                                                <td width="9%">Applay VAT</td>                                                        
                                                                                <td colspan="2" class="comment" width="42%"> 
                                                                                    <%
            if (receive.getPurchaseId() == 0 && vendorId == 0) {
                Vector include_value = new Vector(1, 1);
                Vector include_key = new Vector(1, 1);
                String sel_include = "" + receive.getIncluceTax();

                include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_NO]);
                include_key.add("" + DbReceive.INCLUDE_TAX_NO);
                include_value.add(DbReceive.strIncludeTax[DbReceive.INCLUDE_TAX_YES]);
                include_key.add("" + DbReceive.INCLUDE_TAX_YES);
                                                                                    %>
                                                                                    <%= JSPCombo.draw(JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX], null, sel_include, include_key, include_value, "onChange=\"javascript:cmdVatEdit()\"", "formElemen") %> 
                                                                                    <%} else {%>
                                                                                    <b><%=DbReceive.strIncludeTax[receive.getIncluceTax()]%></b> 
                                                                                    <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>" value="<%=receive.getIncluceTax()%>">
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left"> 
                                                                                <td height="21" width="12%">&nbsp;&nbsp;Inc. Adj Number</td>                                                        
                                                                                <td height="21" width="37%"> <%= DbReceive.getNextNumberRecAdj(DbReceive.getNextCounterRecAdj())%> </td>                                                        
                                                                                <td width="9%">Type Adj</td>                                                        
                                                                                <td colspan="2" class="comment" width="42%">                                                             
                                                                                    <select name="type_adj">                                                                
                                                                                        <option value=<%=DbReceive.TYPE_AP_REC_ADJ_BY_QTY%> <%if (receive.getTypeAp() == DbReceive.TYPE_AP_REC_ADJ_BY_QTY) {%>selected<%}%>>Quantity</option>
                                                                                        <option value=<%=DbReceive.TYPE_AP_REC_ADJ_BY_PRICE%> <%if (receive.getTypeAp() == DbReceive.TYPE_AP_REC_ADJ_BY_PRICE) {%>selected<%}%>>Value</option>                                                                
                                                                                    </select>                                                            
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td colspan="5" valign="top">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" > 
                                                                                <td colspan="5" valign="top">
                                                                                    <%
            Vector x = drawList(purchItems);
            String strList = (String) x.get(0);
                                                                                    %>
                                                                                    <%=strList%>
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
                                                                                            <td width="38%" valign="middle">&nbsp;</td>
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
                                                                                                            
                                                                                                        </td>
                                                                                                        <td width="23%"> 
                                                                                                            <div align="right"> 
                                                                                                                <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                                                            </div>
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
                                                                                                            
                                                                                                        </td>
                                                                                                        <td width="23%"> 
                                                                                                            <div align="right"> 
                                                                                                                <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(receive.getTotalTax(), "#,###.##")%>" style="text-align:right">
                                                                                                            </div>
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
                                                                                                                <input type="text" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(subTotal + receive.getTotalTax() + receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                                                            </div>
                                                                                                            
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
                                                                            <tr align="left" > 
                                                                                <td colspan="5" valign="top"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <%
            if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0 && (privAdd || privUpdate)) {
                                                                                        %>
                                                                                        <tr> 
                                                                                            <td width="97"> 
                                                                                                <div align="left"><a href="javascript:cmdSaveDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('del2111','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="del2111" height="22" border="0"></a></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>  
                                                                            <tr align="left" > 
                                                                                <td colspan="5" height="35" valign="top"> </td>
                                                                            </tr>    
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>                                                                                  
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
