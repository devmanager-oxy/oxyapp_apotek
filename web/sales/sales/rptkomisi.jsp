
<%-- 
    Document   : rptkomisi
    Created on : Jan 17, 2013, 1:45:23 PM
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
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.sales.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KOMISI);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KOMISI, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KOMISI, AppMenu.PRIV_PRINT);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KOMISI, AppMenu.PRIV_ADD);
%>
<!-- Jsp Block -->

<%

            if (session.getValue("REPORT_KOMISI") != null) {
                session.removeValue("REPORT_KOMISI");
            }

            if (session.getValue("REPORT_KOMISI_DETAIL") != null) {
                session.removeValue("REPORT_KOMISI_DETAIL");
            }

            if (session.getValue("REPORT_KOMISI_DEDUCTION") != null) {
                session.removeValue("REPORT_KOMISI_DEDUCTION");
            }

            String strdate1 = JSPRequestValue.requestString(request, "invStartDate");
            String strdate2 = JSPRequestValue.requestString(request, "invEndDate");
            Date invStartDate = (JSPRequestValue.requestString(request, "invStartDate") == null) ? new Date() : JSPFormater.formatDate(strdate1, "dd/MM/yyyy");
            Date invEndDate = (JSPRequestValue.requestString(request, "invEndDate") == null) ? new Date() : JSPFormater.formatDate(strdate2, "dd/MM/yyyy");
            long locationId = JSPRequestValue.requestLong(request, "src_location_id");
            long vendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int groupByDate = JSPRequestValue.requestInt(request, "group_by_date");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            double totalAmount = JSPRequestValue.requestDouble(request, "hidden_total_amount");

            //deduction
            double lphQty = JSPRequestValue.requestDouble(request, "lph_qty");
            double lphAmount = JSPRequestValue.requestDouble(request, "lph_amount");
            double nptQty = JSPRequestValue.requestDouble(request, "npt_qty");
            double nptAmount = JSPRequestValue.requestDouble(request, "npt_amount");
            double lphfQty = JSPRequestValue.requestDouble(request, "lphf_qty");
            double lphfAmount = JSPRequestValue.requestDouble(request, "lphf_amount");

            double promoQty = JSPRequestValue.requestDouble(request, "promo_qty");
            double promoAmount = JSPRequestValue.requestDouble(request, "promo_amount");

            double otherQty = JSPRequestValue.requestDouble(request, "other_qty");
            double otherAmount = JSPRequestValue.requestDouble(request, "other_amount");

            double barcode = JSPRequestValue.requestDouble(request, "barcode");
            double barcodeQty = JSPRequestValue.requestDouble(request, "barcode_qty");

            Vector result = new Vector();

            String parameter = "Date Between : " + JSPFormater.formatDate(invStartDate, "dd/MM/yyyy") + " to " + JSPFormater.formatDate(invEndDate, "dd/MM/yyyy");
            if (locationId != 0) {
                try {
                    Location l = DbLocation.fetchExc(locationId);
                    parameter = parameter + " , Location :" + l.getName();
                } catch (Exception e) {
                }
            }

            String name = "";
            if (vendorId != 0) {
                try {
                    Vendor v = DbVendor.fetchExc(vendorId);
                    if (v.getName() != null && v.getName().length() > 0) {
                        parameter = parameter + " , Suplier :" + v.getName();
                        name = ", Suplier :" + v.getName();
                    }
                } catch (Exception e) {
                }
            }

            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.POST) {
                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setVendorId(vendorId);
                session.putValue("REPORT_KOMISI", rp);

                result = SessReportSales.reportKomisi(locationId, vendorId, invStartDate, invEndDate);

                if (iJSPCommand == JSPCommand.POST) {

                    Periode opnPeriode = DbPeriode.getPeriodByTransDate(invEndDate);

                    if (opnPeriode.getOID() != 0 && opnPeriode.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) != 0) {

                        Memorial memorial = new Memorial();
                        memorial.setStartDate(invStartDate);
                        memorial.setEndDate(invEndDate);
                        memorial.setVendorId(vendorId);
                        memorial.setLocationId(locationId);
                        memorial.setCreateDate(new Date());
                        memorial.setUserId(user.getOID());
                        try {
                            String where = DbMemorial.colNames[DbMemorial.CL_VENDOR_ID] + "=" + vendorId + " and " + DbMemorial.colNames[DbMemorial.CL_LOCATION_ID] + "=" + locationId + " and (" + DbMemorial.colNames[DbMemorial.CL_START_DATE] + " between '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 23:59:59') and " +
                                    " (" + DbMemorial.colNames[DbMemorial.CL_END_DATE] + " between '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 00:00:00' and '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59') ";

                            int count = DbMemorial.getCount(where);
                            long oidMemorial = 0;
                            if (count == 0) {
                                oidMemorial = DbMemorial.insertExc(memorial);
                            }

                            if (oidMemorial != 0) {

                                long oidCoaLPH = 0;
                                long oidCoaNPT = 0;
                                long oidCoaLPHForm = 0;
                                long oidCoaPromotion = 0;
                                long oidHutangTrade = 0;
                                long oidCoaBarcode = 0;

                                try {
                                    oidCoaLPH = Long.parseLong(String.valueOf(DbSystemProperty.getValueByName("OID_COA_LPH")));
                                } catch (Exception e) {
                                    oidCoaLPH = 0;
                                }

                                try {
                                    oidCoaNPT = Long.parseLong(String.valueOf(DbSystemProperty.getValueByName("OID_COA_NPT")));
                                } catch (Exception e) {
                                    oidCoaNPT = 0;
                                }

                                try {
                                    oidCoaLPHForm = Long.parseLong(String.valueOf(DbSystemProperty.getValueByName("OID_COA_LPH_FORM")));
                                } catch (Exception e) {
                                    oidCoaLPHForm = 0;
                                }

                                try {
                                    oidCoaPromotion = Long.parseLong(String.valueOf(DbSystemProperty.getValueByName("OID_COA_PROMOTION")));
                                } catch (Exception e) {
                                    oidCoaPromotion = 0;
                                }

                                try {
                                    oidCoaBarcode = Long.parseLong(String.valueOf(DbSystemProperty.getValueByName("OID_COA_BARCODE")));
                                } catch (Exception e) {
                                    oidCoaBarcode = 0;
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

                                //Potongan LPH
                                if (oidCoaLPH != 0 && (lphQty * lphAmount) != 0) {
                                    Coa cLPH = new Coa();
                                    try {
                                        cLPH = DbCoa.fetchExc(oidCoaLPH);
                                        if (cLPH.getOID() != 0) {
                                            MemorialDetail md = new MemorialDetail();
                                            md.setMemorialId(oidMemorial);
                                            md.setAmount((lphQty * lphAmount));
                                            md.setCoaId(cLPH.getOID());
                                            md.setNote("LPH ");
                                            note = "LPH";
                                            try {
                                                DbMemorialDetail.insertExc(md);
                                            } catch (Exception e) {
                                            }
                                        }
                                    } catch (Exception e) {
                                    }
                                }

                                //Poyongan NPT
                                if (oidCoaNPT != 0 && (nptQty * nptAmount) != 0) {
                                    Coa cNPT = new Coa();
                                    try {
                                        cNPT = DbCoa.fetchExc(oidCoaNPT);
                                        if (cNPT.getOID() != 0) {
                                            MemorialDetail md = new MemorialDetail();
                                            md.setMemorialId(oidMemorial);
                                            md.setAmount((nptQty * nptAmount));
                                            md.setCoaId(cNPT.getOID());
                                            md.setNote("NPT ");
                                            if (note != null && note.length() > 0) {
                                                note = note + "/NPT";
                                            }
                                            try {
                                                DbMemorialDetail.insertExc(md);
                                            } catch (Exception e) {
                                            }
                                        }
                                    } catch (Exception e) {
                                    }
                                }

                                //Potongan LPH Form
                                if (oidCoaLPHForm != 0 && (lphfQty * lphfAmount) != 0) {
                                    Coa cLPHForm = new Coa();
                                    try {
                                        cLPHForm = DbCoa.fetchExc(oidCoaLPHForm);
                                        if (cLPHForm.getOID() != 0) {
                                            MemorialDetail md = new MemorialDetail();
                                            md.setMemorialId(oidMemorial);
                                            md.setAmount((lphfQty * lphfAmount));
                                            md.setCoaId(cLPHForm.getOID());
                                            md.setNote("LPH Form ");
                                            if (note != null && note.length() > 0) {
                                                note = note + "/LPH Form";
                                            }
                                            try {
                                                DbMemorialDetail.insertExc(md);
                                            } catch (Exception e) {
                                            }
                                        }
                                    } catch (Exception e) {
                                    }
                                }

                                //Promotion
                                if (oidCoaPromotion != 0 && (((promoQty / 100) * totalAmount)) != 0) {
                                    Coa cPromotion = new Coa();
                                    try {
                                        cPromotion = DbCoa.fetchExc(oidCoaPromotion);
                                        if (cPromotion.getOID() != 0) {
                                            MemorialDetail md = new MemorialDetail();
                                            md.setMemorialId(oidMemorial);
                                            md.setAmount(((promoQty / 100) * totalAmount));
                                            md.setCoaId(cPromotion.getOID());
                                            md.setNote("Promotion ");
                                            if (note != null && note.length() > 0) {
                                                note = note + "/Promotion";
                                            }
                                            try {
                                                DbMemorialDetail.insertExc(md);
                                            } catch (Exception e) {
                                            }
                                        }
                                    } catch (Exception e) {
                                    }
                                }

                                //Barcode
                                if (oidCoaBarcode != 0 && barcodeQty != 0 && barcode != 0) {
                                    Coa cBarcode = new Coa();
                                    try {
                                        cBarcode = DbCoa.fetchExc(oidCoaBarcode);
                                        if (cBarcode.getOID() != 0) {
                                            MemorialDetail md = new MemorialDetail();
                                            md.setMemorialId(oidMemorial);
                                            md.setAmount(barcode * barcodeQty);
                                            md.setCoaId(cBarcode.getOID());
                                            md.setNote("Barcode ");
                                            if (note != null && note.length() > 0) {
                                                note = note + "/Barcode";
                                            }
                                            try {
                                                DbMemorialDetail.insertExc(md);
                                            } catch (Exception e) {
                                            }
                                        }
                                    } catch (Exception e) {
                                    }
                                }

                                if (oidHutangTrade != 0) {

                                    Vector listDetail = DbMemorialDetail.list(0, 0, DbMemorialDetail.colNames[DbMemorialDetail.CL_MEMORIAL_ID] + " = " + oidMemorial, null);
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
                                                MemorialDetail md = (MemorialDetail) listDetail.get(t);
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
                                                        MemorialDetail md = (MemorialDetail) listDetail.get(t);
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

            Vector units = DbUom.listAll();
            Hashtable unitxs = new Hashtable();
            for (int x = 0; x < units.size(); x++) {
                Uom u = (Uom) units.get(x);
                unitxs.put("" + u.getOID(), u.getUnit());
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
            
            function cmdPrintJournalXLS(){	                       
                window.open("<%=printroot%>.report.RptKomisiXls?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdPostJournal(){
                    document.frmsales.command.value="<%=JSPCommand.POST%>";            
                    document.frmsales.action="rptkomisi.jsp";
                    document.frmsales.submit();
                }   
                
                function cmdPrintJournalXLS2(){	                       
                    window.open("<%=printroot%>.report.ReportKomisiXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                    }
                    
                    function cmdSearch(){
                        document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                        document.frmsales.action="rptkomisi.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Sales Report
                                                                                                                                        </font><font class="tit1">&raquo; 
                                                                                                                                <span class="lvl2">Komisi Report<br></span></font></b></td>
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
                                                                                                                                <td height="8" valign="middle" colspan="3" >   
                                                                                                                                    <table border="0" cellspacing="1" cellpadding="0" width="600" >
                                                                                                                                        <tr> 
                                                                                                                                            <td width="100" height="14" width="10"></td>
                                                                                                                                            <td width="2" height="14" nowrap>&nbsp;</td>
                                                                                                                                            <td colspan="2" height="14">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="23"> 
                                                                                                                                            <td height="14" class="tablearialcell">&nbsp;&nbsp;Date Between</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td colspan="3">
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
                                                                                                                                        <tr height="23"> 
                                                                                                                                            <td height="14" nowrap class="tablearialcell">&nbsp;&nbsp;Suplier</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td height="14"> 
                                                                                                                                                <%
            String whereKom = DbVendor.colNames[DbVendor.COL_IS_KOMISI] + " = 1";
            Vector vVendor = DbVendor.list(0, 0, whereKom, DbVendor.colNames[DbVendor.COL_NAME]);

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
                                                                                                                                            <td height="15">&nbsp;</td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="23">
                                                                                                                                            <td height="14" class="tablearialcell">&nbsp;&nbsp;Location</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td height="14"> 
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
                                                                                                                                            <td height="14">&nbsp;</td>
                                                                                                                                        </tr>  
                                                                                                                                        <tr height="23">
                                                                                                                                            <td height="14" class="tablearialcell">&nbsp;&nbsp;Group</td>
                                                                                                                                            <td height="14" class="fontarial">:</td>
                                                                                                                                            <td height="14" class="fontarial"><table border="0" cellpadding="0" cellspacing="0"><tr><td><input type="checkbox" name="group_by_date" value="1" <%if (groupByDate == 1) {%> checked <%}%> ></td><td class="fontarial">&nbsp;&nbsp;By Date</td></tr></table></td>
                                                                                                                                            <td height="14"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr height="23">
                                                                                                                                            <td height="14" class="tablearialcell" valign="top">&nbsp;&nbsp;Deduction</td>
                                                                                                                                            <td height="14" class="fontarial" valign="top">:</td>
                                                                                                                                            <td height="14" class="fontarial" colspan="2">
                                                                                                                                                <table border="0" cellpadding="0" cellspacing="1" width="300">
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablearialhdr">Description</td>
                                                                                                                                                        <td class="tablearialhdr">Qty</td>                                                                                                                                                        
                                                                                                                                                        <td class="tablearialhdr">Value</td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;LPH</td>
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" size="5" name="lph_qty" value="<%=lphQty%>" class="fontarial" style="text-align:right"></td>                                                                                                                                                        
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" name="lph_amount" value="<%=lphAmount%>" class="fontarial" style="text-align:right"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;NPT</td>
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" size="5" name="npt_qty" value="<%=nptQty%>" class="fontarial" style="text-align:right"></td>                                                                                                                                                        
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" name="npt_amount" value="<%=nptAmount%>" class="fontarial" style="text-align:right"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;LPH Form</td>
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" size="5" name="lphf_qty" value="<%=lphfQty%>" class="fontarial" style="text-align:right"></td>                                                                                                                                                        
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" name="lphf_amount" value="<%=lphfAmount%>" class="fontarial" style="text-align:right"></td>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Promotion</td>
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" size="5" name="promo_qty" value="<%=promoQty%>" class="fontarial" style="text-align:right"></td>                                                                                                                                                        
                                                                                                                                                        <td class="tablearialcell" align="left">%</td>                                                                                                                                                        
                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Barcode</td>
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" size="5" name="barcode_qty" value="<%=barcodeQty%>" class="fontarial" style="text-align:right"></td>                                                                                                                                                        
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" name="barcode" value="<%=barcode%>" class="fontarial" style="text-align:right"></td>                                                                                                                                                        
                                                                                                                                                        
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td class="tablearialcell">&nbsp;&nbsp;Other</td>
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" size="5" name="other_qty" value="<%=otherQty%>" class="fontarial" style="text-align:right"></td>                                                                                                                                                        
                                                                                                                                                        <td class="tablearialcell" align="center"><input type="text" name="other_amount" value="<%=otherAmount%>" class="fontarial" style="text-align:right"></td>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td >
                                                                                                                                    <table width="80%" border="0" cellspacing="1" cellpadding="1" height="3">
                                                                                                                                        <tr > 
                                                                                                                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                                                                                                                        </tr>
                                                                                                                                    </table> 
                                                                                                                                </td>
                                                                                                                            </tr> 
                                                                                                                            
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;<a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/search2.gif',1)"><img src="../images/search.gif" name="new2" border="0"></a></td>
                                                                                                                            </tr> 
                                                                                                                            
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td>
                                                                                                                            </tr> 
                                                                                                                            <%
            if (result != null && result.size() > 0) {

                if (groupByDate == 0) {
                    double totTotal = 0;
                    Vector resultDeduction = new Vector();
                                                                                                                            %>
                                                                                                                            
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">    
                                                                                                                                    <table width="1000" border="0" cellspacing="1" cellpadding="2">
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="9" class="fontarial" bgcolor="#BFD8AF"><i>&nbsp;<%=parameter%></i></td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialhdr" width="6%">No</td>                                                                                                                                            
                                                                                                                                            <td class="tablearialhdr" width="15%">Date</td>
                                                                                                                                            <td class="tablearialhdr" width="15%">Sales Number</td>
                                                                                                                                            <td class="tablearialhdr" >Description</td>
                                                                                                                                            <td class="tablearialhdr" width="10%">Qty</td>
                                                                                                                                            <td class="tablearialhdr" width="10%">Price</td>
                                                                                                                                            <td class="tablearialhdr" width="10%">Discount</td>
                                                                                                                                            <td class="tablearialhdr" width="10%">Total</td>
                                                                                                                                            <td class="tablearialhdr" width="10%">Total</td>
                                                                                                                                        </tr>   
                                                                                                                                        <%
                                                                                                                                    int number = 1;
                                                                                                                                    long salesId = 0;
                                                                                                                                    double total = 0;
                                                                                                                                    double totQty = 0;
                                                                                                                                    double gTotQty = 0;

                                                                                                                                    for (int i = 0; i < result.size(); i++) {

                                                                                                                                        ReportKomisi rk = (ReportKomisi) result.get(i);
                                                                                                                                        double totPrice = (rk.getQty() * rk.getSellingPrice()) - rk.getDiscount();

                                                                                                                                        if (salesId != rk.getSalesId() && i != 0) {
                                                                                                                                            totTotal = totTotal + total;
                                                                                                                                            gTotQty = gTotQty + totQty;
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell1" colspan="4" align="right">&nbsp;</td>  
                                                                                                                                            <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(totQty, "###,###")%></td>  
                                                                                                                                            <td class="tablearialcell1" colspan="3" align="right">&nbsp;</td>                                                                                                                                              
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(total, "###,###.##")%></B></td>  
                                                                                                                                        </tr>  
                                                                                                                                        <%
                                                                                                                                                total = 0;
                                                                                                                                                totQty = 0;
                                                                                                                                            }
                                                                                                                                            total = total + totPrice;
                                                                                                                                            totQty = totQty + rk.getQty();
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <%if (salesId != rk.getSalesId()) {%>
                                                                                                                                            <td class="tablearialcell" align="center"><%=number%></td>  
                                                                                                                                            <td class="tablearialcell" align="center"><%=JSPFormater.formatDate(rk.getTanggal(), "dd-MMM-yyyy")%></td>  
                                                                                                                                            <%
    number++;
} else {
                                                                                                                                            %>
                                                                                                                                            <td class="tablearialcell" align="center">&nbsp;</td>  
                                                                                                                                            <td class="tablearialcell" align="center">&nbsp;</td>                                                                                                                                              
                                                                                                                                            <%}%> 
                                                                                                                                            <td class="tablearialcell" align="left"><%=rk.getSalesNumber()%></td>  
                                                                                                                                            <td class="tablearialcell" align="left"><%=rk.getName()%></td>  
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(rk.getQty(), "###,###")%></td>                                                                                                                                              
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(rk.getSellingPrice(), "###,###")%></td>  
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(rk.getDiscount(), "###,###")%></td>  
                                                                                                                                            <td class="tablearialcell" align="right"><%=JSPFormater.formatNumber(totPrice, "###,###")%></td>                                                                                                                                              
                                                                                                                                            <td class="tablearialcell" align="right">&nbsp;</td>  
                                                                                                                                        </tr>    
                                                                                                                                        <%
                                                                                                                                        salesId = rk.getSalesId();
                                                                                                                                    }
                                                                                                                                        %>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell1" colspan="4" align="right">&nbsp;</td>  
                                                                                                                                            <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(totQty, "###,###")%></td>  
                                                                                                                                            <td class="tablearialcell1" colspan="3" align="right">&nbsp;</td>                                                                                                                                            
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(total, "###,###.##")%></B></td>  
                                                                                                                                        </tr>  
                                                                                                                                        <%totTotal = totTotal + total;%>
                                                                                                                                        <%gTotQty = gTotQty + totQty;%>
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialcell1" colspan="4" align="center"><B>GRAND TOTAL</B></td>    
                                                                                                                                            <td class="tablearialcell1" align="right"><%=JSPFormater.formatNumber(gTotQty, "###,###")%></td>  
                                                                                                                                            <td class="tablearialcell1" colspan="3" align="right">&nbsp;</td> 
                                                                                                                                            <td class="tablearialcell1" align="right"><B><%=JSPFormater.formatNumber(totTotal, "###,###.##")%></B></td>                                                                                                                                                                                                                                                                                        
                                                                                                                                        </tr>  
                                                                                                                                        <tr height="40"> 
                                                                                                                                            <td colspan="8" align="center">&nbsp;</td>                                                                                                                                                                                                                                                                                       
                                                                                                                                        </tr>  
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5" class="fontarial"><B>Total Sales</B></td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(totTotal, "###,###.##")%></B></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
                                                                                                                                    Vendor v = new Vendor();
                                                                                                                                    try {
                                                                                                                                        v = DbVendor.fetchExc(vendorId);
                                                                                                                                    } catch (Exception e) {
                                                                                                                                    }

                                                                                                                                    double vatOut = 0;
                                                                                                                                    if (v.getIsPKP() == 1) {
                                                                                                                                        vatOut = totTotal - (100 * totTotal / 110);
                                                                                                                                    }

                                                                                                                                    double margin = (v.getKomisiMargin() / 100) * (totTotal - vatOut);
                                                                                                                                    double net = totTotal - margin - vatOut;
                                                                                                                                    double vatIn = 0;
                                                                                                                                    if (v.getIsPKP() == 1) {
                                                                                                                                        vatIn = net * 10 / 100;
                                                                                                                                    }
                                                                                                                                    double subTotal2 = net + vatIn;
                                                                                                                                        %>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5" class="fontarial"><B>VAT Out</B></td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(vatOut, "###,###.##")%></B></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5" class="fontarial"><B>Commision <%=v.getKomisiMargin()%> %</B></td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(margin, "###,###.##")%></B></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5" class="fontarial"><B>Subtotal 1</B></td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(net, "###,###.##")%></B></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5" class="fontarial"><B>VAT In</B></td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(vatIn, "###,###.##")%></B></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr> 
                                                                                                                                            <td colspan="5" class="fontarial"><B>Subtotal 2</B></td>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(subTotal2, "###,###.##")%></B></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="7" class="fontarial"><B>Deduction</B></td>                                                                                                                                            
                                                                                                                                            <td align="right"></td>
                                                                                                                                            <td align="right" ></td>
                                                                                                                                        </tr>
                                                                                                                                        <%
                                                                                                                                    double totDeduction = 0;
                                                                                                                                    ReportKomisi rkLPH = new ReportKomisi();
                                                                                                                                    rkLPH.setName("LPH");
                                                                                                                                    rkLPH.setQty(lphQty);
                                                                                                                                    rkLPH.setSellingPrice(lphAmount);

                                                                                                                                    ReportKomisi rkNpt = new ReportKomisi();
                                                                                                                                    rkNpt.setName("NPT");
                                                                                                                                    rkNpt.setQty(nptQty);
                                                                                                                                    rkNpt.setSellingPrice(nptAmount);

                                                                                                                                    ReportKomisi rkLPHf = new ReportKomisi();
                                                                                                                                    rkLPHf.setName("LPH Form");
                                                                                                                                    rkLPHf.setQty(lphfQty);
                                                                                                                                    rkLPHf.setSellingPrice(lphfAmount);

                                                                                                                                    ReportKomisi rkPromo = new ReportKomisi();
                                                                                                                                    rkPromo.setName("Promotion");
                                                                                                                                    rkPromo.setQty(promoQty);
                                                                                                                                    rkPromo.setSellingPrice(totTotal);

                                                                                                                                    ReportKomisi rkBarcode = new ReportKomisi();
                                                                                                                                    rkBarcode.setName("Barcode");
                                                                                                                                    rkBarcode.setQty(barcodeQty);
                                                                                                                                    rkBarcode.setSellingPrice(barcode);

                                                                                                                                    ReportKomisi rkOther = new ReportKomisi();
                                                                                                                                    rkOther.setName("Other");
                                                                                                                                    rkOther.setQty(otherQty);
                                                                                                                                    rkOther.setSellingPrice(otherAmount);

                                                                                                                                    resultDeduction.add(rkLPH);
                                                                                                                                    resultDeduction.add(rkNpt);
                                                                                                                                    resultDeduction.add(rkLPHf);
                                                                                                                                    resultDeduction.add(rkPromo);
                                                                                                                                    resultDeduction.add(rkBarcode);
                                                                                                                                    resultDeduction.add(rkOther);
                                                                                                                                        %>
                                                                                                                                        <input type="hidden" name="hidden_total_amount" value="<%=totTotal%>" >                                                                                                                                        
                                                                                                                                        <tr>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                            <td align="left" colspan="5">
                                                                                                                                                <table>
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="80" class="fontarial"><b>LPH</b><td>
                                                                                                                                                        <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(lphQty, "###,###.##")%> x <%=JSPFormater.formatNumber(lphAmount, "###,###.##")%></b><td>
                                                                                                                                                        <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((lphQty * lphAmount), "###,###.##")%></b><td>
                                                                                                                                                        <%totDeduction = totDeduction + (lphQty * lphAmount);%>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="80" class="fontarial"><b>NPT</b><td>
                                                                                                                                                        <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(nptQty, "###,###.##")%> x <%=JSPFormater.formatNumber(nptAmount, "###,###.##")%></b><td>
                                                                                                                                                        <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((nptQty * nptAmount), "###,###.##")%></b><td>
                                                                                                                                                        <%totDeduction = totDeduction + (nptQty * nptAmount);%>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="80" class="fontarial"><b>LPH Form</b><td>
                                                                                                                                                        <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(lphfQty, "###,###.##")%> x <%=JSPFormater.formatNumber(lphfAmount, "###,###.##")%></b><td>
                                                                                                                                                        <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((lphfQty * lphfAmount), "###,###.##")%></b><td>
                                                                                                                                                        <%totDeduction = totDeduction + (lphfQty * lphfAmount);%>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="80" class="fontarial"><b>Promotion</b><td>
                                                                                                                                                        <td width="150" class="fontarial"><b><%=(promoQty)%> % x <%=JSPFormater.formatNumber(totTotal, "###,###.##")%></b><td>
                                                                                                                                                        <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber(((promoQty / 100) * totTotal), "###,###.##")%></b><td>
                                                                                                                                                        <%totDeduction = totDeduction + ((promoQty / 100) * totTotal);%>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="80" class="fontarial"><b>Barcode</b><td>
                                                                                                                                                        <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(barcodeQty, "###,###")%> x <%=JSPFormater.formatNumber(barcode, "###,###.##")%></b><td>
                                                                                                                                                        <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((barcode * barcodeQty), "###,###.##")%></b><td>
                                                                                                                                                        <%totDeduction = totDeduction + (barcode * barcodeQty);%>
                                                                                                                                                    </tr>
                                                                                                                                                    <tr>
                                                                                                                                                        <td width="80" class="fontarial"><b>Other</b><td>
                                                                                                                                                        <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(otherQty, "###,###.##")%> x <%=JSPFormater.formatNumber(otherAmount, "###,###.##")%></b><td>
                                                                                                                                                        <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((otherQty * otherAmount), "###,###.##")%></b><td>
                                                                                                                                                        <%totDeduction = totDeduction + (otherQty * otherAmount);%>
                                                                                                                                                    </tr>
                                                                                                                                                </table>
                                                                                                                                            </td>
                                                                                                                                            <td align="right" colspan="2"></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="7" class="fontarial"><B>Total Deduction</B></td>                                                                                                                                            
                                                                                                                                            <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(totDeduction, "###,###.##")%></B></td>
                                                                                                                                        </tr>
                                                                                                                                        <tr>                                                                                                                                               
                                                                                                                                            <td align="left" colspan="7" class="fontarial"><B>Grand Total</B></td>                                                                                                                                            
                                                                                                                                            <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                            <td align="right" class="fontarial" ><B><%=JSPFormater.formatNumber((subTotal2 - totDeduction), "###,###.##")%></B></td>
                                                                                                                                        </tr>
                                                                                                                                    </table>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4">&nbsp;</td>     
                                                                                                                            </tr> 
                                                                                                                            <%
                                                                                                                                    String where = " to_days(" + DbMemorial.colNames[DbMemorial.CL_START_DATE] + ") = to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(" + DbMemorial.colNames[DbMemorial.CL_END_DATE] + ") = to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
                                                                                                                                    if (vendorId != 0) {
                                                                                                                                        where = where + " and " + DbMemorial.colNames[DbMemorial.CL_VENDOR_ID] + " = " + vendorId;
                                                                                                                                    }
                                                                                                                                    if (locationId != 0) {
                                                                                                                                        where = where + " and " + DbMemorial.colNames[DbMemorial.CL_LOCATION_ID] + " = " + locationId;
                                                                                                                                    }
                                                                                                                                    Vector memorials = DbMemorial.list(0, 1, where, null);
                                                                                                                                    Vector gls = new Vector();
                                                                                                                                    if (memorials != null && memorials.size() > 0) {
                                                                                                                                        for (int r = 0; r < memorials.size(); r++) {
                                                                                                                                            Memorial m = (Memorial) memorials.get(r);
                                                                                                                                            String whereRefId = DbReceive.colNames[DbReceive.COL_REFERENCE_ID] + " = " + m.getOID();
                                                                                                                                            Vector recs = DbReceive.list(0, 1, whereRefId, null);
                                                                                                                                            try {
                                                                                                                                                if (recs != null && recs.size() > 0) {
                                                                                                                                                    Receive rec = (Receive) recs.get(0);
                                                                                                                                                    String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + rec.getNumber() + "'";
                                                                                                                                                    gls = DbGl.list(0, 1, whereGl, null);
                                                                                                                                                }
                                                                                                                                            } catch (Exception e) {
                                                                                                                                            }
                                                                                                                                        }
                                                                                                                                    }


                                                                                                                                    if (privPrint || privAdd) {
                                                                                                                                        session.putValue("REPORT_KOMISI_DEDUCTION", resultDeduction);
                                                                                                                            %>
                                                                                                                            <tr align="left" valign="top"> 
                                                                                                                                <td height="22" valign="middle" colspan="4"> 
                                                                                                                                    <%if (privPrint) {%>
                                                                                                                                    <a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" height="22" border="0"></a>
                                                                                                                                    <%}%>
                                                                                                                                    <%if (privAdd && (gls == null || gls.size() <= 0)) {%>
                                                                                                                                    <a href="javascript:cmdPostJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a>                                                                                                                                                                                                                                                                                                                       
                                                                                                                                    <%}%>
                                                                                                                                </td>     
                                                                                                                            </tr>     
                                                                                                                            <% }%>
                                                                                                                            <%} else { // Jika kondisinya by date

                                                                                                                                    Vector resultPrint = new Vector();
                                                                                                                                    Vector resultDeduction = new Vector();
                                                                                                                            %>
                                                                                                                            <table width="900" border="0" cellspacing="1" cellpadding="2">
                                                                                                                                <tr>
                                                                                                                                    <td colspan="9" class="fontarial" bgcolor="#BFD8AF"><i>&nbsp;<%=parameter%></i></td>
                                                                                                                                </tr>   
                                                                                                                                <tr height="20"> 
                                                                                                                                    <td class="tablehdr" width="25">No</td>                                                                                                                                            
                                                                                                                                    <td class="tablehdr" width="100">Date</td>
                                                                                                                                    <td class="tablehdr" >Item Name</td>                                                                                                                                    
                                                                                                                                    <td class="tablehdr" width="80">UoM</td>
                                                                                                                                    <td class="tablehdr" width="150">Qty</td>                                                                                                                                    
                                                                                                                                    <td class="tablehdr" width="200">Amount</td>
                                                                                                                                </tr>   
                                                                                                                                <%
                                                                                                                                    CONResultSet dbrs = null;
                                                                                                                                    try {
                                                                                                                                        String groupBy = "";
                                                                                                                                        String groupBy2 = "";

                                                                                                                                        switch (CONHandler.CONSVR_TYPE) {
                                                                                                                                            case CONHandler.CONSVR_MYSQL:
                                                                                                                                                groupBy = " year(ps.date),month(ps.date),date(ps.date) ";
                                                                                                                                                groupBy2 = " year(date),month(date),date(date) ";
                                                                                                                                                break;

                                                                                                                                            case CONHandler.CONSVR_POSTGRESQL:
                                                                                                                                                groupBy = " EXTRACT(YEAR FROM (ps.date)),EXTRACT(MONTH FROM (ps.date)),EXTRACT(DAY FROM (ps.date))";
                                                                                                                                                groupBy2 = " EXTRACT(YEAR FROM (date)),EXTRACT(MONTH FROM (date)),EXTRACT(DAY FROM (date))";
                                                                                                                                                break;

                                                                                                                                            case CONHandler.CONSVR_SYBASE:
                                                                                                                                                break;

                                                                                                                                            case CONHandler.CONSVR_ORACLE:
                                                                                                                                                break;

                                                                                                                                            case CONHandler.CONSVR_MSSQL:
                                                                                                                                                break;

                                                                                                                                            default:
                                                                                                                                                groupBy = " year(ps.date),month(ps.date),date(ps.date)";
                                                                                                                                                groupBy2 = " year(date),month(date),date(date) ";
                                                                                                                                                break;
                                                                                                                                        }

                                                                                                                                        String sql = "select number,sales_id,date,code,name,uom,sum(qty) as x_qty,sum(selling_price) as x_selling_price,sum(amount) as x_amount,sum(discount_amount) as x_discount_amount from ( " +
                                                                                                                                                " select ps.number as number,ps.sales_id as sales_id,ps.date as date,m.code as code,m.name as name,m.uom_sales_id as uom,sum(psd.qty) as qty,psd.selling_price,sum((psd.qty * psd.selling_price)-psd.discount_amount) as amount,sum(psd.discount_amount) as discount_amount  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_item_master m on psd.product_master_id = m.item_master_id  where m.type_item = 2 and ps.type in(0,1)  and m.default_vendor_id = " + vendorId + " and  ps.location_id = " + locationId + " and  ps.date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and ps.date <= '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59' group by " + groupBy +
                                                                                                                                                " union " +
                                                                                                                                                " select ps.number as number,ps.sales_id as sales_id,ps.date as date,m.code as code,m.name as name,m.uom_sales_id as uom,sum(psd.qty) *-1 as qty,psd.selling_price,sum((psd.qty * psd.selling_price)-psd.discount_amount)*-1 as amount,sum(psd.discount_amount)*-1 as discount_amount  from pos_sales ps inner join pos_sales_detail psd on ps.sales_id = psd.sales_id inner join pos_item_master m on psd.product_master_id = m.item_master_id  where m.type_item = 2 and ps.type in(2,3)  and m.default_vendor_id = " + vendorId + " and  ps.location_id = " + locationId + " and ps.date >= '" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + " 00:00:00' and ps.date <= '" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + " 23:59:59' group by " + groupBy +
                                                                                                                                                " ) as x group by " + groupBy2 + " order by date";

                                                                                                                                        dbrs = CONHandler.execQueryResult(sql);
                                                                                                                                        ResultSet rs = dbrs.getResultSet();
                                                                                                                                        int no = 1;
                                                                                                                                        double totQty = 0;
                                                                                                                                        double totAmount = 0;
                                                                                                                                        while (rs.next()) {
                                                                                                                                            ReportKomisi rKom = new ReportKomisi();
                                                                                                                                            Date date = rs.getDate("date");
                                                                                                                                            String item = rs.getString("name");
                                                                                                                                            double qty = rs.getDouble("x_qty");
                                                                                                                                            double amount = rs.getDouble("x_amount");
                                                                                                                                            long uomId = rs.getLong("uom");

                                                                                                                                            String strUom = "";
                                                                                                                                            try {
                                                                                                                                                strUom = String.valueOf(unitxs.get("" + uomId));
                                                                                                                                            } catch (Exception e) {
                                                                                                                                                strUom = "";
                                                                                                                                            }

                                                                                                                                            rKom.setTanggal(date);
                                                                                                                                            rKom.setName(item);
                                                                                                                                            rKom.setQty(qty);
                                                                                                                                            rKom.setSellingPrice(amount);
                                                                                                                                            rKom.setStn(strUom);
                                                                                                                                            resultPrint.add(rKom);

                                                                                                                                            totQty = totQty + qty;
                                                                                                                                            totAmount = totAmount + amount;

                                                                                                                                            String style = "";
                                                                                                                                            if (no % 2 == 0) {
                                                                                                                                                style = "tablearialcell";
                                                                                                                                            } else {
                                                                                                                                                style = "tablearialcell1";
                                                                                                                                            }

                                                                                                                                %>
                                                                                                                                <tr height="20"> 
                                                                                                                                    <td class="<%=style%>" align="center"><%=no%></td>                                                                                                                                            
                                                                                                                                    <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(date, "yyyy-MM-dd")%></td>
                                                                                                                                    <td class="<%=style%>" ><%=item%></td>                                                                                                                                    
                                                                                                                                    <td class="<%=style%>" ><%=strUom%></td> 
                                                                                                                                    <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(qty, "###,###.##")%>&nbsp;</td>                                                                                                                                    
                                                                                                                                    <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(amount, "###,###.##")%>&nbsp;</td>
                                                                                                                                </tr>   
                                                                                                                                <%
                                                                                                                                        no++;
                                                                                                                                    }
                                                                                                                                    if (no > 1) {%>
                                                                                                                                <tr height="20"> 
                                                                                                                                    <td bgcolor="#cccccc" colspan="4" align="center" class="fontarial"><b>Grand Total<b></td>                                                                                                                                                                                                                                                                                
                                                                                                                                    <td bgcolor="#cccccc" align="right" class="fontarial"><b><%=JSPFormater.formatNumber(totQty, "###,###.##")%></b>&nbsp;</td>                                                                                                                                    
                                                                                                                                    <td bgcolor="#cccccc" align="right" class="fontarial"><b><%=JSPFormater.formatNumber(totAmount, "###,###.##")%></b>&nbsp;</td>
                                                                                                                                </tr>
                                                                                                                                <tr>
                                                                                                                                    <td colspan="3">&nbsp;</td>
                                                                                                                                </tr>                                                                                                                                    
                                                                                                                                <tr>
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>Total Sales</B></td>                                                                                                                                            
                                                                                                                                    <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                    <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(totAmount, "###,###.##")%></B></td>
                                                                                                                                </tr> 
                                                                                                                                <%
                                                                                                                                Vendor v = new Vendor();
                                                                                                                                try {
                                                                                                                                    v = DbVendor.fetchExc(vendorId);
                                                                                                                                } catch (Exception e) {
                                                                                                                                }

                                                                                                                                double vatOut = 0;
                                                                                                                                if (v.getIsPKP() == 1) {
                                                                                                                                    vatOut = totAmount - (100 * totAmount / 110);
                                                                                                                                }

                                                                                                                                double margin = (v.getKomisiMargin() / 100) * (totAmount - vatOut);
                                                                                                                                double net = totAmount - margin - vatOut;
                                                                                                                                double vatIn = 0;
                                                                                                                                if (v.getIsPKP() == 1) {
                                                                                                                                    vatIn = net * 10 / 100;
                                                                                                                                }
                                                                                                                                double subTotal2 = net + vatIn;

                                                                                                                                %>
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>VAT Out</B></td>                                                                                                                                            
                                                                                                                                    <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                    <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(vatOut, "###,###.##")%></B></td>
                                                                                                                                </tr> 
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>Commision <%=v.getKomisiMargin()%> %</B></td>                                                                                                                                            
                                                                                                                                    <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                    <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(margin, "###,###.##")%></B></td>
                                                                                                                                </tr> 
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>Subtotal 1</B></td>                                                                                                                                            
                                                                                                                                    <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                    <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(net, "###,###.##")%></B></td>
                                                                                                                                </tr>
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>VAT In</B></td>                                                                                                                                            
                                                                                                                                    <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                    <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(vatIn, "###,###.##")%></B></td>
                                                                                                                                </tr>
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>Subtotal 2</B></td>                                                                                                                                            
                                                                                                                                    <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                    <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(subTotal2, "###,###.##")%></B></td>
                                                                                                                                </tr>
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>Deduction</B></td>                                                                                                                                            
                                                                                                                                    <td align="right"></td>
                                                                                                                                    <td align="right" ></td>
                                                                                                                                </tr>
                                                                                                                                <%
                                                                                                                                double totDeduction = 0;
                                                                                                                                ReportKomisi rkLPH = new ReportKomisi();
                                                                                                                                rkLPH.setName("LPH");
                                                                                                                                rkLPH.setQty(lphQty);
                                                                                                                                rkLPH.setSellingPrice(lphAmount);

                                                                                                                                ReportKomisi rkNpt = new ReportKomisi();
                                                                                                                                rkNpt.setName("NPT");
                                                                                                                                rkNpt.setQty(nptQty);
                                                                                                                                rkNpt.setSellingPrice(nptAmount);

                                                                                                                                ReportKomisi rkLPHf = new ReportKomisi();
                                                                                                                                rkLPHf.setName("LPH Form");
                                                                                                                                rkLPHf.setQty(lphfQty);
                                                                                                                                rkLPHf.setSellingPrice(lphfAmount);

                                                                                                                                ReportKomisi rkPromo = new ReportKomisi();
                                                                                                                                rkPromo.setName("Promotion");
                                                                                                                                rkPromo.setQty(promoQty);
                                                                                                                                rkPromo.setSellingPrice(totAmount);

                                                                                                                                ReportKomisi rkBarcode = new ReportKomisi();
                                                                                                                                rkBarcode.setName("Barcode");
                                                                                                                                rkBarcode.setQty(barcodeQty);
                                                                                                                                rkBarcode.setSellingPrice(barcode);

                                                                                                                                ReportKomisi rkOther = new ReportKomisi();
                                                                                                                                rkOther.setName("Other");
                                                                                                                                rkOther.setQty(otherQty);
                                                                                                                                rkOther.setSellingPrice(otherAmount);

                                                                                                                                resultDeduction.add(rkLPH);
                                                                                                                                resultDeduction.add(rkNpt);
                                                                                                                                resultDeduction.add(rkLPHf);
                                                                                                                                resultDeduction.add(rkPromo);
                                                                                                                                resultDeduction.add(rkBarcode);
                                                                                                                                resultDeduction.add(rkOther);

                                                                                                                                %>
                                                                                                                                <input type="hidden" name="hidden_total_amount" value="<%=totAmount%>" >                                                                                                                                
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="2"></td>                                                                                                                                            
                                                                                                                                    <td align="left" colspan="3">
                                                                                                                                        <table>
                                                                                                                                            <tr>
                                                                                                                                                <td width="80" class="fontarial"><b>LPH</b><td>
                                                                                                                                                <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(lphQty, "###,###.##")%> x <%=JSPFormater.formatNumber(lphAmount, "###,###.##")%></b><td>
                                                                                                                                                <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((lphQty * lphAmount), "###,###.##")%></b><td>
                                                                                                                                                <%totDeduction = totDeduction + (lphQty * lphAmount);%>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td width="80" class="fontarial"><b>NPT</b><td>
                                                                                                                                                <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(nptQty, "###,###.##")%> x <%=JSPFormater.formatNumber(nptAmount, "###,###.##")%></b><td>
                                                                                                                                                <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((nptQty * nptAmount), "###,###.##")%></b><td>
                                                                                                                                                <%totDeduction = totDeduction + (nptQty * nptAmount);%>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td width="80" class="fontarial"><b>LPH Form</b><td>
                                                                                                                                                <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(lphfQty, "###,###.##")%> x <%=JSPFormater.formatNumber(lphfAmount, "###,###.##")%></b><td>
                                                                                                                                                <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((lphfQty * lphfAmount), "###,###.##")%></b><td>
                                                                                                                                                <%totDeduction = totDeduction + (lphfQty * lphfAmount);%>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td width="80" class="fontarial"><b>Promotion</b><td>
                                                                                                                                                <td width="150" class="fontarial"><b><%=(promoQty)%> % x <%=JSPFormater.formatNumber(totAmount, "###,###.##")%></b><td>
                                                                                                                                                <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber(((promoQty / 100) * totAmount), "###,###.##")%></b><td>
                                                                                                                                                <%totDeduction = totDeduction + ((promoQty / 100) * totAmount);%>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td width="80" class="fontarial"><b>Barcode</b><td>
                                                                                                                                                <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(barcodeQty, "###,###")%> x <%=JSPFormater.formatNumber(barcode, "###,###.##")%></b><td>
                                                                                                                                                <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((barcode * barcodeQty), "###,###.##")%></b><td>
                                                                                                                                                <%totDeduction = totDeduction + (barcode * barcodeQty);%>
                                                                                                                                            </tr>
                                                                                                                                            <tr>
                                                                                                                                                <td width="80" class="fontarial"><b>Other</b><td>
                                                                                                                                                <td width="150" class="fontarial"><b><%=JSPFormater.formatNumber(otherQty, "###,###.##")%> x <%=JSPFormater.formatNumber(otherAmount, "###,###.##")%></b><td>
                                                                                                                                                <td class="fontarial"><b>= Rp <%=JSPFormater.formatNumber((otherQty * otherAmount), "###,###.##")%></b><td>
                                                                                                                                                <%totDeduction = totDeduction + (otherQty * otherAmount);%>
                                                                                                                                            </tr>
                                                                                                                                        </table>
                                                                                                                                    </td>
                                                                                                                                    <td align="right" colspan="2"></td>
                                                                                                                                </tr>
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>Total Deduction</B></td>                                                                                                                                            
                                                                                                                                    <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                    <td align="right" class="fontarial"><B><%=JSPFormater.formatNumber(totDeduction, "###,###.##")%></B></td>
                                                                                                                                </tr>
                                                                                                                                <tr>                                                                                                                                               
                                                                                                                                    <td align="left" colspan="4" class="fontarial"><B>Grand Total</B></td>                                                                                                                                            
                                                                                                                                    <td align="right" class="fontarial"><B>Rp.</B></td>
                                                                                                                                    <td align="right" class="fontarial" ><B><%=JSPFormater.formatNumber((subTotal2 - totDeduction), "###,###.##")%></B></td>
                                                                                                                                </tr>
                                                                                                                                <%

                                                                                                                                String where = " to_days(" + DbMemorial.colNames[DbMemorial.CL_START_DATE] + ") = to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(" + DbMemorial.colNames[DbMemorial.CL_END_DATE] + ") = to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
                                                                                                                                if (vendorId != 0) {
                                                                                                                                    where = where + " and " + DbMemorial.colNames[DbMemorial.CL_VENDOR_ID] + " = " + vendorId;
                                                                                                                                }
                                                                                                                                if (locationId != 0) {
                                                                                                                                    where = where + " and " + DbMemorial.colNames[DbMemorial.CL_LOCATION_ID] + " = " + locationId;
                                                                                                                                }
                                                                                                                                Vector memorials = DbMemorial.list(0, 1, where, null);
                                                                                                                                Vector gls = new Vector();
                                                                                                                                if (memorials != null && memorials.size() > 0) {
                                                                                                                                    for (int r = 0; r < memorials.size(); r++) {
                                                                                                                                        Memorial m = (Memorial) memorials.get(r);
                                                                                                                                        String whereRefId = DbReceive.colNames[DbReceive.COL_REFERENCE_ID] + " = " + m.getOID();
                                                                                                                                        Vector recs = DbReceive.list(0, 1, whereRefId, null);
                                                                                                                                        try {
                                                                                                                                            if (recs != null && recs.size() > 0) {
                                                                                                                                                Receive rec = (Receive) recs.get(0);
                                                                                                                                                String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + rec.getNumber() + "'";
                                                                                                                                                gls = DbGl.list(0, 1, whereGl, null);
                                                                                                                                            }
                                                                                                                                        } catch (Exception e) {
                                                                                                                                        }
                                                                                                                                    }
                                                                                                                                }
                                                                                                                                if (privPrint || privAdd) {
                                                                                                                                    session.putValue("REPORT_KOMISI_DETAIL", resultPrint);
                                                                                                                                    session.putValue("REPORT_KOMISI_DEDUCTION", resultDeduction);
                                                                                                                                %>
                                                                                                                                <tr align="left" valign="top"> 
                                                                                                                                    <td height="22" valign="middle" colspan="6">&nbsp;</td>     
                                                                                                                                </tr>     
                                                                                                                                <tr align="left" valign="top"> 
                                                                                                                                    <td height="22" valign="middle" colspan="6"> 
                                                                                                                                        <%if (privPrint) {%>
                                                                                                                                        <a href="javascript:cmdPrintJournalXLS2()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print" height="22" border="0"></a>
                                                                                                                                        <%}%>
                                                                                                                                        <%if (privAdd && (gls == null || gls.size() <= 0)) {%>
                                                                                                                                        <a href="javascript:cmdPostJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a>                                                                                                                                                                                                                                                                                                                       
                                                                                                                                        <%}%>
                                                                                                                                    </td>     
                                                                                                                                </tr>     
                                                                                                                                <%}%>
                                                                                                                                <%}

                                                                                                                                    } catch (Exception e) {
                                                                                                                                    }
                                                                                                                                
                                                                                                                                
                                                                                                                                
                                                                                                                                %>
                                                                                                                            </table>
                                                                                                                            <%}%>
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" colspan="4">&nbsp;</td> 
                                                                                                                            </tr>  
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" colspan="4" class="container">
                                                                                                                                    <%
                                                                                                                                String where = " to_days(" + DbMemorial.colNames[DbMemorial.CL_START_DATE] + ") = to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(" + DbMemorial.colNames[DbMemorial.CL_END_DATE] + ") = to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
                                                                                                                                if (vendorId != 0) {
                                                                                                                                    where = where + " and " + DbMemorial.colNames[DbMemorial.CL_VENDOR_ID] + " = " + vendorId;
                                                                                                                                }
                                                                                                                                if (locationId != 0) {
                                                                                                                                    where = where + " and " + DbMemorial.colNames[DbMemorial.CL_LOCATION_ID] + " = " + locationId;
                                                                                                                                }
                                                                                                                                Vector memorials = DbMemorial.list(0, 0, where, null);

                                                                                                                                if (memorials != null && memorials.size() > 0) {
                                                                                                                                    for (int r = 0; r < memorials.size(); r++) {
                                                                                                                                        Memorial m = (Memorial) memorials.get(r);
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
                                                                                                                                            <td colspan="5">
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
                                                                                                                                <td height="17" colspan="4"></td> 
                                                                                                                            </tr>  
                                                                                                                            <%} else {%>
                                                                                                                            <%if (iJSPCommand != JSPCommand.NONE) {%>
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" class="tablecell1" colspan="4"><i>&nbsp;Data not found</i></td> 
                                                                                                                            </tr>  
                                                                                                                            <%}%>
                                                                                                                            <%}%>
                                                                                                                            <%if (iJSPCommand == JSPCommand.NONE) {%>
                                                                                                                            <tr align="left" valign="middle"> 
                                                                                                                                <td height="17" colspan="4" class="fontarial"><b><i>&nbsp;Click search button to searching the data...</i></b></td> 
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

