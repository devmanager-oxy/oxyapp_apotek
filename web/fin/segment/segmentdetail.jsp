
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_SEGMENT, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
    public String drawList(int start, int iJSPCommand, JspSegmentDetail frmObject, SegmentDetail objEntity, Vector objectClass, long segmentDetailId, long oidSegment, Vector all) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("1150");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");

        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("No", "20");
        ctrlist.addHeader("Code", "45");
        ctrlist.addHeader("Name", "16%");
        ctrlist.addHeader("Location", "20%");
        ctrlist.addHeader("Journal Location", "15%");
        ctrlist.addHeader("Parent", "15%");
        ctrlist.addHeader("Status", "80");
        ctrlist.addHeader("Type Sales Report", "");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        Vector rowx = new Vector(1, 1);
        ctrlist.reset();
        int index = -1;

        Vector reflocid_value = new Vector(1, 1);
        Vector reflocid_key = new Vector(1, 1);
        reflocid_value.add("0");
        reflocid_key.add("- Default -");

        if (all != null && all.size() > 0) {
            for (int k = 0; k < all.size(); k++) {
                SegmentDetail sdxx = (SegmentDetail) all.get(k);
                reflocid_key.add(sdxx.getName());
                reflocid_value.add("" + sdxx.getOID());
            }
        }


        /* selected RefId*/
        Segment segmentParent = DbSegment.gerRef(oidSegment);
        Vector refs = DbSegmentDetail.list(0, 0, DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + "=" + segmentParent.getOID(), "code");

        Vector refid_value = new Vector(1, 1);
        Vector refid_key = new Vector(1, 1);
        refid_value.add("0");
        refid_key.add("- no parent -");

        if (refs != null && refs.size() > 0) {
            for (int i = 0; i < refs.size(); i++) {

                SegmentDetail segD = (SegmentDetail) refs.get(i);

                String str = "";
                switch (segD.getLevel()) {
                    case 0:
                        break;
                    case 1:
                        str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        break;
                    case 2:
                        str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        break;
                    case 3:
                        str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        break;
                    case 4:
                        str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        break;
                }

                refid_value.add("" + segD.getOID());
                refid_key.add(str + segD.getName());
            }
        }

        Vector type_value = new Vector(1, 1);
        Vector type_key = new Vector(1, 1);
        type_value.add("HEADER");
        type_key.add("HEADER");
        type_value.add("POSTABLE");
        type_key.add("POSTABLE");

        Vector vLoc = DbLocation.listAll();
        Vector loc_val = new Vector();
        Vector loc_key = new Vector();

        loc_val.add("" + 0);
        loc_key.add("- no location -");

        if (vLoc != null && vLoc.size() > 0) {
            for (int x = 0; x < vLoc.size(); x++) {
                Location loc = (Location) vLoc.get(x);
                loc_val.add("" + loc.getOID());
                loc_key.add("" + loc.getName());
            }
        }

        Vector sales_val = new Vector();
        Vector sales_key = new Vector();

        for (int x = 0; x < DbSegmentDetail.typeSaleStr.length; x++) {
            sales_val.add("" + x);
            sales_key.add("" + DbSegmentDetail.typeSaleStr[x]);
        }

        Vector status_val = new Vector();
        Vector status_key = new Vector();

        for (int x = 0; x < DbSegmentDetail.strKeyStatus.length; x++) {
            status_val.add("" + x);
            status_key.add("" + DbSegmentDetail.strKeyStatus[x]);
        }

        for (int i = 0; i < objectClass.size(); i++) {
            SegmentDetail segmentDetail = (SegmentDetail) objectClass.get(i);

            String str = "";
            switch (segmentDetail.getLevel()) {
                case 0:
                    break;
                case 1:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 2:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 3:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
                case 4:
                    str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    break;
            }

            rowx = new Vector();
            if (segmentDetailId == segmentDetail.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
                rowx.add("<div align=\"left\"><input type=\"text\" size=\"8\" name=\"" + frmObject.colNames[JspSegmentDetail.JSP_CODE] + "\" value=\"" + segmentDetail.getCode() + "\" class=\"formElemen\">" + frmObject.getErrorMsg(frmObject.JSP_CODE) + "</div>");
                rowx.add("<div align=\"left\"><input type=\"text\" name=\"" + frmObject.colNames[JspSegmentDetail.JSP_NAME] + "\" size=\"40\" value=\"" + segmentDetail.getName() + "\" class=\"formElemen\">" + frmObject.getErrorMsg(frmObject.JSP_NAME) + "</div>");
                rowx.add("<div align=\"left\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_LOCATION_ID], null, "" + segmentDetail.getLocationId(), loc_val, loc_key, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_REF_SEGMENT_DETAIL_ID], null, "" + segmentDetail.getRefSegmentDetailId(), reflocid_value, reflocid_key, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_REF_ID], null, "" + segmentDetail.getRefId(), refid_value, refid_key, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_STATUS], null, "" + segmentDetail.getStatus(), status_val, status_key, "formElemen", "") + "</div>");
                rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_TYPE_SALES_REPORT], null, "" + segmentDetail.getTypeSalesReport(), sales_val, sales_key, "formElemen", "") + "</div>");
            } else {
                rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(segmentDetail.getOID()) + "')\">" + str + (segmentDetail.getCode()) + "</a>");
                rowx.add(str + segmentDetail.getName());
                SegmentDetail sd = new SegmentDetail();
                try {
                    sd = DbSegmentDetail.fetchExc(segmentDetail.getRefId());
                } catch (Exception e) {
                }

                String nameLocation = "- no location -";
                try {
                    Location lx = DbLocation.fetchExc(segmentDetail.getLocationId());
                    nameLocation = lx.getName();
                } catch (Exception e) {
                }
                rowx.add(nameLocation);

                String locationJournal = "- default -";
                try {
                    if (segmentDetail.getRefSegmentDetailId() != 0) {
                        SegmentDetail sdf = new SegmentDetail();
                        sdf = DbSegmentDetail.fetchExc(segmentDetail.getRefSegmentDetailId());
                        locationJournal = sdf.getName();
                    }
                } catch (Exception e) {
                }
                rowx.add("" + locationJournal);

                if (sd.getOID() == 0) {
                    rowx.add("- no parent -");
                } else {
                    rowx.add("" + sd.getName());
                }
                rowx.add(DbSegmentDetail.strKeyStatus[segmentDetail.getStatus()]);
                rowx.add(DbSegmentDetail.typeSaleStr[segmentDetail.getTypeSalesReport()]);

            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<div align=\"center\"></div>");
            rowx.add("<div align=\"left\"><input type=\"text\" size=\"8\" name=\"" + frmObject.colNames[JspSegmentDetail.JSP_CODE] + "\" value=\"" + ((objEntity.getCode() == null) ? "" : objEntity.getCode()) + "\" class=\"formElemen\">" + frmObject.getErrorMsg(frmObject.JSP_CODE) + "</div>");
            rowx.add("<div align=\"left\"><input type=\"text\" name=\"" + frmObject.colNames[JspSegmentDetail.JSP_NAME] + "\" size=\"40\" value=\"" + objEntity.getName() + "\" class=\"formElemen\">" + frmObject.getErrorMsg(frmObject.JSP_NAME) + "</div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_LOCATION_ID], null, "" + objEntity.getLocationId(), loc_val, loc_key, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_REF_SEGMENT_DETAIL_ID], null, "" + objEntity.getRefSegmentDetailId(), refid_value, refid_key, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_REF_ID], null, "" + objEntity.getRefId(), refid_value, refid_key, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_STATUS], null, "" + objEntity.getStatus(), status_val, status_key, "formElemen", "") + "</div>");
            rowx.add("<div align=\"center\">" + JSPCombo.draw(frmObject.colNames[JspSegmentDetail.JSP_TYPE_SALES_REPORT], null, "" + objEntity.getTypeSalesReport(), sales_val, sales_key, "formElemen", "") + "</div>");
        }

        lstData.add(rowx);
        return ctrlist.draw(index);
    }
