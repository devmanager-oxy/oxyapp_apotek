
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
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_CARD);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_CARD, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_CARD, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%!
    public Vector drawList(Vector objectClass, int start, long locationId) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("No", "5%");
        cmdist.addHeader("Code", "15%");
        cmdist.addHeader("Barcode", "20%");
        cmdist.addHeader("Item Name", "50%");
        cmdist.addHeader("Qty Stock", "10%");
        cmdist.addHeader("Unit", "10%");

        cmdist.setLinkRow(1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        Vector temp = new Vector();

        for (int i = 0; i < objectClass.size(); i++) {
            ItemMaster itemMaster = (ItemMaster) objectClass.get(i);
            Vector rowx = new Vector();
            Uom uom = new Uom();
            try {
                uom = DbUom.fetchExc(itemMaster.getUomStockId());
            } catch (Exception ex) {

            }
            rowx.add("<div align=\"center\">" + (i + 1 + start) + "</div>");
            rowx.add("" + itemMaster.getCode());
            rowx.add("" + itemMaster.getBarcode());
            rowx.add("" + itemMaster.getName());
            rowx.add("" + getStockByStatus(locationId, itemMaster.getOID(), "APPROVED"));

            rowx.add("" + uom.getUnit());
            lstData.add(rowx);
            temp.add(itemMaster);
            lstLinkData.add(String.valueOf(itemMaster.getOID()));
        }

        Vector rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");

        lstData.add(rowx);

        Vector vx = new Vector();
        vx.add(cmdist.draw(index));
        vx.add(temp);
        return vx;
    }

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
            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }
            if (session.getValue("DETAIL") != null) {
                session.removeValue("DETAIL");
            }
            if (session.getValue("RPT_PARAMETER") != null) {
                session.removeValue("RPT_PARAMETER");
            }
            if (session.getValue("SRC_VENDOR") != null) {
                session.removeValue("SRC_VENDOR");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");
            String startDate = JSPRequestValue.requestString(request, "src_start_date");
            String endDate = JSPRequestValue.requestString(request, "src_end_date");
            Vector locations = userLocations;
            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            if (iJSPCommand == JSPCommand.NONE) {
                if (locations != null && locations.size() > 0) {
                    Location l = (Location) locations.get(0);
                    srcLocationId = l.getOID();
                }
            }

            int userLocation = 0;
            try {
                userLocation = Integer.parseInt(DbSystemProperty.getValueByName("USE_USER_LOCATION"));
            } catch (Exception e) {
            }

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            if (srcCode != null && srcCode.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " (" + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " like '%" + srcCode + "%' or " + DbItemMaster.colNames[DbItemMaster.COL_BARCODE] + " like '%" + srcCode + "%') ";
            }

            if (srcName != null && srcName.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " like '%" + srcName + "%'";
            }
            if (srcVendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " pos_vendor_item.vendor_id=" + srcVendorId;
            }

            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            ReportStockParameter rsp = new ReportStockParameter();
            rsp.setCode(srcCode);
            rsp.setName(srcName);
            rsp.setLocationId(srcLocationId);

            if (startDate != "") {
                srcStartDate = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(endDate, "dd/MM/yyyy");
            }

            rsp.setStartDate(srcStartDate);
            rsp.setEndDate(srcEndDate);

            session.putValue("RPT_PARAMETER", rsp);
            session.putValue("SRC_VENDOR", "" + srcVendorId);
            JSPLine ctrLine = new JSPLine();
            Vector listReport = new Vector(1, 1);
            int vectSize = 0;

            if (srcVendorId != 0) {
                vectSize = DbItemMaster.getCountBySupplier(whereClause);
            } else {
                vectSize = DbItemMaster.getCount(whereClause);
            }

            CmdStock ctrlStock = new CmdStock(request);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlStock.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            if (srcVendorId != 0) {
                listReport = DbItemMaster.listByVendor(start, recordToGet, whereClause, orderClause);
            } else {
                listReport = DbItemMaster.list(start, recordToGet, whereClause, orderClause);
            }

            if (userLocation == 0) {
                locations = userLocations;
            } else {
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
                window.open("<%=printroot%>.report.ReportStockCardXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdEdit(oidItemMaster){                    
                    window.open("<%=approot%>/posreport/stock-card-detail-Non-Consigment.jsp?locationId=<%=srcLocationId%>&src_start_date=<%=startDate%>&src_end_date=<%=endDate%>&itemMasterId="+oidItemMaster+"&type_item=<%=DbStockCode.TYPE_NON_CONSIGMENT%>", null, "height=800,width=1200, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes"); 
                    } 
                    
                    function cmdSearch(){
                        document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
                        document.frmadjusment.start.value=0; 
                        document.frmadjusment.action="stock-card-non-consigment.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdListFirst(){
                        document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
                        document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
                        document.frmadjusment.action="stock-card-non-consigment.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdListPrev(){
                        document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
                        document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
                        document.frmadjusment.action="stock-card-non-consigment.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdListNext(){
                        document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
                        document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
                        document.frmadjusment.action="stock-card-non-consigment.jsp";
                        document.frmadjusment.submit();
                    }
                    
                    function cmdListLast(){
                        document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
                        document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
                        document.frmadjusment.action="stock-card-non-consigment.jsp";
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
                                                                                        Card</font><font class="tit1"> &raquo; <span class="lvl2">By 
                                                                                Location</span></font></b></td>
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
                                                                                <td height="8"  colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="4"><b><i>Search Parameters :</i></b></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="6%">Code/Barcode</td>
                                                                                                        <td width="38%"> 
                                                                                                            <input type="text" name="src_code" value="<%=srcCode%>" size="30">
                                                                                                        </td>
                                                                                                        <td width="15%" align="right">&nbsp;</td>
                                                                                                        <td width="41%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="6%">Name</td>
                                                                                                        <td width="38%"> 
                                                                                                            <input type="text" name="src_name" value="<%=srcName%>" size="30">
                                                                                                        </td>
                                                                                                        <td width="15%" align="right">&nbsp;</td>
                                                                                                        <td width="41%">&nbsp; </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="5%">Vendor</td>
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
                                                                                                        <td width="6%">Location</td>
                                                                                                        <td width="38%"> 
                                                                                                        <select name="src_location_id">
                                                                                                            <%
            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);

                                                                                                            %>
                                                                                                            <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                            <%}
            }%>
                                                                                                        </select>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="6%">Periode</td>
                                                                                                        <td width="38%"> 
                                                                                                        <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                                                                        <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="4" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="6%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        <td colspan="3">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="6%">&nbsp;</td>
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
                                                                                                Vector x = drawList(listReport, start, srcLocationId);
                                                                                                String strTampil = (String) x.get(0);
                                                                                                Vector rptObj = (Vector) x.get(1);
                                                                                                %>
                                                                                                <%=strTampil%> 
                                                                                                <%
                                                                                                session.putValue("DETAIL", rptObj);
                                                                                                %>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"></td>
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
                                                                                        <%if (privPrint) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">
                                                                                                <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print2" height="22" border="0"></a>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%}%>
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
