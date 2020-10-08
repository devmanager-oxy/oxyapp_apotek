
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.fms.activity.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.journal.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %>
<% int appObjCode = 1;%>
<%
            /* Check privilege except VIEW, view is already checked on checkuser.jsp as basic access*/
            boolean privView = true;
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%!
    public String drawList(int iJSPCommand, JspCoaActivity frmObject, CoaActivity objEntity, Vector objectClass, long coaActivityId, long oidDep, int iErrCode) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("50%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tablehdr");
        cmdist.setCellStyle("tablecell");
        //cmdist.setCellStyle("tablecell1");
        cmdist.setHeaderStyle("tablehdr");

        cmdist.addHeader("Department", "40%");
        cmdist.addHeader("Chart Of Account", "60%");
        //cmdist.addHeader("Module Id","50%");

        Vector deps = DbDepartment.list(0, 0, "", "");
        if (oidDep == 0) {
            if (deps != null && deps.size() > 0) {
                oidDep = ((Department) deps.get(0)).getOID();
            }
        }


        Vector coas = DbCoa.list(0, 0, "department_id=" + oidDep + " and account_group='" + I_Project.ACC_GROUP_EXPENSE + "' and status='" + I_Project.ACCOUNT_LEVEL_POSTABLE + "'", "code");

        System.out.println("deps : " + deps);
        System.out.println("coas : " + coas);

        cmdist.setLinkRow(0);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        Vector rowx = new Vector(1, 1);
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            CoaActivity coaActivity = (CoaActivity) objectClass.get(i);
            rowx = new Vector();
            if (coaActivityId == coaActivity.getOID()) {
                index = i;
            }

            if (index == i && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK)) {
                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(coaActivity.getCoaId());
                } catch (Exception e) {
                }
                rowx.add(getDepartment(deps, oidDep));//coa.getDepartmentId()));
                rowx.add(getCoa(coas, coaActivity.getCoaId(), frmObject.colNames[JspCoaActivity.JSP_COA_ID]));//"<input type=\"text\" name=\""+frmObject.colNames[JspCoaActivity.JSP_COA_ID] +"\" value=\""+coa.getName()+"\" class=\"formElemen\">");
            } else {
                Department de = new Department();
                try {
                    de = DbDepartment.fetchExc(coaActivity.getDepartmentId());
                } catch (Exception e) {
                }
                rowx.add("<a href=\"javascript:cmdEdit('" + String.valueOf(coaActivity.getOID()) + "')\">" + de.getName() + "</a>");
                Coa coa = new Coa();
                try {
                    coa = DbCoa.fetchExc(coaActivity.getCoaId());
                } catch (Exception e) {
                }
                rowx.add(coa.getName());
            //rowx.add(String.valueOf(coaActivity.getModuleId()));
            }

            lstData.add(rowx);
        }

        rowx = new Vector();

        if (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && iErrCode > 0)) {
            rowx.add(getDepartment(deps, oidDep));
            rowx.add(getCoa(coas, objEntity.getCoaId(), frmObject.colNames[JspCoaActivity.JSP_COA_ID]));//"<input type=\"text\" name=\""+frmObject.colNames[JspCoaActivity.JSP_COA_ID] +"\" value=\""+objEntity.getModuleId()+"\" class=\"formElemen\">");

        }

        lstData.add(rowx);

        return cmdist.draw(index);
    }

    public String getDepartment(Vector dep, long depOID) {
        String str = "<select name=\"" + JspCoaActivity.colNames[JspCoaActivity.JSP_DEPARTMENT_ID] + "\" onChange=\"javascript:cmdDepartment()\">";
        if (dep != null && dep.size() > 0) {
            for (int i = 0; i < dep.size(); i++) {
                Department d = (Department) dep.get(i);
                str = str + "<option value=\"" + d.getOID() + "\" ";
                if (d.getOID() == depOID) {
                    str = str + "selected";
                }
                str = str + ">" + d.getName() + "</option>";
            }
        }
        str = str + "</select>";
        return str;
    }

    public String getCoa(Vector coa, long coaId, String namex) {
        String str = "<select name=\"" + namex + "\">";
        if (coa != null && coa.size() > 0) {
            for (int i = 0; i < coa.size(); i++) {
                Coa c = (Coa) coa.get(i);
                String sx = "";
                /*switch(c.getLevel()){
                case 1 : 											
                break;
                case 2 : 
                sx = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
                case 3 :
                sx = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
                case 4 :
                sx = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;
                case 5 :
                sx = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                break;				
                }*/

                str = str + "<option value=\"" + c.getOID() + "\" " + ((c.getOID() == coaId) ? "selected" : "") + ">" + sx + c.getCode() + " - " + c.getName() + "</option>";
            }
        }
        str = str + "</select>";
        return str;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidCoaActivity = JSPRequestValue.requestLong(request, "hidden_coa_activity_id");
            long oidModule = JSPRequestValue.requestLong(request, "hidden_module_id");
            long oidDepartment = JSPRequestValue.requestLong(request, JspCoaActivity.colNames[JspCoaActivity.JSP_DEPARTMENT_ID]);



//out.println("oidModule : "+oidModule);
            Module module = new Module();
            try {
                module = DbModule.fetchExc(oidModule);
            } catch (Exception e) {
            }

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "module_id=" + oidModule;
            String orderClause = "";

//out.println("iJSPCommand : "+iJSPCommand);

            CmdCoaActivity ctrlCoaActivity = new CmdCoaActivity(request);
            JSPLine ctrLine = new JSPLine();
            Vector listCoaActivity = new Vector(1, 1);

            /*switch statement */
            iErrCode = ctrlCoaActivity.action(iJSPCommand, oidCoaActivity);
            /* end switch*/
            JspCoaActivity jspCoaActivity = ctrlCoaActivity.getForm();

            /*count list All CoaActivity*/
            int vectSize = DbCoaActivity.getCount(whereClause);

            /*switch list CoaActivity*/
            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = ctrlCoaActivity.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            CoaActivity coaActivity = ctrlCoaActivity.getCoaActivity();
            msgString = ctrlCoaActivity.getMessage();

            if (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.SUBMIT) {
                oidDepartment = coaActivity.getDepartmentId();
            //out.println("oidDepartment 1 : "+oidDepartment);	
            }

            /* get record to display */
            listCoaActivity = DbCoaActivity.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listCoaActivity.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listCoaActivity = DbCoaActivity.list(start, recordToGet, whereClause, orderClause);
            }