%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidSegmentDetail = JSPRequestValue.requestLong(request, "hidden_segment_detail_id");
            long oidSegment = JSPRequestValue.requestLong(request, "hidden_segment_id");
            int showAll = JSPRequestValue.requestInt(request, "show_all");

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = DbSegmentDetail.colNames[DbSegmentDetail.COL_SEGMENT_ID] + "=" + oidSegment;
            String orderClause = DbSegmentDetail.colNames[DbSegmentDetail.COL_CODE];

            Vector segments = DbSegment.list(0, 0, "", "");

            CmdSegmentDetail ctrlSegmentDetail = new CmdSegmentDetail(request);
            ctrlSegmentDetail.setUserId(user.getOID());
            JSPLine ctrLine = new JSPLine();
            Vector listSegmentDetail = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlSegmentDetail.action(iJSPCommand, oidSegmentDetail);
            /* end switch*/
            JspSegmentDetail jspSegmentDetail = ctrlSegmentDetail.getForm();

            /*count list All SegmentDetail*/
            int vectSize = DbSegmentDetail.getCount(whereClause);

            /*switch list SegmentDetail*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlSegmentDetail.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            SegmentDetail segmentDetail = ctrlSegmentDetail.getSegmentDetail();
            msgString = ctrlSegmentDetail.getMessage();

            /* get record to display */
            listSegmentDetail = DbSegmentDetail.list(start, recordToGet, whereClause, orderClause);

            Vector segmentDetailAll = DbSegmentDetail.list(0, 0, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listSegmentDetail.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listSegmentDetail = DbSegmentDetail.list(start, recordToGet, whereClause, orderClause);
            }

            /*** LANG ***/
            String[] langMD = {"Records", "Editor", "Account Group", //0-2
                "Account", "Budget", "Transaction", "Budget Balance", "Account Group", "Is SP", "Level", "Department", "Section"}; //3-11

            String[] langNav = {"Masterdata", "Segment Detail", "All"};

            if (lang == LANG_ID) {
                String[] langID = {"Daftar", "Editor", "Kelompok Perkiraan",
                    "Perkiraan", "Anggaran", "Transaksi", "Saldo Anggaran", "Kelompok Perkiraan", "SP", "Level", "Departemen", "Bagian"
                };
                langMD = langID;

                String[] navID = {"Data Induk", "Segmen Detail", "Semua"};
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
            function cmdUnShowAll(){                
                document.frmsegmentdetail.command.value="<%=JSPCommand.LIST%>";                
                document.frmsegmentdetail.show_all.value=0;
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdShowAll(){                
                document.frmsegmentdetail.command.value="<%=JSPCommand.LIST%>";                
                document.frmsegmentdetail.show_all.value=1;
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdChange(){
                document.frmsegmentdetail.command.value="<%=JSPCommand.LIST%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdAdd(){
                document.frmsegmentdetail.hidden_segment_detail_id.value="0";
                document.frmsegmentdetail.command.value="<%=JSPCommand.ADD%>";
                document.frmsegmentdetail.prev_command.value="<%=prevJSPCommand%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdAsk(oidSegmentDetail){
                document.frmsegmentdetail.hidden_segment_detail_id.value=oidSegmentDetail;
                document.frmsegmentdetail.command.value="<%=JSPCommand.ASK%>";
                document.frmsegmentdetail.prev_command.value="<%=prevJSPCommand%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdConfirmDelete(oidSegmentDetail){
                document.frmsegmentdetail.hidden_segment_detail_id.value=oidSegmentDetail;
                document.frmsegmentdetail.command.value="<%=JSPCommand.DELETE%>";
                document.frmsegmentdetail.prev_command.value="<%=prevJSPCommand%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdSave(){
                document.frmsegmentdetail.command.value="<%=JSPCommand.SAVE%>";
                document.frmsegmentdetail.prev_command.value="<%=prevJSPCommand%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdEdit(oidSegmentDetail){
                <%if (privUpdate) {%>
                document.frmsegmentdetail.hidden_segment_detail_id.value=oidSegmentDetail;
                document.frmsegmentdetail.command.value="<%=JSPCommand.EDIT%>";
                document.frmsegmentdetail.prev_command.value="<%=prevJSPCommand%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
                <%}%> 
            }
            
            function cmdCancel(oidSegmentDetail){
                document.frmsegmentdetail.hidden_segment_detail_id.value=oidSegmentDetail;
                document.frmsegmentdetail.command.value="<%=JSPCommand.EDIT%>";
                document.frmsegmentdetail.prev_command.value="<%=prevJSPCommand%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdBack(){
                document.frmsegmentdetail.command.value="<%=JSPCommand.BACK%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdListFirst(){
                document.frmsegmentdetail.command.value="<%=JSPCommand.FIRST%>";
                document.frmsegmentdetail.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdListPrev(){
                document.frmsegmentdetail.command.value="<%=JSPCommand.PREV%>";
                document.frmsegmentdetail.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdListNext(){
                document.frmsegmentdetail.command.value="<%=JSPCommand.NEXT%>";
                document.frmsegmentdetail.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            function cmdListLast(){
                document.frmsegmentdetail.command.value="<%=JSPCommand.LAST%>";
                document.frmsegmentdetail.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmsegmentdetail.action="segmentdetail.jsp";
                document.frmsegmentdetail.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidSegmentDetail){
                document.frmimage.hidden_segment_detail_id.value=oidSegmentDetail;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="segmentdetail.jsp";
                document.frmimage.submit();
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">" + langNav[0] + "</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">" + langNav[1] + "</span></font>";
                                           %>
                                                    <%@ include file="../main/navigator.jsp"%><!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmsegmentdetail" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="show_all" value="0">
                                                            <input type="hidden" name="hidden_segment_detail_id" value="<%=oidSegmentDetail%>">
                                                            <input type="hidden" name="<%=JspSegmentDetail.colNames[JspSegmentDetail.JSP_SEGMENT_ID]%>" value="<%=oidSegment%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top">
                                                                                <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <table width="50%" border="0" cellspacing="2" cellpadding="2">
                                                                                        <tr>
                                                                                            <td width="10%">Segment</td>
                                                                                            <td width="90%">
                                                                                                <select name="hidden_segment_id" onChange="javascript:cmdChange()">
                                                                                                    <%if (segments != null && segments.size() > 0) {
                for (int i = 0; i < segments.size(); i++) {
                    Segment segment = (Segment) segments.get(i);
                                                                                                    %>
                                                                                                    <option value="<%=segment.getOID()%>" <%if (segment.getOID() == oidSegment) {%>selected<%}%>><%=segment.getName()%></option>
                                                                                                    <%}
            }%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> 
                                                                                <%= drawList(start, iJSPCommand, jspSegmentDetail, segmentDetail, listSegmentDetail, oidSegmentDetail, oidSegment, segmentDetailAll)%> </td>
                                                                            </tr>
                                                                            <%
            } catch (Exception exc) {
            }%>
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
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
                                                                            </tr>
                                                                            <%
            if ((iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iJSPCommand != JSPCommand.EDIT) && (jspSegmentDetail.errorSize() < 1)) {
                if (privAdd) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td> 
                                                                                    <table cellpadding="0" cellspacing="0" border="0">
                                                                                        <tr> 
                                                                                            <td width="4"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                            <td width="20"><a href="javascript:cmdAdd()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image261','','<%=approot%>/images/ctr_line/BtnNewOn.jpg',1)"><img name="Image261" border="0" src="<%=approot%>/images/ctr_line/BtnNew.jpg" width="18" height="16" alt="Add new data"></a></td>
                                                                                            <td width="6"><img src="<%=approot%>/images/spacer.gif" width="1" height="1"></td>
                                                                                            <td height="22" valign="middle" colspan="3" width="951"> 
                                                                                                <a href="javascript:cmdAdd()" class="command">Add 
                                                                                            New</a></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <%}
            }%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspSegmentDetail.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="container"> 
                                                                        <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidSegmentDetail + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidSegmentDetail + "')";
    String scancel = "javascript:cmdEdit('" + oidSegmentDetail + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");

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
                                                                        %>
                                                                    <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%> </td>
                                                                </tr>
                                                                <%}%>
                                                                <tr>
                                                                    <td colspan="3">&nbsp;</td>
                                                                </tr>    
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="800" >
                                                                            <tr>
                                                                                <td width="120" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Date</i><b></td>
                                                                                <td width="470" bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>Description</i><b></td>
                                                                                <td bgcolor="#F3F3F3" class="fontarial" align="center"><b><i>By</i><b></td>
                                                                            </tr>   
                                                                            <%
            int max = 10;
            if (showAll == 1) {
                max = 0;
            }
            int countx = DbHistoryUser.getCount(DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_SEGMENT_DETAIL);
            Vector historys = DbHistoryUser.list(0, max, DbHistoryUser.colNames[DbHistoryUser.COL_TYPE] + " = " + DbHistoryUser.TYPE_SEGMENT_DETAIL, DbHistoryUser.colNames[DbHistoryUser.COL_DATE] + " desc");
            if (historys != null && historys.size() > 0) {

                for (int r = 0; r < historys.size(); r++) {
                    HistoryUser hu = (HistoryUser) historys.get(r);

                    Employee e = new Employee();
                    try {
                        e = DbEmployee.fetchExc(hu.getEmployeeId());
                    } catch (Exception ex) {
                    }
                    String name = "-";
                    if (e.getName() != null && e.getName().length() > 0) {
                        name = e.getName();
                    }
                    
                    SegmentDetail sdx = new SegmentDetail();
                    try{
                        sdx = DbSegmentDetail.fetchExc(hu.getRefId());
                    }catch(Exception ex){}
                    String desc = "";
                    if(sdx.getOID() != 0 && sdx.getName() != null && sdx.getName().length() > 0){
                        desc = desc + sdx.getName()+" : ";
                    }
                    
                    desc = desc + hu.getDescription();
                                                                            %>
                                                                            <tr>
                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td class="fontarial" style=padding:3px;><%=JSPFormater.formatDate(hu.getDate(), "dd MMM yyyy HH:mm:ss ")%></td>
                                                                                <td class="fontarial" style=padding:3px;><i><%=desc%></i></td>
                                                                                <td class="fontarial" style=padding:3px;><%=name%></td>
                                                                            </tr>
                                                                            <%
                                                                                }

                                                                            } else {
                                                                            %>
                                                                            <tr>
                                                                                <td colspan="3" class="fontarial" style=padding:3px;><i>No history available</i></td>
                                                                            </tr>
                                                                            <%}%>
                                                                            <tr>
                                                                                <td colspan="3" height="1" bgcolor="#CCCCCC"></td>
                                                                            </tr>
                                                                            <%
            if (countx > max) {
                if (showAll == 0) {
                                                                            %>
                                                                            <tr>
                                                                                <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdShowAll()"><i>Show All History (<%=countx%>) Data</i></a></td>
                                                                            </tr>
                                                                            <%
                                                                                } else {
                                                                            %>
                                                                            <tr>
                                                                                <td colspan="3" height="1" class="fontarial"><a href="javascript:cmdUnShowAll()"><i>Show By Limit</i></a></td>
                                                                            </tr>
                                                                            <%
                }
            }%>                                                                                                                                                          
                                                                        </table>
                                                                    </td>
                                                                </tr>    
                                                            </table>
                                                        </form>
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
