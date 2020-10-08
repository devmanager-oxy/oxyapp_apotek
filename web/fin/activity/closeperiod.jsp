
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MENU_MASTER, AppMenu.M2_MENU_WORKPLAN, AppMenu.PRIV_DELETE);
%>   
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspActivityPeriod frmObject, ActivityPeriod objEntity, Vector objectClass, long activityPeriodId, String approot) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");

        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");        
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("Name", "25%");
        cmdist.addHeader("Start Date", "25%");
        cmdist.addHeader("End Date", "25%");
        cmdist.addHeader("Status", "25%");

        cmdist.setLinkRow(0);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        Vector rowx = new Vector(1, 1);
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            ActivityPeriod activityPeriod = (ActivityPeriod) objectClass.get(i);
            rowx = new Vector();
            if (activityPeriodId == activityPeriod.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {

                rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspActivityPeriod.JSP_NAME] + "\" value=\"" + activityPeriod.getName() + "\" class=\"formElemen\">");
                //rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_START_DATE] +"\" value=\""+activityPeriod.getStartDate()+"\" class=\"formElemen\">");
                rowx.add(getDates(activityPeriod.getStartDate(), "frmactivityperiod", frmObject.colNames[JspActivityPeriod.JSP_START_DATE], approot));
                //rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_END_DATE] +"\" value=\""+activityPeriod.getEndDate()+"\" class=\"formElemen\">");
                rowx.add(getDates(activityPeriod.getEndDate(), "frmactivityperiod", frmObject.colNames[JspActivityPeriod.JSP_END_DATE], approot));
                //rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_STATUS] +"\" value=\""+activityPeriod.getStatus()+"\" class=\"formElemen\">");
                rowx.add(activityPeriod.getStatus());
            } else {
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(activityPeriod.getOID()) + "')\">" + activityPeriod.getName() + "</a>");

                String str_dt_StartDate = "";
                try {
                    Date dt_StartDate = activityPeriod.getStartDate();
                    if (dt_StartDate == null) {
                        dt_StartDate = new Date();
                    }

                    str_dt_StartDate = JSPFormater.formatDate(dt_StartDate, "dd MMMM yyyy");
                } catch (Exception e) {
                    str_dt_StartDate = "";
                }
                rowx.add(str_dt_StartDate);

                String str_dt_EndDate = "";
                try {
                    Date dt_EndDate = activityPeriod.getEndDate();
                    if (dt_EndDate == null) {
                        dt_EndDate = new Date();
                    }

                    str_dt_EndDate = JSPFormater.formatDate(dt_EndDate, "dd MMMM yyyy");
                } catch (Exception e) {
                    str_dt_EndDate = "";
                }
                rowx.add(str_dt_EndDate);
                rowx.add(activityPeriod.getStatus());
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0)) {
            rowx.add("<input type=\"text\" name=\"" + frmObject.colNames[JspActivityPeriod.JSP_NAME] + "\" value=\"" + objEntity.getName() + "\" class=\"formElemen\">");
            //rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_START_DATE] +"\" value=\""+objEntity.getStartDate()+"\" class=\"formElemen\">");
            rowx.add(getDates(objEntity.getStartDate(), "frmactivityperiod", frmObject.colNames[JspActivityPeriod.JSP_START_DATE], approot));

            //rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_END_DATE] +"\" value=\""+objEntity.getEndDate()+"\" class=\"formElemen\">");
            rowx.add(getDates(objEntity.getEndDate(), "frmactivityperiod", frmObject.colNames[JspActivityPeriod.JSP_END_DATE], approot));
            //rowx.add("<input type=\"text\" name=\""+frmObject.colNames[JspActivityPeriod.JSP_STATUS] +"\" value=\""+objEntity.getStatus()+"\" class=\"formElemen\">");
            rowx.add("");

        }

        lstData.add(rowx);

        return cmdist.draw(index);
    }

    public String getDates(Date dt, String frmname, String strname, String approot) {
        String str = "<table width=\"15%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">" +
                "<tr>" +
                "<td width=\"14%\">" +
                "<input type=\"text\" name=\"" + strname + "\"  value=\"" + (JSPFormater.formatDate(dt, "dd/MM/yyyy")) + "\" class=\"formElemen\" size=\"15\" readOnly>" +
                "</td>" +
                "<td width=\"86%\"><a href=\"javascript:void(0)\" onClick=\"if(self.gfPop)gfPop.fPopCalendar(document." + frmname + "." + strname + ");return false;\" ><img class=\"PopcalTrigger\" align=\"absmiddle\" src=\"" + approot + "/calendar/calbtn.gif\" height=18 border=\"0\" alt=\"sob from\" width=\"24\"></a></td>" +
                "</tr>" +
                "</table>";
        return str;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidActivityPeriod = JSPRequestValue.requestLong(request, "hidden_activity_period_id");

            String periodName = JSPRequestValue.requestString(request, "period_name");
            Date startDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "start_date"), "dd/MM/yyyy");
            Date endDate = JSPFormater.formatDate(JSPRequestValue.requestString(request, "end_date"), "dd/MM/yyyy");
            int transModule = JSPRequestValue.requestInt(request, "trans_module");
            int transExpense = JSPRequestValue.requestInt(request, "trans_expense");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            CmdActivityPeriod ctrlActivityPeriod = new CmdActivityPeriod(request);
            JSPLine ctrLine = new JSPLine();
            Vector listActivityPeriod = new Vector(1, 1);

            String result = "";

            if (iJSPCommand == JSPCommand.SAVE) {
                ActivityPeriod ap = new ActivityPeriod();
                ap.setName(periodName);
                ap.setStartDate(startDate);
                ap.setEndDate(endDate);
                
                result = DbActivityPeriod.closePeriod(ap, transModule,null, transExpense,null);

            //ap.setStatus(I_Project);

            }