//out.println("oidDepartment : "+oidDepartment);
//out.println("oidCoaActivity : "+oidCoaActivity);

            if (iJSPCommand == JSPCommand.SUBMIT) {
                if (oidCoaActivity == 0) {
                    iJSPCommand = JSPCommand.ADD;
                } else {
                    iJSPCommand = JSPCommand.EDIT;
                }
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
            <!--
            
            
            
            <%if (!privView) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            function cmdDepartment(){
                document.frmcoaactivity.command.value="<%=JSPCommand.SUBMIT%>";
                document.frmcoaactivity.submit();
            }
            
            function cmdActivity(){
                document.frmcoaactivity.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoaactivity.action="moduledt.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdActPerBudget(){
                document.frmcoaactivity.command.value="<%=JSPCommand.LIST%>";
                document.frmcoaactivity.action="activityperiodbudget.jsp";
                document.frmcoaactivity.submit();
                
            }
            
            function cmdAdd(){
                document.frmcoaactivity.hidden_coa_activity_id.value="0";
                document.frmcoaactivity.command.value="<%=JSPCommand.ADD%>";
                document.frmcoaactivity.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdAsk(oidCoaActivity){
                document.frmcoaactivity.hidden_coa_activity_id.value=oidCoaActivity;
                document.frmcoaactivity.command.value="<%=JSPCommand.ASK%>";
                document.frmcoaactivity.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdConfirmDelete(oidCoaActivity){
                document.frmcoaactivity.hidden_coa_activity_id.value=oidCoaActivity;
                document.frmcoaactivity.command.value="<%=JSPCommand.DELETE%>";
                document.frmcoaactivity.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdSave(){
                document.frmcoaactivity.command.value="<%=JSPCommand.SAVE%>";
                document.frmcoaactivity.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdEdit(oidCoaActivity){
                document.frmcoaactivity.hidden_coa_activity_id.value=oidCoaActivity;
                document.frmcoaactivity.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoaactivity.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdCancel(oidCoaActivity){
                document.frmcoaactivity.hidden_coa_activity_id.value=oidCoaActivity;
                document.frmcoaactivity.command.value="<%=JSPCommand.EDIT%>";
                document.frmcoaactivity.prev_command.value="<%=prevJSPCommand%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdBack(){
                document.frmcoaactivity.command.value="<%=JSPCommand.BACK%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdListFirst(){
                document.frmcoaactivity.command.value="<%=JSPCommand.FIRST%>";
                document.frmcoaactivity.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdListPrev(){
                document.frmcoaactivity.command.value="<%=JSPCommand.PREV%>";
                document.frmcoaactivity.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdListNext(){
                document.frmcoaactivity.command.value="<%=JSPCommand.NEXT%>";
                document.frmcoaactivity.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            function cmdListLast(){
                document.frmcoaactivity.command.value="<%=JSPCommand.LAST%>";
                document.frmcoaactivity.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmcoaactivity.action="coaactivity.jsp";
                document.frmcoaactivity.submit();
            }
            
            //-------------- script form image -------------------
            
            function cmdDelPict(oidCoaActivity){
                document.frmimage.hidden_coa_activity_id.value=oidCoaActivity;
                document.frmimage.command.value="<%=JSPCommand.POST%>";
                document.frmimage.action="coaactivity.jsp";
                document.frmimage.submit();
            }
            
            //-------------- script control line -------------------
            //-->
        </script>
        
        <!-- #EndEditable -->
    </head>
    <body onLoad="MM_preloadImages('<%=approot%>/images/home2.gif','<%=approot%>/images/logout2.gif')">
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
              <!-- #EndEditable -->
                                        </td>
                                        <td width="100%" valign="top"> 
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr> 
                                                    <td class="title"><!-- #BeginEditable "title" -->
                                           <%
            String navigator = "<font class=\"lvl1\">Activity</font><font class=\"tit1\">&nbsp;&raquo;&nbsp;<span class=\"lvl2\">Account Link</span></font>";
                                           %>
                                           <%@ include file="../main/navigator.jsp"%>
                                                    <!-- #EndEditable --></td>
                                                </tr>
                                                <!--tr> 
                      <td><img src="<%=approot%>/images/title-sp.gif" width="584" height="1"></td> 
                                                </tr-->
                                                <tr> 
                                                    <td><!-- #BeginEditable "content" --> 
                                                        <form name="frmcoaactivity" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_coa_activity_id" value="<%=oidCoaActivity%>">
                                                            <input type="hidden" name="hidden_module_id" value="<%=oidModule%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <input type="hidden" name="<%=JspCoaActivity.colNames[JspCoaActivity.JSP_MODULE_ID]%>" value="<%=oidModule%>">
                                                            
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8"  colspan="3"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="top" colspan="3"> 
                                                                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                        <tr> 
                                                                                            <td height="8"></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="16"><b><u>Data Maintenance > Activity 
                                                                                            > Account List</u></b></td>
                                                                                        </tr>
                                                                                        <tr> 
                                                                                            <td height="16"> 
                                                                                                <table width="57%" border="0" cellpadding="1" height="20" cellspacing="1">
                                                                                                    <tr> 
                                                                                                        <td width="17%" bgcolor="#CCCCCC" onClick=""> 
                                                                                                            <div align="center"><a href="javascript:cmdActivity()"><font color="#666666">ACTIVITY</font></a></div>
                                                                                                        </td>
                                                                                                        <td width="18%" bgcolor="#666666" onClick=""> 
                                                                                                            <div align="center"> <font color="#666666"><b><font color="#FFFFFF">ACCOUNT 
                                                                                                            LIST</font></b></font></div>
                                                                                                        </td>
                                                                                                        <td width="31%" bgcolor="#CCCCCC"> 
                                                                                                            <div align="center"><a href="javascript:cmdActPerBudget()"><font color="#666666">ACTIVITY 
                                                                                                            PERIOD &amp; BUDGETING</font></a> </div>
                                                                                                        </td>
                                                                                                        <td width="34%" bgcolor="#CCCCCC"> 
                                                                                                            <div align="center"><font color="#666666">DONOR 
                                                                                                            COMPONENTS &amp; BUDGETING</font> </div>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                </table>
                                                                                            </td>
                                                                                        </tr>
                                                                                    </table>
                                                                                </td>
                                                                            </tr>
                                                                            <tr align="left" valign="top">
                                                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;</td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="14" valign="middle" colspan="3" class="comment">&nbsp;<b><%=module.getCode() + " - " + module.getDescription()%></b></td>
                                                                            </tr>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="5" valign="middle" colspan="3" class="comment"></td>
                                                                            </tr>
                                                                            <%
            try {
                                                                            %>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3"> <%= drawList(iJSPCommand, jspCoaActivity, coaActivity, listCoaActivity, oidCoaActivity, oidDepartment, iErrCode)%> </td>
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
                                                                            <%if (iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ASK && iErrCode == 0) {%>
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="22" valign="middle" colspan="3">&nbsp;<a href="javascript:cmdAdd()" class="command"><u>Add 
                                                                                New</u></a></td>
                                                                            </tr>
                                                                            <%}%>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top"> 
                                                                    <td height="8" valign="middle" width="17%">&nbsp;</td>
                                                                    <td height="8" colspan="2" width="83%">&nbsp; </td>
                                                                </tr>
                                                                <tr align="left" valign="top" > 
                                                                    <td colspan="3" class="command"> 
                                                                        <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("50%");
            String scomDel = "javascript:cmdAsk('" + oidCoaActivity + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidCoaActivity + "')";
            String scancel = "javascript:cmdEdit('" + oidCoaActivity + "')";
            ctrLine.setBackCaption("Back to List");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("Delete");

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
                                                                        <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE) && (iErrCode != 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                                        <%= ctrLine.drawImage(iJSPCommand, iErrCode, msgString)%>
                                                                    <%}%> </td>
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
