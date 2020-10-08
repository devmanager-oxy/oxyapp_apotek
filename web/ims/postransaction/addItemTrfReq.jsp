
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %> 
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>   
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %> 
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
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
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevStart = JSPRequestValue.requestInt(request, "prev_start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");

            long srcGroupId = JSPRequestValue.requestLong(request, "src_group");
            long srcCategoryId = JSPRequestValue.requestLong(request, "src_category");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");

            String itemName = JSPRequestValue.requestString(request, "item_name");
            String itemCode = JSPRequestValue.requestString(request, "item_code");
            long locationFromId = JSPRequestValue.requestLong(request, "location_id");
            long locationToId = JSPRequestValue.requestLong(request, "location_to_id");
            long transferId = JSPRequestValue.requestLong(request, "transfer_id");

            if (itemName.length() > 0) {
                srcName = itemName;
            }

            if (itemCode.length() > 0) {
                srcCode = itemCode;
            }

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "for_buy=1";
            String orderClause = "name,code";

            if (srcGroupId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID] + "=" + srcGroupId;
            }

            if (srcCategoryId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_ITEM_CATEGORY_ID] + "=" + srcCategoryId;
            }

            if (srcCode != null && srcCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + "(" + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + srcCode + "%' or " +
                        DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%' or " +
                        DbItemMaster.colNames[DbItemMaster.COL_BARCODE_2] + " like '%" + srcCode + "%' or " +
                        DbItemMaster.colNames[DbItemMaster.COL_BARCODE_3] + " like '%" + srcCode + "%')";
            }

            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName + "%'";
            }

            CmdItemMaster ctrlItemMaster = new CmdItemMaster(request);
            JSPLine jspLine = new JSPLine();
            Vector listItemMaster = new Vector(1, 1);


            /*count list All ItemMaster*/
            int vectSize = DbItemMaster.getCount(whereClause);
            ItemMaster itemMaster = ctrlItemMaster.getItemMaster();


            if (oidItemMaster == 0) {
                oidItemMaster = itemMaster.getOID();
            }

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlItemMaster.actionList(iJSPCommand, start, vectSize, recordToGet);
            }


            /* get record to display */
            listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listItemMaster.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listItemMaster = DbItemMaster.list(start, recordToGet, whereClause, orderClause);
            }

            if (iJSPCommand == JSPCommand.ADD) {
                itemMaster.setForSale(1);
                itemMaster.setForBuy(1);
                itemMaster.setIsActive(1);
                itemMaster.setRecipeItem(1);
            }

