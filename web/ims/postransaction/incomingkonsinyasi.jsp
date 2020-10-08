
<%-- 
    Document   : incomingkonsinyasi
    Created on : Sep 29, 2015, 2:19:10 PM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KONSINYASI);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KONSINYASI, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KONSINYASI, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KONSINYASI, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KONSINYASI, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_INCOMING, AppMenu.M2_INCOMING_KONSINYASI, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%!
    public void konsinyasiSales(long locationId, Date startDate, Date endDate, long vendorId, long userId, long incomingId) {

        try {
            String sql = "select sd.sales_id as sales_id,sd.sales_detail_id as sales_detail_id from pos_sales s inner join pos_sales_detail sd on s.sales_id = sd.sales_id " +
                    " inner join pos_item_master m on sd.product_master_id = m.item_master_id left join pos_sales_detail_konsinyasi dk on sd.sales_detail_id = dk.sales_detail_id " +
                    " where s.location_id = " + locationId + " and s.date between ('" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00') and ('" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59') and m.default_vendor_id = " + vendorId + " and dk.sales_detail_id is null";
            CONResultSet dbrs = null;
            try {
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {
                    long salesId = rs.getLong("sales_id");
                    long salesDetailId = rs.getLong("sales_detail_id");

                    SalesDetailKonsinyasi sdk = new SalesDetailKonsinyasi();
                    sdk.setSalesId(salesId);
                    sdk.setSalesDetailId(salesDetailId);
                    sdk.setVendorId(vendorId);
                    sdk.setCreateDate(new Date());
                    sdk.setCreateId(userId);
                    sdk.setReferensiId(incomingId);
                    try {
                        DbSalesDetailKonsinyasi.insertExc(sdk);
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e) {
            }
        } catch (Exception e) {
        }
    }
%>
<%

            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            Vendor vnd = new Vendor();
            try {
                if (vendorId != 0) {
                    vnd = DbVendor.fetchExc(vendorId);
                }
            } catch (Exception e) {
            }

            int totalData = JSPRequestValue.requestInt(request, "total_data");

            if (iJSPCommand == JSPCommand.SAVE) {
                if (totalData > 0) {
                    double totalAmount = JSPRequestValue.requestDouble(request, "total_amount");

                    Receive rec = new Receive();
                    rec.setLocationId(locationId);
                    int counter = DbReceive.getNextCounter() + 1;
                    rec.setNumber(DbReceive.getNextNumber(counter));
                    rec.setCounter(counter);
                    rec.setDate(new Date());
                    rec.setPrefixNumber(DbReceive.getNumberPrefix());
                    rec.setStatus("APPROVED");
                    rec.setUserId(user.getOID());
                    rec.setDueDate(new Date());
                    rec.setApproval1(user.getOID());
                    rec.setApproval1Date(new Date());
                    rec.setVendorId(vnd.getOID());
                    rec.setTotalAmount(totalAmount);
                    rec.setPaymentType("Credit");
                    rec.setCurrencyId(504404384818397770l);//rp
                    rec.setNote("AUTO GENERATED - Incoming Konsinyasi");
                    if (vnd.getIsPKP() == 1) {
                        rec.setIncluceTax(1);
                        rec.setTaxPercent(10);
                        rec.setTotalTax((totalAmount * 10) / 100);
                    }

                    try {
                        long oidx = DbReceive.insertExc(rec);
                        if (oidx != 0) {
                            for (int i = 1; i <= totalData; i++) {
                                long itemId = JSPRequestValue.requestLong(request, "item_id" + i);
                                double cost = JSPRequestValue.requestDouble(request, "cost" + i);
                                double sold = JSPRequestValue.requestDouble(request, "sold" + i);

                                ItemMaster im = new ItemMaster();
                                try {
                                    im = DbItemMaster.fetchExc(itemId);
                                } catch (Exception ex1) {
                                }
                                ReceiveItem ri = new ReceiveItem();
                                ri.setReceiveId(oidx);
                                ri.setItemMasterId(itemId);
                                ri.setQty(sold);
                                ri.setAmount(cost);
                                ri.setTotalAmount(sold * cost);
                                ri.setUomId(im.getUomStockId());

                                try {
                                    long oid = DbReceiveItem.insertExc(ri);
                                } catch (Exception ex) {
                                }

                            }
                            if (oidx != 0) {
                                try {
                                    DbReceiveItem.proceedStock(rec);
                                } catch (Exception e) {
                                }
                            }
                            konsinyasiSales(locationId, invStartDate, invEndDate, vendorId, user.getOID(), oidx);

                        }
                    } catch (Exception e) {
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
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                document.frmsales.prev_command.value="<%=prevJSPCommand%>";
                document.frmsales.action="incomingkonsinyasi.jsp";
                document.frmsales.submit();
            }
            
            function cmdSave(){
                if(confirm("Warning, this command will create APPROVED incoming, and also generate stock.\nProceed action ?")){
                    
                    //document.all.cmdsave.style.display="none";
                    //document.all.cmdsavecomment.style.display="";
                    
                    document.frmsales.command.value="<%=JSPCommand.SAVE%>";
                    document.frmsales.prev_command.value="<%=prevJSPCommand%>";
                    document.frmsales.action="incomingkonsinyasi.jsp";
                    document.frmsales.submit();
                }
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
                   <%@ include file="../calendar/calendarframe.jsp"%>
                                <!-- #EndEditable -->
                            </td>
                            <td width="100%" valign="top"> 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    
                                    <tr> 
                                        <td><!-- #BeginEditable "content" --> 
                                            <form name="frmsales" method ="post" action="">
                                                <input type="hidden" name="command" value="<%=iJSPCommand%>">                                                                                                            
                                                <input type="hidden" name="start" value="<%=start%>">
                                                <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">                                                                                                                                                                                                                        
                                                <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                    <tr> 
                                                        <td valign="top"> 
                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                <tr valign="bottom"> 
                                                                    <td width="60%" height="23"><b><font color="#990000" class="lvl1">Incoming Goods 
                                                                            </font><font class="tit1">&raquo; 
                                                                    <span class="lvl2">Consigned By Cost<br></span></font></b></td>
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
                                                        <td colspan="3" height="5"></td>
                                                    </tr>
                                                    <tr align="left" valign="top"> 
                                                        <td height="8"  colspan="3" class="container"> 
                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" > 
                                                                        <table width="350" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top">                                                                         
                                                                                <td  >                                                                                                                                                
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                        <tr> 
                                                                                            <td colspan="3" height="5"></td>
                                                                                        </tr>
                                                                                        <tr>
                                                                                            <td colspan="3" nowrap class="fontarial"><font size="1"><i>Searching Parameter :</i></font></td>                                                                                    
                                                                                        </tr>
                                                                                        <tr height="22"> 
                                                                                            <td width="90" class="tablearialcell1">&nbsp;&nbsp;Date Between</td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td >
                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                    <tr>
                                                                                                        <td ><input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                                                                        <td class="fontarial">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                        <td><input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>                                                                                                                                                        
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>                                                                                                                                        
                                                                                        <tr height="22">
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Suplier</td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td class="fontarial"> 
                                                                                                <%
            String whereCosg = DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 1 and " + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HB;
            Vector vVendor = DbVendor.list(0, 0, whereCosg, DbVendor.colNames[DbVendor.COL_NAME]);

                                                                                                %>
                                                                                                <select name="src_vendor_id" class="fontarial">                                                                                                                                                    
                                                                                                    <%if (vVendor != null && vVendor.size() > 0) {
                for (int i = 0; i < vVendor.size(); i++) {
                    Vendor v = (Vendor) vVendor.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == vendorId) {%>selected<%}%>><%=v.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                            </td>                                                                                                                                            
                                                                                        </tr>
                                                                                        <tr height="22">
                                                                                            <td class="tablearialcell1">&nbsp;&nbsp;Location</td>
                                                                                            <td width="1" class="fontarial">:</td>
                                                                                            <td class="fontarial"> 
                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                %>
                                                                                                <select name="src_location_id" class="fontarial">                                                                                                    			                                                                                                                                                                
                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                            </td>                                                                                                                                            
                                                                                        </tr>                                                                                                                                                                                                                                                                               
                                                                                        
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>  
                                                                <tr>
                                                                    <td colspan="4">
                                                                        <table width="80%" border="0" cellspacing="1" cellpadding="1" height="3">
                                                                            <tr > 
                                                                                <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                            </tr>
                                                                        </table>    
                                                                    </td>
                                                                </tr> 
                                                                <tr align="left" valign="top"> 
                                                                    <td height="22" valign="middle" colspan="4" > 
                                                                        <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>
                                                                    </td>    
                                                                </tr>  
                                                                <tr align="left" valign="top"> 
                                                                    <td height="22" valign="middle" colspan="4">&nbsp;</td>    
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="22" valign="middle" colspan="4"> 
                                                                        <table width="1000" border="0" cellspacing="1" cellpadding="0">
                                                                            <tr height="20"> 
                                                                                <td class="tablearialhdr" width="100" >SKU</td>                                                                                                                                            
                                                                                <td class="tablearialhdr" >DESCRIPTION</td>
                                                                                <td class="tablearialhdr" width="150">COST</td>
                                                                                <td class="tablearialhdr" width="150">SOLD</td>                                                                                
                                                                                <td class="tablearialhdr" width="150">SELLING VALUE</td>                                                                                
                                                                            </tr>  
                                                                            <%
            if (iJSPCommand == JSPCommand.SEARCH) {

                int xData = 0;
                CONResultSet crs = null;

                try {

                    String sql = "select sku,item_id,item_name,sum(qty_sold) - sum(qty_ret) as sold  from ( ";

                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name, sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty_sold, 0 as qty_ret " +
                            " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " left join pos_sales_detail_konsinyasi sdk on psd.sales_detail_id = sdk.sales_detail_id " +
                            " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (" + DbSales.TYPE_CASH + "," + DbSales.TYPE_CREDIT + ") and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId + " and sdk.sales_detail_id is null ";
                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " union ";


                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name, 0 as qty_sold, sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ")as qty_ret " +
                            " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " left join pos_sales_detail_konsinyasi sdk on psd.sales_detail_id = sdk.sales_detail_id " +
                            " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (" + DbSales.TYPE_RETUR_CASH + "," + DbSales.TYPE_RETUR_CREDIT + ") and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId + " and sdk.sales_detail_id is null ";
                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " ) as x group by item_id ";

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

                    double tot3 = 0;
                    double tot9 = 0;

                    while (rs.next()) {

                        String itemName = "";
                        String sku = "";
                        double hargaBeli = 0;
                        long itemMasterId = 0;
                        double sold = 0;

                        try {
                            itemName = rs.getString("item_name");
                        } catch (Exception e) {
                        }

                        try {
                            sku = rs.getString("sku");
                        } catch (Exception e) {
                        }

                        try {
                            itemMasterId = rs.getLong("item_id");
                        } catch (Exception e) {
                        }

                        try {
                            sold = rs.getDouble("sold");
                        } catch (Exception e) {
                        }

                        xData++;

                        try {
                            hargaBeli = SessReportSales.getLastPrice(itemMasterId, invEndDate);
                            if (hargaBeli == 0) {
                                hargaBeli = SessReportSales.getLastHargaBeli(itemMasterId, invEndDate, vendorId);
                            }
                        } catch (Exception e) {
                        }


                        double sellingV = sold * hargaBeli;
                        String strSellingV = "";

                        if (sellingV < 0) {
                            strSellingV = "(" + JSPFormater.formatNumber(sellingV, "#,###.##") + ")";
                        } else {
                            strSellingV = JSPFormater.formatNumber(sellingV, "#,###.##");
                        }

                        tot3 = tot3 + sold;
                        tot9 = tot9 + sellingV;

                        String style = "";
                        if (xData % 2 == 0) {
                            style = "tablearialcell";
                        } else {
                            style = "tablearialcell1";
                        }

                                                                            %>
                                                                            <input type="hidden" name="item_id<%=xData%>" value="<%=itemMasterId%>">       
                                                                            <input type="hidden" name="cost<%=xData%>" value="<%=hargaBeli%>">
                                                                            <input type="hidden" name="sold<%=xData%>" value="<%=sold%>">
                                                                            <tr height="22"> 
                                                                                <td class="<%=style%>" align="center"><%=sku%></td>                                                                                                                                            
                                                                                <td class="<%=style%>" align="left" style="padding:3px;"><%=itemName%></td>
                                                                                <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(hargaBeli, "#,###.##")%></td>
                                                                                <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(sold, "#,###.##") %></td>                                                                                
                                                                                <td class="<%=style%>" align="right" style="padding:3px;"><%=strSellingV%></td>                                                                                
                                                                            </tr>    
                                                                            <%
                                                                                    }%>
                                                                            <input type="hidden" name="total_data" value="<%=xData%>">  
                                                                            <input type="hidden" name="total_amount" value="<%=tot9%>">
                                                                            <%if (xData > 0) {%>
                                                                            <tr height="22">                                                                                                                                             
                                                                                <td bgcolor="#CCCCCC" align="center" style="padding:3px;" colspan="3" class="fontarial"><B>GRAND TOTAL</B></td>
                                                                                <td bgcolor="#CCCCCC" style="padding:3px;" align="right" class="fontarial"><B><%=JSPFormater.formatNumber(tot3, "#,###.##")%></B></td>
                                                                                <%
    String strV = "";
    if (tot9 < 0) {
        tot9 = tot9 * -1;
        strV = "(" + JSPFormater.formatNumber(tot9, "#,###.##") + ")";
    } else {
        strV = JSPFormater.formatNumber(tot9, "#,###.##");
    }%>
                                                                                <td bgcolor="#CCCCCC" style="padding:3px;" align="right" class="fontarial"><B><%=strV%></B></td>                                                                                
                                                                            </tr>            
                                                                            <tr align="left" valign="top"> 
                                                                                <td colspan="15">&nbsp;</td>
                                                                            </tr>    
                                                                            <tr align="left" valign="top"> 
                                                                                <td colspan="15">
                                                                                    <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a>                                                                                                                                                                                                                               
                                                                                </td>     
                                                                            </tr>     
                                                                            <%}else{%>
                                                                            <tr align="left" valign="top" height="20"> 
                                                                                <td colspan="15" class="tablearialcell1" valign="middle">&nbsp;&nbsp;<i>Data not found</i></td>
                                                                            </tr>  
                                                                            
                                                                            <%}%>
                                                                            <%} catch (Exception e) {
                                                                                }%>
                                                                            <%


                                                                            } else {

                                                                                if (iJSPCommand == JSPCommand.SAVE) {
                                                                            %>
                                                                            <tr align="left" valign="top" height="20"> 
                                                                                <td colspan="15" class="tablearialcell1" valign="middle">&nbsp;&nbsp;<i>Data process complete</i></td>
                                                                            </tr>      
                                                                            
                                                                            <%} else {%>                         
                                                                            <tr align="left" valign="top" height="20"> 
                                                                                <td colspan="15" class="tablearialcell1" valign="middle">&nbsp;&nbsp;<i>Click search button to searching the data</i></td>
                                                                            </tr>                                                                             
                                                                            <%}
            }
                                                                            %>                                                                                                                                        
                                                                        </table>
                                                                    </td>
                                                                </tr>                                                                                                                            
                                                            </table>
                                                        </td>
                                                    </tr>                                                                                                                
                                                </table>
                                            </form>
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
