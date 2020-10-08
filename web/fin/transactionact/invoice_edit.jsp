
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.fms.transaction.QrInvoice" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_IGL);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_IGL, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_IGL, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_IGL, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_IGL, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%@ include file = "invoice_edit_function.jsp" %>
<%
            if (session.getValue("PURCHASE_TITTLE") != null) {
                session.removeValue("PURCHASE_TITTLE");
            }

            if (session.getValue("PURCHASE_DETAIL") != null) {
                session.removeValue("PURCHASE_DETAIL");
            }

            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");
            long periodId = JSPRequestValue.requestLong(request, JspReceive.colNames[JspReceive.JSP_PERIOD_ID]);
            String stsReceive = JSPRequestValue.requestString(request,JspReceive.colNames[JspReceive.JSP_STATUS]);
            long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");
            
            int allowPeriod = 0;
            try{
                allowPeriod = Integer.parseInt(DbSystemProperty.getValueByName("ALLOW_SELECT_PERIOD"));
            }catch(Exception e){}

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
            }

            /*variable declaration*/
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";
            
            CmdReceiveFn cmdReceive = new CmdReceiveFn(request);
            cmdReceive.setPeriodeId(periodId);
            cmdReceive.setStatus(stsReceive);
            cmdReceive.setUserId(user.getOID());
            
            JSPLine ctrLine = new JSPLine();
            JspReceiveFn jspReceive = cmdReceive.getForm();
            Receive receive = cmdReceive.getReceive();
            msgString = cmdReceive.getMessage();

            if (oidReceive == 0) {
                oidReceive = receive.getOID();
                receive.setStatus(I_Project.DOC_STATUS_DRAFT);
            }

            /*variable declaration*/
            String msgString2 = "";
            int iErrCode2 = JSPMessage.NONE;

            SessIncomingGoods ig = new SessIncomingGoods();

            CmdReceiveItem cmdReceiveItem = new CmdReceiveItem(request);
            JspReceiveItem jspReceiveItem = cmdReceiveItem.getForm();
            ReceiveItem receiveItem = cmdReceiveItem.getReceiveItem();
            msgString2 = cmdReceiveItem.getMessage();

            whereClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID] + "=" + oidReceive;
            orderClause = DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ITEM_ID];
            Vector purchItems = DbReceiveItem.list(0, 0, whereClause, orderClause);

            boolean isItemOk = true;

