
<%-- 
    Document   : rptkonsinyasibp
    Created on : Jun 16, 2013, 10:31:19 PM
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
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.ccs.session.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "java.sql.ResultSet" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/checksl.jsp" %>
<%@ include file="../calendar/calendarframe.jsp"%>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_BELI);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_BELI, AppMenu.PRIV_VIEW);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_BELI, AppMenu.PRIV_PRINT);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_BELI, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_BELI, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_SALES_REPORT, AppMenu.M2_SAL_REPORT_KONSINYASI_BELI, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%
            if (session.getValue("REPORT_KONSINYASI BELI") != null) {
                session.removeValue("REPORT_KONSINYASI BELI");
            }

            if (session.getValue("REPORT_KONSINYASI_COST") != null) {
                session.removeValue("REPORT_KONSINYASI_COST");
            }

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

            Vector vKonsinyasiBeli = new Vector();

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
                    memorial.setType(DbMemorialKonsinyasi.TYPE_CONSIGNED_BY_COST);
                    try {
                        String where = DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_VENDOR_ID]+"="+vendorId+" and "+DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_LOCATION_ID]+"="+locationId+" and ("+DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_START_DATE]+" between '"+JSPFormater.formatDate(invStartDate,"yyyy-MM-dd")+" 00:00:00' and '"+JSPFormater.formatDate(invStartDate,"yyyy-MM-dd")+" 23:59:59') and "+
                            " ("+DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_END_DATE]+" between '"+JSPFormater.formatDate(invEndDate,"yyyy-MM-dd")+" 00:00:00' and '"+JSPFormater.formatDate(invEndDate,"yyyy-MM-dd")+" 23:59:59') ";
                                                              
                        int count = DbMemorialKonsinyasi.getCount(where);
                        long oidMemorial = 0;
                        if(count ==0){
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
                window.open("<%=printroot%>.report.RptKonsinyasiCostPDF?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdPostJournal(){
                    document.frmsales.command.value="<%=JSPCommand.POST%>";            
                    document.frmsales.action="rptconsignedbycost.jsp?menu_idx=<%=menuIdx%>";
                    document.frmsales.submit();
                } 
                
                function cmdPrintJournalXls(){	                       
                    window.open("<%=printroot%>.report.RptKonsinyasiCostXLS?user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                    }
                    
                    function cmdSearch(){
                        document.frmsales.command.value="<%=JSPCommand.SEARCH%>";
                        document.frmsales.action="rptconsignedbycost.jsp?menu_idx=<%=menuIdx%>";
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
                                                                                                                                                                <%if (vLoc.size() == totLocationxAll) {%>
                                                                                                                                                                <option value="0"> - All Location -</option>
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
                                                                                                                                    <table width="1200" border="0" cellspacing="1" cellpadding="0">
                                                                                                                                        <tr height="20"> 
                                                                                                                                            <td class="tablearialhdr" width="10%" rowspan="2"><font size="1">SKU</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablearialhdr" rowspan="2"><font size="1">DESCRIPTION</font></td>
                                                                                                                                            <td class="tablearialhdr" width="6%" rowspan="2"><font size="1">COST</font></td>
                                                                                                                                            <td class="tablearialhdr" width="6%" rowspan="2"><font size="1">BEGINING</font></td>
                                                                                                                                            <td class="tablearialhdr" width="6%" rowspan="2"><font size="1">RECEIVING</font></td>
                                                                                                                                            <td class="tablearialhdr" width="6%" rowspan="2"><font size="1">SOLD</font></td>
                                                                                                                                            <td class="tablearialhdr" width="6%" rowspan="2"><font size="1">RETUR</font></td>
                                                                                                                                            <td class="tablearialhdr" width="10%" colspan="2"><font size="1">TRANSFER</font></td>                                                                                                                                            
                                                                                                                                            <td class="tablearialhdr" width="6%" rowspan="2"><font size="1">ADJUSTMENT</font></td>
                                                                                                                                            <td class="tablearialhdr" width="6%" rowspan="2"><font size="1">ENDING</font></td>
                                                                                                                                            <td class="tablearialhdr" width="8%" rowspan="2"><font size="1">SELLING VALUE</font></td>
                                                                                                                                            <td class="tablearialhdr" width="8%" rowspan="2"><font size="1">STOCK VALUE</font></td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr>
                                                                                                                                            <td class="tablearialhdr" width="6%" ><font size="1">IN</font></td>
                                                                                                                                            <td class="tablearialhdr" width="6%"><font size="1">OUT</font></td>
                                                                                                                                        </tr> 
                                                                                                                                        <%
            if (iJSPCommand == JSPCommand.SEARCH || iJSPCommand == JSPCommand.POST) {

                ReportParameter rp = new ReportParameter();
                rp.setLocationId(locationId);
                rp.setDateFrom(invStartDate);
                rp.setDateTo(invEndDate);
                rp.setVendorId(vendorId);

                session.putValue("REPORT_KONSINYASI_COST", rp);
                int xData = 0;
                CONResultSet crs = null;

                try {

                    String sql = "select sku,item_id,item_name,sum(stock_opening) as opening,sum(qty_pembelian) as receiving,sum(qty_tin) as transfer_in,sum(qty_sold) - sum(qty_ret) as sold,sum(qty_tout) as transfer_out,sum(adj) as adjustment,sum(retur) as stock_retur  from ( " +
                            " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                            " from " + DbItemMaster.DB_ITEM_MASTER + " im " +
                            " where im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;

                    sql = sql + " group by im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " union ";

                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,sum(" + DbStock.colNames[DbStock.COL_QTY] + " * " + DbStock.colNames[DbStock.COL_IN_OUT] + ") as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                            " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") < to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId + " and ps." + DbStock.colNames[DbStock.COL_TYPE] + " in (" + DbStock.TYPE_INCOMING_GOODS + "," + DbStock.TYPE_SALES + "," + DbStock.TYPE_TRANSFER + "," + DbStock.TYPE_TRANSFER_IN + "," + DbStock.TYPE_RETUR_GOODS + "," + DbStock.TYPE_ADJUSTMENT + "," + DbStock.TYPE_OPNAME + ") ";


                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";


                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, sum(" + DbStock.colNames[DbStock.COL_QTY] + " * " + DbStock.colNames[DbStock.COL_IN_OUT] + ") as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                            " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_INCOMING_GOODS + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;

                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }

                    sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";

                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,sum(" + DbStock.colNames[DbStock.COL_QTY] + "   ) as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur  " +
                            " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_TRANSFER_IN + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;

                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";

                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name, 0 as stock_opening, 0 as qty_pembelian,0 as qty_tin,sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ") as qty_sold, 0 as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                            " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (" + DbSales.TYPE_CASH + "," + DbSales.TYPE_CREDIT + ") and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " union ";

                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name, 0 as stock_opening, 0 as qty_pembelian,0 as qty_tin,0 as qty_sold, sum(psd." + DbSalesDetail.colNames[DbSalesDetail.COL_QTY] + ")as qty_ret,0 as qty_tout,0 as adj, 0 as retur " +
                            " from " + DbSales.DB_SALES + " ps inner join " + DbSalesDetail.DB_SALES_DETAIL + " psd on ps." + DbSales.colNames[DbSales.COL_SALES_ID] + " = psd." + DbSalesDetail.colNames[DbSalesDetail.COL_SALES_ID] + " inner join " + DbItemMaster.DB_ITEM_MASTER + " im on psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " where ps." + DbSales.colNames[DbSales.COL_TYPE] + " in (" + DbSales.TYPE_RETUR_CASH + "," + DbSales.TYPE_RETUR_CREDIT + ") and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbSales.colNames[DbSales.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by psd." + DbSalesDetail.colNames[DbSalesDetail.COL_PRODUCT_MASTER_ID] + " union ";

                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,sum(" + DbStock.colNames[DbStock.COL_QTY] + ") as qty_tout,0 as adj, 0 as retur " +
                            " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_TRANSFER + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";


                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,sum(" + DbStock.colNames[DbStock.COL_QTY] + " * " + DbStock.colNames[DbStock.COL_IN_OUT] + " ) as adj, 0 as retur " +
                            " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_ADJUSTMENT + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " union ";

                    sql = sql + " select im." + DbItemMaster.colNames[DbItemMaster.COL_CODE] + " as sku,im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] + " as item_id,im." + DbItemMaster.colNames[DbItemMaster.COL_NAME] + " as item_name,0 as stock_opening, 0 as qty_pembelian,0 as qty_tin, 0 as qty_sold,0 as qty_ret,0 as qty_tout,0 as adj, sum(" + DbStock.colNames[DbStock.COL_QTY] + " ) as retur " +
                            " from " + DbStock.DB_POS_STOCK + " ps inner join " + DbItemMaster.DB_ITEM_MASTER + " im on ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + " = im." + DbItemMaster.colNames[DbItemMaster.COL_ITEM_MASTER_ID] +
                            " where ps." + DbStock.colNames[DbStock.COL_STATUS] + " = 'APPROVED' and ps." + DbStock.colNames[DbStock.COL_TYPE] + " = " + DbStock.TYPE_RETUR_GOODS + " and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") >= to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(ps." + DbStock.colNames[DbStock.COL_DATE] + ") <= to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') and im." + DbItemMaster.colNames[DbItemMaster.COL_DEFAULT_VENDOR_ID] + " = " + vendorId;
                    if (locationId != 0) {
                        sql = sql + " and ps." + DbStock.colNames[DbStock.COL_LOCATION_ID] + " = " + locationId;
                    }
                    sql = sql + " group by ps." + DbStock.colNames[DbStock.COL_ITEM_MASTER_ID] + ") as x group by item_id ";

                    crs = CONHandler.execQueryResult(sql);
                    ResultSet rs = crs.getResultSet();

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

                    while (rs.next()) {
                        xData++;
                        String itemName = "";
                        String sku = "";
                        double hargaBeli = 0;
                        long itemMasterId = 0;
                        double opening = 0;
                        double receiving = 0;
                        double sold = 0;
                        double transferIn = 0;
                        double transferOut = 0;
                        double adjustment = 0;
                        double retur = 0;

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
                            hargaBeli = SessReportSales.getLastPrice(itemMasterId, invEndDate);
                            if (hargaBeli == 0) {
                                hargaBeli = SessReportSales.getLastHargaBeli(itemMasterId, invEndDate, vendorId);
                            }
                        } catch (Exception e) {
                        }

                        try {
                            opening = rs.getDouble("opening");
                        } catch (Exception e) {
                        }

                        try {
                            receiving = rs.getDouble("receiving");
                        } catch (Exception e) {
                        }

                        try {
                            sold = rs.getDouble("sold");
                        } catch (Exception e) {
                        }

                        try {
                            retur = rs.getDouble("stock_retur");
                        } catch (Exception e) {
                        }

                        try {
                            transferIn = rs.getDouble("transfer_in");
                        } catch (Exception e) {
                        }

                        try {
                            transferOut = rs.getDouble("transfer_out");
                        } catch (Exception e) {
                        }

                        try {
                            adjustment = rs.getDouble("adjustment");
                        } catch (Exception e) {
                        }

                        RptKonsinyasiBeli rptKonsinyasiBeli = new RptKonsinyasiBeli();
                        rptKonsinyasiBeli.setBegining(opening);
                        rptKonsinyasiBeli.setAdjustment(adjustment);
                        rptKonsinyasiBeli.setItemName(itemName);
                        rptKonsinyasiBeli.setSku(sku);
                        rptKonsinyasiBeli.setItemMasterId(itemMasterId);
                        rptKonsinyasiBeli.setCost(hargaBeli);
                        rptKonsinyasiBeli.setTransferIn(transferIn);
                        rptKonsinyasiBeli.setTransferOut(transferOut);
                        rptKonsinyasiBeli.setReceiving(receiving);
                        rptKonsinyasiBeli.setSold(sold);
                        rptKonsinyasiBeli.setRetur(retur);
                        rptKonsinyasiBeli.setVendorId(vendorId);
                        vKonsinyasiBeli.add(rptKonsinyasiBeli);

                        double stock = opening + receiving - sold - retur + transferIn - transferOut + adjustment;

                        double sellingV = sold * hargaBeli;
                        String strSellingV = "";

                        if (sellingV < 0) {
                            strSellingV = "(" + JSPFormater.formatNumber(sellingV*-1, "#,###.##") + ")";
                        } else {
                            strSellingV = JSPFormater.formatNumber(sellingV, "#,###.##");
                        }
                        double vEnding = stock * hargaBeli;

                        String strV = "";
                        if (vEnding < 0) {                            
                            strV = "(" + JSPFormater.formatNumber(vEnding*-1, "#,###.##") + ")";
                        } else {
                            strV = JSPFormater.formatNumber(vEnding, "#,###.##");
                        }

                        tot1 = tot1 + opening;
                        tot2 = tot2 + receiving;
                        tot3 = tot3 + sold;
                        tot4 = tot4 + retur;
                        tot5 = tot5 + transferIn;
                        tot6 = tot6 + transferOut;
                        tot7 = tot7 + adjustment;
                        tot8 = tot8 + stock;
                        tot9 = tot9 + sellingV;
                        tot10 = tot10 + vEnding;

                        String style = "";
                        if (xData % 2 == 0) {
                            style = "tablearialcell";
                        } else {
                            style = "tablearialcell1";
                        }

                                                                                                                                        %>
                                                                                                                                        <tr height="22"> 
                                                                                                                                            <td class="<%=style%>" align="center"><%=sku%></td>                                                                                                                                            
                                                                                                                                            <td class="<%=style%>" align="left" style="padding:3px;"><font size="1"><%=itemName%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=JSPFormater.formatNumber(hargaBeli, "#,###.##")%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=JSPFormater.formatNumber(opening, "#,###.##")%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=JSPFormater.formatNumber(receiving, "#,###.##")%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=JSPFormater.formatNumber(sold, "#,###.##") %></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=retur%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=transferIn%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=transferOut %></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=adjustment%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=stock%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=strSellingV%></td>
                                                                                                                                            <td class="<%=style%>" align="right" style="padding:3px;"><font size="1"><%=strV%></td>
                                                                                                                                        </tr>    
                                                                                                                                        <%}%>
                                                                                                                                        <tr height="22">                                                                                                                                             
                                                                                                                                            <td bgcolor="#CCCCCC" align="center" style="padding:3px;" colspan="3"><font class="fontarial" size="1"><B>GRAND TOTAL</B></font></td>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=JSPFormater.formatNumber(tot1, "#,###.##")%></B></font></td>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=JSPFormater.formatNumber(tot2, "#,###.##")%></B></font></td>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=JSPFormater.formatNumber(tot3, "#,###.##")%></B></font></td>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=JSPFormater.formatNumber(tot4, "#,###.##")%></B></font></td>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=JSPFormater.formatNumber(tot5, "#,###.##")%></B></font></td>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=JSPFormater.formatNumber(tot6, "#,###.##")%></B></font></td>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=JSPFormater.formatNumber(tot7, "#,###.##")%></B></font></td>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=JSPFormater.formatNumber(tot8, "#,###.##")%></B></font></td>                                                                                                                                           
                                                                                                                                            <%
                                                                                                                                                String strV = "";
                                                                                                                                                if (tot9 < 0) {
                                                                                                                                                    tot9 = tot9 * -1;
                                                                                                                                                    strV = "(" + JSPFormater.formatNumber(tot9, "#,###.##") + ")";
                                                                                                                                                } else {
                                                                                                                                                    strV = JSPFormater.formatNumber(tot9, "#,###.##");
                                                                                                                                                }%>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=strV%></B></font></td>
                                                                                                                                            <%
                                                                                                                                                String strVx = "";
                                                                                                                                                if (tot10 < 0) {
                                                                                                                                                    tot10 = tot10 * -1;
                                                                                                                                                    strVx = "(" + JSPFormater.formatNumber(tot10, "#,###.##") + ")";
                                                                                                                                                } else {
                                                                                                                                                    strVx = JSPFormater.formatNumber(tot10, "#,###.##");
                                                                                                                                                }

                                                                                                                                            %>
                                                                                                                                            <td bgcolor="#CCCCCC" style="padding:3px;" align="right"><font class="fontarial" size="1"><B><%=strVx%></B></font></td>
                                                                                                                                        </tr>   
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="15" height="30"></td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="15">
                                                                                                                                                <table cellpadding="0" cellspacing="0" border="0">
                                                                                                                                                    <tr >
                                                                                                                                                        <td width="120"><font face="arial"><B>Subtotal</B></font></td>
                                                                                                                                                        <td width="20" align="center">&nbsp;</td>
                                                                                                                                                        <td width="30" align="center"><font face="arial"><B>=</B></font></td>
                                                                                                                                                        <td width="50" align="center"><font face="arial"><B>Rp.</B></font></td>
                                                                                                                                                        <td width="80" align="right"><font face="arial">&nbsp;</font></td>
                                                                                                                                                        <td width="100" align="right"><font face="arial"><B><%=strV%></B></font></td>
                                                                                                                                                    </tr>  
                                                                                                                                                    <tr >
                                                                                                                                                        <td colspan="5">&nbsp;</td>                                                                                                                                                        
                                                                                                                                                    </tr> 
                                                                                                                                                    <% 
                                                                                                                                                    double ppn = 0;
                                                                                                                                                    if (vnd.getIsPKP() == 1 ){
                                                                                                                                                        ppn = (tot9 * 10)/100;
                                                                                                                                                    }
                                                                                                                                                    %>
                                                                                                                                                    <tr >
                                                                                                                                                        <td ><font face="arial"><B>Tax</B></font></td>
                                                                                                                                                        <td align="center">&nbsp;</td>
                                                                                                                                                        <td align="center"><font face="arial"><B>=</B></font></td>
                                                                                                                                                        <td align="center"><font face="arial"><B>Rp.</B></font></td>
                                                                                                                                                        <td align="right"><font face="arial">&nbsp;</font></td>
                                                                                                                                                        <td align="right"><font face="arial"><B><%=JSPFormater.formatNumber(ppn, "#,###.##")%></B></font></td>
                                                                                                                                                    </tr>                                                                                                                                                     
                                                                                                                                                    <%
                                                                                                                                                    double totalBill = tot9 + ppn;
                                                                                                                                                    %>
                                                                                                                                                    <tr >
                                                                                                                                                        <td ><font face="arial"><B>Total Bill</B></font></td>
                                                                                                                                                        <td align="center">&nbsp;</td>
                                                                                                                                                        <td align="center"><font face="arial"><B>=</B></font></td>
                                                                                                                                                        <td align="center"><font face="arial"><B>Rp.</B></font></td>
                                                                                                                                                        <td align="right"><font face="arial">&nbsp;</font></td>
                                                                                                                                                        <td align="right"><font face="arial"><B><%=JSPFormater.formatNumber(totalBill, "#,###.##")%></B></font></td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <% double promot = (totalBill / 100) * vnd.getPercentPromosi();%> 
                                                                                                                                                    <input type="hidden" name="hidden_promotion" value="<%=promot%>">
                                                                                                                                                    <tr >
                                                                                                                                                        <td ><font face="arial"><B>Promosi <%=JSPFormater.formatNumber(vnd.getPercentPromosi(), "#,###")%>%</B></font></td>
                                                                                                                                                        <td align="center">&nbsp;</td>
                                                                                                                                                        <td align="center"><font face="arial"><B>=</B></font></td>
                                                                                                                                                        <td align="center"><font face="arial"><B>Rp.</B></font></td>
                                                                                                                                                        <td align="right"><font face="arial"><B><%=JSPFormater.formatNumber(promot, "#,###.##")%></B></font></td>
                                                                                                                                                        <td align="right"><font face="arial">&nbsp;</font></td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <% double barcode = vnd.getPercentBarcode() * (tot2 + tot5);%>
                                                                                                                                                    <input type="hidden" name="hidden_barcode" value="<%=barcode%>">
                                                                                                                                                    <tr >
                                                                                                                                                        <td ><font face="arial"><B>Barcode @Rp. <%=JSPFormater.formatNumber(vnd.getPercentBarcode(), "#,###")%></B></font></td>
                                                                                                                                                        <td align="center">&nbsp;</td>
                                                                                                                                                        <td align="center"><font face="arial"><B>=</B></font></td>
                                                                                                                                                        <td align="center"><font face="arial"><B>Rp.</B></font></td>
                                                                                                                                                        <td align="right"><font face="arial"><B><%=JSPFormater.formatNumber(barcode, "#,###.##")%></B></font></td>
                                                                                                                                                        <td align="right"><font face="arial">&nbsp;</font></td>
                                                                                                                                                    </tr> 
                                                                                                                                                    <% double grandTotal = totalBill - promot - barcode;%>
                                                                                                                                                    <tr >
                                                                                                                                                        <td ><font face="arial"><B>Total Bayar</B></font></td>
                                                                                                                                                        <td align="center">&nbsp;</td>
                                                                                                                                                        <td align="center"><font face="arial"><B>=</B></font></td>
                                                                                                                                                        <td align="center"><font face="arial"><B>Rp.</B></font></td>
                                                                                                                                                        <td align="right"><font face="arial">&nbsp;</font></td>
                                                                                                                                                        <td align="right"><font face="arial"><B><%=JSPFormater.formatNumber(grandTotal, "#,###.##")%></B></font></td>
                                                                                                                                                    </tr>  
                                                                                                                                                </table>
                                                                                                                                            </td>       
                                                                                                                                        </tr> 
                                                                                                                                        
                                                                                                                                        <% 
                                                                                                                                        Vector gls = new Vector();
                                                                                                                                        String where = " to_days(" + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_START_DATE] + ") = to_days('" + JSPFormater.formatDate(invStartDate, "yyyy-MM-dd") + "') and to_days(" + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_END_DATE] + ") = to_days('" + JSPFormater.formatDate(invEndDate, "yyyy-MM-dd") + "') ";
                                                                                                                                            if (vendorId != 0) {
                                                                                                                                                where = where + " and " + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_VENDOR_ID] + " = " + vendorId;
                                                                                                                                            }
                                                                                                                                            if (locationId != 0) {
                                                                                                                                                where = where + " and " + DbMemorialKonsinyasi.colNames[DbMemorialKonsinyasi.CL_LOCATION_ID] + " = " + locationId;
                                                                                                                                            }
                                                                                                                                            Vector memorials = DbMemorialKonsinyasi.list(0, 1, where, null);

                                                                                                                                            if (memorials != null && memorials.size() > 0) {
                                                                                                                                                for (int r = 0; r < memorials.size(); r++) {
                                                                                                                                                    MemorialKonsinyasi m = (MemorialKonsinyasi) memorials.get(r);
                                                                                                                                                    String whereRefId = DbReceive.colNames[DbReceive.COL_REFERENCE_ID] + " = " + m.getOID();
                                                                                                                                                    Vector recs = DbReceive.list(0, 1, whereRefId, null);
                                                                                                                                                    try {
                                                                                                                                                        if (recs != null && recs.size() > 0) {
                                                                                                                                                            Receive rec = (Receive) recs.get(0);
                                                                                                                                                            String whereGl = DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " = '" + rec.getNumber() + "'";
                                                                                                                                                            gls = DbGl.list(0, 1, whereGl, null);
                                                                                                                                                        }    
                                                                                                                                                    }catch(Exception e){}    
                                                                                                                                               }    
                                                                                                                                                    
                                                                                                                                              } 
                                                                                                                                        %>
                                                                                                                                        <tr>
                                                                                                                                            <td colspan="15">&nbsp;</td>       
                                                                                                                                        </tr>  
                                                                                                                                        <%if (xData > 0 && (privPrint || privAdd || privUpdate || privDelete)) {%>
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td colspan="15">&nbsp;</td>
                                                                                                                                        </tr>    
                                                                                                                                        <tr align="left" valign="top"> 
                                                                                                                                            <td colspan="15">
                                                                                                                                                <table>
                                                                                                                                                    <tr>
                                                                                                                                                        <%if (privPrint) {%>
                                                                                                                                                        <td width="100"><a href="javascript:cmdPrintJournal()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print','','../images/print2.gif',1)"><img src="../images/print.gif" name="print" width="53" height="22" border="0"></a></td>                                                                                                                                                
                                                                                                                                                        <td width="160"><a href="javascript:cmdPrintJournalXls()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('print2','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="print2" height="22" border="0"></a></td>
                                                                                                                                                        <%}%>
                                                                                                                                                        <%if ((privAdd || privUpdate || privDelete) && ( gls==null || gls.size() <= 0)  ) {%>
                                                                                                                                                        <td width="100"><a href="javascript:cmdPostJournal()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('post','','../images/post_journal2.gif',1)"><img src="../images/post_journal.gif" name="post" border="0"></a></td>                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                        <%}%>
                                                                                                                                                    </tr>
                                                                                                                                                </table>        
                                                                                                                                            </td>     
                                                                                                                                        </tr>     
                                                                                                                                        <%}%>
                                                                                                                                        <tr align="left" valign="top" height="35"> 
                                                                                                                                            <td colspan="15">&nbsp;</td>
                                                                                                                                        </tr> 
                                                                                                                                        <%} catch (Exception e) {
                                                                                                                                            }%>
                                                                                                                                        <%
                                                                                                                                            session.putValue("REPORT_KONSINYASI BELI", vKonsinyasiBeli);
                                                                                                                                        %>    
                                                                                                                                        <tr align="left" valign="middle"> 
                                                                                                                                            <td height="17" colspan="15">&nbsp;</td> 
                                                                                                                                        </tr>  
                                                                                                                                        <tr align="left" valign="middle"> 
                                                                                                                                            <td height="17" colspan="15" class="container">
                                                                                                                                                <%
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
                                                                                                                                        
                                                                                                                                        <%
                                                                                                                                        } else {%>
                                                                                                                                        <tr align="left" valign="top" height="20"> 
                                                                                                                                            <td colspan="15" class="tablearialcell1" valign="middle">&nbsp;&nbsp;<i>Click search button to searching the data</i></td>
                                                                                                                                        </tr> 
                                                                                                                                        
                                                                                                                                        <%}
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
