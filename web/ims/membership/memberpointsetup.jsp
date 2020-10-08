
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>  
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.postransaction.memberpoint.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%@ include file = "../main/check.jsp" %>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privAdd = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_ADD));
            boolean privUpdate = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_UPDATE));
            boolean privDelete = true;//userSession.checkPrivilege(AppObjInfo.composeCode(appObjCode, AppObjInfo.COMMAND_DELETE));
%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long memberPointSetupId) {
        JSPList ctrlist = new JSPList();
        ctrlist.setAreaWidth("100%");
        ctrlist.setListStyle("listgen");
        ctrlist.setTitleStyle("tablehdr");
        ctrlist.setCellStyle("tablecell");
        ctrlist.setCellStyle1("tablecell1");
        ctrlist.setHeaderStyle("tablehdr");
        ctrlist.addHeader("Date", "8%");
        ctrlist.addHeader("Start Date", "8%");
        ctrlist.addHeader("End Date", "8%");
        ctrlist.addHeader("Group", "8%");
        ctrlist.addHeader("Type", "8%");
        ctrlist.addHeader("Amount Rp.", "8%");
        ctrlist.addHeader("Point", "8%");
        ctrlist.addHeader("Value per Unit Rp.", "8%");
        ctrlist.addHeader("Rounding", "8%");
        ctrlist.addHeader("Min Rouding", "8%");
        ctrlist.addHeader("User", "8%");
        ctrlist.addHeader("Last Update", "8%");
        ctrlist.addHeader("Status", "8%");

        ctrlist.setLinkRow(0);
        ctrlist.setLinkSufix("");
        Vector lstData = ctrlist.getData();
        Vector lstLinkData = ctrlist.getLinkData();
        ctrlist.setLinkPrefix("javascript:cmdEdit('");
        ctrlist.setLinkSufix("')");
        ctrlist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {

            MemberPointSetup memberPointSetup = (MemberPointSetup) objectClass.get(i);

            Vector rowx = new Vector();
            if (memberPointSetupId == memberPointSetup.getOID()) {
                index = i;
            }

            String str_dt_Date = "";
            try {
                Date dt_Date = memberPointSetup.getDate();
                if (dt_Date == null) {
                    dt_Date = new Date();
                }

                str_dt_Date = JSPFormater.formatDate(dt_Date, "dd/MM/yyyy");
            } catch (Exception e) {
                str_dt_Date = "";
            }

            rowx.add("<div align=\"center\">" + str_dt_Date + "</div>");

            String str_dt_StartDate = "";
            try {
                Date dt_StartDate = memberPointSetup.getStartDate();
                if (dt_StartDate == null) {
                    dt_StartDate = new Date();
                }

                str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd/MM/yyyy");
            } catch (Exception e) {
                str_dt_StartDate = "";
            }

            rowx.add("<div align=\"center\">" + str_dt_StartDate + "</div>");

            String str_dt_EndDate = "";
            try {
                Date dt_EndDate = memberPointSetup.getEndDate();
                if (dt_EndDate == null) {
                    dt_EndDate = new Date();
                }

                str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd/MM/yyyy");
            } catch (Exception e) {
                str_dt_EndDate = "";
            }

            rowx.add("<div align=\"center\">" + str_dt_EndDate + "</div>");

            ItemGroup ig = new ItemGroup();
            try {
                ig = DbItemGroup.fetchExc(memberPointSetup.getItemGroupId());
            } catch (Exception e) {
            }

            rowx.add((ig.getOID() == 0) ? "-" : ig.getName());

            rowx.add(I_Ccs.strCategoryType[memberPointSetup.getGroupType()]);

            rowx.add("<div align=\"right\">" + String.valueOf(memberPointSetup.getAmount()) + "</div>");

            rowx.add("<div align=\"right\">" + String.valueOf(memberPointSetup.getPoint()) + "</div>");

            rowx.add("<div align=\"right\">" + String.valueOf(memberPointSetup.getPointUnitValue()) + "</div>");

            rowx.add("<div align=\"center\">" + ((memberPointSetup.getAmountRounding() == 0) ? "Up" : "Down") + "</div>");

            rowx.add("<div align=\"right\">" + String.valueOf(memberPointSetup.getMinRouding()) + "</div>");

            User u = new User();
            try {
                u = DbUser.fetch(memberPointSetup.getUserId());
            } catch (Exception e) {
            }

            rowx.add(u.getLoginId());

            String str_dt_LastUpdateDate = "";
            try {
                Date dt_LastUpdateDate = memberPointSetup.getLastUpdateDate();
                if (dt_LastUpdateDate == null) {
                    dt_LastUpdateDate = new Date();
                }

                str_dt_LastUpdateDate = JSPFormater.formatDate(dt_LastUpdateDate, "dd/MM/yyyy");
            } catch (Exception e) {
                str_dt_LastUpdateDate = "";
            }

            rowx.add("<div align=\"center\">" + str_dt_LastUpdateDate + "</div>");

            rowx.add("<div align=\"center\">" + ((memberPointSetup.getStatus() == 0) ? "Active" : "Inactive") + "</div>");

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(memberPointSetup.getOID()));
        }

        return ctrlist.draw(index);
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidMemberPointSetup = JSPRequestValue.requestLong(request, "hidden_member_point_setup_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdMemberPointSetup ctrlMemberPointSetup = new CmdMemberPointSetup(request);
            JSPLine ctrLine = new JSPLine();
            Vector listMemberPointSetup = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlMemberPointSetup.action(iJSPCommand, oidMemberPointSetup, user.getOID());
            /* end switch*/
            JspMemberPointSetup jspMemberPointSetup = ctrlMemberPointSetup.getForm();

            /*count list All MemberPointSetup*/
            int vectSize = DbMemberPointSetup.getCount(whereClause);

            MemberPointSetup memberPointSetup = ctrlMemberPointSetup.getMemberPointSetup();
            msgString = ctrlMemberPointSetup.getMessage();

            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlMemberPointSetup.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listMemberPointSetup = DbMemberPointSetup.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listMemberPointSetup.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listMemberPointSetup = DbMemberPointSetup.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html >
    <!-- #BeginTemplate "/Templates/index.dwt" --> 
    <head>
        <!-- #BeginEditable "javascript" --> 
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Finance System</title>
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            function cmdAdd(){
                document.frmmemberpointsetup.hidden_member_point_setup_id.value="0";
                document.frmmemberpointsetup.command.value="<%=JSPCommand.ADD%>";
                document.frmmemberpointsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdAsk(oidMemberPointSetup){
                document.frmmemberpointsetup.hidden_member_point_setup_id.value=oidMemberPointSetup;
                document.frmmemberpointsetup.command.value="<%=JSPCommand.ASK%>";
                document.frmmemberpointsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdConfirmDelete(oidMemberPointSetup){
                document.frmmemberpointsetup.hidden_member_point_setup_id.value=oidMemberPointSetup;
                document.frmmemberpointsetup.command.value="<%=JSPCommand.DELETE%>";
                document.frmmemberpointsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            function cmdSave(){
                document.frmmemberpointsetup.command.value="<%=JSPCommand.SAVE%>";
                document.frmmemberpointsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdEdit(oidMemberPointSetup){
                document.frmmemberpointsetup.hidden_member_point_setup_id.value=oidMemberPointSetup;
                document.frmmemberpointsetup.command.value="<%=JSPCommand.EDIT%>";
                document.frmmemberpointsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdCancel(oidMemberPointSetup){
                document.frmmemberpointsetup.hidden_member_point_setup_id.value=oidMemberPointSetup;
                document.frmmemberpointsetup.command.value="<%=JSPCommand.EDIT%>";
                document.frmmemberpointsetup.prev_command.value="<%=prevJSPCommand%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdBack(){
                document.frmmemberpointsetup.command.value="<%=JSPCommand.BACK%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdListFirst(){
                document.frmmemberpointsetup.command.value="<%=JSPCommand.FIRST%>";
                document.frmmemberpointsetup.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdListPrev(){
                document.frmmemberpointsetup.command.value="<%=JSPCommand.PREV%>";
                document.frmmemberpointsetup.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdListNext(){
                document.frmmemberpointsetup.command.value="<%=JSPCommand.NEXT%>";
                document.frmmemberpointsetup.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
            }
            
            function cmdListLast(){
                document.frmmemberpointsetup.command.value="<%=JSPCommand.LAST%>";
                document.frmmemberpointsetup.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmmemberpointsetup.action="memberpointsetup.jsp";
                document.frmmemberpointsetup.submit();
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
                                        <td width="165" height="100%" valign="top" background="<%=approot%>/images/leftbg.gif"> 
                                            <!-- #BeginEditable "menu" --> 
                  <%@ include file="../main/menu.jsp"%>
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                        <!-- #EndEditable --> </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmmemberpointsetup" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_member_point_setup_id" value="<%=oidMemberPointSetup%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container">
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                                                                                    <tr valign="bottom"> 
                                                                                                        <td width="60%" height="23"><b><font color="#990000" class="lvl1">Master 
                                                                                                                Maintenance </font><font class="tit1">&raquo; 
                                                                                                                </font><span class="lvl2">Pencairan 
                                                                                                        Point</span></b></td>
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
                                                                                            <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            try {
                if (listMemberPointSetup.size() > 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                            <%= drawList(listMemberPointSetup, oidMemberPointSetup)%> </td>
                                                                                        </tr>
                                                                                        <%  }
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
                                                                                        <tr align="left" valign="top">
                                                                                            <td height="15" valign="middle" colspan="3">&nbsp;</td>
                                                                                        </tr>
                                                                                        <%
            if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/new2.gif',1)"><img src="../images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                                                        </tr>
                                                                                        <%}%>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top">
                                                                                <td height="8" valign="middle" colspan="3">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3"> 
                                                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (jspMemberPointSetup.errorSize() > 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="88%" class="comment" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" colspan="3"><b>Member 
                                                                                            Point Setup</b></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="21" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="21" colspan="2" width="88%" class="comment" valign="top">*)= 
                                                                                            required</td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">Date</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" disabled="true" name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_DATE] %>"  value="<%= (memberPointSetup.getOID() == 0) ? JSPFormater.formatDate(new Date(), "dd/MM/yyyy") : JSPFormater.formatDate(memberPointSetup.getDate(), "dd/MM/yyyy") %>" class="readonly">
                                                                                        <tr align="left">
                                                                                        <td height="21" width="12%">Item Group</td> 
                                                                                        <td height="21" colspan="2" width="88%">
                                                                                        <%
    Vector tempg = DbItemGroup.list(0, 0, "", "name");
    Vector itemgroupid_valuex = new Vector(1, 1);
    Vector itemgroupid_keyx = new Vector(1, 1);
    String sel_itemgroupidx = "" + memberPointSetup.getItemGroupId();

    itemgroupid_keyx.add("0");
    itemgroupid_valuex.add("");

    if (tempg != null && tempg.size() > 0) {
        for (int i = 0; i < tempg.size(); i++) {
            ItemGroup ig = (ItemGroup) tempg.get(i);
            itemgroupid_keyx.add("" + ig.getOID());
            itemgroupid_valuex.add("" + ig.getName());
        }
    }

                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_ITEM_GROUP_ID], null, sel_itemgroupidx, itemgroupid_keyx, itemgroupid_valuex, "", "formElemen") %> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">Group Type</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <%
    // Vector tempg = DbItemGroup.list(0,0, "", "name");
%>
                                                                                        <% Vector itemgroupid_value = new Vector(1, 1);
    Vector itemgroupid_key = new Vector(1, 1);
    String sel_itemgroupid = "" + memberPointSetup.getGroupType();//.getItemGroupId();

    //if(tempg!=null && tempg.size()>0){
    for (int i = 0; i < I_Ccs.strCategoryType.length; i++) {//tempg.size(); i++){
        //ItemGroup ig = (ItemGroup)tempg.get(i);					  		
        itemgroupid_key.add("" + i);//ig.getOID());
        itemgroupid_value.add("" + I_Ccs.strCategoryType[i]);//ig.getName());
    }
    //}

                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_GROUP_TYPE], null, sel_itemgroupid, itemgroupid_key, itemgroupid_value, "", "formElemen") %> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">Amount Rp.</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_AMOUNT] %>"  value="<%= memberPointSetup.getAmount() %>" class="formElemen">
                                                                                        * <%= jspMemberPointSetup.getErrorMsg(JspMemberPointSetup.JSP_FIELD_AMOUNT) %> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">Point</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_POINT] %>"  value="<%= memberPointSetup.getPoint() %>" class="formElemen">
                                                                                        * <%= jspMemberPointSetup.getErrorMsg(JspMemberPointSetup.JSP_FIELD_POINT) %> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">Value per 
                                                                                        Unit Rp.</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_POINT_UNIT_VALUE] %>"  value="<%= memberPointSetup.getPointUnitValue() %>" class="formElemen">
                                                                                        / point 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">Start Date</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_START_DATE]%>" value="<%=JSPFormater.formatDate((memberPointSetup.getStartDate() == null) ? new Date() : memberPointSetup.getStartDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmemberpointsetup.<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">End Date</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_END_DATE]%>" value="<%=JSPFormater.formatDate((memberPointSetup.getEndDate() == null) ? new Date() : memberPointSetup.getEndDate(), "dd/MM/yyyy")%>" size="11" readonly>
                                                                                        <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmemberpointsetup.<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%"> Rounding 
                                                                                        Type</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <select name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_AMOUNT_ROUNDING] %>">
                                                                                            <option value="0" <%if (memberPointSetup.getAmountRounding() == 0) {%>selected<%}%>>Up</option>
                                                                                            <option value="1" <%if (memberPointSetup.getAmountRounding() == 1) {%>selected<%}%>>Down</option>
                                                                                        </select>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">Min Rouding</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_MIN_ROUDING] %>"  value="<%= memberPointSetup.getMinRouding() %>" class="formElemen">
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="12%">Status</td>
                                                                                            <td height="8" colspan="2" width="88%" valign="top"> 
                                                                                                <select name="<%=jspMemberPointSetup.colNames[JspMemberPointSetup.JSP_FIELD_STATUS] %>">
                                                                                                    <option value="0" <%if (memberPointSetup.getStatus() == 0) {%>selected<%}%>>Active</option>
                                                                                                    <option value="1" <%if (memberPointSetup.getStatus() == 1) {%>selected<%}%>>Inactive</option>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="88%" valign="top">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" class="command" valign="top"> 
                                                                                                <%
    ctrLine.setLocationImg(approot + "/images/ctr_line");
    ctrLine.initDefault();
    ctrLine.setTableWidth("80%");
    String scomDel = "javascript:cmdAsk('" + oidMemberPointSetup + "')";
    String sconDelCom = "javascript:cmdConfirmDelete('" + oidMemberPointSetup + "')";
    String scancel = "javascript:cmdEdit('" + oidMemberPointSetup + "')";
    ctrLine.setBackCaption("Back to List");
    ctrLine.setJSPCommandStyle("buttonlink");
    ctrLine.setDeleteCaption("Delete");
    ctrLine.setSaveCaption("Save");
    ctrLine.setAddCaption("");

    ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
    ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

    //ctrLine.setOnMouseOut("MM_swapImgRestore()");
    ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + approot + "/images/cancel2.gif',1)");
    ctrLine.setBackImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + approot + "/images/delete2.gif',1)");
    ctrLine.setDeleteImage("<img src=\"" + approot + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

    ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + approot + "/images/cancel2.gif',1)");
    ctrLine.setEditImage("<img src=\"" + approot + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


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
                                                                                                %>
                                                                                            <%= ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%> </td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td width="12%">&nbsp;</td>
                                                                                            <td width="88%">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" valign="top"> 
                                                                                                <div align="left"></div>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                    <%}%>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            
                                                        </form>
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
