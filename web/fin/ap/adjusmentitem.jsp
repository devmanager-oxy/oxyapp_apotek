
<%-- 
    Document   : adjusmentitem
    Created on : Apr 5, 2012, 12:50:19 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.adjusment.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.general.*" %>
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
    public Vector drawList(int iJSPCommand, JspAdjusmentItem frmObject,
            AdjusmentItem objEntity, Vector objectClass,
            long adjusmentItemId, String approot, long oidFromLocationId,
            int iErrCode2, String status, String langAR[]) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("" + langAR[5], "25%");
        jsplist.addHeader("" + langAR[6], "10%");
        jsplist.addHeader("" + langAR[7], "10%");
        jsplist.addHeader("" + langAR[8], "10%");
        jsplist.addHeader("" + langAR[9], "10%");
        jsplist.addHeader("" + langAR[10], "15%");
        jsplist.addHeader("" + langAR[11], "15%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;
        String whereCls = "";
        String orderCls = "";

        /* selected ItemGroupId*/
        Vector vectVendMaster = DbStock.getStock(oidFromLocationId);

        Vector vect_value = new Vector(1, 1);
        Vector vect_key = new Vector(1, 1);
        if (vectVendMaster != null && vectVendMaster.size() > 0) {
            for (int i = 0; i < vectVendMaster.size(); i++) {
                Stock stock = (Stock) vectVendMaster.get(i);
                ItemGroup ig = new ItemGroup();
                try {
                    ItemMaster im = new ItemMaster();
                    im = DbItemMaster.fetchExc(stock.getItemMasterId());
                    ig = DbItemGroup.fetchExc(im.getItemGroupId());
                    vect_key.add(ig.getName() + " / " + stock.getItemCode() + " - " + stock.getItemName());
                    vect_value.add("" + stock.getItemMasterId());
                } catch (Exception e) {
                }
            }
        }

        Vector temp = new Vector();

        /* selected ItemGroupId*/
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

        for (int i = 0; i < objectClass.size(); i++) {
            AdjusmentItem adjusmentItem = (AdjusmentItem) objectClass.get(i);
            RptAdjustmentL detail = new RptAdjustmentL();

            ItemMaster im = new ItemMaster();
            try {
                im = DbItemMaster.fetchExc(adjusmentItem.getItemMasterId());
            } catch (Exception e) {
            }

            rowx = new Vector();
            if (adjusmentItemId == adjusmentItem.getOID()) {
                index = i;
            }


            ItemMaster itemMaster = new ItemMaster();
            ItemGroup ig = new ItemGroup();
            ItemCategory ic = new ItemCategory();
            try {
                itemMaster = DbItemMaster.fetchExc(adjusmentItem.getItemMasterId());
                ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
            if (status != null && status.equals(I_Project.DOC_STATUS_DRAFT)) {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(adjusmentItem.getOID()) + "')\">" + ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName() + "</a>");
                detail.setName(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
            } else {
                rowx.add(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
                detail.setName(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
            }
            rowx.add("<div align=\"center\">" + adjusmentItem.getQtySystem() + "</div>");
            detail.setQtySystem(adjusmentItem.getQtySystem());
            rowx.add("<div align=\"center\">" + adjusmentItem.getQtyReal() + "</div>");
            detail.setQtyReal(adjusmentItem.getQtyReal());
            rowx.add("<div align=\"center\">" + adjusmentItem.getQtyBalance() + "</div>");

            Uom uom = new Uom();
            try {
                uom = DbUom.fetchExc(itemMaster.getUomStockId());
            } catch (Exception e) {
            }
            rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(adjusmentItem.getPrice(), "#,###.##") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(adjusmentItem.getAmount(), "#,###.##") + "</div>");

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
            long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");
            long periodId = JSPRequestValue.requestLong(request, "period");

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidAdjusment = 0;
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdAdjusment cmdAdjusment = new CmdAdjusment(request);
            JSPLine ctrLine = new JSPLine();
            iErrCode = cmdAdjusment.action(iJSPCommand, oidAdjusment);
            JspAdjusment jspAdjusment = cmdAdjusment.getForm();
            Adjusment adjusment = cmdAdjusment.getAdjusment();
            msgString = cmdAdjusment.getMessage();

            RptAdjustment rptKonstan = new RptAdjustment();

            if (oidAdjusment == 0) {
                oidAdjusment = adjusment.getOID();
                adjusment.setStatus(I_Project.DOC_STATUS_DRAFT);
            }

            whereClause = DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ID] + "=" + oidAdjusment;
            orderClause = DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ITEM_ID];
            Vector purchReqItems = DbAdjusmentItem.list(0, 0, whereClause, orderClause);
%>	
<%
            long oidAdjusmentItem = JSPRequestValue.requestLong(request, "hidden_adjusment_item_id");
            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            CmdAdjusmentItem cmdAdjusmentItem = new CmdAdjusmentItem(request);

            iErrCode2 = cmdAdjusmentItem.action(iJSPCommand, oidAdjusmentItem, oidAdjusment);
            JspAdjusmentItem jspAdjusmentItem = cmdAdjusmentItem.getForm();
            AdjusmentItem adjusmentItem = cmdAdjusmentItem.getAdjusmentItem();
            msgString2 = cmdAdjusmentItem.getMessage();

            whereClause = DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ID] + "=" + oidAdjusment;
            orderClause = DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ITEM_ID];
            Vector purchItems = DbAdjusmentItem.list(0, 0, whereClause, orderClause);
            Vector vendors = new Vector();

            Vector locations = DbLocation.list(0, 0, "", "code");
            if (adjusment.getLocationId() == 0 && locations != null && locations.size() > 0) {
                Location lxx = (Location) locations.get(0);
                adjusment.setLocationId(lxx.getOID());
            }

            Vector stockItems = DbStock.getStock(adjusment.getLocationId());

            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) {
                iJSPCommand = JSPCommand.ADD;
                oidAdjusmentItem = 0;
                adjusmentItem = new AdjusmentItem();
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidAdjusmentItem = 0;
                adjusmentItem = new AdjusmentItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD) {
                try {
                    adjusment = DbAdjusment.fetchExc(oidAdjusment);
                } catch (Exception e) {
                }
            }

            if (iJSPCommand == JSPCommand.ACTIVATE) {
                int x = DbAdjusment.postJournal(adjusment, purchItems, user.getOID(),periodId);
                if (x == 1) {
                    adjusment = DbAdjusment.fetchExc(adjusment.getOID());
                }

            }

            double subTotalReal = DbAdjusmentItem.getTotalQtyAdjusment(oidAdjusment, DbAdjusmentItem.colNames[DbAdjusmentItem.COL_QTY_REAL]);
            double subTotalSystem = DbAdjusmentItem.getTotalQtyAdjusment(oidAdjusment, DbAdjusmentItem.colNames[DbAdjusmentItem.COL_QTY_SYSTEM]);

            String[] langAR = {"Number", "Date", "Location", "Doc. Status", "Notes", "Group/Category/Code - Name", "Qty System", "Qty Real", // 0-7
                "Balance", "Unit", "@ Price", "Total Amount", "Total Adjustment"}; // 8 - 12
            String[] langNav = {"Account Payable", "Post Journal", "Posting", "Detail", "Search Parameters"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor", "Tanggal", "Lokasi", "Status Dok.", "Memo", "Grup/Kategori/Kode - Nama", "Qty Sistem", "Qty Sebenarnya", //0 - 7
                    "Balance", "Satuan", "@ Harga", "Jum. Total", "Tot. Penyesuaian"}; //8-12
                langAR = langID;

                String[] navID = {"Hutang", "Post Jurnal", "Posting", "Detail", "Parameter Pencarian"};
                langNav = navID;
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RptAdjustmentXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdPrintPdf(){                    
                    window.open("<%=printroot%>.report.RptAdjusmentOrderPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                    }
                    
                    function cmdPost(){                
                        document.frmadjusment.command.value="<%=JSPCommand.ACTIVATE%>";
                        document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
                        document.frmadjusment.action="adjusmentitem.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    
                    
                    var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
                    var usrDigitGroup = "<%=sUserDigitGroup%>";
                    var usrDecSymbol = "<%=sUserDecimalSymbol%>";
                    
                    function removeChar(number){
                        
                        var ix;
                        var result = "";
                        for(ix=0; ix<number.length; ix++){
                            var xx = number.charAt(ix);
                            //alert(xx);
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
                    
                    function parserMaster(){
                        var str = document.frmadjusment.<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_ITEM_MASTER_ID]%>.value;
         <%if (stockItems != null && stockItems.size() > 0) {
                for (int i = 0; i < stockItems.size(); i++) {
                    Stock stock = (Stock) stockItems.get(i);
         %>
             if('<%=stock.getItemMasterId()%>'==str){
                 document.frmadjusment.<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_QTY_SYSTEM]%>.value = <%=stock.getQty()%>;
                 document.frmadjusment.unit_code.value="<%=stock.getUnit()%>";
             }
         <%}
            }%>
            calculateSubTotal();
        }
        
        function calculateSubTotal(){
            var price = document.frmadjusment.<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_PRICE]%>.value;
            var qty = document.frmadjusment.<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_QTY_REAL]%>.value;
            
            amount = removeChar(price);
            amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmadjusment.<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);
            
            qty = removeChar(qty);
            qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
            document.frmadjusment.<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_QTY_REAL]%>.value = qty;
            
            var totalItemAmount = (parseFloat(amount) * parseFloat(qty));
            document.frmadjusment.<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
            
            var subtot = document.frmadjusment.sub_tot.value;
            subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
            
         <%
            //add
            if (oidAdjusmentItem == 0) {%>                    
                    <%} else {%>                    
         <%}
         %>
             
             calculateAmount();
         }         
         
         function cmdVatEdit(){
             calculateAmount();
         }
         
         function calculateAmount(){}
         
         function cmdClosedReason(){       
         }
         
         function cmdLocation(){
             <%if (adjusment.getOID() != 0 && purchItems != null && purchItems.size() > 0) {%>
             if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all adjusment item based on vendor item master. ')){
                 document.frmadjusment.command.value="<%=JSPCommand.LOAD%>";
                 document.frmadjusment.action="adjusmentitem.jsp";
                 document.frmadjusment.submit();
             }
             <%} else {%>
             document.frmadjusment.command.value="<%=JSPCommand.LOAD%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
             //cmdVendorChange();
             <%}%>
         }
         
         function cmdToRecord(){
             document.frmadjusment.command.value="<%=JSPCommand.NONE%>";
             document.frmadjusment.action="adjusmentlist.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdVendorChange(){
             var oid = document.frmadjusment.<%=JspAdjusment.colNames[JspAdjusment.JSP_LOCATION_ID]%>.value;
         <%
            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor v = (Vendor) vendors.get(i);
                         %>
                             if('<%=v.getOID()%>'==oid){
                                 document.frmadjusment.vnd_address.value="<%=v.getAddress()%>";
                             }
                         <%
                }
            }
         %>
             
         }
         
         
         function cmdCloseDoc(){
             document.frmadjusment.action="<%=approot%>/home.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdAskDoc(){
             document.frmadjusment.hidden_adjusment_item_id.value="0";
             document.frmadjusment.command.value="<%=JSPCommand.SUBMIT%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdDeleteDoc(){
             document.frmadjusment.hidden_adjusment_item_id.value="0";
             document.frmadjusment.command.value="<%=JSPCommand.CONFIRM%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdCancelDoc(){
             document.frmadjusment.hidden_adjusment_item_id.value="0";
             document.frmadjusment.command.value="<%=JSPCommand.EDIT%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdSaveDoc(){
             document.frmadjusment.command.value="<%=JSPCommand.POST%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdAdd(){
             document.frmadjusment.hidden_adjusment_item_id.value="0";
             document.frmadjusment.command.value="<%=JSPCommand.ADD%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdAsk(oidAdjusmentItem){
             document.frmadjusment.hidden_adjusment_item_id.value=oidAdjusmentItem;
             document.frmadjusment.command.value="<%=JSPCommand.ASK%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdAskMain(oidAdjusment){
             document.frmadjusment.hidden_adjusment_id.value=oidAdjusment;
             document.frmadjusment.command.value="<%=JSPCommand.ASK%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusment.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdConfirmDelete(oidAdjusmentItem){
             document.frmadjusment.hidden_adjusment_item_id.value=oidAdjusmentItem;
             document.frmadjusment.command.value="<%=JSPCommand.DELETE%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         function cmdSaveMain(){
             document.frmadjusment.command.value="<%=JSPCommand.SAVE%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusment.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdSave(){
             document.frmadjusment.command.value="<%=JSPCommand.SAVE%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdEdit(oidAdjusment){
             document.frmadjusment.hidden_adjusment_item_id.value=oidAdjusment;
             document.frmadjusment.command.value="<%=JSPCommand.EDIT%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdCancel(oidAdjusment){
             document.frmadjusment.hidden_adjusment_item_id.value=oidAdjusment;
             document.frmadjusment.command.value="<%=JSPCommand.EDIT%>";
             document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdBack(){
             document.frmadjusment.command.value="<%=JSPCommand.NONE%>";
             document.frmadjusment.action="adjusmentlist.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdListFirst(){
             document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
             document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdListPrev(){
             document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
             document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdListNext(){
             document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
             document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
         }
         
         function cmdListLast(){
             document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
             document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
             document.frmadjusment.action="adjusmentitem.jsp";
             document.frmadjusment.submit();
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
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmadjusment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspAdjusment.colNames[JspAdjusment.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_adjusment_item_id" value="<%=oidAdjusmentItem%>">
                                                            <input type="hidden" name="hidden_adjusment_id" value="<%=oidAdjusment%>">
                                                            <input type="hidden" name="<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_ADJUSMENT_ID]%>" value="<%=oidAdjusment%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">&nbsp;<%=langNav[0]%> 
                                                                                </font><font class="tit1">&raquo; <span class="lvl2"><%=langNav[1]%></span></font></b></td>
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
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink"><%=langNav[2]%></a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<%=langNav[3]%>&nbsp;&nbsp;</div>
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
                                                                                                                    <%if (adjusment.getOID() == 0) {%>
                                                                                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                                                                                    <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(adjusment.getUserId());
    } catch (Exception e) {
    }
                                                                                                                    %>
                                                                                                                    Prepared By : <%=us.getLoginId()%> 
                                                                                                                    <%}%>
                                                                                                            </i>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;<%=langAR[0]%></td>
                                                                                                        <td height="21" width="27%"><span class="comment"> 
                                                                                                                <%
            String number = "";
            if (adjusment.getOID() == 0) {
                int ctr = DbAdjusment.getNextCounter();
                number = DbAdjusment.getNextNumber(ctr);
                rptKonstan.setNumber(number);
            } else {
                number = "" + adjusment.getNumber();
                rptKonstan.setNumber(number);
            }
                                                                                                                %>
                                                                                                        <B><%=number%></B> </span></td>
                                                                                                        <td width="9%"><%=langAR[1]%></td>
                                                                                                        <td colspan="2" class="comment" width="52%"> 
                                                                                                            <B><%=JSPFormater.formatDate(adjusment.getDate(), "dd/MM/yyyy")%></B>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;<%=langAR[2]%></td>
                                                                                                        <td height="21" width="27%"><span class="comment"> 
                                                                                                                <%
            String loc = "";
            try {
                Location locx = DbLocation.fetchExc(adjusment.getLocationId());
                loc = locx.getName();
            } catch (Exception e) {
            }
                                                                                                                %>
                                                                                                                <B><%=loc%></B>
                                                                                                        </span> </td>
                                                                                                        <td width="9%"><%=langAR[3]%></td>
                                                                                                        <td colspan="2" class="comment" width="52%">
                                                                                                            <%
            if (adjusment.getStatus() == null) {
                //out.println("status = null, set to draft");
                adjusment.setStatus(I_Project.DOC_STATUS_DRAFT);
            }
                                                                                                            %>
                                                                                                            <input type="text" class="readOnly" name="stt" value="<%=(adjusment.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((adjusment.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : adjusment.getStatus())%>" size="15" readOnly>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                    <td height="5" colspan="5"></td>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;<%=langAR[4]%></td>
                                                                                                        <td height="21" > 
                                                                                                            <B><%=adjusment.getNote()%></B>
                                                                                                        </td>
                                                                                                        <td height="21" >Periode</td>
                                                                                                        <td height="21" >
                                                                                                            <%
            Vector periods = new Vector();
            Periode preClosedPeriod = new Periode();
            Periode openPeriod = new Periode();

            Vector vPreClosed = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE]);

            openPeriod = DbPeriode.getOpenPeriod();

            if (vPreClosed != null && vPreClosed.size() > 0) {
                for (int i = 0; i < vPreClosed.size(); i++) {
                    Periode prClosed = (Periode) vPreClosed.get(i);
                    if (i == 0) {
                        preClosedPeriod = prClosed;
                    }
                    periods.add(prClosed);
                }
            }

            if (openPeriod.getOID() != 0) {
                periods.add(openPeriod);
            }

                                                                                                                                                            %>   
                                                                                                                                                            <select name="period">
                                                                                                                                                                <%
            if (periods != null && periods.size() > 0) {
                for (int t = 0; t < periods.size(); t++) {
                    Periode objPeriod = (Periode) periods.get(t);
                                                                                                                                                                %>
                                                                                                                                                                <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == periodId) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                                                                <%}%><%}%>
                                                                                                                                                            </select>
                                                                                                            
                                                                                                        </td>
                                                                                                        <td height="21" ></td>
                                                                                                    <%
            rptKonstan.setNotes(adjusment.getNote());
                                                                                                    %>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(iJSPCommand, jspAdjusmentItem, adjusmentItem, purchItems, oidAdjusmentItem, approot, adjusment.getLocationId(), iErrCode2, adjusment.getStatus(), langAR);
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
                                                                                                                    <td colspan="3" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="3" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="45%" valign="middle"> 
                                                                                                                        <%if (adjusment.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>
                                                                                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <%
    if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD ||
            (iJSPCommand == JSPCommand.EDIT && oidAdjusmentItem != 0) ||
            iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                    <%
                                                                                                                                ctrLine = new JSPLine();
                                                                                                                                ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                                ctrLine.initDefault();
                                                                                                                                ctrLine.setTableWidth("80%");
                                                                                                                                String scomDel = "javascript:cmdAsk('" + oidAdjusmentItem + "')";
                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidAdjusmentItem + "')";
                                                                                                                                String scancel = "javascript:cmdBack('" + oidAdjusmentItem + "')";
                                                                                                                                ctrLine.setBackCaption("Back to List");
                                                                                                                                ctrLine.setJSPCommandStyle("buttonlink");
                                                                                                                                ctrLine.setDeleteCaption("Delete");

                                                                                                                                ctrLine.setOnMouseOut("MM_swapImgRestore()");
                                                                                                                                ctrLine.setOnMouseOverSave("MM_swapImage('save_item','','" + approot + "/images/save2.gif',1)");
                                                                                                                                ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save_item\" height=\"22\" border=\"0\">");

                                                                                                                                //ctrLine.setOnMouseOut("MM_swapImgRestore()");
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
                                                                                                                                if ((iJSPCommand == JSPCommand.DELETE) || (iJSPCommand == JSPCommand.SAVE) && (iErrCode == 0)) {
                                                                                                                                    ctrLine.setAddCaption("");
                                                                                                                                    ctrLine.setCancelCaption("");
                                                                                                                                    ctrLine.setBackCaption("");
                                                                                                                                    msgString = "Data is Saved";
                                                                                                                                }

                                                                                                                                if (stockItems == null || stockItems.size() == 0) {
                                                                                                                                    ctrLine.setSaveCaption("");
                                                                                                                                }

                                                                                                                                if (iJSPCommand == JSPCommand.LOAD) {
                                                                                                                                    if (oidAdjusmentItem == 0) {
                                                                                                                                        iJSPCommand = JSPCommand.ADD;
                                                                                                                                    } else {
                                                                                                                                        iJSPCommand = JSPCommand.EDIT;
                                                                                                                                    }
                                                                                                                                }

                                                                                                                                    %>
                                                                                                                                    <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%} else {%>
                                                                                                                            <tr> 
                                                                                                                                <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="55%" colspan="2"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="60%"> 
                                                                                                                                    <div align="right"><b><%=langAR[12]%></b></div>
                                                                                                                                </td>
                                                                                                                                <td width="17%"> 
                                                                                                                                    <input type="hidden" name="sub_tot" value="<%=subTotalReal%>">
                                                                                                                                </td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="total_real" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(DbAdjusmentItem.getTotalAdjustmentAmount(adjusment.getOID()), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%
            rptKonstan.setTotalQtyReal(subTotalReal);
                                                                                                                                    %>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (adjusment.getOID() != 0) {%>
                                                                                                    <%if (adjusment.getPostedStatus() == 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5">
                                                                                                            <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel" height="22" border="0"></a>
                                                                                                            <a href="javascript:cmdPost()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" height="22" border="0" width="92"></a>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5">
                                                                                                            <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','../images/back2.gif',1)"><img src="../images/back.gif" name="cancel" height="22" border="0"></a>                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5">
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5">
                                                                                                            <div align="left" class="msgnextaction"> 
                                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                                                                                    <tr>
                                                                                                                        <td width="20"><img src="../images/success.gif" width="20" height="20"></td>
                                                                                                                        <td width="150">Posted</td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%}%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (adjusment.getOID() != 0) {%>
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
        u = DbUser.fetch(adjusment.getUserId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(adjusment.getDate(), "dd MMMM yy")%></i></div>
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
        u = DbUser.fetch(adjusment.getApproval1());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (adjusment.getApproval1() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(adjusment.getApproval1_date(), "dd MMMM yy")%> 
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
                                                                cmdVendorChange();
                                                         <%
            if (stockItems != null && stockItems.size() > 0) {
                if (iErrCode2 == 0 && (adjusment.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && adjusmentItem.getOID() != 0) || iErrCode != 0))) {%>
                        parserMaster();
                                                         <%}
            }%>
                                                            </script>
                                                            <script language="JavaScript">
                                                                <%if (adjusment.getStatus().equals(I_Project.DOC_STATUS_DRAFT) && (iJSPCommand == JSPCommand.NONE || iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.EDIT && adjusmentItem.getOID() != 0) || iErrCode != 0)) {%>                                                             																	
                                                         <%}
            if (adjusment.getOID() != 0 && !adjusment.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>
                    cmdClosedReason();
                    <%}%>
                                                            </script>
                                                            
                                                            <%

                                                            %>
                                                        </form>
                                                        <%
            session.putValue("KONSTAN", rptKonstan);
                                                        %>
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
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
