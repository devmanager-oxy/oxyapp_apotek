
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_REPORT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_REPORT, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_REPORT, AppMenu.PRIV_PRINT);            
%>
<!-- Jsp Block -->

<%!
    public Vector drawList(Vector objectClass, int start) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("No", "3%");
        cmdist.addHeader("Location", "15%");
        cmdist.addHeader("Code", "10%");
        cmdist.addHeader("Item Name", "27%");
        cmdist.addHeader("Category", "15%");
        cmdist.addHeader("Qty Draft", "7%");
        cmdist.addHeader("Stock On Hand", "10%");
        cmdist.addHeader("Available", "10%");
        
        //cmdist.addHeader("Cogs", "10%");
        //cmdist.addHeader("Total", "10%");

        cmdist.setLinkRow(-1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        Vector temp = new Vector();

        for (int i = 0; i < objectClass.size(); i++) {
            SrcStockReportL stockReportL = (SrcStockReportL) objectClass.get(i);

            ItemMaster im = new ItemMaster();
            try {
                im = DbItemMaster.fetchExc(stockReportL.getItemMasterId());
            } catch (Exception e) {}

            Vector rowx = new Vector();
            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add("" + stockReportL.getLocationName());
            rowx.add("" + stockReportL.getCode());
            rowx.add("" + stockReportL.getDescription());
            rowx.add("" + stockReportL.getGroupName());
            double stDraft = SessStockReport.getStockByStatus(stockReportL.getLocation(), stockReportL.getItemMasterId(), "DRAFT");
            rowx.add("<div align=\"right\">" + stDraft + "</div>");
            rowx.add("<div align=\"right\">" + stockReportL.getQty() + "</div>");
            rowx.add("<div align=\"right\">" + (stockReportL.getQty() + stDraft) + "</div>");
            //rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(im.getCogs(), "#,###.##") + "</div>");
            //rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(stockReportL.getQty() * im.getCogs(), "#,###.##") + "</div>");
            
            lstData.add(rowx);
            temp.add(stockReportL);
            lstLinkData.add(String.valueOf(-1));
        }
        
        Vector vx = new Vector();
        vx.add(cmdist.draw(index));
        vx.add(temp);
        return vx;
    }
    
    public static int getItemStockCountBySupplier(String itmCode, String itmName, long locationId, long groupId, int type, long vendorId){
        
        String sql = "select count(*) as tot from ((" +
             " select s.stock_id "+
            " from "+DbStock.DB_POS_STOCK+" s "+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " inner join "+DbLocation.DB_LOCATION+" l "+
            " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = s."+DbStock.colNames[DbStock.COL_LOCATION_ID] +
            " inner join "+DbVendorItem.DB_VENDOR_ITEM+" v "+
            " on v."+DbVendorItem.colNames[DbVendorItem.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
        
            String where = "";
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            //0 = all location, 1=group by location
            if(locationId!=0 && locationId!=1){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            
            if(groupId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+groupId;
            }
            if(vendorId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " v."+DbVendorItem.colNames[DbVendorItem.COL_VENDOR_ID]+" = "+vendorId;
            }
            
            if(where.length()>0){
                where = where + " and s."+DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }else{
                where  = "s." +DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }
            
            if(where.length()>0){
                where = where + " and s."+DbStock.colNames[DbStock.COL_STATUS]+" = 'APPROVED' ";
            }else{
                where  = " s." +DbStock.colNames[DbStock.COL_STATUS]+" =  = 'APPROVED' ";
            }
            
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];
            
            
            sql = sql + ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+ ")) as tabel ";//seharusnya di group per lokasi jg. seblumnya tidak ada
            
            
           int total = 0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){                    
                   total = rs.getInt("tot");                    
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return total;
            
    }
    
    public static int getItemStockCount(String itmCode, String itmName, long locationId, long groupId, int type){
        
        String sql = "select count(*) as tot from (( " +
            " select s.stock_id " +
            " from "+DbStock.DB_POS_STOCK+" s "+
            " inner join "+DbItemMaster.DB_ITEM_MASTER+" m "+
            " on m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID]+" = s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID]+
            " inner join "+DbItemGroup.DB_ITEM_GROUP+" g "+
            " on g."+DbItemGroup.colNames[DbItemGroup.COL_ITEM_GROUP_ID]+" = m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+
            " inner join "+DbLocation.DB_LOCATION+" l "+
            " on l."+DbLocation.colNames[DbLocation.COL_LOCATION_ID]+" = s."+DbStock.colNames[DbStock.COL_LOCATION_ID];
        
            String where = "";
            if(itmCode.length()>0){
                where = " m."+DbItemMaster.colNames[DbItemMaster.COL_CODE]+" like '%"+itmCode+"%'";
            }
            
            if(itmName.length()>0){
                if(where.length()>0){
                    where = "("+where +" or ";
                }
                
                where = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_NAME]+" like '%"+itmName+"%'";
                
                if(itmCode.length()>0){
                    where = where +")";
                }
            }
            
            //0 = all location, 1=group by location
            if(locationId!=0 && locationId!=1){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " s."+DbStock.colNames[DbStock.COL_LOCATION_ID]+"="+locationId;
            }
            
            if(groupId!=0){
                if(where.length()>0){
                    where = where +" and ";
                }
                
                where  = where + " m."+DbItemMaster.colNames[DbItemMaster.COL_ITEM_GROUP_ID]+" = "+groupId;
            }
            if(where.length()>0){
                where = where + " and s."+DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }else{
                where  = " s." +DbStock.colNames[DbStock.COL_TYPE_ITEM]+" = "+ type;
            }
            
            if(where.length()>0){
                where = where + " and s."+DbStock.colNames[DbStock.COL_STATUS]+" = 'APPROVED' ";
            }else{
                where  = " s." +DbStock.colNames[DbStock.COL_STATUS]+" =  = 'APPROVED' ";
            }
            
            
            if(where.length()>0){
                sql = sql + " where "+where;
            }
            
            sql = sql + " group by s."+DbStock.colNames[DbStock.COL_ITEM_MASTER_ID];            
            
            sql = sql + ", s."+DbStock.colNames[DbStock.COL_LOCATION_ID] + ")) as tabel ";//seharusnya di group per lokasi jg. seblumnya tidak ada            
            
            int total =0;
            
            CONResultSet crs = null;
            try{
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while(rs.next()){
                    
                   total =  rs.getInt("tot");
                   
                }
            }
            catch(Exception e){
                System.out.println(e.toString());
            }
            finally{
                CONResultSet.close(crs);
            }
            
            return total;
            
    }
    

