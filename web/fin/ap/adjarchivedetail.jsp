
<%-- 
    Document   : adjarchivedetail
    Created on : Apr 9, 2012, 1:57:01 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.adjusment.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_ARCHIVES);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_ARCHIVES, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_ARCHIVES, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_ARCHIVES, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MN_GL, AppMenu.M2_MN_JOURNAL_ADJUSMENT_ARCHIVES, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long adjusmentItemId, String status, String langAR[]) {

        JSPList jsplist = new JSPList();
        jsplist.setAreaWidth("100%");
        jsplist.setListStyle("listgen");
        jsplist.setTitleStyle("tablearialhdr");
        jsplist.setCellStyle("tablearialcell");
        jsplist.setCellStyle1("tablearialcell1");
        jsplist.setHeaderStyle("tablearialhdr");

        jsplist.addHeader("No", "5%");
        jsplist.addHeader("" + langAR[5], "25%");
        jsplist.addHeader("" + langAR[6], "10%");
        jsplist.addHeader("" + langAR[7], "10%");
        jsplist.addHeader("" + langAR[8], "10%");
        jsplist.addHeader("" + langAR[9], "10%");
        jsplist.addHeader("" + langAR[10], "15%");
        jsplist.addHeader("" + langAR[11], "15%");

        jsplist.setLinkRow(0);
        jsplist.setLinkSufix("");
        Vector lstData = jsplist.getData();
        Vector lstLinkData = jsplist.getLinkData();
        Vector rowx = new Vector(1, 1);
        jsplist.reset();
        int index = -1;

        Vector temp = new Vector();

        for (int i = 0; i < objectClass.size(); i++) {
            AdjusmentItem adjusmentItem = (AdjusmentItem) objectClass.get(i);
            RptAdjustmentL detail = new RptAdjustmentL();

            rowx = new Vector();
            if (adjusmentItemId == adjusmentItem.getOID()) {
                index = i;
            }

            ItemMaster itemMaster = new ItemMaster();
            ItemGroup ig = new ItemGroup();
            ItemCategory ic = new ItemCategory();
            try {
                itemMaster = DbItemMaster.fetchExc(adjusmentItem.getItemMasterId());
                ig = DbItemGroup.fetchExc(itemMaster.getItemGroupId());
                ic = DbItemCategory.fetchExc(itemMaster.getItemCategoryId());
            } catch (Exception e) {
            }

            rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
            if (status != null && status.equals(I_Project.DOC_STATUS_DRAFT)) {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(adjusmentItem.getOID()) + "')\">" + ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName() + "</a>");
                detail.setName(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
            } else {
                rowx.add(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
                detail.setName(ig.getName() + "/ " + ic.getName() + "/ " + itemMaster.getCode() + " - " + itemMaster.getName());
            }
            rowx.add("<div align=\"center\">" + adjusmentItem.getQtySystem() + "</div>");
            detail.setQtySystem(adjusmentItem.getQtySystem());
            rowx.add("<div align=\"center\">" + adjusmentItem.getQtyReal() + "</div>");
            detail.setQtyReal(adjusmentItem.getQtyReal());
            rowx.add("<div align=\"center\">" + adjusmentItem.getQtyBalance() + "</div>");

            Uom uom = new Uom();
            try {
                uom = DbUom.fetchExc(itemMaster.getUomStockId());
            } catch (Exception e) {
            }
            rowx.add("<div align=\"center\">" + uom.getUnit() + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(adjusmentItem.getPrice(), "#,###.##") + "</div>");
            rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(adjusmentItem.getAmount(), "#,###.##") + "</div>");

            lstData.add(rowx);
        }

        return jsplist.draw();
    }
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");

            if (iJSPCommand == JSPCommand.NONE) {
                iJSPCommand = JSPCommand.ADD;
                oidAdjusment = 0;
            }

            /*variable declaration*/
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdAdjusment cmdAdjusment = new CmdAdjusment(request);
            JSPLine ctrLine = new JSPLine();
            iErrCode = cmdAdjusment.action(iJSPCommand, oidAdjusment);

            Adjusment adjusment = cmdAdjusment.getAdjusment();
            try {
                adjusment = DbAdjusment.fetchExc(oidAdjusment);
            } catch (Exception e) {
            }