//pengecekan bila terjadi item master yang kosong, maka tidak bisa disimpan
            if (purchItems != null && purchItems.size() > 0) {
                for (int iRi = 0; iRi < purchItems.size(); iRi++) {
                    ReceiveItem obRi = (ReceiveItem) purchItems.get(iRi);
                    try {
                        ItemMaster im = DbItemMaster.fetchExc(obRi.getItemMasterId());
                    } catch (Exception e) {
                        isItemOk = false;
                        break;
                    }
                }
            }

            Vector vendors = new Vector();
            if (receive.getVendorId() == 0) {
                vendors = DbVendor.list(0, 1, "", "name");
                if (vendors != null && vendors.size() > 0) {
                    Vendor vx = (Vendor) vendors.get(0);
                    receive.setVendorId(vx.getOID());
                }
            }

            if (iErrCode == 0 && iErrCode2 == 0 && iJSPCommand == JSPCommand.SAVE) {
                iJSPCommand = JSPCommand.ADD;
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
            }

            if (iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) {
                oidReceiveItem = 0;
                receiveItem = new ReceiveItem();
            }

            if ((iJSPCommand == JSPCommand.DELETE && iErrCode == 0 && iErrCode2 == 0) || iJSPCommand == JSPCommand.LOAD || iJSPCommand == JSPCommand.ACTIVATE) {
                try {
                    receive = DbReceive.fetchExc(oidReceive);
                } catch (Exception e) {
                }
            }
            
            Receive recTotal = QrInvoice.getIncoming(oidReceive); 
            Vector errorx = new Vector();

            long result = 0;

            if (iJSPCommand == JSPCommand.ACTIVATE && stsReceive.equals(I_Project.DOC_STATUS_CHECKED)) {
                boolean isError = false;
                long locationId = JSPRequestValue.requestLong(request, JspReceive.colNames[JspReceive.JSP_LOCATION_ID]);
                Location loc = new Location();
                try {
                    loc = DbLocation.fetchExc(locationId);
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + loc.getOID();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt == null || segmentDt.size() <= 0) {
                        isError = true;
                    }
                } catch (Exception e) {
                }

                Periode p = new Periode();
                if (periodId == 0) {
                    p = DbPeriode.getPeriodByTransDate(receive.getApproval1Date());
                } else {
                    try {
                        p = DbPeriode.fetchExc(periodId);
                    } catch (Exception e) {
                    }
                }

                if (p.getOID() == 0 || p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0) {
                    isError = true;
                    jspReceive.addError(jspReceive.JSP_PERIOD_ID, "Please chose open period");                    
                }

                if (purchItems != null && purchItems.size() > 0) {
                    for (int i = 0; i < purchItems.size(); i++) {
                        ReceiveItem ri = (ReceiveItem) purchItems.get(i);
                        long oidx = loc.getCoaApId();
                        Vendor vx = new Vendor();
                        try{
                            vx = DbVendor.fetchExc(receive.getVendorId());
                        }catch(Exception e){}
                        
                        if(vx.getOID() != 0){
                            if (vx.getLiabilitiesType() == DbVendor.LIABILITIES_TYPE_GROSIR) {
                                oidx = loc.getCoaApGrosirId();                        
                            } else {
                                oidx = loc.getCoaApId();                        
                            }   
                        }                        
                        
                        if (ri.getIsBonus() == DbReceiveItem.BONUS) {
                            ItemMaster im = new ItemMaster();
                            ItemGroup igx = new ItemGroup();
                            try {
                                im = DbItemMaster.fetchExc(ri.getItemMasterId());
                                igx = DbItemGroup.fetchExc(im.getItemGroupId());
                            } catch (Exception e) {
                                System.out.println("[exception] " + e.toString());
                            }

                            Vector vOtherIncome = DbCoa.list(0, 1, DbCoa.colNames[DbCoa.COL_CODE] + "='" + igx.getAccountBonusIncome() + "'", "");
                            Coa coaOtherIncome = new Coa();
                            if (vOtherIncome != null && vOtherIncome.size() > 0) {
                                coaOtherIncome = (Coa) vOtherIncome.get(0);
                                oidx = coaOtherIncome.getOID();
                            }
                        }
                        if (oidx != 0) {
                            try {
                                Coa coa = DbCoa.fetchExc(oidx);
                                if (coa.getStatus().equals(I_Project.ACCOUNT_LEVEL_POSTABLE)) {
                                    if (coa.getAccountClass() != DbCoa.ACCOUNT_CLASS_SP) {
                                        ri = DbReceiveItem.fetchExc(ri.getOID());
                                        ri.setApCoaId(oidx);
                                        DbReceiveItem.updateExc(ri);
                                        errorx.add("");
                                    } else {
                                        isError = true;
                                        errorx.add("<span class=\"errfont\">non SP account required</span>");
                                    }
                                } else {
                                    isError = true;
                                    errorx.add("<span class=\"errfont\">non postable account</span>");
                                }
                            } catch (Exception e) {
                            }
                        } else {
                            isError = true;
                            errorx.add("<span class=\"errfont\">account AP required</span>");
                        }
                    }
                }

                if (!isError) {
                    jspReceive.requestEntityObject(receive);                   
                    //jika sudah diapprove, lakukan posting jurnal
                    if (receive.getStatus() != null && receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED) && iErrCode <= 0) {
                        Company comp = DbCompany.getCompany();
                        ExchangeRate er = DbExchangeRate.getStandardRate();
                        receive.setApproval2(user.getOID());
                        result = DbReceive.postJournal(receive, periodId, comp, er);
                    }
                    if (result == 0) {
                        msgString = "incompleted data input, please check again";
                    }else{                
                        iErrCode = cmdReceive.action(iJSPCommand, oidReceive);                        
                        receive = cmdReceive.getReceive();
                   }

                } else {
                    //kalau error batalkan proses update
                    iJSPCommand = JSPCommand.EDIT;
                    iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
                    jspReceive = cmdReceive.getForm();
                    receive = cmdReceive.getReceive();
                    msgString = "incompleted data input, please check again";
                }

            } else {
                iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
                jspReceive = cmdReceive.getForm();
                receive = cmdReceive.getReceive();
                msgString = cmdReceive.getMessage();
            }

            String[] langCT = {"Vendor", "Address", "Receive In", "Incoming Number", "DO Number", "Currency", "Invoice Number", "Applay VAT", "Term Of Payment", "Payment Type", "Notes", "Doc Status", "Date", "Location" // 0-13
                , "Group/Category/Code - Name", "Price", "Qty", "Discount", "Total", "Unit", "Chart of Account", "Sub Total", "Discount", "VAT", "Grand Total", "Set Status to", "Bonus" //14 - 26
            };

            String[] langNav = {"Account Payable", "Incoming Goods", "Date", "Incoming Goods", "Item Records", "Approve Date"}; // 0 - 5                       
            if (lang == LANG_ID) {
                String[] langID = {"Suplier", "Alamat", "Lokasi Penerimaan", "No. Incoming", "No. Surat Jalan", "Mata Uang", "No. Faktur", "Menggunakan Pajak", "Jangka Waktu Pembayaran", "Type Pembayaran", "Memo", "Status Dok.", "Tanggal", "Lokasi" // 0 - 13
                    , "Group/Kategori/Kode - Nama", "Harga", "Qty", "Diskon", "Total", "Unit", "Akun Perkiraan", "Sub Total", "Diskon", "Ppn", "Total", "Status", "Bonus" // 14 - 26
                };
                langCT = langID;
                String[] navID = {"Hutang", "Barang Masuk", "Tanggal", "Barang Masuk", "Arsip Barang", "Tanggal Approve"}; // 0 - 5
                langNav = navID;
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdPrintDoc(){                
                window.open("<%=printrootinv%>.report.RptIncomingGoodsPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }   
                
                var sysDecSymbol = "<%=sSystemDecimalSymbol%>";
                var usrDigitGroup = "<%=sUserDigitGroup%>";
                var usrDecSymbol = "<%=sUserDecimalSymbol%>";
                
                function removeChar(number){                    
                    var ix;
                    var result = "";
                    for(ix=0; ix<number.length; ix++){
                        var xx = number.charAt(ix);                        
                        if(!isNaN(xx)){
                            result = result + xx;
                        }else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }                    
                return result;
            }
            
            function calculateSubTotal(){
                var amount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value;
                var qty = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value;
                var discount = document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value;
                
                amount = removeChar(amount);
                amount = cleanNumberFloat(amount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_AMOUNT]%>.value = formatFloat(''+amount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                
                qty = removeChar(qty);
                qty = cleanNumberFloat(qty, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_QTY]%>.value = qty;
                
                discount = removeChar(discount);
                discount = cleanNumberFloat(discount, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
                document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_DISCOUNT]%>.value = formatFloat(''+discount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                
                var totalItemAmount = (parseFloat(amount) * parseFloat(qty)) - parseFloat(discount);
                document.frmreceive.<%=JspReceiveItem.colNames[JspReceiveItem.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+totalItemAmount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                
                var subtot = document.frmreceive.sub_tot.value;
                subtot = cleanNumberFloat(subtot, sysDecSymbol, usrDigitGroup, usrDecSymbol);
                
         <%
            //add
            if (oidReceiveItem == 0) {%>
                    document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
                    <%} else {%>
                    var tempAmount = document.frmreceive.temp_item_amount.value;
                    document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value = formatFloat(''+(parseFloat(totalItemAmount) + parseFloat(subtot) - parseFloat(tempAmount)), '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace);	
         <%}
         %>             
             calculateAmount();
         }
         
         
         function cmdVatEdit(){
             var vat = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>.value;
             if(parseInt(vat)==0){
                 document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="0.0";				
             }else{
             document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
         }
         
         calculateAmount();
     }
     
     function calculateAmount(){         
         var vat = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>.value;
         var taxPercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value;
         taxPercent = removeChar(taxPercent);
         taxPercent = cleanNumberFloat(taxPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         var discPercent = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>.value;	
         discPercent = removeChar(discPercent);
         discPercent = cleanNumberFloat(discPercent, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         var subTotal = document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>.value;
         subTotal = removeChar(subTotal);
         subTotal = cleanNumberFloat(subTotal, sysDecSymbol, usrDigitGroup, usrDecSymbol);	
         
         var totalDiscount = 0;
         if(parseFloat(discPercent)>0){
             totalDiscount = parseFloat(discPercent)/100 * parseFloat(subTotal);
         }
         
         var totalTax = 0;         
         if(parseInt(vat)==0){
             document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="0.0";		             
             totalTax = 0;
         }else{
         document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>.value="<%=sysCompany.getGovernmentVat()%>";		
         totalTax = (parseFloat(subTotal) - totalDiscount) * (parseFloat(taxPercent)/100);
     }
     
     var grandTotal = (parseFloat(subTotal) - totalDiscount) + totalTax;     
     document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>.value = formatFloat(''+totalTax, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
     document.frmreceive.<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>.value = formatFloat(''+totalDiscount, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 
     document.frmreceive.grand_total.value = formatFloat(''+grandTotal, '', sysDecSymbol, usrDigitGroup, usrDecSymbol, decPlace); 	
     
 }
 
 function cmdVendor(){
     <%if (receive.getOID() != 0 && purchItems != null && purchItems.size() > 0) {%>
     if(confirm('Warning !!\nChange the vendor could effect to deletion of some or all receive item based on vendor item master. ')){
         document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
         document.frmreceive.action="invoice_edit.jsp";
         document.frmreceive.submit();
     }
     <%} else {%>
     document.frmreceive.command.value="<%=JSPCommand.LOAD%>";
     document.frmreceive.action="invoice_edit.jsp";
     document.frmreceive.submit();
     
     <%}%>
 }
 
 function cmdToRecord(){
     document.frmreceive.command.value="<%=JSPCommand.NONE%>";
     document.frmreceive.action="invoicesrc.jsp";
     document.frmreceive.submit();
 }
 
 function cmdCloseDoc(){
     document.frmreceive.action="<%=approot%>/home.jsp";
     document.frmreceive.submit();
 }
 
 function cmdSaveDoc(){
     document.all.closecmd.style.display="none";
     document.all.closemsg.style.display="";
     document.frmreceive.command.value="<%=JSPCommand.ACTIVATE%>";
     document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
     document.frmreceive.action="invoice_edit.jsp";
     document.frmreceive.submit();
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
 
 function MM_swapImage() { //v3.0
     var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
     if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
 }
 
 function MM_findObj(n, d) { //v4.01
     var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
         d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
     if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
     for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
     if(!x && d.getElementById) x=d.getElementById(n); return x;
 }
 //-->
        </script>
        <!-- #EndEditable --> 
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/print2.gif','../images/close2.gif','../images/savedoc2.gif')">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
            <tr> 
                <td valign="top"> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
                        <tr> 
                            <td height="96"> <!-- #BeginEditable "header" --> 
            <%@ include file="../main/hmenu.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                        <tr> 
                            <td valign="top"> 
                                <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
                                    <!--DWLayoutTable-->
                                    <tr> 
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                  <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmreceive" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_USER_ID]%>" value="<%=receive.getUserId()%>">
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>" value="<%=receive.getIncluceTax()%>">
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_TYPE_AP]%>" value="<%=receive.getTypeAp()%>">
                                                            
                                                            <input type="hidden" name="hidden_receive_item_id" value="<%=oidReceiveItem%>">
                                                            <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                                                            <input type="hidden" name="<%=JspReceiveItem.colNames[JspReceiveItem.JSP_RECEIVE_ID]%>" value="<%=oidReceive%>">
                                                            
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr> 
                                                                                <td height="8"></td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink"><font face="arial"><%=langNav[4]%></font></a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;<font face="arial"><%=langNav[3]%></font> &nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader">
                                                                                                <img src="<%=approot%>/images/spacer.gif" width="10" height="10">
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td > 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">                                                                                                    
                                                                                                    <tr align="left" height="10"> 
                                                                                                        <td width="140" class="tablearialcell1"></td>
                                                                                                        <td width="300" class="fontarial"></td>
                                                                                                        <td width="140"></td>
                                                                                                        <td colspan="2" class="comment"></td>
                                                                                                    </tr>                                                                                                   
                                                                                                    <%
            Purchase purchase = new Purchase();
            if (receive.getPurchaseId() != 0) {
                ig.setOidGoods(receive.getPurchaseId());
                try {
                    purchase = DbPurchase.fetchExc(receive.getPurchaseId());
                } catch (Exception e) {
                }
                                                                                                    %>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" class="tablearialcell1">&nbsp;&nbsp;<font face="arial">PO Number</font></td>
                                                                                                        <td height="20" class="fontarial"> :&nbsp;<%=purchase.getNumber()%><%ig.setPoNumber(purchase.getNumber());%></td>
                                                                                                        <td height="20" >&nbsp;</td>
                                                                                                        <td height="20" colspan="2" class="comment">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" class="tablearialcell1">&nbsp;&nbsp;PO Date</td>                                                                                                        
                                                                                                        <td height="20" class="fontarial">:&nbsp;<%=JSPFormater.formatDate(purchase.getPurchDate(), "dd/MM/yyyy")%><%ig.setPoDate(purchase.getPurchDate());%></td>
                                                                                                        <td height="20" >&nbsp;</td>
                                                                                                        <td height="20" colspan="2" class="comment">&nbsp;</td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <%}%>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" class="tablearialcell1">&nbsp;&nbsp;<%=langCT[0]%></td>
                                                                                                        <td height="20" class="fontarial"> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PURCHASE_ID]%>" value="<%=purchase.getOID()%>">
                                                                                                            <%
            Vendor vnd = new Vendor();
            if (receive.getVendorId() == 0) {%>
                                                                                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>" onChange="javascript:cmdVendor()">
                                                                                                                <%
                                                                                                                if (vendors != null && vendors.size() > 0) {
                                                                                                                    for (int i = 0; i < vendors.size(); i++) {
                                                                                                                        Vendor d = (Vendor) vendors.get(i);
                                                                                                                        if (receive.getVendorId() == d.getOID()) {
                                                                                                                            ig.setVendor(d.getCode() + " - " + d.getName());
                                                                                                                            ig.setAddress(d.getAddress());
                                                                                                                        }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (receive.getVendorId() == d.getOID()) {%>selected<%}%>><%=d.getCode() + " - " + d.getName()%></option>
                                                                                                                <%}
                                                                                                                }%>
                                                                                                            </select>
                                                                                                            <%} else {
                                                                                                                try {
                                                                                                                    vnd = DbVendor.fetchExc(receive.getVendorId());
                                                                                                                    ig.setVendor(vnd.getCode() + " - " + vnd.getName());
                                                                                                                    ig.setAddress(vnd.getAddress());
                                                                                                                } catch (Exception e) {
                                                                                                                }
                                                                                                            %>
                                                                                                            :&nbsp;<%=vnd.getCode() + " - " + vnd.getName()%> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_VENDOR_ID]%>" value="<%=receive.getVendorId()%>">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                        <%
            Vector periods = new Vector();
            if(allowPeriod == 1){
                periods = DbPeriode.list(0, 0, DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_PRE_CLOSED + "' or " + DbPeriode.colNames[DbPeriode.COL_STATUS] + "='" + I_Project.STATUS_PERIOD_OPEN + "'", "" + DbPeriode.colNames[DbPeriode.COL_START_DATE] + " desc ");
            }        
                                                                                                        %>
                                                                                                        <td height="20" class="tablearialcell1">&nbsp;Periode</td>
                                                                                                        <td height="20" colspan="2" class="fontarial">:&nbsp;                                                                                                       
                                                                                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_PERIOD_ID]%>">
                                                                                                                <option value ="0" <%if (receive.getPeriodId() == 0) {%>selected<%}%> >< Default incoming ></option>
                                                                                                                <%
            if (periods != null && periods.size() > 0) {
                for (int t = 0; t < periods.size(); t++) {
                    Periode objPeriod = (Periode) periods.get(t);
                                                                                                                %>
                                                                                                                <option value ="<%=objPeriod.getOID()%>" <%if (objPeriod.getOID() == receive.getPeriodId()) {%>selected<%}%> ><%=objPeriod.getName()%></option>
                                                                                                                <%}%><%}%>
                                                                                                            </select>
                                                                                                            <%=jspReceive.getErrorMsg(JspReceive.JSP_PERIOD_ID)%> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="20" class="tablearialcell1">&nbsp;&nbsp;<%=langCT[1]%></td>
                                                                                                        <td height="20" class="fontarial">:&nbsp;<%=vnd.getAddress()%><input type="hidden" value="<%=vnd.getAddress()%>"></td>
                                                                                                        <td height="20" class="tablearialcell1">&nbsp;<%=langCT[2]%></td>
                                                                                                        <td colspan="2" class="fontarial">:&nbsp
                                                                                                            <%if (receive.getLocationId() == 0) {%>
                                                                                                            <select name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>">
                                                                                                                <%
    Vector locations = DbLocation.list(0, 0, "", "code");
    if (locations != null && locations.size() > 0) {
        for (int i = 0; i < locations.size(); i++) {
            Location d = (Location) locations.get(i);
            if (receive.getLocationId() == d.getOID()) {
                ig.setReceiveIn(d.getCode() + " - " + d.getName());
            }
                                                                                                                %>
                                                                                                                <option value="<%=d.getOID()%>" <%if (receive.getLocationId() == d.getOID()) {%>selected<%}%>><%=d.getCode() + " - " + d.getName()%></option>
                                                                                                                <%}
    }%>
                                                                                                            </select>
                                                                                                            <%} else {
    Location loc = new Location();
    try {
        loc = DbLocation.fetchExc(receive.getLocationId());
        ig.setReceiveIn(loc.getCode() + " - " + loc.getName());
    } catch (Exception e) {
    }
                                                                                                            %>
                                                                                                            <%=loc.getCode() + " - " + loc.getName()%> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_LOCATION_ID]%>" value="<%=receive.getLocationId()%>">
                                                                                                            <%}%>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                   
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langCT[4]%></td>
                                                                                                        <td height="21" class="fontarial">:&nbsp;<%=receive.getDoNumber()%> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_DO_NUMBER]%>" value="<%=receive.getDoNumber()%>">
                                                                                                            <%=jspReceive.getErrorMsg(JspReceive.JSP_DO_NUMBER)%> 
                                                                                                            <%ig.setDoNumber(receive.getDoNumber());%>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1">&nbsp;<%=langCT[3]%></td>
                                                                                                        <td colspan="2" class="fontarial">:&nbsp;
                                                                                                            <%
            String number = "";
            if (receive.getOID() == 0) {
                int ctr = DbReceive.getNextCounter();
                number = DbReceive.getNextNumber(ctr);
                ig.setDocNumber(number);
            } else {
                number = receive.getNumber();
                ig.setDocNumber(number);
            }
                                                                                                            %>
                                                                                                            <%=number%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" class="tablearialcell1">&nbsp;&nbsp;<font face="arial"><%=langCT[6]%></font></td>
                                                                                                        <td height="21" class="fontarial">:&nbsp;<%=receive.getInvoiceNumber()%> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_INVOICE_NUMBER]%>" value="<%=receive.getInvoiceNumber()%>">
                                                                                                            <%=jspReceive.getErrorMsg(JspReceive.JSP_INVOICE_NUMBER)%> 
                                                                                                            <%
            Vector currs = DbCurrency.list(0, 0, "", "");
            Vector exchange_value = new Vector(1, 1);
            Vector exchange_key = new Vector(1, 1);
            if (currs != null && currs.size() > 0) {
                for (int i = 0; i < currs.size(); i++) {
                    Currency d = (Currency) currs.get(i);
                    exchange_key.add("" + d.getOID());
                    exchange_value.add(d.getCurrencyCode());
                }
            }
                                                                                                            %>                                                                                                            
                                                                                                            <%ig.setInvoiceNumber(receive.getInvoiceNumber());%>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1">&nbsp;<%=langCT[5]%></td>
                                                                                                        <td colspan="2" class="fontarial">:&nbsp; 
                                                                                                            <%
            Currency curr = new Currency();
            try {
                curr = DbCurrency.fetchExc(receive.getCurrencyId());
            } catch (Exception e) {
            }
            out.println(curr.getCurrencyCode());
                                                                                                            %>
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_CURRENCY_ID]%>" value="<%=receive.getCurrencyId()%>">
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" class="tablearialcell1">&nbsp;&nbsp;<font face="arial"><%=langCT[12]%></font></td>
                                                                                                        <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDate() == null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%>">
                                                                                                        <td height="21" class="fontarial">:&nbsp;<%=JSPFormater.formatDate((receive.getDate() == null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%>                                                                                                             
                                                                                                            <%ig.setDate(receive.getDate());%>
                                                                                                        </td>
                                                                                                        <td class="tablearialcell1">&nbsp;<%=langCT[11]%></td>
                                                                                                        <td colspan="2" class="fontarial">:&nbsp;<%=(receive.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((receive.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : receive.getStatus())%>
                                                                                                            <%
            if (receive.getStatus() == null || receive.getStatus().length() == 0) {
                receive.setStatus(I_Project.DOC_STATUS_DRAFT);
            }
                                                                                                            %>                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" class="tablearialcell1">&nbsp;&nbsp;<font face="arial"><%=langNav[5]%></font></td>                                                                                                        
                                                                                                        <td height="21" class="fontarial">:&nbsp;<%=JSPFormater.formatDate((receive.getApproval1Date() == null) ? new Date() : receive.getApproval1Date(), "dd/MM/yyyy")%></td>
                                                                                                        <td height="21" class="tablearialcell1">&nbsp;<%=langCT[8]%></td>
                                                                                                        <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_DUE_DATE]%>" value="<%=JSPFormater.formatDate((receive.getDueDate() == null) ? new Date() : receive.getDueDate(), "dd/MM/yyyy")%>">
                                                                                                        <td colspan="2" class="fontarial">:&nbsp;<%=JSPFormater.formatDate((receive.getDueDate() == null) ? new Date() : receive.getDueDate(), "dd/MM/yyyy")%>                                                                                                            
                                                                                                            <%ig.setTermOfPayment(receive.getDueDate());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" class="tablearialcell1">&nbsp;&nbsp;<%=langCT[9]%></td>
                                                                                                        <td height="21" class="fontarial">:&nbsp;<%=receive.getPaymentType()%>    
                                                                                                        <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PAYMENT_TYPE]%>" value="<%=receive.getPaymentType()%>">
                                                                                                        <%ig.setPaymentType(receive.getPaymentType());%>
                                                                                                        <td class="tablearialcell1">&nbsp;<%=langCT[7]%></td>
                                                                                                        <td colspan="2" class="fontarial">:&nbsp;<%=DbReceive.strIncludeTax[receive.getIncluceTax()]%></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" class="tablearialcell1">&nbsp;&nbsp;<font face="arial"><%=langCT[10]%></font></td>
                                                                                                        <td height="21" class="fontarial" colspan="4">:&nbsp;<%=receive.getNote()%>  
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_NOTE]%>" value="<%=receive.getNote()%>">
                                                                                                            <%ig.setNotes(receive.getNote());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="10" colspan="5"></td>
                                                                                                    </tr>                                                                                                                                                                                                       
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(iJSPCommand, jspReceiveItem, receiveItem, purchItems, oidReceiveItem, approot, receive.getVendorId(), iErrCode2, receive.getStatus(), errorx, langCT);
            String strList = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
                                                                                                            %>
                                                                                                            <%=strList%><% session.putValue("PURCHASE_DETAIL", rptObj);%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"><%@ include file = "invoice_edit_total.jsp" %></td>
                                                                                                    </tr>
                                                                                                    <%if (receive.getOID() != 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="4"> 
                                                                                                                        <%if (receive.getOID() != 0 && !receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="12%">&nbsp;</td><td width="14%">&nbsp;</td><td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%if ((!receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED) || iErrCode != 0)) {%>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%" class="fontarial"><b><%=langCT[25]%></b></td>
                                                                                                                                <td width="14%"> 
                                                                                                                                    <select name="<%=JspReceive.colNames[JspReceive.JSP_STATUS]%>" class="fontarial">                                                                                                                                       
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>                                                                                                                                       
                                                                                                                                        <option value="<%=I_Project.DOC_STATUS_CHECKED%>" <%if (receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED)) {%>selected<%}%>>CHECKED AS INVOICE</option>                                                                                                                                       
                                                                                                                                    </select>
                                                                                                                                </td>
                                                                                                                                <td width="74%">&nbsp; </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="12%">&nbsp;</td>
                                                                                                                                <td width="14%">&nbsp;</td>
                                                                                                                                <td width="74%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                        </table>                                                                                                                        
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <%if (receive.getOID() != 0) {%>
                                                                                                                <tr> 
                                                                                                                    <td colspan="4" class="errfont"><%=msgString%></td>
                                                                                                                </tr>
                                                                                                                <%}%>                                                                                                                
                                                                                                                <tr id="closecmd"> 
                                                                                                                    <%if ((!receive.getStatus().equals(I_Project.DOC_STATUS_CHECKED) || iErrCode != 0) && isItemOk && result == 0) {%>
                                                                                                                    <%if (privAdd || privUpdate || privDelete) {%>
                                                                                                                    <td width="149" ><a href="javascript:cmdSaveDoc()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save211','','../images/savedoc2.gif',1)"><img src="../images/savedoc.gif" name="save211" height="22" border="0"></a></td>
                                                                                                                    <%}%>
                                                                                                                    <%}%>
                                                                                                                    <td width="102" > 
                                                                                                                        <div align="left"><a href="javascript:cmdPrintDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close211111','','../images/print2.gif',1)"><img src="../images/print.gif" name="close211111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <td width="97"> 
                                                                                                                        <div align="left"><a href="javascript:cmdCloseDoc()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('close21111','','../images/close2.gif',1)"><img src="../images/close.gif" name="close21111" border="0"></a></div>
                                                                                                                    </td>
                                                                                                                    <td width="862"> 
                                                                                                                        <div align="left"></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr id="closemsg" align="left" valign="top"> 
                                                                                                                    <td height="22" valign="middle" colspan="10"> 
                                                                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td> <font color="#006600">Posting sales in progress, please wait .... </font> </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td height="1">&nbsp; </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td> <img src="../images/progress_bar.gif" border="0"> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (receive.getOID() != 0) {%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <%@ include file="invoice_edit_approval.jsp"%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>                                                                                                   
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td>&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <%
            session.putValue("PURCHASE_TITTLE", ig);
                                                            %>
                                                            <script language="JavaScript">
                                                                document.all.closecmd.style.display="";
                                                                document.all.closemsg.style.display="none";
                                                            </script>  
                                                        </form>
                                                        <span class="level2"><br>
                                                    </span><!-- #EndEditable --> </td>
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
            <%@ include file="../main/footer.jsp"%>
                            <!-- #EndEditable --> </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </body>
    <!-- #EndTemplate --> 
</html>
