
<%-- 
    Document   : adjusmentarchive
    Created on : Apr 9, 2012, 1:47:57 PM
    Author     : Roy Andika
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.ccs.postransaction.adjusment.*" %>
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
    public String drawList(Vector objectClass, int start, String langAR[]) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablearialhdr");
        cmdist.setCellStyle("tablearialcell");
        cmdist.setCellStyle1("tablearialcell1");
        cmdist.setHeaderStyle("tablearialhdr");

        cmdist.addHeader("No", "5%");
        cmdist.addHeader("" + langAR[5], "10%");
        cmdist.addHeader("" + langAR[2], "10%");
        cmdist.addHeader("" + langAR[0], "10%");
        cmdist.addHeader("" + langAR[1], "10%");
        cmdist.addHeader("" + langAR[6], "40%");

        cmdist.setLinkRow(1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Adjusment adjusment = (Adjusment) objectClass.get(i);
            Vector rowx = new Vector();

            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add("<div align=\"center\">" + adjusment.getNumber() + "</div>");

            if (adjusment.getDate() == null) {
                rowx.add("");
            } else {
                rowx.add("<div align=\"center\">" + JSPFormater.formatDate(adjusment.getDate(), "dd-MMM-yyyy") + "</div>");
            }

            Location location = new Location();
            try {
                location = DbLocation.fetchExc(adjusment.getLocationId());
            } catch (Exception e) {
            }

            rowx.add("" + location.getName());
            if (adjusment.getStatus().equals(I_Project.DOC_STATUS_POSTED)) {
                rowx.add("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr height=\"20\"><td bgcolor=\"72D5BF\" align=\"center\" ><font face=\"arial\" >" + adjusment.getStatus() + "</font><td></tr></table>");
            } else {
                rowx.add("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr height=\"20\"><td bgcolor=\"D4543A\" align=\"center\"><font face=\"arial\" >" + adjusment.getStatus() + "</font><td></tr></table>");
            }
            rowx.add(adjusment.getNote());
            lstData.add(rowx);
            lstLinkData.add(String.valueOf(adjusment.getOID()));
        }

        return cmdist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidAdjusment = JSPRequestValue.requestLong(request, "hidden_adjusment_id");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            
            String number = JSPRequestValue.requestString(request, "txtnumber");
            String memo = JSPRequestValue.requestString(request, "txtmemo");
            
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();

            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
                srcStatus = "";
            }

            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = DbAdjusment.colNames[DbAdjusment.COL_DATE];

            if (srcLocationId != 0) {
                whereClause = DbAdjusment.colNames[DbAdjusment.COL_LOCATION_ID] + "=" + srcLocationId;
            }

            if (srcStatus != null && srcStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbAdjusment.colNames[DbAdjusment.COL_STATUS] + "='" + srcStatus + "'";
                } else {
                    whereClause = DbAdjusment.colNames[DbAdjusment.COL_STATUS] + "='" + srcStatus + "'";
                }
            }

            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbAdjusment.colNames[DbAdjusment.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbAdjusment.colNames[DbAdjusment.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = "(to_days(" + DbAdjusment.colNames[DbAdjusment.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbAdjusment.colNames[DbAdjusment.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            
            if(number != null && number.length() > 0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbAdjusment.colNames[DbAdjusment.COL_NUMBER] + " like '%" + number + "%'";
            }
            
            
            if(memo != null && memo.length() > 0){
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and ";
                }
                whereClause = whereClause + DbAdjusment.colNames[DbAdjusment.COL_NOTE] + " like '%" + memo + "%'";
            }
            
            CmdAdjusment cmdAdjusment = new CmdAdjusment(request);
            JSPLine ctrLine = new JSPLine();
            Vector listAdjusment = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdAdjusment.action(iJSPCommand, oidAdjusment);
            /* end switch*/
            /*count list All Adjusment*/
            int vectSize = DbAdjusment.getCount(whereClause);

            msgString = cmdAdjusment.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdAdjusment.actionList(iJSPCommand, start, vectSize, recordToGet);
            }


            listAdjusment = DbAdjusment.list(start, recordToGet, whereClause, orderClause);

            if (listAdjusment.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listAdjusment = DbAdjusment.list(start, recordToGet, whereClause, orderClause);
            }

            String[] langAR = {"Location", "Document Status", "Date", "Ignored", "To", "Transaction Nomor", "Notes"};
            String[] langNav = {"Journal", "Adjusment - Archive", "Records", "Adjusment Stock", "Search Parameters","Data not found"};

            if (lang == LANG_ID) {
                String[] langID = {"Lokasi", "Status Dokumen", "Tanggal", "Abaikan", "Sampai", "Nomor Transaksi", "Memo"};
                langAR = langID;

                String[] navID = {"Jurnal", "Adjusment - Arsip", "Arsip", "Penyesuaian Stock", "Parameter Pencarian","Data tidak ditemukan"};
                langNav = navID;
            }

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../highslide/highslide-with-html.js"></script>
        <link rel="stylesheet" type="text/css" href="../highslide/highslide.css" />
        <script language="JavaScript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmadjusment.command.value="<%=JSPCommand.LIST%>";
                document.frmadjusment.action="adjusmentarchive.jsp";
                document.frmadjusment.submit();
            }
            
            function cmdEdit(oid){
                document.frmadjusment.hidden_adjusment_id.value=oid;
                document.frmadjusment.command.value="<%=JSPCommand.EDIT%>";
                document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
                document.frmadjusment.action="adjarchivedetail.jsp";
                document.frmadjusment.submit();
            }
            
            function cmdAdd(){
                document.frmadjusment.hidden_adjusment_id.value="0";
                document.frmadjusment.command.value="<%=JSPCommand.ADD%>";
                document.frmadjusment.prev_command.value="<%=prevJSPCommand%>";
                document.frmadjusment.action="adjarchivedetail.jsp";
                document.frmadjusment.submit();
            }
            
            function cmdListFirst(){
                document.frmadjusment.command.value="<%=JSPCommand.FIRST%>";
                document.frmadjusment.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmadjusment.action="adjusmentarchive.jsp";
                document.frmadjusment.submit();
            }
            
            function cmdListPrev(){
                document.frmadjusment.command.value="<%=JSPCommand.PREV%>";
                document.frmadjusment.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmadjusment.action="adjusmentarchive.jsp";
                document.frmadjusment.submit();
            }
            
            function cmdListNext(){
                document.frmadjusment.command.value="<%=JSPCommand.NEXT%>";
                document.frmadjusment.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmadjusment.action="adjusmentarchive.jsp";
                document.frmadjusment.submit();
            }
            
            function cmdListLast(){
                document.frmadjusment.command.value="<%=JSPCommand.LAST%>";
                document.frmadjusment.prev_command.value="<%=JSPCommand.LAST%>";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/search2.gif','../images/new2.gif')">
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
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_adjusment_id" value="<%=oidAdjusment%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                                       
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table border="0" cellpadding="1" cellspacing="1" width="800">                                                                                                                                        
                                                                                                    <tr>                                                                                                                                            
                                                                                                        <td class="tablecell1" >
                                                                                                            <table width="100%" border="0" style="border:1px solid #ABA8A8" cellspacing="2" cellpadding="1">
                                                                                                                <tr>
                                                                                                                    <td colspan="5" height="5"></td>
                                                                                                                </tr>
                                                                                                                <tr>
                                                                                                                    <td width="5"></td>
                                                                                                                    <td  class="fontarial" colspan="4"><b><i><%=langNav[4]%>:</i></b></td>
                                                                                                                </tr>                                                                                                                
                                                                                                                <tr> 
                                                                                                                    <td width="5"></td>
                                                                                                                    <td width="100" class="fontarial"><%=langAR[0]%></td>
                                                                                                                    <td > 
                                                                                                                        <select name="src_location_id">
                                                                                                                            <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>All Location...</option>
                                                                                                                            <%

            Vector locations = DbLocation.list(0, 0, "", "name");

            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location d = (Location) locations.get(i);
                    String str = "";
                                                                                                                            %>
                                                                                                                            <option value="<%=d.getOID()%>" <%if (srcLocationId == d.getOID()) {%>selected<%}%>><%=d.getName()%></option>
                                                                                                                            <%}
            }%>
                                                                                                                        </select>
                                                                                                                    </td>
                                                                                                                    <td class="fontarial" align="right"><%=langAR[2]%></td>
                                                                                                                    <td >
                                                                                                                       <table border = "0" cellpadding="0" cellspacing="0">
                                                                                                                            <tr>
                                                                                                                                <td><input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly></td>
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> </td>    
                                                                                                                                <td class="fontarial">&nbsp;&nbsp;<%=langAR[4]%>&nbsp;&nbsp;</td>    
                                                                                                                                <td><input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly></td>    
                                                                                                                                <td><a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmadjusment.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> </td>     
                                                                                                                                <td><input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>></td>    
                                                                                                                                <td class="fontarial"><%=langAR[3]%></td>    
                                                                                                                            </tr>   
                                                                                                                        </table>  
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5"></td>
                                                                                                                    <td class="fontarial"><%=langAR[5]%></td>
                                                                                                                    <td ><input type="text" name="txtnumber" value="<%=number%>" size="25"></td>
                                                                                                                    <td class="fontarial" align="right"><%=langAR[1]%></td>
                                                                                                                    <td >
                                                                                                                        <select name="src_status">
                                                                                                                            <option value="" <%if (srcStatus.equals("")) {%>selected<%}%>>All Status...</option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                            <option value="<%=I_Project.DOC_STATUS_POSTED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_POSTED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_POSTED%></option>
                                                                                                                    </select>
                                                                                                                    </td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td width="5"></td>
                                                                                                                    <td class="fontarial"><%=langAR[6]%></td>
                                                                                                                    <td colspan="3"><input type="text" name="txtmemo" value="<%=memo%>" size="25"></td>
                                                                                                                </tr>
                                                                                                                <tr> 
                                                                                                                    <td colspan="5" height="10"></td>
                                                                                                                </tr>                                                                                                                
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top">
                                                                                            <td>
                                                                                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top" height="25">
                                                                                            <td>&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listAdjusment != null && listAdjusment.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(listAdjusment, start, langAR)%> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td colspan="3">
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
                                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span>
                                                                                                
                                                                                            </td>
                                                                                        </tr>
                                                                                        <% } else {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><i><%=langNav[5]%>...</i></td>
                                                                                        </tr>
                                                                                        <%}
            } catch (Exception exc) {
                System.out.println("sdsdf : " + exc.toString());
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>                                                                                       
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        <span class="level2"><br>
                                                        </span><!-- #EndEditable -->
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
