
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
            boolean useGereja = DbModule.getModSysPropGereja();


%>
<!-- Jsp Block -->
<%!
    public String drawList(Vector objectClass, long moduleId) {
        JSPList cmdist = new JSPList();
        cmdist.setAreaWidth("100%");
        cmdist.setListStyle("listgen");
        cmdist.setTitleStyle("tableheader");
        cmdist.setCellStyle("cellStyle");
        cmdist.setHeaderStyle("tableheader");
        cmdist.addHeader("Parent Id", "11%");
        cmdist.addHeader("Code", "11%");
        cmdist.addHeader("Level", "11%");
        cmdist.addHeader("Description", "11%");
        cmdist.addHeader("Output Deliver", "11%");
        cmdist.addHeader("Perform Indicator", "11%");
        cmdist.addHeader("Assum Risk", "11%");
        cmdist.addHeader("Status", "11%");
        cmdist.addHeader("Type", "11%");

        cmdist.setLinkRow(0);
        cmdist.setLinkSufix("");
        Vector lstData = cmdist.getData();
        Vector lstLinkData = cmdist.getLinkData();
        cmdist.setLinkPrefix("javascript:cmdEdit('");
        cmdist.setLinkSufix("')");
        cmdist.reset();
        int index = -1;

        for (int i = 0; i < objectClass.size(); i++) {
            Module module = (Module) objectClass.get(i);
            Vector rowx = new Vector();
            if (moduleId == module.getOID()) {
                index = i;
            }

            rowx.add(String.valueOf(module.getParentId()));

            rowx.add(module.getCode());

            rowx.add(module.getLevel());

            rowx.add(module.getDescription());

            rowx.add(module.getOutputDeliver());

            rowx.add(module.getPerformIndicator());

            rowx.add(module.getAssumRisk());

            rowx.add(module.getStatus());

            rowx.add(module.getType());

            lstData.add(rowx);
            lstLinkData.add(String.valueOf(module.getOID()));
        }

        return cmdist.drawList(index);
    }

    public String getSubstring(String s) {
        if (s.length() > 65) {
            s = s.substring(0, 65) + "...";
        }
        return s;
    }

