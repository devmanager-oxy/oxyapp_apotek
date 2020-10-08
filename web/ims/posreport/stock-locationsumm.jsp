
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
        cmdist.addHeader("Location", "21%");
        cmdist.addHeader("Code", "10%");
        cmdist.addHeader("Item Name", "30%");
        cmdist.addHeader("Category", "15%");
        cmdist.addHeader("Qty Draft", "7%");
        cmdist.addHeader("Qty Approved", "7%");
        cmdist.addHeader("Qty Saldo", "7%");


        cmdist.setLinkRow(-1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        Vector temp = new Vector();
        double totalamount = 0.0;
        double ttAmount = 0.0;

        for (int i = 0; i < objectClass.size(); i++) {
            SrcStockReportL stockReportL = (SrcStockReportL) objectClass.get(i);

            Vector rowx = new Vector();

            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add("" + stockReportL.getLocationName());
            rowx.add("" + stockReportL.getCode());

            rowx.add("" + stockReportL.getDescription());


            rowx.add("" + stockReportL.getGroupName());

            rowx.add("<div align=\"right\">" + SessStockReport.getStockByStatus(stockReportL.getLocation(), stockReportL.getItemMasterId(), "DRAFT") + "</div>");
            rowx.add("<div align=\"right\">" + SessStockReport.getStockByStatus(stockReportL.getLocation(), stockReportL.getItemMasterId(), "APPROVED") + "</div>");
            rowx.add("<div align=\"right\">" + stockReportL.getQty() + "</div>");
            lstData.add(rowx);
            temp.add(stockReportL);
            lstLinkData.add(String.valueOf(-1));
        }


        Vector vx = new Vector();
        vx.add(cmdist.draw(index));
        vx.add(temp);
        return vx;
    }

