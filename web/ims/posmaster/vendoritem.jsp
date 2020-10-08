
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_COST_CHANGE);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_COST_CHANGE, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_COST_CHANGE, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_COST_CHANGE, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_COST_CHANGE, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long vendorItemId) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell1");
        jsplist.setCellStyle1("tablecell");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("Vendor Name", "20%");
        jsplist.addHeader("Address", "30%");
        jsplist.addHeader("Real Price", "10%");
        jsplist.addHeader("Price Margin(%)", "10%");
        jsplist.addHeader("Last Price", "10%");
        jsplist.addHeader("Last Discount %", "10%");
        jsplist.addHeader("Last Update", "10%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        jsplist.setLinkPrefix("javascript:cmdEdit('");
        jsplist.setLinkSufix("')");
        jsplist.reset();
        int index = -1;
        int statusVendor = 0;
        for (int i = 0; i < objectClass.size(); i++) {
            VendorItem vendorItem = (VendorItem) objectClass.get(i);
            Vector rowx = new Vector();
            if (vendorItemId == vendorItem.getOID()) {
                index = i;
            }

            Vendor im = new Vendor();
            try {
                im = DbVendor.fetchExc(vendorItem.getVendorId());
                if (im.getIsKonsinyasi() == 1 || im.getIsKomisi() == 1) {
                    statusVendor = 1;
                }
            } catch (Exception e) {
            }

            rowx.add(im.getCode() + " - " + im.getName());
            rowx.add(im.getAddress());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(vendorItem.getRealPrice(), "#,###.##") + "</div>");
            rowx.add("<div align=\"right\">" + vendorItem.getMarginPrice() + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(vendorItem.getLastPrice(), "#,###.##") + "</div>");

            rowx.add("<div align=\"right\">" + vendorItem.getLastDiscount() + "</div>");

            String str_dt_UpdateDate = "";
            try {
                Date dt_UpdateDate = vendorItem.getUpdateDate();
                if (dt_UpdateDate == null) {
                    dt_UpdateDate = new Date();
                }
                str_dt_UpdateDate = JSPFormater.formatDate(dt_UpdateDate, "dd MMMM yyyy");
            } catch (Exception e) {
                str_dt_UpdateDate = "";
            }

            rowx.add("<div align=\"center\">" + str_dt_UpdateDate + "</div>");

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(vendorItem.getOID()) + "','" + statusVendor);
        }

        return jsplist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidVendorItem = JSPRequestValue.requestLong(request, "hidden_vendor_item_id");
            long oidItemMaster = JSPRequestValue.requestLong(request, "hidden_item_master_id");
            int stsTypeVendor = JSPRequestValue.requestInt(request, "status_type_vendor");
            int showAll = JSPRequestValue.requestInt(request, "show_all");
            ItemMaster itemMaster = new ItemMaster();
            try {
                itemMaster = DbItemMaster.fetchExc(oidItemMaster);
            } catch (Exception e) {
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID] + "=" + oidItemMaster;
            String orderClause = "";

            CmdVendorItem ctrlVendorItem = new CmdVendorItem(request);
            ctrlVendorItem.setUserId(user.getOID());
            JSPLine ctrLine = new JSPLine();
            Vector listVendorItem = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlVendorItem.action(iJSPCommand, oidVendorItem);
            /* end switch*/
            JspVendorItem jspVendorItem = ctrlVendorItem.getForm();

            /*count list All VendorItem*/
            int vectSize = DbVendorItem.getCount(whereClause);

            VendorItem vendorItem = ctrlVendorItem.getVendorItem();
            msgString = ctrlVendorItem.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlVendorItem.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listVendorItem = DbVendorItem.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listVendorItem.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listVendorItem = DbVendorItem.list(start, recordToGet, whereClause, orderClause);
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
            
            function cmdUnShowAll(){                
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";                
                document.frmitemmaster.show_all.value=0;
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdShowAll(){                
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";                
                document.frmitemmaster.show_all.value=1;
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToVendor(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToProduct(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmaster.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToRecords(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemlist.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdToMinimumStock(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="stockMinItem.jsp";
                document.frmitemmaster.submit();
            }   
            function cmdToPrice(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.BACK %>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="pricematerial.jsp";
                document.frmitemmaster.submit();
            }          
            function cmdToEditor(){
                
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmaster.jsp";
                document.frmitemmaster.submit();
            }          
            
            function cmdToRecipe(){
                document.frmitemmaster.hidden_item_master_id.value="<%=oidItemMaster%>";
                document.frmitemmaster.command.value="<%=JSPCommand.LIST%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="recipe.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdBackItem(oid){
                document.frmitemmaster.hidden_item_master_id.value=oid;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="itemmaster.jsp";
                document.frmitemmaster.submit();
            }   
            
            function cmdAdd(stsType){		
                document.frmitemmaster.hidden_vendor_item_id.value="0";
                document.frmitemmaster.command.value="<%=JSPCommand.ADD%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.status_type_vendor.value=stsType;                
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdAsk(oidVendorItem){
                document.frmitemmaster.hidden_vendor_item_id.value=oidVendorItem;
                document.frmitemmaster.command.value="<%=JSPCommand.ASK%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdConfirmDelete(oidVendorItem){
                document.frmitemmaster.hidden_vendor_item_id.value=oidVendorItem;
                document.frmitemmaster.command.value="<%=JSPCommand.DELETE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            function cmdSave(){
                document.frmitemmaster.command.value="<%=JSPCommand.SAVE%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdEdit(oidVendorItem,stsType){
                document.frmitemmaster.status_type_vendor.value=stsType;
                document.frmitemmaster.hidden_vendor_item_id.value=oidVendorItem;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdCancel(oidVendorItem){
                document.frmitemmaster.hidden_vendor_item_id.value=oidVendorItem;
                document.frmitemmaster.command.value="<%=JSPCommand.EDIT%>";
                document.frmitemmaster.prev_command.value="<%=prevJSPCommand%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdBack(){
                document.frmitemmaster.command.value="<%=JSPCommand.BACK%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListFirst(){
                document.frmitemmaster.command.value="<%=JSPCommand.FIRST%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListPrev(){
                document.frmitemmaster.command.value="<%=JSPCommand.PREV%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListNext(){
                document.frmitemmaster.command.value="<%=JSPCommand.NEXT%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmitemmaster.action="vendoritem.jsp";
                document.frmitemmaster.submit();
            }
            
            function cmdListLast(){
                document.frmitemmaster.command.value="<%=JSPCommand.LAST%>";
                document.frmitemmaster.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmitemmaster.action="vendoritem.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif')">
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
                                                        <form name="frmitemmaster" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_vendor_item_id" value="<%=oidVendorItem%>">
                                                            <input type="hidden" name="hidden_item_master_id" value="<%=oidItemMaster%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="status_type_vendor" value="<%=stsTypeVendor%>">
                                                            <input type="hidden" name="show_all" value="0">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                        <tr valign="bottom"> 
                                                                                            <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                                    Maintenance </font><font class="tit1">&raquo; 
                                                                                                    </font><font class="tit1"><span class="lvl2">POS 
                                                                                                        </span>&raquo; <span class="lvl2">Vendor
                                                                                            &amp; Item</span></font></b></td>
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
                                                                                <td height="5"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecords()" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToEditor()" class="tablink">Item Data</a>&nbsp;&nbsp;</div>
                                                                                            </td>                                                                                            
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%if (itemMaster.getOID() != 0) {%>
                                                                                            <td class="tabin" nowrap><div align="center">
                                                                                                    &nbsp;&nbsp;<a href="javascript:cmdToPrice()" class="tablink">Price List</a>&nbsp;&nbsp;
                                                                                            </div></td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <%}%>
                                                                                            <td class="tab" nowrap><div align="center">
                                                                                                    &nbsp;&nbsp;Vendor Item&nbsp;&nbsp;
                                                                                            </div></td>                                                                                            
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
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
                                                                                                        <td height="8" valign="middle" colspan="3">&nbsp; 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="14" valign="middle" colspan="3" class="comment"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="9%"><b>Code</b></td>
                                                                                                                    <td width="91%"><%=itemMaster.getCode()%></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="9%"><b>Name</b></td>
                                                                                                                    <td width="91%"><%=itemMaster.getName()%></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="9%"><b>Barcode</b></td>
                                                                                                                    <td width="91%"><%=(itemMaster.getBarcode() == null || itemMaster.getBarcode().length() < 1) ? "-" : itemMaster.getBarcode()%></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="9%"><b>Purchase 
                                                                                                                    Unit</b></td>
                                                                                                                    <td width="91%"> 
                                                                                                                        <%
            Uom purUom = new Uom();
            try {
                purUom = DbUom.fetchExc(itemMaster.getUomPurchaseId());
            } catch (Exception e) {
            }
                                                                                                                        %>
                                                                                                                    <%=purUom.getUnit()%></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%
            try {
                if (listVendorItem.size() > 0) {
                                                                                                    %>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                                        <%= drawList(listVendorItem, oidVendorItem)%> </td>
                                                                                                    </tr>
                                                                                                    <%  }
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
                                                                                                                <% ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                                %>
                                                                                                        <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="15" valign="middle" colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%
            if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                                    %>
                                                                                                    <%if (privAdd) {%>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="15" valign="middle" colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="22" valign="middle" colspan="3"> 
                                                                                                            <table width="100%" align="left" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="23%" align="left" class="fontarial"><a href="javascript:cmdAdd(0)" >Add 
                                                                                                                    New Vendor Price</a></td>
                                                                                                                    <td width="1%" align="center">&nbsp;</td>
                                                                                                                    <td width="35%" align="left" class="fontarial"><a href="javascript:cmdAdd(1)" >Add 
                                                                                                                    New Vendor Price (Consigment/Komisi)</a></td>
                                                                                                                    <td width="37%">&nbsp;</td>
                                                                                                                    <td width="0%">&nbsp;</td>
                                                                                                                    <td width="4%">&nbsp;</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}
            }%> 
                                                                                                                                                                                
                                                                                                    <tr align="left" valign="top"> 
                                                                                                        <td height="15" valign="middle" colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspVendorItem.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                                <%if (stsTypeVendor == 0) {%>
                                                                                                <%@ include file="vendoritem_reg.jsp"%>
                                                                                                <%} else {%>
                                                                                                <%@ include file="vendoritem_con.jsp"%>
                                                                                                <%}%>
                                                                                                <%}%>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3">
                                                                                                <table width="800" >
                                                                                                    <tr>
                                                                                                        <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i><b></td>
                                                                                                        <td width="470" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i><b></td>
                                                                                                        <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>By</i><b></td>
                                                                                                    </tr>   
                                                                                                    <%
            int max = 10;
            if (showAll == 1) {
                max = 0;
            }
            int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_VENDOR_ITEM+" and "+DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID]+" = "+oidItemMaster);
            Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_VENDOR_ITEM+" and "+DbHistoryUser.colNames[DbHistoryUser.COL_REF_ID]+" = "+oidItemMaster, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
            if (historys != null && historys.size() > 0) {

                for (int r = 0; r < historys.size(); r++) {
                    HistoryUser hu = (HistoryUser) historys.get(r);

                    Employee e = new Employee();
                    try {
                        e = DbEmployee.fetchExc(hu.getEmployeeId());
                    } catch (Exception ex) {
                    }
                    String name = "-";
                    if (e.getName() != null && e.getName().length() > 0) {
                        name = e.getName();
                    }
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td class="fontarial" style=padding:3px;><%=JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss ")%></td>
                                                                                                        <td class="fontarial" style=padding:3px;><i><%=hu.getDescription()%></i></td>
                                                                                                        <td class="fontarial" style=padding:3px;><%=name%></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        }

                                                                                                    } else {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td colspan="3" class="fontarial" style=padding:3px;><i>No history available</i></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr>
                                                                                                        <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                                                    </tr>
                                                                                                    <%
            if (countx > max) {
                if (showAll == 0) {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdShowAll()"><i>Show All History (<%=countx%>) Data</i></a></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                        } else {
                                                                                                    %>
                                                                                                    <tr>
                                                                                                        <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdUnShowAll()"><i>Show By Limit</i></a></td>
                                                                                                    </tr>
                                                                                                    <%
                }
            }%>
                                                                                                                                                                                                                                                                                                                                          
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