%>
<%
            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }

            if (session.getValue("DETAIL") != null) {
                session.removeValue("DETAIL");
            }

            if (session.getValue("VENDORID") != null) {
                session.removeValue("VENDORID");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");

            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            long srcGroupId = JSPRequestValue.requestLong(request, "src_group_id");
            int orderBy = JSPRequestValue.requestInt(request, "order_by");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");

            session.putValue("VENDORID", ""+srcVendorId);
            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            int userLocation = 0;
            try{
                userLocation = Integer.parseInt(DbSystemProperty.getValueByName("USE_USER_LOCATION"));
            }catch(Exception e){}

            JSPLine ctrLine = new JSPLine();
            Vector listReport = new Vector(1, 1);
            JSPLine jspLine = new JSPLine();

            int vectSize = 0;
            Vector vDet = new Vector();

            if (iJSPCommand != JSPCommand.NONE) {
                if (srcVendorId != 0) {
                    vectSize = getItemStockCountBySupplier(srcCode, srcName, srcLocationId, srcGroupId, DbStock.TYPE_NON_CONSIGMENT, srcVendorId);
                } else {
                    vectSize = getItemStockCount(srcCode, srcName, srcLocationId, srcGroupId, DbStock.TYPE_NON_CONSIGMENT);
                }
            }
//get value for report
            SrcStockReport rptKonstan = new SrcStockReport();
            CmdStock ctrlStock = new CmdStock(request);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlStock.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
//listReport = SessStockReport.getStockByLocation(srcLocationId, I_Project.GROUP_LOCATION);
            if (iJSPCommand != JSPCommand.NONE) {
                if (srcVendorId != 0) {
                    listReport = SessStockReport.getItemStockBySupplier(srcCode, srcName, srcLocationId, srcGroupId, orderBy, DbStock.TYPE_NON_CONSIGMENT, start, recordToGet, srcVendorId);
                } else {
                    listReport = SessStockReport.getItemStock(srcCode, srcName, srcLocationId, srcGroupId, orderBy, DbStock.TYPE_NON_CONSIGMENT, start, recordToGet);

                }
                vDet.add(srcCode);
                vDet.add(srcName);
                vDet.add(""+srcLocationId);
                vDet.add(""+srcGroupId);
                vDet.add(""+orderBy);
                vDet.add(""+DbStock.TYPE_NON_CONSIGMENT);
                vDet.add(""+0);
                vDet.add(""+0);
                vDet.add(""+srcVendorId);

            }
            Vector locations = userLocations;
            if(userLocation==0){
                locations = userLocations;
            }else{
                locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
                window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.RptStockLocationXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdSearch(){
                    document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
                    document.frmadjusment.start.value=0; 
                    document.frmadjusment.action="stock-location.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListFirst(){
                    document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmadjusment.action="stock-location.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListPrev(){
                    document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmadjusment.action="stock-location.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListNext(){
                    document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmadjusment.action="stock-location.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListLast(){
                    document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmadjusment.action="stock-location.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif','../images/print2.gif')">
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
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmadjusment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_adjusment_id" value="<%=oidAdjusment%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Reports</font><font class="tit1"> 
                                                                                        &raquo; </font><font color="#990000" class="lvl1">Stock 
                                                                                        Repor t</font><font class="tit1"> &raquo; 
                                                                                <span class="lvl2">By Location</span></font></b></td>
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="5"  colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;By Location&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;<a href="<%=approot%>/posreport/stock-category.jsp?menu_idx=13" class="tablink">By Category</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;<a href="<%=approot%>/posreport/stock-subcategory.jsp?menu_idx=13" class="tablink">By Sub Category</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="4"><b><i>Search Parameters 
                                                                                                        :</i></b></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="8%">Code</td>
                                                                                                        <td width="22%"> 
                                                                                                            <input type="text" name="src_code" value="<%=srcCode%>" size="30">
                                                                                                        </td>
                                                                                                        <td width="8%" align="right">Category</td>
                                                                                                        <td width="62%">
                                                                                                            <%
            Vector groups = DbItemGroup.list(0, 0, "", "name");
                                                                                                            %>	 
                                                                                                            <select name="src_group_id">
                                                                                                                <option value="0" <%if (srcGroupId == 0) {%>selected<%}%>>- All -</option>
                                                                                                                <%if (groups != null && groups.size() > 0) {
                for (int i = 0; i < groups.size(); i++) {
                    ItemGroup ig = (ItemGroup) groups.get(i);
                                                                                                                %>
                                                                                                                <option value="<%=ig.getOID()%>" <%if (srcGroupId == ig.getOID()) {%>selected<%}%>><%=ig.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="8%">Name</td>
                                                                                                        <td width="22%"> 
                                                                                                            <input type="text" name="src_name" value="<%=srcName%>" size="30">
                                                                                                        </td>
                                                                                                        <td width="8%" align="right">Location</td>
                                                                                                        <td width="62%"> 
                                                                                                            <select name="src_location_id">
                                                                                                                <%
                                                                                                                if (locations.size() == totLocationxAll || userLocation==1) {
            if (srcLocationId == 0 || srcLocationId == 1) {
                rptKonstan.setLocation("- All -");
            }
                                                                                                                %>                                                                                                                
                                                                                                                <option value="1" <%if (srcLocationId == 1) {%>selected<%}%>>- GROUP BY LOCATION -</option>
                                                                                                                <%
                                                                                                                }
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    String str = "";
                    if (srcLocationId == d.getOID()) {
                        rptKonstan.setLocation(d.getName());
                    }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="8%">Order By</td>
                                                                                                        <td width="22%"> 
                                                                                                            <select name="order_by">
                                                                                                                <option value="0" <%if (orderBy == 0) {%>selected<%}%>>LOCATION</option>
                                                                                                                <option value="1" <%if (orderBy == 1) {%>selected<%}%>>ITEM CODE</option>
                                                                                                                <option value="2" <%if (orderBy == 2) {%>selected<%}%>>ITEM NAME</option>
                                                                                                                <option value="3" <%if (orderBy == 3) {%>selected<%}%>>ITEM CATEGORY</option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td width="5%" align="right">Vendor</td>
                                                                                                        <td width="11%">
                                                                                                            <select name="src_vendor_id">
                                                                                                                <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>>- All -</option>
                                                                                                                <%

            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (vendors != null && vendors.size() > 0) {
                for (int i = 0; i < vendors.size(); i++) {
                    Vendor d = (Vendor) vendors.get(i);
                    String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (srcVendorId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="8%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        <td colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="8%">&nbsp;</td>
                                                                                                        <td colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listReport.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                                <%
                                                                                                Vector x = drawList(listReport, start);
                                                                                                String strTampil = (String) x.get(0);
                                                                                                Vector rptObj = (Vector) x.get(1);
                                                                                                %>
                                                                                                <%=strTampil%> 
                                                                                                <%
                                                                                                session.putValue("DETAIL", vDet);
                                                                                                %>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if(privPrint){%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%  }
            } catch (Exception exc) {
                System.out.println("sdsdf : " + exc.toString());
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
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3">&nbsp; </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        <%
            session.putValue("KONSTAN", rptKonstan);
                                                        %>
                                                        <!-- #EndEditable -->
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