%>
<%
            if (session.getValue("KONSTAN") != null) {
                session.removeValue("KONSTAN");
            }

            if (session.getValue("DETAIL") != null) {
                session.removeValue("DETAIL");
            }

            boolean displayPending = false;

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");            
            int orderBy = JSPRequestValue.requestInt(request, "order_by");
            String srcCode = JSPRequestValue.requestString(request, "src_code");
            String srcName = JSPRequestValue.requestString(request, "src_name");            
            int orderType = JSPRequestValue.requestInt(request, "order_type");
            int supZero = JSPRequestValue.requestInt(request, "sup_zero");
            int recordToGet = JSPRequestValue.requestInt(request, "record_to_get");
            
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            if (srcCode != null && srcCode.length() > 0) {
                whereClause = " code like '%" + srcCode + "%'";
            }
            if (srcName != null && srcName.length() > 0) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " name like '%" + srcName + "%'";
            }

            if (supZero == 1) {
                if (whereClause != null && whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " qtystock <> 0";
            }

            if (orderBy == 0) {
                orderClause = " name";
            } else if (orderBy == 1) {
                orderClause = " code";
            } else {
                orderClause = " qtystock";
            }

            if (orderType == 1) {
                orderClause = orderClause + " desc";
            }

            JSPLine ctrLine = new JSPLine();
            Vector listReport = new Vector(1, 1);
            JSPLine jspLine = new JSPLine();

            int vectSize = 0;
            if (iJSPCommand != JSPCommand.NONE) {
                vectSize = SessStockReportView.getStockItemCount(whereClause);
            }

//get value for report
            SrcStockReport rptKonstan = new SrcStockReport();
            CmdStock ctrlStock = new CmdStock(request);
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlStock.actionList(iJSPCommand, start, vectSize, recordToGet);
            }

            if (iJSPCommand != JSPCommand.NONE) {
                listReport = SessStockReportView.getStockItemList(start, recordToGet, whereClause, orderClause);

                Vector temp = new Vector();
                temp.add(srcCode);
                temp.add(srcName);
                temp.add("" + orderBy);
                temp.add("" + orderType);
                temp.add("" + supZero);

                session.putValue("REPORT_STOCK", temp);
                session.putValue("REPORT_STOCK_USER", user.getLoginId());
                session.putValue("REPORT_STOCK_FILTER", "Filtered by code : " + ((srcCode == null || srcCode.length() == 0) ? "All" : srcCode) + ", name : " + ((srcName == null || srcName.length() == 0) ? "All" : srcName) + ", sort by :" + orderClause + ", " + (supZero == 1 ? "suppress zero" : ""));
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
                window.open("<%=printroot%>.report.RptStockTotalLocationXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdSearch(){
                    document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
                    document.frmadjusment.start.value=0; 
                    document.frmadjusment.action="stock-locationsumm.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListFirst(){
                    document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
                    document.frmadjusment.action="stock-locationsumm.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListPrev(){
                    document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
                    document.frmadjusment.action="stock-locationsumm.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListNext(){
                    document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
                    document.frmadjusment.action="stock-locationsumm.jsp";
                    document.frmadjusment.submit();
                }
                
                function cmdListLast(){
                    document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
                    document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
                    document.frmadjusment.action="stock-locationsumm.jsp";
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
                                                                                <span class="lvl2">Total Stock per Location</span></font></b></td>
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
                                                                                <td height="8"  colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="4"><b><i>Search Parameters 
                                                                                                        :</i></b></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="8%">Code</td>
                                                                                                        <td width="33%"> 
                                                                                                            <input type="text" name="src_code" value="<%=srcCode%>" size="30">
                                                                                                        </td>
                                                                                                        <td width="6%" align="right">&nbsp;</td>
                                                                                                        <td width="53%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="8%">Name</td>
                                                                                                        <td width="33%"> 
                                                                                                            <input type="text" name="src_name" value="<%=srcName%>" size="30">
                                                                                                        </td>
                                                                                                        <td width="6%" align="right">&nbsp;</td>
                                                                                                        <td width="53%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="8%">Sort By</td>
                                                                                                        <td width="33%" nowrap> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td width="22%"> 
                                                                                                                        <select name="order_by">
                                                                                                                            <option value="0" <%if (orderBy == 0) {%>selected<%}%>>ITEM 
                                                                                                                                    NAME</option>
                                                                                                                            <option value="1" <%if (orderBy == 1) {%>selected<%}%>>ITEM 
                                                                                                                                    CODE</option>
                                                                                                                            <option value="2" <%if (orderBy == 2) {%>selected<%}%>>STOCK 
                                                                                                                                    QTY</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td width="2"></td>
                                                                                                                    <td width="76%"> 
                                                                                                                        <select name="order_type">
                                                                                                                            <option value="0" <%if (orderType == 0) {%>selected<%}%>>ASC</option>
                                                                                                                            <option value="1" <%if (orderType == 1) {%>selected<%}%>>DESC</option>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                        <td width="6%" align="right">&nbsp;</td>
                                                                                                        <td width="53%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td height="17" width="8%">List 
                                                                                                        Preview Limit </td>
                                                                                                        <td height="17" width="33%">
                                                                                                            <select name="record_to_get">
                                                                                                                <option value="25" <%if (recordToGet == 25) {%>selected<%}%>>25</option>
                                                                                                                <option value="50" <%if (recordToGet == 50) {%>selected<%}%>>50</option>
                                                                                                                <option value="100" <%if (recordToGet == 100) {%>selected<%}%>>100</option>
                                                                                                                <option value="250" <%if (recordToGet == 250) {%>selected<%}%>>250</option>
                                                                                                                <option value="500" <%if (recordToGet == 500) {%>selected<%}%>>500</option>
                                                                                                                <option value="750" <%if (recordToGet == 750) {%>selected<%}%>>750</option>
                                                                                                                <option value="1000" <%if (recordToGet == 1000) {%>selected<%}%>>1000</option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                        <td height="17" width="6%"></td>
                                                                                                        <td height="17" width="53%"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td height="17" width="8%">Suppress 
                                                                                                        Zero</td>
                                                                                                        <td height="17" width="33%"> 
                                                                                                        <input type="checkbox" name="sup_zero" value="1" <%if (supZero == 1) {%>checked<%}%>>
                                                                                                               Yes </td>
                                                                                                        <td height="17" width="6%"></td>
                                                                                                        <td height="17" width="53%"></td>
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

                    Vector locations = DbLocation.list(0, 0, "", "name");

                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td class="tablehdr" width="63"><font size="1">NO</font></td>
                                                                                                        <td class="tablehdr" width="100"><font size="1">CODE</font></td>
                                                                                                        <td class="tablehdr" width="200"><font size="1">ITEM 
                                                                                                        NAME </font></td>
                                                                                                        <%if (locations != null && locations.size() > 0) {
                                                                                                        for (int i = 0; i < locations.size(); i++) {
                                                                                                            Location d = (Location) locations.get(i);

                                                                                                        %>
                                                                                                        <td width="90" class="tablehdr"><font size="1"><%=d.getName()%></font></td>
                                                                                                        <%}
                                                                                                    }%>
                                                                                                        <td width="130" class="tablehdr"><font size="1">TOTAL</font></td>
                                                                                                    </tr>
                                                                                                    <%
                                                                                                    for (int x = 0; x < listReport.size(); x++) {
                                                                                                        ItemMaster im = (ItemMaster) listReport.get(x);
                                                                                                        double totAv = 0;
                                                                                                        double totOtw = 0;
                                                                                                        double totSlp = 0;
                                                                                                        double tot = 0;
                                                                                                        if (x % 2 == 0) {
                                                                                                    %>
                                                                                                    <tr> 
                                                                                                        <td width="63" class="tablecell1"> 
                                                                                                            <div align="center"><font size="1"><%=(start + x + 1)%></font></div>
                                                                                                        </td>
                                                                                                        <td width="100" class="tablecell1" nowrap><font size="1"><%=im.getCode()%></font></td>
                                                                                                        <td width="200" class="tablecell1" nowrap><font size="1"><%=im.getName()%></font></td>
                                                                                                        <%if (locations != null && locations.size() > 0) {
                                                                                                                          for (int i = 0; i < locations.size(); i++) {
                                                                                                                              Location d = (Location) locations.get(i);
                                                                                                                              double qty = SessStockReportView.getStockByLocationByItem(im.getOID(), d.getOID(), "APPROVED");
                                                                                                                              double qtyOtw = 0;//SessStockReportView.getStockByLocationByItem(im.getOID(), d.getOID(), "DRAFT");
                                                                                                                              double qtySlp = 0;
                                                                                                                              if (displayPending) {
                                                                                                                                  qtySlp = 0;//SessStockReportView.getSalesPendingLocationByItem(im.getOID(), d.getOID());
                                                                                                                              }


                                                                                                                              if (qtyOtw < 0) {
                                                                                                                                  qtyOtw = qtyOtw * -1;
                                                                                                                              }

                                                                                                                              qty = qty - qtyOtw - qtySlp;

                                                                                                                              totAv = totAv + qty;
                                                                                                                              totOtw = totOtw + qtyOtw;
                                                                                                                              totSlp = totSlp + qtySlp;
                                                                                                                              //tot = tot + qty + qtyOtw + qtySlp;
%>
                                                                                                        <td width="90" class="tablecell1"> 
                                                                                                            <div align="right"><font size="1"><%=(qty == 0) ? "-" : JSPFormater.formatNumber(qty, "###")%></font></div>
                                                                                                        </td>
                                                                                                        <%}
                                                                                                                      }%>
                                                                                                        <td width="130" class="tablecell1"> 
                                                                                                            <div align="right"><font size="1"><%=(totAv + totOtw + totSlp == 0) ? "-" : JSPFormater.formatNumber(totAv + totOtw + totSlp, "###")%></font></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td width="63" class="tablecell"> 
                                                                                                            <div align="center"><font size="1"><%=(start + x + 1)%></font></div>
                                                                                                        </td>
                                                                                                        <td width="100" class="tablecell" nowrap><font size="1"><%=im.getCode()%></font></td>
                                                                                                        <td width="200" class="tablecell" nowrap><font size="1"><%=im.getName()%></font></td>
                                                                                                        <%if (locations != null && locations.size() > 0) {
                                                                                                                          for (int i = 0; i < locations.size(); i++) {
                                                                                                                              Location d = (Location) locations.get(i);
                                                                                                                              double qty = SessStockReportView.getStockByLocationByItem(im.getOID(), d.getOID(), "APPROVED");
                                                                                                                              double qtyOtw = 0;// SessStockReportView.getStockByLocationByItem(im.getOID(), d.getOID(), "DRAFT");
                                                                                                                              double qtySlp = 0;
                                                                                                                              if (displayPending) {
                                                                                                                                  qtySlp = 0;//SessStockReportView.getSalesPendingLocationByItem(im.getOID(), d.getOID());
                                                                                                                              }

                                                                                                                              if (qtyOtw < 0) {
                                                                                                                                  qtyOtw = qtyOtw * -1;
                                                                                                                              }

                                                                                                                              qty = qty - qtyOtw - qtySlp;

                                                                                                                              totAv = totAv + qty;
                                                                                                                              totOtw = totOtw + qtyOtw;
                                                                                                                              totSlp = totSlp + qtySlp;
                                                                                                        %>
                                                                                                        <td width="90" class="tablecell"> 
                                                                                                            <div align="right"><font size="1"><%=(qty == 0) ? "-" : JSPFormater.formatNumber(qty, "###")%></font></div>
                                                                                                        </td>
                                                                                                        <%}
                                                                                                                      }%>
                                                                                                        <td width="130" class="tablecell"> 
                                                                                                            <div align="right"><font size="1"><%=(totAv + totOtw + totSlp == 0) ? "-" : JSPFormater.formatNumber(totAv + totOtw + totSlp, "###")%></font></div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}
                                                                                                    }%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">  
                                                                                            <td height="8" align="left" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" class="command"> 
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
                                                                                            <td height="22" valign="middle">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if(privPrint){%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle"><a href="javascript:cmdPrintXLS()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></td>
                                                                                        </tr>
                                                                                        <%  
                                                                                        }
                                                                                        }
            } catch (Exception exc) {
                System.out.println("sdsdf : " + exc.toString());
            }%>
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
