
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.receiving.*" %>
<%@ page import = "com.project.ccs.postransaction.purchase.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.general.*" %>
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
    public Vector drawList(int iJSPCommand, JspReceiveItem frmObject,
            ReceiveItem objEntity, Vector objectClass,
            long receiveItemId, String approot, long oidVendor,
            int iErrCode2, String status, Vector errorx,String[] langCT) {
        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablehdr");
        jsplist.setCellStyle("tablecell");
        jsplist.setCellStyle1("tablecell1");
        jsplist.setHeaderStyle("tablehdr");

        jsplist.addHeader("No", "4%");
        jsplist.addHeader(langCT[22], "");
        jsplist.addHeader(langCT[23], "6%");
        jsplist.addHeader(langCT[24], "10%");
        jsplist.addHeader(langCT[25], "8%");
        jsplist.addHeader(langCT[26], "10%");
        jsplist.addHeader(langCT[27], "10%");
        jsplist.addHeader(langCT[28], "7%");
        jsplist.addHeader(langCT[29], "15%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;
        Vector temp = new Vector();

        for (int i = 0; i < objectClass.size(); i++) {
            ReceiveItem receiveItem = (ReceiveItem) objectClass.get(i);
            SessIncomingGoodsL igL = new SessIncomingGoodsL();
            rowx = new Vector();
            if (receiveItemId == receiveItem.getOID()) {
                index = i;
            }

            ItemMaster itemMaster = new ItemMaster();
            ItemGroup ig = new ItemGroup();
            ItemCategory ic = new ItemCategory();
            try {
                itemMaster = DbItemMaster.fetchExc(receiveItem.getItemMasterId());
                ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
            } catch (Exception e) {
            }

            Uom uom = new Uom();
            try {
                uom = DbUom.fetchExc(receiveItem.getUomId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
            if (status != null && status.equals(I_Project.DOC_STATUS_DRAFT)) {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(receiveItem.getOID()) + "')\">" + ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName() + "</a>");
                igL.setGroup(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
            } else {
                rowx.add(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
                igL.setGroup(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
            }
            if (receiveItem.getIsBonus() == DbReceiveItem.BONUS) {
                rowx.add("<div align=\"center\">Yes</div>");
            } else {
                rowx.add("<div align=\"center\">-</div>");
            }
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getAmount(), "#,###.##") + "</div>");
            igL.setPrice(receiveItem.getAmount());
            rowx.add("<div align=\"right\">" + receiveItem.getQty() + "</div>");
            igL.setQty(receiveItem.getQty());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getTotalDiscount(), "#,###.##") + "</div>");
            igL.setDiscount(receiveItem.getTotalDiscount());
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(receiveItem.getTotalAmount(), "#,###.##") + "</div>");
            igL.setTotal(receiveItem.getTotalAmount());
            rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
            igL.setUnit(uom.getUnit());

            Coa coa = new Coa();
            try {
                coa = DbCoa.fetchExc(receiveItem.getApCoaId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"left\">" + coa.getCode() + "-" + coa.getName() + "</div>");

            lstData.add(rowx);
            temp.add(igL);
        }

        Vector v = new Vector();
        v.add(jsplist.draw(index));
        v.add(temp);
        return v;
    }
%>
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
            long oidReceiveItem = JSPRequestValue.requestLong(request, "hidden_receive_item_id");

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidReceive = 0;
            }

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdReceive cmdReceive = new CmdReceive(request);
            JSPLine ctrLine = new JSPLine();

            JspReceive jspReceive = cmdReceive.getForm();
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
            Vector vendors = DbVendor.list(0, 0, "", "name");

            if (receive.getVendorId() == 0) {
                if (vendors != null && vendors.size() > 0) {
                    Vendor vx = (Vendor) vendors.get(0);
                    receive.setVendorId(vx.getOID());
                }
            }

            Vector vendorItems = new Vector();
            double subTotal = DbReceiveItem.getTotalReceiveAmount(oidReceive);

            Vector errorx = new Vector();

            iErrCode = cmdReceive.action(iJSPCommand, oidReceive);
            jspReceive = cmdReceive.getForm();
            receive = cmdReceive.getReceive();
            msgString = cmdReceive.getMessage();


            String[] langCT = {"Vendor", "Doc Number", "Receive Date", "Ignored", "Invoice/DO", "Date", "Notes", "Amount", "Status", "Due Date", "PO Number", "Receive In",
                "Address", "PO Date", "DO Number", "Currency","Invoice Number","Date","Applay VAT","Payment Type","Term Of Payment","Notes",
                "Group/Category/Code - Name","Bonus","Price","Qty","Discount","Total","Unit","Account"
            };
            String[] langNav = {"Account Payable", "Invoice Data", "Record"};

            if (lang == LANG_ID) {
                String[] langID = {"Suplier", "Nomor Faktur", "Tanggal Pembelian", "Abaikan", "Faktur/DO", "Tanggal", "Memo", "Jumlah", "Status", "Batas Tanggal", "Nomor PO", "Lokasi Penerima", //0-11
                    "Alamat", "Tanggal Order", "Nomor Pesanan", "Mata Uang","Nomor Faktur","Tanggal","Pajak","Tipe Pembayaran","Waktu Pembayaran","Keterangan", // 12- 21
                    "Grop/Kategori/Kode - Nama","Bonus","Harga","Qty","Potongan","Total","Satuan","Perkiraan"
                };
                langCT = langID;

                String[] navID = {"Hutang", "Data Faktur", "Daftar"};
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
            <!--
            function cmdPrintDoc(){                
                window.open("<%=printrootinv%>.report.RptIncomingGoodsPdf?mis=<%=System.currentTimeMillis()%>","",'scrollbars=yes,status=yes,width=750,height=600,resizable=yes');
                }
                
                function cmdToRecord(){
                    document.frmreceive.command.value="<%=JSPCommand.NONE%>";
                    document.frmreceive.action="invoicearchive.jsp";
                    document.frmreceive.submit();
                }
                
                function cmdCloseDoc(){
                    document.frmreceive.action="<%=approot%>/home.jsp";
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
                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
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
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdToRecord()" class="tablink"><%=langNav[2]%></a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center"><%=langNav[1]%>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr> 
                                                                                <td class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                                                                        <td height="21" valign="middle" >&nbsp;</td>
                                                                                                        <td height="21" valign="middle" width="13%">&nbsp;</td>
                                                                                                        <td height="21" colspan="2" width="47%" class="comment" valign="top"> 
                                                                                                            <div align="right"><i>Date : 
                                                                                                                    <%=JSPFormater.formatDate(new Date(), "dd/MM/yyyy")%>, 
                                                                                                                    <%if (receive.getOID() == 0) {%>
                                                                                                                    Operator : <%=appSessUser.getLoginId()%>&nbsp; 
                                                                                                                    <%} else {
    User us = new User();
    try {
        us = DbUser.fetch(receive.getUserId());
    } catch (Exception e) {
    }
                                                                                                                    %>
                                                                                                                    Prepared By : <%=us.getLoginId()%> 
                                                                                                                    <%}%>
                                                                                                            </i>&nbsp;&nbsp;&nbsp;</div>
                                                                                                        </td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="5"></td>
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
                                                                                                        <td >&nbsp;&nbsp;<b><%=langCT[10]%></b></td>
                                                                                                        <td > <%=purchase.getNumber()%><%ig.setPoNumber(purchase.getNumber());%></td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td >&nbsp;&nbsp;<b><%=langCT[13]%></b></td>
                                                                                                        <td > <%=JSPFormater.formatDate(purchase.getPurchDate(), "dd/MM/yyyy")%> 
                                                                                                        <%ig.setPoDate(purchase.getPurchDate());%></td>
                                                                                                        <td >&nbsp;</td>
                                                                                                        <td >&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="5" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <tr align="left"> 
                                                                                                        <td >&nbsp;&nbsp;<b><%=langCT[0]%></b></td>
                                                                                                        <td > 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_PURCHASE_ID]%>" value="<%=purchase.getOID()%>">
                                                                                                            <%

            Vendor vnd = new Vendor();
            try {
                vnd = DbVendor.fetchExc(receive.getVendorId());
                ig.setVendor(vnd.getCode() + " - " + vnd.getName());
                ig.setAddress(vnd.getAddress());
            } catch (Exception e) {
            }
                                                                                                            %>
                                                                                                        <%=vnd.getCode() + " - " + vnd.getName()%> </td>
                                                                                                        <td ><b><%=langCT[11]%></b></td>
                                                                                                        <td > 
                                                                                                            <%
            Location loc = new Location();
            try {
                loc = DbLocation.fetchExc(receive.getLocationId());
                ig.setReceiveIn(loc.getCode() + " - " + loc.getName());
            } catch (Exception e) {
            }
                                                                                                            %>
                                                                                                        <%=loc.getCode() + " - " + loc.getName()%></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="3" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td >&nbsp;&nbsp;<b><%=langCT[12]%></b></td>
                                                                                                        <td > <%=vnd.getAddress()%> </td>
                                                                                                        <td ><b><%=langCT[1]%></b></td>
                                                                                                        <td > 
                                                                                                            <%
            String number = "";
            number = receive.getNumber();
            ig.setDocNumber(number);

                                                                                                            %>
                                                                                                        <%=number%></td>
                                                                                                    </tr>    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="3" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td >&nbsp;<b>&nbsp;<%=langCT[14]%></b></td>
                                                                                                        <td > <%=receive.getDoNumber()%> </td>
                                                                                                        <td ><b><%=langCT[15]%></b></td>
                                                                                                        <td colspan="2" >
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
                                                                                                        <td height="3" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td >&nbsp;<b>&nbsp;<%=langCT[16]%> </b></td>
                                                                                                        <td > <%=receive.getInvoiceNumber()%> 
                                                                                                            <%ig.setInvoiceNumber(receive.getInvoiceNumber());%>
                                                                                                        </td>
                                                                                                        <td ><b>Status</b></td>
                                                                                                        <td colspan="2" > 
                                                                                                        <%=(receive.getOID() == 0) ? I_Project.DOC_STATUS_DRAFT : ((receive.getStatus() == null) ? I_Project.DOC_STATUS_DRAFT : receive.getStatus())%></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="3" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;<b><%=langCT[17]%></b></td>
                                                                                                        <td height="21" width="30%"> <%=JSPFormater.formatDate((receive.getDate() == null) ? new Date() : receive.getDate(), "dd/MM/yyyy")%> 
                                                                                                            <%ig.setDate(receive.getDate());%>
                                                                                                        </td>
                                                                                                        <td width="11%"><b><%=langCT[18]%></b></td>
                                                                                                        <td colspan="2" class="comment" width="47%"> 
                                                                                                            <input type="hidden" name="<%=JspReceive.colNames[JspReceive.JSP_INCLUDE_TAX]%>" value="<%=receive.getIncluceTax()%>">
                                                                                                        <%=DbReceive.strIncludeTax[receive.getIncluceTax()]%></td>
                                                                                                    </tr>
                                                                                                     <tr align="left"> 
                                                                                                        <td height="3" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td >&nbsp;&nbsp;<b><%=langCT[19]%></b></td>
                                                                                                        <td > <%=receive.getPaymentType()%> </td>
                                                                                                        <td ><b><%=langCT[20]%></b></td>
                                                                                                        <td colspan="2"> 
                                                                                                            <%=JSPFormater.formatDate((receive.getDueDate() == null) ? new Date() : receive.getDueDate(), "dd/MM/yyyy")%> 
                                                                                                            <%ig.setPaymentType("" + receive.getPaymentType());%>
                                                                                                            <%ig.setTermOfPayment(receive.getDueDate());%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="3" colspan="5"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="12%">&nbsp;&nbsp;<b><%=langCT[21]%></b></td>
                                                                                                        <td height="21" colspan="4"> <%=receive.getNote()%> <%ig.setNotes(receive.getNote());%></td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            &nbsp; 
                                                                                                            <%
            Vector x = drawList(iJSPCommand, jspReceiveItem, receiveItem, purchItems, oidReceiveItem, approot, receive.getVendorId(), iErrCode2, receive.getStatus(), errorx,langCT);
            String strList = (String) x.get(0);
            Vector rptObj = (Vector) x.get(1);
                                                                                                            %>
                                                                                                            <%=strList%> 
                                                                                                            <% session.putValue("PURCHASE_DETAIL", rptObj);%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="2" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="38%" valign="middle">&nbsp; 
                                                                                                                    </td>
                                                                                                                    <td width="55%"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="62%"> 
                                                                                                                                    <div align="right"><b>Sub Total</b></div>
                                                                                                                                </td>
                                                                                                                                <td width="15%"> 
                                                                                                                                    <input type="hidden" name="sub_tot" value="<%=subTotal%>">
                                                                                                                                </td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_AMOUNT]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(subTotal, "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setSubTotal(subTotal);%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="60%"> 
                                                                                                                                    <div align="right"><b><%=langCT[26] %></b></div>
                                                                                                                                </td>
                                                                                                                                <td width="17%"> 
                                                                                                                                    <div align="center"> 
                                                                                                                                        <input name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_PERCENT]%>" type="text" value="<%=receive.getDiscountPercent()%>" size="5" style="text-align:center" onBlur="javascript:calculateAmount()" onClick="this.select()" readonly class="readonly">
                                                                                                                                    % </div>
                                                                                                                                    <%ig.setDiscount1(receive.getDiscountPercent());%>
                                                                                                                                </td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_DISCOUNT_TOTAL]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setDiscount2(receive.getDiscountTotal());%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="60%"> 
                                                                                                                                    <div align="right"><b><%=langCT[18]%></b></div>
                                                                                                                                </td>
                                                                                                                                <td width="17%"> 
                                                                                                                                    <div align="center"> 
                                                                                                                                        <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TAX_PERCENT]%>" size="5" value="<%=receive.getTaxPercent()%>" readOnly class="readOnly" style="text-align:center">
                                                                                                                                    % </div>
                                                                                                                                    <%ig.setVat1(receive.getTaxPercent());%>
                                                                                                                                </td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="<%=JspReceive.colNames[JspReceive.JSP_TOTAL_TAX]%>" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(receive.getTotalTax(), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setVat2(receive.getTotalTax());%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="60%"> 
                                                                                                                                    <div align="right"><b>Grand Total</b></div>
                                                                                                                                </td>
                                                                                                                                <td width="17%">&nbsp;</td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="grand_total" readOnly class="readOnly"  value="<%=JSPFormater.formatNumber(receive.getTotalAmount() + receive.getTotalTax() - receive.getDiscountTotal(), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>
                                                                                                                                    <%ig.setGrandTotal(receive.getTotalAmount() + receive.getTotalTax() - receive.getDiscountTotal());%>
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <tr> 
                                                                                                                                <td width="60%">&nbsp;</td>
                                                                                                                                <td width="17%">&nbsp;</td>
                                                                                                                                <td width="23%">&nbsp;</td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td colspan="4">&nbsp; </td>
                                                                                                                </tr>
                                                                                                                <tr> 
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
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="32%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><b><u>Document 
                                                                                                                    History</u></b></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>User</u></b></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>Date</u></b></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Prepared 
                                                                                                                    by</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
            User u = new User();
            try {
                u = DbUser.fetch(receive.getUserId());
            } catch (Exception e) {
            }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(receive.getDate(), "dd MMMM yy")%></i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Approved 
                                                                                                                    by</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%
            u = new User();
            try {
                u = DbUser.fetch(receive.getApproval1());
            } catch (Exception e) {
            }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (receive.getApproval1() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(receive.getApproval1Date(), "dd MMMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Checked 
                                                                                                                    by </i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                                <%
            u = new User();
            try {
                u = DbUser.fetch(receive.getApproval2());
            } catch (Exception e) {
            }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i> 
                                                                                                                                <%if (receive.getApproval2() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(receive.getApproval2Date(), "dd MMMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
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
