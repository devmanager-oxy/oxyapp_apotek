
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ccs.postransaction.repack.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>  
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_REPACK, AppMenu.PRIV_PRINT);
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, int start) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablearialhdr");
        cmdist.setCellStyle("tablearialcell");
        cmdist.setCellStyle1("tablearialcell1");
        cmdist.setHeaderStyle("tablearialhdr");
        cmdist.addHeader("No", "25");
        cmdist.addHeader("Number", "10%");
        cmdist.addHeader("Date", "10%");
        cmdist.addHeader("Location", "20%");
        cmdist.addHeader("Status", "10%");
        cmdist.addHeader("Notes", "");

        cmdist.setLinkRow(1);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Repack repack = (Repack) objectClass.get(i);
            Vector rowx = new Vector();

            int cnt = DbRepackItem.getCount("repack_id=" + repack.getOID() + " and type=1");

            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add(repack.getNumber());
            if (repack.getDate() == null) {
                rowx.add("");
            } else {
                rowx.add("<div align=\"center\">" + JSPFormater.formatDate(repack.getDate(), "dd-MMM-yyyy") + "</div>");
            }

            Location location = new Location();
            try {
                location = DbLocation.fetchExc(repack.getLocationId());
            } catch (Exception e) {
            }
            rowx.add("" + location.getName());
            rowx.add("<div align=\"center\">" + repack.getStatus() + "</div>");

            rowx.add(repack.getNote());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(repack.getOID()) + "','" + cnt);
        }

        return cmdist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidRepack = JSPRequestValue.requestLong(request, "hidden_repack_id");
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            String srcNumber = JSPRequestValue.requestString(request, "src_number");
            int srcIgnore = JSPRequestValue.requestInt(request, "src_ignore");
            Date srcStartDate = new Date();
            Date srcEndDate = new Date();
            if (iJSPCommand == JSPCommand.NONE) {
                srcIgnore = 1;
            }
            if (srcIgnore == 0) {
                srcStartDate = JSPFormater.formatDate(srcStart, "dd/MM/yyyy");
                srcEndDate = JSPFormater.formatDate(srcEnd, "dd/MM/yyyy");
            }

            /*variable declaration*/
            int recordToGet = 20;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";
            Vector vloc = userLocations;

            if (iJSPCommand == JSPCommand.NONE) {                
                if (vloc != null && vloc.size() > 0) {                    
                    if (vloc.size() != totLocationxAll) {
                        Location l = (Location) vloc.get(0);
                        whereClause = DbRepack.colNames[DbRepack.COL_LOCATION_ID] + " = " + l.getOID();
                    }
                }
            } else {
                if(srcLocationId != 0){
                    whereClause = DbRepack.colNames[DbRepack.COL_LOCATION_ID] + "=" + srcLocationId;
                }
            }

            if (srcStatus != null && srcStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbRepack.colNames[DbRepack.COL_STATUS] + "='" + srcStatus + "'";
                } else {
                    whereClause = DbRepack.colNames[DbRepack.COL_STATUS] + "='" + srcStatus + "'";
                }
            }
            if (srcNumber != null && srcNumber.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbRepack.colNames[DbRepack.COL_NUMBER] + " like '%" + srcNumber + "%'";
                } else {
                    whereClause = DbRepack.colNames[DbRepack.COL_NUMBER] + " like '%" + srcNumber + "%'";
                }
            }
            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbRepack.colNames[DbRepack.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbRepack.colNames[DbRepack.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = "(to_days(" + DbRepack.colNames[DbRepack.COL_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbRepack.colNames[DbRepack.COL_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            CmdRepack cmdRepack = new CmdRepack(request);
            JSPLine ctrLine = new JSPLine();
            Vector listRepack = new Vector(1, 1);

            /*count list All Transfer*/
            int vectSize = 0;
            if (vloc != null && vloc.size() > 0) {

                vectSize = DbRepack.getCount(whereClause);

                if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                        (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                    start = cmdRepack.actionList(iJSPCommand, start, vectSize, recordToGet);
                }

                orderClause = DbRepack.colNames[DbRepack.COL_DATE] + " desc," + DbRepack.colNames[DbRepack.COL_NUMBER] + " desc";
                listRepack = DbRepack.list(start, recordToGet, whereClause, orderClause);

                /*handle condition if size of record to display = 0 and start > 0 	after delete*/
                if (listRepack.size() < 1 && start > 0) {
                    if (vectSize - recordToGet > recordToGet) {
                        start = start - recordToGet;
                    } //go to JSPCommand.PREV
                    else {
                        start = 0;
                        iJSPCommand = JSPCommand.FIRST;
                        prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                    }
                    listRepack = DbRepack.list(start, recordToGet, whereClause, orderClause);
                }
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=titleIS%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            <!--
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmrepack.command.value="<%=JSPCommand.LIST%>";
                document.frmrepack.action="repacklist.jsp";
                document.frmrepack.submit();
            }
            
            function cmdEdit(oid,cnt){
                document.frmrepack.hidden_repack_id.value=oid;
                document.frmrepack.command.value="<%=JSPCommand.EDIT%>";
                document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                if(parseInt(cnt)>1){ 
                    document.frmrepack.action="repackitemmulty.jsp";
                }
                else{
                    document.frmrepack.action="repackitem.jsp";
                }
                document.frmrepack.submit();
            }
            
            function cmdAdd(){
                document.frmrepack.hidden_repack_id.value="0";
                document.frmrepack.command.value="<%=JSPCommand.ADD%>";
                document.frmrepack.prev_command.value="<%=prevJSPCommand%>";
                document.frmrepack.action="repackitem.jsp";
                document.frmrepack.submit();
            }
            
            function cmdListFirst(){
                document.frmrepack.command.value="<%=JSPCommand.FIRST%>";
                document.frmrepack.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmrepack.action="repacklist.jsp";
                document.frmrepack.submit();
            }
            
            function cmdListPrev(){
                document.frmrepack.command.value="<%=JSPCommand.PREV%>";
                document.frmrepack.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmrepack.action="repacklist.jsp";
                document.frmrepack.submit();
            }
            
            function cmdListNext(){
                document.frmrepack.command.value="<%=JSPCommand.NEXT%>";
                document.frmrepack.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmrepack.action="repacklist.jsp";
                document.frmrepack.submit();
            }
            
            function cmdListLast(){
                document.frmrepack.command.value="<%=JSPCommand.LAST%>";
                document.frmrepack.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmrepack.action="repacklist.jsp";
                document.frmrepack.submit();
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmrepack" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_repack_id" value="<%=oidRepack%>">                                                                                                                        
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">Transaction 
                                                                                        </font><font class="tit1">&raquo; <span class="lvl2">Repack list
                                                                                </span></font></b></td>
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
                                                                    <td valign="top" class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="5"  colspan="3"></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                        <tr > 
                                                                                            <td class="tab" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;Records&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td class="tabin" nowrap> 
                                                                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdAdd()" class="tablink">Repack Item</a>&nbsp;&nbsp;</div>
                                                                                            </td>
                                                                                            <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                            <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3" > 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="2"><b><i>Search Parameters 
                                                                                                        :</i></b></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">Location</td>
                                                                                                        <td width="90%"> 
                                                                                                            <select name="src_location_id">
                                                                                                                <%if (vloc.size() == totLocationxAll) {%>
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>- All -</option>
                                                                                                                <%
            }



            if (vloc != null && vloc.size() > 0) {
                for (int i = 0; i < vloc.size(); i++) {
                    Location loc = (Location) vloc.get(i);
                    String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=loc.getOID()%>" <%if (srcLocationId == loc.getOID()) {%>selected<%}%>><%=loc.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr>
                                                                                                        <td width="10%">Number</td>
                                                                                                        <td width="90%">
                                                                                                            <input type="text" name="src_number" value="<%=srcNumber%>">
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">Document Status</td>
                                                                                                        <td width="90%"> 
                                                                                                            <select name="src_status">
                                                                                                                <option value="" >- All -</option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_POSTED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_POSTED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_POSTED%></option>
                                                                                                                <option value="CANCELED" <%if (srcStatus.equals("CANCELED")) {%>selected<%}%>>CANCELED</option>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">Date</td>
                                                                                                        <td width="90%"> 
                                                                                                        <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrepack.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        &nbsp;&nbsp;and&nbsp;&nbsp; 
                                                                                                        <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrepack.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        <input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>>
                                                                                                               Ignored</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="2" height="2"> 
                                                                                                            <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                                <tr > 
                                                                                                                    <td height="3" background="../images/line1.gif" ></td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        <td width="90%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%">&nbsp;</td>
                                                                                                        <td width="90%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listRepack.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(listRepack, start)%> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%  } else {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="fontarial"><font color="FF0000"><i>Data is not available for this location</i></font></td>
                                                                                        </tr>
                                                                                        <%
                }
            } catch (Exception exc) {
                System.out.println("sdsdf : " + exc.toString());
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
                                                                                <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
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