//proses penambahan PO
            if (iJSPCommand == JSPCommand.SAVE || iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.LAST || iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.PREV) {

                Vector listItemMasterExc = DbItemMaster.list(prevStart, recordToGet, whereClause, orderClause);

                if (listItemMasterExc != null && listItemMasterExc.size() > 0) {

                    Vector pis = new Vector();
                    TransferRequest transfer = new TransferRequest();
                    try {
                        if (transferId != 0) {
                            transfer = DbTransferRequest.fetchExc(transferId);
                        }
                    } catch (Exception e) {
                    }

                    for (int i = 0; i < listItemMasterExc.size(); i++) {
                        ItemMaster im = (ItemMaster) listItemMasterExc.get(i);
                        double qty = 0;
                        String rex = request.getParameter("order_" + i);
                        if (rex != null && rex.length() > 0) {
                            qty = Double.parseDouble(rex);
                        }



                        if (qty > 0) {
                            TransferRequestItem ti = new TransferRequestItem();
                            Vector tmp = DbTransferRequestItem.list(0, 1, DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ID] + " = " + transfer.getOID() + " and " + DbTransferRequestItem.colNames[DbTransferRequestItem.COL_ITEM_MASTER_ID] + "=" + im.getOID(), null);
                            if (tmp != null && tmp.size() > 0) {
                                try {
                                    ti = (TransferRequestItem) tmp.get(0);
                                } catch (Exception e) {
                                }
                            }
                            ti.setTransferRequestId(transfer.getOID());
                            ti.setQty(qty);
                            ti.setItemMasterId(im.getOID());
                            ti.setItemBarcode(im.getBarcode());

                            if (transferId == 0) {
                                pis.add(ti);
                            } else {
                                try {
                                    //jika po DRAFT boleh dihajar                        
                                    if (transfer.getStatus().equals("DRAFT") || transfer.getStatus().equals("")) {
                                        if (ti.getOID() != 0) {
                                            DbTransferRequestItem.updateExc(ti);
                                        } else {
                                            DbTransferRequestItem.insertExc(ti);
                                        }
                                    }
                                } catch (Exception e) {
                                }

                            }

                        } else {
                            if (transferId != 0) {
                                try {
                                    //jika po DRAFT boleh dihajar                        
                                    if (transfer.getStatus().equals("DRAFT") || transfer.getStatus().equals("")) {
                                        TransferRequestItem pi = new TransferRequestItem();
                                        Vector temp = DbTransferRequestItem.list(0, 0, DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ID] + " = " + transferId + " and item_master_id=" + im.getOID(), "");
                                        if (temp != null && temp.size() > 0) {
                                            pi = (TransferRequestItem) temp.get(0);
                                            try {
                                                DbTransferRequestItem.deleteExc(pi.getOID());
                                            } catch (Exception e) {
                                            }
                                        }
                                    }
                                } catch (Exception e) {
                                }
                            }
                        }

                    }

                    //proses hanya untuk po baru
                    if (pis != null && pis.size() > 0) {

                        TransferRequest p = new TransferRequest();

                        //jika new po
                        if (transferId == 0) {

                            p.setCounter(DbTransferRequest.getNextCounter(locationFromId));
                            p.setNumber(DbTransferRequest.getNextNumber(p.getCounter(), locationFromId));
                            p.setPrefixNumber(DbTransferRequest.getNumberPrefix(locationFromId));
                            p.setFromLocationId(locationFromId);
                            p.setToLocationId(locationToId);
                            p.setNote("");
                            p.setDate(new Date());
                            p.setUserId(user.getOID());
                            p.setStatus("DRAFT");
                            p.setCreateDate(new Date());

                            try {
                                long oid = DbTransferRequest.insertExc(p);

                                if (oid != 0) {
                                    transferId = oid;
                                    for (int i = 0; i < pis.size(); i++) {
                                        TransferRequestItem pi = (TransferRequestItem) pis.get(i);
                                        pi.setTransferRequestId(oid);
                                        try {
                                            DbTransferRequestItem.insertExc(pi);
                                        } catch (Exception e) {
                                        }
                                    }
                                }
                            } catch (Exception e) {
                            }
                        }

                    }
                }
            }

            prevStart = start;

