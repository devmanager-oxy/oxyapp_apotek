
<%-- 
    Document   : addstockcode
    Created on : Des 08, 2011, 1:22:20 PM
    Author     : Ngurah
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.main.db.*" %> 
<%@ page import = "java.util.Date" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.transfer.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.repack.*" %>
<%@ page import = "com.project.ccs.postransaction.costing.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.adjusment.*" %>
<%@ page import = "com.project.ccs.postransaction.opname.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<!-- Jsp Block -->
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_CARD);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_CARD, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_RETAIL_REPORT, AppMenu.M2_STOCK_CARD, AppMenu.PRIV_PRINT);
%>
<%!
    public Vector drawList(Vector objectClass, int start, double stockprev) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("No", "5%");
        cmdist.addHeader("Date", "10%");
        cmdist.addHeader("Doc Number", "10%");
        cmdist.addHeader("Description", "35%");
        cmdist.addHeader("Status", "10%");
        cmdist.addHeader("Qty In", "10%");
        cmdist.addHeader("Qty Out", "10%");
        cmdist.addHeader("Qty Saldo", "10%");

        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        Vector temp = new Vector();
        double qtyIn = 0;
        double qtySaldo = 0;
        qtySaldo = stockprev;

        Vector rowx1 = new Vector();
        rowx1.add("");
        rowx1.add("");
        rowx1.add("");
        rowx1.add("STOCK BEFORE");
        rowx1.add("");
        rowx1.add("");
        rowx1.add("");
        rowx1.add("" + stockprev);
        lstData.add(rowx1);

        for (int i = 0; i < objectClass.size(); i++) {

            Stock st = (Stock) objectClass.get(i);
            Vector rowx = new Vector();
            rowx.add("<div align=\"center\">" + (i + 1 + start) + "</div>");
            rowx.add("" + JSPFormater.formatDate(st.getDate(), "dd-MM-yyyy"));

            switch (st.getType()) {
                case 0:
                    try {
                        Receive rec = new Receive();
                        try {
                            rec = DbReceive.fetchExc(st.getIncomingId());
                        } catch (Exception ex) {

                        }

                        rowx.add("" + rec.getNumber());
                        Vendor ven = new Vendor();
                        try {
                            ven = DbVendor.fetchExc(rec.getVendorId());
                        } catch (Exception ex) {

                        }

                        rowx.add("Incoming from " + ven.getName());

                    } catch (Exception ex) {

                    }
                    break;
                case 1:
                    try {
                        Retur ret = new Retur();
                        try {
                            ret = DbRetur.fetchExc(st.getReturId());
                        } catch (Exception ex) {

                        }

                        rowx.add("" + ret.getNumber());
                        Vendor ven = new Vendor();
                        try {
                            ven = DbVendor.fetchExc(ret.getVendorId());
                        } catch (Exception ex) {

                        }

                        rowx.add("Retur to " + ven.getName());

                    } catch (Exception ex) {

                    }
                    break;

                case 2:
                    try {
                        Transfer tr = new Transfer();
                        try {
                            tr = DbTransfer.fetchExc(st.getTransferId());
                        } catch (Exception ex) {

                        }


                        rowx.add("" + tr.getNumber());
                        Location loc = new Location();
                        try {
                            loc = DbLocation.fetchExc(tr.getToLocationId());
                        } catch (Exception ex) {

                        }

                        rowx.add(" Transfer out to " + loc.getName());


                    } catch (Exception ex) {

                    }

                    break;

                case 3:
                    try {
                        Transfer tr = new Transfer();
                        try {
                            tr = DbTransfer.fetchExc(st.getTransferId());
                        } catch (Exception ex) {

                        }
                        rowx.add("" + tr.getNumber());
                        Location loc = new Location();
                        try {
                            loc = DbLocation.fetchExc(tr.getFromLocationId());
                        } catch (Exception ex) {

                        }

                        rowx.add(" Transfer in from " + loc.getName());


                    } catch (Exception ex) {

                    }
                    break;

                case 4:
                    try {
                        Adjusment ad = new Adjusment();

                        try {
                            ad = DbAdjusment.fetchExc(st.getAdjustmentId());
                        } catch (Exception ex) {

                        }

                        rowx.add("" + ad.getNumber());
                        if (st.getOpnameId() != 0) {
                            Opname op = new Opname();
                            try {
                                op = DbOpname.fetchExc(st.getOpnameId());
                            } catch (Exception ex) {

                            }
                            rowx.add("adjusment from opname " + op.getNumber());
                        } else {
                            rowx.add("adjusment");
                        }


                    } catch (Exception ex) {

                    }
                    break;

                case 5:
                    try {
                        Adjusment ad = new Adjusment();

                        try {
                            ad = DbAdjusment.fetchExc(st.getAdjustmentId());
                        } catch (Exception ex) {

                        }

                        rowx.add("" + ad.getNumber());
                        rowx.add("opname awal");

                    } catch (Exception ex) {

                    }

                    break;
                case 7:
                    try {
                        Sales sl = new Sales();
                        try {
                            sl = DbSales.fetchExc(st.getOpnameId());
                        } catch (Exception ex) {
                            System.out.println(ex.toString());
                        }

                        rowx.add("" + getNumber(st.getOpnameId()));//sl.getNumber());

                        if (sl.getType() == DbSales.TYPE_CASH) {
                            rowx.add("Cash Sales");
                        } else if (sl.getType() == DbSales.TYPE_CREDIT) {
                            rowx.add("Credit Sales");
                        } else if (sl.getType() == DbSales.TYPE_RETUR_CASH) {
                            rowx.add("Retur Cash Sales");
                        } else if (sl.getType() == DbSales.TYPE_RETUR_CREDIT) {
                            rowx.add("Retur Credit Sales");
                        }

                    } catch (Exception ex) {

                    }

                    break;
                case 8:
                    try {
                        Costing cs = new Costing();
                        try {
                            cs = DbCosting.fetchExc(st.getCostingId());
                        } catch (Exception ex) {
                        }

                        rowx.add("" + cs.getNumber());
                        rowx.add("Costing");

                    } catch (Exception ex) {
                    }

                    break;
                case 9:
                    try {
                        Repack rp = new Repack();

                        try {
                            rp = DbRepack.fetchExc(st.getRepackId());
                        } catch (Exception ex) {

                        }
                        rowx.add("" + rp.getNumber());
                        if ((st.getQty() * st.getInOut()) < 0) {
                            rowx.add("Repack out");
                        } else {
                            rowx.add("Repack in");
                        }

                    } catch (Exception ex) {

                    }
                    break;
                case 10:
                    try {
                        Receive rp = new Receive();

                        try {
                            rp = DbReceive.fetchExc(st.getIncomingId());
                        } catch (Exception ex) {

                        }
                        rowx.add("" + rp.getNumber());
                        if ((st.getQty() * st.getInOut()) < 0) {
                            rowx.add("inc adjusment out");
                        } else {
                            rowx.add("inc adjusment in");
                        }

                    } catch (Exception ex) {

                    }
                    break;
                default:
                    break;
            }

            rowx.add("" + st.getStatus());
            if ((st.getQty() * st.getInOut()) < 0) {
                rowx.add("");
                rowx.add("" + (-1 * st.getQty() * st.getInOut()));
            } else {
                rowx.add("" + st.getQty() * st.getInOut());
                rowx.add("");
            }

            qtySaldo = qtySaldo + (st.getQty() * st.getInOut());
            rowx.add("" + JSPFormater.formatNumber(qtySaldo, "###,###.##"));


            lstData.add(rowx);
            temp.add(st);
            lstLinkData.add(String.valueOf(st.getItemMasterId()));

        }

        Vector rowx = new Vector();
        rowx.add("");
        rowx.add("");
        rowx.add("");
        rowx.add("");
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

    public Date getDateTime(long stockId) {
        Date dt = new Date();
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT date FROM pos_stock where stock_id=" + stockId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Date dtx = rs.getDate(1);
                Date tmx = rs.getTime(1);
                dt.setDate(dtx.getDate());
                dt.setMonth(dtx.getMonth());
                dt.setYear(dtx.getYear());
                dt.setHours(tmx.getHours());
                dt.setMinutes(tmx.getMinutes());
                dt.setSeconds(tmx.getSeconds());

            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);

        }

        return dt;

    }

    public String getNumber(long salesId) {

        String number = "";

        if (salesId != 0) {

            String sql = "select number  from pos_sales where sales_id=" + salesId;

            CONResultSet crs = null;
            Vector list = new Vector();
            try {
                crs = CONHandler.execQueryResult(sql);
                ResultSet rs = crs.getResultSet();
                while (rs.next()) {
                    number = rs.getString(1);
                }
            } catch (Exception e) {
                System.out.println(e.toString());
            } finally {
                CONResultSet.close(crs);
            }


        }
        return number;

    }

    public static double getTotalStockPrev(long locationId, long itemOID, Date dt) {


        String sql = " select sum(qty * in_out) from pos_stock where item_master_id=" + itemOID + "" +
                " and location_id=" + locationId + " and status='APPROVED'" +
                " and to_days(date)<to_days('" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "')";

        double result = 0;

        CONResultSet crs = null;
        try {
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while (rs.next()) {
                result = rs.getDouble(1);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

%>
<%

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            long locationId = JSPRequestValue.requestLong(request, "locationId");
            long itemMasterId = JSPRequestValue.requestLong(request, "itemMasterId");
            int type_item = JSPRequestValue.requestInt(request, "type_item");
            String startDate = JSPRequestValue.requestString(request, "src_start_date");
            String endDate = JSPRequestValue.requestString(request, "src_end_date");

            if (session.getValue("RPT_DETAIL_STOCK_CARD") != null) {
                session.removeValue("RPT_DETAIL_STOCK_CARD");
            }
            if (session.getValue("RPT_PARAMETER_DETAIL_STOCK_CARD") != null) {
                session.removeValue("RPT_PARAMETER_DETAIL_STOCK_CARD");
            }

            Location location = new Location();
            ItemMaster itemMaster = new ItemMaster();

            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            ReportStockParameter rsp = new ReportStockParameter();
            rsp.setLocationId(locationId);
            rsp.setItemMasterId(itemMasterId);

            if (startDate != "") {
                srcStartDate = JSPFormater.formatDate(startDate, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(endDate, "dd/MM/yyyy");
            }
            rsp.setStartDate(srcStartDate);
            rsp.setEndDate(srcEndDate);

            double stockPrev = 0;
            try {
                stockPrev = DbStock.getTotalStockPrev(locationId, itemMasterId, srcStartDate);            
            } catch (Exception e) {
            }

            rsp.setAmount(stockPrev);

            Vector vstockDetail = new Vector();
            vstockDetail = DbStock.list(0, 0, " to_days(date) between to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "') and to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "') and item_master_id=" + itemMasterId + " and location_id=" + locationId, "date");

            session.putValue("RPT_PARAMETER_DETAIL_STOCK_CARD", rsp);
            session.putValue("RPT_DETAIL_STOCK_CARD", vstockDetail);

            if (srcStartDate != srcEndDate) {
                int i = 0;
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=titleIS%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <style type="text/css">
            .style1 {color: #FF0000}
        </style>
        <script language="JavaScript">
            <%if (!priv || !privView) {%> 
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintXLS(){	 
                window.open("<%=printroot%>.report.ReportStockCardDetailMixXLS?idx=<%=System.currentTimeMillis()%>");
                }
                
                function cmdShowStockCode(){                   
                    document.frmstockcardDetailCons.command.value="<%=JSPCommand.LIST%>";
                    document.frmstockcardDetailCons.action="stock-card-detail-Non-Consigment.jsp";
                    document.frmstockcardDetailCons.submit();
                }
                function cmdShowSumary(){                   
                    document.frmstockcardDetailCons.command.value="<%=JSPCommand.NONE%>";
                    document.frmstockcardDetailCons.action="stock-card-detail-Non-Consigment.jsp";
                    document.frmstockcardDetailCons.submit();
                }
                //-------------- script form image -------------------
                function cmdDelPict(oidCashReceiveDetail){
                    document.frmaddstockcode.hidden_cash_receive_detail_id.value=oidCashReceiveDetail;
                    document.frmaddstockcode.command.value="<%=JSPCommand.POST%>";
                    document.frmaddstockcode.action="stock-card-detail-Non-Consigment.jsp";
                    document.frmaddstockcode.submit();
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
    <body> 
        <table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
            <form name="frmstockcardDetailCons" method ="post" action="">
                <input type="hidden" name="command" value="<%=iJSPCommand%>">
                <input type="hidden" name="locationId" value="<%=locationId%>">
                <input type="hidden" name="type_item" value="<%=type_item%>">
                <input type="hidden" name="OID_STOCK_CODE" value="">
                <input type="hidden" name="src_start_date" value="<%=startDate%>">
                <input type="hidden" name="src_end_date" value="<%=endDate%>">
                <input type="hidden" name="itemMasterId" value="<%=itemMasterId%>">                            
                <tr>
                    <td colspan="2" height="10"></td>
                </tr>
                <%
            try {
                location = DbLocation.fetchExc(locationId);
                itemMaster = DbItemMaster.fetchExc(itemMasterId);
            } catch (Exception e) {

            }
                %>
                
                
                <tr> 
                    <td colspan="2"> 
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr> 
                                <td  height="20" width="20%"><b>STOCK CARD</b></td>
                                <td  height="20"  width="2%" align="left">&nbsp;</td>
                                <td  height="20" align="left" width="75%">&nbsp;</td>
                            </tr>
                            <tr> 
                                <td  height="20" width="20%"><b>Location Name</b></td>
                                <td  height="20"  width="2%" align="left"><b>:</b></td>
                                <td  height="20" align="left" width="75%"><%=location.getName()%> </td>
                            </tr>
                            <tr> 
                                <td  height="20" width="20%"><b>Code</b></td>
                                <td  height="20" width="2%" align="left"><b>:</b></td>
                                <td  height="20" align="left" width="75%"><%=itemMaster.getCode()%></td>
                            </tr>
                            <tr> 
                                <td  height="20" width="20%"><b>Barcode</b></td>
                                <td  height="20" width="2%" align="left"><b>:</b></td>
                                <td  height="20" align="left" width="75%"><%=itemMaster.getBarcode()%></td>
                            </tr>
                            <tr> 
                                <td  height="20" width="20%"><b>Item Name</b></td>
                                <td  height="20" width="2%" align="left"><b>:</b></td>
                                <td  height="20" align="left" width="75%"><%=itemMaster.getName()%> </td>
                            </tr>
                            <%
            String strPeriode = "" + JSPFormater.formatDate(srcStartDate, "dd MMM yyyy") + " to " + JSPFormater.formatDate(srcEndDate, "dd MMM yyyy");
                            %>
                            <tr> 
                                <td  height="20" width="20%"><b>Periode</b></td>
                                <td  height="20" width="2%" align="left"><b>:</b></td>
                                <td  height="20" align="left" width="75%"><%=strPeriode%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" height="15"></td>
                </tr>                
                <tr> 
                    <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                </tr>
                <tr>
                    <td colspan="2" height="15"></td>
                </tr>
                <%
            if (vstockDetail != null) {
                int pg = 1;
                %>
                <tr>
                    <td colspan="2">
                        <table width="100%" border="0" cellpadding="0" cellspacing="1">
                            <tr>
                                <td>
                                    <%
                    Vector x = drawList(vstockDetail, 0, stockPrev);
                    String strTampil = (String) x.get(0);
                    Vector rptObj = (Vector) x.get(1);
                                    %>
                                    <%=strTampil%>
                                </td>
                            </tr> 
                        </table>    
                    </td>
                </tr>
                <tr> 
                    <td colspan="2">
                        <%if ((itemMaster.getApplyStockCode() != DbItemMaster.NON_APPLY_STOCK_CODE) || (itemMaster.getApplyStockCodeSales() != DbItemMaster.NON_APPLY_STOCK_CODE_SALES)) {%>
                        <table width="100%" border="0" cellpadding="0" cellspacing="1">   
                            <tr>
                                <td width="15%"><a href="javascript:cmdShowStockCode()"> Preview Serial Number</a></td>
                                <td width="15%"><a href="javascript:cmdShowSumary()"> Preview Summary</a></td>
                            </tr  
                        ></table>
                        <%}%>
                    </td>
                </tr>  
                <%}%>
                <tr>
                    <td colspan="2" height="10"></td>
                </tr>
                <%if (privPrint) {%>
                <tr>
                    <td colspan="2" height="10">
                        <a href="javascript:cmdPrintXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print2" height="22" border="0"></a>
                    </td>
                </tr>
                <%}%>
                <tr>
                    <td colspan="2" height="10"></td>
                </tr>
                <tr> 
                    <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                </tr>
                <tr>
                    <td colspan="2" height="15"></td>
                </tr>
            </form>
            <tr height = "40px">
                <td>&nbsp;</td>
            </tr>
        </table>
    </body>
</html>
