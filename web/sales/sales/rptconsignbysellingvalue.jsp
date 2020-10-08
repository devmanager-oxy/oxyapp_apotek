
<%-- 
    Document   : rptconsignbysellingvalue
    Created on : Jan 7, 2013, 11:46:03 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_JUAL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_JUAL, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_JUAL, AppMenu.PRIV_PRINT);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_JUAL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_JUAL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_JUAL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%

            if (session.getValue("REPORT_KONSINYASI_PRICE") != null) {
                session.removeValue("REPORT_KONSINYASI_PRICE");
            }

            if (session.getValue("REPORT_KONSINYASI_RESULT") != null) {
                session.removeValue("REPORT_KONSINYASI_RESULT");
            }

            if (session.getValue("REPORT_KONSINYASI_BEGIN") != null) {
                session.removeValue("REPORT_KONSINYASI_BEGIN");
            }

            if (session.getValue("REPORT_KONSINYASI_RECEIVE") != null) {
                session.removeValue("REPORT_KONSINYASI_RECEIVE");
            }

            if (session.getValue("REPORT_KONSINYASI_SOLD") != null) {
                session.removeValue("REPORT_KONSINYASI_SOLD");
            }

            if (session.getValue("REPORT_KONSINYASI_RETUR") != null) {
                session.removeValue("REPORT_KONSINYASI_RETUR");
            }

            if (session.getValue("REPORT_KONSINYASI_TRANS_IN") != null) {
                session.removeValue("REPORT_KONSINYASI_TRANS_IN");
            }

            if (session.getValue("REPORT_KONSINYASI_TRANS_OUT") != null) {
                session.removeValue("REPORT_KONSINYASI_TRANS_OUT");
            }

            if (session.getValue("REPORT_KONSINYASI_ADJ") != null) {
                session.removeValue("REPORT_KONSINYASI_ADJ");
            }

            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            int chkInvDate = 0;
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");

            Vector result = new Vector();
            Hashtable sBegin = new Hashtable();
            Hashtable sReceive = new Hashtable();
            Hashtable sSold = new Hashtable();
            Hashtable sRetur = new Hashtable();
            Hashtable sTransIn = new Hashtable();
            Hashtable sTransOut = new Hashtable();
            Hashtable sAdjustment = new Hashtable();

            Vendor vendor = new Vendor();
            try {
                if (vendorId != 0) {
                    vendor = DbVendor.fetchExc(vendorId);
                }
            } catch (Exception e) {
            }

            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.POST) {
                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setIgnore(chkInvDate);
                rp.setVendorId(vendorId);

                session.putValue("REPORT_KONSINYASI_PRICE", rp);

                result = SessReportSales.reportItemConsignedBySelling(vendorId);
                sBegin = SessReportSales.reportConsignedByCostBeginingSelling(invStartDate, chkInvDate, vendorId, locationId);
                sReceive = SessReportSales.reportConsignedBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_INCOMING_GOODS, locationId);
                sSold = SessReportSales.reportConsignedBySellingPosSales(invStartDate, invEndDate, chkInvDate, vendorId, locationId);
                sRetur = SessReportSales.reportConsignedBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_RETUR_GOODS, locationId);
                sTransIn = SessReportSales.reportConsignedBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_TRANSFER_IN, locationId);
                sTransOut = SessReportSales.reportConsignedBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_TRANSFER, locationId);
                sAdjustment = SessReportSales.reportConsignedBySelling(invStartDate, invEndDate, chkInvDate, vendorId, DbStock.TYPE_ADJUSTMENT, locationId);

                session.putValue("REPORT_KONSINYASI_RESULT", result);
                session.putValue("REPORT_KONSINYASI_BEGIN", sBegin);
                session.putValue("REPORT_KONSINYASI_RECEIVE", sReceive);
                session.putValue("REPORT_KONSINYASI_SOLD", sSold);
                session.putValue("REPORT_KONSINYASI_RETUR", sRetur);
                session.putValue("REPORT_KONSINYASI_TRANS_IN", sTransIn);
                session.putValue("REPORT_KONSINYASI_TRANS_OUT", sTransOut);
                session.putValue("REPORT_KONSINYASI_ADJ", sAdjustment);

                if (iJSPCommand == JSPCommand.POST) {
                    double amountPromotion = JSPRequestValue.requestDouble(request, "hidden_promotion");
                    double amountBarcode = JSPRequestValue.requestDouble(request, "hidden_barcode");

                    String name = "";
                    if (vendorId != 0) {
                        try {
                            Vendor v = DbVendor.fetchExc(vendorId);
                            if (v.getName() != null && v.getName().length() > 0) {
                                name = ", Suplier :" + v.getName();
                            }
                        } catch (Exception e) {
                        }
                    }

                    Periode opnPeriode = DbPeriode.getPeriodByTransDate(invEndDate);
                    if (opnPeriode.getOID() != 0 && opnPeriode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0 && (amountPromotion != 0 || amountBarcode != 0)) {
                        MemorialKonsinyasi memorial = new MemorialKonsinyasi();
                        memorial.setStartDate(invStartDate);
                        memorial.setEndDate(invEndDate);
                        memorial.setVendorId(vendorId);
                        memorial.setLocationId(locationId);
                        memorial.setCreateDate(new Date());
                        memorial.setUserId(user.getOID());
                        memorial.setType(DbMemorialKonsinyasi.TYPE_CONSIGNED_BY_PRICE);
                        try {
                            String where = DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_VENDOR_ID] + "=" + vendorId + " and " + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_LOCATION_ID] + "=" + locationId + " and (" + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_START_DATE] + " between '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 23:59:59') and " +
                                    " (" + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_END_DATE] + " between '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59') ";

                            int count = DbMemorialKonsinyasi.getCount(where);
                            long oidMemorial = 0;
                            if (count == 0) {
                                oidMemorial = DbMemorialKonsinyasi.insertExc(memorial);
                            }

                            if (oidMemorial != 0) {
                                long oidCoaBarcode = 0;
                                long oidCoaPromotion = 0;
                                long oidHutangTrade = 0;

                                try {
                                    oidCoaBarcode = Long.parseLong(String.valueOf(DbSystemProperty.getValueByName("OID_COA_BARCODE")));
                                } catch (Exception e) {
                                    oidCoaBarcode = 0;
                                }

                                try {
                                    oidCoaPromotion = Long.parseLong(String.valueOf(DbSystemProperty.getValueByName("OID_COA_PROMOTION")));
                                } catch (Exception e) {
                                    oidCoaPromotion = 0;
                                }

                                try {
                                    oidHutangTrade = Long.parseLong(String.valueOf(DbSystemProperty.getValueByName("OID_COA_HUTANG_TRADE")));
                                } catch (Exception e) {
                                    oidHutangTrade = 0;
                                }

                                long oidItemDmm = 0;
                                long oidUom = 0;
                                long currencyId = 0;

                                try {
                                    oidItemDmm = Long.parseLong(DbSystemProperty.getValueByName("OID_ITEM_MEMO"));
                                } catch (Exception e) {
                                }

                                try {
                                    oidUom = Long.parseLong(DbSystemProperty.getValueByName("OID_UOM_MEMO"));
                                } catch (Exception e) {
                                }


                                try {
                                    currencyId = Long.parseLong(DbSystemProperty.getValueByName("OID_CURRENCY_RP"));
                                } catch (Exception e) {
                                }

                                String note = "";
                                if (oidCoaPromotion != 0 && amountPromotion != 0) {
                                    Coa cPromotion = new Coa();
                                    try {
                                        cPromotion = DbCoa.fetchExc(oidCoaPromotion);
                                        if (cPromotion.getOID() != 0) {
                                            MemorialKonsinyasiDetail md = new MemorialKonsinyasiDetail();
                                            md.setMemorialKonsinyasiId(oidMemorial);
                                            md.setAmount(amountPromotion);
                                            md.setCoaId(cPromotion.getOID());
                                            md.setNote("Promotion ");
                                            if (note != null && note.length() > 0) {
                                                note = note + "/Promotion";
                                            }
                                            try {
                                                DbMemorialKonsinyasiDetail.insertExc(md);
                                            } catch (Exception e) {
                                            }
                                        }
                                    } catch (Exception e) {
                                    }
                                }


                                if (oidCoaBarcode != 0 && amountBarcode != 0) {
                                    Coa cBarcode = new Coa();
                                    try {
                                        cBarcode = DbCoa.fetchExc(oidCoaBarcode);
                                        if (cBarcode.getOID() != 0) {
                                            MemorialKonsinyasiDetail md = new MemorialKonsinyasiDetail();
                                            md.setMemorialKonsinyasiId(oidMemorial);
                                            md.setAmount(amountBarcode);
                                            md.setCoaId(cBarcode.getOID());
                                            md.setNote("Barcode ");
                                            if (note != null && note.length() > 0) {
                                                note = note + "/Barcode";
                                            }
                                            try {
                                                DbMemorialKonsinyasiDetail.insertExc(md);
                                            } catch (Exception e) {
                                            }
                                        }
                                    } catch (Exception e) {
                                    }
                                }

                                if (oidHutangTrade != 0) {

                                    Vector listDetail = DbMemorialKonsinyasiDetail.list(0, 0, DbMemorialKonsinyasiDetail.colNames[DbMemorialKonsinyasiDetail.CL_MEMORIAL_KONSINYASI_ID] + " = " + oidMemorial, null);
                                    if (listDetail != null && listDetail.size() > 0) {

                                        if (opnPeriode.getOID() != 0) {
                                            Receive r = new Receive();
                                            r.setApproval1(user.getOID());
                                            r.setApproval3(user.getOID());
                                            r.setStatus("CHECKED");
                                            r.setNote(note + "" + name);
                                            r.setPaymentType("Cash");
                                            r.setLocationId(locationId);
                                            r.setUserId(user.getOID());
                                            Date dt = new Date();
                                            int periodeTaken = 0;
                                            try {
                                                periodeTaken = Integer.parseInt(DbSystemProperty.getValueByName("PERIODE_TAKEN"));
                                            } catch (Exception e) {
                                            }

                                            if (periodeTaken == 0) {
                                                dt = opnPeriode.getStartDate();  // untuk mendapatkan periode yang aktif
                                            } else if (periodeTaken == 1) {
                                                dt = opnPeriode.getEndDate();  // untuk mendapatkan periode yang aktif
                                            }

                                            String formatDocCode = "";
                                            int counter = 0;

                                            formatDocCode = DbSystemDocNumber.getNumberPrefixApMemo(opnPeriode.getOID());
                                            counter = DbSystemDocNumber.getNextCounterApMemo(opnPeriode.getOID());

                                            r.setCounter(counter);
                                            r.setPrefixNumber(formatDocCode);

                                            // proses untuk object ke general penanpungan code
                                            SystemDocNumber systemDocNumber = new SystemDocNumber();
                                            systemDocNumber.setCounter(counter);
                                            systemDocNumber.setDate(new Date());
                                            systemDocNumber.setPrefixNumber(formatDocCode);
                                            systemDocNumber.setType(DbSystemDocCode.typeDocument[DbSystemDocCode.TYPE_DOCUMENT_AP_MEMO]);

                                            systemDocNumber.setYear(dt.getYear() + 1900);
                                            formatDocCode = DbSystemDocNumber.getNextNumberApMemo(r.getCounter(), opnPeriode.getOID());

                                            systemDocNumber.setDocNumber(formatDocCode);
                                            r.setNumber(formatDocCode);

                                            r.setVendorId(vendorId);
                                            r.setDate(invEndDate);
                                            r.setCurrencyId(currencyId);
                                            r.setApproval1Date(invEndDate);
                                            r.setApproval3Date(invEndDate);
                                            r.setDueDate(invEndDate);
                                            r.setInvoiceNumber("-");
                                            r.setPeriodId(opnPeriode.getOID());
                                            r.setCoaId(oidHutangTrade);
                                            r.setTypeAp(DbReceive.TYPE_AP_YES);
                                            r.setReferenceId(oidMemorial);
                                            double tot = 0;
                                            for (int t = 0; t < listDetail.size(); t++) {
                                                MemorialKonsinyasiDetail md = (MemorialKonsinyasiDetail) listDetail.get(t);
                                                tot = tot + md.getAmount();
                                            }
                                            r.setTotalAmount(tot * -1);
                                            long oidRec = 0;
                                            try {
                                                oidRec = DbReceive.insertExc(r);
                                                if (oidRec != 0) {
                                                    try {
                                                        DbSystemDocNumber.insertExc(systemDocNumber);
                                                    } catch (Exception E) {
                                                        System.out.println("[exception] " + E.toString());
                                                    }
                                                    for (int t = 0; t < listDetail.size(); t++) {
                                                        MemorialKonsinyasiDetail md = (MemorialKonsinyasiDetail) listDetail.get(t);
                                                        ReceiveItem ri = new ReceiveItem();
                                                        ri.setItemMasterId(oidItemDmm);
                                                        ri.setQty(1);
                                                        ri.setAmount(md.getAmount() * -1);
                                                        ri.setTotalAmount(md.getAmount() * -1);
                                                        ri.setDeliveryDate(invEndDate);
                                                        ri.setUomId(oidUom);
                                                        ri.setReceiveId(oidRec);
                                                        ri.setExpiredDate(invEndDate);
                                                        ri.setMemo(md.getNote());
                                                        ri.setApCoaId(md.getCoaId());
                                                        DbReceiveItem.insertExc(ri);
                                                    }
                                                }
                                            } catch (Exception e) {
                                            }
                                            DbReceive.postJournalAutoKomisi(r, user.getOID());
                                        }
                                    }
                                }

                            }



                        } catch (Exception e) {
                        }

                    }

                }

            }
