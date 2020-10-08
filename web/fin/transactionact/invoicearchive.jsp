
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.fms.transaction.DbBankpoPayment" %>
<%@ page import = "com.project.fms.transaction.DbBankpoPaymentDetail" %>
<%@ page import = "com.project.fms.session.SessViewReport" %>
<%@ page import = "com.project.fms.session.InvoiceArchive" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_APAY, AppMenu.M2_MENU_ILI);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_ILI, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_ILI, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_ILI, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), (AppMenu.M1_MENU_APAY), AppMenu.M2_MENU_ILI, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, int start, String[] langCT) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
        cmdist.addHeader("No", "3%");
        cmdist.addHeader("" + langCT[1], "10%");
        cmdist.addHeader("" + langCT[4], "10%");
        cmdist.addHeader("" + langCT[5], "10%");
        cmdist.addHeader("" + langCT[9], "8%");
        cmdist.addHeader("" + langCT[0], "");
        cmdist.addHeader("" + langCT[7], "10%");
        cmdist.addHeader("" + langCT[6], "10%");
        cmdist.addHeader("" + langCT[11], "10%");
        cmdist.addHeader("" + langCT[8], "10%");


        cmdist.setLinkRow(1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Receive receive = (Receive) objectClass.get(i);
            Vector rowx = new Vector();

            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add("<div align=\"center\">" + receive.getNumber() + "</div>");

            rowx.add(receive.getInvoiceNumber() + "/" + receive.getDoNumber());

            if (receive.getDate() == null) {
                rowx.add("");
            } else {
                rowx.add("<div align=\"center\">" + JSPFormater.formatDate(receive.getDate(), "dd MMM yyyy") + "</div>");
            }

            rowx.add("<div align=\"center\">" + JSPFormater.formatDate(receive.getDueDate(), "dd MMM yyyy") + "</div>");
            Vendor vendor = new Vendor();
            try {
                vendor = DbVendor.fetchExc(receive.getVendorId());
            } catch (Exception e) {
                System.out.println(e);
            }

            double hutang = DbReceive.getTotInvoice(receive.getOID());
            double payment = 0;
            double balance = hutang - payment;

            rowx.add("" + vendor.getName());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(hutang, "#,###.##") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(payment, "#,###.##") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(balance, "#,###.##") + "</div>");
            rowx.add("<div align=\"center\"><table><tr height=\"22\"><td>" + ((receive.getPaymentStatus() == 0) ? "-" : I_Project.invStatusStr[receive.getPaymentStatus()]) + "</td></tr></table></div>");

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(receive.getOID()));
        }

        return cmdist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidReceive = JSPRequestValue.requestLong(request, "hidden_receive_id");

            long srcVendorId = JSPRequestValue.requestLong(request, "src_vendor_id");
            long locationId = JSPRequestValue.requestLong(request, "location_id");
            String srcStatus = I_Project.DOC_STATUS_CHECKED;
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            String untilDate = JSPRequestValue.requestString(request, "until_date");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            int srcIgnoreUntil = JSPRequestValue.requestInt(request, "src_ignore_until");
            String docNumber = JSPRequestValue.requestString(request, "doc_number");

            int noPayment = JSPRequestValue.requestInt(request, "no_payment");
            int partialyPaid = JSPRequestValue.requestInt(request, "partialy_paid");
            int fullyPaid = JSPRequestValue.requestInt(request, "fully_paid");
            int print = JSPRequestValue.requestInt(request, "print");
            int typeOrder = JSPRequestValue.requestInt(request, "type_order");
            

            Date srcStartDate = new Date();
            Date srcEndDate = new Date();
            Date srcUntilDate = new Date();
            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
                noPayment = 1;
                partialyPaid = 1;
                fullyPaid = 1;
                srcIgnoreUntil = 1;
            }

            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            if (srcIgnoreUntil == 0) {
                srcUntilDate = JSPFormater.formatDate(untilDate, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            if (session.getValue("REPORT_PRINT_INVOICE_ARCHIVE") != null) {
                session.removeValue("REPORT_PRINT_INVOICE_ARCHIVE");
            }

            whereClause = DbReceive.colNames[DbReceive.COL_TYPE_AP] + " in (" + DbReceive.TYPE_AP_NO + "," + DbReceive.TYPE_AP_YES + "," + DbReceive.TYPE_RETUR + ") ";

            Vector listLocation = DbSegmentDetail.listLocation(user.getOID());
            if(false){
            if(locationId != 0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbReceive.colNames[DbReceive.COL_LOCATION_ID] + "=" + locationId;
                
            }else{
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                String all = "";
                if(listLocation != null && listLocation.size() > 0){
                    for(int t = 0; t < listLocation.size() ; t++){
                        Location l = (Location)listLocation.get(t);
                        if(all != null && all.length() > 0){
                            all = all+",";
                        }
                        all = all + l.getOID();
                        
                    }
                }
                
                whereClause = whereClause + DbReceive.colNames[DbReceive.COL_LOCATION_ID] + " in (" + all +") ";
            }}
            
            
            if (srcVendorId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbReceive.colNames[DbReceive.COL_VENDOR_ID] + "=" + srcVendorId;
            }
            if (srcStatus != null && srcStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbReceive.colNames[DbReceive.COL_STATUS] + "='" + srcStatus + "'";
                } else {
                    whereClause = DbReceive.colNames[DbReceive.COL_STATUS] + "='" + srcStatus + "'";
                }
            }
            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbReceive.colNames[DbReceive.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbReceive.colNames[DbReceive.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = "(to_days(" + DbReceive.colNames[DbReceive.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbReceive.colNames[DbReceive.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            if (srcIgnoreUntil == 0) {
                whereClause = whereClause + " and ( (" + DbReceive.colNames[DbReceive.COL_TYPE_AP] + " in (" + DbReceive.TYPE_AP_NO + "," + DbReceive.TYPE_RETUR + ") and to_days(" + DbReceive.colNames[DbReceive.COL_APPROVAL_2_DATE] + ") <= to_days('" + JSPFormater.formatDate(srcUntilDate, "yyyy-MM-dd") + "') )  or (" + DbReceive.colNames[DbReceive.COL_TYPE_AP] + " in (" + DbReceive.TYPE_AP_YES + ") and to_days(" + DbReceive.colNames[DbReceive.COL_APPROVAL_3_DATE] + ") <= to_days('" + JSPFormater.formatDate(srcUntilDate, "yyyy-MM-dd") + "'))) ";
            }

            if (docNumber != null && docNumber.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " number like '%" + docNumber + "%'";
            }

            if (noPayment == 1 || partialyPaid == 1 || fullyPaid == 1) {
                String pay = "";
                if (noPayment == 1) {
                    if (pay != null && pay.length() > 0) {
                        pay = pay + ",";
                    }
                    pay = pay + "0";
                }

                if (partialyPaid == 1) {
                    if (pay != null && pay.length() > 0) {
                        pay = pay + ",";
                    }
                    pay = pay + "1";

                }
                if (fullyPaid == 1) {
                    if (pay != null && pay.length() > 0) {
                        pay = pay + ",";
                    }
                    pay = pay + "2";
                }

                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " " + DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS_POSTED] + " in (" + pay + ")";
            } else {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + " " + DbReceive.colNames[DbReceive.COL_PAYMENT_STATUS_POSTED] + " = -1 ";
            }

            if (print == 1) {
                start = 0;
                recordToGet = 0;
            }

            CmdReceive cmdReceive = new CmdReceive(request);
            JSPLine ctrLine = new JSPLine();
            Vector listReceive = new Vector(1, 1);

            /*switch statement */
            //iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
            /* end switch*/
            JspReceive jspReceive = cmdReceive.getForm();
            int vectSize = DbReceive.getCount(whereClause);

            Receive vendor = cmdReceive.getReceive();
            msgString = cmdReceive.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdReceive.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            orderClause = DbReceive.colNames[DbReceive.COL_DATE];
            
            if(typeOrder == 0){
                orderClause = DbReceive.colNames[DbReceive.COL_DATE];
            }else if(typeOrder == 1){
                orderClause = DbReceive.colNames[DbReceive.COL_DUE_DATE];
            }
            listReceive = DbReceive.list(start, recordToGet, whereClause, orderClause);

            if (listReceive.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listReceive = DbReceive.list(start, recordToGet, whereClause, orderClause);
            }

            String[] langCT = {"Vendor", "Doc Number", "Receive Date", "Ignored", "Invoice/DO", "Date", "Paid", "Amount", "Status", "Due Date", "Print", "Balance", "Until", "Location","Due Date"};
            String[] langNav = {"Account Payable", "Invoice List", "Search Parameters"};

            if (lang == LANG_ID) {
                String[] langID = {"Suplier", "Nomor Faktur", "Tanggal Pembelian", "Abaikan", "Faktur/DO", "Tanggal", "Terbayar", "Jumlah Hutang", "Status", "Batas Pembayaran", "Print", "Sisa Hutang", "Hutang Sampai", "Lokasi","Due Date"};
                langCT = langID;

                String[] navID = {"Hutang", "Daftar Faktur", "Parameter Pencarian"};
                langNav = navID;
            }
            
            Vector listPrint = new Vector();

            
%>
<html >
<!-- #BeginTemplate "/Templates/index.dwt" --> 
<head>
    <!-- #BeginEditable "javascript" --> 
    <title><%=systemTitle%></title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link href="../css/default.css" rel="stylesheet" type="text/css" />
    <link href="../css/css.css" rel="stylesheet" type="text/css" />
    <script language="JavaScript">
        <!--
        function cmdPrintJournalXLS(){	                       
            window.open("<%=printroot%>.report.RptInvoiceXLS?vendorId=<%=srcVendorId%>&user_id=<%=appSessUser.getUserOID()%>&lang=<%=lang%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
            }
            
            function cmdSearch(){
                document.frmreceive.command.value="<%=JSPCommand.LIST%>";
                document.frmreceive.action="invoicearchive.jsp";
                document.frmreceive.submit();
            }
            
            function cmdEdit(oid){
                document.frmreceive.hidden_receive_id.value=oid;
                document.frmreceive.command.value="<%=JSPCommand.EDIT%>";
                document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                document.frmreceive.action="invoice_preview.jsp";
                document.frmreceive.submit();
            }
            
            function cmdAdd(){
                document.frmreceive.hidden_receive_id.value="0";
                document.frmreceive.command.value="<%=JSPCommand.ADD%>";
                document.frmreceive.prev_command.value="<%=prevJSPCommand%>";
                document.frmreceive.action="invoice_edit.jsp";
                document.frmreceive.submit();
            }
            
            function cmdListFirst(){
                document.frmreceive.command.value="<%=JSPCommand.FIRST%>";
                document.frmreceive.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmreceive.action="invoicearchive.jsp";
                document.frmreceive.submit();
            }
            
            function cmdListPrev(){
                document.frmreceive.command.value="<%=JSPCommand.PREV%>";
                document.frmreceive.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmreceive.action="invoicearchive.jsp";
                document.frmreceive.submit();
            }
            
            function cmdListNext(){
                document.frmreceive.command.value="<%=JSPCommand.NEXT%>";
                document.frmreceive.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmreceive.action="invoicearchive.jsp";
                document.frmreceive.submit();
            }
            
            function cmdListLast(){
                document.frmreceive.command.value="<%=JSPCommand.LAST%>";
                document.frmreceive.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmreceive.action="invoicearchive.jsp";
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
<body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif')">
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
                    <input type="hidden" name="vectSize" value="<%=vectSize%>">
                    <input type="hidden" name="start" value="<%=start%>">
                    <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                    <input type="hidden" name="hidden_receive_id" value="<%=oidReceive%>">
                    <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                        <td valign="top" class="container"> 
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                            
                            <tr align="left" valign="top"> 
                                <td height="8"  colspan="3" > 
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr  valign="top"> 
                                    <td colspan="3" align="left"> 
                                        <table border="0" cellspacing="1" cellpadding="0">           
                                        <tr> 
                                            <td colspan="6" height="5"></td>
                                        </tr>                                                                                                                                                                                                                         
                                        <tr>                                                                                                         
                                            <td colspan="6" ><table ><tr><td class="tablehdr"></td><td class="fontarial"><b><i><%=langNav[2]%> :</i></b></td></tr></table></td>
                                        </tr>
                                        <tr height="22">                                                                                                         
                                            <td width="100" class="tablecell1">&nbsp;<%=langCT[0]%></td>
                                            <td width="2" class="fontarial">:</td>
                                            <td colspan="4"> 
                                                <select name="src_vendor_id" class="fontarial">
                                                    <option value="0" <%if (srcVendorId == 0) {%>selected<%}%>> - All Suplier - </option>
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
                                                <input type="hidden" name="src_status" value="<%=I_Project.DOC_STATUS_CHECKED%>">
                                            </td>
                                        </tr>                                                                                                    
                                        <tr height="22">                                                                                                        
                                            <td class="tablecell">&nbsp;<%=langCT[1]%></td>
                                            <td width="2" class="fontarial">:</td>
                                            <td width="250"><input type="text" name="doc_number" value="<%=docNumber%>" size="25"></td>
                                            <td width="100" class="tablecell">&nbsp;<%=langCT[2]%></td>
                                            <td >:</td>
                                            <td >
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                        <td>&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                        <td><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                        <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>
                                                        <td><%=langCT[3]%></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>                                                                                                   
                                        <tr height="22">                                                                                                         
                                            <td class="tablecell1">&nbsp;<%=langCT[8]%></td>
                                            <td width="2" class="fontarial">:</td>
                                            <td >
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td><input type="checkbox" name="no_payment" <%if (noPayment == 1) {%> checked<%}%> value="1"></td>
                                                        <td class="fontarial"><i>Draft</i></td>
                                                        <td >&nbsp;<input type="checkbox" name="partialy_paid" value="1" <%if (partialyPaid == 1) {%> checked<%}%>></td>
                                                        <td class="fontarial"><i>Partialy Paid</i></td>
                                                        <td>&nbsp;<input type="checkbox" name="fully_paid" value="1" <%if (fullyPaid == 1) {%> checked<%}%>></td>
                                                        <td class="fontarial"><i>Fully Paid</i></td>
                                                    </tr> 
                                                </table>
                                            </td>
                                            <td class="tablecell1">&nbsp;<%=langCT[10]%></td>    
                                            <td width="2" class="fontarial">:</td>
                                        <td class="fontarial"><input type="checkbox" name="print" value="1" <%if (print == 1) {%> checked<%}%>><i>Print</i></td>   
                                        </tr>
                                        <tr height="22">                                                                                                         
                                            <td class="tablecell">&nbsp;<%=langCT[12]%></td>
                                            <td width="2" class="fontarial">:</td>
                                            <td >
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>                                                        
                                                        <td><input name="until_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcUntilDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                        <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmreceive.until_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a></td>
                                                        <td><input type="checkbox" name="src_ignore_until" value="1" <%if (srcIgnoreUntil == 1) {%>checked<%}%>></td>
                                                        <td><%=langCT[3]%></td>
                                                    </tr>
                                                </table>
                                            </td>                                            
                                            <td class="tablecell">&nbsp;<%=langCT[13]%></td>    
                                            <td width="2" class="fontarial">:</td>
                                            <td class="fontarial">
                                                <select name="location_id" class="fontarial">
                                                    <option value="0">- All Location -</option>
                                                <%if(listLocation != null && listLocation.size() > 0){
                                                    for(int i = 0 ; i < listLocation.size() ; i++){
                                                        Location l = (Location)listLocation.get(i);
                                                %>
                                                    <option value="<%=l.getOID()%>" <%if(locationId == l.getOID()){%> selected <%}%> ><%=l.getName() %></option>
                                                
                                                <%}}%>
                                                </select>
                                            </td>   
                                        </tr>
                                        <tr height="22">                                                                                                         
                                            <td class="tablecell1">&nbsp;Order By</td>
                                            <td width="2" class="fontarial">:</td>
                                            <td >
                                                 <select name="type_order" class="fontarial">
                                                    <option value="0" <%if(typeOrder == 0){%> selected <%}%> ><%=langCT[5]%></option>
                                                    <option value="1" <%if(typeOrder == 1){%> selected <%}%>><%=langCT[9]%></option>
                                                </select>
                                            </td>                                            
                                            <td ></td>    
                                            <td ></td>
                                            <td class="fontarial"></td>   
                                        </tr>
                                    </table>
                                </td>
                            </tr> 
                            <tr > 
                                <td>
                                    <table width="700">
                                        <tr>
                                            <td height="3" background="<%=approot%>/images/line1.gif" ></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr align="left" valign="top"> 
                                <td height="22"> <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                            </tr>
                            <tr align="left" valign="top"> 
                                <td height="25"> </td>
                            </tr>
                            
                            <tr> 
                                <td colspan="3" height="3" background="<%=approot%>/images/line1.gif" ></td>                                                                                            
                            </tr>
                            <tr align="left" valign="top"> 
                                <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                    <table width="100%" border="0" cellpadding="0" cellspacing="1">
                                        <tr>
                                            <td class="tablehdr" width="20">No</td>
                                            <td class="tablehdr" width="90"><%=langCT[1]%></td>
                                            <td class="tablehdr" width="120"><%=langCT[4]%></td>
                                            <td class="tablehdr" width="90"><%=langCT[5]%></td>
                                            <td class="tablehdr" width="90"><%=langCT[9]%></td>
                                            <td class="tablehdr"><%=langCT[0]%></td>
                                            <td class="tablehdr" width="90"><%=langCT[7]%></td>
                                            <td class="tablehdr" width="90"><%=langCT[6]%></td>
                                            <td class="tablehdr" width="90"><%=langCT[11]%></td>
                                            <td class="tablehdr" width="60"><%=langCT[8]%></td>
                                        </tr>   
                                        <%
            try {
                if (listReceive != null && listReceive.size() > 0) {

                    double totHutang = 0;
                    double totTerbayar = 0;
                    double totSisa = 0;

                    for (int i = 0; i < listReceive.size(); i++) {
                        Receive receive = (Receive) listReceive.get(i);

                        String style = "";
                        if (i % 2 == 0) {
                            style = "tablecell";
                        } else {
                            style = "tablecell1";
                        }

                        Vendor v = new Vendor();
                        try {
                            v = DbVendor.fetchExc(receive.getVendorId());
                        } catch (Exception e) {
                            System.out.println(e);
                        }

                        double hutang = DbReceive.getTotInvoice(receive.getOID());
                        double payment = DbBankpoPaymentDetail.getTotalPaymentPosted(receive.getOID(), srcUntilDate, srcIgnoreUntil);                        
                        double balance = hutang - payment;

                        totHutang = totHutang + hutang;
                        totTerbayar = totTerbayar + payment;
                        totSisa = totSisa + balance;

                        if (print == 1) {
                            InvoiceArchive iArchive = new InvoiceArchive();
                            iArchive.setNomorInoice(receive.getNumber());
                            iArchive.setNomorDo(receive.getInvoiceNumber() + "/" + receive.getDoNumber());
                            iArchive.setTanggal(receive.getDate());
                            iArchive.setBatasPembayaran(receive.getDueDate());
                            iArchive.setVendor(v.getName());
                            iArchive.setHutang(hutang);
                            iArchive.setTerbayar(payment);
                            iArchive.setStatus(receive.getPaymentStatusPosted());
                            listPrint.add(iArchive);
                        }
                                        %>
                                        <tr height="22">
                                            <td class="<%=style%>" align="center"><%=(start + i + 1)%></td>
                                            <td class="<%=style%>" align="center"><%=receive.getNumber()%></td>
                                            <td class="<%=style%>"><%=receive.getInvoiceNumber() + "/" + receive.getDoNumber()%></td>
                                            <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(receive.getDate(), "dd MMM yyyy")%></td>
                                            <td class="<%=style%>" align="center"><%=JSPFormater.formatDate(receive.getDueDate(), "dd MMM yyyy")%></td>
                                            <td class="<%=style%>"><%=v.getName()%></td>
                                            <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(hutang, "#,###.##")%></td>
                                            <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(payment, "#,###.##")%></td>
                                            <td class="<%=style%>" align="right"><%=JSPFormater.formatNumber(balance, "#,###.##")%></td>
                                            <%if (receive.getPaymentStatusPosted() == I_Project.INV_STATUS_FULL_PAID) {%>
                                            <td bgcolor="D4543A" class="fontarial" align="center"><%=((receive.getPaymentStatusPosted() == 0) ? "-" : I_Project.invStatusStr[receive.getPaymentStatusPosted()])%></td>
                                            <%} else if (receive.getPaymentStatusPosted() == I_Project.INV_STATUS_PARTIALY_PAID) {%>
                                            <td bgcolor="72D5BF" class="fontarial" align="center"><%=((receive.getPaymentStatusPosted() == 0) ? "-" : I_Project.invStatusStr[receive.getPaymentStatusPosted()])%></td>
                                            <%} else {%>
                                            <td class="<%=style%>" align="center"><%=((receive.getPaymentStatusPosted() == 0) ? "-" : I_Project.invStatusStr[receive.getPaymentStatusPosted()])%></td>
                                            <%}%>    
                                        </tr> 
                                        <%
                                                }%>
                                        <%
                                                if (print == 1) {
                                                    session.putValue("REPORT_PRINT_INVOICE_ARCHIVE", listPrint);
                                        %>        
                                        <tr height="22">
                                            <td bgcolor="#cccccc" align="center" colspan="6">T O T A L</td>                                            
                                            <td bgcolor="#cccccc" align="right"><%=JSPFormater.formatNumber(totHutang, "#,###.##")%></td>
                                            <td bgcolor="#cccccc" align="right"><%=JSPFormater.formatNumber(totTerbayar, "#,###.##")%></td>
                                            <td bgcolor="#cccccc" align="right"><%=JSPFormater.formatNumber(totSisa, "#,###.##")%></td>
                                            <td bgcolor="#cccccc"></td>
                                        </tr> 
                                        <tr height="22">
                                            <td align="center" colspan="10">&nbsp;</td>                                            
                                        </tr>
                                        <tr height="22">
                                            <td align="left" colspan="10"><a href="javascript:cmdPrintJournalXLS()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('printx','','../images/printxls2.gif',1)"><img src="../images/printxls.gif" name="printx" border="0"></a></td>                                            
                                        </tr>
                                        <tr height="22">
                                            <td align="center" colspan="10">&nbsp;</td>                                            
                                        </tr>
                                        <%}%>
                                        <%}
            } catch (Exception exc) {
                System.out.println("sdsdf : " + exc.toString());
            }%>
                                    </table>
                                </td>
                            </tr>                                
                            <tr> 
                                <td colspan="3" height="3" background="<%=approot%>/images/line1.gif" ></td>                                                                                            
                            </tr>                            
                            <%if (print == 0) {%>
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
                                        %>
                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%></span> </td>
                            </tr>
                            <%}%>
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

