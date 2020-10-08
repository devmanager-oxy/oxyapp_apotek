
<%-- 
    Document   : ga_archives.jsp
    Created on : May 24, 2015, 5:20:28 AM
    Author     : Roy
--%>

<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.postransaction.ga.*" %>
<%@ page import = "com.project.ccs.postransaction.stock.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.ccs.report.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA, AppMenu.PRIV_PRINT);

            boolean privApproved = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA_APPROVED);
            boolean privViewApproved = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_STOCK_MANAGEMENT, AppMenu.M2_GA_APPROVED, AppMenu.PRIV_VIEW);
%>

<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, int start) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        cmdist.setCellStyle1("tablecell1");
        cmdist.setHeaderStyle("tablehdr");
        cmdist.addHeader("No", "5%");
        cmdist.addHeader("Number", "8%");
        cmdist.addHeader("Date", "8%");
        cmdist.addHeader("Location", "16%");
        cmdist.addHeader("Status", "7%");
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
            GeneralAffair generalAffair = (GeneralAffair) objectClass.get(i);
            Vector rowx = new Vector();

            rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
            rowx.add("<div align=\"center\">" + generalAffair.getNumber() + "</div>");

            if (generalAffair.getDate() == null) {
                rowx.add("");
            } else {
                rowx.add("<div align=\"center\">" + JSPFormater.formatDate(generalAffair.getTransactionDate(), "dd MMM yyyy") + "</div>");
            }

            Location location = new Location();
            try {
                location = DbLocation.fetchExc(generalAffair.getLocationId());
            } catch (Exception e) {
            }
            rowx.add("" + location.getName());
            rowx.add("<div align=\"center\">" + generalAffair.getStatus() + "</div>");
            rowx.add(generalAffair.getNote());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(generalAffair.getOID()));
        }

        return cmdist.draw(index);
    }

%>