%>	
<%
            long oidAdjusmentItem = JSPRequestValue.requestLong(request, "hidden_adjusment_item_id");
            int iErrCode2 = JSPMessage.NONE;
            CmdAdjusmentItem cmdAdjusmentItem = new CmdAdjusmentItem(request);
            iErrCode2 = cmdAdjusmentItem.action(iJSPCommand, oidAdjusmentItem, oidAdjusment);
            whereClause = DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ID] + "=" + oidAdjusment;
            orderClause = DbAdjusmentItem.colNames[DbAdjusmentItem.COL_ADJUSMENT_ITEM_ID];
            Vector purchItems = DbAdjusmentItem.list(0, 0, whereClause, orderClause);

            Vector locations = DbLocation.list(0, 0, "", "code");
            if (adjusment.getLocationId() == 0 && locations != null && locations.size() > 0) {
                Location lxx = (Location) locations.get(0);
                adjusment.setLocationId(lxx.getOID());
            }

            double subTotalReal = DbAdjusmentItem.getTotalQtyAdjusment(oidAdjusment, DbAdjusmentItem.colNames[DbAdjusmentItem.COL_QTY_REAL]);
            String[] langAR = {"Number", "Date", "Location", "Doc. Status", "Notes", "Group/Category/Code - Name", "Qty System", "Qty Real", // 0-7
                "Balance", "Unit", "@ Price", "Total Amount", "Total Adjustment"}; // 8 - 12
            String[] langNav = {"Journal", "Adjusment - Archive Detail", "Archive", "Detail", "Search Parameters"};

            if (lang == LANG_ID) {
                String[] langID = {"Nomor", "Tanggal", "Lokasi", "Status Dok.", "Memo", "Grup/Kategori/Kode - Nama", "Qty Sistem", "Qty Sebenarnya", //0 - 7
                    "Balance", "Satuan", "@ Harga", "Jum. Total", "Tot. Penyesuaian"}; //8-12
                langAR = langID;

                String[] navID = {"Jurnal", "Adjusment - Arsip Detail", "Arsip", "Detail", "Parameter Pencarian"};
                langNav = navID;
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title><%=systemTitle%></title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
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
                    }
                    else{
                        if(xx==',' || xx=='.'){
                            result = result + xx;
                        }
                    }
                }
                return result;
            }
            
            function cmdBack(){
                document.frmadjusment.command.value="<%=JSPCommand.NONE%>";
                document.frmadjusment.action="adjusmentarchive.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/new2.gif','../images/yes2.gif','../images/cancel2.gif','../images/savedoc2.gif','../images/del2.gif','../images/print2.gif','../images/close2.gif')">
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
                                        <td width="165" height="100%" valign="top" style="background:url(<%=approot%>/images/leftmenu-bg.gif) repeat-y"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmadjusment" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="start" value="0">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="<%=JspAdjusment.colNames[JspAdjusment.JSP_USER_ID]%>" value="<%=appSessUser.getUserOID()%>">
                                                            <input type="hidden" name="hidden_adjusment_item_id" value="<%=oidAdjusmentItem%>">
                                                            <input type="hidden" name="hidden_adjusment_id" value="<%=oidAdjusment%>">
                                                            <input type="hidden" name="<%=JspAdjusmentItem.colNames[JspAdjusmentItem.JSP_ADJUSMENT_ID]%>" value="<%=oidAdjusment%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                            <tr valign="bottom"> 
                                                                                <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                                                                %>
                                                                                <%@ include file="../main/navigator.jsp"%>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr> 
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                            
                                                                            <tr> 
                                                                                <td class="page"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="0">                                                                                                    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" width="60" class="fontarial">&nbsp;&nbsp;<%=langAR[0]%></td>
                                                                                                        <td height="21" width="27%" class="fontarial"><span class="comment">:                                                                                                               
                                                                                                        <%=adjusment.getNumber()%></span></td>
                                                                                                        <td width="9%" class="fontarial"><%=langAR[1]%></td>
                                                                                                        <td colspan="2" class="comment" class="fontarial">: 
                                                                                                            <%=JSPFormater.formatDate(adjusment.getDate(), "dd/MM/yyyy")%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" class="fontarial">&nbsp;&nbsp;<%=langAR[2]%></td>
                                                                                                        <td height="21" class="fontarial"><span class="comment">: 
                                                                                                                <%
            String loc = "";
            try {
                Location locx = DbLocation.fetchExc(adjusment.getLocationId());
                loc = locx.getName();
            } catch (Exception e) {
            }
                                                                                                                %>
                                                                                                                <%=loc%>
                                                                                                        </span> </td>
                                                                                                        <td class="fontarial"><%=langAR[3]%></td>
                                                                                                        <td colspan="2" class="comment" >:
                                                                                                            <%=adjusment.getStatus()%>                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>                                                                                                    
                                                                                                    <tr align="left"> 
                                                                                                        <td height="21" class="fontarial">&nbsp;&nbsp;<%=langAR[4]%></td>
                                                                                                        <td height="21" colspan="4" class="fontarial">: 
                                                                                                            <%=adjusment.getNote()%>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">                                                                                                             
                                                                                                            <%=drawList(purchItems, oidAdjusmentItem, adjusment.getStatus(), langAR)%>                                                                                                            
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td colspan="3" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="3" background="../images/line1.gif"><img src="../images/line1.gif" width="42" height="3"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="3" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="45%" valign="middle"> 
                                                                                                                        <%if (adjusment.getStatus().equals(I_Project.DOC_STATUS_DRAFT)) {%>
                                                                                                                        <table width="72%" border="0" cellspacing="0" cellpadding="0">
                                                                                                                            <%
    if (iJSPCommand == JSPCommand.ADD || iJSPCommand == JSPCommand.LOAD ||
            (iJSPCommand == JSPCommand.EDIT && oidAdjusmentItem != 0) ||
            iJSPCommand == JSPCommand.ASK || iErrCode2 != 0) {%>
                                                                                                                            <tr> 
                                                                                                                                <td> 
                                                                                                                                    <%
                                                                                                                                ctrLine = new JSPLine();
                                                                                                                                ctrLine.setLocationImg(approot + "/images/ctr_line");
                                                                                                                                ctrLine.initDefault();
                                                                                                                                ctrLine.setTableWidth("80%");
                                                                                                                                String scomDel = "javascript:cmdAsk('" + oidAdjusmentItem + "')";
                                                                                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidAdjusmentItem + "')";
                                                                                                                                String scancel = "javascript:cmdBack('" + oidAdjusmentItem + "')";
                                                                                                                                ctrLine.setBackCaption("Back to List");
                                                                                                                                ctrLine.setJSPCommandStyle("buttonlink");
                                                                                                                                ctrLine.setDeleteCaption("Delete");

                                                                                                                                ctrLine.setOnMouseOut("MM_swapImgRestore()");
                                                                                                                                ctrLine.setOnMouseOverSave("MM_swapImage('save_item','','" + approot + "/images/save2.gif',1)");
                                                                                                                                ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save_item\" height=\"22\" border=\"0\">");

                                                                                                                                //ctrLine.setOnMouseOut("MM_swapImgRestore()");
                                                                                                                                ctrLine.setOnMouseOverBack("MM_swapImage('back_item','','" + approot + "/images/cancel2.gif',1)");
                                                                                                                                ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back_item\" height=\"22\" border=\"0\">");

                                                                                                                                ctrLine.setOnMouseOverDelete("MM_swapImage('delete_item','','" + approot + "/images/delete2.gif',1)");
                                                                                                                                ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete_item\" height=\"22\" border=\"0\">");

                                                                                                                                ctrLine.setOnMouseOverEdit("MM_swapImage('edit_item','','" + approot + "/images/cancel2.gif',1)");
                                                                                                                                ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit_item\" height=\"22\" border=\"0\">");


                                                                                                                                ctrLine.setWidthAllJSPCommand("90");
                                                                                                                                ctrLine.setErrorStyle("warning");
                                                                                                                                ctrLine.setErrorImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
                                                                                                                                ctrLine.setQuestionStyle("warning");
                                                                                                                                ctrLine.setQuestionImage(approot + "/images/error.gif\" width=\"20\" height=\"20");
                                                                                                                                ctrLine.setInfoStyle("success");
                                                                                                                                ctrLine.setSuccessImage(approot + "/images/success.gif\" width=\"20\" height=\"20");

                                                                                                                                if (privDelete) {
                                                                                                                                    ctrLine.setConfirmDelJSPCommand(sconDelCom);
                                                                                                                                    ctrLine.setDeleteJSPCommand(scomDel);
                                                                                                                                    ctrLine.setEditJSPCommand(scancel);
                                                                                                                                } else {
                                                                                                                                    ctrLine.setConfirmDelCaption("");
                                                                                                                                    ctrLine.setDeleteCaption("");
                                                                                                                                    ctrLine.setEditCaption("");
                                                                                                                                }

                                                                                                                                if (privAdd == false && privUpdate == false) {
                                                                                                                                    ctrLine.setSaveCaption("");
                                                                                                                                }

                                                                                                                                if (privAdd == false) {
                                                                                                                                    ctrLine.setAddCaption("");
                                                                                                                                }
                                                                                                                                if ((iJSPCommand == JSPCommand.DELETE) || (iJSPCommand == JSPCommand.SAVE) && (iErrCode == 0)) {
                                                                                                                                    ctrLine.setAddCaption("");
                                                                                                                                    ctrLine.setCancelCaption("");
                                                                                                                                    ctrLine.setBackCaption("");
                                                                                                                                    msgString = "Data is Saved";
                                                                                                                                }

                                                                                                                                if (iJSPCommand == JSPCommand.LOAD) {
                                                                                                                                    if (oidAdjusmentItem == 0) {
                                                                                                                                        iJSPCommand = JSPCommand.ADD;
                                                                                                                                    } else {
                                                                                                                                        iJSPCommand = JSPCommand.EDIT;
                                                                                                                                    }
                                                                                                                                }

                                                                                                                                    %>
                                                                                                                                    <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> 
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                            <%} else {%>
                                                                                                                            <tr> 
                                                                                                                                <td><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                                                            </tr>
                                                                                                                            <%}%>
                                                                                                                        </table>
                                                                                                                        <%}%>
                                                                                                                    </td>
                                                                                                                    <td width="55%" colspan="2"> 
                                                                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                                                            <tr> 
                                                                                                                                <td width="60%"> 
                                                                                                                                    <div align="right"><b><%=langAR[12]%></b></div>
                                                                                                                                </td>
                                                                                                                                <td width="17%"> 
                                                                                                                                    <input type="hidden" name="sub_tot" value="<%=subTotalReal%>">
                                                                                                                                </td>
                                                                                                                                <td width="23%"> 
                                                                                                                                    <div align="right"> 
                                                                                                                                        <input type="text" name="total_real" readOnly class="readOnly" value="<%=JSPFormater.formatNumber(DbAdjusmentItem.getTotalAdjustmentAmount(adjusment.getOID()), "#,###.##")%>" style="text-align:right">
                                                                                                                                    </div>                                                                                                                                    
                                                                                                                                </td>
                                                                                                                            </tr>
                                                                                                                        </table>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if (adjusment.getOID() != 0) {%>
                                                                                                    <%if (adjusment.getPostedStatus() == 0) {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5">
                                                                                                            <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="cancel" height="22" border="0"></a>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%} else {%>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5">
                                                                                                            <a href="javascript:cmdBack()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('cancel','','../images/back2.gif',1)"><img src="../images/back.gif" name="cancel" height="22" border="0"></a>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="5" height="5">
                                                                                                            <div align="left" class="msgnextaction"> 
                                                                                                                <table border="0" cellpadding="5" cellspacing="0" class="success" align="left">
                                                                                                                    <tr>
                                                                                                                        <td width="20"><img src="../images/success.gif" height="20"></td>
                                                                                                                        <td width="150">Posted</td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                    <%}%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <%if (adjusment.getOID() != 0) {%>
                                                                                                    <tr align="left" > 
                                                                                                        <td colspan="5" valign="top"> 
                                                                                                            <table width="32%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1" align="center"><b><u>Document History</u></b></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>User</u></b></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><b><u>Date</u></b></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Prepared 
                                                                                                                    By</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="left"> <i> 
                                                                                                                                <%
    User u = new User();
    try {
        u = DbUser.fetch(adjusment.getUserId());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"><i><%=JSPFormater.formatDate(adjusment.getDate(), "dd MMM yy")%></i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Approved 
                                                                                                                    by</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="left"> <i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(adjusment.getApproval1());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (adjusment.getApproval1() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(adjusment.getApproval1_date(), "dd MMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="33%" class="tablecell1"><i>Posted 
                                                                                                                    by</i></td>
                                                                                                                    <td width="34%" class="tablecell1"> 
                                                                                                                        <div align="left"> <i> 
                                                                                                                                <%
    u = new User();
    try {
        u = DbUser.fetch(adjusment.getPostedById());
    } catch (Exception e) {
    }
                                                                                                                                %>
                                                                                                                        <%=u.getLoginId()%></i></div>
                                                                                                                    </td>
                                                                                                                    <td width="33%" class="tablecell1"> 
                                                                                                                        <div align="center"> <i> 
                                                                                                                                <%if (adjusment.getPostedById() != 0) {%>
                                                                                                                                <%=JSPFormater.formatDate(adjusment.getPostedDate(), "dd MMM yy")%> 
                                                                                                                                <%}%>
                                                                                                                        </i></div>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%}%>
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
                </td>
            </tr>
        </table>
    </body>
<!-- #EndTemplate --></html>