/* end switch*/
            JspActivityPeriod jspActivityPeriod = ctrlActivityPeriod.getForm();

            /*count list All ActivityPeriod*/
            int vectSize = DbActivityPeriod.getCount(whereClause);

            /*switch list ActivityPeriod*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlActivityPeriod.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            ActivityPeriod activityPeriod = ctrlActivityPeriod.getActivityPeriod();
            msgString = ctrlActivityPeriod.getMessage();

            /* get record to display */
            listActivityPeriod = DbActivityPeriod.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listActivityPeriod.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listActivityPeriod = DbActivityPeriod.list(start, recordToGet, whereClause, orderClause);
            }
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            <%if (!priv || !privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if (iJSPCommand == JSPCommand.SAVE && result.length() == 0) {%>
            window.location="activityperiod.jsp";
            <%}%>
            
            function cmdClose(){
                if(confirm('Are you sure to do this action ?\nthis action is undoable, all transaction in the previews period will be locked for update')){
                    alert('sorry, close period is under construction ...');
                }
            }
            
            function cmdAdd(){
                document.frmactivityperiod.hidden_activity_period_id.value="0";
                document.frmactivityperiod.command.value="<%=JSPCommand.ADD%>";
                document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdAsk(oidActivityPeriod){
                document.frmactivityperiod.hidden_activity_period_id.value=oidActivityPeriod;
                document.frmactivityperiod.command.value="<%=JSPCommand.ASK%>";
                document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdConfirmDelete(oidActivityPeriod){
                document.frmactivityperiod.hidden_activity_period_id.value=oidActivityPeriod;
                document.frmactivityperiod.command.value="<%=JSPCommand.DELETE%>";
                document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdSave(){
                document.frmactivityperiod.command.value="<%=JSPCommand.SAVE%>";
                document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
                document.frmactivityperiod.action="closeperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdEdit(oidActivityPeriod){
                document.frmactivityperiod.hidden_activity_period_id.value=oidActivityPeriod;
                document.frmactivityperiod.command.value="<%=JSPCommand.EDIT%>";
                document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdCancel(oidActivityPeriod){
                document.frmactivityperiod.hidden_activity_period_id.value=oidActivityPeriod;
                document.frmactivityperiod.command.value="<%=JSPCommand.EDIT%>";
                document.frmactivityperiod.prev_command.value="<%=prevJSPCommand%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdBack(){
                document.frmactivityperiod.command.value="<%=JSPCommand.BACK%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdListFirst(){
                document.frmactivityperiod.command.value="<%=JSPCommand.FIRST%>";
                document.frmactivityperiod.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdListPrev(){
                document.frmactivityperiod.command.value="<%=JSPCommand.PREV%>";
                document.frmactivityperiod.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdListNext(){
                document.frmactivityperiod.command.value="<%=JSPCommand.NEXT%>";
                document.frmactivityperiod.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            function cmdListLast(){
                document.frmactivityperiod.command.value="<%=JSPCommand.LAST%>";
                document.frmactivityperiod.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmactivityperiod.action="activityperiod.jsp";
                document.frmactivityperiod.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidActivityPeriod){
                document.frmimage.hidden_activity_period_id.value=oidActivityPeriod;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="activityperiod.jsp";
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
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif','../images/saveclose2.gif','../images/cancel2.gif')">
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
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Kegiatan</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Close Period</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmactivityperiod" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_activity_period_id" value="<%=oidActivityPeriod%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td class="container"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8"  colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="8" valign="middle" colspan="3"> 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            try {
                                                                                        %>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                                                                    <tr> 
                                                                                                        <td width="17%"><i><font color="#006600">Setup 
                                                                                                            new activity period</font></i> 
                                                                                                        </td>
                                                                                                        <td width="83%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="17%">Period Name</td>
                                                                                                        <td width="83%"> 
                                                                                                            <input type="text" name="period_name" value="<%=periodName%>" size="50">
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="17%">Start Date</td>
                                                                                                        <td width="83%"> 
                                                                                                            <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11">
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmactivityperiod.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="17%">End Date</td>
                                                                                                        <td width="83%"> 
                                                                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11">
                                                                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmactivityperiod.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <%if(false){%>
                                                                                                    <tr> 
                                                                                                        <td width="17%">Transfer Previous 
                                                                                                        Activity Data</td>
                                                                                                        <td width="83%"> 
                                                                                                            <input type="checkbox" name="trans_module" value="1" checked>
                                                                                                        Yes </td>
                                                                                                    </tr>
                                                                                                    <tr> 
                                                                                                        <td width="17%">Transfer Previous 
                                                                                                        Expense Budget</td>
                                                                                                        <td width="83%"> 
                                                                                                            <input type="checkbox" name="trans_expense" value="1" checked>
                                                                                                        Yes </td>
                                                                                                    </tr>
                                                                                                    <%}%>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <%
            } catch (Exception exc) {
            }%>
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="24" valign="middle" colspan="3">
                                                                                                <%if (result.length() > 0) {%>
                                                                                                <font color="#FF0000"><%=result%></font>
                                                                                            <%}%></td>
                                                                                        </tr>
                                                                                        
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="22" valign="middle" colspan="3"> 
                                                                                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                    <tr> 
                                                                                                        <td width="14%"><a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','../images/saveclose2.gif',1)"><img src="../images/saveclose.gif" name="new21" border="0"></a></td>
                                                                                                        <td width="85%"><a href="javascript:cmdBack()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new211','','../images/cancel2.gif',1)"><img src="../images/cancel.gif" name="new211" border="0" width="63" height="22"></a></td>
                                                                                                        <td width="1%">&nbsp;</td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                                <td height="8" colspan="2" width="83%"> </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top" > 
                                                                                <td colspan="3" class="command">&nbsp; </td>
                                                                            </tr>
                                                                    </table></td>
                                                                </tr>
                                                            </table>
                                                            
                                                        </form>
                                                        <!-- #EndEditable -->
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
