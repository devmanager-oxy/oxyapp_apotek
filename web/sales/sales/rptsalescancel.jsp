
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.posmaster.DbShift" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_CANCELED);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_CANCELED, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_SALES_CANCELED, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");

        ctrlist.addHeader("No", "5%");
        ctrlist.addHeader("Lokasi", "13%");
        ctrlist.addHeader("Faktur", "13%");
        ctrlist.addHeader("Tanggal", "10%");
        ctrlist.addHeader("Member", "15%");
        ctrlist.addHeader("Kasir", "10%");
        ctrlist.addHeader("Total", "10%");

        ctrlist.setLinkRow(2);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Sales sales = (Sales) objectClass.get(i);

            Vector rowx = new Vector();
            rowx.add("<div align=center>" + (i + 1) + "</div>");
            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(sales.getCurrencyId());
            } catch (Exception e) {
            }


            rowx.add("<div align=left>" + loc.getName() + "</div>");

            String str_dt_Date = "";
            try {
                Date dt_Date = sales.getDate();
                if (dt_Date == null) {
                    dt_Date = new Date();
                }
                str_dt_Date = JSPFormater.formatDate(dt_Date, "dd-MM-yyyy HH:mm");
            } catch (Exception e) {
                str_dt_Date = "";
            }

            rowx.add(sales.getNumber());
            rowx.add(str_dt_Date);
            rowx.add(sales.getName());

            User user = new User();
            try {
                user = DbUser.fetch(sales.getUserId());
            } catch (Exception e) {
            }

            rowx.add(String.valueOf(user.getLoginId()));
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(sales.getAmount(), "#,##0") + "</div>");

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(sales.getOID()));
        }

        return ctrlist.draw(index);
    }

    public static Vector getSalesAndDetail(long salesOid) {
        CONResultSet crs = null;
        Vector list = new Vector();
        try {
            String sql = "select * from pos_sales_cancel where sales_id=" + salesOid;

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            Sales sales = new Sales();
            while (rs.next()) {
                // get object sales
                sales = new Sales();
                sales.setOID(rs.getLong("sales_id"));
                sales.setNumber(rs.getString("number"));
                sales.setDate(rs.getDate("date"));
                sales.setType(rs.getInt("type"));
                sales.setName(rs.getString("name"));
                sales.setUserId(rs.getLong("user_id"));
                sales.setAmount(rs.getDouble("amount"));
                sales.setCurrencyId(rs.getLong("location_id"));
                sales.setCategoryId(rs.getLong("shift_id"));
                sales.setCustomerId(rs.getLong("customer_id"));
                sales.setEmployeeId(rs.getLong("cancelled_by"));
            }
            rs.close();

            // simpan object sales
            list.add(sales);

            sql = "select * from pos_sales_detail_cancel where sales_id=" + salesOid;
            crs = CONHandler.execQueryResult(sql);
            rs = crs.getResultSet();

            Vector item = new Vector();
            Vector listItem = new Vector();
            ItemMaster itemMaster = new ItemMaster();
            while (rs.next()) {
                item = new Vector();
                itemMaster = new ItemMaster();
                try {
                    itemMaster = DbItemMaster.fetchExc(rs.getLong("product_master_id"));
                } catch (Exception e) {
                }

                item.add(String.valueOf(itemMaster.getCode() + "/" + itemMaster.getBarcode()));
                item.add(String.valueOf(itemMaster.getName()));
                item.add(String.valueOf(rs.getDouble("selling_price")));
                item.add(String.valueOf(rs.getDouble("discount_amount")));
                item.add(String.valueOf(rs.getDouble("qty")));
                item.add(String.valueOf(rs.getDouble("total")));

                listItem.add(item);
            }

            // simpan data faktur detail 
            list.add(listItem);
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return list;
    }

    public static String getUser(long userId) {
        CONResultSet crs = null;
        String name = "";
        try {
            String sql = "select full_name from sysuser where user_id = " + userId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                name = rs.getString("full_name");
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return name;
    }

    public static String getCustomer(long customerId) {
        CONResultSet crs = null;
        String name = "";
        try {
            String sql = "select name from customer where customer_id = " + customerId;
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                name = rs.getString("name");
            }
        } catch (Exception e) {
        } finally {
            CONResultSet.close(crs);
        }
        return name;
    }

%>
<%

            Date invStartDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invStartDate"), "dd/MM/yyyy");
            Date invEndDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "invEndDate"), "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long salesOid = JSPRequestValue.requestLong(request, "hidden_sales_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            long oidPublic = 0;
            try {
                oidPublic = Long.parseLong(DbSystemProperty.getValueByName("OID_CUSTOMER_PUBLIC"));
            } catch (Exception e) {
            }

            if (session.getValue("REPORT_SALES_CANCEL") != null) {
                session.removeValue("REPORT_SALES_CANCEL");
            }

            if (session.getValue("REPORT_SALES_CANCEL_PARAMETER") != null) {
                session.removeValue("REPORT_SALES_CANCEL_PARAMETER");
            }

            Vector vLoc = userLocations;

            if (iJSPCommand == JSPCommand.NONE) {                
                if (vLoc.size() == totLocationxAll) {
                    locationId = 0;
                }else{                
                    try {
                        Location d = (Location) vLoc.get(0);
                        locationId = d.getOID();
                    } catch (Exception e) {
                    }
                }
            }

            if (invStartDate == null) {
                invStartDate = new Date();
            }

            if (invEndDate == null) {
                invEndDate = new Date();
            }

            Vector sessReport = new Vector();
            Vector sessReportParameter = new Vector();
            sessReportParameter.add(String.valueOf(sysCompany.getName()));
            sessReportParameter.add(String.valueOf(sysCompany.getAddress()));
            sessReportParameter.add(String.valueOf(locationId));
            sessReportParameter.add(String.valueOf(JSPFormater.formatDate(invStartDate, "dd/MM/yyyy")));
            sessReportParameter.add(String.valueOf(JSPFormater.formatDate(invEndDate, "dd/MM/yyyy")));
            session.putValue("REPORT_SALES_CANCEL_PARAMETER", sessReportParameter);
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdPrintJournalXls(){	                       
                window.open("<%=printroot%>.report.ReportSalesCancelXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdSearch(){
                    document.frmsales.command.value="<%=JSPCommand.SUBMIT%>";
                    document.frmsales.action="rptsalescancel.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsales.submit();
                }
                
                function cmdEdit(oidSales){
                    document.frmsales.hidden_sales_id.value=oidSales;
                    document.frmsales.command.value="<%=JSPCommand.LIST%>";
                    document.frmsales.prev_command.value="<%=prevJSPCommand%>";
                    document.frmsales.action="rptsalescancel.jsp";
                    document.frmsales.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/imagessl/home2.gif','<%=approot%>/imagessl/logout2.gif','../images/search2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenusl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/imagessl/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menusl.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
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
                                                                                                    <td> 
                                                                                                        <form name="frmsales" method ="post" action="">
                                                                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                                                                            <input type="hidden" name="start" value="<%=start%>">
                                                                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                                                                            <input type="hidden" name="hidden_sales_id" value="">
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                            <span class="lvl2">CANCELED SALES REPORT<br>
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
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8"  colspan="3" class="container"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                                                                    <table border="0" cellspacing="1" cellpadding="1">     
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="3" height="10"></td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr height="22"> 
                                                                                                                                            <td width="100" class="tablearialcell" style="padding:3px;" nowrap>Transaction Date</td>
                                                                                                                                            <td class="fontarial" width="2">:</td>
                                                                                                                                            <td width="450">
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td><input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                                                                                                                        <td class="fontarial">&nbsp;to&nbsp;</td>
                                                                                                                                                        <td><input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly></td>
                                                                                                                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="22"> 
                                                                                                                                            <td class="tablearialcell" style="padding:3px;" nowrap>Location</td>
                                                                                                                                            <td class="fontarial">:</td>
                                                                                                                                            <td >
                                                                                                                                                <select name="src_location_id" class="fontarial">
                                                                                                                                                    <%if (vLoc.size() == totLocationxAll) {%>
                                                                                                                                                    <option value="0">< All Location ></option>
                                                                                                                                                    <%}%>
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
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="3">
                                                                                                                                                <tr>
                                                                                                                                                    <td colspan="4">
                                                                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                                                                            <tr>
                                                                                                                                                                <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                                            </tr>
                                                                                                                                                        </table>
                                                                                                                                                    </td>
                                                                                                                                                </tr>
                                                                                                                                            </td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="2">&nbsp;</td>
                                                                                                                                            <td ><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                                            
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%
            if (salesOid != 0) {
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"><%@ include file="rptsalescanceldetail.jsp"%></td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td> 
                                                                                                                            </tr>
                                                                                                                            <%
            }
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td> 
                                                                                                                            </tr>
                                                                                                                            
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="23">
                                                                                                                                            <td class="tablearialhdr" width="25">No</td>
                                                                                                                                            <td class="tablearialhdr" width="130">Number</td>  
                                                                                                                                            <td class="tablearialhdr" >Location</td>
                                                                                                                                            <td class="tablearialhdr" width="80">Date</td>                                                                                            
                                                                                                                                            <td class="tablearialhdr" width="150">Member</td>  
                                                                                                                                            <td class="tablearialhdr" width="180">Cashier</td>
                                                                                                                                            <td class="tablearialhdr" width="80">Total</td>
                                                                                                                                            <td class="tablearialhdr" width="180">Approved By</td>
                                                                                                                                        </tr>    
                                                                                                                                        <%

            CONResultSet crs = null;
            long tmp = 0;
            try {
                String where = " c.date between '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59' ";

                if (locationId != 0) {
                    where = where + " and c.location_id = " + locationId;
                }

                String sql = "select location_id,location,sales_id,customer_id,type,date,number,user_id,cancelled_by,sum(total) as grand_total from (" +
                        " select l.location_id as location_id,l.name as location,c.sales_id as sales_id ,c.customer_id as customer_id,c.type as type,c.date as date,c.number as number,c.user_id as user_id,c.cancelled_by as cancelled_by,0 as total from pos_sales_cancel c left join pos_sales_detail_cancel cd on c.sales_id = cd.sales_id inner join pos_location l on c.location_id = l.location_id where cd.sales_id is null and " + where + " group by c.sales_id union " +
                        " select l.location_id as location_id,l.name as location,c.sales_id as sales_id ,c.customer_id as customer_id,c.type as type,c.date as date,c.number as number,c.user_id as user_id,c.cancelled_by as cancelled_by,sum((cd.selling_price * cd.qty)-cd.discount_amount) as total from pos_sales_cancel c inner join pos_sales_detail_cancel cd on c.sales_id = cd.sales_id inner join pos_location l on c.location_id = l.location_id where c.type in (0,1) and " + where + " group by c.sales_id union " +
                        " select l.location_id as location_id,l.name as location,c.sales_id as sales_id ,c.customer_id as customer_id,c.type as type,c.date as date,c.number as number,c.user_id as user_id,c.cancelled_by as cancelled_by,sum((cd.selling_price * cd.qty)-cd.discount_amount)*-1 as total from pos_sales_cancel c inner join pos_sales_detail_cancel cd on c.sales_id = cd.sales_id inner join pos_location l on c.location_id = l.location_id where c.type in (2,3) and " + where + " group by c.sales_id ) as x group by sales_id order by location,date,number ";

                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();

                int no = 1;
                double totalSub = 0;
                double totalGrand = 0;
                while (rs.next()) {

                    String style = "";
                    if (no % 2 == 0) {
                        style = "tablearialcell1";
                    } else {
                        style = "tablearialcell";
                    }
                    long salesId = rs.getLong("sales_id");
                    String number = rs.getString("number");
                    double subTotal = rs.getDouble("grand_total");
                    String location = rs.getString("location");
                    Date dt = rs.getDate("date");
                    long customerId = rs.getLong("customer_id");
                    long userId = rs.getLong("user_id");
                    long cancelBy = rs.getLong("cancelled_by");
                    long locId = rs.getLong("location_id");
                    Vector tmpReport = new Vector();

                    tmpReport.add(String.valueOf(salesId));// 0
                    tmpReport.add(String.valueOf(number));// 1
                    tmpReport.add(String.valueOf(locId));// 2
                    tmpReport.add(String.valueOf(location));// 3
                    tmpReport.add(String.valueOf(JSPFormater.formatDate(dt, "dd/MM/yyyy")));// 4

                    if (tmp != 0 && tmp != locId) {%>
                                                                                                                                        <tr height="23">
                                                                                                                                            <td colspan="6" bgcolor="#cccccc" class="fontarial" align="center"><b><i>Sub Total</i></b></td>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><b><i><%=JSPFormater.formatNumber(totalSub, "###,###.##") %></i></b></td>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial">&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="23">
                                                                                                                                            <td colspan="8">&nbsp;</td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr height="23">
                                                                                                                                            <td class="tablearialhdr" width="25">No</td>
                                                                                                                                            <td class="tablearialhdr" width="130">Number</td>  
                                                                                                                                            <td class="tablearialhdr" >Location</td>
                                                                                                                                            <td class="tablearialhdr" width="80">Date</td>                                                                                            
                                                                                                                                            <td class="tablearialhdr" width="150">Member</td>  
                                                                                                                                            <td class="tablearialhdr" width="180">Cashier</td>
                                                                                                                                            <td class="tablearialhdr" width="80">Total</td>
                                                                                                                                            <td class="tablearialhdr" width="180">Approved By</td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
                                                                                                                                                                totalSub = 0;
                                                                                                                                                            }


                                                                                                                                                            String cstName = "";
                                                                                                                                                            String cashier = "";
                                                                                                                                                            String approved = "";

                                                                                                                                                            if (customerId == oidPublic) {
                                                                                                                                                                cstName = "Public";
                                                                                                                                                            } else {
                                                                                                                                                                try {
                                                                                                                                                                    cstName = getCustomer(customerId);
                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                }
                                                                                                                                                            }

                                                                                                                                                            try {
                                                                                                                                                                cashier = getUser(userId);
                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                            }

                                                                                                                                                            try {
                                                                                                                                                                approved = getUser(cancelBy);
                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                            }

                                                                                                                                                            tmpReport.add(String.valueOf(cstName));// 5
                                                                                                                                                            tmpReport.add(String.valueOf(cashier));// 6
                                                                                                                                                            tmpReport.add(String.valueOf(subTotal));// 7
                                                                                                                                                            tmpReport.add(String.valueOf(approved));// 8
                                                                                                                                                            sessReport.add(tmpReport);
                                                                                                                                        %>
                                                                                                                                        <tr height="22">
                                                                                                                                            <td class="<%=style%>" align="center"><%=no%></td>
                                                                                                                                            <td class="<%=style%>" align="center"><a href="javascript:cmdEdit('<%=salesId%>')"><%=number%></td>        
                                                                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=location %></td>
                                                                                                                                            <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(dt, "yyyy-MM-dd") %></td>                                           
                                                                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=cstName%></td>
                                                                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=cashier%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(subTotal, "###,###.##")%></td>
                                                                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><%=approved%></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
                                                                                                                                                            no++;
                                                                                                                                                            tmp = locId;
                                                                                                                                                            totalSub = totalSub + subTotal;
                                                                                                                                                            totalGrand = totalGrand + subTotal;
                                                                                                                                                        }%>
                                                                                                                                        <tr height="23">
                                                                                                                                            <td colspan="6" bgcolor="#cccccc" class="fontarial" align="center"><b><i>Sub Total</i></b></td>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><b><i><%=JSPFormater.formatNumber(totalSub, "###,###.##") %></i></b></td>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial">&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="8">&nbsp;</td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr height="23">
                                                                                                                                            <td colspan="6" bgcolor="#cccccc" class="fontarial" align="center"><b><i>Grand Total</i></b></td>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial" align="right" style="padding:3px;"><b><i><%=JSPFormater.formatNumber(totalGrand, "###,###.##") %></i></b></td>
                                                                                                                                            <td bgcolor="#cccccc" class="fontarial">&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <%


                session.putValue("REPORT_SALES_CANCEL", sessReport);
            } catch (Exception e) {
            }




                                                                                                                                        %>
                                                                                                                                        <%if (privPrint) {%>
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="8">
                                                                                                                                                <a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print1','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print1" height="22" border="0"></a>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <%}%>                                                                                                                                        
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="8" align="left" colspan="3" class="command"> 
                                                                                                                                    <span class="command"> 
                                                                                                                                </span></td>
                                                                                                                            </tr>
                                                                                                                            
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="8" valign="middle" colspan="3">&nbsp; 
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    <!-- #EndEditable --> </td>
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
                            <td height="25"> <!-- #BeginEditable "footer" --> 
            <%@ include file="../main/footersl.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>