%>
<%
            int iJSPCommand = JSPRequestValue.requestCommand(request);
            int start = JSPRequestValue.requestInt(request, "start");
            int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
            long oidModule = JSPRequestValue.requestLong(request, "hidden_module_id");

            /*variable declaration*/
            int recordToGet = 10;
            String msgString = "";
            int iErrCode = JSPMessage.NONE;
            String whereClause = "";
            String orderClause = "";

            ActivityPeriod apOpen = DbActivityPeriod.getOpenPeriod();

            CmdModule cmdModule = new CmdModule(request);
            JSPLine ctrLine = new JSPLine();
            Vector listModule = new Vector(1, 1);

            /*switch statement */
            iErrCode = cmdModule.action(iJSPCommand, oidModule);
            /* end switch*/
            JspModule jspModule = cmdModule.getForm();

            /*count list All Module*/
            int vectSize = DbModule.getCount(whereClause);

            Module module = cmdModule.getModule();
            msgString = cmdModule.getMessage();


            if ((iJSPCommand == JSPCommand.FIRST || iJSPCommand == JSPCommand.PREV) ||
                    (iJSPCommand == JSPCommand.NEXT || iJSPCommand == JSPCommand.LAST)) {
                start = cmdModule.actionList(iJSPCommand, start, vectSize, recordToGet);
            }
            /* end switch list*/

            /* get record to display */
            listModule = DbModule.list(start, recordToGet, whereClause, orderClause);

            /*handle condition if size of record to display = 0 and start > 0 	after delete*/
            if (listModule.size() < 1 && start > 0) {
                if (vectSize - recordToGet > recordToGet) {
                    start = start - recordToGet;
                } //go to JSPCommand.PREV
                else {
                    start = 0;
                    iJSPCommand = JSPCommand.FIRST;
                    prevJSPCommand = JSPCommand.FIRST; //go to JSPCommand.FIRST
                }
                listModule = DbModule.list(start, recordToGet, whereClause, orderClause);
            }
            
            String[] langMD = {"Period", "Location", "Kind of Activity", "Kin", "Date",
                "Time", "Memo", "Budget"
            };
            String[] langNav = {"Activity", "Activity List"};

            if (lang == LANG_ID) {
                String[] langID = {"Tahun Anggaran", "Lokasi", "Jenis Kegiatan", "Hari", "Tanggal",
                    "Waktu", "Keterangan", "Anggaran"
                };
                langMD = langID;
                String[] navID = {"Kegiatan", "Data Kerja"};
                langNav = navID;
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
            <%if (!priv || !privView || !privUpdate) {%>
            window.location="<%=approot%>/nopriv.jsp";
            <%}%>
            
            <%if ((iJSPCommand == JSPCommand.DELETE) && iErrCode == 0) {%>
            <%if (useGereja) {%>
            window.location="moduleg.jsp";
            <%} else {%>
            window.location="module.jsp";
            <%}%>            
            <%}%>
            
            function cmdAdd(){
                document.frmmodule.hidden_module_id.value="0";
                document.frmmodule.command.value="<%=JSPCommand.ADD%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdActPerBudget(){
                document.frmmodule.command.value="<%=JSPCommand.LIST%>";
                document.frmmodule.action="activityperiodbudget.jsp";
                document.frmmodule.submit();
            }
            
            
            function cmdAsk(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.ASK%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdConfirmDelete(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.DELETE%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            function cmdSave(){
                document.frmmodule.command.value="<%=JSPCommand.SAVE%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdEdit(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdCancel(oidModule){
                document.frmmodule.hidden_module_id.value=oidModule;
                document.frmmodule.command.value="<%=JSPCommand.EDIT%>";
                document.frmmodule.prev_command.value="<%=prevJSPCommand%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdBack(){
                document.frmmodule.command.value="<%=JSPCommand.BACK%>";
                <%if (useGereja) {%>
                document.frmmodule.action="moduleg.jsp";
                <%} else {%>
                document.frmmodule.action="module.jsp";
                <%}%>
                document.frmmodule.submit();
            }
            
            function cmdListFirst(){
                document.frmmodule.command.value="<%=JSPCommand.FIRST%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.FIRST%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListPrev(){
                document.frmmodule.command.value="<%=JSPCommand.PREV%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.PREV%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListNext(){
                document.frmmodule.command.value="<%=JSPCommand.NEXT%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.NEXT%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdListLast(){
                document.frmmodule.command.value="<%=JSPCommand.LAST%>";
                document.frmmodule.prev_command.value="<%=JSPCommand.LAST%>";
                document.frmmodule.action="moduledt.jsp";
                document.frmmodule.submit();
            }
            
            function cmdChangeLevel(){
                var lvcode = document.frmmodule.<%=jspModule.colNames[JspModule.JSP_LEVEL]%>.value;
                //alert(lvcode);
                if(lvcode=='A' || lvcode=='SA' || lvcode=='SSA'){
                    //alert('xxx');
                    document.all.postheader.style.display="none";
                    document.all.postpostable.style.display="";
                }
                else{
                    //alert('yy');
                    document.all.postheader.style.display="";
                    document.all.postpostable.style.display="none";
                }
                
                if(lvcode=='M'){
                    document.all.parent.style.display="";
                    document.all.parentM.style.display="none";
                    document.all.parentS.style.display="none";
                    document.all.parentSH.style.display="none";
                    document.all.parentA.style.display="none";
                    document.all.parentSA.style.display="none";
                }
                else if(lvcode=='S'){
                    document.all.parent.style.display="none";
                    document.all.parentM.style.display="";
                    document.all.parentS.style.display="none";
                    document.all.parentSH.style.display="none";
                    document.all.parentA.style.display="none";
                    document.all.parentSA.style.display="none";
                }
                else if(lvcode=='H'){
                    document.all.parent.style.display="none";
                    document.all.parentM.style.display="none";
                    document.all.parentS.style.display="";
                    document.all.parentSH.style.display="none";
                    document.all.parentA.style.display="none";
                    document.all.parentSA.style.display="none";
                }
                else if(lvcode=='A'){	
                    document.all.parent.style.display="none";
                    document.all.parentM.style.display="none";
                    document.all.parentS.style.display="none";
                    document.all.parentSH.style.display="";
                    document.all.parentA.style.display="none";
                    document.all.parentSA.style.display="none";
                }
                else if(lvcode=='SA'){	
                    document.all.parent.style.display="none";
                    document.all.parentM.style.display="none";
                    document.all.parentS.style.display="none";
                    document.all.parentSH.style.display="none";
                    document.all.parentA.style.display="";
                    document.all.parentSA.style.display="none";
                }
                else if(lvcode=='SSA'){	
                    document.all.parent.style.display="none";
                    document.all.parentM.style.display="none";
                    document.all.parentS.style.display="none";
                    document.all.parentSH.style.display="none";
                    document.all.parentA.style.display="none";
                    document.all.parentSA.style.display="";
                }
                
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
                                   <%@ include file="../calendar/calendarframe.jsp"%>
                                            <!-- #EndEditable -->
                                        </td>
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
                                                        <form name="frmmodule" method ="post" action="">
                                                            <input type="hidden" name="command" value="<%=iJSPCommand%>">
                                                            <input type="hidden" name="vectSize" value="<%=vectSize%>">
                                                            <input type="hidden" name="start" value="<%=start%>">
                                                            <input type="hidden" name="prev_command" value="<%=prevJSPCommand%>">
                                                            <input type="hidden" name="hidden_module_id" value="<%=oidModule%>">
                                                            <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                <tr> 
                                                                    <td class="container"> 
                                                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                            <tr align="left" valign="top"> 
                                                                                <td height="8" valign="middle" colspan="3" class="page"> 
                                                                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                                                                        <tr align="left" valign="top"> 
                                                                                            <td height="6" valign="middle" colspan="3"></td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" colspan="3"> 
                                                                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                                                                <tr> 
                                                                                                    <td width="20%" valign="top"> 
                                                                                                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                                                                            <tr > 
                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="17" height="10"></td>
                                                                                                                <td class="tabin"> 
                                                                                                                    <%if (useGereja) {%>
                                                                                                                    <div align="center">&nbsp;&nbsp;<a href="moduleg.jsp?menu_idx=<%=menuIdx%>" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                                                    <%} else {%>
                                                                                                                    <div align="center">&nbsp;&nbsp;<a href="module.jsp?menu_idx=<%=menuIdx%>" class="tablink">Records</a>&nbsp;&nbsp;</div>
                                                                                                                    <%}%>
                                                                                                                </td>
                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                <td class="tab"> 
                                                                                                                    <div align="center">&nbsp;&nbsp;Editor&nbsp;&nbsp;</div>
                                                                                                                </td>
                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                <td class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="3" height="10"></td>
                                                                                                                <td width="100%" class="tabheader"><img src="<%=approot%>/images/spacer.gif" width="10" height="10"></td>
                                                                                                            </tr>
                                                                                                        </table>
                                                                                                    </td>
                                                                                                </tr>
                                                                                            </table>
                                                                                        </td>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;</td>
                                                                                        <td height="21" colspan="2" width="88%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <%if (useGereja) {%>
                                                                                        <%  
                                                                                        
                                                                                        Vector listSegment = new Vector();
                                                                                        
                                                                                        listSegment = DbSegment.listAll();
                                                                                        
                                                                                        if(listSegment != null && listSegment.size()>0){
                                                                                            for(int xSeg = 0 ; xSeg < listSegment.size() ; xSeg++){
                                                                                                Segment objSegment = (Segment)listSegment.get(xSeg);
                                                                                        %>


                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;<%=objSegment.getName() %></td>
                                                                                        <% 
                                                                                        Vector SegmentDet = new Vector();   
                                                                                        SegmentDet = DbSegmentDetail.listAll();
                                                                                        %>
                                                                                        <td height="21" colspan="2" width="88%">&nbsp;</td> 
                                                                                        </tr>
                                                                                        <%
                                                                                        }
                                                                                        }
                                                                                        }
                                                                                        %>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Activity 
                                                                                        Period </td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <%
            Vector actPeriods = DbActivityPeriod.list(0, 0, "", "");
                                                                                        %>
                                                                                        <select name="<%=jspModule.colNames[JspModule.JSP_ACTIVITY_PERIOD_ID] %>">
                                                                                            <%if (actPeriods != null && actPeriods.size() > 0) {
                for (int i = 0; i < actPeriods.size(); i++) {
                    ActivityPeriod ap = (ActivityPeriod) actPeriods.get(i);
                    if (ap.getOID() == apOpen.getOID()) {
                                                                                            %>
                                                                                            <option value="<%=ap.getOID()%>" <%if (ap.getOID() == module.getActivityPeriodId()) {%>selected<%}%>><%=ap.getName()%></option>
                                                                                            <%}
                }
            }%>
                                                                                        </select>                                                                                        
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Initial</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspModule.colNames[JspModule.JSP_INITIAL] %>"  value="<%= module.getInitial() %>" class="formElemen" size="15">
                                                                                        * <%= jspModule.getErrorMsg(JspModule.JSP_CODE) %> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Code</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspModule.colNames[JspModule.JSP_CODE] %>"  value="<%= module.getCode() %>" class="formElemen" size="15">
                                                                                        * <%= jspModule.getErrorMsg(JspModule.JSP_CODE) %> 
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Description</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <input type="text" name="<%=jspModule.colNames[JspModule.JSP_DESCRIPTION] %>" class="formElemen" size="100" value="<%= module.getDescription() %>">
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Output 
                                                                                        and Deliverable</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_OUTPUT_DELIVER] %>" class="formElemen" cols="100" rows="2"><%= module.getOutputDeliver() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Performance 
                                                                                        Indicator</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_PERFORM_INDICATOR] %>" class="formElemen" cols="100" rows="2"><%= module.getPerformIndicator() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Assumtion 
                                                                                        and Risk</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_ASSUM_RISK] %>" class="formElemen" cols="100" rows="2"><%= module.getAssumRisk() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Cost 
                                                                                        Implication</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <textarea name="<%=jspModule.colNames[JspModule.JSP_COST_IMPLICATION]%>" class="formElemen" cols="100" rows="2"><%= module.getCostImplication() %></textarea>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Level</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <% Vector level_value = new Vector(1, 1);
            Vector level_key = new Vector(1, 1);
            String sel_level = "" + module.getLevel();
            for (int i = 0; i < I_Project.strActivities.length; i++) {
                level_key.add(I_Project.strActivities[i]);
                level_value.add(I_Project.strActivities[i]);
            }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_LEVEL], null, sel_level, level_key, level_value, "onChange=\"javascript:cmdChangeLevel()\"", "formElemen") %> * <%= jspModule.getErrorMsg(JspModule.JSP_LEVEL) %> 
                                                                                        <tr id="parent"> 
                                                                                        <td height="21" width="12%">&nbsp;Parent 
                                                                                        </td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <% Vector parentid_value = new Vector(1, 1);
            Vector parentid_key = new Vector(1, 1);
            String sel_parentid = "" + module.getParentId();
            parentid_key.add("0");
            parentid_value.add("-");

                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_PARENT_ID], null, sel_parentid, parentid_key, parentid_value, "", "formElemen") %> 
                                                                                        <tr id="parentM"> 
                                                                                        <td height="21" width="12%">&nbsp;Parent</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <%
            String wherex = "level='M' and activity_period_id=" + apOpen.getOID();
            Vector hdr = DbModule.list(0, 0, wherex, "code");
            parentid_key = new Vector(1, 1);
            parentid_value = new Vector(1, 1);
            if (hdr != null && hdr.size() > 0) {
                for (int i = 0; i < hdr.size(); i++) {
                    Module m = (Module) hdr.get(i);
                    parentid_key.add("" + m.getOID());
                    parentid_value.add("" + m.getCode() + " - " + getSubstring(m.getDescription()));
                }
            }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_PARENT_ID_M], null, sel_parentid, parentid_key, parentid_value, "", "formElemen") %> 
                                                                                        <tr id="parentS"> 
                                                                                        <td height="21" width="12%">&nbsp;Parent</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <%
            wherex = "level='S' and activity_period_id=" + apOpen.getOID();

            //out.println(wherex);

            hdr = new Vector(1, 1);
            hdr = DbModule.list(0, 0, wherex, "code");
            parentid_key = new Vector(1, 1);
            parentid_value = new Vector(1, 1);
            if (hdr != null && hdr.size() > 0) {
                for (int i = 0; i < hdr.size(); i++) {
                    Module m = (Module) hdr.get(i);
                    parentid_key.add("" + m.getOID());
                    parentid_value.add("" + m.getCode() + " - " + getSubstring(m.getDescription()));
                }
            }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_PARENT_ID_S], null, sel_parentid, parentid_key, parentid_value, "", "formElemen") %> 
                                                                                        <tr id="parentSH"> 
                                                                                        <td height="21" width="12%">&nbsp;Parent</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <%
            wherex = "(level='S' or level='H') and activity_period_id=" + apOpen.getOID();
            //out.println(wherex);
            hdr = new Vector(1, 1);
            hdr = DbModule.list(0, 0, wherex, "code");
            parentid_key = new Vector(1, 1);
            parentid_value = new Vector(1, 1);
            if (hdr != null && hdr.size() > 0) {
                for (int i = 0; i < hdr.size(); i++) {
                    Module m = (Module) hdr.get(i);
                    String str = "";
                    if (m.getLevel().equals("H")) {
                        str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    }
                    parentid_key.add("" + m.getOID());
                    parentid_value.add(str + "" + m.getCode() + " - " + getSubstring(m.getDescription()));
                }
            }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_PARENT_ID_SH], null, sel_parentid, parentid_key, parentid_value, "", "formElemen") %> 
                                                                                        <tr id="parentA"> 
                                                                                        <td height="21" width="12%">&nbsp;Parent</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <%
            wherex = "level='A' and activity_period_id=" + apOpen.getOID();
            hdr = new Vector(1, 1);
            hdr = DbModule.list(0, 0, wherex, "code");
            parentid_key = new Vector(1, 1);
            parentid_value = new Vector(1, 1);
            if (hdr != null && hdr.size() > 0) {
                for (int i = 0; i < hdr.size(); i++) {
                    Module m = (Module) hdr.get(i);
                    parentid_key.add("" + m.getOID());
                    parentid_value.add("" + m.getCode() + " - " + getSubstring(m.getDescription()));
                }
            }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_PARENT_ID_A], null, sel_parentid, parentid_key, parentid_value, "", "formElemen") %> 
                                                                                        <tr id="parentSA"> 
                                                                                        <td height="21" width="12%">&nbsp;Parent</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <%
            wherex = "level='SA' and activity_period_id=" + apOpen.getOID();
            hdr = new Vector(1, 1);
            hdr = DbModule.list(0, 0, wherex, "code");
            parentid_key = new Vector(1, 1);
            parentid_value = new Vector(1, 1);
            if (hdr != null && hdr.size() > 0) {
                for (int i = 0; i < hdr.size(); i++) {
                    Module m = (Module) hdr.get(i);
                    parentid_key.add("" + m.getOID());
                    parentid_value.add("" + m.getCode() + " - " + getSubstring(m.getDescription()));
                }
            }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_PARENT_ID_SA], null, sel_parentid, parentid_key, parentid_value, "", "formElemen") %> 
                                                                                        
                                                                                        <tr id="postheader"> 
                                                                                            <td height="27" width="12%">&nbsp;Postable</td>
                                                                                            <td height="27" colspan="2" width="88%"> 
                                                                                            <input type="text" name="<%=jspModule.colNames[JspModule.JSP_POSITION_LEVEL]%>" value="<%=I_Project.ACCOUNT_LEVEL_HEADER%>" size="15" readOnly>
                                                                                        </tr>
                                                                                        <tr  id="postpostable"> 
                                                                                            <td height="21" width="12%">&nbsp;Postable</td>
                                                                                            <td height="21" colspan="2" width="88%"> 
                                                                                            <input type="text" name="<%=jspModule.colNames[JspModule.JSP_STATUS_POST]%>" value="<%=I_Project.ACCOUNT_LEVEL_POSTABLE%>" size="15" readOnly>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                        <td height="21" width="12%">&nbsp;Type</td>
                                                                                        <td height="21" colspan="2" width="88%"> 
                                                                                        <% Vector type_value = new Vector(1, 1);
            Vector type_key = new Vector(1, 1);

            String sel_type = "" + module.getType();
            for (int i = 0; i < I_Project.actTypes.length; i++) {
                type_key.add(I_Project.actTypes[i]);
                type_value.add(I_Project.actTypes[i]);
            }
                                                                                        %>
                                                                                        <%= JSPCombo.draw(jspModule.colNames[JspModule.JSP_TYPE], null, sel_type, type_key, type_value, "", "formElemen") %> 
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="88%" valign="top">&nbsp; 
                                                                                            </td>
                                                                                        </tr>
                                                                                        <!--tr align="left"> 
                                          <td height="8" valign="middle" width="12%">&nbsp;Expired 
                                            Date </td>
                                          <td height="8" colspan="2" width="88%" valign="top"> 
                                            <input name="<%=jspModule.colNames[jspModule.JSP_EXPIRED_DATE] %>" value="<%=JSPFormater.formatDate((module.getExpiredDate() == null) ? new Date() : module.getExpiredDate(), "dd/MM/yyyy")%>" size="11">
                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmmodule.<%=jspModule.colNames[jspModule.JSP_EXPIRED_DATE] %>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=approot%>/calendar/calbtn.gif" height="19" border="0" alt=""></a> 
                                          </td>
                                                                                   
                                                                                        </tr-->
                                                                                        <tr align="left">  
                                                                                            <td height="8" valign="middle" width="12%">&nbsp;Status</td>
                                                                                            <td height="8" colspan="2" width="88%" valign="top"> 
                                                                                                <select name="<%=jspModule.colNames[JspModule.JSP_STATUS]%>">
                                                                                                    <%for (int i = 0; i < I_Project.statusArray1.length; i++) {%>
                                                                                                    <option value="<%=I_Project.statusArray1[i]%>" <%if ((I_Project.statusArray1[i]).equals(module.getStatus())) {%>selected<%}%>><%=I_Project.statusArray1[i]%></option>
                                                                                                    <%}%>
                                                                                                </select>
                                                                                            </td>
                                                                                        </tr>
                                                                                        <tr align="left"> 
                                                                                            <td height="8" valign="middle" width="12%">&nbsp;</td>
                                                                                            <td height="8" colspan="2" width="88%" valign="top">&nbsp;</td>
                                                                                        </tr>
                                                                                        <tr align="left" > 
                                                                                            <td colspan="3" class="command" valign="top"> 
                                                                                                <%
            ctrLine.setLocationImg(approot + "/images/ctr_line");
            ctrLine.initDefault();
            ctrLine.setTableWidth("50%");
            String scomDel = "javascript:cmdAsk('" + oidModule + "')";
            String sconDelCom = "javascript:cmdConfirmDelete('" + oidModule + "')";
            String scancel = "javascript:cmdEdit('" + oidModule + "')";
            ctrLine.setBackCaption("Go To Records");
            ctrLine.setJSPCommandStyle("buttonlink");
            ctrLine.setDeleteCaption("Delete");
            ctrLine.setSaveCaption("Save");

            if (apOpen.getOID() != module.getActivityPeriodId() && module.getOID() != 0) {
                ctrLine.setDeleteCaption("");
                ctrLine.setSaveCaption("");
            }

            ctrLine.setAddCaption("Add New");

            if (privDelete) {
                ctrLine.setConfirmDelJSPCommand(sconDelCom);
                ctrLine.setDeleteJSPCommand(scomDel);
                ctrLine.setEditJSPCommand(scancel);
            } else {
                ctrLine.setConfirmDelCaption("");
                ctrLine.setDeleteCaption("");
                ctrLine.setEditCaption("");
            }

            ctrLine.setOnMouseOut("MM_swapImgRestore()");
            ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + approot + "/images/save2.gif',1)");
            ctrLine.setSaveImage("<img src=\"" + approot + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

            ctrLine.setOnMouseOverAddNew("MM_swapImage('add','','" + approot + "/images/new2.gif',1)");
            ctrLine.setAddNewImage("<img src=\"" + approot + "/images/new.gif\" name=\"add\" height=\"22\" border=\"0\">");

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

            if (privAdd == false && privUpdate == false) {
                ctrLine.setSaveCaption("");
            }

            if (privAdd == false) {
                ctrLine.setAddCaption("");
            }

            //out.println("iCommand  : "+iJSPCommand);
            //out.println("iErrCode  : "+iErrCode);
            //out.println("msgString  : "+msgString);

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
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </form>
                                                        <script language="JavaScript">
                                                            cmdChangeLevel();
                                                        </script>
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