%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            window.focus(); 
            
            <%if (iJSPCommand == JSPCommand.SAVE) {%>
            self.opener.document.frmtransfer.command.value="<%=JSPCommand.ADD%>";  
            self.opener.document.frmtransfer.hidden_transfer_request_id.value="<%=transferId%>";  
            self.opener.document.frmtransfer.submit();                
            self.close();  
            <%}%>
            
            function cmdSave(){
                document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdNextOnEnter(e, i){
                
                if (typeof e == 'undefined' && window.event) { e = window.event; }
                
                if (e.keyCode == 13){
                    <%for (int x = 0; x < 20; x++) {%>
                    if('<%=x%>'==i){
                        document.frmitemmaster.order_<%=x + 1%>.focus(); 
                        document.frmitemmaster.order_<%=x + 1%>.select(); 
                    }
                    <%}%>					              
                } 
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
            
            function cmdCheckQty(i){	
                <%for (int x = 0; x < 20; x++) {%> 
                if('<%=x%>'==i){
                    var qt = document.frmitemmaster.order_<%=x%>.value;
                    qt = removeChar(qt);
                    qt = cleanNumberFloat(qt, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                    document.frmitemmaster.order_<%=x%>.value = qt;
                    var xdun = document.frmitemmaster.dunit_<%=x%>.value;
                    if(parseFloat(xdun)>0){                       
                        var bal = parseInt(qt) % parseInt(xdun);
                        if(bal>0){
                            if((parseFloat(""+bal)/parseFloat(xdun))>=0.5){
                                qt = parseInt(qt) + parseInt((xdun-bal));
                                document.frmitemmaster.order_<%=x%>.value = qt;
                            }
                            else{                                
                                qt = parseInt(qt) - parseFloat(""+bal);
                                document.frmitemmaster.order_<%=x%>.value = qt;
                            }
                        }
                    }    
                }    
                <%}%>
            }
            
            function cmdSearch(){                
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToProduct(){
                document.frmitemmaster.hidden_item_master_id.value="0";
                document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdAdd(){
                document.frmitemmaster.hidden_item_master_id.value="0";
                document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdAsk(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdConfirmDelete(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            function cmdSave(){
                document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdEdit(oidItemMaster){               
                self.opener.document.frmtransfer.itm_JSP_ITEM_MASTER_ID.value=oidItemMaster;  
                self.opener.document.frmtransfer.submit();                
                self.close();  
            }
            
            function cmdCancel(oidItemMaster){
                document.frmitemmaster.hidden_item_master_id.value=oidItemMaster;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdBack(){
                document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListFirst(){
                document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListPrev(){
                document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListNext(){
                document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListLast(){
                document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmitemmaster.action="addItemTrfReq.jsp";
                document.frmitemmaster.submit();
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
    <body onLoad="MM_preloadImages('../images/search2.gif','../images/savedoc2.gif','../images/save2.gif')" >
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmitemmaster" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_start" value="<%=prevStart%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">                                                            
                                                            <input type="hidden" name="transfer_id" value="<%=transferId%>">
                                                            <input type="hidden" name="location_id" value="<%=locationFromId%>">
                                                            <input type="hidden" name="location_to_id" value="<%=locationToId%>">
                                                            <input type="hidden" name="hidden_transfer_request_id" value="<%=0%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container" valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            
                                                                            <tr> 
                                                                                <td class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8"  colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="8" valign="middle" colspan="3"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" nowrap><b><i>Search 
                                                                                                                    Option</i></b></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%">&nbsp;</td>
                                                                                                                    <td width="14%">&nbsp;</td>
                                                                                                                    <td width="8%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="58%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%" class="tablecell1">&nbsp;&nbsp;Group&nbsp;</td>
                                                                                                                    <td width="14%"> 
                                                                                                                        <%
            Vector groupsx = DbItemGroup.list(0, 0, "", "");
                                                                                                                        %>
                                                                                                                        <select name="src_group">
                                                                                                                            <option value="0" <%if (srcGroupId == 0) {%>selected<%}%>>All..</option>
                                                                                                                            <%if (groupsx != null && groupsx.size() > 0) {
                for (int i = 0; i < groupsx.size(); i++) {
                    ItemGroup ig = (ItemGroup) groupsx.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=ig.getOID()%>" <%if (srcGroupId == ig.getOID()) {%>selected<%}%>><%=ig.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="8%" nowrap class="tablecell1"> 
                                                                                                                        <div align="right">&nbsp;SKU/Barcode&nbsp;&nbsp;</div>
                                                                                                                    </td>
                                                                                                                    <td width="15%"> 
                                                                                                                        <input type="text" name="src_code" size="30" value="<%=srcCode%>" onChange="javascript:cmdSearch()">
                                                                                                                    </td>
                                                                                                                    <td width="58%">&nbsp; </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%" nowrap class="tablecell1">&nbsp;&nbsp;Category&nbsp;</td>
                                                                                                                    <td width="14%" nowrap> 
                                                                                                                        <%
            Vector categoryx = DbItemCategory.list(0, 0, "", "");
                                                                                                                        %>
                                                                                                                        <select name="src_category">
                                                                                                                            <option value="0" <%if (srcCategoryId == 0) {%>selected<%}%>>All ..</option>
                                                                                                                            <%if (categoryx != null && categoryx.size() > 0) {
                for (int i = 0; i < categoryx.size(); i++) {
                    ItemCategory ic = (ItemCategory) categoryx.get(i);
                                                                                                                            %>
                                                                                                                            <option value="<%=ic.getOID()%>" <%if (srcCategoryId == ic.getOID()) {%>selected<%}%>><%=ic.getName().toUpperCase()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    &nbsp;&nbsp; </td>
                                                                                                                    <td width="8%" nowrap class="tablecell1"> 
                                                                                                                        <div align="right">&nbsp;Name&nbsp;&nbsp;</div>
                                                                                                                    </td>
                                                                                                                    <td width="15%"> 
                                                                                                                        <input type="text" name="src_name" size="30" onChange="javascript:cmdSearch()" value="<%=srcName%>">
                                                                                                                    </td>
                                                                                                                    <td width="58%">&nbsp; </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search','','../images/search2.gif',1)"><img src="../images/search.gif" name="search"  border="0"></a></td>
                                                                                                                    <td width="14%">&nbsp;</td>
                                                                                                                    <td width="8%">&nbsp;</td>
                                                                                                                    <td width="15%">&nbsp;</td>
                                                                                                                    <td width="58%">&nbsp;</td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td colspan="5">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
            try {
                if (listItemMaster.size() > 0) {
                    
                    Location locFrom = new Location();
                                                                                                                    try {
                                                                                                                        locFrom = DbLocation.fetchExc(locationFromId);
                                                                                                                    } catch (Exception e) {
                                                                                                                    }
                                                                                                                    Location locTo = new Location();
                                                                                                                    try {
                                                                                                                        locTo = DbLocation.fetchExc(locationToId);
                                                                                                                    } catch (Exception e) {
                                                                                                                    }
                                                                                                    %>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                                            
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td class="tablehdr" width="3%">No</td>                                                                                                                    
                                                                                                                    <td class="tablehdr" width="7%">SKU</td>
                                                                                                                    <td class="tablehdr" width="9%">Barcode</td>
                                                                                                                    <td class="tablehdr" >Name</td>                                                                                                                    
                                                                                                                    <td class="tablehdr" width="80">Stock <%=locFrom.getName()%></td>   
                                                                                                                    <td class="tablehdr" width="6%">Unit Stock</td>                                                                                                                    
                                                                                                                    <td class="tablehdr" width="10%">Qty Order</td>
                                                                                                                </tr>
                                                                                                                <%
                                                                                                            if (listItemMaster != null && listItemMaster.size() > 0) {

                                                                                                                for (int i = 0; i < listItemMaster.size(); i++) {

                                                                                                                    ItemMaster im = (ItemMaster) listItemMaster.get(i);                                                                                                                                                                                                                                        
                                                                                                                    TransferRequestItem pi = new TransferRequestItem();
                                                                                                                    Vector temp1 = new Vector();
                                                                                                                    temp1 = DbTransferRequestItem.list(0, 1, DbTransferRequestItem.colNames[DbTransferRequestItem.COL_TRANSFER_REQUEST_ID] + " = " + transferId + " and item_master_id=" + im.getOID(), "");
                                                                                                                    if (temp1 != null && temp1.size() > 0) {
                                                                                                                        pi = (TransferRequestItem) temp1.get(0);
                                                                                                                    }

                                                                                                                    Vector locationsFrom = new Vector();
                                                                                                                    try {
                                                                                                                        Location loc = DbLocation.fetchExc(locationFromId);
                                                                                                                        locationsFrom.add(loc);
                                                                                                                    } catch (Exception e) {
                                                                                                                    }
                                                                                                                    
                                                                                                                    Vector locationsTo = new Vector();
                                                                                                                    try {
                                                                                                                        Location loc = DbLocation.fetchExc(locationToId);
                                                                                                                        locationsTo.add(loc);
                                                                                                                    } catch (Exception e) {
                                                                                                                    }
                                                                                                                    Uom uom = new Uom();
                                                                                                                    
                                                                                                                    if (i % 2 == 0) {
                                                                                                                %>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell" ><%=start + 1 + i%></td>                                                                                                                    
                                                                                                                    <td class="tablecell" nowrap><%=im.getCode()%></td>
                                                                                                                    <td class="tablecell" nowrap><%=im.getBarcode()%></td>
                                                                                                                    <td class="tablecell" nowrap><%=im.getName()%></td>   
                                                                                                                    <td class="tablecell" nowrap><%=getStockByStatus(locFrom.getOID(), im.getOID(), "APPROVED")%></td>   
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <%
                                                                                                                            try {
                                                                                                                                uom = DbUom.fetchExc(im.getUomStockId());
                                                                                                                            } catch (Exception e) {

                                                                                                                            }
                                                                                                                        %>
                                                                                                                        <div align="center"><%=uom.getUnit()%></div>
                                                                                                                    </td>                                                                                                                                                                                                                                                      
                                                                                                                    <td class="tablecell"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="order_<%=i%>" size="5" style="text-align:right" value="<%=(pi.getQty() == 0) ? "" : "" + pi.getQty()%>" onClick="this.select()" onBlur="javascript:cmdCheckQty('<%=i%>')" onkeypress="cmdNextOnEnter(event,'<%=i%>')">
                                                                                                                        </div> 
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%} else {%>
                                                                                                                <tr> 
                                                                                                                    <td class="tablecell1"><%=start + 1 + i%></td>                                                                                                                    
                                                                                                                    <td class="tablecell1" nowrap><%=im.getCode()%></td>
                                                                                                                    <td class="tablecell1" nowrap><%=im.getBarcode()%></td>
                                                                                                                    <td class="tablecell1" nowrap><%=im.getName()%></td> 
                                                                                                                    <td class="tablecell1" nowrap><%=getStockByStatus(locFrom.getOID(), im.getOID(), "APPROVED")%></td>   
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <%

                                                                                                                            try {
                                                                                                                                uom = DbUom.fetchExc(im.getUomStockId());
                                                                                                                            } catch (Exception e) {

                                                                                                                            }
                                                                                                                        %>
                                                                                                                        <div align="center"><%=uom.getUnit()%></div>
                                                                                                                    </td>                                                                                                                                                      
                                                                                                                    <td class="tablecell1"> 
                                                                                                                        <div align="center"> 
                                                                                                                            <input type="text" name="order_<%=i%>" size="5" style="text-align:right" value="<%=(pi.getQty() == 0) ? "" : "" + pi.getQty()%>" onClick="this.select()" onBlur="javascript:cmdCheckQty('<%=i%>')" onkeypress="cmdNextOnEnter(event,'<%=i%>')">
                                                                                                                        </div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%}
                                                                                                                }
                                                                                                            }%>
                                                                                                            </table>                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%  }
            } catch (Exception exc) {
            }%>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="8" align="left" colspan="3" class="command"> 
                                                                                                            <div align="right"><span class="command"> 
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
                                                                                                            <%=jspLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="10" valign="middle" colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%
            if (listItemMaster != null && listItemMaster.size() > 0) {
                if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                                    %>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                                            <div align="right"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/save2.gif',1)"><img src="../images/save.gif" name="save211" height="22" border="0"></a></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%
                }
            }
                                                                                                    %>
                                                                                                </table>
                                                                                            </td>
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
                                                        </form>
                                                        <script language="JavaScript">
                                                            <%if (iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.LAST || iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.PREV) {%>
                                                            document.frmitemmaster.order_0.focus(); 
                                                            document.frmitemmaster.order_0.select(); 
                                                            <%}%> 
                                                        </script>
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
                        
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>