%>
<html >
    <!-- #BeginTemplate "/Templates/indexsl.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=salesSt%></title>
        <link href="../css/csssl.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintJournal(){	                       
                window.open("<%=printroot%>.report.RptKonsinyasiPricePDF?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdPostJournal(){
                    document.frmsales.command.value="<%=JSPCommand.POST%>";            
                    document.frmsales.action="rptconsignbysellingvalue.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsales.submit();
                } 
                
                function cmdPrintJournalXls(){	                       
                    window.open("<%=printroot%>.report.RptKonsinyasiPriceXls?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                    }
                    
                    function cmdSearch(){
                        document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                        document.frmsales.action="rptconsignbysellingvalue.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td valign="top"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                                            <tr valign="bottom"> 
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Consigned Report 
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                <span class="lvl2">Consigned By Price<br></span></font></b></td>
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
                                                                                                                        <table width="350" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr align="left" valign="top">                                                                         
                                                                                                                                <td class="tablecell1" >                                                                                                                                                
                                                                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="1" style="border:1px solid #ABA8A8">
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="3" height="5"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="5" ></td>
                                                                                                                                            <td colspan="2" nowrap class="fontarial"><b><i>Searching Parameter :</i></b></td>                                                                                    
                                                                                                                                        </tr>
                                                                                                                                        <tr>
                                                                                                                                            <td width="5" height="14">&nbsp;</td>
                                                                                                                                            <td width="80" class="fontarial">Date Between</td>
                                                                                                                                            <td >
                                                                                                                                                <table cellpadding="0" cellspacing="0">
                                                                                                                                                    <tr>
                                                                                                                                                        <td > 
                                                                                                                                                            <input name="invStartDate" value="<%=JSPFormater.formatDate((invStartDate == null) ? new Date() : invStartDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invStartDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>
                                                                                                                                                        <td class="fontarial">    
                                                                                                                                                            &nbsp;&nbsp;and&nbsp;&nbsp;
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <input name="invEndDate" value="<%=JSPFormater.formatDate((invEndDate == null) ? new Date() : invEndDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                                                                                                                        </td>
                                                                                                                                                        <td>
                                                                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsales.invEndDate);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt="visit date"></a> 
                                                                                                                                                        </td>                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td width="5" height="14">&nbsp;</td>
                                                                                                                                            <td class="fontarial">Suplier</td>
                                                                                                                                            <td class="fontarial"> 
                                                                                                                                                <%
            String whereCosg = DbVendor.colNames[DbVendor.COL_IS_KONSINYASI] + " = 1 and " + DbVendor.colNames[DbVendor.COL_SYSTEM] + " = " + DbVendor.TYPE_SYSTEM_HJ;
            Vector vVendor = DbVendor.list(0, 0, whereCosg, DbVendor.colNames[DbVendor.COL_NAME]);
                                                                                                                                                %>
                                                                                                                                                <select name="src_vendor_id" class="fontarial">                                                                                                                                                    
                                                                                                                                                    <%if (vVendor != null && vVendor.size() > 0) {
                for (int i = 0; i < vVendor.size(); i++) {
                    Vendor v = (Vendor) vVendor.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=v.getOID()%>" <%if (v.getOID() == vendorId) {%>selected<%}%>><%=v.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                    
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td width="5" height="14">&nbsp;</td>
                                                                                                                                            <td class="fontarial">Location</td>
                                                                                                                                            <td class="fontarial"> 
                                                                                                                                                <%
            Vector vLoc = userLocations;
                                                                                                                                                %>
                                                                                                                                                <select name="src_location_id" class="fontarial">                                                                                                                                                    
                                                                                                                                                    <%if (vLoc != null && vLoc.size() > 0) {
                for (int i = 0; i < vLoc.size(); i++) {
                    Location us = (Location) vLoc.get(i);
                                                                                                                                                    %>
                                                                                                                                                    <option value="<%=us.getOID()%>" <%if (us.getOID() == locationId) {%>selected<%}%>><%=us.getName().toUpperCase()%></option>
                                                                                                                                                    <%}
            }%>
                                                                                                                                                </select>
                                                                                                                                            </td>                                                                                    
                                                                                                                                        </tr>                                                                                                                                        
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="3">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="22" valign="middle" colspan="4" class="container"> 
                                                                                                                        <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a>
                                                                                                                    </td>    
                                                                                                                </tr>  
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="22" valign="middle" colspan="4">&nbsp;</td>    
                                                                                                                </tr>
                                                                                                                <tr align="left" valign="top"> 
                                                                                                                    <td height="22" valign="middle" colspan="4" class="container"> 
                                                                                                                        <table width="1500" border="0" cellspacing="1" cellpadding="0">
                                                                                                                            <%
            int width = 5;
                                                                                                                            %>
                                                                                                                            <tr > 
                                                                                                                                <td class="tablearialhdr" width="70" rowspan="2">Sku</td>                                                                                                                                            
                                                                                                                                <td class="tablearialhdr" rowspan="2">Description</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">price</td>
                                                                                                                                <td class="tablearialhdr" width="7%" rowspan="2">Begining</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">Receiving</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">Sold</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">Retur</td>
                                                                                                                                <td class="tablearialhdr" colspan="2">Transfer</td>                                                                                                                                
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">Adjustment</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">Ending</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">Seliing Value</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">Margin (%)</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">Margin</td>                                                                                                                                
                                                                                                                                <td class="tablearialhdr" width="7%" rowspan="2">Stock Value</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%" rowspan="2">PPN</td>
                                                                                                                            </tr> 
                                                                                                                            <tr >                                                                                                                                 
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%">In</td>
                                                                                                                                <td class="tablearialhdr" width="<%=width%>%">Out</td>                                                                                                                                
                                                                                                                            </tr> 
                                                                                                                            <%
            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.POST) {

                if (result != null && result.size() > 0) {

                    double tot1 = 0;
                    double tot2 = 0;
                    double tot3 = 0;
                    double tot4 = 0;
                    double tot5 = 0;
                    double tot6 = 0;
                    double tot7 = 0;
                    double tot8 = 0;
                    double tot9 = 0;
                    double tot10 = 0;
                    double tot11 = 0;

                    double tot12 = 0;
                    double tot13 = 0;

                    for (int i = 0; i < result.size(); i++) {

                        ReportConsigCost rsm = (ReportConsigCost) result.get(i);

                        double price = 0;

                        ItemMaster im = new ItemMaster();
                        double discount = 0;
                        try {
                            im = DbItemMaster.fetchExc(rsm.getItemMasterId());
                            Vendor vnd = new Vendor();
                            vnd = DbVendor.fetchExc(im.getDefaultVendorId());
                            discount = vnd.getPercentMargin();
                        } catch (Exception e) {
                        }

                        ReportConsigCost begin = new ReportConsigCost();
                        try {
                            begin = (ReportConsigCost) sBegin.get("" + rsm.getItemMasterId());
                        } catch (Exception e) {
                            begin = new ReportConsigCost();
                        }
                        ReportConsigCost receive = new ReportConsigCost();
                        try {
                            receive = (ReportConsigCost) sReceive.get("" + rsm.getItemMasterId());
                        } catch (Exception e) {
                            System.out.println("exception " + e.toString());
                        }
                        if (receive == null) {
                            receive = new ReportConsigCost();
                        }
                        if (begin == null) {
                            begin = new ReportConsigCost();
                        }

                        ReportConsigCost sold = new ReportConsigCost();
                        try {
                            sold = (ReportConsigCost) sSold.get("" + rsm.getItemMasterId());
                        } catch (Exception e) {
                            System.out.println("exception " + e.toString());
                        }

                        if (sold == null) {
                            sold = new ReportConsigCost();
                        }

                        double lastPrice = 0;
                        try {
                            lastPrice = SessLastPriceKonsinyasi.getLastPrice(locationId, rsm.getItemMasterId(), invEndDate);
                        //lastPrice = DbSales.getLastPrice(locationId, rsm.getItemMasterId(), invEndDate);
                        } catch (Exception e) {
                        }
                        price = lastPrice;

                        if (price == 0) {
                            double tmpPrice = 0;
                            try {
                                tmpPrice = SessReportSales.reportConsignedBySellingPrice(locationId, rsm.getItemMasterId());
                            } catch (Exception e) {
                            }
                            price = tmpPrice;
                        }

                        ReportConsigCost retur = new ReportConsigCost();
                        try {
                            retur = (ReportConsigCost) sRetur.get("" + rsm.getItemMasterId());
                        } catch (Exception e) {
                            System.out.println("exception " + e.toString());
                        }
                        if (retur == null) {
                            retur = new ReportConsigCost();
                        }
                        ReportConsigCost transIn = new ReportConsigCost();
                        try {
                            transIn = (ReportConsigCost) sTransIn.get("" + rsm.getItemMasterId());
                        } catch (Exception e) {
                            System.out.println("exception " + e.toString());
                        }
                        if (transIn == null) {
                            transIn = new ReportConsigCost();
                        }

                        ReportConsigCost transOut = new ReportConsigCost();
                        try {
                            transOut = (ReportConsigCost) sTransOut.get("" + rsm.getItemMasterId());
                        } catch (Exception e) {
                            System.out.println("exception " + e.toString());
                        }
                        if (transOut == null) {
                            transOut = new ReportConsigCost();
                        }

                        ReportConsigCost adjustment = new ReportConsigCost();
                        try {
                            adjustment = (ReportConsigCost) sAdjustment.get("" + rsm.getItemMasterId());
                        } catch (Exception e) {
                            System.out.println("exception " + e.toString());
                        }
                        if (adjustment == null) {
                            adjustment = new ReportConsigCost();
                        }

                        double stock = begin.getQty() + receive.getQty() + sold.getQty() + retur.getQty() + transIn.getQty() + transOut.getQty() + adjustment.getQty();
                        double sellingV = 0;
                        if (sold.getQty() != 0) {
                            sellingV = sold.getQty() * -1 * price;
                        } else {
                            sellingV = sold.getQty() * price;
                        }

                        String strSellingV = "";
                        if (sellingV < 0) {
                            strSellingV = "(" + JSPFormater.formatNumber(sellingV, "#,###.##") + ")";
                        } else {
                            strSellingV = JSPFormater.formatNumber(sellingV, "#,###.##");
                        }

                        double vEnding = 0;
                        double vEnding2 = 0;

                        vEnding = stock * price;
                        vEnding2 = stock * price;

                        String strV = "";
                        if (vEnding < 0) {
                            vEnding = vEnding * -1;
                            strV = "(" + JSPFormater.formatNumber(vEnding, "#,###.##") + ")";
                        } else {
                            strV = JSPFormater.formatNumber(vEnding, "#,###.##");
                        }

                        double tmpAmountDisc = (sellingV * discount) / 100;
                        //String strAmountDisc = JSPFormater.formatNumber(tmpAmountDisc, "#,###.##");

                        tot1 = tot1 + begin.getQty();
                        tot2 = tot2 + receive.getQty();
                        double tot3x = sold.getQty() != 0 ? sold.getQty() * -1 : sold.getQty();
                        tot3 = tot3 + tot3x;
                        double tot4x = retur.getQty() != 0 ? retur.getQty() * -1 : retur.getQty();
                        tot4 = tot4 + tot4x;
                        tot5 = tot5 + transIn.getQty();
                        double tot6x = transOut.getQty() != 0 ? transOut.getQty() * -1 : transOut.getQty();
                        tot6 = tot6 + tot6x;
                        tot7 = tot7 + adjustment.getQty();
                        tot8 = tot8 + stock;
                        tot9 = tot9 + sellingV;
                        tot10 = tot10 + vEnding2;
                        tot11 = tot11 + tmpAmountDisc;


                        String style = "";
                        if (i % 2 == 0) {
                            style = "tablearialcell";
                        } else {
                            style = "tablearialcell1";
                        }
                        double marg = vendor.getPercentMargin() * sellingV / 100;
                        tot12 = tot12 + marg;

                        double ppn = 0;
                        if (vendor.getIsPKP() == 1 && sellingV != 0) {
                            ppn = sellingV - ((100 * sellingV) / 110);
                        }
                        tot13 = tot13 + ppn;

                                                                                                                            %>
                                                                                                                            <tr height="23"> 
                                                                                                                                <td class="<%=style%>" align="center"><%=rsm.getSku()%></td>                                                                                                                                            
                                                                                                                                <td class="<%=style%>" align="left">&nbsp;<%=rsm.getDescription()%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(price, "#,###.##")%></td>                                                                                                                                            
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(begin.getQty(), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(receive.getQty(), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(sold.getQty() != 0 ? sold.getQty() * -1 : sold.getQty(), "#,###.##") %></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber((retur.getQty() != 0 ? retur.getQty() * -1 : retur.getQty()), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(transIn.getQty(), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber((transOut.getQty() != 0 ? transOut.getQty() * -1 : transOut.getQty()), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(adjustment.getQty(), "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(stock, "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=strSellingV%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=vendor.getPercentMargin()%> %</td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(marg, "#,###.##")%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=strV%></td>
                                                                                                                                <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(ppn, "#,###.##")%></td>
                                                                                                                            </tr>    
                                                                                                                            <%}%>
                                                                                                                            <tr height="20">                                                                                                                                             
                                                                                                                                <td class="tablearialcell1" align="center" colspan="3"><B>GRAND TOTAL</B>&nbsp;&nbsp;</td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot1, "#,###.##")%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot2, "#,###.##")%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot3, "#,###.##")%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot4, "#,###.##")%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot5, "#,###.##")%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot6, "#,###.##")%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot7, "#,###.##")%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot8, "#,###.##")%></B></td>
                                                                                                                                <%
                                                                                                                                    String strV = "";
                                                                                                                                    if (tot9 < 0) {
                                                                                                                                        tot9 = tot9 * -1;
                                                                                                                                        strV = "(" + JSPFormater.formatNumber(tot9, "#,###.##") + ")";
                                                                                                                                    } else {
                                                                                                                                        strV = JSPFormater.formatNumber(tot9, "#,###.##");
                                                                                                                                    }%>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=strV%></B></td>
                                                                                                                                <%
                                                                                                                                    String strVx = "";
                                                                                                                                    if (tot10 < 0) {
                                                                                                                                        tot10 = tot10 * -1;
                                                                                                                                        strVx = "(" + JSPFormater.formatNumber(tot10, "#,###.##") + ")";
                                                                                                                                    } else {
                                                                                                                                        strVx = JSPFormater.formatNumber(tot10, "#,###.##");
                                                                                                                                    }

                                                                                                                                %>
                                                                                                                                
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=vendor.getPercentMargin()%> %</B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot12, "#,###.##")%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=strVx%></B></td>
                                                                                                                                <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(tot13, "#,###.##")%></B></td>
                                                                                                                            </tr> 
                                                                                                                            <tr>
                                                                                                                                <td colspan="15" height="25"></td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="15">
                                                                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                        <tr height="24">
                                                                                                                                            <td width="200" class="fontarial"><B>Total Selling Price</B></td>
                                                                                                                                            <td width="20" align="center">&nbsp;</td>
                                                                                                                                            <td width="100" align="center" class="fontarial"><B>=</B></td>
                                                                                                                                            <td width="50" align="center" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td width="100" align="right" class="fontarial"><B><%=strV%></B></td>
                                                                                                                                            <td width="2"></td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr height="24">
                                                                                                                                            <td width="200" class="fontarial"><B>VAT Out</B></td>
                                                                                                                                            <td width="20" align="center">&nbsp;</td>
                                                                                                                                            <td width="100" align="center" class="fontarial"><B>=</B></td>
                                                                                                                                            <td width="50" align="center" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td width="100" align="right" class="fontarial"><B><%=JSPFormater.formatNumber(tot13, "#,###.##")%></B></td>
                                                                                                                                            <td width="2"></td>
                                                                                                                                        </tr>  
                                                                                                                                        <%
                                                                                                                                    double margin = 0;
                                                                                                                                    margin = (vendor.getPercentMargin() * (tot9 - tot13)) / 100;
                                                                                                                                        %>
                                                                                                                                        <tr height="24">
                                                                                                                                            <td class="fontarial"><B>Margin <%=JSPFormater.formatNumber(vendor.getPercentMargin(), "#,###")%>%</B></td>
                                                                                                                                            <td align="center">&nbsp;</td>
                                                                                                                                            <td align="center" class="fontarial"><B>=</B></td>
                                                                                                                                            <td align="center" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" style="border-bottom: #000000 1px solid;" class="fontarial"><B><%=JSPFormater.formatNumber(margin, "#,###.##")%></B></td>
                                                                                                                                            <td width="2">&nbsp;-</td>
                                                                                                                                        </tr>  
                                                                                                                                        <%
                                                                                                                                    double tot = tot9 - tot13 - margin;
                                                                                                                                    double vatin = 0;
                                                                                                                                    if (vendor.getIsPKP() == 1) {
                                                                                                                                        vatin = (10 * tot) / 100;
                                                                                                                                    }
                                                                                                                                    double subtotal2 = tot + vatin;
                                                                                                                                        %>
                                                                                                                                        <tr height="24">
                                                                                                                                            <td width="200" class="fontarial"><B>Subtotal 1</B></td>
                                                                                                                                            <td width="20" align="center">&nbsp;</td>
                                                                                                                                            <td width="100" align="center" class="fontarial"><B>=</B></td>
                                                                                                                                            <td width="50" align="center" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td width="100" align="right" class="fontarial"><B><%=JSPFormater.formatNumber(tot, "#,###.##")%></B></td>
                                                                                                                                            <td width="2"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="24">                                                                                                                                                        
                                                                                                                                            <td align="center" colspan="5">&nbsp;</td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <tr height="24">
                                                                                                                                            <td width="200" class="fontarial"><B>VAT In</B></td>
                                                                                                                                            <td width="20" align="center">&nbsp;</td>
                                                                                                                                            <td width="100" align="center" class="fontarial"><B>=</B></td>
                                                                                                                                            <td width="50" align="center" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td width="100" align="right" style="border-bottom: #000000 1px solid;" class="fontarial"><B><%=JSPFormater.formatNumber(vatin, "#,###.##")%></B></td>
                                                                                                                                            <td width="2">&nbsp;+</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="24">
                                                                                                                                            <td width="200" class="fontarial"><B>Subtotal 2</B></td>
                                                                                                                                            <td width="20" align="center">&nbsp;</td>
                                                                                                                                            <td width="100" align="center" class="fontarial"><B>=</B></td>
                                                                                                                                            <td width="50" align="center" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td width="100" align="right" class="fontarial"><B><%=JSPFormater.formatNumber(subtotal2, "#,###.##")%></B></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="24">                                                                                                                                                        
                                                                                                                                            <td align="center" colspan="5">&nbsp;</td>                                                                                                                                                        
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="24">
                                                                                                                                            <td class="fontarial"><B>Potongan</B></td>
                                                                                                                                            <td align="center" colspan="4"></td>                                                                                                                                                        
                                                                                                                                        </tr> 
                                                                                                                                        <% double promot = (tot9 / 100) * vendor.getPercentPromosi();%> 
                                                                                                                                        <input type="hidden" name="hidden_promotion" value="<%=promot%>">
                                                                                                                                        <tr height="24">
                                                                                                                                            <td class="fontarial">&nbsp;&nbsp;&nbsp;<B>Promosi <%=JSPFormater.formatNumber(vendor.getPercentPromosi(), "#,###")%>%</B></td>
                                                                                                                                            <td align="center" class="fontarial"><B>Rp</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(promot, "#,###.##")%></B></td>
                                                                                                                                            <td align="right" class="fontarial"></td>
                                                                                                                                            <td align="right" class="fontarial"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <% double barcode = vendor.getPercentBarcode() * (tot2 + tot5);%>
                                                                                                                                        <input type="hidden" name="hidden_barcode" value="<%=barcode%>">
                                                                                                                                        <tr height="24">
                                                                                                                                            <td class="fontarial">&nbsp;&nbsp;&nbsp;<B>Barcode @Rp. <%=JSPFormater.formatNumber(vendor.getPercentBarcode(), "#,###")%></B></td>
                                                                                                                                            <td align="center" class="fontarial"><B>Rp</B></td>
                                                                                                                                            <td align="right" style="border-bottom: #000000 1px solid;" class="fontarial"><B><%=JSPFormater.formatNumber(barcode, "#,###.##")%></B></td>
                                                                                                                                            <td align="right">&nbsp;</td>
                                                                                                                                            <td align="right"></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%double totPotongan = promot + barcode;%>
                                                                                                                                        <tr height="24">
                                                                                                                                            <td class="fontarial">&nbsp;&nbsp;&nbsp;<b>Total Potongan</B></td>
                                                                                                                                            <td></td>
                                                                                                                                            <td align="center" class="fontarial"><B>=</B></td>
                                                                                                                                            <td align="center" class="fontarial"><B>Rp</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(totPotongan, "#,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                        <tr height="24">                                                                                                                                                        
                                                                                                                                            <td align="center" colspan="5">&nbsp;</td>                                                                                                                                                        
                                                                                                                                        </tr>
                                                                                                                                        <% double grandTotal = subtotal2 - totPotongan;%>
                                                                                                                                        <tr height="24">
                                                                                                                                            <td class="fontarial"><B>Total Bayar</B></td>
                                                                                                                                            <td></td>
                                                                                                                                            <td align="center" class="fontarial"><B>=</B></td>
                                                                                                                                            <td align="center" class="fontarial"><B>Rp</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(grandTotal, "#,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr>
                                                                                                                                <td colspan="15" >&nbsp;</td>
                                                                                                                            </tr>   
                                                                                                                            <%
                                                                                                                                    Vector glsx = new Vector();
                                                                                                                                    String where = " to_days(" + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_START_DATE] + ") = to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(" + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_END_DATE] + ") = to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
                                                                                                                                    if (vendorId != 0) {
                                                                                                                                        where = where + " and " + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_VENDOR_ID] + " = " + vendorId;
                                                                                                                                    }
                                                                                                                                    if (locationId != 0) {
                                                                                                                                        where = where + " and " + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_LOCATION_ID] + " = " + locationId;
                                                                                                                                    }
                                                                                                                                    Vector memorials = DbMemorialKonsinyasi.list(0, 0, where, null);

                                                                                                                                    if (memorials != null && memorials.size() > 0) {
                                                                                                                                        for (int r = 0; r < memorials.size(); r++) {
                                                                                                                                            MemorialKonsinyasi m = (MemorialKonsinyasi) memorials.get(r);
                                                                                                                                            String whereRefId = DbReceive.colNames[DbReceive.COL_REFERENCE_ID] + " = " + m.getOID();
                                                                                                                                            Vector recs = DbReceive.list(0, 1, whereRefId, null);
                                                                                                                                            try {
                                                                                                                                                if (recs != null && recs.size() > 0) {
                                                                                                                                                    Receive rec = (Receive) recs.get(0);
                                                                                                                                                    String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + rec.getNumber() + "'";
                                                                                                                                                    glsx = DbGl.list(0, 1, whereGl, null);
                                                                                                                                                }
                                                                                                                                            } catch (Exception e) {
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                            %> 
                                                                                                                            
                                                                                                                            <%if (privPrint || privAdd || privUpdate || privDelete) {%>
                                                                                                                            <tr>
                                                                                                                                <td colspan="15" >
                                                                                                                                    <table>
                                                                                                                                        <tr>
                                                                                                                                            <%if (privPrint) {%>
                                                                                                                                            <td width="100"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>                                                                                                                                                
                                                                                                                                            <td width="160"><a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print2" height="22" border="0"></a></td>
                                                                                                                                            <%}%>
                                                                                                                                            <%if ((privAdd || privUpdate || privDelete) && (glsx == null || glsx.size() <= 0)) {%>
                                                                                                                                            <td width="100"><a href="javascript:cmdPostJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a></td>                                                                                                                                                                                                                                                                                                                       
                                                                                                                                            <%}%>
                                                                                                                                        </tr>
                                                                                                                                    </table>    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" colspan="15">&nbsp;</td> 
                                                                                                                            </tr>  
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" colspan="15" class="container">
                                                                                                                                    <%

                                                                                                                                    if (memorials != null && memorials.size() > 0) {
                                                                                                                                        for (int r = 0; r < memorials.size(); r++) {
                                                                                                                                            MemorialKonsinyasi m = (MemorialKonsinyasi) memorials.get(r);
                                                                                                                                            String whereRefId = DbReceive.colNames[DbReceive.COL_REFERENCE_ID] + " = " + m.getOID();
                                                                                                                                            Vector recs = DbReceive.list(0, 1, whereRefId, null);
                                                                                                                                            try {
                                                                                                                                                if (recs != null && recs.size() > 0) {
                                                                                                                                                    Receive rec = (Receive) recs.get(0);
                                                                                                                                                    String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + rec.getNumber() + "'";
                                                                                                                                                    Vector gls = DbGl.list(0, 1, whereGl, null);
                                                                                                                                                    if (gls != null && gls.size() > 0) {
                                                                                                                                                        Gl gl = (Gl) gls.get(0);
                                                                                                                                    %>
                                                                                                                                    <table width="900" border="0" cellspacing="0" cellpadding="0"> 
                                                                                                                                        <%
                                                                                                                                                                                                                                                                                            try {


                                                                                                                                                                                                                                                                                                Vector details = DbGlDetail.list(0, 0, DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + gl.getOID(), "debet desc");
                                                                                                                                                                                                                                                                                                User ux = new User();
                                                                                                                                                                                                                                                                                                try {
                                                                                                                                                                                                                                                                                                    ux = DbUser.fetch(gl.getPostedById());
                                                                                                                                                                                                                                                                                                } catch (Exception e) {
                                                                                                                                                                                                                                                                                                }
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td>
                                                                                                                                                <table width="900" border="0" cellspacing="1" cellpadding="0"> 
                                                                                                                                                    <tr> 
                                                                                                                                                        <td width="100" class="fontarial" bgcolor="#EFFEDE" height="17" style="padding:3px;" nowrap><b>Status</b></td>      
                                                                                                                                                        <td width="300" class="fontarial" height="17" nowrap style="padding:3px;"><b> : Posted</b></td> 
                                                                                                                                                        <td width="100" class="fontarial" bgcolor="#EFFEDE" height="17" style="padding:3px;" nowrap><b>Number</b></td>      
                                                                                                                                                        <td class="fontarial" height="17" style="padding:3px;" nowrap><b> : <%=gl.getJournalNumber()%></b></td> 
                                                                                                                                                    </tr>
                                                                                                                                                    <tr> 
                                                                                                                                                        <td class="fontarial" bgcolor="#EFFEDE" style="padding:3px;" height="17" nowrap><b>Transaction Date</b></td>      
                                                                                                                                                        <td class="fontarial" height="17" style="padding:3px;" nowrap><b> : <%=JSPFormater.formatDate(gl.getTransDate(), "dd MMMM yyyy")%></b></td> 
                                                                                                                                                        <td class="fontarial" bgcolor="#EFFEDE" style="padding:3px;" height="17" nowrap><b>Create Date</b></td>      
                                                                                                                                                        <td class="fontarial" height="17" style="padding:3px;" nowrap><b> : <%=JSPFormater.formatDate(gl.getDate(), "dd MMMM yyyy")%></b></td>                                                                                                                                                                                 
                                                                                                                                                    </tr>                                                                                                                                                                 
                                                                                                                                                    <tr> 
                                                                                                                                                        <td class="fontarial" bgcolor="#EFFEDE" style="padding:3px;" height="17" nowrap><b>Posted By</b></td>      
                                                                                                                                                        <td class="fontarial" height="17" style="padding:3px;" nowrap><b> : <%=ux.getFullName()%></b></td> 
                                                                                                                                                    </tr> 
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>  
                                                                                                                                        <%if (details != null && details.size() > 0) {%>
                                                                                                                                        <tr>    
                                                                                                                                            <td colspan="15">
                                                                                                                                                <table width="1000" border="0" cellspacing="1" cellpadding="0" >
                                                                                                                                                    <tr height="20">
                                                                                                                                                        <td width="25" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial" ><b>No</b></td>
                                                                                                                                                        <td align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial" ><b>Akun Perkiraan</b></td>
                                                                                                                                                        <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Debet</b></td>
                                                                                                                                                        <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Credit</b></td>
                                                                                                                                                        <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Memo</b></td>
                                                                                                                                                        <td width="100" align="center" bgcolor="609836" style="color:#ffffff;" class="fontarial"><b>Segment</b></td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <%

    double totalDebit = 0;
    double totalCredit = 0;
    for (int d = 0; d < details.size(); d++) {

        GlDetail gld = (GlDetail) details.get(d);
        Coa coa = new Coa();
        try {
            coa = DbCoa.fetchExc(gld.getCoaId());
        } catch (Exception e) {
        }

        SegmentDetail sd = new SegmentDetail();
        try {
            if (gld.getSegment1Id() != 0) {
                sd = DbSegmentDetail.fetchExc(gld.getSegment1Id());
            }
        } catch (Exception e) {
        }

        totalDebit = totalDebit + gld.getDebet();
        totalCredit = totalCredit + gld.getCredit();
        String bg1 = "#EFFEDE";
        String bg2 = "#E0FCC2";
        String bg = "";
        if (d % 2 == 0) {
            bg = bg1;
        } else {
            bg = bg2;
        }
                                                                                                                                                    %>                                                                                                                                                                            
                                                                                                                                                    <tr height="25"> 
                                                                                                                                                        <td class="fontarial" bgcolor="<%=bg%>" align="center" ><%=(d + 1)%></td>                                                                                                                                                                                
                                                                                                                                                        <td class="fontarial" bgcolor="<%=bg%>"  style="padding:3px;" nowrap><%=coa.getCode() + " - " + coa.getName()%></td>
                                                                                                                                                        <td class="fontarial" bgcolor="<%=bg%>" align="right" style="padding:3px;"><%=(gld.getDebet() == 0) ? "" : JSPFormater.formatNumber(gld.getDebet(), "###,###.##")%></td>
                                                                                                                                                        <td class="fontarial" bgcolor="<%=bg%>" align="right" style="padding:3px;"><%=(gld.getCredit() == 0) ? "" : JSPFormater.formatNumber(gld.getCredit(), "###,###.##")%></td>
                                                                                                                                                        <td class="fontarial" bgcolor="<%=bg%>" style="padding:3px;"><%=gld.getMemo()%></td>
                                                                                                                                                        <td class="fontarial" bgcolor="<%=bg%>" style="padding:3px;" nowrap><%=sd.getName()%></td>                                                                                                                                                                               
                                                                                                                                                    </tr>   
                                                                                                                                                    
                                                                                                                                                    <%
    }


                                                                                                                                                    %>
                                                                                                                                                    <tr height="25"> 
                                                                                                                                                        <td class="fontarial" bgcolor="#cccccc" align="center" colspan="2" nowrap>Grand Total</td>
                                                                                                                                                        <td class="fontarial" bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalDebit, "###,###.##")%></td>
                                                                                                                                                        <td class="fontarial" bgcolor="#cccccc" align="right" style="padding:3px;"><%=JSPFormater.formatNumber(totalCredit, "###,###.##")%></td>
                                                                                                                                                        <td bgcolor="#cccccc" colspan="2">&nbsp;</td>                                                                                                                                                                                
                                                                                                                                                    </tr>  
                                                                                                                                                    <tr height="25">
                                                                                                                                                        <td colspan="5"></td>
                                                                                                                                                    </tr>    
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                                                                                                                                                                                }

                                                                                                                                                                                                                                                                                            } catch (Exception e) {
                                                                                                                                                                                                                                                                                            }
                                                                                                                                        
                                                                                                                                        %>  
                                                                                                                                    </table>
                                                                                                                                    <%
                                                                                                                                                    }
                                                                                                                                                }
                                                                                                                                            } catch (Exception e) {
                                                                                                                                            }

                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    %>
                                                                                                                                </td> 
                                                                                                                            </tr>  
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" colspan="15"></td> 
                                                                                                                            </tr> 
                                                                                                                            
                                                                                                                            <%} else {%>
                                                                                                                            <tr height="22">
                                                                                                                                <td colspan="15" class="tablearialcell1">&nbsp;<b><i>Data not found</i></b></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                            <%} else {%>
                                                                                                                            <tr height="22">
                                                                                                                                <td colspan="15" class="tablearialcell1">&nbsp;<b><i>Click search button to searching the data</i></b></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
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
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        <!-- #EndEditable --> </td>
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