<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidTransfer = JSPRequestValue.requestLong(request, "hidden_general_affair_id");            
            long srcLocationId = JSPRequestValue.requestLong(request, "src_location_id");
            long srcCostLocationId = JSPRequestValue.requestLong(request, "src_cost_location_id");
            String srcStatus = JSPRequestValue.requestString(request, "src_status");
            String srcStart = JSPRequestValue.requestString(request, "src_start_date");
            String srcEnd = JSPRequestValue.requestString(request, "src_end_date");
            String number = JSPRequestValue.requestString(request, "number");
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
            int recordToGet = 30;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            if (srcLocationId != 0) {
                whereClause = DbGeneralAffair.colNames[DbGeneralAffair.COL_LOCATION_ID] + "=" + srcLocationId;
            }

            if (srcCostLocationId != 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbGeneralAffair.colNames[DbGeneralAffair.COL_LOCATION_POST_ID] + "= " + srcCostLocationId;
                } else {
                    whereClause = DbGeneralAffair.colNames[DbGeneralAffair.COL_LOCATION_POST_ID] + "= " + srcCostLocationId;
                }
            }

            if (number != null && number.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbGeneralAffair.colNames[DbGeneralAffair.COL_NUMBER] + " like '" + number + "'";
                } else {
                    whereClause = DbGeneralAffair.colNames[DbGeneralAffair.COL_NUMBER] + " like '" + number + "'";
                }
            }

            if (srcStatus != null && srcStatus.length() > 0) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and " + DbGeneralAffair.colNames[DbGeneralAffair.COL_STATUS] + "='" + srcStatus + "'";
                } else {
                    whereClause = DbGeneralAffair.colNames[DbGeneralAffair.COL_STATUS] + "='" + srcStatus + "'";
                }
            }
            if (srcIgnore == 0 && iJSPCommand != JSPCommand.NONE) {
                if (whereClause.length() > 0) {
                    whereClause = whereClause + " and (to_days(" + DbGeneralAffair.colNames[DbGeneralAffair.COL_TRANSACTION_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbGeneralAffair.colNames[DbGeneralAffair.COL_TRANSACTION_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                } else {
                    whereClause = "(to_days(" + DbGeneralAffair.colNames[DbGeneralAffair.COL_TRANSACTION_DATE] + ")>=to_days('" + JSPFormater.formatDate(srcStartDate, "yyyy-MM-dd") + "')" +
                            " and to_days(" + DbGeneralAffair.colNames[DbGeneralAffair.COL_TRANSACTION_DATE] + ")<=to_days('" + JSPFormater.formatDate(srcEndDate, "yyyy-MM-dd") + "'))";
                }
            }

            CmdGeneralAffair cmdGeneralAffair = new CmdGeneralAffair(request);
            JSPLine ctrLine = new JSPLine();
            Vector listGeneralAffair = new Vector(1, 1);
            JspGeneralAffair jspGeneralAffair = cmdGeneralAffair.getForm();

            /*count list All Transfer*/
            int vectSize = DbGeneralAffair.getCount(whereClause);
            msgString = cmdGeneralAffair.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdGeneralAffair.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            orderClause = DbGeneralAffair.colNames[DbGeneralAffair.COL_TRANSACTION_DATE];
            listGeneralAffair = DbGeneralAffair.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listGeneralAffair.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listGeneralAffair = DbGeneralAffair.list(start, recordToGet, whereClause, orderClause);
            }

            Vector locations = DbLocation.list(0, 0, "", DbLocation.colNames[DbLocation.COL_NAME]);
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
            
            <%if ((!priv || !privView) && (!privApproved || !privViewApproved)){%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdSearch(){
                document.frmga.command.value="<%=JSPCommand.LIST%>";
                document.frmga.action="ga_archives.jsp";
                document.frmga.submit();
            }
            
            
            function cmdEdit(oid){
                document.frmga.hidden_general_affair_id.value=oid;
                document.frmga.command.value="<%=JSPCommand.EDIT%>";
                document.frmga.prev_command.value="<%=prevJSPCommand%>";
                document.frmga.action="ga_item.jsp";
                document.frmga.submit();
            }
            
            function cmdAdd(){
                document.frmga.hidden_general_affair_id.value="0";
                document.frmga.command.value="<%=JSPCommand.ADD%>";
                document.frmga.prev_command.value="<%=prevJSPCommand%>";
                document.frmga.action="ga_item.jsp";
                document.frmga.submit();
            }
            
            function cmdListFirst(){
                document.frmga.command.value="<%=JSPCommand.FIRST%>";
                document.frmga.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmga.action="ga_archives.jsp";
                document.frmga.submit();
            }
            
            function cmdListPrev(){
                document.frmga.command.value="<%=JSPCommand.PREV%>";
                document.frmga.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmga.action="ga_archives.jsp";
                document.frmga.submit();
            }
            
            function cmdListNext(){
                document.frmga.command.value="<%=JSPCommand.NEXT%>";
                document.frmga.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmga.action="ga_archives.jsp";
                document.frmga.submit();
            }
            
            function cmdListLast(){
                document.frmga.command.value="<%=JSPCommand.LAST%>";
                document.frmga.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmga.action="ga_archives.jsp";
                document.frmga.submit();
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
                                                        <form name="frmga" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_general_affair_id" value="<%=oidTransfer%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td valign="top"> 
                                                                        <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                            <tr valign="bottom"> 
                                                                                <td width="60%" height="23"><b><font color="#990000" class="lvl1">General Affair 
                                                                                </font><font class="tit1">&raquo; <span class="lvl2">Archives</span></font></b></td>
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
                                                                                <td height="8"  colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="2" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td colspan="2" class="fontarial"><b><i>Search Parameters :</i></b></td>                                                                                                        
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td width="10%" class="tablearialcell1">&nbsp;Number</td>
                                                                                                        <td width="90%">
                                                                                                        <input type="text" name="number" value="<%=number%>" size="25" class="fontarial"></td>
                                                                                                    </tr>
                                                                                                    <%
            Vector vloc = userLocations;
                                                                                                    %>
                                                                                                    <tr height="22"> 
                                                                                                        <td width="10%" class="tablearialcell1">&nbsp;Location</td>
                                                                                                        <td width="90%">
                                                                                                            <select name="src_location_id" class="fontarial">
                                                                                                                <%if (vloc.size() == totLocationxAll) {%>
                                                                                                                <option value="0" <%if (srcLocationId == 0) {%>selected<%}%>>- All Location-</option>
                                                                                                                <%}%>
                                                                                                                <%



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
                                                                                                    <tr height="22"> 
                                                                                                        <td width="10%" class="tablearialcell1">&nbsp;Document Status</td>
                                                                                                        <td width="90%">
                                                                                                            <select name="src_status" class="fontarial">
                                                                                                                <option value="" >- ALL STATUS -</option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_DRAFT%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_DRAFT)) {%>selected<%}%>><%=I_Project.DOC_STATUS_DRAFT%></option>
                                                                                                                <option value="<%=I_Project.DOC_STATUS_APPROVED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_APPROVED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_APPROVED%></option>
                                                                                                                <option value="<%=I_Project.STATUS_DOC_POSTED%>" <%if (srcStatus.equals(I_Project.DOC_STATUS_POSTED)) {%>selected<%}%>><%=I_Project.DOC_STATUS_POSTED%></option>                                                                                                                
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td width="10%" class="tablearialcell1">&nbsp;Period</td>
                                                                                                        <td width="90%">
                                                                                                            <table border="0" cellspacing="0" cellpadding="0">
                                                                                                                <tr> 
                                                                                                                    <td> 
                                                                                                                        <input name="src_start_date" value="<%=JSPFormater.formatDate((srcStartDate == null) ? new Date() : srcStartDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmga.src_start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td class="fontarial">&nbsp;&nbsp;and&nbsp;&nbsp;</td>
                                                                                                                    <td> 
                                                                                                                        <input name="src_end_date" value="<%=JSPFormater.formatDate((srcEndDate == null) ? new Date() : srcEndDate, "dd/MM/yyyy")%>" size="11" readonly>
                                                                                                                    </td>
                                                                                                                    <td> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmga.src_end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                                    </td>
                                                                                                                    <td>
                                                                                                                    <input type="checkbox" name="src_ignore" value="1" <%if (srcIgnore == 1) {%>checked<%}%>>
                                                                                                                           </td>
                                                                                                                    <td class="fontarial">Ignored</td>
                                                                                                                </tr>
                                                                                                            </table>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr height="22"> 
                                                                                                        <td width="10%" class="tablearialcell1">&nbsp;Cost Location</td>
                                                                                                        <td width="90%">
                                                                                                            <select name="src_cost_location_id" class="fontarial">  
                                                                                                                <option value="0" <%if (srcCostLocationId == 0) {%>selected<%}%>>- All Location -</option>
                                                                                                                
                                                                                                                <%

            if (locations != null && locations.size() > 0) {
                for (int i = 0; i < locations.size(); i++) {
                    Location loc = (Location) locations.get(i);
                    String str = "";
                                                                                                                %>
                                                                                                                <option value="<%=loc.getOID()%>" <%if (srcCostLocationId == loc.getOID()) {%>selected<%}%>><%=loc.getName()%></option>
                                                                                                                <%}
            }%>
                                                                                                            </select>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td colspan="2" height="5"></td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="10%"><a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('sr21','','../images/search2.gif',1)"><img src="../images/search.gif" name="sr21" border="0"></a></td>
                                                                                                        <td width="90%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr height="25"> 
                                                                                                        <td width="10%">&nbsp;</td>
                                                                                                        <td width="90%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listGeneralAffair.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td class="boxed1" height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(listGeneralAffair, start)%> </td>
                                                                                        </tr>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" align="left" colspan="3" class="command">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%  }
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

            ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + approot + "/images/first.gif\" alt=\"First\">");
            ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + approot + "/images/prev.gif\" alt=\"Prev\">");
            ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + approot + "/images/next.gif\" alt=\"Next\">");
            ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + approot + "/images/last.gif\" alt=\"Last\">");

            ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + approot + "/images/first2.gif',1)");
            ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + approot + "/images/prev2.gif',1)");
            ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + approot + "/images/next2.gif',1)");
            ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + approot + "/images/last2.gif',1)");
                                                                                                    %>
                                                                                            <%=ctrLine.drawImageListLimit(cmd, vectSize, start, recordToGet)%> </span> </td>
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
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3">&nbsp; </td>
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

